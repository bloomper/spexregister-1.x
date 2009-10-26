// Swedish
jQuery(function() {
   // jQuery Alerts
   jQuery.alerts.okButton = '&nbsp;OK&nbsp;';
   jQuery.alerts.cancelButton = '&nbsp;Avbryt&nbsp;';

   // jQuery Date Picker
   jQuery.datepicker.regional['sv'] = {
           closeText: 'Stäng',
           prevText: '&laquo;Förra',
           nextText: 'Nästa&raquo;',
           currentText: 'Idag',
           monthNames: ['Januari','Februari','Mars','April','Maj','Juni', 'Juli','Augusti','September','Oktober','November','December'],
           monthNamesShort: ['Jan','Feb','Mar','Apr','Maj','Jun','Jul','Aug','Sep','Okt','Nov','Dec'],
           dayNamesShort: ['Sön','Mån','Tis','Ons','Tor','Fre','Lör'],
           dayNames: ['Söndag','Måndag','Tisdag','Onsdag','Torsdag','Fredag','Lördag'],
           dayNamesMin: ['Sö','Må','Ti','On','To','Fr','Lö'],
           dateFormat: 'yy-mm-dd', firstDay: 1,
           isRTL: false};
   jQuery.datepicker.setDefaults(jQuery.datepicker.regional['sv']);
});
