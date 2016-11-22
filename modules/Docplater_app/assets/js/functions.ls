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
	..rx =
		hash	: (-> @test(it)).bind(/^[0-9a-f]{40}$/)
		number	: (-> @test(it)).bind(/^[0-9]+$/)
	..get_list_of_allowed_tags = ->
		list	= [
			'p', 'div'
			'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'sup', 'sub'
			'img', 'br'
			'table', 'thead', 'tbody', 'tr', 'th', 'td'
			'h1', 'h2', 'h3', 'h4', 'h5', 'h6'
			'ul', 'ol', 'li'
			'docplater-document-clause', 'docplater-document-parameter'
		]
		tags	= {}
		for tag in list
			tags[tag]	= {}
		tags
	..fill_tags_attributes = (tags) ->
		map	= {
			td								:
				colspan			: @rx.number
				rowspan			: @rx.number
			'docplater-document-clause'		:
				contenteditable	: 'false'
				tabindex		: 0
				hash			: @rx.hash
				instance		: @rx.number
			'docplater-document-parameter'	:
				contenteditable	: 'false'
				tabindex		: 0
		}
		for tag, attributes of map
			for attribute, attribute_value of attributes
				if attribute_value instanceof Object
					tags[tag][attribute]	= attribute_value
				else
					tags[tag][attribute]	= true
		tags
