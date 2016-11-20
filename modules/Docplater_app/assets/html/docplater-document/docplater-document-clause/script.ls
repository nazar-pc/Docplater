/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is				: 'docplater-document-clause'
	behaviors		: [
		cs.Docplater.behaviors.attached_once
		redux-behavior
	]
	hostAttributes	:
		contenteditable	: 'false'
	properties		:
		data		: Object
		hash		: String
		instance	: Number
	created : !->
		@attached_once
			.then !~>
				for clause in @getState().document.clauses
					if clause.hash == @hash
						return clause
			.then (@data) !~>
				@$.content.innerHTML	= @data.content
)
