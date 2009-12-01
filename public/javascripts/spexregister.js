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
	fetchFunctionsByCategory : function(category, nameElement, addEmptyFirst) {
	  var nameSelect = jQuery('select#' + nameElement);
	  nameSelect.html('').attr('disabled', 'disabled');
	  if(category != '') {
		  jQuery.getJSON('/functions', {'search[function_category_id_equals]': category, format: 'json', 'search[order]': 'ascend_by_name'}, function(j) {
			  if (addEmptyFirst) {
			      nameSelect.addOption('', '');
			  }
		      for (var i = 0; i < j.length; i++) {
		    	  nameSelect.addOption(j[i].function.id, j[i].function.name, false);
		      }
		      nameSelect.removeAttr('disabled');
		  });
	  }
   }
});

jQuery.extend( {
	fetchSpexByCategory : function(category, showRevivals, yearElement, titleElement, addEmptyFirst) {
	  var yearSelect = jQuery('select#' + yearElement);
	  var titleSelect = jQuery('select#' + titleElement);
	  yearSelect.html('').attr('disabled', 'disabled');
	  titleSelect.html('').attr('disabled', 'disabled');
	  if(category != '') {
		  jQuery.getJSON('/spex', {'search[spex_category_id_equals]': category, 'search[is_revival_equals]': showRevivals, format: 'json', 'search[order]': 'ascend_by_title'}, function(j) {
			  if (addEmptyFirst) {
				  yearSelect.addOption('', '');
			      titleSelect.addOption('', '');
			  }
		      for (var i = 0; i < j.length; i++) {
		    	  yearSelect.addOption(j[i].spex.id, j[i].spex.year, false);
		      }
		      yearSelect.sortOptions();
		      for (var i = 0; i < j.length; i++) {
		    	  titleSelect.addOption(j[i].spex.id, j[i].spex.title, false);
		      }
			  yearSelect.removeAttr('disabled');
			  titleSelect.removeAttr('disabled');
		  });
	  }
   }
});

jQuery.extend( {
	populateYearsFromSpexCategory : function(id, yearElement) {
	  var yearSelect = jQuery('select#' + yearElement);
	  yearSelect.html('').attr('disabled', 'disabled');
	  if(id != '') {
		  jQuery.getJSON('/spex_categories/' + id + '?format=json', function(j) {
			  var firstYear = j.spex_category.first_year;
			  var currentYear = new Date().getFullYear();
			  if(firstYear <= currentYear) {
				  for(var i = currentYear; i >= firstYear; i--) {
	         	      yearSelect.addOption(i, i, false);
				  }
			  } else {
         	      yearSelect.addOption(firstYear, firstYear, true);
			  }
		      yearSelect.removeAttr('disabled');
		  });
	  }
   }
});

jQuery.extend( {
	stripeTable : function(table) {
	  jQuery('tbody tr:visible:even', table).removeClass().addClass('even');
	  jQuery('tbody tr:visible:odd', table).removeClass().addClass('odd');
    }
});

jQuery(function() {
	jQuery('a.add-sub').livequery('click', function() {
	    var assoc = jQuery(this).attr('data-association');
	    var content = jQuery('#' + assoc + '_fields_template').html();
	    var context = (jQuery(this).parents('.fields').find('input:first').attr('name') || '').replace(new RegExp('\[[a-z_]+\]$'), '');
	    if(context) {
		    var parentNames = context.match(/[a-z_]+_attributes/g) || [];
		    var parentIds = context.match(/[0-9]+/g);
		      
		    for(i = 0; i < parentNames.length; i++) {
		        if(parentIds[i]) {
		            content = content.replace(new RegExp('(\\[' + parentNames[i] + '\\])\\[.+?\\]', 'g'), '$1[' + parentIds[i] + ']');
		        }
  	        }
	    }
	    var regexp = new RegExp('new_' + assoc, 'g');
	    var newId = new Date().getTime();
	    content = content.replace(regexp, newId);
	    jQuery(this).parent().before(content);
	    return false;
	});

	jQuery('a.remove-sub').livequery('click', function() {
	    var hiddenField = jQuery(this).prev('input[type=hidden]')[0];
	    if(hiddenField) {
	    	hiddenField.value = '1';
	    }
	    jQuery(this).closest('.fields').hide();
	    return false;
	});
});

jQuery.extend( {
	toggleDisplayOfActor : function(addActorLink, categoryHasActor) {
	  var selectedAddActorLink = jQuery('#' + addActorLink);
	  if(categoryHasActor == 'true') {
		  jQuery(selectedAddActorLink).show();
	  } else {
		  jQuery(selectedAddActorLink).hide();
		  var hiddenFields = jQuery(selectedAddActorLink).siblings('.fields').hide().find('input[type=hidden]');
		  for(var i = 0; i <= hiddenFields.size(); i++) {
			  hiddenFields[i].value = '1';
		  }
	  }
    }
});

jQuery(function() {
	jQuery('select.observe-function-activity-function-category-changes').livequery('change', function() {
		jQuery.fetchFunctionsByCategory(jQuery('option:selected', this).val(), jQuery(this).attr('functions_field'), false);
		jQuery.toggleDisplayOfActor(jQuery(this).attr('add_actor_link'), jQuery('option:selected', this).attr('has_actor'));
	    return false;
	});
});
