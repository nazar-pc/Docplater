// Generated by LiveScript 1.4.0
/**
 * @package   Docplater app
 * @category  modules
 * @author    Nazar Mokrynskyi <nazar@mokrynskyi.com>
 * @copyright Copyright (c) 2016, Nazar Mokrynskyi
 * @license   AGPL-3.0, see license.txt
 */
(function(){
  var Event, Parameter;
  Event = cs.Event;
  Parameter = cs.Docplater.Parameter;
  Polymer({
    is: 'docplater-document',
    behaviors: [cs.Docplater.behaviors.parameters, cs.Docplater.behaviors.when_ready],
    properties: {
      hash: '43cc23fa52b87b4cc1d02b5b114154151d6adddb17c9fddc06b027fa99e24008',
      preview: false
    },
    attached: function(){
      var this$ = this;
      require(['scribe'], function(Scribe){
        new Scribe(this$.$.content);
      });
      this.parameters = [
        Parameter({
          name: 'company_name',
          type: Parameter.TYPE_STRING,
          default_value: 'Company name'
        }), Parameter({
          name: 'date',
          type: Parameter.TYPE_DATE
        }), Parameter({
          name: 'description',
          type: Parameter.TYPE_TEXT
        })
      ];
    },
    _toggle_preview: function(){
      this.preview = !this.preview;
      Event.fire('dockplater/document/preview', {
        preview: this.preview
      });
    }
  });
}).call(this);
