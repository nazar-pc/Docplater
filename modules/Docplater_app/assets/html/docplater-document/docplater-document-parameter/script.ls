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
	is				: 'docplater-document-parameter'
	behaviors		: [
		cs.Docplater.behaviors.document
		cs.Docplater.behaviors.document_clause
	]
	hostAttributes	:
		contenteditable	: 'false'
		tabindex		: 0
	properties		:
		highlight	:
			reflectToAttribute	: true
			type				: Boolean
		name	: String
	listeners		:
		'focus'	: '_focus_in'
		'blur'	: '_focus_out'
	created : !->
		@_highlighting	= @_highlighting.bind(@)
		Event.on('dockplater/property/highlight', @_highlighting)
	attached : !->
		@name = @textContent.trim()
	_focus_in : !->
		Event.fire('dockplater/property/highlight', {@name})
	_focus_out : !->
		Event.fire('dockplater/property/highlight')
	_highlighting : ({name}?) !->
		@highlight = name == @name
)
