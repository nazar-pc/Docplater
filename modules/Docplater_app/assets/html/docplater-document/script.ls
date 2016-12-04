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
		document		:
			statePath	: 'document'
			type		: Object
			observer	: '_document_changed'
		hash			: String
		scribe_instance	:
			notify	: true
			type	: Object
	created : !->
		@attached_once
			.then !~>
				if @hash
					cs.api('get api/Docplater_app/documents/' + @hash).then (document) !~>
						@dispatch(
							type		: 'DOCUMENT_LOADED'
							document	: document
						)
			.then !~>
				@scopeSubtree(@$.content, true)
				@_init_scribe()
	_document_changed : !->
		if @scribe_instance && @document.hash != @hash
			@hash = @document.hash
			@_set_content(@document.content)
	_init_scribe : !->
		if @scribe_instance
			@_set_content(@document.content)
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
				@_set_content(@document.content)
		)
	_set_content : (content) !->
		@scribe_instance
			..setContent(content)
			..undoManager.clearUndo()
)
