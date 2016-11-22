// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  var loading_clauses, x$, ref$;
  loading_clauses = {};
  x$ = (ref$ = cs.Docplater || (cs.Docplater = {})).functions || (ref$.functions = {});
  x$.get_clause = function(clause_hash){
    return cs.Docplater.Redux.store.then(function(store){
      var state;
      state = store.getState();
      if (state.clauses[clause_hash]) {
        return state.clauses[clause_hash];
      } else if (loading_clauses[clause_hash]) {
        return loading_clauses[clause_hash];
      } else {
        return loading_clauses[clause_hash] = cs.api("get api/Docplater_app/clauses/" + clause_hash).then(function(clause){
          delete loading_clauses[clause_hash];
          store.dispatch({
            type: 'CLAUSE_LOADED',
            clause: clause
          });
          return clause;
        });
      }
    });
  };
  x$.get_document = function(document_hash){
    return cs.Docplater.Redux.store.then(function(store){
      return cs.api("get api/Docplater_app/documents/" + document_hash).then(function(document){
        store.dispatch({
          type: 'DOCUMENT_LOADED',
          document: document
        });
        return document;
      });
    });
  };
  x$.rx = {
    hash: function(it){
      return this.test(it);
    }.bind(/^[0-9a-f]{40}$/),
    number: function(it){
      return this.test(it);
    }.bind(/^[0-9]+$/)
  };
  x$.get_list_of_allowed_tags = function(){
    var list, tags, i$, len$, tag;
    list = ['p', 'div', 'b', 'strong', 'i', 'em', 'u', 's', 'strike', 'sup', 'sub', 'img', 'br', 'table', 'thead', 'tbody', 'tr', 'th', 'td', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'docplater-document-clause', 'docplater-document-parameter'];
    tags = {};
    for (i$ = 0, len$ = list.length; i$ < len$; ++i$) {
      tag = list[i$];
      tags[tag] = {};
    }
    return tags;
  };
  x$.fill_tags_attributes = function(tags){
    var map, tag, attributes, attribute, attribute_value;
    map = {
      td: {
        colspan: this.rx.number,
        rowspan: this.rx.number
      },
      'docplater-document-clause': {
        contenteditable: 'false',
        tabindex: 0,
        hash: this.rx.hash,
        instance: this.rx.number
      },
      'docplater-document-parameter': {
        contenteditable: 'false',
        tabindex: 0
      }
    };
    for (tag in map) {
      attributes = map[tag];
      for (attribute in attributes) {
        attribute_value = attributes[attribute];
        if (attribute_value instanceof Object) {
          tags[tag][attribute] = attribute_value;
        } else {
          tags[tag][attribute] = true;
        }
      }
    }
    return tags;
  };
}).call(this);
