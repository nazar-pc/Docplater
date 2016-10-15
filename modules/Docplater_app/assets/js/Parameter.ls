/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
/**
 * @param {Object}	args
 * @param {string}	args.name			String name of parameter without `@` prefix
 * @param {number}	args.type			One of Parameter.TYPE_* constants
 * @param {string}	args.value
 * @param {string}	args.default_value
 */
!function Parameter (args)
	if @ == window
		return new Parameter(args)
	{@name, @type, @value, @default_value} = args
Parameter::
	..TYPE_STRING	= 0
	..TYPE_NUMBER	= 1
	..TYPE_DATE		= 2
	..TYPE_TEXT		= 3
# Export
cs.{}Docplater.Parameter = Parameter
