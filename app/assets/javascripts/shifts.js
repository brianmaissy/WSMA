var shiftIsHighlighted = false;
var highlightedShiftID = '';


	$( init );

	function init() {
		$('#content').css('background-color', '#FFFFFF');		
		// apply the draggable effect to the resident divs
		$('.resident').draggable({
			containment: '#content',
			snap: '.day',
			revert: true
		});
		
		// apply the droppable effect to the shift divs, which allows them to
		// accept draggable items
		$('.day').droppable({
			drop: handleResidentDrop
		});
		
		// call the resident div click handler, which causes a resident's name 
		// to jump to the currently highlighted shift when clicked
		residentClick();
		
		// function to allow shifts to be highlighted - only one shift can be 
		// highlighted at a time, clicking on a highlighted shift will 
		// un-highlight it, and clicking on a non-highlighted shift will
		// highlight it and un-highlight the currently highlighted shift if
		// there is one
		$('.day').click(function() {
			// if the user clicks on the close button of a resident name in the
			// shift, don't highlight the shift
			if ($(event.target).hasClass('closeButton') || $(event.target).hasClass('assignedResident')) {
				;
			} 
			  // if this shift is highlighted, un-highlight it
			  else if($(this).hasClass('highlighted')) {
				$(this).css('border', '1px solid #000000');
				$(this).css('background-color', '#FFBB99');
				$(this).removeClass('highlighted');
				shiftIsHighlighted = false;
				highlightedShiftID = '';
			} else {
				// if another shift is highlighted, un-highlight it
				if(shiftIsHighlighted) {
					$('#' + highlightedShiftID).removeClass('highlighted');
					$('#' + highlightedShiftID).css('border', '1px solid #000000');
					$('#' + highlightedShiftID).css('background-color', '#FFBB99');
				}
				// highlight this shift
				$(this).css('border', '1px solid #00CCFF');
				$(this).css('background-color', '#FFFFD5');
				$(this).addClass('highlighted');
				shiftIsHighlighted = true;				
				highlightedShiftID = $(event.target).attr('id');
			}		
		});
	}
	
	function residentClick() {
		// unbind is used here to prevent the multiplying effect make sure that 
		// that would be caused by the click handler getting repeatedly bound
		$('.resident').unbind('click').bind('click', function() {
			// only perform the assignment on click if a shift is currently highlighted
			if(shiftIsHighlighted) {
				// create a new div with the resident's name in it and a close button
				var username = $(this).text();
				var shiftID = highlightedShiftID;
				var newDiv = $('<div></div>').addClass('assignedResident').append(username);
				var closeButton = $('<span></span>').addClass('closeButton');		
				closeButton.append('x');
				newDiv.append(closeButton);
				// place the new resident name div in the shift div
				$('#'+highlightedShiftID).append(newDiv);
				// remove the resident's name from the name list
				$(this).remove();			 
				
				// retrieve the user ID of the resident whose name was selected
				var findIDURL = '/users/find_by_name/' + username;
				var userID = 0;
				$.ajax({
					url: findIDURL,
					type: 'GET',
					dataType: 'json',
					success: function( data ) {
						var nameeee = data.name;
						userID = data.id;
						var div = $('<div></div>').append(nameeee).append(userID);
						$('#namelist').append(div);						
						residentClick();
					}
				});
							 
				// create an assignment of the current shift to the selected resident using
				// the hidden dummy form
				$('#form_userid').val(userID);
				$('#form_shiftid').val(highlightedShiftID);
				$('#form_week').val(0);
				$('#form_status').val(1)
				$('#form_blowoffjobid').val(1);
				
				$.ajax({
					url: '/assignments/new', 
					type: 'POST', 
					data:{"assignment": {"user_id": userID, "shift_id": 1, "week": 1, "status": 1, "blow_off_job_id": 1}},
					success: function( data ) {
						var div = $('<div></div>').append('assigned');
						$('#namelist').append(div);
					},
					error: function( errorThrown ) {
						var div = $('<div></div>').append(errorThrown);
						$('#namelist').append(div);
					}
				});					
					
				
				// click handler for the close buttons
				$(closeButton).click(function() {
					undoAssignment(username, newDiv);
				});	
				
			}
		});
	}
	
	function handleResidentDrop(event, ui) {
		var resident = ui.draggable;
		var username = resident.text();
		var shiftID = $(event.target).attr('id');
		var newDiv = $('<div></div>').addClass('assignedResident').append(username);
		var closeButton = $('<span></span>').addClass('closeButton');
		
		//make new assignment using username and shift
		
		closeButton.append('x');
		newDiv.append(closeButton);
		$(this).append(newDiv);
		resident.remove();
		
		//$.ajax({
			//url: '/assignments', type: 'post', data:{user: username, shift: shiftID.substr(1)}
		//});
		$(closeButton).click(function() {
			undoAssignment(username, newDiv);
		});		
	}

	function undoAssignment(username, oldDiv) {
		// make a new div with the resident's name
		var replaceDiv = $('<div></div>').addClass('resident').append(username);
		// remove the resident's name from the shift div
		oldDiv.remove();
		// put the resident's name back into the name list
		$('#namelist').append(replaceDiv);
					
		// reapply the draggable effect to the replaced resident div
		$('.resident').draggable({
			containment: '#content',
			snap: '.day',
			revert: true
		});	
					
		// delete the assignment
		$.ajax({
			url: '/assignments', 
			type: 'delete', 
			data:{"user_id": 2, "shift_id": 2, "week": 2, "status": 2, "blow_off_job_id": 2}
		});
					
		// re-call the resident click handler
		residentClick();		
	}


