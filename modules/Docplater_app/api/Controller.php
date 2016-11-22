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
	cs\modules\Docplater_app\Document_template;

class Controller {
	public static $clause_content = <<<HTML
<table>
	<tr><td>By:</td><td><docplater-document-parameter>by</docplater-document-parameter></td></tr>
	<tr><td>Name:</td><td><docplater-document-parameter>name</docplater-document-parameter></td></tr>
	<tr><td>Title:</td><td><docplater-document-parameter>title</docplater-document-parameter></td></tr>
	<tr><td>Date:</td><td><docplater-document-parameter>date</docplater-document-parameter></td></tr>
</table>
HTML;
	/**
	 * @param \cs\Request $Request
	 *
	 * @return array|false
	 */
	public static function documents_get ($Request) {
		return Document_template::instance()->get($Request->route_path(1));
	}
	public static function clauses () {
		return
			['content' => self::$clause_content] +
			_json_decode(
			/** @lang JSON */
				<<<JSON
	{
	"hash"       : "9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c",
	"title"      : "Demo template",
	"parameters" : [
		"by",
		"name",
		"title",
		"date"
	]
}
JSON
			);
	}
}
