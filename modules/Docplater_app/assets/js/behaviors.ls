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
		observers	: [
			'_parameter_changed(parameters.*)'
		]
		get_parameter : (name) ->
			for parameter in @parameters
				if parameter.name == name
					return parameter
			return null
		_parameter_changed : !->
			for parameter in @parameters
				@_update_parameter(parameter)
		_update_parameter : (parameter) !->
			if !@document
				parameter.absolute_id	= @hash + '/' + parameter.name
				parameter.real_value	= @_parameter_get_real_value(parameter)
			else #We're in clause element
				parameter	= @get_parameter(parameter.name)
				value		= parameter.value || parameter.default_value
				@document.when_ready.then !~>
					if parameter && value && value.indexOf('@') == 0
						name					= value.substring(1)
						parameter.absolute_id	= @document.hash + '/' + name
						parameter.real_value	= @_parameter_get_real_value(@document.get_parameter(name))
					else
						parameter.absolute_id	= @document.hash + '/' + @hash + '/' + parameter.name
						parameter.real_value	= @_parameter_get_real_value(parameter)
		_parameter_get_real_value : (parameter) ->
			if parameter.value.length then parameter.value else parameter.default_value
	..this =
		properties	:
			this	:
				notify		: true
				readOnly	: true
				type		: Object
		attached : !->
			if !@this
				@_setThis(@)
	..when_ready =
		created : !->
			@when_ready = new Promise (@_when_ready_resolve) !~>
		attached : !->
			if @_when_ready_resolve
				@_when_ready_resolve(@)
				delete @_when_ready_resolve
