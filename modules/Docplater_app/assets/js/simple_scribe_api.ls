/**
 * Node contents normalization - will combine together similar nodes next to each other, will also merge child nodes of the same type into parent
 *
 * @param {Node} target_node
 */
!function normalize (target_node)
	target_node.normalize()
	for node in target_node.querySelectorAll('*') by -1
		if node.parentNode && node.nodeName == node.parentNode.nodeName && node.nodeName.indexOf('-') == -1
			for child_node in node.childNodes
				node.insertBefore(child_node, node)
			node.parentNode.removeChild(node)
	target_node.normalize()
	for node in target_node.querySelectorAll('*')
		if node.nextSibling
			if node.nodeType == Node.TEXT_NODE
				if !node.length
					node.parentNode.removeChild(node)
			else if node.nodeType == node.nextSibling.nodeType && node.nodeName.indexOf('-') == -1
				for child_node in node.nextSibling.childNodes
					node.appendChild(child_node)
				node.nextSibling.parentNode.removeChild(node.nextSibling)
/**
 * @param {Node} node
 *
 * @return {Element}
 */
function get_container_element (node)
	if node.nodeType == Node.TEXT_NODE then node.parentNode else node
/**
 * Will shrink specified parent to the range and return parts before range and after it
 *
 * @param {Element}	parent
 * @param {Range}	range
 *
 * {DocumentFragment[]} 2 fragments: before and after
 */
function shrink_to_range (parent, range)
	range_1	= new Range
		..setStartBefore(parent.firstChild || parent)
		..setEnd(range.startContainer, range.startOffset)
	range_2	= new Range
		..setStart(range.endContainer, range.endOffset)
		..setEndAfter(parent.lastChild || parent)
	before	= range_1.extractContents()
	after	= range_2.extractContents()
	[before, after]
/**
 * @param {Element}	element
 * @param {string}	tag
 *
 * @return {Element}
 */
function wrap_with_tag (element, tag)
	tmp = document.createElement(tag)
	tmp.appendChild(element)
	tmp
#define ->
/**
 * @param {Scribe} scribe_instance
 */
!function simple_scribe_api (@scribe_instance)
	fire_state_changed	= !~>
		@scribe_instance.trigger('scribe:state-changed')
	destroyed			= !->
		@scribe_instance.el
			..removeEventListener('keyup', fire_state_changed)
			..removeEventListener('mouseup', fire_state_changed)
			..removeEventListener('focus', fire_state_changed)
			..removeEventListener('blur', fire_state_changed)
		@scribe_instance
			..off('content-changed', fire_state_changed)
			..off('scribe:destroy', destroyed)
	@scribe_instance.el
		..addEventListener('keyup', fire_state_changed)
		..addEventListener('mouseup', fire_state_changed)
		..addEventListener('focus', fire_state_changed)
		..addEventListener('blur', fire_state_changed)
	@scribe_instance
		..on('content-changed', fire_state_changed)
		..on('scribe:destroy', destroyed)
	void
simple_scribe_api::
	/**
	 * Subscribe to event when selection or content changes (not necessary actually changes, but likely so)
	 *
	 * @param {Function} callback
	 */
	..on_state_changed = (callback) !->
		@scribe_instance.on('scribe:state-changed', callback)
	/**
	 * Unsubscribe from event, which was subscribed with `on_state_changed()` method
	 *
	 * @param {Function} callback
	 */
	..off_state_changed = (callback) !->
		@scribe_instance.off('scribe:state-changed', callback)
	/**
	 * Returns selection and range from `Scribe.api.Selection`, but ensures that some text is selected (if not - selects parent element)
	 *
	 * @return {Object} With keys `selection` and `range`
	 */
	..get_normalized_selection_and_range = ->
		{selection, range}	= new @scribe_instance.api.Selection
		if range && !@is_selected_text()
			new_range	= new Range
				..selectNode(range.commonAncestorContainer)
			range		= new_range
			selection
				..removeAllRanges()
				..addRange(range)
		{selection, range}
	/**
	 * Whether text is selected in editor
	 *
	 * @return {bool}
	 */
	..is_selected_text = ->
		range = (new @scribe_instance.api.Selection).range
		Boolean(
			range &&
			(
				range.startContainer != range.endContainer ||
				range.startOffset != range.endOffset
			)
		)
	/**
	 * Whether either no selection or selected text within the same element
	 *
	 * @return {bool}
	 */
	..is_single_element_in_range = ->
		range = (new @scribe_instance.api.Selection).range
		Boolean(
			range &&
			range.startContainer == range.endContainer
		)
	/**
	 * Wrap selected content with element
	 *
	 * @param {Element} element
	 *
	 * @return {bool}
	 */
	..wrap_selection_with_element = (element) ->
		{selection, range}	= @get_normalized_selection_and_range()
		if !range
			return false
		parent_element	= get_container_element(range.commonAncestorContainer)
		element.appendChild(range.extractContents())
		range.insertNode(element)
		new_range	= new Range
			..selectNode(element)
		selection
			..removeAllRanges()
			..addRange(new_range)
		normalize(parent_element)
		true
	/**
	 * Wrap selected content with empty element of specified tag (wrapper for `wrap_selection_with_element`)
	 *
	 * @param {string} tag
	 *
	 * @return {bool}
	 */
	..wrap_selection_with_tag = (tag) ->
		@wrap_selection_with_element(document.createElement(tag))
	/**
	 * Unwrap selected content from specified tag
	 *
	 * @param {string} tag
	 *
	 * @return {bool}
	 */
	..unwrap_selection_with_tag = (tag) ->
		{selection, range}	= @get_normalized_selection_and_range()
		if !range
			return false
		parent_element	= get_container_element(range.commonAncestorContainer)
		[before, after]	= shrink_to_range(parent_element, range)
		fragment		= range.extractContents()
		if parent_element.matches(tag)
			before	= wrap_with_tag(before, tag)
			after	= wrap_with_tag(after, tag)

			fragment.insertBefore(before, fragment.firstChild)
			fragment.appendChild(after)

			new_parent_element	= parent_element.parentNode
			new_parent_element.replaceChild(fragment, parent_element)
			parent_element		= new_parent_element

			new_range	= new Range
			new_range.setStartAfter(before)
			new_range.setEndBefore(after)
			selection
				..removeAllRanges()
				..addRange(new_range)

			if !before.textContent.length
				before.parentNode.removeChild(before)
			if !after.textContent.length
				after.parentNode.removeChild(after)
		else
			for element in fragment.querySelectorAll(tag)
				for child_node in element.childNodes
					element.parentNode.insertBefore(child_node, element)
				element.parentNode.removeChild(element)

			range_start	= fragment.firstChild
			range_end	= fragment.lastChild

			fragment.insertBefore(before, fragment.firstChild)
			fragment.appendChild(after)
			range.insertNode(fragment)

			new_range	= new Range
				..setStartBefore(range_start)
				..setEndAfter(range_end)
			selection
				..removeAllRanges()
				..addRange(new_range)
		normalize(parent_element)
		true
	/**
	 * Whether selection is wrapped with specified tag
	 *
	 * @param {string} tag
	 *
	 * @return {bool}
	 */
	..is_selection_wrapped_with_tag = (tag) ->
		range	= @get_normalized_selection_and_range().range
		if !range
			return false
		parent_element	= get_container_element(range.commonAncestorContainer)
		parent_element.matches("#tag, #tag *")
	/**
	 * Toggle selection wrapping between two of the specified tags (if second tag not specified - wrap and unwrap single tag only)
	 *
	 * @param {string}				tag_1
	 * @param {(string|undefined)}	tag_2
	 */
	..toggle_selection_wrapping_with_tag = (tag_1, tag_2) !->
		if @is_selection_wrapped_with_tag(tag_1)
			@unwrap_selection_with_tag(tag_1)
			if tag_2
				@wrap_selection_with_tag(tag_2)
		else
			if tag_2
				@unwrap_selection_with_tag(tag_2)
			@wrap_selection_with_tag(tag_1)
#	simple_scribe_api
cs.{}Docplater.simple_scribe_api = simple_scribe_api
