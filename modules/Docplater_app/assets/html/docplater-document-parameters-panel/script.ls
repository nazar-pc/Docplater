/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-document-parameters-panel'
	behaviors	:[
		redux-behavior
	]
	properties	:
		parameters_map	: Array
		state			:
			statePath	: ''
			type		: Object
	observers	: [
		'_parameters_map(state.document, state.clauses)'
	]
	_parameters_map : (document, clauses) !->
		if @_skip_render
			@_skip_render	= false
			return
		parameters_map	= [
			{
				for			: 'Document'
				parameters	: for own name, parameter of document.parameters
					parameter.merge({name})
			}
		]
		Promise.all(
			for own clause_hash of document.clauses
				cs.Docplater.functions.get_clause(clause_hash)
		).then (clauses) !~>
			for clause in clauses
				clause_instances	= document.clauses[clause.hash]
				for own clause_index, clause_instance of clause_instances
					if Object.keys(clause_instance.parameters).length
						parameters_map.push({
							for			: clause.title + ' #' + clause_index
							parameters	: for own name, parameter of clause_instance.parameters
								parameter.merge({name, clause_hash, clause_index})
						})
			@parameters_map	= parameters_map
	_parameter_highlight : (e) !->
		@dispatch(
			type			: 'PARAMETER_HIGHLIGHT'
			name			: e.model.parameter.name
			clause_hash		: e.model.parameter.clause_hash
			clause_index	: e.model.parameter.clause_index
		)
	_parameter_unhighlight : !->
		@dispatch(
			type	: 'PARAMETER_UNHIGHLIGHT'
		)
	_parameter_changed : (e) !->
		@_skip_render	= true
		@dispatch(
			type			: 'PARAMETER_UPDATE_VALUE'
			name			: e.model.parameter.name
			clause_hash		: e.model.parameter.clause_hash
			clause_index	: e.model.parameter.clause_index
			value			: e.target.value
		)
)
