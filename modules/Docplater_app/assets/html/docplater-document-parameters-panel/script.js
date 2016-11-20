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
      is: 'docplater-document-parameters-panel',
      behaviors: [reduxBehavior],
      properties: {
        parameters_map: Array,
        state: {
          statePath: '',
          type: Object
        }
      },
      observers: ['_parameters_map(state.document, state.clauses)'],
      _parameters_map: function(document, clauses){
        var parameters_map, name, parameter, i$, ref$, len$, clause, j$, ref1$, len1$, clause_instance, parameters;
        if (this._skip_render) {
          this._skip_render = false;
          return;
        }
        parameters_map = [{
          'for': 'Document',
          parameters: (function(){
            var ref$, own$ = {}.hasOwnProperty, results$ = [];
            for (name in ref$ = document.parameters) if (own$.call(ref$, name)) {
              parameter = ref$[name];
              results$.push(parameter.merge({
                name: name
              }));
            }
            return results$;
          }())
        }];
        for (i$ = 0, len$ = (ref$ = document.clauses).length; i$ < len$; ++i$) {
          clause = ref$[i$];
          if (clause.instances.length) {
            for (j$ = 0, len1$ = (ref1$ = clause.instances).length; j$ < len1$; ++j$) {
              clause_instance = j$;
              parameters = ref1$[j$];
              parameters_map.push({
                'for': clause.title + ' #' + clause_instance,
                parameters: (fn$())
              });
            }
          }
        }
        this.parameters_map = parameters_map;
        function fn$(){
          var ref$, own$ = {}.hasOwnProperty, results$ = [];
          for (name in ref$ = parameters) if (own$.call(ref$, name)) {
            parameter = ref$[name];
            results$.push(parameter.merge({
              name: name,
              clause_hash: clause.hash,
              clause_instance: clause_instance
            }));
          }
          return results$;
        }
      },
      _parameter_highlight: function(e){
        this.dispatch({
          type: 'PARAMETER_HIGHLIGHT',
          name: e.model.parameter.name,
          clause_hash: e.model.parameter.clause_hash,
          clause_instance: e.model.parameter.clause_instance
        });
      },
      _parameter_unhighlight: function(){
        this.dispatch({
          type: 'PARAMETER_UNHIGHLIGHT'
        });
      },
      _parameter_changed: function(e){
        this._skip_render = true;
        this.dispatch({
          type: 'PARAMETER_UPDATE_VALUE',
          name: e.model.parameter.name,
          clause_hash: e.model.parameter.clause_hash,
          clause_instance: e.model.parameter.clause_instance,
          value: e.target.value
        });
      },
      _add_parameter: function(){
        var this$ = this;
        cs.ui.prompt('New parameter name (without @ prefix):').then(function(name){
          this$.dispatch({
            type: 'PARAMETER_ADD',
            name: name
          });
        });
      },
      _edit_parameter: function(e){
        var name, this$ = this;
        name = e.model.parameter.name;
        cs.ui.prompt("Default value for parameter " + name + ":").then(function(default_value){
          this$.dispatch({
            type: 'PARAMETER_SET_DEFAULT_VALUE',
            name: name,
            clause_hash: e.model.parameter.clause_hash,
            clause_instance: e.model.parameter.clause_instance,
            default_value: default_value
          });
        });
      },
      _delete_parameter: function(e){
        var name, this$ = this;
        name = e.model.parameter.name;
        cs.ui.confirm("Are you sure you want to delete parameter @" + name + "?").then(function(){
          this$.dispatch({
            type: 'PARAMETER_DELETE',
            name: name
          });
        });
      }
    });
  });
}).call(this);
