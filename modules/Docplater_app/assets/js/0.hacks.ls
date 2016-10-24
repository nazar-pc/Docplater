/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
# Disable controls for tables editing in Firefox
document.designMode = "on"
document.execCommand('enableObjectResizing', false, 'false')
document.execCommand("enableInlineTableEditing", false, "false")
requirejs.config(
	# TODO: is necessary until https://github.com/reactjs/redux/pull/2047 is released
	packages	: [
		{
			name		: 'redux'
			main		: 'redux'
			location	: '/storage/Composer/vendor/npm-asset/redux/dist'
		}
	]
)
