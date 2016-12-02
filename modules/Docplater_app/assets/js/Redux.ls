/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Immutable		= null
initial_state	= {
	document	:
		clauses		: []
		content		: '<p></p>'
		parameters	: {}
	preview		: true
}
Redux			= cs.{}Docplater.{}Redux
Redux.store		= require(['redux', 'seamless-immutable']).then ([redux, seamless-immutable]) ->
	Immutable		:= seamless-immutable
	initial_state	:= Immutable(initial_state)
	redux.createStore(reducer)
Redux.behavior	=
	Promise.all([
		Redux.store
		require(['polymer-redux'])
	]).then ([store, [polymer-redux]]) ->
		polymer-redux(store)
function get_full_parameter_path (state, parameter, clause_hash, clause_instance)
	if clause_hash
		for clause_index, clause of state.document.clauses
			if clause.hash == clause_hash
				return ['document', 'clauses', clause_index, 'instances', clause_instance, parameter]
		throw 'No clause in document'
	else
		['document', 'parameters', parameter]

function reducer (state = initial_state, action)
	switch action.type
		when 'DOCUMENT_LOADED'
			state.set('document', action.document)
		when 'CLAUSE_ADD_INSTANCE'
			parameters	= {}
			for parameter in action.clause.parameters
				parameters[parameter] =
					value			: ''
					default_value	: ''
			for clause_index, clause of state.document.clauses
				if clause.hash == action.clause.hash
					return state.setIn(
						['document', 'clauses', clause_index, 'instances', parseInt(Object.keys(clause.instances).pop()) + 1]
						parameters
					)
			state.setIn(
				['document', 'clauses', state.document.clauses.length]
				{
					hash		: action.clause.hash
					title		: action.clause.title
					content		: action.clause.content
					instances	:
						0	: parameters
				}
			)
		when 'PARAMETER_HIGHLIGHT'
			if state.highlighted_parameter
				state	= state.setIn(state.highlighted_parameter.concat('highlight'), false)
			highlighted_parameter	= get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance)
			state
				.set('highlighted_parameter', highlighted_parameter)
				.setIn(highlighted_parameter.concat('highlight'), true)
		when 'PARAMETER_UNHIGHLIGHT'
			if state.highlighted_parameter
				state
					.setIn(state.highlighted_parameter.concat('highlight'), false)
					.set('highlighted_parameter')
			else
				state
		when 'PARAMETER_ADD'
			state.setIn(['document', 'parameters', action.name], {value : '', default_value : ''})
		when 'PARAMETER_SET_DEFAULT_VALUE'
			parameter	= get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance)
			state.setIn(parameter.concat('default_value'), action.default_value)
		when 'PARAMETER_DELETE'
			state.setIn(['document', 'parameters'], state.document.parameters.without(action.name))
		when 'PARAMETER_UPDATE_VALUE'
			parameter	= get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance)
			state.setIn(parameter.concat('value'), action.value)
		when 'PREVIEW_TOGGLE'
			state.merge(
				preview	: !state.preview
			)
		else state
