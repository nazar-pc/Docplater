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
    is: 'docplater-document-clause',
    behaviors: [cs.Docplater.behaviors.attached_once],
    hostAttributes: {
      contenteditable: 'false'
    },
    properties: {
      data: Object,
      hash: String,
      index: Number,
      parameters: Object
    },
    created: function(){
      var this$ = this;
      this.attached_once.then(function(){
        return cs.Docplater.functions.get_clause(this$.hash);
      }).then(function(data){
        this$.data = data;
        this$.$.content.innerHTML = this$.data.content;
      });
    }
  });
}).call(this);
