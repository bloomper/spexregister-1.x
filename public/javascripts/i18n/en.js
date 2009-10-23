// English
jQuery(function() {
   /*
   // jQuery Lightbox
   jQuery('a[@rel*=lightbox]').lightBox({
      imageLoading:     '/images/jquery.lightbox/lightbox-ico-loading.gif',
      imageBtnPrev:     '/images/jquery.lightbox/lightbox-btn-prev_en.gif',
      imageBtnNext:     '/images/jquery.lightbox/lightbox-btn-next_en.gif',
      imageBtnClose:    '/images/jquery.lightbox/lightbox-btn-close_en.gif',
      imageBlank:       '/images/jquery.lightbox/lightbox-blank.gif',
      txtImage:         'Image',
      txtOf:            'of',
      keyToClose:       'c',
      keyToPrev:        'p',
      keyToNext:        'n'
   });
   */

    // jQuery Alerts
   jQuery.alerts.okButton = '&nbsp;OK&nbsp;';
   jQuery.alerts.cancelButton = '&nbsp;Cancel&nbsp;';

   // jQuery Date Picker
   jQuery.datepicker.regional['en'] = {
           closeText: 'Done',
           prevText: '&laquo;Prev',
           nextText: 'Next&raquo;',
           currentText: 'Today',
           monthNames: ['January','February','March','April','May','June','July','August','September','October','November','December'],
           monthNamesShort: ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
           dayNamesShort: ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
           dayNames: ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
           dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'],
           dateFormat: 'yy-mm-dd', firstDay: 0,
           isRTL: false};
   jQuery.datepicker.setDefaults(jQuery.datepicker.regional['en']);
});
