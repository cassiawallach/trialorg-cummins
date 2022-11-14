// if youreka is disabled or the tooling API endpoint isnt available redirect to the get started page
if (yourekaDisabled === 'true' || endpointAvailable=='false') {
	if (isLightningExp) {
		sforce.one.navigateToURL('/apex/'+ ns +'GetStarted');
	} else {
		window.location.href='/apex/'+ns+'GetStarted';
	}
}

/* adds an error to the error banner */
function addError(errorText) {
	$('.slds-notify_container-OR').show();
	$('#allErrors').html(errorText);
}

/* Go to the Bulk Form Generator */ 
function goToFormGen() {
	if (isLightningExp) {
		sforce.one.navigateToURL('/apex/'+ ns +'FormGeneratorJobs?templateID='+templateID);
	}
	else {
		window.location.href = '/apex/'+ ns +'FormGeneratorJobs?templateID='+templateID;
	}
}


/* go to form builder */
function editTemplate() {
	toggleSpinnerModal();
	Visualforce.remoting.Manager.invokeAction(  
		checkTemplateVFR,
		templateID,
		function(result, event) {
			// if it has a URL redirect to there
			if (result.indexOf('error') === -1 && result.indexOf('deleted') === -1) {
				if (isLightningExp) {
					sforce.one.navigateToURL('/apex/'+ ns +'TemplateBuilder?templateID='+templateID);
				}
				else {
					window.location.href = '/apex/'+ ns +'TemplateBuilder?templateID='+templateID;
				}
			}
			// if it has been deleted already
			else {
				toggleSpinnerModal();
				addError('This Template has been deleted.');
			}
		}
	);

}


// navigate to form submission VF page
function openFormSubmissionBehavior() {
	if (isLightningExp){
		sforce.one.navigateToURL('/apex/'+ns+'FormSubmission?id='+templateID);
	}
	else{
		window.location.href = '/apex/'+ns+'FormSubmission?id='+templateID;
	}
}

// navigate to inbound deeplink  VF page
function openInboundDeeplink() {
	if (isLightningExp){
		sforce.one.navigateToURL('/apex/'+ns+'InboundDeeplink?id='+templateID);
	}
	else{
		window.location.href = '/apex/'+ns+'InboundDeeplink?id='+templateID;
	}
}

// opens dependent logic page
function viewDepLogic() {
     if (isLightningExp) {
        sforce.one.navigateToURL('/apex/'+ns+'DepLogic?id='+templateID);
    } else {
        window.location.href='/apex/'+ns+'DepLogic?id='+templateID;
    }
}

//go to no override page
function viewTemplateDetails()
{
	if (isLightningExp) {
		sforce.one.navigateToURL('/'+templateID+'?nooverride=true');
	} else {
		window.location.href='/'+templateID+'?nooverride';
	}
}

/* clones form template*/
function cloneTemplate() {
	toggleSpinnerModal();
	
	Visualforce.remoting.timeout = 120000;

	Visualforce.remoting.Manager.invokeAction(  
		cloneFormTemplateVFR,
		templateID,
		function(result, event) {
			//result will be either error text or the new template ID
			// if there was an error
			if (result.indexOf('Error') > -1) {
				addError(result);
				toggleSpinnerModal();
			}
			// if it was successful
			else {
				if (isLightningExp) {
					sforce.one.navigateToURL('/apex/'+ns+'TemplateBuilder?templateID='+result);
				}
				else {
					window.location.href = '/apex/'+ns+'TemplateBuilder?templateID='+result;
				}
			}
		}
	);
}

/* export template and redirect to export file */
function exportTemplate() {
	toggleSpinnerModal();
	
	Visualforce.remoting.Manager.invokeAction(  
		exportTemplateVFR,
		templateID,
		function(result, event) {
			// if it has a URL redirect to there
			if (result.indexOf('Error') === -1 && result.indexOf('error') === -1 && result.indexOf('deleted') === -1) {
				window.location.href = result;
			}
			// if it has been deleted already
			else if (result === 'deleted') {
				addError('This record has been deleted. Unable to export.');
			}
			// otherwise something else went wrong
			else {
				addError(result);
			}
			toggleSpinnerModal();
		}
	);
}


// formatting function for validator errors
function formatListingError(res){
	let result = '<li><b>'+res.objType;
	if (res.questionLabel){
		result += ' - "'+res.questionLabel+'"';
	}
	let listingError = res.error;
	if (listingError){
		listingError = listingError.replace('Suggested solution:','<b>Suggested solution:</b>');	
		result+=':</b> '+listingError+'</li>';
	}		
	return result;
}

/*fix previously found errors*/
function fixTemplateModal() {
	toggleSpinnerModal();
	closeModal('FieldLinkResultsModal');
	$('#FieldLinkResults').html('');

	Visualforce.remoting.Manager.invokeAction(  
		fixFormTemplateVFR,
		templateID,
		function(result, event) {
			toggleSpinnerModal();
			// if it has been deleted already
			if (result === 'deleted') {
				addError('This record has been deleted. Unable to test.');
				return;
			}
			var listing='';
			
			if (result.length===0) {
				listing += '<div class="slds-modal__content slds-p-around_medium" id="FieldLinkErrorListHeader">'+
								'Good news: All errors were fixed!'+
							'</div>'+
							'<div class="modal-footer slds-modal__footer">'+
								'<div class="slds-x-small-buttons--horizontal">'+
									'<button class="slds-button slds-button--neutral slds-button--brand" type="button" onClick="closeModal(\'FieldLinkResultsModal\');">'+
										'Ok'+
									'</button>'+
								'</div>'+
							'</div>';
			}
			// has errors
			else {
				listing+= '<div class="slds-modal__content slds-p-around_medium" id="FieldLinkErrorListHeader">'+
								'Some errors still remain:<br/>'+
								'<ul class="slds-list--dotted">';

				for (i = 0; i < result.length; i++) { 
					listing+=formatListingError(result[i]);
					
				}

				listing+= 		'</ul>'+
							'</div>'+
							'<div class="modal-footer slds-modal__footer">'+
								'<div class="slds-x-small-buttons--horizontal">'+
									'<button class="slds-button slds-button--neutral slds-button--brand" type="button" onClick="closeModal(\'FieldLinkResultsModal\');">'+
										'Ok'+
									'</button>'+
								'</div>'+
							'</div>';
			}
			$('#FieldLinkResults').html(listing);
			$('#FieldLinkResultsModal').modal();
		});
}


/*find errors and report. May result in user going to fix routine above */
function checkTemplateModal(header) {
	toggleSpinnerModal();
	$('#FieldLinkResults').html('');

	Visualforce.remoting.Manager.invokeAction(  
		testFormTemplateVFR,
		templateID,
		function(result, event) {
			toggleSpinnerModal();
			// if it has been deleted already
			if (result === 'deleted') {
				addError('This record has been deleted. Unable to test.');
				return;
			}
			var listing='';
			var fixableError = false;

			if (result.length===0) {
				listing += '<div class="slds-modal__content slds-p-around_medium" id="FieldLinkErrorListHeader">'+
								'Good news: No Field Link errors found!'+
							'</div>'+
							'<div class="modal-footer slds-modal__footer">'+
								'<div class="slds-x-small-buttons--horizontal">'+
									'<button class="slds-button slds-button--neutral slds-button--brand" type="button" onClick="closeModal(\'FieldLinkResultsModal\');">'+
										'Ok'+
									'</button>'+
								'</div>'+
							'</div>';
			}
			// errors found
			else {
				listing+= '<div class="slds-modal__content slds-p-around_medium" id="FieldLinkErrorListHeader">'+
								'<div id="CheckerHeader" class="slds-notify slds-notify_alert slds-theme_error slds-hide slds-m-bottom_small" role="alert"></div>'+
								'Here are the problems that were found:'+
								'<ul class="slds-list--dotted">';
				
				for (i = 0; i < result.length; i++) { 
					listing += formatListingError(result[i]);

					// Check for message that includes 'fixed automatically'
					// If it is not in there, we have an error that can be auto fixed
					if (result[i].error.indexOf('fixed automatically') === -1) {
						fixableError = true;
					}
				}

				if (fixableError) {
					listing += 		'</ul>'+
								'<br/>Would you like to make these updates?'+
							'</div>'+
							'<div class="modal-footer slds-modal__footer">'+
								'<div class="slds-x-small-buttons--horizontal">'+
									'<button class="slds-button slds-button--neutral " type="button" onClick="closeModal(\'FieldLinkResultsModal\');">'+
										'No, thanks.'+
									'</button>'+
									'<button class="slds-button slds-button--neutral slds-button--brand" type="button" onClick="fixTemplateModal();">'+
										'Try to resolve errors!'+
									'</button>'+
								'</div>'+
							'</div>';
				} else {
					var plural = result.length > 1 ?'s':'';
					listing += '</ul>'+
								'<br/>Please edit the Template or make your changes in Setup to fix the error'+plural +'.'+
							'</div>'+
							'<div class="modal-footer slds-modal__footer">'+
								'<div class="slds-x-small-buttons--horizontal">'+
									'<button class="slds-button slds-button--neutral slds-button--brand" type="button" onClick="closeModal(\'FieldLinkResultsModal\');">'+
										'Ok'+
									'</button>'+
								'</div>'+
							'</div>';
				}
				
			}

			$('#FieldLinkResults').html(listing);

			if (header){
				$('#CheckerHeader').html(header);
				$('#CheckerHeader').removeClass('slds-hide');
			}
			else{
				$('#CheckerHeader').addClass('slds-hide');
			}
			
			$('#FieldLinkResultsModal').modal();
			
		});
}

// navigate to the statistics page
function goToFormTemplateStats(){
	if (isLightningExp){
		sforce.one.navigateToURL('/apex/'+ns+'FormTemplateStats?Id='+templateID);
	}
	else{
		window.location.href = '/apex/'+ns+'FormTemplateStats?Id='+templateID;
	}
		
}

// open edit view of Template's properties
function editTemplateProps() {
	if (isLightningExp){
		sforce.one.navigateToURL('/' + templateID + '/e?nooverride=1');
	}
	else{
		window.location.href = '/' + templateID + '/e?nooverride=1&retURL=' + templateID;
	}
}

/* open delete template modal */
function deleteTemplateModal() {
	if ($('.form-row.templates').length || $('.form-row.forms').length) {
		$('#deleteTemplateModal').find('.cannot-delete').addClass('slds-show').removeClass('slds-hide');
		$('#deleteTemplateModal').find('.can-delete').addClass('slds-hide').removeClass('slds-show');
	} else {
		$('#deleteTemplateModal').find('.can-delete').addClass('slds-show').removeClass('slds-hide');
		$('#deleteTemplateModal').find('.cannot-delete').addClass('slds-hide').removeClass('slds-show');
	}
	$('#deleteTemplateModal').modal();
}

/* open edit/copy template modal */
function editTemplateModal(returnToDrafting) {
	const $editTemplateModal = $('#editTemplateModal'); 

	if (isManagedTemplate && $('.form-row.templates').length) {
		$editTemplateModal.find('.managed-template').addClass('slds-show').removeClass('slds-hide');
		$editTemplateModal.find('.standard-template').addClass('slds-hide').removeClass('slds-show');
		$editTemplateModal.find('.copy-new-version').addClass('slds-show').removeClass('slds-hide');
		$editTemplateModal.data('returnToDrafting',returnToDrafting);
		$editTemplateModal.modal();
		return;
	} 
	else if ($('.form-row.forms').length) {
		$editTemplateModal.find('.standard-template').addClass('slds-show').removeClass('slds-hide');
		$editTemplateModal.find('.managed-template').addClass('slds-hide').removeClass('slds-show');
		$editTemplateModal.find('.copy-new-version').addClass('slds-show').removeClass('slds-hide');
		$editTemplateModal.data('returnToDrafting',returnToDrafting);
		$editTemplateModal.modal();
		return;
	}
	else if (hasFormSubmissionData) {
		$editTemplateModal.find('.form-submission').addClass('slds-show').removeClass('slds-hide');
		$editTemplateModal.find('.copy-new-version').addClass('slds-hide').removeClass('slds-show');
		$editTemplateModal.find('.managed-template').addClass('slds-hide').removeClass('slds-show');
		$editTemplateModal.find('.standard-template').addClass('slds-hide').removeClass('slds-show');
		$editTemplateModal.data('returnToDrafting',returnToDrafting);
		$editTemplateModal.modal();
		return;
	}
	if (returnToDrafting) {
		updateStatus('Drafting','reload');
	}
	else {
		unpublishEditTemplate(hasFormSubmissionData);
	}
}

/* open edit/copy template modal */
function publishAddFormModal() {
	$('#publishAddFormModal').modal();
}

/* open modal to edit Auto Lock, Auto Archive and Remove Mob Avail days props */
function editAutoLockArchiveDaysModal() {
	var $form = $('.js-temp-props-form');

	var templateProperties = [
		{label: 'Number of days before a submitted form no longer syncs to the mobile app:', fieldName: ns+'Remove_Mobile_Avail_Days__c', type: 'number'},
        {label: 'Number of days before submitted forms automatically lock:', fieldName: ns+'Auto_Lock_Days__c', type: 'number'},
        {label: 'Number of days before locked forms automatically archive:', fieldName: ns+'Auto_Archive_Days__c', type: 'number'}
    ];

	var html = templateProperties.map(function(item){
		return '<div class="slds-form-element slds-m-bottom_small js-input-cont">'+
			'<label class="slds-form-element__label" for="'+item.fieldName+'">'+
				'<abbr class="slds-required" title="required">* </abbr>'+item.label +
			'</label>'+
			'<div class="slds-form-element__control">'+
				'<input type="'+item.type+'" id="'+item.fieldName+'" class="slds-input" value="'+thisTemplate[item.fieldName]+'" min="0" max="999999999999999999" maxlength="18" step="1"/>'+
			'</div>'+
		'</div>';
	});

	$form.html(html);

	$('#editAutoLockArchiveDaysModal').modal();
}

// Validate form and make VFR call to update Remove_Mobile_Avail_Days__c, Auto_Lock_Days__c, Auto_Archive_Days__c
function updateTemplateProps() {
	var saveValues = {};
	$('.js-input-cont').each(function(i,item){
		var $item = $(item);
		var $input = $item.find('input');
		var inputId = $input[0].id;
		var val = $input.val();

		// Remove prev error
		$item.removeClass('slds-has-error').find('#form-error-'+inputId).remove();

		// Validate Input, add error
		if (val !== 0 && !val) {
			$item.addClass('slds-has-error').append(formGenErrorHtml(inputId, 'Value cannot be empty.'));
			return;
		}
		else if (val < 0) {
			$item.addClass('slds-has-error').append(formGenErrorHtml(inputId, 'Value cannot be less than zero.'));
			return;
		} else if (val > 999999999999999999) {
			$item.addClass('slds-has-error').append(formGenErrorHtml(inputId, 'Value cannot be greater than 999999999999999999.'));
			return;
		}

		// Round down just in case input is decimal
		var modifiedVal = Math.floor(val);

		// Add to save array
		saveValues[inputId] = modifiedVal;
	});


	if (Object.keys(saveValues).length !== 3) {
		// not all values are valid, stop
		return;
	} else {
		toggleSpinner('editAutoLockArchiveDaysModal');

		Visualforce.remoting.Manager.invokeAction(  
			updateAutoLockArchiveDaysVFR,
			templateID,
			saveValues,
			function(error, event) {
				if (!error) {
					// refresh page
					window.location.reload();
				}
				else {
					// remove any errant '[]'s
					addError(result.split(': []').join(''));
					toggleSpinner('editAutoLockArchiveDaysModal');
					closeModal('editAutoLockArchiveDaysModal');
				}
			}
		);
	}

	// create html for error that goes below input
	function formGenErrorHtml(id, error) {
		return '<div class="slds-form-element__help" id="form-error-'+id+'">'+error+'</div>';
	}
}

/* redirect to add new form for form template */
function addForm() {
	var url = '/apex/'+ ns +'NewFormWizard?templateID='+templateID+'&retURL=%2F'+templateID+'&IgnoreRetURLInGoDirect';
	if (isLightningExp && sfEnv.isNapili) {
		var communityName = SLDS_PATH.substring(0,SLDS_PATH.indexOf('/resource')); 
		window.parent.location = communityName + url;
	}else if (isLightningExp) {
		// no way right now to pre-populate the form template lookup
		sforce.one.navigateToURL(url);
	}
	else {
		window.location.href = url;
	}
}


/* updates form template status */
function updateStatus(newStatus,nextAction) {
	Visualforce.remoting.Manager.invokeAction(  
		updateStatusVFR,
		templateID,
		newStatus,
		function(result, event) {
			// success
			if (result.indexOf('error:') === -1) {
				// if its being published generate the field link triggers
				if (newStatus ==='In Use') {
					generateZIP();
				}
				 
				if (nextAction === 'reload') {
					window.location.href = window.location.href.replace('&createTriggers=true','');
				} else if (nextAction === 'addForm') {
					addForm();
				} else if (nextAction === 'editTemplate') {
					editTemplate();
				}
			}
			// error 
			else 
			{	// remove modals
				if (nextAction === 'addForm') {
					toggleSpinner('publishAddFormModal');
					closeModal('publishAddFormModal');
				}
				else if (nextAction === 'editTemplate') {
						toggleSpinnerModal();
				}	
				// show error
				if (result.indexOf('Checker error:') > -1){
					checkTemplateModal('There are errors on this template that must be fixed before it can be published<br/>');			
				}

				else if (result.indexOf('cannot be changed ')>-1){
				}
				else{
					$('.slds-notify_container-OR').show();
					// parse ugly error to make more user friendly
					var errComponents = result.split(',');
					var errorText = errComponents[errComponents.length-1];
					// remove any errant '[]'s
					errorText = errorText.replace('error:','');
					$('#allErrors').html(errorText.split(': []').join(''));
				}
			}
		}
	);
}

function publishAddForm() {
	toggleSpinner('publishAddFormModal');
	updateStatus('In Use','addForm');
}

function unpublishEditTemplate() {
	toggleSpinnerModal();
	const returnToDrafting = $('#editTemplateModal').data('returnToDrafting');
	const nextAction = returnToDrafting ? 'reload' : 'editTemplate';
	updateStatus('Drafting',nextAction);
}





/* load LSR list for warning */
function loadLSRListAndShowDeleteModal(formId){
	Visualforce.remoting.Manager.invokeAction(  
		loadNonInheritedLinkedSectionRecordsVFR,
		formId,
		function(result, event) {
			nonInheritedLinkedSectionRecords=result;
			if (nonInheritedLinkedSectionRecords.length>0)
			{
				$('#lsrList').removeClass("slds-hide");
				var list='<ul>';
				for (i=0; i < nonInheritedLinkedSectionRecords.length; i++){
                     list+='<li>'+nonInheritedLinkedSectionRecords[i].name+
                     		' ('+nonInheritedLinkedSectionRecords[i].objectName+')</li>';
                }
                list+='</ul>';
                $('#lsrListDetail').html(list);
			}

			$('#deleteFormModal').data('form-id', formId);
			$('#deleteFormModal').modal();
		}
	);
}

/* open delete form modal */
function openDeleteFormModal(formId) {
	loadLSRListAndShowDeleteModal(formId);
}

/* deletes form */
function deleteForm() {
	toggleSpinner('deleteFormModal');
	var formId = $('#deleteFormModal').data('form-id');
	Visualforce.remoting.Manager.invokeAction(  
		deleteFormVFR,
		formId,
		function(result, event) {
			if (result === 'success') {
				// refresh page
				window.location.reload();
			}
			else {
				// remove any errant '[]'s
				addError(result.split(': []').join(''));
				toggleSpinner('deleteFormModal');
			}
		}
	);
}


/* returns to form template list view */
function returnToListView() {
	if (isLightningExp) {
		sforce.one.navigateToList(templateListViewID,'All Form Templates',ns+'Form_Template__c');
	}
	else {
		var pathName = window.location.pathname;
		var pathStart = '';
		if (pathName.indexOf('apex') === -1) {
			let noLeadingSlash = pathName.slice(1);
			pathStart = noLeadingSlash.slice(0,noLeadingSlash.indexOf('/') + 1);
		}
		window.location.href = '/'+pathStart+templateObjectPrefix;
	}
}

/* closes confirmation modal */
function closeModal(id) {
	$('#'+id).data('modal').close();
}

function toggleSpinner(id) {
	$('#'+id).find('.slds-spinner_container').toggle();
}

function toggleSpinnerModal() {
	const $modal = $('#spinnerModal');
	if(!$modal.hasClass('slds-fade-in-open')) {
		$('.slds-backdrop').addClass('slds-backdrop_open');
		$modal.addClass('slds-fade-in-open');
	} else {
		$('.slds-backdrop').removeClass('slds-backdrop_open');
		$modal.removeClass('slds-fade-in-open');
	}
}

function toggleMenu() {
	$('#actionsMenu').show(function(){
		document.body.addEventListener('click', menuCloser, false);
	});
}

function menuCloser(e){
	document.body.removeEventListener('click', menuCloser, false);
	$('#actionsMenu').hide();
}

/* deep delete form template */
function deleteTemplate() {
	toggleSpinner('deleteTemplateModal');

	Visualforce.remoting.Manager.invokeAction(  
		deleteFormTemplateVFR,
		templateID,
		function(result, event) {
			if (result === 'success') {
				if (isLightningExp) {
					sforce.one.navigateToList(templateListViewID,'All Form Templates',ns+'Form_Template__c');
				}
				else {
					returnToListView();
				}
			}
			else {
				toggleSpinner('deleteTemplateModal');
	
				if(result.indexOf('[]') > -1) {
					// this isnt a pretty error message so it needs to be cleaned up some
					addError(result.split(';')[1].split(':').splice(1).join('').split('[]').join(''));
				} else {
					addError(result);
				}
				
				closeModal('deleteTemplateModal');
			}
		}
	);
}

	/* redirects to detail page for given record */
function openThisRecord(recordID) {
	if (isLightningExp) {
		sforce.one.navigateToSObject(recordID,'detail');
	}
	else {
		window.location.href='/'+recordID;
	}		
}

/* Build HTML for Form Rows */
function buildFormRows(form){
	var status = form[ns+'Status__c'].split(' ').map(function(word){ 
        return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
	}).join(' ');
	var createDate = moment(form.CreatedDate).format('MM/DD/YYYY h:mm A');
	var statusIcon;
	var statusBadgeShading;
	switch (form[ns+'Status__c']) {
		case 'NEW':
			statusIcon = 'favorite';
			statusBadgeShading = 'default';
			break;
		case 'IN PROGRESS':
			statusIcon = 'edit';
			statusBadgeShading = 'lightest';
			break;
		case 'SUBMITTED':
			statusIcon = 'check';
			statusBadgeShading = 'inverse';
			break;
		case 'LOCKED':
			statusIcon = 'lock';
			statusBadgeShading = 'inverse';
			break;
		case 'ARCHIVED':
			statusIcon = 'download';
			statusBadgeShading = 'inverse';
	}
    return '<tr class="slds-hint-parent form-row forms">'+
                '<td class="slds-size_2-of-8 slds-cell-wrap" data-label="Name">'+
                    '<button type="button" class="view-btn slds-button slds-button_neutral" onClick="openThisRecord('+"'"+form.Id+"'"+');">'+
                        '<svg aria-hidden="true" class="slds-button__icon">'+
                            '<use xlink:href="'+SLDS_PATH+'/assets/icons/utility-sprite/svg/symbols.svg#preview"></use>'+
                        '</svg>'+
                        'View'+
                    '</button>'+
                    '<button type="button" class="delete-btn slds-button slds-button_neutral" onclick="openDeleteFormModal('+"'"+form.Id+"'"+')">'+
                        '<svg aria-hidden="true" class="slds-button__icon">'+
                            '<use xlink:href="'+SLDS_PATH+'/assets/icons/utility-sprite/svg/symbols.svg#delete"></use>'+
                        '</svg>'+
                        'Delete'+
                    '</button>'+
                '</td>'+
                '<td class="slds-size_2-of-8" data-label="Name">'+
                    '<a href="/'+form.Id+'">'+
                        form.Name+
                    '</a>'+
                '</td>'+
                '<td class="slds-size_2-of-8" data-label="Status">'+
                	'<div class="badge-wrapper">'+
                		'<span class="slds-badge slds-badge_'+statusBadgeShading+'">'+
	                        '<span class="slds-icon_container slds-m-right_xx-small">'+
	                            '<svg class="slds-icon slds-icon_xx-small slds-icon-text-'+(statusBadgeShading==='lightest'?'default':statusBadgeShading)+'" aria-hidden="true">'+
	                               '<use xlink:href="'+SLDS_PATH+'/assets/icons/utility-sprite/svg/symbols.svg#'+statusIcon+'"></use>'+
	                            '</svg>'+
	                        '</span>'+
	                        form[ns+'Status__c']+
	                    '</span>'+
                    '</div>'+
                '</td>'+
                '<td class="slds-size_2-of-8" data-label="Created Date">'+
                	'<label>'+
                   		createDate+
            		'</label>'+
                '</td>'+
            '</tr>';
}

/* Build HTML for Template Rows */
function buildTemplateRows(template){
	var createDate = moment(template.CreatedDate).format('MM/DD/YYYY h:mm A');
    return '<tr class="slds-hint-parent form-row templates">'+
            '<td class="slds-size_1-of-8 slds-cell-wrap" data-label="Name">'+
                '<button type="button" class="view-btn slds-button slds-button_neutral" onClick="openThisRecord('+"'"+template.Id+"'"+');">'+
                    '<svg aria-hidden="true" class="slds-button__icon">'+
                        '<use xlink:href="'+SLDS_PATH+'/assets/icons/utility-sprite/svg/symbols.svg#preview"></use>'+
                    '</svg>'+
                    'View'+
                '</button>'+
            '</td>'+
            '<td class="slds-size_3-of-8" data-label="Name">'+
                '<a href="/'+template.Id+'">'+
                    template.Name+
                '</a>'+
            '</td>'+
            '<td class="slds-size_2-of-8" data-label="Owner Name">'+
                '<a href="/'+template.Id+'">'+
                    template.Owner.Name+
                '</a>'+
            '</td>'+
            '<td class="slds-size_2-of-8" data-label="Created Date">'+
            	'<label>'+
               		createDate+
        		'</label>'+
            '</td>'+
        '</tr>';
}
