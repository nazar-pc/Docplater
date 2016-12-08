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
	h;

class Controller {
	public static function editor () {
		return h::docplater_app();
	}
	public static function print () {
		return h::docplater_print();
	}
}
