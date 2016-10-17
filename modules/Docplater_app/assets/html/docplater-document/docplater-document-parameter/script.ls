/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Event	= cs.Event
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
		name		: String
		parameter	: Object
		preview		: false
		value		: String
	listeners		:
		'focus'	: '_focus_in'
		'blur'	: '_focus_out'
	created : !->
		@_highlighting						= @_highlighting.bind(@)
		@_set_preview						= @_set_preview.bind(@)
		@_track_parameter_effective_value	= @_track_parameter_effective_value.bind(@)
		Event.on('docplater/parameter/highlight', @_highlighting)
		Event.on('docplater/document/preview', @_set_preview)
	attached : !->
		@name	= @textContent.trim()
		if @clause
			@parameter	= @document.data.clauses[@clause.hash].parameters[@name]
		else
			@parameter	= @document.data.parameters[@name]
		@_update_display_value()
		@parameter.once(@_track_parameter_effective_value)
	_track_parameter_effective_value : !->
		parameter	= @parameter
		parameter.on(
			!~>
				if parameter != @parameter
					@_track_parameter_effective_value()
					parameter.off(@_track_parameter_effective_value)
				@_update_display_value()
			['effective_value']
		)
	_update_display_value : (parameter) !->
		@value	= @parameter.effective_value || "@#{@name}"
	_focus_in : !->
		Event.fire('docplater/parameter/highlight', {
			absolute_id	: @parameter.absolute_id
		})
	_focus_out : !->
		Event.fire('docplater/parameter/highlight')
	_highlighting : ({absolute_id}?) !->
		@highlight = absolute_id == @parameter.absolute_id
	_set_preview : ({@preview}) !->
)
