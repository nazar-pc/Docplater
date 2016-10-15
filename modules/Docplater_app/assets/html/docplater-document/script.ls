/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
Parameter = cs.Docplater.Parameter
Polymer(
	is			: 'docplater-document'
	properties	:
		preview	: false
	attached : !->
		require(['scribe'], (Scribe) !~>
			new Scribe(@$.content)
		)
	_toggle_preview : !->
		@preview = !@preview
)
