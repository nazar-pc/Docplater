<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
namespace cs\modules\Docplater_app\api;
use
	cs\modules\Docplater_app\Clause_template,
	cs\modules\Docplater_app\Document_template;

class Controller {
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function documents_get ($Request) {
		return Document_template::instance()->get($Request->route_path(1));
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function clauses_get ($Request) {
		return Clause_template::instance()->get($Request->route_path(1));
	}
}
