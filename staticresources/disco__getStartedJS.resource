
$(document).ready(function() {
    // if its classic set font-size to 12px to stop LDS style overriding classic styles in header/sidebar
    if (!isLightningExp) {
        $('body').css('font-size','12px');
    }

    if (registrationComplete) {
        // replace welcome text
        if (isAdmin) {
            replaceBannerText('PLEASE SELECT AN OPTION BELOW');
        }
        else {
            replaceBannerText('ACTIVATION COMPLETE');
        }
    }
    // get all sample templates
    Visualforce.remoting.Manager.invokeAction(
        returnSampleTemplatesVFR,
        function(result,event) {
            // build array of all sample templates -- clean up format, then parse the JSON
            for (var i = 0; i < result.length; i++) {
                // use jQuery to convert format to be JSON parseable (convert &quot; to ")
                sampleTemplates.push(JSON.parse($('<div/>').html(result[i]).text()));
            }
            
            // build picklist options
            for (var j = sampleTemplates.length - 1; j >= 0; j--) {
                var templateName = sampleTemplates[j].RecordSetBundles[0].Records[0].Name;
                $('#sampleTemplatesSelect').append('<option value="'+j+'">'+templateName+'</option>');
            }
        }
    );

    if (hadToReplaceInstanceSite) {
        // update custom setting since we can't in the constructor
        Visualforce.remoting.Manager.invokeAction(
            updateBaseURLVFR,
            thisInstanceSite,
            function(result,event) {}
        );
    }
});
// Calls the Metdata API from JavaScript to create the Remote Site Setting to permit Apex callouts
function createNewRemoteSite(siteURL,name,description,vfSite,sessionID,resolve,reject) {
    let iterations = 0;
    var binding = new XMLHttpRequest();
    var request =
        '<?xml version="1.0" encoding="utf-8"?>' +
        '<env:Envelope xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
            '<env:Header>' +
                '<urn:SessionHeader xmlns:urn="http://soap.sforce.com/2006/04/metadata">' +
                    '<urn:sessionId>' + sessionID +'</urn:sessionId>' +
                '</urn:SessionHeader>' +
            '</env:Header>' +
            '<env:Body>' +
                '<createMetadata xmlns="http://soap.sforce.com/2006/04/metadata">' +
                    '<metadata xsi:type="RemoteSiteSetting">' +
                        '<fullName>'+ name +'</fullName>' +
                        '<description>'+ description +'</description>' +
                        '<disableProtocolSecurity>false</disableProtocolSecurity>' +
                        '<isActive>true</isActive>' +
                        '<url>'+ siteURL +'</url>' +
                    '</metadata>' +
                '</createMetadata>' +
            '</env:Body>' +
        '</env:Envelope>';
    binding.open('POST', vfSite+'/services/Soap/m/31.0');
    binding.setRequestHeader('SOAPAction','""');
    binding.setRequestHeader('Content-Type', 'text/xml');
    binding.onreadystatechange = function() {
        iterations++;
        if(this.readyState==4 && this.status === 200) {
            // If its done and successful
            var parser = new DOMParser();
            var doc  = parser.parseFromString(this.response, 'application/xml');
            var errors = doc.getElementsByTagName('errors');
            var messageText = '';
            for(var errorIdx = 0; errorIdx < errors.length; errorIdx++) {
                messageText+= errors.item(errorIdx).getElementsByTagName('message').item(0).innerHTML + '\n';
            }
            // resolve promise
            resolve(messageText);
        } else if (this.readyState==4 && iterations === 1) {
            // If it's done the first time but fails, try it again.
            binding.send(request);
        } else if (this.readyState==4){
            // If the second try doesn't work.
            reject();
        }
    }
    binding.send(request);
}

function createAllSites() {

    toggleSpinner();
    
    var pSFInst = new Promise(function(resolve, reject) {
        createNewRemoteSite(thisInstanceSite,'This_Salesforce_Instance'+todaysDateShortPlusRandom,'This Salesforce Instance '+todaysDateShortPlusRandom,vfSite,sessionID,resolve,reject);
    });
    var pRelBuilder = new Promise(function(resolve, reject) {
        createNewRemoteSite(vfSite,'Youreka_Relationship_Builder'+todaysDateShortPlusRandom,'Youreka Relationship Builder '+todaysDateShortPlusRandom,vfSite,sessionID,resolve,reject);
    });
    var pSFLogin = new Promise(function(resolve, reject) {
        createNewRemoteSite(loginSite,'Salesforce_Login'+todaysDateShortPlusRandom,'Salesforce Login '+todaysDateShortPlusRandom,vfSite,sessionID,resolve,reject);
    });
    var pSynAPOrg = new Promise(function(resolve, reject) {
        createNewRemoteSite(synapticSite,'SynapticAP_Org'+todaysDateShortPlusRandom,'SynapticAP Org '+todaysDateShortPlusRandom,vfSite,sessionID,resolve,reject);
    });

    Promise.all([pSFInst,pRelBuilder,pSFLogin,pSynAPOrg]).then(function(response){
        // add a 1s buffer just in case
        setTimeout(function(){ scheduleDCC(); },1000);
    },function(err){
        toggleSpinner();
        console.log(`A remote site could not be created due error: ${err}. Please try to activate again.`); // eslint-disable-line no-console
        window.openCustomModal({bodyStringArray:['A remote site could not be created due error:',err,'Please try to activate again.']});
    });
}

function scheduleDCC() {
    Visualforce.remoting.Manager.invokeAction(
        runDCCVFR,
        function(result,event) {
            if (result === 'success') {
                window.location.reload();
            }
            else {
                toggleSpinner();
                console.log('There was a temporary communication error. Please try to activate again.'); // eslint-disable-line no-console
                window.openCustomModal({bodyStringArray:['There was a temporary communication error. Please try to activate again.']});
            }
        }
    );
}

function confirmUninstall() {
    var zipData = generateZIP();
    if (zipData == ''){
        console.log(`No metadata found to delete. You should be good to uninstall the package.`); // eslint-disable-line no-console
        window.openCustomModal({bodyStringArray:['No metadata found to delete. You should be good to uninstall the package.']});
    }
    else {
        const modalData = {
            bodyStringArray: [
                'Are you sure you wish to uninstall metadata created by Youreka?',
                'This is not reversable and may break functionality.'
            ],
            showCancelButton: true
        };
        window.openCustomModal(modalData)
            .then(() => {
                Visualforce.remoting.Manager.invokeAction(
                    deleteMetadataVFR,
                    zipData,            
                    function(result,event) {
                        const resultModalData = {
                            bodyStringArray: [
                                'Metadata is being deleted. Please wait a few minutes, then you may proceed to uninstall the package.',
                                'You can check the progress in Setup/Deploy/Deployment Status.',
                                'Once the deployment is complete, you can uninstall the Youreka package.'
                            ]
                        };
                        window.openCustomModal(resultModalData);
                    });
            });
    }
}

function runFFsizeBatch(){
    $('#ffUpdateLink').hide();
    toggleSpinnerID('updateSpinner');
    Visualforce.remoting.Manager.invokeAction(
        runFFBatchVFR,
        function(result,event) {
            toggleSpinnerID('updateSpinner');
            console.log(`Your templates are being upgraded.`); // eslint-disable-line no-console
            window.openCustomModal({bodyStringArray:['Your templates are being upgraded.']});
        }
    );      
}

function toggleSpinner() {
    $('.slds-spinner_large').toggle();
    $('#createSitesBtn').toggle();
}

function toggleSpinnerID(id) {
    $('#'+id).find('.slds-spinner_container').toggle();
}

/* if the template has a linked object in parens (Template Name (Contact)) open confirm modal for selecting sample template 
   otherwise just create the new template */
function openConfirmModal() {
    $('.browser-select-template').find('button').prop('disabled',true);
    var selectedTemplateName = $('#sampleTemplatesSelect option:selected').text();
    var objectName;
    if (selectedTemplateName.indexOf('(') > -1) {
        objectName = selectedTemplateName.split('(')[1].split(')')[0];
        $('#confirmModal').find('.objectName').text(objectName+'\'s');
        $('#confirmModal').find('.fieldName').text('disco__form_'+objectName+'__c');
        
        // open modal
        $('#confirmModal').addClass('slds-fade-in-open');
        $('.slds-backdrop').addClass('slds-backdrop_open');
    }
    else {
        createSampleTemplate('browser');
    }
}


// /* user acknowledges confirm modal, create sample template */
function confirmModalOkButton() {
    createSampleTemplate('browser');
    $('#confirmModal').removeClass('slds-fade-in-open');
    $('.slds-backdrop').removeClass('slds-backdrop_open');
}

function createSampleTemplate(templateType) {
    var selectedTemplate;
    var selectedTemplateName;
    var shouldPublishAndCreateForm = templateType==='mobile'; // only publish and create form for mobile
    if (templateType==='mobile') {
        selectedTemplate = JSON.stringify(sampleMobileTemplate);
        selectedTemplateName = sampleMobileTemplate.RecordSetBundles[0].Records[0].Name;
    }
    else {
        var selectedTemplateIndex = $('#sampleTemplatesSelect option:selected').val();
        selectedTemplate = JSON.stringify(sampleTemplates[selectedTemplateIndex]);
        selectedTemplateName = sampleTemplates[selectedTemplateIndex].RecordSetBundles[0].Records[0].Name;
    }

    Visualforce.remoting.Manager.invokeAction(
    createSampleTemplateAndFormVFR,
    selectedTemplate,
    selectedTemplateName,
    shouldPublishAndCreateForm,
    function(result,event) {
        var createdInfo = result;
        if (createdInfo===null) {
            console.log('We\'re unable to create your template/form at this time.'); // eslint-disable-line no-console
            window.openCustomModal({bodyStringArray:['We\'re unable to create your template/form at this time.']});
        }
        else if (createdInfo.error) {
            console.log(`We\'re unable to create your template/form at this time. Error: ${createdInfo.error}`); // eslint-disable-line no-console
            window.openCustomModal({bodyStringArray:['We\'re unable to create your template/form at this time.',`Error: ${createdInfo.error}`]});
        }
        else {
            formId = createdInfo.formId;
            templateId = createdInfo.templateId;
        }

        if (templateType=='browser') {
            if (isLightningExp) {
                sforce.one.navigateToURL('/'+templateId);
            }
            else {
                window.location.href = '/'+templateId;
            }
        }
    });
}


function buildDeletePackageXML(allClasses,allTriggers){
    if (allClasses.length+allTriggers.length===0)
        return '';  //-------------------->

    var packageXML = '<?xml version="1.0" encoding="UTF-8"?>' + 
                        '<Package xmlns="http://soap.sforce.com/2006/04/metadata">' + 
                        '<types>';

    // add all classes
    for (var i = 0; i < allClasses.length; i++) {
        packageXML += '<members>'+allClasses[i]+'</members>';
    }
        packageXML += '<name>ApexClass</name></types><types><name>ApexTrigger</name>';

    // add all triggers
    for (var i = 0; i < allTriggers.length; i++) {
        packageXML += '<members>'+allTriggers[i]+'</members>';
    }
    packageXML += '</types>' + 
                    '<version>52.0</version>' + 
                '</Package>';
    return packageXML;

}

function buildPackageXML() {
    return '<?xml version="1.0" encoding="UTF-8"?>'+
            '<Package xmlns="http://soap.sforce.com/2006/04/metadata">'+
            '<version>52.0</version>'+
            '</Package>';
}

function generateZIP() {
    var classes= buildDeletePackageXML(classNames,triggerNames);
    if (classes=='')
        return ''; //-------------------->

    var zipFile = new JSZip();
    zipFile.file('package.xml',buildPackageXML());
    zipFile.file('destructiveChanges.xml',classes);
    // generate zip file
    var zipData = zipFile.generate();
    return zipData;
}


function selectMobile() {
    $('#mobile-start').addClass('slds-show');
    $('#select-option').addClass('slds-hide');
    replaceBannerText('LET\'S GET STARTED WITH YOUREKA MOBILE');

    createSampleTemplate('mobile');
}

function selectBrowser() {
    $('#browser-start').addClass('slds-show');
    $('#select-option').addClass('slds-hide');
    replaceBannerText('LET\'S GET STARTED WITH YOUREKA');
}

function replaceBannerText(newText) {
     $('.banner-container').find('.slds-text-heading_medium').text(newText.toUpperCase());
}

function goToForm() {
    window.open('/'+formId);
}

function goToTemplateDetail() {
    window.open('/'+templateId);
}