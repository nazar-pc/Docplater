// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  var Immutable, initial_state, Redux, ref$;
  Immutable = null;
  initial_state = {
    document: {
      clauses: [],
      content: '<p></p>',
      parameters: {}
    },
    preview: true
  };
  Redux = (ref$ = cs.Docplater || (cs.Docplater = {})).Redux || (ref$.Redux = {});
  Redux.store = require(['redux', 'seamless-immutable']).then(function(arg$){
    var redux, seamlessImmutable;
    redux = arg$[0], seamlessImmutable = arg$[1];
    Immutable = seamlessImmutable;
    initial_state = Immutable(initial_state);
    return redux.createStore(reducer);
  });
  Redux.behavior = Promise.all([Redux.store, require(['polymer-redux'])]).then(function(arg$){
    var store, polymerRedux;
    store = arg$[0], polymerRedux = arg$[1][0];
    return polymerRedux(store);
  });
  function get_full_parameter_path(state, parameter, clause_hash, clause_instance){
    var clause_index, ref$, clause;
    if (clause_hash) {
      for (clause_index in ref$ = state.document.clauses) {
        clause = ref$[clause_index];
        if (clause.hash === clause_hash) {
          return ['document', 'clauses', clause_index, 'instances', clause_instance, parameter];
        }
      }
      throw 'No clause in document';
    } else {
      return ['document', 'parameters', parameter];
    }
  }
  function reducer(state, action){
    var parameters, i$, ref$, len$, parameter, clause_index, clause, highlighted_parameter;
    state == null && (state = initial_state);
    switch (action.type) {
    case 'DOCUMENT_LOADED':
      return state.set('document', action.document);
    case 'CLAUSE_ADD_INSTANCE':
      parameters = {};
      for (i$ = 0, len$ = (ref$ = action.clause.parameters).length; i$ < len$; ++i$) {
        parameter = ref$[i$];
        parameters[parameter] = {
          value: '',
          default_value: ''
        };
      }
      for (clause_index in ref$ = state.document.clauses) {
        clause = ref$[clause_index];
        if (clause.hash === action.clause.hash) {
          return state.setIn(['document', 'clauses', clause_index, 'instances', parseInt(Object.keys(clause.instances).pop()) + 1], parameters);
        }
      }
      return state.setIn(['document', 'clauses', state.document.clauses.length], {
        hash: action.clause.hash,
        title: action.clause.title,
        content: action.clause.content,
        instances: {
          0: parameters
        }
      });
    case 'PARAMETER_HIGHLIGHT':
      if (state.highlighted_parameter) {
        state = state.setIn(state.highlighted_parameter.concat('highlight'), false);
      }
      highlighted_parameter = get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance);
      return state.set('highlighted_parameter', highlighted_parameter).setIn(highlighted_parameter.concat('highlight'), true);
    case 'PARAMETER_UNHIGHLIGHT':
      if (state.highlighted_parameter) {
        return state.setIn(state.highlighted_parameter.concat('highlight'), false).set('highlighted_parameter');
      } else {
        return state;
      }
      break;
    case 'PARAMETER_ADD':
      return state.setIn(['document', 'parameters', action.name], {
        value: '',
        default_value: ''
      });
    case 'PARAMETER_SET_DEFAULT_VALUE':
      parameter = get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance);
      return state.setIn(parameter.concat('default_value'), action.default_value);
    case 'PARAMETER_DELETE':
      return state.setIn(['document', 'parameters'], state.document.parameters.without(action.name));
    case 'PARAMETER_UPDATE_VALUE':
      parameter = get_full_parameter_path(state, action.name, action.clause_hash, action.clause_instance);
      return state.setIn(parameter.concat('value'), action.value);
    case 'PREVIEW_TOGGLE':
      return state.merge({
        preview: !state.preview
      });
    default:
      return state;
    }
  }
}).call(this);
