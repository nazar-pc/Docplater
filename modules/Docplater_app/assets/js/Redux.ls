/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
initial_state	= {
	document		:
		clauses		: []
		content		: '<p></p>'
		parameters	: {}
		type		: 'document'
	preview			: true
	force_update	: false
}
if previous_state = localStorage.getItem('redux-state')
	previous_state	= JSON.parse(previous_state)
Redux			= cs.{}Docplater.{}Redux
Redux.store		= require(['redux', 'seamless-immutable']).then ([redux, seamless-immutable]) ->
	initial_state	:= seamless-immutable(initial_state)
	previous_state	:= seamless-immutable(previous_state)
	store	= redux.createStore(reducer)
	store.subscribe(!->
		localStorage.setItem('redux-state', JSON.stringify(store.getState()))
	)
	store
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

function reducer (state = previous_state || initial_state, action)
	switch action.type
		when 'DOCUMENT_NEW'
			localStorage.removeItem('redux-state')
			state
				.set('document', initial_state.document)
				.set('force_update', true)
		when 'DOCUMENT_LOADED'
			state
				.set('document', action.document)
				.set('force_update', true)
		when 'DOCUMENT_UPLOADED'
			localStorage.removeItem('redux-state')
			state
				.set('document', initial_state.document)
				.setIn(['document', 'content'], action.content)
				.set('force_update', true)
		when 'DOCUMENT_CONTENT_UPDATE'
			state.setIn(['document', 'content'], action.content)
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
			state.set('preview', !state.preview)
		when 'FORCE_UPDATE_TOGGLE'
			state.set('force_update', !state.force_update)
		else state
