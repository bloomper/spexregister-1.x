// English
$(function() {
   $('a[@rel*=lightbox]').lightBox({
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
   $.alerts.okButton = '&nbsp;OK&nbsp;';
   $.alerts.cancelButton = '&nbsp;Cancel&nbsp;';
});
