// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  /**
   * @param {Element}	element
   * @param {string}	selector
   *
   * @return {(Element|null)}
   */
  var x$, ref$;
  function find_parent(element, selector){
    while (element) {
      element = element.parentNode || element.host;
      if (element instanceof Element && element.matches(selector)) {
        return element;
      }
    }
    return null;
  }
  x$ = (ref$ = cs.Docplater || (cs.Docplater = {})).behaviors || (ref$.behaviors = {});
  x$.document = {
    properties: {
      document: Object
    },
    attached: function(){
      this.set('document', find_parent(this, 'docplater-document'));
    }
  };
  x$.document_clause = {
    properties: {
      clause: Object
    },
    attached: function(){
      this.set('clause', find_parent(this, 'docplater-document-clause'));
    }
  };
  x$.parameters = {
    properties: {
      parameters: {
        notify: true,
        type: Array
      }
    },
    get_parameter: function(name){
      var i$, ref$, len$, parameter;
      for (i$ = 0, len$ = (ref$ = this.parameters).length; i$ < len$; ++i$) {
        parameter = ref$[i$];
        if (parameter.name === name) {
          return parameter;
        }
      }
      return null;
    }
  };
  x$.when_ready = {
    created: function(){
      var this$ = this;
      this.when_ready = new Promise(function(_when_ready_resolve){
        this$._when_ready_resolve = _when_ready_resolve;
      });
    },
    attached: function(){
      if (this._when_ready_resolve) {
        this._when_ready_resolve();
        delete this._when_ready_resolve;
      }
    }
  };
}).call(this);
