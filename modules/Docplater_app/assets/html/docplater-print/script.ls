/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
redux-behavior <-! cs.Docplater.Redux.behavior.then
Polymer(
	is			: 'docplater-print'
	behaviors	: [
		redux-behavior
	]
	attached : !->
		@$.content.innerHTML = @getState().document.content
		cs.ui.ready.then !~>
			for element in @$.content.querySelectorAll('docplater-document-clause')
				element.outerHTML = '<div class="clause">' + element.shadowRoot.querySelector('#content').innerHTML + '</div>'
			for element in @$.content.querySelectorAll('docplater-document-parameter')
				element.outerHTML = '<div class="parameter">' + (if element.parameter then element.parameter.display_value else '@' + element.name) + '</div>'
			print()
)
