/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Polymer(
	is				: 'docplate-document-toolbar'
	properties		:
		scribe_instance	:
			observer	: '_scribe_instance'
			type		: Object
	_scribe_instance : !->
		require(['scribe-plugin-toolbar']).then ([scribe-plugin-toolbar]) !~>
			@scribe_instance.use(scribe-plugin-toolbar(@$.toolbar))
			@ssa	= new cs.Docplater.simple_scribe_api(@scribe_instance)
			@ssa.on_state_changed(!~>
				if @_state_changed_timeout
					clearTimeout(@_state_changed_timeout)
				@_state_changed_timeout = setTimeout(!~>
					@_state_changed()
				)
			)
	_state_changed : !->
		inline_allowed	= Boolean((new @scribe_instance.api.Selection).range)
		for element in @shadowRoot.querySelectorAll('[inline-tag]')
			element.disabled	= !inline_allowed
	_inline_tag_toggle : (e) !->
		@ssa.toggle_selection_wrapping_with_tag(e.target.getAttribute('tag'))
)
