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
document.designMode = "off"

# TODO: is necessary until https://github.com/reactjs/redux/pull/2047 is released
requirejs.config(
	packages	: [{
		name		: 'redux'
		main		: 'redux'
		location	: '/storage/Composer/vendor/npm-asset/redux/dist'
	}]
)

# TODO: is necessary until https://github.com/guardian/scribe/pull/503 is resolved
define('scribe-editor/src/api/selection', ['Docplater_app/hacks/scribe-editor/src/api/selection'], -> it)

# TODO: is necessary until https://github.com/guardian/scribe-plugin-inline-styles-to-elements/issues/6 is resolved
define('scribe-plugin-inline-styles-to-elements/inline-styles-formatter', ['inline-styles-formatter'], -> it)
define('scribe-plugin-inline-styles-to-elements/as-html-formatter', ['as-html-formatter'], -> it)
