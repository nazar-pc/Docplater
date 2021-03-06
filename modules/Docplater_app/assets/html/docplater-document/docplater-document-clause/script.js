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
      is: 'docplater-document-clause',
      behaviors: [cs.Docplater.behaviors.attached_once, reduxBehavior],
      hostAttributes: {
        contenteditable: 'false'
      },
      properties: {
        data: Object,
        hash: String,
        instance: Number
      },
      created: function(){
        var this$ = this;
        this.attached_once.then(function(){
          var clause, ref$;
          for (clause in ref$ = this$.getState().document.clauses) {
            clause = ref$[clause];
            if (clause.hash === this$.hash) {
              return clause;
            }
          }
        }).then(function(data){
          this$.data = data;
          this$.$.content.innerHTML = this$.data.content;
        });
      }
    });
  });
}).call(this);
