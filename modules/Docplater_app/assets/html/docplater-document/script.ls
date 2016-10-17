/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Event		= cs.Event
Notifiable	= cs.Docplater.Notifiable
Polymer(
	is			: 'docplater-document'
	behaviors	: [
		cs.Docplater.behaviors.attached_once
	]
	properties	:
		data	:
			notify	: true
			type	: Object
		hash	: String
		preview	: false
	created : !->
		@attached_once
			.then ~> cs.api('get api/Docplater_app/documents/' + @hash)
			.then (data) !~>
				data = Notifiable(data)
				@_denormalize_parameters(data, data.parameters)
				for own clause_hash, clause of data.clauses
					@_denormalize_parameters(data, clause.parameters, clause_hash)
				@data					= data
				@$.content.innerHTML	= @data.content
				@distributeContent()
				require(['scribe'], (Scribe) !~>
					new Scribe(@$.content)
				)
	_denormalize_parameters : (data, parameters, clause_hash) !->
		for own name, parameter of parameters
			@_denormalize_parameters_single(data, name, parameter, clause_hash)
	_denormalize_parameters_single : (data, name, parameter, clause_hash) ->
		# Create new properties
		parameter.set('name', name)
		parameter.set('absolute_id', '')
		parameter.set('effective_value', '')
		parameter.on(
			(keys, new_value) !~>
				if !clause_hash
					parameter.absolute_id		= @hash + '/' + parameter.name
					parameter.effective_value	= @_parameter_get_effective_value(parameter)
					return
				value	= parameter.value || parameter.default_value
				if parameter && value && value.indexOf('@') == 0
					name	= value.substring(1)
					if data.parameters[name]
						parameter.absolute_id		= @hash + '/' + name
						parameter.effective_value	= @_parameter_get_effective_value(data.parameters[name])
						@_subscribe_to_upstream_parameters_change(parameter, data.parameters[name])
						return
				parameter.absolute_id		= @hash + '/' + @hash + '/' + parameter.name
				parameter.effective_value	= @_parameter_get_effective_value(parameter)
			['value']
		)
		# Trigger event handler above
		parameter.fire(['value'])
	_parameter_get_effective_value : (parameter) ->
		parameter.value || parameter.default_value
	_subscribe_to_upstream_parameters_change : (parameter, upstream_parameter) !->
		callback	= !~>
			if upstream_parameter.absolute_id == parameter.absolute_id
				parameter.effective_value	= @_parameter_get_effective_value(upstream_parameter)
			else
				upstream_parameter.off(callback, ['effective_value'])
		upstream_parameter.on(callback, ['effective_value'])
	_toggle_preview : !->
		@preview = !@preview
		Event.fire('docplater/document/preview', {@preview})
)
