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
			.then ~> cs.Docplater.functions.get_document(@hash)
			.then !~>
				@scopeSubtree(@$.content, true)
				@_init_scribe()
	_init_scribe : !->
		if @scribe_instance
			return
		require([
			'scribe-editor'
			'scribe-plugin-inline-styles-to-elements'
			'scribe-plugin-keyboard-shortcuts'
			'scribe-plugin-sanitizer'
			'scribe-plugin-tab-indent'
		]).then(
			([
				scribe-editor
				scribe-plugin-inline-styles-to-elements
				scribe-plugin-keyboard-shortcuts
				scribe-plugin-sanitizer
				scribe-plugin-tab-indent
			]) !~>
					@scribe_instance	= new scribe-editor(@$.content)
					@scribe_instance
						..use(scribe-plugin-inline-styles-to-elements())
						..use(scribe-plugin-keyboard-shortcuts())
						..use(scribe-plugin-sanitizer(
							tags: cs.Docplater.functions.fill_tags_attributes(
								cs.Docplater.functions.get_list_of_allowed_tags()
							)
						))
						..use(scribe-plugin-tab-indent())
						..setHTML(@document.content)
		)
	_toggle_preview : !->
		@dispatch(
			type	: 'PREVIEW_TOGGLE'
		)
)
