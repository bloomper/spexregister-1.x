// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.alerts.dialogClass = "alertDialog";

jQuery.noConflict();

function isUnsupportedBrowser(){
  if(jQuery.browser.msie && parseInt(jQuery.browser.version) <= 6) {
    return true;
  }
  return false;
}

function areCookiesEnabled(){
  var TEST_COOKIE = 'spexregister_test_cookie';
  jQuery.cookie(TEST_COOKIE, true);
  if(jQuery.cookie(TEST_COOKIE)) {
    jQuery.cookie(TEST_COOKIE, null);
  return true;
  }
  return false;
}

jQuery(document).ajaxStart(function() {
  jQuery('#progress-indicator').show();
});

jQuery(document).ajaxStop(function() {
  jQuery('#progress-indicator').hide();
});

jQuery(document).ajaxSend(function(e, xhr, options) {
  var token = jQuery("meta[name='csrf-token']").attr('content');
  xhr.setRequestHeader("X-CSRF-Token", token);
});

jQuery(function() {
  jQuery('td:empty').html('&nbsp;');
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
      hideOnContentClick : true,
      overlayShow : true,
      zoomOpacity : true,
      zoomSpeedIn : 500,
      zoomSpeedOut : 500,
      titleShow : false
    });
  });
});

jQuery(function() {
  jQuery('a.fancybox-text').livequery(function() {
    jQuery(this).fancybox( {
      hideOnContentClick : false,
      overlayShow : true,
      zoomOpacity : true,
      zoomSpeedIn : 500,
      zoomSpeedOut : 500,
      titleShow : false,
      loadingShow : false
    });
  });
});

jQuery(function() {
  jQuery('a.fancybox-form').livequery(function() {
    jQuery(this).fancybox( {
      hideOnContentClick : false,
      overlayShow : true,
      zoomOpacity : true,
      zoomSpeedIn : 500,
      zoomSpeedOut : 500,
      titleShow : false,
      loadingShow : false,
      scrolling : 'no'
    });
  });
});

jQuery(function() {
  jQuery('a.dropdown-menu').livequery(function() {
    jQuery(this).menu( {
      'content': jQuery('a.dropdown-menu').next().html(),
      'showSpeed': 100,
      'width' : 120
    });
  });
});

jQuery(function() {
  jQuery('td[data-link]').livequery('click', function(event) {
    window.location = jQuery(this).data("link");
  });
});

jQuery(function() {
  jQuery('select:not([id*="_new_function_activities_function_id"],[id*="_new_function_activities_actors_attributes_new_actors_vocal_id"]), input:checkbox, input:radio, input:file').livequery(function() {
    jQuery(this).uniform();
  });
});

jQuery.extend( {
  fetchFunctionsByCategory : function(category, nameElement, addEmptyFirst) {
    var nameSelect = jQuery('select#' + nameElement);
    nameSelect.html('').attr('disabled', 'disabled');
    if(category != '') {
      jQuery.getJSON('/functions', {'search[function_category_id_equals]': category, format: 'json', 'search[order]': 'ascend_by_name'}, function(j) {
        if(j != null) {
            if (addEmptyFirst) {
              nameSelect.addOption('', '');
            }
            for (var i = 0; i < j.length; i++) {
              nameSelect.addOption(j[i].id, j[i].name, false);
            }
            nameSelect.removeAttr('disabled');
            jQuery.uniform.update("#" + nameElement);
        }
      });
    }
    jQuery.uniform.update("#" + nameElement);
   }
});

jQuery.extend( {
  fetchSpexByCategory : function(category, showRevivals, yearElement, titleElement, addEmptyFirst) {
    var yearSelect = jQuery('select#' + yearElement);
    var titleSelect = jQuery('select#' + titleElement);
    yearSelect.html('').attr('disabled', 'disabled');
    titleSelect.html('').attr('disabled', 'disabled');
    if(category != '') {
      var jsonUrl = '/spex';
      jsonUrl += '?search[spex_category_id_equals]=' + category;
      jsonUrl += '&search[parent_id_' + (showRevivals ? 'not_' : '') + 'null]=true';
      jsonUrl += '&format=json';
      jsonUrl += '&search[order]=ascend_by_spex_detail_title';
      jQuery.getJSON(jsonUrl, function(j) {
        if(j != null) {
            if (addEmptyFirst) {
              yearSelect.addOption('', '');
              titleSelect.addOption('', '');
            }
            for (var i = 0; i < j.length; i++) {
              yearSelect.addOption(j[i].id, j[i].year, false);
            }
            yearSelect.sortOptions();
            for (var i = 0; i < j.length; i++) {
              titleSelect.addOption(j[i].id, j[i].title, false);
            }
            yearSelect.removeAttr('disabled');
            titleSelect.removeAttr('disabled');
            jQuery.uniform.update("#" + yearElement);
            jQuery.uniform.update("#" + titleElement);
        }
      });
    }
    jQuery.uniform.update("#" + yearElement);
    jQuery.uniform.update("#" + titleElement);
   }
});

jQuery.extend( {
  toggleShowRevivals : function(showRevivals, category) {
  var showRevivalsSelect = jQuery('#' + showRevivals);
  if(category != '') {
      showRevivalsSelect.removeAttr('disabled');
  } else {
      showRevivalsSelect.attr('disabled', 'disabled');
  }
  jQuery.uniform.update('#' + showRevivals);
  }
});

jQuery.extend( {
  populateYearsFromSpexCategory : function(id, yearElement) {
    var yearSelect = jQuery('select#' + yearElement);
    yearSelect.html('').attr('disabled', 'disabled');
    if(id != '') {
      jQuery.getJSON('/spex_categories/' + id + '?format=json', function(j) {
      if(j != null) {
          var firstYear = j.first_year;
          var currentYear = new Date().getFullYear();
          if(firstYear <= currentYear) {
            for(var i = currentYear; i >= firstYear; i--) {
              yearSelect.addOption(i, i, false);
            }
          } else {
            yearSelect.addOption(firstYear, firstYear, true);
          }
          yearSelect.removeAttr('disabled');
          jQuery.uniform.update("#" + yearElement);
      }
      });
    }
    jQuery.uniform.update("#" + yearElement);
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
      var context = (jQuery(this).parents('.fields').find('input:last').attr('name') || '').replace(new RegExp('\[[a-z_]+\]$'), '');
      if(context) {
        var parentNames = context.match(/[a-z_]+_attributes/g) || [];
        var parentIds = context.match(/[0-9]+/g);
          
        for(var i = 0; i < parentNames.length; i++) {
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
      for(var i = 0; i < hiddenFields.size(); i++) {
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
