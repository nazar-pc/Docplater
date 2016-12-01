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
      is: 'docplater-documents-search',
      behaviors: [cs.Docplater.behaviors.attached_once, reduxBehavior],
      properties: {
        documents: Array
      },
      created: function(){
        var this$ = this;
        this.attached_once.then(function(){
          return cs.api('get api/Docplater_app/documents');
        }).then(function(documents){
          this$.documents = documents;
        });
      },
      _load_document: function(e){
        cs.Docplater.functions.get_document(e.model.item.hash);
      }
    });
  });
}).call(this);
