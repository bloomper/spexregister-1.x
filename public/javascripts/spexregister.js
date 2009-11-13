// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.alerts.dialogClass = "alertDialog";

jQuery.noConflict();

jQuery(document).ajaxStart(function() {
	jQuery('#progress-indicator').fadeIn();
});

jQuery(document).ajaxStop(function() {
	jQuery('#progress-indicator').fadeOut();
});

jQuery(function() {
	jQuery('.datepicker').livequery(function() {
		jQuery(this).datepicker( {
			showOn : 'button',
			showButtonPanel : true,
			changeMonth : true,
			changeYear : true,
			buttonImage : '/images/calendar.png',
			buttonImageOnly : true
		});
	});
});

jQuery(function() {
	jQuery('.datepicker-birthdate').livequery(function() {
		jQuery(this).datepicker( {
			showOn : 'button',
			showButtonPanel : true,
			changeMonth : true,
			changeYear : true,
			buttonImage : '/images/calendar.png',
			buttonImageOnly : true,
			yearRange : '-150:0',
			constrainInput : false
		});
	});
});

jQuery(function() {
	jQuery('a.fancybox-single').livequery(function() {
		jQuery(this).fancybox( {
			'hideOnContentClick' : true,
			'overlayShow' : true,
			'zoomOpacity' : true,
			'zoomSpeedIn' : 500,
			'zoomSpeedOut' : 500
		});
	});
});

jQuery(function() {
	jQuery('a.fancybox-text').livequery(function() {
		jQuery(this).fancybox( {
			'hideOnContentClick' : true,
			'overlayShow' : true,
			'zoomOpacity' : true,
			'zoomSpeedIn' : 500,
			'zoomSpeedOut' : 500
		});
	});
});

jQuery(function() {
	jQuery('input[type=checkbox]').livequery(function() {
		jQuery(this).checkbox();
	});
});

jQuery(function() {
	jQuery('.multiselect-usergroups').livequery(function() {
		jQuery(this).multiselect( {
			'searchable' : false,
			'sortable' : false
		});
	});
});

jQuery.extend( {
	fetch_functions_by_category : function(category, nameElement) {
	  var nameSelect = jQuery('select#' + nameElement);
	  if(category == '') {
		  nameSelect.html('').attr('disabled', 'disabled');
	  } else {
		  jQuery.getJSON('/functions', {'search[function_category_id_equals]': category, format: 'json', 'search[order]': 'asscend_by_name'}, function(j) {
			  nameSelect.addOption('', '');
		      for (var i = 0; i < j.length; i++) {
		    	  nameSelect.addOption(j[i].function.id, j[i].function.name, false);
		      }
		      nameSelect.removeAttr('disabled');
		  });
	  }
   }
});

jQuery.extend( {
	fetch_spex_by_category : function(category, showRevivals, yearElement, titleElement) {
	  var yearSelect = jQuery('select#' + yearElement);
	  var titleSelect = jQuery('select#' + titleElement);
	  if(category == '') {
		  yearSelect.html('').attr('disabled', 'disabled');
		  titleSelect.html('').attr('disabled', 'disabled');
	  } else {
		  jQuery.getJSON('/spex', {'search[spex_category_id_equals]': category, 'search[is_revival_equals]': showRevivals, format: 'json', 'search[order]': 'ascend_by_title'}, function(j) {
			  yearSelect.addOption('', '');
		      for (var i = 0; i < j.length; i++) {
		    	  yearSelect.addOption(j[i].spex.id, j[i].spex.year, false);
		      }
		      yearSelect.sortOptions();
		      titleSelect.addOption('', '');
		      for (var i = 0; i < j.length; i++) {
		    	  titleSelect.addOption(j[i].spex.id, j[i].spex.title, false);
		      }
			  yearSelect.removeAttr('disabled');
			  titleSelect.removeAttr('disabled');
		  });
	  }
   }
});
