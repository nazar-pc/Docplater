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
	..document =
		properties	:
			document	: Object
		attached	: !->
			@set('document', find_parent(@, 'docplater-document'))
	..document_clause =
		properties	:
			clause	: Object
		attached	: !->
			@set('clause', find_parent(@, 'docplater-document-clause'))
	..parameters =
		properties	:
			parameters	:
				notify	: true
				type	: Array
		get_parameter : (name) ->
			for parameter in @parameters
				if parameter.name == name
					return parameter
			return null
	..when_ready =
		created : !->
			@when_ready = new Promise (@_when_ready_resolve) !~>
		attached : !->
			if @_when_ready_resolve
				@_when_ready_resolve()
				delete @_when_ready_resolve
