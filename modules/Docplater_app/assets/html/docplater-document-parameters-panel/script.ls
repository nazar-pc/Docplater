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
	behaviors	: [
		redux-behavior
	]
	properties	:
		parameters_map	: Array
		state			:
			statePath	: ''
			type		: Object
	observers	: [
		'_parameters_map(state.document)'
	]
	_parameters_map : (document) !->
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
		for clause, clause of document.clauses
			for clause_instance, parameters of clause.instances
				parameters_map.push({
					for			: clause.title + ' #' + clause_instance
					parameters	: for own name, parameter of parameters
						parameter.merge({
							name			: name
							clause_hash		: clause.hash
							clause_instance	: clause_instance
						})
				})
		@parameters_map	= parameters_map
	_parameter_highlight : (e) !->
		@dispatch(
			type			: 'PARAMETER_HIGHLIGHT'
			name			: e.model.parameter.name
			clause_hash		: e.model.parameter.clause_hash
			clause_instance	: e.model.parameter.clause_instance
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
			clause_instance	: e.model.parameter.clause_instance
			value			: e.target.value
		)
	_add_parameter : !->
		cs.ui.prompt('New parameter name (without @ prefix):').then (name) !~>
			@dispatch(
				type	: 'PARAMETER_ADD'
				name	: name
			)
	_edit_parameter : (e) !->
		name	= e.model.parameter.name
		cs.ui.prompt("Default value for parameter #name:").then (default_value) !~>
			@dispatch(
				type			: 'PARAMETER_SET_DEFAULT_VALUE'
				name			: name
				clause_hash		: e.model.parameter.clause_hash
				clause_instance	: e.model.parameter.clause_instance
				default_value	: default_value
			)
	_delete_parameter : (e) !->
		name	= e.model.parameter.name
		cs.ui.confirm("Are you sure you want to delete parameter @#name?").then !~>
			@dispatch(
				type	: 'PARAMETER_DELETE'
				name	: name
			)
)
