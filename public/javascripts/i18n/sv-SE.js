// Swedish
$(function() {
   $('a[@rel*=lightbox]').lightBox({
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
   $.alerts.okButton = '&nbsp;OK&nbsp;';
   $.alerts.cancelButton = '&nbsp;Avbryt&nbsp;';
});
