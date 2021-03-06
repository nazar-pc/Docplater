// Generated by LiveScript 1.4.0
/**
 * @package    CleverStyle Framework
 * @subpackage System module
 * @category   modules
 * @author     Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright  Copyright (c) 2015-2016, Nazar Mokrynskyi
 * @license    MIT License, see license.txt
 */
(function(){
  Polymer({
    is: 'cs-system-admin-users-general',
    behaviors: [cs.Polymer.behaviors.Language('system_admin_users_general_'), cs.Polymer.behaviors.admin.System.settings],
    properties: {
      registration_with_confirmation: {
        computed: '_registration_with_confirmation(settings.allow_user_registration, settings.require_registration_confirmation)',
        type: Boolean
      },
      settings_api_url: 'api/System/admin/users/general'
    },
    _registration_with_confirmation: function(allow_user_registration, require_registration_confirmation){
      return allow_user_registration == 1 && require_registration_confirmation == 1;
    }
  });
}).call(this);
