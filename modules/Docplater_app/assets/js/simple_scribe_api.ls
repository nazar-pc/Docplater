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
 * {Element[]}
 */
function shrink_to_range (parent, range)
	range_1	= new Range
	range_1.setStartBefore(parent.firstChild || parent)
	range_1.setEnd(range.startContainer, range.startOffset)
	range_2	= new Range
	range_2.setStart(range.endContainer, range.endOffset)
	range_2.setEndAfter(parent.lastChild || parent)
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
	void
simple_scribe_api::
	/**
	 * Whether text is selected in editor
	 *
	 * @return {bool}
	 */
	..selected_text = ->
		range = (new @scribe_instance.api.Selection).range
		Boolean(
			range &&
			(
				range.startContainer != range.endContainer ||
				range.startOffset != range.endOffset
			)
		)
	/**
	 * Wrap selected content with element
	 *
	 * @param {Element} element
	 *
	 * @return {bool}
	 */
	..wrap_selection_with_element = (element) ->
		if !@selected_text()
			return false
		range			= (new @scribe_instance.api.Selection).range
		parent_element	= get_container_element(range.commonAncestorContainer)
		element.appendChild(range.extractContents())
		range.insertNode(element)
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
		if !@selected_text()
			return false
		{selection, range}	= new @scribe_instance.api.Selection
		parent_element		= get_container_element(range.commonAncestorContainer)
		[before, after]		= shrink_to_range(parent_element, range)
		fragment			= range.extractContents()
		if parent_element.matches(tag)
			before	= wrap_with_tag(before, tag)
			after	= wrap_with_tag(after, tag)

			fragment.insertBefore(before, fragment.firstChild)
			fragment.appendChild(after)

			parent_element.parentNode.replaceChild(fragment, parent_element)

			new_range	= new Range
			new_range.setStartAfter(before)
			new_range.setEndBefore(after)
			selection
				..removeAllRanges()
				..addRange(new_range)
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
			new_range.setStartBefore(range_start)
			new_range.setEndAfter(range_end)
			selection
				..removeAllRanges()
				..addRange(new_range)
		normalize(parent_element)
		true
#	simple_scribe_api
cs.{}Docplater.simple_scribe_api = simple_scribe_api
