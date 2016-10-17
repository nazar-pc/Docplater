/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Event	= cs.Event
Polymer(
	is			: 'docplater-document-parameters-panel'
	properties	:
		data	:
			observer	: '_data_set'
			type		: Object
		parameters_map	: Array
	_data_set : !->
		parameters_map	= [
			{
				for			: 'Document'
				parameters	: Object.values(@data.parameters)
			}
		]
		Promise.all(
			for own clause_hash, clause of @data.clauses
				cs.api("get api/Docplater_app/clauses/#clause_hash")
		).then (clauses) !~>
			console.log clauses
			for clause in clauses
				parameters	= Object.values(@data.clauses[clause.hash].parameters)
				if parameters.length
					parameters_map.push({
						for			: clause.title
						parameters	: parameters
					})
			@parameters_map	= parameters_map
	_parameter_highlight : (e) !->
		Event.fire('docplater/parameter/highlight', {
			absolute_id	: e.model.parameter.absolute_id
		})
	_parameter_unhighlight : !->
		Event.fire('docplater/parameter/highlight')
)
