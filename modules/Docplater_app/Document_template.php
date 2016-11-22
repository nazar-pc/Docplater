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
	cs\User;

class Document_template {
	use
		CRUD_helpers;
	protected $data_model = [
		'hash'        => 'text:40',
		'group_id'    => 'text:36',
		'parent_hash' => 'text:40',
		'date'        => 'int:1',
		'user'        => 'int:1',
		'title'       => 'text:256',
		'content'     => null, // Set in constructor
		'parameters'  => 'json',
		'clauses'     => 'json'
	];
	protected $table      = '[prefix]docplater_documents_templates';
	protected function cdb () {
		return Config::instance()->module('System')->db('users');
	}
	protected function construct () {
		// TODO: stricter rules as on frontend with certain custom elements allowed
		$this->data_model['content'] = function ($text) {
			return xap($text);
		};
	}
	/**
	 * Create document template
	 *
	 * @param string $group_id
	 * @param string $parent_hash
	 * @param string $title
	 * @param string $content
	 * @param array  $parameters
	 * @param array  $clauses
	 *
	 * @return string Document hash
	 */
	public function add ($group_id, $parent_hash, $title, $content, $parameters, $clauses) {
		// TODO: Additional validation
		$date = time();
		$user = User::instance()->id;
		$hash = $this->compute_hash($date, $user, $title, $content, $parameters, $clauses);
		// TODO: parameters and clauses cleaning
		return $this->create($hash, $group_id, $parent_hash, $date, $user, $title, $content, $parameters, $clauses);
	}
	/**
	 * Compute document hash
	 *
	 * @param int    $date
	 * @param int    $user
	 * @param string $title
	 * @param string $content
	 * @param array  $parameters
	 * @param array  $clauses
	 *
	 * @return string
	 */
	protected function compute_hash ($date, $user, $title, $content, $parameters, $clauses) {
		$parameters = _json_encode($parameters);
		$clauses    = _json_encode($clauses);
		return sha1("$date$user$title$content$parameters$clauses");
	}
	/**
	 * Get document template by its hash
	 *
	 * @param string $hash
	 *
	 * @return array|false
	 */
	public function get ($hash) {
		return $this->read($hash);
	}
	/**
	 * Delete document template by its hash
	 *
	 * @param string $hash
	 *
	 * @return array|false
	 */
	public function del ($hash) {
		return $this->delete($hash);
	}
}
