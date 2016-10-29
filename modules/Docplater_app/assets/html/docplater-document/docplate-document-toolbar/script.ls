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
)
