({
    //Added Comment for mv-253 deployment
    getSolutionsKnw : function(component,event)
    {
        var solID = component.get("v.recordId");
        console.log('solID == '+solID);
        //var action = component.get("c.getknowledge");
        var action = component.get("c.getSolknowledge");
        action.setParams({
            'workOrderId': solID 
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var data = response.getReturnValue();
                // console.log('data = '+JSON.stringify(data));
                component.set("v.knowledgeList", data);// Adding values in Aura attribute variable.
                // alert('test '+JSON.stringify(data));
                if(data && data.length>0)
                {
                    setTimeout(function()
                               { 
                                   if(data[0].selectedsolname != null){
                                       //alert('select:'+ data[0].selectedsolname);
                                       var solstr = data[0].selectedsolname;
                                       var res = solstr.substring(1, 2);
                                       //alert('res '+res);
                                       if(res ==".")
                                           component.set("v.activeSections", '\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t\r\t'+ data[0].selectedsolname);
                                       else
                                           component.set("v.activeSections",data[0].selectedsolname);
                                       var action1 = component.get("c.woselecomnull");
                                       //alert('WoID ' +solID);
                                       action1.setParams({
                                           'workOrderId': solID 
                                       });
                                       $A.enqueueAction(action1);
                                   }else{
                                       component.set("v.activeSections", data[0].solname);
                                   }
                               }, 2000);   
                }   
            }else if (state === "INCOMPLETE")
            {
                // alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // alert("Error message: " + errors[0].message);
                    }
                } else {
                    // alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    // Added Ravi To hide/show the In spec out Radio buttons based user look up value
    hideshowspec: function(component,event,helper){
        
        var woID = component.get("v.recordId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('woID == '+woID);        
        var action = component.get("c.getjobordernumber");
        action.setParams({
            'strjobId': woID
        });
        
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               console.log(state+'<user id>'+response.getReturnValue());
                               if (state === "SUCCESS")
                               {
                                   if(response.getReturnValue().User__c== null || response.getReturnValue().User__c== ''|| response.getReturnValue().User__c == userId){
                                       
                                       component.set("v.hidelaunchinsite",true);
                                   } 
                                   
                                   else if(response.getReturnValue().User__c!= null || response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId){
                                       component.set("v.hidelaunchinsite",false);
                                   }
                                   
                               }else if (state === "INCOMPLETE")
                               {
                                   // alert('Response is Incompleted');
                               }else if (state === "ERROR") {
                                   var errors = response.getError();
                                   if (errors) {
                                       if (errors[0] && errors[0].message) {
                                           // alert("Error message: " + errors[0].message);
                                       }
                                   } else {
                                       // alert("Unknown error");
                                   }
                               }
                               console.log(component.get("v.hidelaunchinsite"));
                           });
        $A.enqueueAction(action);     
    },
    //by Mallika
    updateSolHelper: function(component,event,helper){
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        var solID = component.get("v.SoluId");
        //  alert('**solID**'+ solID);
        var repResponse=component.get("v.childevevalue");
        //alert('**repResponse**'+ repResponse);
        var  repNotes=component.get("v.comment");
        // alert('**repNotes**'+ repNotes);
        if(repResponse == undefined){
            component.set("v.isOpen", true);
            component.set("v.errorMsg",'Please be sure a solution button is selected and comments are entered to continue');
             $A.util.addClass(spinner, "slds-hide");
        }
        if(
            (repResponse == 'Repair Successful.' || repResponse == 'Repair Successful with additional parts/procedures.' || repResponse == 'Repair performed but didnot resolve the root cause.')
            && (repNotes == null || repNotes == ''))
        {
            component.set("v.isOpen", true); 
            component.set("v.errorMsg",'Please enter comments before saving');
             $A.util.addClass(spinner, "slds-hide");
        }
        // checking parent perform onclick of save
        else{
        var parentValue=component.get("v.parentsol");
        var parentuserstamp=component.get("v.parentuserstamp");
        
        var woid = component.get("v.recordId");
        var action = component.get("c.solUpdate");
        action.setParams({
            'solutionId': solID,
            'repairresponse':repResponse, 
            'repairnotes':repNotes,
            'workOrderId': woid,
            'solComps':component.get("v.selectComps"),
            'deSolComps':component.get("v.deSelectedSolComps"),
            'selectedParts':component.get("v.selectedParts"),
            'deSelectedParts':component.get("v.deSelectedParts"),
            'cssSolWrappers':component.get("v.cssSolComps")
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (repResponse != undefined  && repNotes != undefined || 
                ( repResponse !='Repair not performed.' && repNotes != undefined) ||
                (repResponse != 'Repair performed but didnot resolve the root cause.' && repNotes != undefined) 
                && state === "success") {
                //alert(repResponse+'*****'+repNotes);
                component.set("v.comment",null);
                component.set("v.childevevalue",undefined);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message: 'Solution comments are added',
                    type: 'success',
                });
                $A.util.addClass(spinner, "slds-hide");
                toastEvent.fire();
                helper.insertPerformedRepairAuditEvent(component,event,helper,repResponse,repNotes);
                location.reload();
            }else if (state === "INCOMPLETE")
            {
                // alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // alert("Error message: " + errors[0].message);
                    }
                } else {
                    // alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
        }
    },
    
    insertPerformedRepairAuditEvent : function(component, event,helper,repResponse,repNotes){
        var action = component.get('c.insertPerformedRepairAuditEvent');
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            repairRadio : repResponse,
            comments : repNotes,
            solId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+ state);
            //console.log(state); 
            if (state === "SUCCESS") {
                console.log("audit event inserted");
            }
        });
        $A.enqueueAction(action);
        helper.insertSelectedRootCauseOnRepair(component,event,helper);
    },
    
    insertViewedSolutionOnRepair:function(component,event,helper){
        //  alert(component.get("v.selectComps"));
        //  alert(component.get("v.recordId"));
        var action = component.get('c.insertViewedSolutionOnRepair');
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            solId : component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                // alert('Success');
                console.log("insertViewedSolutionOnRepair audit event inserted");
            }
        });
        $A.enqueueAction(action);
    },
    
    insertSelectedRootCauseOnRepair:function(component,event,helper){
        //  alert(component.get("v.selectComps"));
        //  alert(component.get("v.recordId"));
        var action = component.get('c.insertSelectedRootCauseOnRepair');
        
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            cssSolutionCompId : component.get("v.selectComps"),
            solId : component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            //  alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("insertSelectedRootCauseOnRepair audit event inserted");
            }
        });
        $A.enqueueAction(action);
    },
    
    //by Mallika
    setLPTsListViewHelper: function(component,event,helper) {
        var toggl = event.getParam("openSections");
        component.set("v.activeSections", toggl);
        var knowledgeList = component.get("v.knowledgeList");
        for(var i=0;i<knowledgeList.length;i++){
            if(toggl.includes(knowledgeList[i].solname)){
                // alert('selectedSolutionId:'+knowledgeList[i].kurlName);
                component.set("v.SoluId",knowledgeList[i].kurlName);
                component.set("v.comment",knowledgeList[i].srepairnote);
                //alert('selected option:'+knowledgeList[i].parentUserStamp);
                component.set("v.childevevalue",knowledgeList[i].srepair);
                // component.set("v.childevevalue",knowledgeList[i].solDiag);
            }
        }
    },
    getWorkOrderRecordType:function(component,event,helper){
        
        // alert(component.get("v.recordId"))
        var action = component.get("c.getWorkOrderRecordType");
        action.setParams({
            strWorkOrderId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // alert("From server: " + response.getReturnValue())
                component.set("v.recordTypeName",response.getReturnValue());
            }
            
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    returnToSolutionInDiagnostic: function(component, solId)
    {
        var woId = component.get("v.recordId");
        //alert(solId);
        var action = component.get("c.changeRecord");
        action.setParams({
            'workId': woId,
            'solId':solId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                location.reload();
                /* var rid= component.get("v.recordId");
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": rid,
                "slideDevName": "SloutionT&D"
                
            });
            navEvt.fire(); */
                // $A.get('e.force:refreshView').fire();
                
            }else if (state === "INCOMPLETE") {
                alert('Response is Incompleted');
            }else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                              errors[0].message);
                    }
                } else {
                    alert("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})