<?php
/**
 * @package   Composer
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2015-2016, Nazar Mokrynskyi
 * @license   MIT License, see license.txt
 */
namespace cs\modules\Composer\api;
use
	cs\ExitException,
	cs\User,
	cs\modules\Composer\Composer;

class Controller {
	/**
	 * @return string
	 *
	 * @throws ExitException
	 */
	public static function index_get () {
		static::common();
		$log_file = STORAGE.'/Composer/last_execution.log';
		return file_exists($log_file) ? ansispan(file_get_contents($log_file)) : '';
	}
	protected static function common () {
		if (!User::instance()->admin()) {
			throw new ExitException(403);
		}
		require_once __DIR__.'/../ansispan.php';
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array
	 *
	 * @throws ExitException
	 */
	public static function index_post ($Request) {
		static::common();
		$force = $Request->data('force');
		$name  = $Request->data('name');
		if ($force) {
			$result = Composer::instance()->force_update();
		} elseif ($name) {
			$result = Composer::instance()->update($name, Composer::MODE_ADD);
		} else {
			throw new ExitException(400);
		}
		return [
			'code'        => $result['code'],
			'description' => ansispan($result['description'])
		];
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array
	 *
	 * @throws ExitException
	 */
	public static function index_delete ($Request) {
		static::common();
		$name = $Request->data('name');
		if (!$name) {
			throw new ExitException(400);
		}
		$result = Composer::instance()->update($name, Composer::MODE_DELETE);
		return [
			'code'        => $result['code'],
			'description' => ansispan($result['description'])
		];
	}
}
