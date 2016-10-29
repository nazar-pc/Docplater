// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  Polymer({
    is: 'docplate-document-toolbar',
    properties: {
      scribe_instance: {
        observer: '_scribe_instance',
        type: Object
      }
    },
    _scribe_instance: function(){
      var this$ = this;
      require(['scribe-plugin-toolbar']).then(function(arg$){
        var scribePluginToolbar;
        scribePluginToolbar = arg$[0];
        this$.scribe_instance.use(scribePluginToolbar(this$.$.toolbar));
        this$.ssa = new cs.Docplater.simple_scribe_api(this$.scribe_instance);
        this$.ssa.on_state_changed(function(){
          if (this$._state_changed_timeout) {
            clearTimeout(this$._state_changed_timeout);
          }
          this$._state_changed_timeout = setTimeout(function(){
            this$._state_changed();
          });
        });
      });
    },
    _state_changed: function(){
      var inline_allowed, i$, ref$, len$, element;
      inline_allowed = Boolean((new this.scribe_instance.api.Selection).range);
      for (i$ = 0, len$ = (ref$ = this.shadowRoot.querySelectorAll('[inline-tag]')).length; i$ < len$; ++i$) {
        element = ref$[i$];
        element.disabled = !inline_allowed;
      }
    },
    _inline_tag_toggle: function(e){
      this.ssa.toggle_selection_wrapping_with_tag(e.target.getAttribute('tag'));
    }
  });
}).call(this);