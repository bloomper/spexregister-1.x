Ajax.Responders.register({
		onCreate: function() {
			if (Ajax.activeRequestCount > 0) {
				Element.show("loadingIndicator");
			}
		},
		onComplete: function() {
			if (Ajax.activeRequestCount == 0) {
				Element.hide("loadingIndicator");
			}
		}
});

var Abstract = new Object();
Abstract.Table = function() {};
Abstract.Table.prototype = {
  tagTest: function(element, tagName) {
    return $(element).tagName.toLowerCase() == tagName.toLowerCase();
  }		
};	

Abstract.TableRow = function() {};
Abstract.TableRow.prototype = Object.extend(new Abstract.Table(), {
  initialize: function(targetTableRow, sourceTableRow) {
    try {
      var sourceTableRow = $(sourceTableRow);
      var targetTableRow = $(targetTableRow);
      
      if (targetTableRow == null || !this.tagTest(targetTableRow,'tr') 
      	|| sourceTableRow == null || !this.tagTest(sourceTableRow,'tr')) {
        throw("TableRow: both parameters must be a <tr> tag.");
      }
      
      var tableOrTbody = this.findParentTableOrTbody(targetTableRow);
      
      var newRow = tableOrTbody.insertRow(this.getNewRowIndex(targetTableRow) - this.getRowOffset(tableOrTbody));
      newRow.parentNode.replaceChild(sourceTableRow, newRow);

    } catch (e) {
      alert(e);
    }
  },
  getRowOffset: function(tableOrTbody) {
    //If we are inserting into a tablebody we would need figure out the rowIndex of the first
    // row in that tbody and subtract that offset from the new row index  
    var rowOffset = 0;
    if (this.tagTest(tableOrTbody,'tbody')) {
      rowOffset = tableOrTbody.rows[0].rowIndex;
    }
    return rowOffset;
  },
  findParentTableOrTbody: function(element) {
    var element = $(element);
    // Completely arbitrary value
    var maxSearchDepth = 3;
    var currentSearchDepth = 1;
    var current = element;
    while (currentSearchDepth <= maxSearchDepth) {
      current = current.parentNode;
      if (this.tagTest(current, 'tbody') || this.tagTest(current, 'table')) {
        return current;
      }
      currentSearchDepth++;
    }
  }		
});

var TableRow = new Object();

TableRow.MoveBefore = Class.create();
TableRow.MoveBefore.prototype = Object.extend(new Abstract.TableRow(), {
  getNewRowIndex: function(target) {
    return target.rowIndex;
  }
});

TableRow.MoveAfter = Class.create();
TableRow.MoveAfter.prototype = Object.extend(new Abstract.TableRow(), {
  getNewRowIndex: function(target) {
    return target.rowIndex+1;
  }
});

Abstract.TableRowMover = function() {};
Abstract.TableRowMover.prototype = Object.extend(new Abstract.TableRow(), {
  initialize: function(targetTableRow) {
    try {
      var targetTableRow = $(targetTableRow);
      
      if (targetTableRow == null || !this.tagTest(targetTableRow,'tr')) {
        throw("TableRow: parameter must be a <tr> tag.");
      }
      
      var tableOrTbody = this.findParentTableOrTbody(targetTableRow);
      
      var newRowIndex = this.getNewRowIndex(targetTableRow);
      var rowOffset = this.getRowOffset(tableOrTbody);
      var rowPosition = 0;
      if((newRowIndex - rowOffset) > tableOrTbody.rows.length) {
        rowPosition = 0;
      } else {
        rowPosition = newRowIndex - rowOffset;
      }
      var newRow = tableOrTbody.insertRow(rowPosition);
      newRow.parentNode.replaceChild(targetTableRow, newRow);

    } catch (e) {
      alert(e);
    }
  }
});

var TableRowMover = new Object();

TableRowMover.MoveUp = Class.create();
TableRowMover.MoveUp.prototype = Object.extend(new Abstract.TableRowMover(), {
  getNewRowIndex: function(target) {
    return target.rowIndex-1;
  }
});

TableRowMover.MoveDown = Class.create();
TableRowMover.MoveDown.prototype = Object.extend(new Abstract.TableRowMover(), {
  getNewRowIndex: function(target) {
    return target.rowIndex+2;
  }
});

var Spexregister = {  
  stripe: function(tableBody) {
    var even = false;
    var tableBody = $(tableBody);
    var tableRows = tableBody.getElementsByTagName("tr");
    var length = tableBody.rows.length;
      
    for (var i = 0; i < length; i++) {
      var tableRow = tableBody.rows[i];
      //Make sure to skip rows that are add or edit rows or messages
      if (!Element.hasClassName(tableRow, "add_link_item") 
        && !Element.hasClassName(tableRow, "edit_link_item")
        && !Element.hasClassName(tableRow, "empty_message")) {
      	
        if (even) {
          Element.addClassName(tableRow, "even");
        } else {
          Element.removeClassName(tableRow, "even");
        }
        even = !even;
      }
    }
  },
  displayMessageIfEmpty: function(tableBody, emptyMessageElement) {
    // Check to see if this was the last element in the list
    if ($(tableBody).rows.length == 0) {
      Element.show($(emptyMessageElement));
    }
  },
  progressPercent: function(indicator, percentage) {
 	  document.getElementById(indicator).style.width =  parseInt(percentage)+"px";
 	  document.getElementById(indicator).innerHTML= "<div>"+percentage+"%</div>"
  },
  initRichTextEditor: function(objName) {
      tinyMCE.idCounter = 0;
      tinyMCE.execCommand('mceAddControl', true, objName);
  },
  killRichTextEditor: function(objName) {
      tinyMCE.execCommand('mceRemoveControl', true, objName);
  }  
}
