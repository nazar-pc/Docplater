/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Event		= cs.Event
Polymer(
	is			: 'docplater-document-parameters-panel'
	properties	:
		document			:
			observer	: '_document_set'
			type		: Object
		document_parameters	: Array
		clauses				: Array
	_document_set : !->
		@document.when_ready.then !~>
			@set('document_parameters', @document.parameters)
			@set('clauses', @document.clauses)
	_parameter_focus_in : (e) !->
		Event.fire('dockplater/parameter/highlight', {
			absolute_id	: e.model.parameter.absolute_id
		})
	_parameter_focus_out : !->
		Event.fire('dockplater/parameter/highlight')
)
