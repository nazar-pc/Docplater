/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Polymer(
	is				: 'docplater-document-clause'
	behaviors		: [
		cs.Docplater.behaviors.attached_once
	]
	hostAttributes	:
		contenteditable	: 'false'
	properties		:
		data		: Object
		hash		: String
		parameters	: Object
	created : !->
		@attached_once
			.then ~> cs.api('get api/Docplater_app/clauses/' + @hash)
			.then (@data) !~>
				@$.content.innerHTML	= @data.content
)
