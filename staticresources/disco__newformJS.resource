	var isLightningExp = typeof sforce !== 'undefined';
	var modalStyle = {escapeClose: false,clickClose: false,showClose: false,closeExisting: true};
	var newCheckboxHTML = '<span class="new-record-text-wrapper">'+
							'OR <div class="slds-form-element new-record-container">'+
  									'<div class="slds-form-element__control">'+
    									'<label class="slds-checkbox">'+
      										'<input type="checkbox" class="new-record-checkbox" onchange="toggleNewRecord($(this));" name="options"/>'+
     										'<span class="slds-checkbox--faux" ></span>'+
      										'<span class="slds-form-element__label">New Record</span>'+
										'</label>'+
									'</div>'+
								'</div>'+
							'</span>';
	var lookupErrorHTML = '<div class="error-text"><strong>Error:</strong> You must enter a lookup record for this relationship.<div>';
	var lookupAndCheckboxErrorHTML = '<div class="error-text"><strong>Error:</strong> You must either enter a lookup record or select New Record for this relationship.<div>';

	$(document).ready(function() {
		if (isWizard) {
			showAppropriateModal();
		}
		normalizeURLParams();

		// andd new record checkboxes to relationships that allow them
		addNewRecordCheckboxes();
	});

	function addNewRecordCheckboxes() {
		normalizeURLParams();
		relsAllowingInserts.split(',').forEach(function(relName) {
			var $matchingInput = $('input[data-relname="' + relName + '"]');
			$matchingInput.next().next().after(newCheckboxHTML);
			
			// if new checkbox should be set to checked per URL paramters find it and set it
			if (relName.toUpperCase() in allURLParameters && allURLParameters[relName.toUpperCase()] === 'NEW') {
				var $matchingCheckbox = $matchingInput.siblings('.new-record-text-wrapper').find('input[type="checkbox"]').prop('checked',true);
				toggleNewRecord($matchingCheckbox);
			}
		});
	}

	/* converts all keys/values to uppercase */
	function normalizeURLParams() {
		var newURLParameters = {};
		var param;
		for (param in allURLParameters) {
			newURLParameters[param.toUpperCase()] = allURLParameters[param].toUpperCase();
		}
		allURLParameters = newURLParameters;
	}


	function toggleNewRecord($checkbox) {
		var $lookupInput = $checkbox.closest('dd').find('input[type="text"]');
		var $lookupHiddenInputs = $checkbox.closest('dd').find('input[type="hidden"]');
		var $inputWrapper =$checkbox.closest('dd').find('.new-record-text-wrapper');
		var lookupInputVal = $lookupInput.val();
		
		$inputWrapper.toggleClass('margin-left');
		// if its being checked disable and clear the input, hide the lookup mag glass
		if ($checkbox.prop('checked') === true) {
			$lookupInput.prop('disabled',true);
			$lookupInput.parent().find('a').hide();
			$lookupInput.val('');
			$lookupHiddenInputs.each(function() {
				var hiddenValue = $(this).val();
				
				// Look for hidden input that is storing the name of the selected obj
				if (hiddenValue === lookupInputVal) {
					$(this).val('null'); // Reset default value of Salesforce managed lookup
				} 
				// Look for hidden input that is storing the sf ID of the selected obj
				else if (hiddenValue.length === 15) {
					$(this).val('000000000000000'); // Reset default value of Salesforce managed lookup
				}
			});
		}
		// if its being unchecked re-enable the input and show the lookup mag glass
		else {
			$lookupInput.prop('disabled',false);
			$lookupInput.parent().find('a').show();
		}
	}

	function validateAndSubmit(redirectLocation) {
		showSpinner();
		var errorFound = false;
		var $allRequiredFields = $('input[data-required="true"]');
		$allRequiredFields.each(function(index,el) {
			// it needs a value in the lookup or the new record checkbox checked if it has one to be valid
			if ($(el).val() === '' && 
			($(el).parent().find('input[type="checkbox"]').length === 0 || 
			$(el).parent().find('input[type="checkbox"]').is(':not(:checked)'))) {

				errorFound = true;
				addErrorToField($(el));
			}
			else {
				removeErrorFromField($(el));
			}
		});
		if (errorFound === false) {
			if (redirectLocation === 'detail') {				
				saveFormGotoDetailAF();
			}
			else if (redirectLocation === 'lwc') {
				saveFormGotoLWCAF();
			}
			else {
				saveFormGotoCompleteAF();
			}
		}
		else {
			hideSpinner();
		}
	}

	function showSpinner() {
		$('#goToSpinner').show();
	}
	function hideSpinner() {
		$('#goToSpinner').hide();
	}

	function addErrorToField($el) {
		if ($el.parent().siblings('.error-text').length === 0) {
			if ($el.parent().find('input[type="checkbox"]').length > 0) {
				$el.parent().after(lookupAndCheckboxErrorHTML);
			}
			else {
				$el.parent().after(lookupErrorHTML);
			}
		}
	}

	function removeErrorFromField($el) {
		$el.parent().siblings('.error-text').remove();
	}
	
	/* returns to form template */
	function goToTemplate() {
		if (isLightningExp) {
			sforce.one.navigateToSObject(sfEnv.templateID,'detail');
		}
		else {
			window.location.href = '/'+sfEnv.templateID;
		}
	}

   	/* go back */
	function goBack(){
		if (isLightningExp) {
			if (retURL){
				sforce.one.navigateToURL(retURL);
			}
			else{
				sforce.one.back(true);
			}
		}
		else{
			if (retURL) {
				window.location.href= retURL;
			}
			else if (isLWC) {
				window.top.postMessage('close', '*');
			}
			else {
				window.location.href = '/';
			}
		}
	}

	/* show select Tempate modal */
	function selectTemplateModal() {
		$('#selectTemplateModal').modal(modalStyle);
	}

	/*select additional fields modal */
	function additionalFieldsModal(){		
		$('#additionalFieldsModal').modal(modalStyle);
	}
	
	/* select template, or fill in additional fields */
	function showAppropriateModal()	{
		if (sfEnv.templateID===null || sfEnv.templateID===''){
	 		selectTemplateModal();
	 	}
	 	else {
	 		additionalFieldsModal();
	 	}
	}	