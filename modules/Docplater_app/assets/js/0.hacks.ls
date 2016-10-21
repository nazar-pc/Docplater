/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
requirejs.config(
	paths	:
		# TODO: full path shouldn't be used, but it is necessary until https://github.com/reactjs/redux/pull/2047 is merged and released
		redux					: '/storage/Composer/vendor/npm-asset/redux/dist/redux'
		# TODO: full path shouldn't be used, but it is necessary until https://github.com/rtfeldman/seamless-immutable/issues/164 is fixed and released
#		'seamless-immutable'	: '/storage/Composer/vendor/npm-asset/seamless-immutable/seamless-immutable.production.min'
)
