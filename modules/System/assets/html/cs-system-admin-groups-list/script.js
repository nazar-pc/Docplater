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
  var ADMIN_GROUP_ID, USER_GROUP_ID;
  ADMIN_GROUP_ID = 1;
  USER_GROUP_ID = 2;
  Polymer({
    'is': 'cs-system-admin-groups-list',
    behaviors: [cs.Polymer.behaviors.Language('system_admin_groups_')],
    properties: {
      groups: []
    },
    ready: function(){
      this.reload();
    },
    reload: function(){
      var this$ = this;
      cs.api('get api/System/admin/groups').then(function(groups){
        groups.forEach(function(group){
          group.allow_to_delete = group.id != ADMIN_GROUP_ID && group.id != USER_GROUP_ID;
        });
        this$.set('groups', groups);
      });
    },
    add_group: function(){
      cs.ui.simple_modal("<h3>" + this.L.group_addition + "</h3>\n<cs-system-admin-groups-form/>").addEventListener('close', bind$(this, 'reload'));
    },
    edit_group: function(e){
      var group;
      group = e.model.group;
      cs.ui.simple_modal("<h3>" + this.L.editing_group(group.title) + "</h3>\n<cs-system-admin-groups-form group_id=\"" + group.id + "\"/>").addEventListener('close', bind$(this, 'reload'));
    },
    delete_group: function(e){
      var group, this$ = this;
      group = e.model.group;
      cs.ui.confirm(this.L.sure_delete_group(group.title)).then(function(){
        return cs.api('delete api/System/admin/groups/' + group.id);
      }).then(function(){
        cs.ui.notify(this$.L.changes_saved, 'success', 5);
        this$.splice('groups', e.model.index, 1);
      });
    },
    edit_permissions: function(e){
      var group, title;
      group = e.model.group;
      title = this.L.permissions_for_group(group.title);
      cs.ui.simple_modal("<h2>" + title + "</h2>\n<cs-system-admin-permissions-for group=\"" + group.id + "\" for=\"group\"/>");
    }
  });
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
