/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
loading_clauses	= {}
cs.{}Docplater.{}functions
	..get_clause = (clause_hash) ->
		cs.Docplater.Redux.store.then (store) ->
			state	= store.getState()
			if state.clauses[clause_hash]
				state.clauses[clause_hash]
			else if loading_clauses[clause_hash]
				loading_clauses[clause_hash]
			else
				loading_clauses[clause_hash]	= cs.api("get api/Docplater_app/clauses/#clause_hash").then (clause) ->
					delete loading_clauses[clause_hash]
					store.dispatch(
						type	: 'CLAUSE_LOADED'
						clause	: clause
					)
					clause
	..get_document = (document_hash) ->
		cs.Docplater.Redux.store.then (store) ->
			cs.api("get api/Docplater_app/documents/#document_hash").then (document) ->
				store.dispatch(
					type		: 'DOCUMENT_LOADED'
					document	: document
				)
				document
