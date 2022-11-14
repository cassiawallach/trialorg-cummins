({    
    doInit: function(component, event, helper) 
    {
        //alert('hi');
        //helper.insertstagingvalues(component, event, helper); // Added by Ravikanth
        //helper.updateWorkOrder(component);
        helper.valdateAndUpdateWorkOrder(component,event,false); // only validate on load
        // helper.chechCustomerCreditMessageCode(component, event, helper);
        
        //Get Current User ERP Value
       helper.fetchCurrentUserERP(component, event, helper);
    },
    onAccountChange: function(component, event, helper) 
    {
        console.log('AccChange');
        var wo = component.get("v.WorkOrder");
        console.log('wo === ' +JSON.stringify(wo));
    },
    upRec: function(component, event, helper) 
    
    {
        helper.valdateAndUpdateWorkOrder(component,event,true); // validate And Update 
        
         // helper.updateWorkOrder(component,event,wodrData);  
    },
    itemsChange : function(component, event, helper)
    {
        helper.updateWOComment(component,event,helper); 
        
    },
     // User story ROAD-218 start
     toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }   
    }  // User story ROAD-218 end
});