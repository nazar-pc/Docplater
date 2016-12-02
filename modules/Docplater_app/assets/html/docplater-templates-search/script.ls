/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-templates-search'
	behaviors	: [
		cs.Docplater.behaviors.attached_once
		redux-behavior
	]
	properties	:
		templates	: Array
	created : !->
		@attached_once
			.then -> cs.api('get api/Docplater_app/templates')
			.then (@templates) !~>
	_load_document : (e) !->
		@dispatch(
			type		: 'DOCUMENT_LOADED'
			document	: e.model.item
		)
)
