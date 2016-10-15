/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
/**
 * @param {Element}	element
 * @param {string}	selector
 *
 * @return {(Element|null)}
 */
function find_parent (element, selector)
	while element
		element	= element.parentNode || element.host
		if element instanceof Element && element.matches(selector)
			return element
	null

cs.{}Docplater.{}behaviors
	..document	=
		properties	:
			document	: Object
		attached	: !->
			@set('document', find_parent(@, 'docplater-document'))
	..document_clause	=
		properties	:
			clause	: Object
		attached	: !->
			@set('clause', find_parent(@, 'docplater-document-clause'))
