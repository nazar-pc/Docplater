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
          type: Object,
          observer: '_document_changed'
        },
        hash: String,
        scribe_instance: {
          notify: true,
          type: Object
        }
      },
      created: function(){
        var this$ = this;
        this.attached_once.then(function(){
          if (this$.hash) {
            cs.Docplater.functions.get_document(this$.hash);
          }
        }).then(function(){
          this$.scopeSubtree(this$.$.content, true);
          this$._init_scribe();
        });
      },
      _document_changed: function(){
        if (this.scribe_instance && this.document.hash !== this.hash) {
          this.hash = this.document.hash;
          this.scribe_instance.setContent(this.document.content);
        }
      },
      _init_scribe: function(){
        var this$ = this;
        if (this.scribe_instance) {
          this.scribe_instance.setContent(this.document.content);
          return;
        }
        require(['scribe-editor', 'scribe-plugin-inline-styles-to-elements', 'scribe-plugin-keyboard-shortcuts', 'scribe-plugin-sanitizer', 'scribe-plugin-tab-indent']).then(function(arg$){
          var scribeEditor, scribePluginInlineStylesToElements, scribePluginKeyboardShortcuts, scribePluginSanitizer, scribePluginTabIndent, x$;
          scribeEditor = arg$[0], scribePluginInlineStylesToElements = arg$[1], scribePluginKeyboardShortcuts = arg$[2], scribePluginSanitizer = arg$[3], scribePluginTabIndent = arg$[4];
          this$.scribe_instance = new scribeEditor(this$.$.content);
          x$ = this$.scribe_instance;
          x$.use(scribePluginInlineStylesToElements());
          x$.use(scribePluginKeyboardShortcuts());
          x$.use(scribePluginSanitizer({
            tags: cs.Docplater.functions.fill_tags_attributes(cs.Docplater.functions.get_list_of_allowed_tags())
          }));
          x$.use(scribePluginTabIndent());
          x$.setHTML(this$.document.content);
        });
      }
    });
  });
}).call(this);
