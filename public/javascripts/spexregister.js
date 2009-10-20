// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.noConflict();

jQuery(document).ajaxStart(function() {
    jQuery("#progress-indicator").fadeIn();
});

jQuery(document).ajaxStop(function() {
    jQuery("#progress-indicator").fadeOut();
});