$(document).ready(function(){
    // init page
    var NEW_FORM = 'new-form';
    var MY_FORMS = 'my-forms';
    var ALL_FORMS = 'all-forms';
    var tabs = [NEW_FORM, MY_FORMS, ALL_FORMS];
    
    tabs.forEach(function(tab) {
        buildBtnRows(tab);
    });

    // jQuery Listeners
    $('.js-tab-list').on('click', makeTabActive);
    $('#'+MY_FORMS).on('click','button:not(.js-get-more)', openForm);
    $('#'+ALL_FORMS).on('click','button:not(.js-get-more)', openForm);
    $('#'+NEW_FORM).on('click','button:not(.js-get-more)', newForm);

    // API
    function buildBtnRows (tab) {
        var buttonRows = '';

        if (sfEnv.mobileForms[tab].length){
            sfEnv.mobileForms[tab].forEach(function(form,i) {
                // Reset visibility of respective 'get-more' button 
                $('.'+tab+'-btn').addClass('slds-hide');
                if (i < 100) {
                    buttonRows += buildButtonRows(tab,form);
                } else {
                    /* If there are still more that would be queried,
                        make the respective 'get-more' button visible */
                    $('.'+tab+'-btn').removeClass('slds-hide');
                }
            });
            $('.'+tab+'-rows').append(buttonRows);
        } else {
            $('.'+tab+'-btn').addClass('slds-hide');
        }
    }

    function buildButtonRows(tab,form){
        var buttonTitle;
        var iconType = 'edit_form'

        if(tab === 'new-form') {
            buttonTitle = form.Name
            iconType = 'add';
        } else {
            buttonTitle = form[sfEnv.namespace+'Form_Template__r'].Name+ ' - ' + form.Name;
        }

        return '<div>'+
                    '<button data-id="'+form.Id+'" type="button" class="mobile-button slds-button slds-button_neutral">'+
                        '<svg aria-hidden="true" class="slds-button__icon slds-button__icon_left slds-icon_medium">'+
                            '<use xlink:href="'+sfEnv.sldsLink+'/assets/icons/utility-sprite/svg/symbols.svg#'+iconType+'"></use>'+
                        '</svg>'+
                        buttonTitle+
                    '</button>'+
                '</div>';
    }

    // Make VFR call to create new Form and navigate to it
    function openForm(el) {
        // Show Spinner
        $('.slds-spinner_container').removeClass('slds-hide');

        var formId = $(el.target).data('id');

        if(sfEnv.isSF1 || sfEnv.isLEX) {
            sforce.one.navigateToURL('/apex/'+sfEnv.namespace+'CompleteForm?id='+formId);     
        } else {
            window.location.href = '/apex/'+sfEnv.namespace+'CompleteForm?id='+formId;
        }

        setTimeout(function(){
            // Hide class after user navigates to make sure it is hidden if user uses back arrow
            // to return to the forms list
            $('.slds-spinner_container').addClass('slds-hide');
        }, 2000);
    }

    // Make VFR call to create new Form and navigate to it
    function newForm(el) {
        var templateID = $(el.target).data('id');

        // display loading spinner
        $('.slds-spinner_container').removeClass('slds-hide');
        // make VFR call
        Visualforce.remoting.Manager.invokeAction(  
            sfEnv.newFormVFR,
            templateID,
            function(result, event) {
                //result will be either error text or the new template ID
                //check for connection error
                if(event.hasOwnProperty('message') && event.message.indexOf('Unable to connect') > -1) {
                    $('.slds-spinner_container').addClass('slds-hide'); // hide loading spinner
                    alert('Cannot create forms while offline, please check internet connection.');
                }
                // if there was an error
                else if (result === null && event.statusCode === 200) {
                    /* redirect to add new form for form template */
                    if (sfEnv.isSF1 || sfEnv.isLEX) {
                        // no way right now to pre-populate the form template lookup
                        sforce.one.navigateToURL('/apex/'+ sfEnv.namespace +'NewForm?templateID='+templateID+'&retURL=%2F'+templateID);
                    }
                    else {
                        window.location.href = '/apex/'+ sfEnv.namespace +'NewForm?templateID='+templateID+'&retURL=%2F'+templateID;
                    }
                } else if (result === null ){
                    var errorMsg = '.';
                    if(event.message) {
                        errorMsg = ': \n\n'+event.message;
                    }

                    $('.slds-spinner_container').addClass('slds-hide'); // hide loading spinner
                    alert('The new form could not be created'+errorMsg);
                }
                // if it was successful
                else {
                    if(sfEnv.isSF1) {
                        sforce.one.navigateToURL('/apex/'+sfEnv.namespace+'CompleteForm?id='+result);     
                    } else {
                        window.location.href = '/apex/'+sfEnv.namespace+'CompleteForm?id='+result;
                    }
                }

                setTimeout(function(){
                    // Hide spinner after user has time for navigation to complete
                    // (spinner hidden already if known error)
                    $('.slds-spinner_container').addClass('slds-hide');
                }, 2000);
            }
        );
    }
    
    function makeTabActive(el) {
        // return immediately if tab link was not clicked
        if(el.target.nodeName === "UL") return;

        // setup vars for previously clicked tab and newly clicked tab
        var $selectedElement = $(el.target); // link that was clicked on
        var $newActiveTab = $selectedElement.parent(); // tab containing link
        var newActiveTabName = $selectedElement.attr('aria-controls'); // get tab's reference
        var $tabList = $newActiveTab.parent(); // get container of all tabs
        var $lastActiveTab = $tabList.find('.slds-active'); // find active tab
        var lastActiveTabName = $lastActiveTab.find('a').attr('aria-controls'); // get last active tab's reference

        // Deactive last tab, active new tab (adding underline)
        $lastActiveTab.removeClass('slds-active');
        $newActiveTab.addClass('slds-active');

        // Hide last tab's content, show new tab's content
        $('#'+lastActiveTabName).removeClass('slds-show').addClass('slds-hide');
        $('#'+newActiveTabName).removeClass('slds-hide').addClass('slds-show');
    }

    function getMore(tab){
        var vfrCall;

        switch(tab){
            case 'my-forms':
                vfrCall = sfEnv.getMoreMyFormsVFR;
                break;
            case 'all-forms':
                vfrCall = sfEnv.getMoreAllFormsVFR;
                break;
            case 'new-form':
                vfrCall = sfEnv.getMoreNewFormVFR;
        }

        Visualforce.remoting.Manager.invokeAction(
            vfrCall,
            sfEnv.mobileForms[tab].length,
            function(forms,event){
                var buttonRows = '';
                forms.forEach(function(form,i){
                    // Reset visibility of respective 'get-more' button 
                    $('.'+tab+'-btn').addClass('slds-hide');
                    if (i < 100) {
                         // Build rows
                        buttonRows += buildButtonRows(tab,form);

                        // Add new forms to the respective arrays
                        sfEnv.mobileForms[tab].push(form);                       
                    } else {
                        /* If there are still more that would be queried,
                            make the respective 'get-more' button visible */
                        $('.'+tab+'-btn').removeClass('slds-hide');
                    }
                });
                $('.'+tab+'-rows').append(buttonRows);
            });
    }

    $('.js-get-more').on('click',function(elem){
        var thisList = $(elem.currentTarget).data('type');
        getMore(thisList);
    });

    // iOS fix for the first time you scroll down and click on a for it sends you to the top of the list.
    // This is the same code as in sf1Custom_js.resource
    var a = navigator.userAgent;
    if ((a.indexOf('Salesforce') != -1) && 
        (a.indexOf('iPhone') != -1 || a.indexOf('iPad') != -1) && 
        (a.indexOf('Safari') == -1)) {
        //All proper scrolling for iOS
        var s = document.createElement('style');
        if (a.indexOf('OS/8') != -1 || a.indexOf('OS 8') != -1) {
            s.innerHTML = "html,html body{overflow: auto;-webkit-overflow-scrolling:touch;}body{position:absolute;left:0;right:0;top:0;bottom:0;}";
        } else if (a.indexOf('OS/9') != -1 || a.indexOf('OS 9') != -1) {
            s.innerHTML = "html, html body {overflow: auto;-webkit-overflow-scrolling:auto;} body{position:absolute;left:0;right:0;top:0;bottom:0;}"
        } else { // for iOS 10, 11, and 12. Will hopefully work on future versions as well...
            s.innerHTML = "html, html body {overflow-y: scroll;-webkit-overflow-scrolling:touch;} body{position:absolute;left:0;right:0;top:0;bottom:0;}"
        }
        document.getElementsByTagName('head')[0].appendChild(s);
    }
});