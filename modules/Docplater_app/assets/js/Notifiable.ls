/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
/**
 * @param {Notifiable}	args
 * @param {string}		key
 */
!function Wrap (target, key)
	current_value	= target[key]
	Object.defineProperty(
		target
		key
		get			: ->
			current_value
		set			: (new_value) ->
			if new_value instanceof Object
				new_value = new Notifiable(new_value, target, key)
			old_value		= current_value
			current_value	:= new_value
			target.fire([key], new_value, old_value)
		enumerable	: true
	)
/**
 * @param {Object}	source
 * @param {Object}	parent
 * @param {string}	parent_key
 *
 * @return {Notifiable}
 */
!function Notifiable (source, parent, parent_key)
	if !(@ instanceof Notifiable)
		return new Notifiable(source)
	for own key of source
		if source[key] instanceof Object
			@[key]	= new Notifiable(source[key], @, key)
		else
			@[key] = source[key]
		Wrap(@, key)
	if parent && parent_key
		@on (keys, new_value, old_value) !~>
			parent.fire([parent_key].concat(keys), new_value, old_value)
/**
 * @param {Array} keys
 *
 * @return {string}
 */
function __notifiable_path_from_keys (keys)
	if keys.length then '/' + keys.join('/') + '/' else '/'

Notifiable::
	..on	= (callback, keys = []) ->
		if callback
			path	= __notifiable_path_from_keys(keys)
			if !@__notifiable_callbacks
				Object.defineProperty(
					@
					'__notifiable_callbacks'
					value	: []
				)
			@__notifiable_callbacks.push([callback, path])
		@
	..off	= (callback, keys = []) ->
		path	= __notifiable_path_from_keys(keys)
		@__notifiable_callbacks = @__notifiable_callbacks.filter (c) ->
			c[0] != callback && c[1] == path
		@
	..once	= (callback, keys = []) ->
		if callback
			callback_ = ~>
				@off(callback_)
				callback.apply(callback, arguments)
			@on(callback_, keys)
		@
	..fire	= (keys, new_value, old_value) !->
		if @__notifiable_callbacks?.length
			path	= __notifiable_path_from_keys(keys)
			for callback in @__notifiable_callbacks
				if path.indexOf(callback[1]) == 0
					callback[0](keys.slice(), new_value, old_value)
	..set	= (key, value) ->
		if value instanceof Object
			@[key] = new Notifiable(value, @, key)
		else
			@[key] = value
		Wrap(@, key)
		@
# Export
cs.{}Docplater.Notifiable = Notifiable
