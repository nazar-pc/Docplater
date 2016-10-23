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
    is: 'cs-system-admin-blocks-list',
    behaviors: [cs.Polymer.behaviors.Language('system_admin_blocks_')],
    properties: {
      blocks: Object,
      blocks_count: Number
    },
    ready: function(){
      this._reload();
    },
    _init_sortable: function(){
      var this$ = this;
      require(['html5sortable'], function(html5sortable){
        var group;
        if (this$.blocks_count === undefined || this$.shadowRoot.querySelectorAll('[group] > div:not(:first-child)').length < this$.blocks_count) {
          setTimeout(bind$(this$, '_init_sortable'), 100);
          return;
        }
        group = this$.shadowRoot.querySelectorAll('[group]');
        html5sortable(this$.shadowRoot.querySelectorAll('[group]'), {
          connectWith: 'blocks-list',
          items: 'div:not(:first-child)',
          placeholder: '<div class="cs-block-primary"/>'
        })[0].addEventListener('sortupdate', function(){
          var get_indexes, order;
          get_indexes = function(group){
            return [].map.call(this$.shadowRoot.querySelectorAll("[group=" + group + "] > div:not(:first-child)"), function(it){
              return it.index;
            });
          };
          order = {
            top: get_indexes('top'),
            left: get_indexes('left'),
            floating: get_indexes('floating'),
            right: get_indexes('right'),
            bottom: get_indexes('bottom')
          };
          cs.api('update_order api/System/admin/blocks', {
            order: order
          }).then(function(){
            cs.ui.notify(this$.L.changes_saved, 'success', 5);
          });
        });
      });
    },
    _status_class: function(active){
      if (active == 1) {
        return 'cs-block-success cs-text-success';
      } else {
        return 'cs-block-warning cs-text-warning';
      }
    },
    _reload: function(){
      var this$ = this;
      cs.api('get api/System/admin/blocks').then(function(blocks){
        var blocks_grouped, i$, len$, index, block;
        this$.blocks_count = blocks.length;
        blocks_grouped = {
          top: [],
          left: [],
          floating: [],
          right: [],
          bottom: []
        };
        for (i$ = 0, len$ = blocks.length; i$ < len$; ++i$) {
          index = i$;
          block = blocks[i$];
          blocks_grouped[block.position].push(block);
        }
        this$.set('blocks', blocks_grouped);
        this$._init_sortable();
      });
    },
    _block_permissions: function(e){
      var title;
      title = this.L.permissions_for_block(e.model.item.title);
      cs.ui.simple_modal("<h3>" + title + "</h3>\n<cs-system-admin-permissions-for-item label=\"" + e.model.item.index + "\" group=\"Block\"/>");
    },
    _add_block: function(){
      cs.ui.simple_modal("<h3>" + this.L.block_addition + "</h3>\n<cs-system-admin-blocks-form/>").addEventListener('close', bind$(this, '_reload'));
    },
    _edit_block: function(e){
      var title;
      title = this.L.editing_block(e.model.item.title);
      cs.ui.simple_modal("<h3>" + title + "</h3>\n<cs-system-admin-blocks-form index=\"" + e.model.item.index + "\"/>").addEventListener('close', bind$(this, '_reload'));
    },
    _delete_block: function(e){
      var this$ = this;
      cs.ui.confirm(this.L.sure_to_delete_block(e.model.item.title)).then(function(){
        return cs.api('delete api/System/admin/blocks/' + e.model.item.index);
      }).then(function(){
        cs.ui.notify(this$.L.changes_saved, 'success', 5);
        this$._reload();
      });
    }
  });
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
}).call(this);
