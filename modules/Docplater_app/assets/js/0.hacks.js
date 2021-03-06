// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  document.designMode = "on";
  document.execCommand('enableObjectResizing', false, 'false');
  document.execCommand("enableInlineTableEditing", false, "false");
  document.designMode = "off";
  requirejs.config({
    packages: [{
      name: 'redux',
      main: 'redux',
      location: '/storage/Composer/vendor/npm-asset/redux/dist'
    }]
  });
  define('scribe-editor/src/api/selection', ['Docplater_app/hacks/scribe-editor/src/api/selection'], function(it){
    return it;
  });
  define('scribe-plugin-inline-styles-to-elements/inline-styles-formatter', ['inline-styles-formatter'], function(it){
    return it;
  });
  define('scribe-plugin-inline-styles-to-elements/as-html-formatter', ['as-html-formatter'], function(it){
    return it;
  });
}).call(this);
