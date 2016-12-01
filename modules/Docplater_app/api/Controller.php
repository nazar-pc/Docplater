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
	cs\User,
	cs\modules\Docplater_app\Clause_template,
	cs\modules\Docplater_app\Document,
	cs\modules\Docplater_app\Document_template;

class Controller {
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function documents_get ($Request) {
		$id       = $Request->route_path(1);
		$Document = Document::instance();
		if ($id) {
			return $Document->get($id);
		}
		return $Document->get(
			$Document->search(
				[
					'user' => User::instance()->id
				]
			)
		);
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function templates_get ($Request) {
		$id                = $Request->route_path(1);
		$Document_template = Document_template::instance();
		if ($id) {
			return $Document_template->get($id);
		}
		return $Document_template->get(
			$Document_template->search()
		);
	}
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function clauses_get ($Request) {
		$id              = $Request->route_path(1);
		$Clause_template = Clause_template::instance();
		if ($id) {
			return $Clause_template->get($id);
		}
		return $Clause_template->get(
			$Clause_template->search()
		);
	}
}
