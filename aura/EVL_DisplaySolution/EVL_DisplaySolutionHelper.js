({
    getSolutionsKnw : function(component,event,activesession)
    {
        var solID = component.get("v.recordId");
        console.log('Anirudh solID == '+solID);
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
                //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                if(activesession !== undefined){
                      component.set("v.activeSections", activesession);  
                    component.set("v.isreloads",true);
                }
                component.set("v.knowledgeList", data);// Adding values in Aura attribute variable.   
                //alert('test '+JSON.stringify(data));
                /*var x;
                for(x in data){
                    alert(data[x].solname);
                }*/
                if(data && data.length>0)
                {
                    setTimeout(function()
                               { 
                                   // console.log('karthikSol'+data[0].sname) 
                                   
                                   if(data[0].repairSol)
                                   { 
                                       component.set("v.activeSections", data[0].repairSol);	//added by Sriprada  
                                        //alert('karthikSoldef'+data[0].repairSol);
                                   } else if(activesession !== undefined){
                                     component.set("v.activeSections", activesession);  
                                     component.set("v.isreloads",true);  //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                                   }
                                   else {
                                       component.set("v.activeSections", data[0].defsname);
                                       //alert('karthikSoldef'+data[0].defsname);
                                   }
                                    $A.get('e.force:refreshView').fire();

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
    getoverview : function(component,event)
    {
        var woID = component.get("v.recordId");
        console.log('woID == '+woID);        
            var action = component.get("c.getFCOverview");
        action.setParams({
            'workOrderId': woID
        });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               console.log(state);
                               if (state === "SUCCESS")
                               {
                                   var data = response.getReturnValue();
                                   //console.log('OverView data =: '+data);
                                   component.set("v.overViewDetail",JSON.parse(data));
                                   
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
    //Audit trail for trobuleshooting
    insertPerformedRepairAuditEvent : function(component, event,helper,repResponse,repNotes){
        var action = component.get('c.insertPerformedRepairAuditEvent');
        action.setParams({
            repairRadio : repResponse,
            comments : repNotes,
            solId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("audit event inserted");
            }
        });
        $A.enqueueAction(action);
        helper.insertViewedSolutionOnRepair(component,event,helper);
    },
    
    insertViewedSolutionOnRepair:function(component,event,helper){
        
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
                console.log("insertViewedSolutionOnRepair audit event inserted");
            }
        });
        $A.enqueueAction(action);
        //  helper.insertSelectedRootCauseOnRepair(component,event,helper);
    },
    
    insertSelectedRootCauseOnRepair:function(component,event,helper){
        // alert(component.get("v.selectComps"));
        // alert(component.get("v.recordId"));
        var action = component.get('c.insertSelectedRootCauseOnRepair');
        action.setParams({
            cssSolutionCompId : component.get("v.selectComps"),
            solId : component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("insertSelectedRootCauseOnRepair audit event inserted");
            }
        });
        $A.enqueueAction(action);
    },
    
    // Added Ravi To hide/show the In spec out Radio buttons based user look up value
    hideshowspec: function(component,event,helper){
        
        var woID = component.get("v.recordId");
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log('woID == '+woID);        
        var action = component.get("c.fetchTakeControl");
        action.setParams({
            'strjobId': woID
        });
        
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               console.log(state+'<user id>'+response.getReturnValue());
                               if (state === "SUCCESS")
                               {
                                   /*Condition updated to Consider EVL Technicians - Sruthi
                                   if(((response.getReturnValue().User__c == null || response.getReturnValue().User__c == '') && response.getReturnValue().CreatedById == userId) || response.getReturnValue().User__c == userId){
                                       component.set("v.hidelaunchinsite",true);
                                   } 
                                   else if(response.getReturnValue().User__c == null || response.getReturnValue().User__c == '' || (response.getReturnValue().User__c!= null || response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId)){
                                       component.set("v.hidelaunchinsite",false);
                                   }*/
                                   if(response.getReturnValue()){
                                       component.set("v.hidelaunchinsite",true);
                                   }
                                   else{
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
        var resval= component.get("v.childevevalue");
        var  commvalue= component.get("v.comment");
        var  childflag=component.get("v.childSol"); 
        var parentValue=component.get("v.parentsol");
        var parentuserstamp=component.get("v.parentuserstamp");
        var errorBool = false; 
        
        if(parentValue != undefined && parentuserstamp == undefined){
                    component.set("v.isOpen", true);
                    //Road 108 changes by Murali - Changing warning message
                    var errorMessage = $A.get("$Label.c.FSL_Parent_Solution_Message");
                    component.set("v.errorMsg",errorMessage);
                   // component.set("v.childSol", true);
            $A.util.addClass(spinner, "slds-hide");

                }  
        else{
            // checking parent perform onclick of save
        var parentValue=component.get("v.parentsol");
        var parentuserstamp=component.get("v.parentuserstamp");
        var woid = component.get("v.recordId");
        console.log('cssSolComps>>>'+component.get("v.cssSolComps"));
            //alert('before calling');
        var action = component.get("c.solUpdate");
        action.setParams({
            'solutionId': solID,
            'responseValue':resval, 
            'commentValue':commvalue,
            'workOrderId': woid ,
            'solComps':component.get("v.selectComps"),
            'deSolComps':component.get("v.deSelectedSolComps"),
            'selectedParts':component.get("v.selectedParts"),
            'deSelectedParts':component.get("v.deSelectedParts"),
            'cssSolWrappers':component.get("v.cssSolComps"),
            'partIdReplsRsn':component.get("v.partIdReplsRsn")
         });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            console.log(errorBool);
            if(errorBool == false) {
                if (resval != undefined  && commvalue != undefined || (resval =='Could not perform the solution verification') || (resval != undefined && resval !='Could not perform the solution verification' && commvalue != undefined)
                    ||(resval !='Could not perform the solution verification' && parentuserstamp != undefined) && state === "success") {
                    // alert(resval+'*****'+commvalue);
                    component.set("v.comment",null);
                    component.set("v.childevevalue",undefined);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Solution comments are added',
                        type: 'success',
                    });
                    $A.util.addClass(spinner, "slds-hide");
                    if(response.getReturnValue() == true){
                        toastEvent.fire();
                        var activesession = component.get("v.activeSections");	
                        var preactivesession = activesession; //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                        /*Road 101 START - Commenting Road 7 & 56 changes by Murali
                       // helper.focusOpenaccordion(component,event,resval);	
                       // activesession = component.get("v.NextToggle");	Road 101 END*/
                      //Road 106/107 by Murali for reverting Road 101 changes 11/29/2021 START
                       helper.focusOpenaccordion(component,event,resval);
                       activesession = component.get("v.NextToggle");	// Road 106/107 END
                    	helper.insertPerformedDiagAuditEventLogger(component,event,helper,resval,commvalue);	
                        //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                        component.set("v.isreloads",false);
                        var nexttoggle = component.get("v.NextToggle"); 
                         if(preactivesession === component.get("v.NextToggle"))
                         {
                              component.set("v.isreloads",true);
                         }
                        this.getSolutionsKnw(component, event, activesession);	
                  //  location.reload();//added by vinod for reloading -7/11	
                  //added by Mani  PHEON - 33 -->
                    //component.set("v.isreloads",true); //Commented by Murali 106/107 and moved code to above as it is conflicting with audit trail updates
                    //added by Mani  PHEON - 33 -->
                    }	
                    	
                }	
                /*Road 101 START - Commenting Road 7 & 56 changes by Murali
               /* else if(state === "success")	
                {	
                    helper.focusOpenaccordion(component,event,resval);	
                    component.set("v.activeSections", component.get("v.NextToggle"));
                }	Road 101 END */
                //Road 106/107 by Murali for reverting Road 101 changes 11/29/2021 START
                else if(state === "success")	
                {	
                    //Added by Murali for Road 106/107 Audit trail Changes - 12/16/2021
                    $A.util.addClass(spinner, "slds-hide");
                    helper.focusOpenaccordion(component,event,resval);	
                    component.set("v.activeSections", component.get("v.NextToggle"));
                }  // Road 106/107 END
                else if (state === "INCOMPLETE")	
                {	
                    // alert('Response is Incompleted');	
                }else if (state === "ERROR") {	
                    var errors = response.getError();	
                    if (errors) {	
                        if (errors[0] && errors[0].message) {	
                        } 
                    } else {	
                        // alert("Unknown error");	
                    }	
                }
                }
        });
        $A.enqueueAction(action);
        }
    },
    //by Mallika
    setLPTsListViewHelper: function(component,event,helper) {
        var toggl = event.getParam("openSections");
        component.set("v.activeSections", toggl);
        // alert('toggle=='+component.get("v.activeSections"));
        var knowledgeList = component.get("v.knowledgeList");
        for(var i=0;i<knowledgeList.length;i++){
            if(toggl.includes(knowledgeList[i].solname)){
                // alert('selectedSolutionId:'+knowledgeList[i].kurlName);
                component.set("v.SoluId",knowledgeList[i].kurlName);
                component.set("v.comment",knowledgeList[i].solcomm);
                //alert('selected option:'+knowledgeList[i].parentUserStamp);
                component.set("v.childevevalue",knowledgeList[i].soldiagnostic);
                // checking parent perform onchange accordian
                component.set("v.parentuserstamp",knowledgeList[i].parentUserStamp);
                component.set("v.parentsol",knowledgeList[i].nestedSolVal);
                var parentValue=component.get("v.parentsol");
                var parentuserstamp=component.get("v.parentuserstamp");
                //alert('parentValue == '+parentValue);
                // alert('parentuserstamp == '+parentuserstamp);
                // Road 106 by Murali 01/11/2022
                var isAutoOpenChild = component.get("v.isAutoOpen"); 
                if(!isAutoOpenChild && parentValue != undefined && parentuserstamp == undefined){
                    component.set("v.isOpen", true);
                    component.set("v.isAutoOpen",false); 
                    //Road 108 changes by Murali - Changing warning message
                    var errorMessage = $A.get("$Label.c.FSL_Parent_Solution_Message");
                    component.set("v.errorMsg",errorMessage);
                    component.set("v.childSol", true);
                }  // // end of checking parent onchange accordian
            }
        }
    },
    
    continueToRepair: function(component, solId, woId) {
        var action = component.get("c.continueToRepair");
        action.setParams({
            'workId': woId,
            'solId':solId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                // karthk added below EVL_51
                var recId = window.location.href;
                var recId1 = recId.substring(0, recId.lastIndexOf('/'));
                var tabsetUrl = $A.get("$Label.c.EVL_TabSetToRepair");
                //alert('KarthiktabsetUrl>>'+tabsetUrl);
                var recId2 = recId1+'/detail?tabset-'+tabsetUrl+'&TabId=solution'; 
                //alert('recId2'+recId2);
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({ "url": recId2});   // Pass your community URL
                urlEvent.fire(); 
                var appEvent = $A.get("e.c:EVL_PathChange"); 
                //Set event attribute value
                appEvent.setParams({"statusValue" : "Triage & Diagnosis"}); 
                appEvent.fire();
                $A.get('e.force:refreshView').fire();
                // location.reload();
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
    }, 
    
    //by Mallika
    continueToSolutionInRepair: function(component, solId)
    {
        var woId = component.get("v.recordId");
        var solId = component.get("v.SoluId");
        var errorBoolRepair = false;  
        var resval= component.get("v.childevevalue");
        var  commvalue= component.get("v.comment");
        
        console.log('resval**'+resval);
        console.log('commvalue**'+commvalue);
        
        if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.')){
        	var action_2 = component.get("c.getAccSRTCheck");
            action_2.setParams({
                'solId': solId
            });
            action_2.setCallback(this, function(response){
                var state2 = response.getState();
            	console.log('state2::'+state2);
            	if(state2 === "SUCCESS"){
            		errorBoolRepair = response.getReturnValue();
            		console.log('errorBoolRepair**'+errorBoolRepair);
            		if(errorBoolRepair == true){
                		component.set("v.isOpen", true);
            			//$A.util.addClass(spinner, "slds-hide");
            			component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
                    } else {
                        this.continueToRepair(component, solId, woId);
                    } 
        		} else{
            		//errorBoolRepair = false;
            		this.continueToRepair(component, solId, woId);
        		}  
        	});
            $A.enqueueAction(action_2);
        } else {
            console.log('Outside If**'+errorBoolRepair);
            //errorBoolRepair = false;
            this.continueToRepair(component, solId, woId);
        } 
    },
    //Added by vinodyelala for audti trial on Diag
    insertPerformedDiagAuditEventLogger : function(component, event,helper,repResponse,repNotes){        
        console.log('entered performed diag audit'+component.get("v.recordId"));
        var woId=component.get("v.recordId");
        var action = component.get('c.insertPerformedDiagAuditEvent');
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            repairRadio : repResponse,
            comments : repNotes,
            woId : woId
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            console.log('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("audit event inserted");
            }           
        });
        $A.enqueueAction(action);      
        helper.insertSelectedRootCauseOnSolution(component,event,helper);
    },
    /* insertViewedSolutionOnDiagAudit: function(component, event,helper){
        var solID = component.get("v.SoluId");
        console.log('solID>>'+solID)
        var action = component.get('c.insertViewedSolutionOnDiag');
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            woId : component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("insertViewedSolutionOnRepair audit event inserted");
            }
        });
        $A.enqueueAction(action);
    }, */
    insertSelectedRootCauseOnSolution:function(component,event,helper){
        //  alert(component.get("v.selectComps"));
        //  alert(component.get("v.recordId"));
        var action = component.get('c.insertSelectedRootCauseOnSol');
        action.setParams({
            cssSolutionId : component.get("v.SoluId"),
            cssSolutionCompId : component.get("v.selectComps"),
            solId : component.get("v.recordId")
        }); 
        action.setCallback(this,function(response){
            var state = response.getState();
            // alert('state audit'+state);
            console.log(state); 
            if (state === "SUCCESS") {
                console.log("insertSelectedRootCauseOnRepair audit event inserted");
            }           
        });
        $A.enqueueAction(action);
    },  
    removeParam : function(key, sourceURL) {
    var rtn = sourceURL.split("?")[0],
        param,
        params_arr = [],
        queryString = (sourceURL.indexOf("?") !== -1) ? sourceURL.split("?")[1] : "";
    if (queryString !== "") {
        params_arr = queryString.split("&");
        for (var i = params_arr.length - 1; i >= 0; i -= 1) {
            param = params_arr[i].split("=")[0];
            if (param === key) {
                params_arr.splice(i, 1);
            }
        }
        rtn = rtn + "?" + params_arr.join("&");
    }
    return rtn;
    },
   //Road 106/107 by Murali for reverting Road 101 changes 11/29/2021 START
   /* Road 101 START - Commenting Road 7 & 56 changes by Murali */
   focusOpenaccordion: function(component,event,resval) 	
    {	
                
        var target = event.getSource();	
        var currentIndex = event.getSource().get("v.name");	
        var nextIndex = currentIndex+1;	
        var knowledgeList = component.get("v.knowledgeList");	
        var currentToggle = knowledgeList[currentIndex];
        var toggle ; 
        
        if(nextIndex<knowledgeList.length)
         {
            toggle = knowledgeList[nextIndex];	
            var toggleName = toggle.solname;
            if(currentToggle.isParent === true && toggle.nestedSolVal != null)
            {
                if(resval == 'Most likely the solution. Repair recommended.')
                {
                    component.set("v.isAutoOpen",true); 
                    component.set("v.NextToggle", toggleName); 
                }
                else
                {
                    var i = currentIndex+1;
                     for(i;i<knowledgeList.length;i++){
                         if(knowledgeList[i].isParent === true || knowledgeList[i].nestedSolVal == null )
                         {           console.log('in 3');
                             component.set("v.isAutoOpen",true); 
                             component.set("v.NextToggle", knowledgeList[i].solname); 
                             return;
                         }
                     }
                }
            }
             else if (currentToggle.isParent === false && currentToggle.nestedSolVal != null)
             {
                 if(resval != 'Most likely the solution. Repair recommended.')
                 {
                    component.set("v.isAutoOpen",true); 
                     component.set("v.NextToggle", toggleName);
                 }
                 else
                 {
                     component.set("v.isAutoOpen",false); 
                     component.set("v.NextToggle", component.get("v.activeSections")); 	
                 }
             }
            else if (currentToggle.isParent === false )
            {
                component.set("v.isAutoOpen",false); 
                component.set("v.NextToggle", component.get("v.activeSections")); 	
            }
         }
        else
        {
            component.set("v.isAutoOpen",false); 
            component.set("v.NextToggle", 'no open section'); 
        }
        
            
    }// Road 106/107 END 
})