// Swedish
jQuery(function() {
   /*
   // jQuery Lightbox
   jQuery('a[@rel*=lightbox]').lightBox({
      imageLoading:     '/images/jquery.lightbox/lightbox-ico-loading.gif',
      imageBtnPrev:     '/images/jquery.lightbox/lightbox-btn-prev_sv.gif',
      imageBtnNext:     '/images/jquery.lightbox/lightbox-btn-next_sv.gif',
      imageBtnClose:    '/images/jquery.lightbox/lightbox-btn-close_sv.gif',
      imageBlank:       '/images/jquery.lightbox/lightbox-blank.gif',
      txtImage:         'Bild',
      txtOf:            'av',
      keyToClose:       's',
      keyToPrev:        'f',
      keyToNext:        'n'
   });
   */

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
