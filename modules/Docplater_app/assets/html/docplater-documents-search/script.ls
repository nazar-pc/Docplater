/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-documents-search'
	behaviors	: [
		cs.Docplater.behaviors.attached_once
		redux-behavior
	]
	properties	:
		documents	: Array
	created : !->
		@attached_once
			.then -> cs.api('get api/Docplater_app/documents')
			.then (@documents) !~>
	_load_document : (e) !->
		cs.Docplater.functions.get_document(e.model.item.hash)
)
