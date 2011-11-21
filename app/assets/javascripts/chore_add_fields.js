// JavaScript Document
var nFloor = "";
var form_num = 1;
	
	function removeField(nField){

		nField.parentNode.parentNode.removeChild(nField.parentNode);
	}

	function insertField(){

		var newFieldContainer = document.createElement('div');
        newFieldContainer.className = "shift_creation";
		
		
		var newSelectorLabel = document.createElement('label');
		newSelectorLabel.innerHTML = "<span>Day</span>";
		var selector = document.createElement('select');
        selector.name = "day_of_week_" + form_num ;
		
		var option = document.createElement('option');
		option.value = 1;
		option.selected = "selected";
		option.appendChild(document.createTextNode('Sunday'));
		selector.appendChild(option);

		var option = document.createElement('option');
		option.value = 2;
		option.appendChild(document.createTextNode('Monday'));
		selector.appendChild(option);
		
		var option = document.createElement('option');
		option.value = 3;
		option.appendChild(document.createTextNode('Tuesday'));
		selector.appendChild(option);
		
		var option = document.createElement('option');
		option.value = 4;
		option.appendChild(document.createTextNode('Wednesday'));
		selector.appendChild(option);
		
		var option = document.createElement('option');
		option.value = 5;
		option.appendChild(document.createTextNode('Thursday'));
		selector.appendChild(option);
		
		var option = document.createElement('option');
		option.value = 6;
		option.appendChild(document.createTextNode('Friday'));
		selector.appendChild(option);
		
		var option = document.createElement('option');
		option.value = 7;
		option.appendChild(document.createTextNode('Saturday'));
		selector.appendChild(option);
		
		
		
		newFieldContainer.appendChild(newSelectorLabel);
		newSelectorLabel.appendChild(selector);
		
		
		
		var newFieldLabel = document.createElement('label');
		newFieldLabel.innerHTML = "<span>Time</span>"; 		
		var newField = document.createElement('input');
		newField.type = "text";
		newField.name = "start_time_" + form_num;
		newField.className = "input_text";
		newFieldContainer.appendChild(newFieldLabel);
		newFieldLabel.appendChild(newField);
		var deleteBtn = document.createElement('input');
		deleteBtn.type = "button";
		deleteBtn.id = "deleteBtn";
		deleteBtn.value = "Remove";
		deleteBtn.style.marginLeft = "5px";
		deleteBtn.onclick = function(){removeField(this)};
		newFieldContainer.appendChild(deleteBtn);
		document.forms[0].insertBefore(newFieldContainer,nFloor);
        form_num += 1;
	}

	function init(){

		var insertBtn = document.getElementById('newFieldBtn');
		insertBtn.onclick = function()
			{
			 insertField();
             // $('#content').height($('#content').height() + 200);
            };
		nFloor = insertBtn;		
	}

	navigator.appName == "Microsoft Internet Explorer" ? attachEvent('onload', init, false) : addEventListener('load', init, false);