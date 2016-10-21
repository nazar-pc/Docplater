/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Immutable		= null
initial_state	= {
	clauses		: {},
	documents	: {},
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
function get_full_parameter_path (state, parameter, clause_hash)
	if clause_hash
		['document', 'clauses', clause_hash, 'parameters', parameter]
	else
		['document', 'parameters', parameter]

function reducer (state = initial_state, action)
	switch action.type
		when 'DOCUMENT_LOADED'
			state.set('document', action.document)
		when 'CLAUSE_LOADED'
			state.setIn(
				['clauses', action.clause.hash]
				action.clause
			)
		when 'PARAMETER_HIGHLIGHT'
			if state.highlighted_parameter
				state	= state.setIn(state.highlighted_parameter.concat('highlight'), false)
			highlighted_parameter	= get_full_parameter_path(state, action.name, action.clause_hash)
			state
				.set('highlighted_parameter', highlighted_parameter)
				.setIn(highlighted_parameter.concat('highlight'), true)
		when 'PARAMETER_UNHIGHLIGHT'
			if state.highlighted_parameter
				state
					.setIn(state.highlighted_parameter.concat('highlight'), false)
					.set('highlighted_parameter')
		when 'PARAMETER_UPDATE_VALUE'
			parameter	= get_full_parameter_path(state, action.name, action.clause_hash)
			state.setIn(parameter.concat('value'), action.value)
		when 'PREVIEW_TOGGLE'
			state.merge(
				preview	: !state.preview
			)
		else state
