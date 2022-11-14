({
	doInit : function(component, event, helper) {
		var pageRef = component.get("v.pageReference");
        var state = pageRef.state; // state holds any query params
        var base64Context = state.inContextOfRef;
		/*
			*For some reason, the string starts with "1.", if somebody knows why,
			*8this solution could be better generalized.
		*/
        console.log('base64Context '+base64Context);
         if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        console.log('addressableContext '+addressableContext);
        component.set("v.recordId", addressableContext.attributes.recordId);
        
        var recId = component.get('v.recordId');
        console.log('info '+recId);
        var woRecId = component.get("v.recordId");
       var action = component.get('c.fetchAccountId');
        
        action.setParams({            
            woId:woRecId
        });
       
        action.setCallback( this, function(response) {
            console.log('woRecId-2 '+woRecId);
        	var state = response.getState();  
            console.log('state--- '+state);
            if (state === "SUCCESS") {
                //alert('response--- '+response.getReturnValue());                              
                console.log('response--- '+response.getReturnValue());
                if(response.getReturnValue()){                   
                   //component.set("v.recordIdAcc",response.getReturnValue());
                    var responseVal = response.getReturnValue();//changed here
                    component.set("v.accountID",responseVal[1]);
                    component.set("v.recordIdAcc",responseVal[0]);
                     var accIdInfo = component.get("v.recordIdAcc");
                    var accdefault = component.get("v.accountID");
                    console.log('acc Info '+accIdInfo);
                    console.log('accdefault '+accdefault);
                }
         
            var servicetrID = component.get("v.recordIdAcc");
            var acounttrID = component.get("v.accountID");
            console.log('acc Id '+servicetrID);
            var createCaseEvent = $A.get("e.force:createRecord");
            createCaseEvent.setParams({
                "entityApiName": "ServiceOrderContact__c",
                "defaultFieldValues": {               
                    'Payer_Account__c' : servicetrID,
                    'Service_Order__c': woRecId,
                    'Account__c': acounttrID
                }
            });
            createCaseEvent.fire();
      }
        });
        $A.enqueueAction(action);
	},
})