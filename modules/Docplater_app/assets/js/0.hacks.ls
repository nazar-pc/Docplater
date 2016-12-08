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

# TODO: is necessary until https://github.com/rtfeldman/seamless-immutable/issues/164 is resolved
window.{}process.{}env.NODE_ENV = ''

# TODO: is necessary until https://github.com/rtfeldman/seamless-immutable/issues/117 is resolved
delete requirejs.contexts._.config.paths['seamless-immutable']
delete requirejs.contexts._.config.pkgs['seamless-immutable']
define('seamless-immutable', ['/storage/Composer/vendor/npm-asset/seamless-immutable/src/seamless-immutable.js'], -> window.Immutable)

# TODO: is necessary until https://github.com/guardian/scribe-plugin-inline-styles-to-elements/issues/6 is resolved
define('scribe-plugin-inline-styles-to-elements/inline-styles-formatter', ['inline-styles-formatter'], -> it)
define('scribe-plugin-inline-styles-to-elements/as-html-formatter', ['as-html-formatter'], -> it)
