/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is				: 'docplater-document-parameter'
	behaviors		: [
		cs.Docplater.behaviors.document_clause
		redux-behavior
	]
	hostAttributes	:
		contenteditable	: 'false'
		tabindex		: 0
	properties		:
		display_value	: String
		exists			:
			type	: Boolean
			value	: false
		highlight		:
			reflectToAttribute	: true
			type				: Boolean
		name			: String
		parameter		:
			computed	: '_parameter(state.document, clause, name)'
			type		: Object
		preview		:
			statePath	: 'preview'
			type		: Boolean
		state		:
			statePath	: ''
			type		: Object
	listeners		:
		'focus'	: '_focus_in'
		'blur'	: '_focus_out'
	attached : !->
		@name	= @textContent.trim()
	_parameter : (document_state, clause, name) ->
		if @clause
			clauses		= document_state.clauses
			for clause, clause of clauses
				if clause.hash == @clause.hash
					parameter	= clause.instances[@clause.instance][name]
					break
		else
			parameter	= document_state.parameters[name]
		@exists	= Boolean(parameter)
		if !parameter
			return
		@non_existing		= ''
		effective_value		= parameter.value || parameter.default_value
		upstream_parameter	= @_get_upstream_parameter(effective_value)
		if upstream_parameter
			display_value	= upstream_parameter.value || upstream_parameter.default_value || "@#upstream_name"
			highlight		= upstream_parameter.highlight || parameter.highlight || false
		else
			display_value	= effective_value || "@#name"
			highlight		= parameter.highlight || false
		@highlight	= highlight
		parameter.merge({display_value})
	_get_upstream_parameter : (value) ->
		if value.indexOf('@') != 0
			null
		else
			name	= value.substring(1)
			@getState().document.parameters[name] || null
	_focus_in : !->
		if !@exists
			return
		@dispatch(
			type			: 'PARAMETER_HIGHLIGHT'
			name			: @name
			clause_hash		: @clause && @clause.hash
			clause_instance	: @clause && @clause.instance
		)
	_focus_out : !->
		@dispatch(
			type	: 'PARAMETER_UNHIGHLIGHT'
		)
)
