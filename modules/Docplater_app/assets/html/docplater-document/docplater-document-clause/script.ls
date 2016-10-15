/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Parameter	= cs.Docplater.Parameter
Event		= cs.Event
Polymer(
	is				: 'docplater-document-clause'
	behaviors		: [
		cs.Docplater.behaviors.document
	]
	hostAttributes	:
		contenteditable	: 'false'
	properties		:
		hash	: '9d96e17fd46eb91085fe8e47f714bd58f95300e1a6eb7792fb30d3efdf85446c'
)
