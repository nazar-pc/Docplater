// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  cs.Docplater.Redux.behavior.then(function(reduxBehavior){
    Polymer({
      is: 'docplater-document',
      behaviors: [cs.Docplater.behaviors.attached_once, reduxBehavior],
      properties: {
        document: {
          statePath: 'document',
          type: Object
        },
        hash: String,
        preview: {
          statePath: 'preview',
          type: Boolean
        }
      },
      created: function(){
        var this$ = this;
        this.attached_once.then(function(){
          return cs.Docplater.functions.get_document(this$.hash);
        }).then(function(){
          this$._init_scribe();
        });
      },
      _init_scribe: function(){
        var this$ = this;
        if (this.scribe_instance) {
          return;
        }
        require(['scribe-editor', 'scribe-plugin-inline-styles-to-elements', 'scribe-plugin-sanitizer', 'scribe-plugin-tab-indent']).then(function(arg$){
          var scribeEditor, scribePluginInlineStylesToElements, scribePluginSanitizer, scribePluginTabIndent, x$;
          scribeEditor = arg$[0], scribePluginInlineStylesToElements = arg$[1], scribePluginSanitizer = arg$[2], scribePluginTabIndent = arg$[3];
          this$.scribe_instance = new scribeEditor(this$.$.content);
          x$ = this$.scribe_instance;
          x$.use(scribePluginInlineStylesToElements());
          x$.use(scribePluginSanitizer({
            tags: cs.Docplater.functions.fill_tags_attributes(cs.Docplater.functions.get_list_of_allowed_tags())
          }));
          x$.use(scribePluginTabIndent());
          x$.setHTML(this$.document.content);
        });
      },
      _toggle_preview: function(){
        this.dispatch({
          type: 'PREVIEW_TOGGLE'
        });
      }
    });
  });
}).call(this);
