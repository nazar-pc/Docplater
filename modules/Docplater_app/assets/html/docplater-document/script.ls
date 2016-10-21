/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-document'
	behaviors	: [
		cs.Docplater.behaviors.attached_once
		redux-behavior
	]
	properties	:
		document	:
			statePath	: 'document'
			type		: Object
		hash	: String
		preview	:
			statePath	: 'preview'
			type		: Boolean
	created : !->
		@attached_once
			.then ~> cs.api('get api/Docplater_app/documents/' + @hash)
			.then (document) !~>
				@dispatch(
					type		: 'DOCUMENT_LOADED'
					document	: document
				)
				@$.content.innerHTML	= document.content
				require(['scribe'], (Scribe) !~>
					new Scribe(@$.content)
				)
	_toggle_preview : !->
		@dispatch(
			type	: 'PREVIEW_TOGGLE'
		)
)
