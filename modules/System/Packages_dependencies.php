<?php
/**
 * @package    CleverStyle Framework
 * @subpackage System module
 * @category   modules
 * @author     Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright  Copyright (c) 2015-2016, Nazar Mokrynskyi
 * @license    MIT License, see license.txt
 */
namespace cs\modules\System;
use
	cs\Config,
	cs\Config\Module_Properties,
	cs\Core;

/**
 * Utility functions, necessary for determining package's dependencies and which packages depend on it
 */
class Packages_dependencies {
	/**
	 * Check dependencies for new component (during installation/updating/enabling)
	 *
	 * @param array $meta   `meta.json` contents of target component
	 * @param bool  $update Is this for updating component to newer version (`$meta` will correspond to the version that components is going to be updated to)
	 *
	 * @return array
	 */
	public static function get_dependencies ($meta, $update = false) {
		/**
		 * No `meta.json` - nothing to check, allow it
		 */
		if (!$meta) {
			return [];
		}
		$meta         = self::normalize_meta($meta);
		$Config       = Config::instance();
		$dependencies = [
			'provide'  => [],
			'require'  => [],
			'conflict' => []
		];
		/**
		 * Check for compatibility with modules
		 */
		foreach (array_keys($Config->components['modules']) as $module) {
			/**
			 * If module uninstalled - we do not care about it
			 */
			if ($Config->module($module)->uninstalled()) {
				continue;
			}
			/**
			 * Stub for the case if there is no `meta.json`
			 */
			$module_meta = [
				'package'  => $module,
				'category' => 'modules',
				'version'  => 0
			];
			if (file_exists(MODULES."/$module/meta.json")) {
				$module_meta = file_get_json(MODULES."/$module/meta.json");
			}
			self::common_checks($dependencies, $meta, $module_meta, $update);
		}
		unset($module, $module_meta);
		/**
		 * If some required packages still missing
		 */
		foreach ($meta['require'] as $package => $details) {
			$dependencies['require'][] = [
				'package'  => $package,
				'required' => $details
			];
		}
		unset($package, $details);
		if (!self::check_dependencies_db($meta['db_support'])) {
			$dependencies['db_support'] = $meta['db_support'];
		}
		if (!self::check_dependencies_storage($meta['storage_support'])) {
			$dependencies['storage_support'] = $meta['storage_support'];
		}
		return array_filter($dependencies);
	}
	/**
	 * @param array $dependencies
	 * @param array $meta
	 * @param array $component_meta
	 * @param bool  $update
	 */
	protected static function common_checks (&$dependencies, &$meta, $component_meta, $update) {
		$component_meta = self::normalize_meta($component_meta);
		$package        = $component_meta['package'];
		/**
		 * Do not compare component with itself
		 */
		if (self::check_dependencies_are_the_same($meta, $component_meta)) {
			if (version_compare($meta['version'], $component_meta['version'], '<')) {
				$dependencies['update_older'] = [
					'from' => $component_meta['version'],
					'to'   => $meta['version']
				];
				return;
			} elseif ($update && $meta['version'] == $component_meta['version']) {
				$dependencies['update_same'] = $meta['version'];
				return;
			}
			/**
			 * If update is supported - check whether update is possible from current version
			 */
			if (
				isset($meta['update_from_version']) &&
				version_compare($meta['update_from_version'], $component_meta['version'], '>')
			) {
				$dependencies['update_from'] = [
					'from'            => $component_meta['version'],
					'to'              => $meta['version'],
					'can_update_from' => $meta['update_from_version']
				];
			}
			return;
		}
		/**
		 * If component already provides the same functionality
		 */
		if ($already_provided = self::also_provided_by($meta, $component_meta)) {
			$dependencies['provide'][] = [
				'package'  => $package,
				'features' => $already_provided
			];
		}
		/**
		 * Check if component is required and satisfies requirement condition
		 */
		if ($dependencies_conflicts = self::check_requirement($meta, $component_meta)) {
			array_push($dependencies['require'], ...$dependencies_conflicts);
		}
		unset($meta['require'][$package]);
		/**
		 * Satisfy provided required functionality
		 */
		foreach ($component_meta['provide'] as $p) {
			unset($meta['require'][$p]);
		}
		/**
		 * Check for conflicts
		 */
		if ($dependencies_conflicts = self::check_conflicts($meta, $component_meta)) {
			array_push($dependencies['conflict'], ...$dependencies_conflicts);
		}
	}
	/**
	 * Check whether there is available supported DB driver
	 *
	 * @param string[] $db_support
	 *
	 * @return bool
	 */
	protected static function check_dependencies_db ($db_support) {
		/**
		 * Component doesn't support (and thus use) any DB drivers, so we don't care what system have
		 */
		if (!$db_support) {
			return true;
		}
		$Core   = Core::instance();
		$Config = Config::instance();
		if (in_array($Core->db_driver, $db_support)) {
			return true;
		}
		foreach ($Config->db as $database) {
			if (isset($database['driver']) && in_array($database['driver'], $db_support)) {
				return true;
			}
		}
		return false;
	}
	/**
	 * Check whether there is available supported Storage driver
	 *
	 * @param string[] $storage_support
	 *
	 * @return bool
	 */
	protected static function check_dependencies_storage ($storage_support) {
		/**
		 * Component doesn't support (and thus use) any Storage drivers, so we don't care what system have
		 */
		if (!$storage_support) {
			return true;
		}
		$Core   = Core::instance();
		$Config = Config::instance();
		if (in_array($Core->storage_driver, $storage_support)) {
			return true;
		}
		foreach ($Config->storage as $storage) {
			if (in_array($storage['driver'], $storage_support)) {
				return true;
			}
		}
		return false;
	}
	/**
	 * Check if two both components are the same
	 *
	 * @param array $new_meta      `meta.json` content of new component
	 * @param array $existing_meta `meta.json` content of existing component
	 *
	 * @return bool
	 */
	protected static function check_dependencies_are_the_same ($new_meta, $existing_meta) {
		return
			$new_meta['package'] == $existing_meta['package'] &&
			$new_meta['category'] == $existing_meta['category'];
	}
	/**
	 * Check for functionality provided by other components
	 *
	 * @param array $new_meta      `meta.json` content of new component
	 * @param array $existing_meta `meta.json` content of existing component
	 *
	 * @return array
	 */
	protected static function also_provided_by ($new_meta, $existing_meta) {
		return array_intersect($new_meta['provide'], $existing_meta['provide']);
	}
	/**
	 * Check whether other component is required and have satisfactory version
	 *
	 * @param array $new_meta      `meta.json` content of new component
	 * @param array $existing_meta `meta.json` content of existing component
	 *
	 * @return array
	 */
	protected static function check_requirement ($new_meta, $existing_meta) {
		$conflicts = self::check_conflicts_or_requirements($new_meta['require'], $existing_meta['package'], $existing_meta['version'], false);
		foreach ($conflicts as &$conflict) {
			$conflict = [
				'package'          => $existing_meta['package'],
				'existing_version' => $existing_meta['version'],
				'required_version' => $conflict
			];
		}
		return $conflicts;
	}
	/**
	 * Check whether other component is required and have satisfactory version
	 *
	 * @param array  $requirements
	 * @param string $component
	 * @param string $version
	 * @param bool   $should_satisfy `true` for conflicts detection and `false` for requirements to fail
	 *
	 * @return array
	 */
	protected static function check_conflicts_or_requirements ($requirements, $component, $version, $should_satisfy) {
		/**
		 * If we are not interested in component - we are good
		 */
		if (!isset($requirements[$component])) {
			return [];
		}
		/**
		 * Otherwise compare required version with actual present
		 */
		$conflicts = [];
		foreach ($requirements[$component] as $details) {
			if (version_compare($version, $details[1], $details[0]) === $should_satisfy) {
				$conflicts[] = $details;
			}
		}
		return $conflicts;
	}
	/**
	 * Check for if component conflicts other components
	 *
	 * @param array $new_meta      `meta.json` content of new component
	 * @param array $existing_meta `meta.json` content of existing component
	 *
	 * @return array
	 */
	protected static function check_conflicts ($new_meta, $existing_meta) {
		/**
		 * Check whether two components conflict in any direction by direct conflicts
		 */
		return array_filter(
			array_merge(
				self::conflicts_one_step($new_meta, $existing_meta),
				self::conflicts_one_step($existing_meta, $new_meta)
			)
		);
	}
	/**
	 * @param array $meta_from
	 * @param array $meta_to
	 *
	 * @return array
	 */
	protected static function conflicts_one_step ($meta_from, $meta_to) {
		$conflicts = self::check_conflicts_or_requirements($meta_from['conflict'], $meta_to['package'], $meta_to['version'], true);
		if ($conflicts) {
			foreach ($conflicts as &$conflict) {
				$conflict = [
					'package'        => $meta_from['package'],
					'conflicts_with' => $meta_to['package'],
					'of_version'     => $conflict
				];
			}
			return $conflicts;
		}
		return [];
	}
	/**
	 * Check whether package is currently used by any other package (during uninstalling/disabling)
	 *
	 * @param array $meta `meta.json` contents of target component
	 *
	 * @return string[][] Empty array if dependencies are fine or array with optional key `modules` that contain array of dependent packages
	 */
	public static function get_dependent_packages ($meta) {
		/**
		 * No `meta.json` - nothing to check, allow it
		 */
		if (!$meta) {
			return [];
		}
		$meta    = self::normalize_meta($meta);
		$used_by = [];
		/**
		 * Checking for backward dependencies of modules
		 */
		foreach (Config::instance()->components['modules'] as $module => $module_data) {
			if (self::is_used_by($meta, $module, $module_data['active'])) {
				$used_by[] = $module;
			}
		}
		return $used_by;
	}
	/**
	 * @param array  $meta
	 * @param string $module
	 * @param int    $active
	 *
	 * @return bool
	 */
	protected static function is_used_by ($meta, $module, $active) {
		/**
		 * If module is not enabled, we compare module with itself or there is no `meta.json` - we do not care about it
		 */
		if (
			$active != Module_Properties::ENABLED ||
			self::check_dependencies_are_the_same($meta, ['category' => 'modules', 'package' => $module]) ||
			!file_exists(MODULES."/$module/meta.json")
		) {
			return false;
		}
		$module_meta = file_get_json(MODULES."/$module/meta.json");
		$module_meta = self::normalize_meta($module_meta);
		/**
		 * Check if component provided something important here
		 */
		return
			isset($module_meta['require'][$meta['package']]) ||
			array_intersect(array_keys($module_meta['require']), $meta['provide']);
	}
	/**
	 * Normalize structure of `meta.json`
	 *
	 * Addition necessary items if they are not present and casting some string values to arrays in order to decrease number of checks in further code
	 *
	 * @param array $meta
	 *
	 * @return array mixed
	 */
	protected static function normalize_meta ($meta) {
		foreach (['db_support', 'storage_support', 'provide', 'require', 'conflict'] as $item) {
			$meta[$item] = isset($meta[$item]) ? (array)$meta[$item] : [];
		}
		foreach (['require', 'conflict'] as $item) {
			$meta[$item] = self::dep_normal($meta[$item]);
		}
		return $meta;
	}
	/**
	 * Function for normalization of dependencies structure
	 *
	 * @param array|string $dependence_structure
	 *
	 * @return array
	 */
	protected static function dep_normal ($dependence_structure) {
		$return = [];
		foreach ((array)$dependence_structure as $d) {
			preg_match('/^([^<=>!]+)([<=>!]*)(.*)$/', $d, $d);
			/** @noinspection NestedTernaryOperatorInspection */
			$return[$d[1]][] = [
				isset($d[2]) && $d[2] ? $d[2] : (isset($d[3]) && $d[3] ? '=' : '>='),
				isset($d[3]) && $d[3] ? (float)$d[3] : 0
			];
		}
		return $return;
	}
}
