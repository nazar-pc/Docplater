<?php
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
namespace cs\modules\Docplater_app\api;

class Controller {
	public static function documents () {
		return _json_decode(
		/** @lang JSON */
			<<<JSON
{
	"hash"       : "43cc23fa52b87b4cc1d02b5b114154151d6adddb17c9fddc06b027fa99e24008",
	"content"    : "<p>Some content requires <docplater-document-parameter>company_name</docplater-document-parameter> as company name</p><docplater-document-clause hash=\"9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c\"></docplater-document-clause><p><docplater-document-parameter>company_name</docplater-document-parameter> can be used multiple times</p><p>Tractu tempora erat tollere peregrinum animalia securae inmensa modo aeris evolvit deerat caligine sua peragebant metusque litora subdita plagae horrifer levius eodem nullo perpetuum animus illas addidit nec rudis passim sectamque ignotas sole melioris omnia circumdare quae agitabilis porrexerat meis piscibus carentem montes emicuit sinistra sanctius coegit zonae faecis moderantum zephyro reparabat lege aere duae umor chaos: persidaque illis foret rerum ubi terrarum hanc cura locavit prima quisquis omnia nulli vis praebebat tuba tuba postquam arce mundi diremit cetera fixo utramque legebantur mutastis litem spectent nullaque frigida levitate onus inmensa cepit levitate securae litem quod fabricator pontus fuit fidem coeperunt.</p>",
	"parameters" : {
		"company_name" : {
			"type"          : 0,
			"value"         : "Docplater",
			"default_value" : "",
			"options"       : {}
		},
		"date"         : {
			"type"          : 2,
			"value"         : "",
			"default_value" : "01.01.2000",
			"options"       : {}
		},
		"description"  : {
			"type"          : 3,
			"value"         : "",
			"default_value" : "",
			"options"       : {}
		}
	},
	"clauses"    : {
		"9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c" : {
			"parameters" : {
				"company" : {
					"type"          : 0,
					"value"         : "@company_name",
					"default_value" : "",
					"options"       : {}
				},
				"company_location" : {
					"type"          : 0,
					"value"         : "",
					"default_value" : "",
					"options"       : {}
				}
			}
		}
	}
}
JSON
		);
	}
	public static function clauses () {
		return _json_decode(
		/** @lang JSON */
			<<<JSON
{
	"hash"       : "9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c",
	"title"      : "Demo template",
	"content"    : "<p>Here is my <docplater-document-parameter>company</docplater-document-parameter> at <docplater-document-parameter>company_location</docplater-document-parameter></p>",
	"parameters" : {
		"company_name" : {
			"type"          : 0,
			"value"         : "Docplater",
			"default_value" : "",
			"options"       : {}
		},
		"date"         : {
			"type"          : 2,
			"value"         : "",
			"default_value" : "01.01.2000",
			"options"       : {}
		},
		"description"  : {
			"type"          : 3,
			"value"         : "",
			"default_value" : "",
			"options"       : {}
		}
	}
}
JSON
		);
	}
}
