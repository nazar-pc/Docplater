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
		{selection, range}	= new @scribe_instance.api.Selection
		inline_allowed		= Boolean(range)
		for element in @shadowRoot.querySelectorAll('[inline-tag]')
			element.disabled	= !inline_allowed
		heading_allowed	= Boolean(
			selection.baseNode?.parentNode.matches?('h1, h2, h3, p')
		)
		for element in @shadowRoot.querySelectorAll('[heading-tag]')
			element.disabled	= !heading_allowed
	_inline_tag_toggle : (e) !->
		@ssa.toggle_selection_wrapping_with_tag(e.target.getAttribute('tag'))
	_heading_tag_toggle : (e) !->
		level	= parseInt(e.target.getAttribute('level'))
		if @ssa.is_selection_wrapped_with_tag("h#level") || @ssa.is_selection_wrapped_with_tag('p')
			@ssa.toggle_selection_wrapping_with_tag("h#level", 'p')
		else if level != 1 && @ssa.is_selection_wrapped_with_tag('h1')
			@ssa.toggle_selection_wrapping_with_tag('h1', "h#level")
		else if level != 2 && @ssa.is_selection_wrapped_with_tag('h2')
			@ssa.toggle_selection_wrapping_with_tag('h2', "h#level")
		else if level != 3 && @ssa.is_selection_wrapped_with_tag('h3')
			@ssa.toggle_selection_wrapping_with_tag('h3', "h#level")
)
