({
    acceptRec : function(component, helper) {
        var action = component.get("c.acceptSerRequest");
        action.setParams({
            "objectID": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {       
            //Navigate to detail page
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var woId = response.getReturnValue();
                component.set('v.loaded', false);
                component.set('v.workOrdId', woId);
                if(woId != null){
                    helper.callFTRAutomation(component, helper);
                }
            }else{
                if(state === 'ERROR' && 
                   response.getError() &&
                   response.getError()[0]&&
                   response.getError()[0]['message']) {
                    
                    let resToast = $A.get("e.force:showToast");
                    resToast.setParams({
                        "type": "Error",
                        "message": response.getError()[0]['message']
                    });
                    resToast.fire();
                    component.set('v.loaded', false);
                }
                var action1 = component.get("c.checkSymptoms");
                action1.setParams({
                    "symID": component.get("v.recordId")
                });
                action1.setCallback(this, function(response) {
                    //Navigate to detail page
                    var state = response.getState();
                    if(state == 'SUCCESS') {
                        var woId1 = response.getReturnValue();
                        if(woId1 == 'fail'){
                            var resToast = $A.get("e.force:showToast");
                            resToast.setParams({
                                "type": "Error",
                                "message":$A.get("$Label.c.FSL_GeneralSymptoms")
                            });
                            resToast.fire();
                            component.set('v.loaded', false);
                        }
                       
                    }
					 
                });
				$A.enqueueAction(action1);
            }
            
         var dismissActionPanel = $A.get("e.force:closeQuickAction");
           dismissActionPanel.fire();
        });
		$A.enqueueAction(action);
	},

    //This method will call Get solutions API
    callFTRAutomation: function(component, helper) {
        var action = component.get("c.getSolutionsForFTR");
        action.setParams({
            "woId": component.get("v.workOrdId")
        });
        action.setCallback( this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") { 
                if(response.getReturnValue()){
                    helper.callGetOptions(component, helper);
                } else {
                    helper.redirectToWO(component);
                }
            } else {
                //Perform Error handling
                helper.redirectToWO(component);
            }
        });
        $A.enqueueAction(action);
    },

    // This method will call Get options, GET SRT Repair and Get Detail coverage
    callGetOptions: function(component, helper) { 
        var action = component.get("c.callGetOptionsAndOtherApis");
        action.setParams({ serviceOrderId : component.get("v.workOrdId") });
        action.setCallback( this, function(response) {
            var state = response.getState();    
            if (state === "SUCCESS") { 
                helper.callGetPartsAndPartReturn(component, helper);
            } else {
                //Perform Error handling
                helper.redirectToWO(component);
            }
        });
        $A.enqueueAction(action);
    },
    //FTR API Automation End 
    //This method will call Get SRT Parts and Get Part Returns
    callGetPartsAndPartReturn: function(component, helper) {
        var action = component.get("c.callGetPartsAndPartReturn");
        action.setParams({ serviceOrderId : component.get("v.workOrdId") });
        action.setCallback( this, function(response) {
            var state = response.getState();      
            if (state === "SUCCESS") { 
                //Perform some action
            } 
            helper.redirectToWO(component);
        });
        $A.enqueueAction(action);
    },
    
    //This method redirects user to WorkOrder Detail page
    redirectToWO: function(component) {
        var urlEvent;
        var woId = component.get('v.workOrdId');
        var action = component.get('c.isDealerAndFTR');
        action.setParams({
            "objectID": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState(); 
            if(state == 'SUCCESS') {
                var isDealerAndFTR = response.getReturnValue();
                if(woId != null && isDealerAndFTR == true) {                      
                    var recId = window.location.href;
                    var recId1 = recId.substring(0, recId.lastIndexOf('/s'));
                    var tabsetUrl = $A.get("$Label.c.EVL_TabSetToOverview");
                    var recId2 = recId1+'/s/workorder/'+ woId +'/detail?tabset-'+tabsetUrl;
                    urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({ "url": recId2}); 
                }
                else if(woId != null) {
                    urlEvent = $A.get("e.force:navigateToSObject");
                    urlEvent.setParams({"recordId":woId});
                }
                urlEvent.fire();
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action); 
    },  
})