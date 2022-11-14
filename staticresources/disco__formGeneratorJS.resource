//************************
//       Variables       *
//************************


var objects = Object.keys(sfEnv.objLookupMap);
var noPrimaryLookups = objects.length === 0;
var noSecondaryLookups = objects.length === 1 && sfEnv.objLookupMap[objects[0]].length === 1;
var noLookupsErr = '<option> -- None -- </option>';
var unsavedChanges = false;
var updateMode = false;

// define today and tomorrow
var rightNow = new Date();
var today = parseToDateString(rightNow);
var tomorrowDate = new Date(rightNow.setDate(rightNow.getDate() + 1));
var tomorrow = parseToDateString(tomorrowDate);

var formGen;
if (sfEnv.queriedFormGenJob && sfEnv.queriedFormGenJob.length === 1) {
	formGen = sfEnv.queriedFormGenJob[0];
	formGen[ns+'Seconday_Relationships_Map__c'] = formGen[ns+'Seconday_Relationships_Map__c'] ? JSON.parse(formGen[ns+'Seconday_Relationships_Map__c']) : [];
	updateMode = true;
	sfEnv.formGenJobID = formGen.Id;
	sfEnv.primaryObj = formGen[ns+'Primary_Object__c'];
} else {
	formGen = {};
	formGen[ns+'Form_Template__c'] = sfEnv.templateID;
	updateMode = false;
}



//************************
//       Functions       *
//************************


function goToPage(currentPage,direction) {
	var dirNum = direction === 'forward' ? 1 : -1;
	var nextPage = currentPage + dirNum;

	if (currentPage === 1) {
		var name = $('#jobName').val();
		if(name) {
			formGen.Name = name;
			hide($('#nameObjectError'));
			$('#jobName').closest('.slds-form-element').removeClass('slds-has-error');
			$('.js-job-name-display').addClass('visible').text(name);
		} else {
			$('#jobName').closest('.slds-form-element').addClass('slds-has-error');
			show($('#nameObjectError'));
			return;
		}
	} 

	if (currentPage === 2) {
		sfEnv.primaryObj = $('.slds-select[name="primaryObject"] option:selected').data('obj');
		var lookupName = $('.slds-select[name="primaryObject"]').val();
		buildPagesFromObj(sfEnv.primaryObj,lookupName);
	}

	// Skip Secondary Lookup Page if there are none.
	if (noSecondaryLookups && nextPage === 3) {
		nextPage = currentPage + (dirNum * 2);
	}

	if (currentPage === 4 && !sfEnv.whereQueryIsValid && direction === 'forward'){
		showErrorModal('Validation Required','The query must be validated before you can continue.');
		$('.query-element.js-advanced-query').addClass('slds-has-error');
		return;
	}

	if(currentPage === 5 && $('#assign-type').val() === 'User' && !$('#user-id').val()) {
		showErrorModal('Validation Issue','A user must be selected if the "Specific User" option is selected.');
		$('#assignment-by-user').closest('.slds-form-element').addClass('slds-has-error');
		return;
	}

	if (currentPage === 6) {
		hide($('.js-back-buttons'));
		var successHeader;
		var successMsg;
		var freqType = $('#frequency').val();
		if (freqType === 'Once'){
			successHeader = 'Success!';
			successMsg = 'You will be notified once your forms have been generated.';
		} else {
			var dateToDisplay = $('#start-date-repeated').val();
			successHeader = 'Success!';
			successMsg = 'Your Forms will be Generated starting on '+dateToDisplay+'!';
		}
		$('.js-success-header').text(successHeader);
		$('.js-success-message').text(successMsg);
	}

	hide($('section.js-page-'+currentPage));
	show($('section.js-page-'+nextPage));
}

function buildPagesFromObj(objName,lookupName){
	$('.js-primary-object-name').text(objName);

	// init page 3
	$('.js-field-map-container').html(objectFieldMapHTML(sfEnv.objFieldsMap,sfEnv.objLookupMap,objName,lookupName));
	$('.js-field-map-container .slds-form-element').removeClass('slds-hide');

	// init page 4
	$('.js-simple-query-field').html(optionColonHTML(sfEnv.objFieldsMap[objName],objName));

	// init page 5
	$('.js-assignment-by-field').html(optionColonHTML(sfEnv.objFieldsMap[objName],objName,'User'));
}

function setInputData(formGenJob){
	// page 0
	$('#active-checkbox').prop('checked',formGen[ns+'Active__c']);

	// page 1
	$('#jobName').val(formGen.Name);

	// page 2
	var objName = formGen[ns+'Primary_Object__c'];
	var lookupName = formGen[ns+'Primary_Relationship__c'];

	$('.slds-select[name="primaryObject"] option:selected').data('obj',objName);
	$('.slds-select[name="primaryObject"]').val(lookupName);
	$('.slds-select[name="primaryObject"]').prop('disabled',true);

	buildPagesFromObj(objName,lookupName);

	// page 3
	if (formGen[ns+'Seconday_Relationships_Map__c'].length) {
		formGen[ns+'Seconday_Relationships_Map__c'].forEach(function(val,i){
			var lookupName = Object.keys(val)[0];

			const $thisSelect = $('.slds-select.secondary-lookup[data-lookup="'+lookupName+'"]');
			$thisSelect.val(val[lookupName]);
			if (val[lookupName]==null ){
				const $cb=$('#'+objName+'-new-cb');
				$cb.prop('checked',true);
				toggleNewRecord($cb);
			}
		});
	} else {
		hide($('.js-page.js-page-1'));
	}


	// page 4
	var queryType = formGen[ns+'Advanced_Query__c'] ? 'Advanced' : 'Simple';
	$('#query-type.slds-select').val(queryType);

	if (formGen[ns+'Advanced_Query__c']){
		$('#whereClause').val(formGen[ns+'Advanced_Query_Logic__c']);
	} else {
		var conditions = JSON.parse(formGen[ns+'Simple_Filter_Logic_Conditions__c']);
		conditions.forEach(function(condition){
			addSimpleQueryRow(condition.fld,condition.operator,condition.values[0]);
		});

		$('#simpleQueryLogic').val(formGen[ns+'Simple_Filter_Logic_Operation__c']);
	}


	// page 5
	var assignmentType = formGen[ns+'Assignment_Type__c'];
	selectAssignCtrls(assignmentType);
	$('#assign-type').val(assignmentType);
	switch(assignmentType){
		case 'Object Field':
			$('.js-assignment-by-field').val(formGen[ns+'Assignment_Criteria__c']);
			break;
		case 'Me':
		case 'User':
			var assignee = JSON.parse(formGen[ns+'Assignment_Criteria__c']);
			if(assignee.length){
				$('#assignment-by-user').val(assignee[0].Name);
				$('#user-id').val(assignee[0].Id);
			}
			break;
		default: // address unexpected values by showing what we have
			$('.js-assignment-by-field').val(formGen[ns+'Assignment_Criteria__c']+' '+formGen[ns+'Assignment_Criteria__c']);
	}

	// page 6
	var frequency = formGen[ns+'Frequency__c'];
	$('#frequency').val(frequency);
	toggleSchedCtrls(frequency);
	var startDate = formGen[ns+'Start_Date__c'];
	var endDate = formGen[ns+'End_Date__c'];
	var $dateOnce = $('#once-date');
	var $startDateRepeated = $('#start-date-repeated');
	var $endDateRepeated = $('#end-date-repeated');
	if (frequency === 'Once'){
		$dateOnce.val(startDate);
		$('#once-date-radio').prop('checked', true);
		if (startDate < tomorrow) {
			$dateOnce.prop('disabled',true);
		} else {
			$dateOnce.attr('min',tomorrow);
		}
	} else {
		$startDateRepeated.val(startDate);
		if (startDate < tomorrow) {
			$startDateRepeated.prop('disabled',true);
		} else {
			$startDateRepeated.attr('min',tomorrow);
		}

		$endDateRepeated.val(endDate);
		if (endDate < tomorrow) {
			$endDateRepeated.prop('disabled',true);
		} else {
			$endDateRepeated.attr('min',tomorrow);
		}
	}

	$('.slds-input.js-day-interval').val(formGen[ns+'Days_Interval__c']);
	hide($('.js-now-element'));
}


function getInputData(){
	var updatedFormGen = {};
	updatedFormGen.Id = sfEnv.formGenJobID;
	updatedFormGen[ns+'Form_Template__c'] = sfEnv.templateID;

	// page 0
	updatedFormGen[ns+'Active__c'] = $('#active-checkbox').prop('checked');

	// page 1
	updatedFormGen.Name = $('#jobName').val();

	// page 2
	updatedFormGen[ns+'Primary_Object__c'] = $('.slds-select[name="primaryObject"] option:selected').data('obj');
	updatedFormGen[ns+'Primary_Relationship__c'] = $('.slds-select[name="primaryObject"]').val();

	// page 3
	var secondaryRelationshipMap = [];
	$('.slds-select.secondary-lookup').each(function(){
		var obj = {};
		obj[$(this).data('lookup')] = $(this).val();
		secondaryRelationshipMap.push(obj);
	});

	if (secondaryRelationshipMap.length) {
		updatedFormGen[ns+'Seconday_Relationships_Map__c'] = JSON.stringify(secondaryRelationshipMap);
	}

	// page 4
	updatedFormGen[ns+'Advanced_Query__c'] = $('#query-type.slds-select').val() === 'Advanced';
	if (updatedFormGen[ns+'Advanced_Query__c']){
		updatedFormGen[ns+'Advanced_Query_Logic__c'] = $('#whereClause').val();
	} else {
		sfEnv.logicConditions = [];
		$('.js-logic-row').each(function(i,row){
			var $this = $(this);
			var isDateTime = $this.find('.js-time-input').css('display') !== 'none';
			var timeVal = $this.find('[name="queryValue-time"]').val();
			var dateVal = $this.find('[name="queryValue"]').val();
			var queryVal; 
			if (isDateTime && dateVal && timeVal) {
				var date = new Date(dateVal);
				var timeArr = timeVal.split(':');
				var hours = timeArr[0];
				var mins = timeArr[1];
				date.setHours(hours,mins);
				queryVal = date;
			} else if (isDateTime) {
				queryVal = '';
			} else {
				queryVal = $this.find('[name="queryValue"]').val();
			}
			sfEnv.logicConditions.push({
				fld: $this.find('[name="queryField"]').val(),
				operator: $this.find('[name="queryOp"]').val(),
				values: [queryVal]
			});
		});
		sfEnv.logicOperation = $('#simpleQueryLogic').val()
		updatedFormGen[ns+'Simple_Filter_Logic_Operation__c'] = sfEnv.logicOperation;
		updatedFormGen[ns+'Simple_Filter_Logic_Conditions__c'] = JSON.stringify(sfEnv.logicConditions);
	}

	// page 5
	var selectedAssignType = $('#assign-type').val();
	updatedFormGen[ns+'Assignment_Type__c'] = selectedAssignType === 'Object Field' ? 'Object Field' : 'User';
	switch(selectedAssignType){
		case 'Object Field':
			updatedFormGen[ns+'Assignment_Criteria__c'] = $('.js-assignment-by-field').val();
			break;
		case 'Me':
			updatedFormGen[ns+'Assignment_Criteria__c'] = sfEnv.userID; 
			break;
		case 'User':
			updatedFormGen[ns+'Assignment_Criteria__c'] = $('#user-id').val();
	}

	// page 6
	var freqType = $('#frequency').val();
	updatedFormGen[ns+'Frequency__c'] = freqType;
	if (freqType === 'Days Interval' || freqType === 'Monthly') {
		updatedFormGen[ns+'Start_Date__c'] = Date.parse($('#start-date-repeated').val());
		updatedFormGen[ns+'End_Date__c'] = Date.parse($('#end-date-repeated').val());
		updatedFormGen[ns+'Days_Interval__c'] = $('.slds-input.js-day-interval').val();
	} else {
		updatedFormGen[ns+'Start_Date__c'] = $('#now-radio').prop('checked') ? Date.parse(today) : Date.parse($('#once-date').val());
	}
	return updatedFormGen;
}

function navigateToTemplate(){
	if (sfEnv.isLightningExp) {
		sforce.one.navigateToURL('/apex/'+ ns +'FormTemplateDetail?id='+sfEnv.templateID);
	}
	else {
		window.location.href = '/apex/'+ ns +'FormTemplateDetail?id='+sfEnv.templateID;
	}
}

function navigateToJobsList(){
	if (sfEnv.isLightningExp) {
		sforce.one.navigateToURL('/apex/'+ ns +'FormGeneratorJobs?templateID='+sfEnv.templateID);
	}
	else {
		window.location.href = '/apex/'+ ns +'FormGeneratorJobs?templateID='+sfEnv.templateID;
	}
}

function showErrorModal(errTitle,errMsg){
	$('#error-modal header h2').text(errTitle);
	$('#error-modal .slds-modal__content').html('<p>'+errMsg+'</p>');
	show($('.js-modal, #error-modal, .slds-backdrop_open'));
}

function showUnsavedChanges(target){
	show($('.js-modal, #confirm-modal, .slds-backdrop_open'));
	
	$('#confirm-modal .js-modal-ok').click(function(){
		unsavedChanges = false; // prevent triggering of unsaved changes again
		if(target === 'TemplateDetail') {
			navigateToTemplate();
		} else {
			navigateToJobsList();
		}
	});
}

window.onbeforeunload = function(evt) {
	if (unsavedChanges) {
		return 'There are unsaved changes. Are you sure you want to leave this page?';
	}
}

function selectAssignCtrls(selection){
	if (selection === 'Object Field') {
		show($('.js-page-5 .js-assign.by-field'));
		hide($('.js-page-5 .js-assign:not(.by-field)'));
	} else if (selection === 'User') {
		show($('.js-page-5 .js-assign.js-by-specific-user'));
		hide($('.js-page-5 .js-assign:not(.js-by-specific-user)'));
	} else {
		hide($('.js-page-5 .js-assign'));
	}
}

function toggleSchedCtrls(selection){
	if (selection === 'Monthly'){
		hide($('.js-once-controls'));
		hide($('.js-day-interval-control'));
		show($('.js-periodicity-controls'));
	} else if (selection === 'Days Interval'){
		hide($('.js-once-controls'));
		show($('.js-periodicity-controls'));
		show($('.js-day-interval-control'));
	} else {
		hide($('.js-periodicity-controls'));
		show($('.js-once-controls'));
	}
}

function optionColonHTML(obj,primaryObj,refObj,setValue) {
	var objectSelectHTML = '';
	for(var field in obj){
		var thisFieldName = obj[field].fieldName;
		if (!refObj && thisFieldName || (thisFieldName && obj[field].referenceObj && obj[field].referenceObj === ('('+refObj+')'))) {
			objectSelectHTML += '<option value="'+thisFieldName+'" data-obj="'+primaryObj+'" data-input-type="'+obj[field].fieldType+'" '+(setValue && thisFieldName === setValue ? 'selected="true"' : '')+'>'+primaryObj+': '+obj[field].fieldLabel+' ('+thisFieldName+')</option>';
		}
	}

	if (objectSelectHTML === '') {
		objectSelectHTML = noLookupsErr;
	}

	return objectSelectHTML;
}

function removeQueryRow(rowId){
	sfEnv.whereQueryIsValid = false;
	$('#'+rowId).replaceWith('');

	// Hide the Logic row if there is only one row
	if ($('.js-logic-row').length === 1) {
		$('#simpleQueryLogic').val('');
		hide($('.js-simple-query-logic'));
		hide($('.js-remove-row'));
	}
}

function addSimpleQueryRow(queryField,queryOp,queryValue){
	sfEnv.whereQueryIsValid = false;

	var queryValueDate = new Date(queryValue);
	var isDate = 'Invalid Date' != queryValueDate && queryValue;
	var timeValue = '';
	if(isDate && queryValue.indexOf('T') === 10 && queryValue.indexOf(':') === 13) {
		var hours = queryValueDate.getHours();
		var mins = queryValueDate.getMinutes();
	 	timeValue = (hours.toString().length === 1 ? '0'+hours : hours)+':'+(mins.toString().length === 1 ? '0'+mins : mins);
	}
	queryValue = isDate && (typeof queryValue === 'string') && queryValue !== '' ? queryValue.substring(0,10) : queryValue;

	var initNumOfRows = $('.js-logic-row').length
	var rowId = 'row'+initNumOfRows;
	var rowHTML = '<div id="'+rowId+'" class="slds-grid logic-row js-logic-row">'+
		'<div class="slds-col slds-size_2-of-6">'+
            '<span class="slds-form-element slds-is-required" >'+
                '<label for="queryField" class="slds-form-element__label">'+
                    '<abbr class="slds-required" title="required">*</abbr>Query Field'+
                '</label>'+
                '<div class="slds-form-element__control">'+
                    '<div class="slds-select_container field-select">'+
                        '<select name="queryField" class="slds-select js-simple-query-field">';
        if (sfEnv.primaryObj) {
        	rowHTML += optionColonHTML(sfEnv.objFieldsMap[sfEnv.primaryObj],sfEnv.primaryObj,null,queryField);
        }

        rowHTML += '</select>'+
                    '</div>'+
                '</div>'+
            '</span>'+
        '</div>'+
        '<div class="slds-col slds-p-horizontal_small slds-size_1-of-6">'+
           ' <span class="slds-form-element slds-is-required" >'+
                '<label for="queryOp" class="slds-form-element__label">'+
                    '<abbr class="slds-required" title="required">*</abbr>Query Operator'+
                '</label>'+
                '<div class="slds-form-element__control">'+
                    '<div class="slds-select_container">'+
                        '<select name="queryOp" class="slds-select" >'+
                            '<option '+(queryOp === '<' ? 'selected="true"' : '')+' value="<" class="lt">less than</option>'+
                            '<option '+(queryOp === '<=' ? 'selected="true"' : '')+' value="<=" class="lte">less or equal to</option>'+
                            '<option '+(queryOp === '>' ? 'selected="true"' : '')+' value=">" class="gt">greater than</option>'+
                            '<option '+(queryOp === '>=' ? 'selected="true"' : '')+' value=">=" class="gte">greater or equal to</option>'+
                            '<option '+(queryOp === '=' ? 'selected="true"' : '')+' value="=">equal to</option>'+
                            '<option '+(queryOp === '!=' ? 'selected="true"' : '')+' value="!=">not equal to</option> '+
                        '</select>'+
                    '</div>'+
                '</div>'+
            '</span>'+
        '</div>'+
        '<div class="slds-col slds-size_3-of-6 js-validate-simple-query validate-simple-query '+(timeValue ? 'has-time' : '')+'">'+
            '<span class="slds-form-element slds-is-required">'+
                '<label for="query-value" class="slds-form-element__label">'+
                    'Query Value'+
                '</label>'+
                '<div class="slds-form-element__control js-has-time">'+
                    '<input type="'+(isDate ? 'date' : 'text')+'" name="queryValue" class="slds-input main-input js-main-input" '+(queryValue ? 'value="'+queryValue+'"' : '')+' />'+
                    '<input type="time" name="queryValue-time" class="slds-input time-input js-time-input" '+(timeValue ? 'value="'+timeValue+'"' : '')+'/>'+
                '</div>'+
            '</span>'+
        '</div>'+
        '<button type="button" class="slds-button js-remove-row '+(initNumOfRows === 0 ? 'slds-hide' : '')+'" onclick="removeQueryRow('+"'"+rowId+"'"+')" >'+
			'<svg aria-hidden="true" class="slds-button__icon">'+
				'<use xlink:href="'+sfEnv.sldsCloseIcon+'"></use>'+
			'</svg>'+
		'</button>';
        if (initNumOfRows >= 1){
    		show($('.js-simple-query-logic'));
    		show($('.js-remove-row'));
        } else if (initNumOfRows === 0){
        	hide($('.js-simple-query-logic'));
        }
    rowHTML += '</div>';

    $('.query-element.simple-query.js-simple-query-rows').append(rowHTML);
}


function toggleNewRecord($checkbox) {
	var $lookupInput = $checkbox.closest('.js-relationship-wrapper').find('select');
	
	if ($checkbox.prop('checked') === true) {
		$lookupInput.prop('disabled',true);
		$lookupInput.val('');
	}
	else {
		$lookupInput.prop('disabled',false);
		$lookupInput.find('option').eq(0).prop('selected','selected');
	}
}



function newRecordCheckBoxHTML(obj, checked){
	return '<span class="new-record-text-wrapper slds-m-left_small slds-m-top_x-small">'+
							'OR <div class="slds-form-element  slds-m-left_x-small">'+
									'<div class="slds-form-element__control">'+
										'<label class="slds-checkbox">'+
											'<input id="'+obj+'-new-cb" type="checkbox"  onchange="toggleNewRecord($(this));" name="options" '+ 
											(checked ? 'checked ':'') +'/>'+
											'<span class="slds-checkbox--faux" ></span>'+
											'<span class="slds-form-element__label">New Record</span>'+
										'</label>'+
									'</div>'+
								'</div>'+
							'</span>';
}

function objectFieldMapHTML(objToFields,objLookupMap,primaryObj,primaryLookup,setValue){
	var thisHTML = '';
	var pageError = false;

	var numOfLookups = 0;
	for (var objName in objLookupMap) {
		objLookupMap[objName].forEach(function(lookup){
			if (primaryLookup !== lookup) {
				var optionHTML = optionColonHTML(objToFields[primaryObj],primaryObj,objName,setValue);
				var allowNew = sfEnv.allowNewRels.includes(','+lookup+',');
				var hasError = optionHTML === noLookupsErr;

				numOfLookups++;
				thisHTML += '<div class="slds-form-element slds-m-bottom_medium js-relationship-wrapper '+(hasError && !allowNew ? 'slds-has-error' : '')+'">'+
					'<label for="secondary-lookup-'+lookup+'" class="slds-form-element__label">'+
						'<abbr class="slds-required" title="required">*</abbr>'+lookup+
					'</label>'+
					'<div class="slds-form-element__control ">'+
						'<div class="slds-select_container '+objName+' '+(hasError && !allowNew ? 'slds-form-element__help' : '')+' field-select">'+
							'<select name="secondaryObject-'+objName+'" class="slds-select secondary-lookup" required="" data-lookup="'+lookup+'"'+
							(hasError && allowNew? ' disabled ' : '')+'>';

				thisHTML += hasError && allowNew ? '' : optionHTML;

				thisHTML += '</select>'+ 
						'</div>';
				if (allowNew){
					thisHTML += newRecordCheckBoxHTML(objName,hasError);
				}
				thisHTML += 
					'</div>';

				if (hasError && !allowNew) {
					thisHTML += '<div class="slds-form-element__help"> The Primary Object ('+primaryObj+') does not have any lookups to the '+objName+' object. Please return to the first page and select a new Primary Object or add a lookup to '+objName+' on the '+primaryObj+' object.</div>';
					pageError = true;
				}
				thisHTML += '</div>'+
				'<br/>';
			}
		});
	}

	$('.js-page-3 button.js-next-button.js-page-change').prop('disabled',pageError);

	return thisHTML;
}

//************************
//       Listeners       *
//************************

// Go to the Template
$('.js-return-btn').click(function(){
	if (unsavedChanges) {
		showUnsavedChanges('TemplateDetail');
	} else {
		navigateToTemplate();
	}
});

// Return to Jobs List
$('.js-cancel-btn').click(function(){
	if (unsavedChanges) {
		showUnsavedChanges('JobsList');
	} else {
		navigateToJobsList();
	}
});

$('.js-page-change').click(function(){
	var $this = $(this);
	var currentPage = $this.data('page');
	var direction = $this.data('direction');
	goToPage(currentPage,direction);
});

// init page 0
$('.slds-select[name="primaryObject"]').html(function(){
	var objectSelectHTML = '';

	for(var objName in sfEnv.objLookupMap){
		var rels = sfEnv.objLookupMap[objName];
		for (var rel=0;rel<rels.length;rel++){
			objectSelectHTML += '<option value="'+rels[rel]+'" data-obj="'+objName+'">'+rels[rel]+' ('+objName+')</option>'		
		}
	}		

	return objectSelectHTML;
});

// init page 2
$('#query-type.slds-select').change(function(){
	sfEnv.whereQueryIsValid = false;
	$('button.js-validate-query').removeClass('is-valid');
	$('#where-responses tbody').html('');
    $('.js-results-display').removeClass('fade-in');
	$('.query-element').each(function(i,elem){
		var $elem = $(elem);
		if($elem.hasClass('slds-hide')){
			show($elem);
		} else {
			hide($elem);
		}
	});
	hide($('.js-query-valid-msg'));
});
if(updateMode && formGen[ns+'Advanced_Query__c']) {
	hide($('.simple-query'));
} else {
	hide($('.js-advanced-query'));
}

$('.js-simple-query-rows').on('change','.js-simple-query-field',function(){
	var $this = $(this);
	var $thisLogicRow = $(this).closest('.js-logic-row');
	var inputType = $this.find('option:selected').data('input-type');

	if (inputType === 'DATE' || inputType === 'DATETIME') {
		$thisLogicRow.find('.validate-simple-query input.js-main-input').prop('type','date');
	} else {
		$thisLogicRow.find('.validate-simple-query input.js-main-input').prop('type','text');
	}

	if (inputType === 'BOOLEAN'){
		$thisLogicRow.find('[name="queryOp"]').addClass('is-boolean').val('=');
	} else {
		$thisLogicRow.find('[name="queryOp"]').removeClass('is-boolean');
	}

	if (inputType === 'DATETIME') {
		$thisLogicRow.find('.validate-simple-query').addClass('has-time');
	} else {
		$thisLogicRow.find('.js-time-input').val('')
		$thisLogicRow.find('.validate-simple-query').removeClass('has-time');
	}
});

if(!updateMode || (updateMode && formGen[ns+'Advanced_Query__c'])) {
	addSimpleQueryRow();
}


$('.add-row').click(addSimpleQueryRow);

$('.js-page-4').change('#whereClause, #simpleQueryLogic, .slds-input, .slds-select',function(){
	sfEnv.whereQueryIsValid = false;
	$('button.js-validate-query').removeClass('is-valid');
	$('#query-next').addClass('slds-button_neutral').removeClass('slds-button_brand');
});

$('button.js-validate-query').click(function(){
	var formJob = getInputData();

	if (!formJob[ns+'Advanced_Query__c']) {
		var filterLogicValidation = validateFilterLogic(sfEnv.logicOperation,sfEnv.logicConditions); // from filter_logic_js.resource
		if (!filterLogicValidation.isValid) {
			var errMsg = '<p>&#8226; '+filterLogicValidation.errors.join('</p><p>&#8226; ')+'</p>';
			showErrorModal('Simple Query Logic Not Valid',errMsg);
    		hide($('.js-query-valid-msg'));
    		return;
		}
	} else if (formJob[ns+'Advanced_Query__c'] && !formJob[ns+'Advanced_Query_Logic__c']) {
		showErrorModal('Missing Fields','The Advanced WHERE Clause is required in order to validate.');
    	$('.query-element.js-advanced-query').addClass('slds-has-error');
    	hide($('.js-query-valid-msg'));
    	return;
	} else {
		$('.query-element.js-advanced-query').removeClass('slds-has-error');
	}

	Visualforce.remoting.Manager.invokeAction(
    	sfEnv.VFR.validateQuery,
    	formJob,
    	function(result, event){
    		$('button.js-validate-query').removeClass('is-valid');
    		$('.js-results-display').removeClass('fade-in');
    		$('#where-responses tbody').html('');
    		$('#query-next').addClass('slds-button_neutral').removeClass('slds-button_brand');

    		if (result && result.data) {
    			var responseHTML = '';
    			result.data.forEach(function(datum){
    				responseHTML += '<tr><td class="slds-truncate">'+datum+'</td></tr>';
    			});
    			sfEnv.whereQueryIsValid = true;
    			$('.query-element.js-advanced-query').removeClass('slds-has-error');
    			$('table .results-count').text('Showing the first '+result.data.length+' of '+result.totalCount+' results.');
    			$('#where-responses tbody').html(responseHTML);
    			$('.js-results-display').addClass('fade-in');
    			$('button.js-validate-query').addClass('is-valid');
    			$('#query-next').removeClass('slds-button_neutral').addClass('slds-button_brand');
    			show($('.js-query-valid-msg'));
    		} else {
    			hide($('.js-query-valid-msg'));
    			var errMsg;
    			if (result) {
    				errMsg = result.error || JSON.stringify(result);
    			} else if (event && event.message) {
					errMsg = event.message;
    			}
    			showErrorModal('Query Not Valid',errMsg);
    			$('.query-element.js-advanced-query').addClass('slds-has-error');
    		}
    	});
});

// init page 3
$('#assign-type.slds-select').change(function(){
	selectAssignCtrls($(this).val());
});
$("#assignment-by-user").autocomplete({
	minLength: 1,
	source: function(request, response) {
		Visualforce.remoting.Manager.invokeAction(
    	sfEnv.VFR.retrieveUsers,
    	request.term,
    	function(result, event){
    		response(result);
    	});
    },
	focus: function(event, ui) {
		$("#assignment-by-user").val(ui.item.label);
		return false;
	},
	select: function(event, ui) {
		$("#assignment-by-user").val(ui.item.label).removeClass('slds-has-error');
		$("#user-id").val(ui.item.value);
		return false;
	}
});

// init page 4
toggleSchedCtrls();
$('#frequency').change(function(){
	toggleSchedCtrls($(this).val());
});

$('#start-date-repeated').on('input',function(){
	var min = $(this).val() || tomorrow;
	$('#end-date-repeated').attr('min',min);
});

$('#end-date-repeated').on('input',function(){
	$('#start-date-repeated').attr('max',$(this).val());
});

if(!updateMode) {
	$('#once-date').prop('disabled',true);

	$('#now-radio').change(function(){
		var isChecked = $(this).prop('checked');
		$('#once-date').prop('disabled',isChecked);
	});

	$('#once-date-radio').change(function(){
		var isChecked = $(this).prop('checked');
		$('#once-date').prop('disabled',!isChecked);
	});
	
	// Set min schedule date as tomorrow
	$('.date input').attr('min',tomorrow);
}	

// clear schedule validation if needed
$('.js-periodicity-controls input').change(function(){
	var $formElem = $(this).closest('.slds-form-element');
	$formElem.removeClass('slds-has-error');
	hide($formElem.find('span.js-errors'));
});

$('.js-once-controls input').change(function(){
	var $formElem = $('#once-date-radio').closest('.slds-form-element');
	$formElem.removeClass('slds-has-error');
	hide($formElem.find('span.js-errors'));
});

// init page 6 
$('.js-generate-button').click(function(){
	var hasValidationError = false;
	var validationErrorMsg = '';
	
	if (updateMode && !sfEnv.whereQueryIsValid) {
		hasValidationError = true;
		validationErrorMsg += '<p>The query must be validated before you can continue.</p>';
    	$('.query-element.js-advanced-query').addClass('slds-has-error');
    } else {
    	$('.query-element.js-advanced-query').removeClass('slds-has-error');
    }

    if(updateMode && $('#assign-type').val() === 'User' && (!$('#user-id').val() || !$('#assignment-by-user').val())) {
    	hasValidationError = true;
		validationErrorMsg += '<p>A user must be selected if the "Specific User" option is selected.</p>';
		$('#assignment-by-user').closest('.slds-form-element').addClass('slds-has-error');
	} else {
		$('#assignment-by-user').closest('.slds-form-element').removeClass('slds-has-error');
	}

    var res = isFrequencyInvalid();
    if(res.startDateAfterEndDate || res.fieldsRequired || res.startDateBeforeTmrw){
    	hasValidationError = true;

    	if(res.fieldsRequired) {
    		validationErrorMsg += '<p>The Frequency fields are required before you can continue.</p>';
    	}
    	if(res.startDateAfterEndDate) {
    		validationErrorMsg += '<p>The Start Date cannot be after the End Date.</p>';
    	}
    	if(res.startDateBeforeTmrw) {
    		validationErrorMsg += '<p>The Start Date cannot be before tomorrow.</p>';
    	}
    }

    if(hasValidationError) {
        showErrorModal('Validation Issue',validationErrorMsg);
    	return;	
    }

	formGen = getInputData();
	show($('.js-modal, #savingStatus, .slds-backdrop_open'));

	if (updateMode){
		Visualforce.remoting.Manager.invokeAction(
        	sfEnv.VFR.updateFormGenJob,
        	formGen,
        	function(result, event){
        		hide($('.js-modal, #savingStatus, .slds-backdrop_open'));

        		if(result !== 'success') {
        			showErrorModal('Form Generation Job Issue',event.message);
        		} else {
        			unsavedChanges = false;
        		}
        	});
	} else {
		formGen[ns+'Active__c'] = $(this).hasClass('schedule');
		sfEnv.onceNow = $('#frequency').val() === 'Once' && $('#now-radio').prop('checked');
		Visualforce.remoting.Manager.invokeAction(
        	sfEnv.VFR.createFormGenJob,
        	formGen,
        	sfEnv.onceNow,
        	function(result, event){
        		hide($('.js-modal, #savingStatus, .slds-backdrop_open'));

        		if(result.indexOf('success:') === -1) {
        			showErrorModal('Form Generation Job Issue',event.message);
        		} else {
        			var formGenJobID = result.split(':')[1];
        			// get the current templateID param and add the newly created form gen job ID
        			var params = window.location.search+'&formGenJobID='+formGenJobID; 
        			window.history.replaceState("object or string", "Title", params);
					goToPage(6,'forward');
        		}
        	});
	} 
});

// Modal Cancels
$('#confirm-modal .js-modal-cancel, #error-modal .js-modal-ok').click(function(){
	hide($(this).closest('.slds-modal'));
	hide($('.js-modal, .slds-backdrop_open'));
});

// init page display
if (sfEnv.isNotPublished) {
	hide($('section.js-page'));
	show($('section.error-page'));
	$('section.error-page .error-msg').text('Templates must be published in order to be able to Generate Forms.');	
} else if (sfEnv.isManagedTemplate) {
	hide($('section.js-page'));
	show($('section.error-page'));
	$('section.error-page .error-msg').text('Managed Templates cannot be used to Generate Forms.');	
} else if (noPrimaryLookups) {
	hide($('section.js-page'));
	show($('section.error-page'));
	$('section.error-page .error-msg').text('Templates Require Field Links in order to be able to Generate Forms.');	
} else if (updateMode) {
	sfEnv.whereQueryIsValid = true;
	if(formGen[ns+'Error_on_Last_Run__c']) {
		$('section.error-page .error-msg').text('Error on Last Run: '+formGen[ns+'Last_Run_Error__c']);
		show($('section.error-page'));
	}
	show($('section.js-page'));
	$('body div.slds-scope').addClass('update-mode');
	$('.slds-page-header .js-cancel-btn').html('Return to Jobs List');
	$('.js-generate-button.schedule').html('Save Changes');
	$('.js-job-name-display').addClass('visible').text(formGen.Name);
	hide($('.js-wizard-view'));
	setInputData(formGen);

	var endDate = new Date(formGen[ns+'End_Date__c']);
	var frequency = formGen[ns+'Frequency__c'];
	if(rightNow > new Date(formGen[ns+'Start_Date__c'])) {
		$('#start-date-repeated').prop('disabled',true);
		$('#frequency').prop('disabled',true);
	}

	if ((frequency === 'Monthly' || frequency === 'Days Interval') && rightNow > endDate) {
		$('#end-date-repeated').prop('disabled',true);
		$('#frequency').prop('disabled',true);
	}

	$('input, select').change(function(){
		unsavedChanges = true;
	});
	sfEnv.whereQueryIsValid = true;
} else {
	goToPage(0,'forward');
}

function show($elem){
	$elem.removeClass('slds-hide').addClass('slds-show');
}

function hide($elem){
	$elem.removeClass('slds-show').addClass('slds-hide');
}

function parseToDateString(dateObj){
	var year = dateObj.getFullYear();
	var month = dateObj.getMonth() + 1;
	if(month.toString().length === 1) {
		month ='0'+month;
	}
	var day = dateObj.getDate();
	if(day.toString().length === 1) {
		day ='0'+day;
	}
	return year+'-'+month+'-'+day;
}

function isFrequencyInvalid(){
	var freqValidation = {fieldsRequired:false, startDateAfterEndDate: false, startDateBeforeTmrw: false};
	var frequency = $('#frequency').val();
	var $onceDateElem = $('#once-date-radio').closest('.slds-form-element');
	var $startDateRepeatedElem = $('#start-date-repeated').closest('.slds-form-element');
	var $endDateRepeatedElem = $('#end-date-repeated').closest('.slds-form-element');
	var $dayIntervalElem = $('.js-day-interval').closest('.slds-form-element');

	if (frequency === 'Once'){
		var startDate = $('#once-date').val();
		var isNow = $('#now-radio').prop('checked');
		freqValidation.fieldsRequired = !isNow && !startDate;
		freqValidation.startDateBeforeTmrw = startDate < tomorrow && !isNow;
		if (freqValidation.fieldsRequired) {
			$onceDateElem.addClass('slds-has-error');
			show($onceDateElem.find('#onceDateError'));
		} else {
			$onceDateElem.removeClass('slds-has-error');
			hide($onceDateElem.find('#onceDateError'));
		}
	} else {
		var startDateEnabled = !$('#start-date-repeated').prop('disabled');
		var startDate = $('#start-date-repeated').val();
		var endDate = $('#end-date-repeated').val();
		var intervalIsInvalid = frequency === 'Days Interval' && $('.js-day-interval').val() < 1;

		if (!startDate) {
			$startDateRepeatedElem.addClass('slds-has-error');
			show($startDateRepeatedElem.find('#startDateError'));
		} else {
			$startDateRepeatedElem.removeClass('slds-has-error');
			hide($startDateRepeatedElem.find('#startDateError'));
		}

		if (!endDate) {
			$endDateRepeatedElem.addClass('slds-has-error');
			show($endDateRepeatedElem.find('#endDateError'));
		} else {
			$endDateRepeatedElem.removeClass('slds-has-error');
			hide($endDateRepeatedElem.find('#endDateError'));
		}

		if (intervalIsInvalid) {
			$dayIntervalElem.addClass('slds-has-error');
			show($dayIntervalElem.find('#dateIntervalError'));
		} else {
			$dayIntervalElem.removeClass('slds-has-error');
			hide($dayIntervalElem.find('#dateIntervalError'));
		}
		
		freqValidation.startDateAfterEndDate = startDate > endDate;
		freqValidation.startDateBeforeTmrw = startDate && startDateEnabled && startDate < tomorrow;
		freqValidation.fieldsRequired = !startDate || !endDate || intervalIsInvalid;
	}
	return freqValidation;
}
