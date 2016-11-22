<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
namespace cs\modules\Docplater_app;
use
	cs\Config,
	cs\CRUD_helpers,
	cs\Singleton,
	cs\User,
	Ramsey\Uuid\Uuid;

class Clause_template {
	use
		CRUD_helpers,
		Singleton;

	protected $data_model = [
		'hash'        => 'text:40',
		'group_uuid'  => 'text:36',
		'parent_hash' => 'text:40',
		'date'        => 'int:1',
		'user'        => 'int:1',
		'title'       => 'text:256',
		'content'     => null, // Set in constructor
		'parameters'  => 'json'
	];
	protected $table      = '[prefix]docplater_clauses_templates';
	protected function cdb () {
		return Config::instance()->module('System')->db('users');
	}
	protected function construct () {
		$this->data_model['content'] = function ($text) {
			// TODO: rules as on frontend with certain custom elements allowed
			return $text;
		};
	}
	/**
	 * Create clause template
	 *
	 * @param string $group_uuid UUID v4, if empty - will be generated automatically
	 * @param string $parent_hash
	 * @param string $title
	 * @param string $content
	 * @param array  $parameters
	 *
	 * @return string Document hash
	 */
	public function add ($group_uuid, $parent_hash, $title, $content, $parameters) {
		$group_uuid = Uuid::isValid($group_uuid) ? $group_uuid : Uuid::uuid4();
		// TODO: Additional validation
		$date = time();
		$user = User::instance()->id;
		$hash = $this->compute_hash($date, $user, $title, $content, $parameters);
		// TODO: parameters and clauses cleaning
		return $this->create($hash, $group_uuid, $parent_hash, $date, $user, $title, $content, $parameters);
	}
	/**
	 * Compute clause hash
	 *
	 * @param int    $date
	 * @param int    $user
	 * @param string $title
	 * @param string $content
	 * @param array  $parameters
	 *
	 * @return string
	 */
	protected function compute_hash ($date, $user, $title, $content, $parameters) {
		$parameters = _json_encode($parameters);
		return sha1("$date$user$title$content$parameters");
	}
	/**
	 * Get clause template by its hash
	 *
	 * @param string $hash
	 *
	 * @return array|false
	 */
	public function get ($hash) {
		return $this->read($hash);
	}
	/**
	 * Delete clause template by its hash
	 *
	 * @param string $hash
	 *
	 * @return array|false
	 */
	public function del ($hash) {
		return $this->delete($hash);
	}
}
