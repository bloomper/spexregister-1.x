// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.alerts.dialogClass = "alertDialog";

jQuery.noConflict();

jQuery(document).ajaxStart(function() {
    jQuery("#progress-indicator").fadeIn();
});

jQuery(document).ajaxStop(function() {
    jQuery("#progress-indicator").fadeOut();
});

jQuery(function(){
    jQuery('.datepicker').livequery( function() {
        jQuery(this).datepicker({
            showOn: 'button',
            showButtonPanel: true,
            changeMonth: true,
            changeYear: true,
            buttonImage: '/images/calendar.png',
            buttonImageOnly: true
            });
    });
});

jQuery(function(){
    jQuery('a.fancybox-single').livequery( function(){    
        jQuery(this).fancybox({ 
            'hideOnContentClick': true,     
            'overlayShow': false,
            'zoomOpacity': true,
            'zoomSpeedIn': 500,
            'zoomSpeedOut': 500
            });
    });
});
