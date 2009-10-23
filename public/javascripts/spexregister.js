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
    jQuery('.datepicker').live('click', function() {
        jQuery(this).datepicker({showOn: 'focus', showButtonPanel: true, changeMonth: true, changeYear: true}).focus();
    });
});
