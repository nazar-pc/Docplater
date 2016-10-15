/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Event		= cs.Event
Parameter	= cs.Docplater.Parameter
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
		absolute_id	: String
		highlight	:
			reflectToAttribute	: true
			type				: Boolean
		name	: String
		preview	: false
		value	: String
	listeners		:
		'focus'	: '_focus_in'
		'blur'	: '_focus_out'
	created : !->
		@_highlighting	= @_highlighting.bind(@)
		@_set_preview	= @_set_preview.bind(@)
		@_update		= @_update.bind(@)
		Event.on('dockplater/parameter/highlight', @_highlighting)
		Event.on('dockplater/document/preview', @_set_preview)
	attached : !->
		@name	= @textContent.trim()
		@document.when_ready.then(@_update)
	_update : !->
		@absolute_id	= @document.hash + '/' + @name
		parameter		= @document.get_parameter(@name)
		if @clause
			parameter	= @clause.get_parameter(@name)
			if parameter && parameter.value.indexOf('@') == 0
				name			= parameter.value && parameter.value.substring(1)
				@absolute_id	= @document.hash + '/' + name
				parameter		= @document.get_parameter(name)
			else
				@absolute_id	= @document.hash + '/' + @clause.hash + '/' + name
		@value	= parameter.value || parameter.default_value
	_focus_in : !->
		Event.fire('dockplater/parameter/highlight', {@absolute_id})
	_focus_out : !->
		Event.fire('dockplater/parameter/highlight')
	_highlighting : ({absolute_id}?) !->
		@highlight = absolute_id == @absolute_id
	_set_preview : ({@preview}) !->
)
