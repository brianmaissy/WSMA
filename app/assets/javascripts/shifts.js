var shiftIsHighlighted = false;
var highlightedShiftID = '';

$(document).ready(function() {
	//alert("house id is " + $('#house').attr('house'));

	$( init );

	function init() {
		$('#content').css('background-color', '#FFFFFF');		
		// apply the draggable effect to the resident divs
		$('.resident').draggable({
			containment: '#content',
			snap: '.day',
			revert: true,
			helper: 'clone'
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
				$(this).css('background-color', '#EFE4B0');
				$(this).removeClass('highlighted');
				shiftIsHighlighted = false;
				highlightedShiftID = '';
			} else {
				// if another shift is highlighted, un-highlight it
				if(shiftIsHighlighted) {
					$('#' + highlightedShiftID).removeClass('highlighted');
					$('#' + highlightedShiftID).css('border', '1px solid #000000');
					$('#' + highlightedShiftID).css('background-color', '#EFE4B0');
				}
				// highlight this shift
				$(this).css('border', '1px solid #2F7097');
				$(this).css('background-color', '#FFFFFF');
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
				var shiftID = highlightedShiftID.substr(1);;
				var newDiv = $('<div></div>').addClass('assignedResident').append(username);
				var closeButton = $('<span></span>').addClass('closeButton');		
				closeButton.append('x');
				newDiv.append(closeButton);
				// place the new resident name div in the shift div
				$('#'+highlightedShiftID).append(newDiv);			 
				
				// retrieve the user ID of the resident whose name was selected
				var findIDURL = '/users/find_by_name/' + username;
				var userID = 0;
				$.ajax({
					url: findIDURL,
					type: 'GET',
					dataType: 'json',
					success: function( data ) {
						userID = data.id;
						// create an assignment of the current shift to the selected resident using
						// the hidden dummy form
						var authToken = $('input[name=authenticity_token]').attr("value");				
						$.ajax({
							url: '/assignments', 
							type: 'POST', 
							data:{"utf-8": "&#x2713",
								"authenticity-token": authToken, 
								"assignment": {"user_id": userID, "shift_id": shiftID, "week": 1, "status": 1, "blow_off_job_id": 1},
								"commit": "Create Assignment"},
							success: function( data ) {
								// retrieve the ID of the just-created assignment
								var findAssignmentURL = "/assignments/find/" + shiftID + "/" + userID;
								$.ajax({
									url: findAssignmentURL, 
									type: 'GET',									
									success: function( data ) {
										newDiv.attr('id', data.id);
										
									}
								});
							}			
						});			
					}
				});
				residentClick();			
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
		var shiftID = $(this).attr('id').substr(1);
		var newDiv = $('<div></div>').addClass('assignedResident').append(username);
		var closeButton = $('<span></span>').addClass('closeButton');
		closeButton.append('x');
		newDiv.append(closeButton);	
		$(this).append(newDiv);
		
		// retrieve the user ID of the resident whose name was selected
		var findIDURL = '/users/find_by_name/' + username;
		var userID = 0;
		$.ajax({
			url: findIDURL,
			type: 'GET',
			dataType: 'json',
			success: function( data ) {
				userID = data.id;
				// create an assignment of the current shift to the selected resident using
				// the hidden dummy form's authenticity token
				var authToken = $('input[name=authenticity_token]').attr("value");
				$.ajax({
					url: '/assignments', 
					type: 'POST', 
					data:{"utf-8": "&#x2713",
						"authenticity-token": authToken, 
						"assignment": {"user_id": userID, "shift_id": shiftID, "week": 1, "status": 1, "blow_off_job_id": 1},
						"commit": "Create Assignment"},
					success: function( data ) {						
						// retrieve the ID of the just-created assignment
						var findAssignmentURL = "/assignments/find/" + shiftID + "/" + userID;
						$.ajax({
							url: findAssignmentURL, 
							type: 'GET',									
							success: function( data ) {								
								newDiv.attr('id', data.id);								
								$(closeButton).click(function() {
									undoAssignment(username, newDiv);
								});		
								residentClick();								
							}
						});												
					}			
				});				
			}
		});
			
	}

	function undoAssignment(username, oldDiv) {
		// make a new div with the resident's name
		var replaceDiv = $('<div></div>').addClass('resident').append(username);
		var assignmentID = oldDiv.attr('id');
		// remove the resident's name from the shift div
		oldDiv.remove();
					
		// reapply the draggable effect to the replaced resident div
		$('.resident').draggable({
			containment: '#content',
			snap: '.day',
			revert: true,
			helper: 'clone'
		});	
		
		// delete the assignment
		var deleteAssignmentURL = "/assignments/" + assignmentID;					
		$.ajax({
			url: deleteAssignmentURL, 
			type: 'delete', 
		});
					
		// re-call the resident click handler
		residentClick();		
	}

});