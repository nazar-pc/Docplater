/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-clauses-search'
	behaviors	: [
		cs.Docplater.behaviors.attached_once
		redux-behavior
	]
	properties	:
		document		:
			statePath	: 'document'
			type		: Object
		clauses			: Array
		scribe_instance	:
			observer	: '_scribe_instance'
			type		: Object
	created : !->
		@attached_once
			.then -> cs.api('get api/Docplater_app/clauses')
			.then (@clauses) !~>
	_scribe_instance : !->
		@ssa	= new cs.Docplater.simple_scribe_api(@scribe_instance)
	_insert_clause : (e) !->
		if @ssa
			hash	= e.model.item.hash
			@dispatch(
				type	: 'CLAUSE_ADD_INSTANCE'
				clause	: e.model.item
			)
			instance	= -1
			for clause, clause of @document.clauses
				if clause.hash == hash
					instance	= Object.keys(clause.instances).pop()
					break
			if instance < 0
				throw 'Instance was not added'
			@ssa.insert_html("""<b>date</b>""")
			@ssa.insert_html("""<docplater-document-clause hash="#hash" instance="#instance"></docplater-document-clause>""")
)
