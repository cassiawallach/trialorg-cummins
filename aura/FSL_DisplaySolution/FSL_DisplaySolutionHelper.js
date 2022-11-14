({
    getSolutionsKnw : function(component,event,activesession)
    {
        var spinner = component.find('mySpinner');
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
                $A.util.addClass(spinner, "slds-hide");
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
                                    // console.log(data[0].sname) 
                                    
                                    if(data[0].repairSol)
                                    { 
                                    component.set("v.activeSections", data[0].repairSol);	//added by Sriprada                                       
                                    // alert('def***'+data[0].repairSol);
                                    } 
                                    else if(activesession !== undefined){
                                        component.set("v.activeSections", activesession); 
                                        component.set("v.isreloads",true);  //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                                    }
                                    else {
                                        component.set("v.activeSections", data[0].defsname);
                                        //  alert('def>>>'+data[0].defsname);
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
        //Commented as part of CPS128 - By Murali 02/04/2021
         // helper.insertSelectedRootCauseOnRepair(component,event,helper); //Uncommented for Phoen-94 Audit trail bug
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
                                    //Line 174 to 178 commented for April release 
                                    /* if((response.getReturnValue().User__c== null || response.getReturnValue().User__c== ''|| response.getReturnValue().User__c == userId) && response.getReturnValue().Clock_In_User_Ids__c !=null ){
                                        component.set("v.hidelaunchinsite",true);
                                    } 
                                    else if((response.getReturnValue().User__c!= null || response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId) || response.getReturnValue().Clock_In_User_Ids__c == null ){
                                        component.set("v.hidelaunchinsite",false);
                                    } */
                                    // Line 181 to 186 added for April release need to remove after release 
                                if(response.getReturnValue().User__c== null || response.getReturnValue().User__c== ''|| response.getReturnValue().User__c == userId){
                                        component.set("v.hidelaunchinsite",true);
                                    } 
                                else if(response.getReturnValue().User__c!= null || response.getReturnValue().User__c!= '' && response.getReturnValue().User__c != userId){
                                        component.set("v.hidelaunchinsite",false);
                                    }
                                }else if (state === "INCOMPLETE")
                                {
                                    
                                    // alert('Response is Incompleted'  && component.get("v.record").Clock_In_User_Ids__c!=null ,, || component.get("v.record").Clock_In_User_Ids__c==null );
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
        console.log('InupdateSolHelper**');
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        component.set("v.showSpinner",true);
        var solID = component.get("v.SoluId");
        var resval= component.get("v.childevevalue");
        var  commvalue= component.get("v.comment");
        var  childflag=component.get("v.childSol"); 
        var parentValue=component.get("v.parentsol");
                var parentuserstamp=component.get("v.parentuserstamp");
            console.log('commvalue**'+commvalue);    
            var errorBool = false; //CT3-26
        var errorComment = false; //CT3-26 
                //var NoAccSRTCheck = component.find("checkbox").get("v.value");
                //console.log('NoAccSRTCheckInside**'+NoAccSRTCheck);
        if(resval == undefined){
            component.set("v.isOpen", true);
            component.set("v.errorMsg",'Please be sure a solution button is selected and comments are entered to continue');
            component.set("v.showSpinner",true);
                $A.util.addClass(spinner, "slds-hide");
        }
        //CT3-26:START
        console.log('resval**'+resval);
        if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.')){
            //alert('Inside MOst Likely loop');
            console.log('resvalInsideIf**'+resval);
            
            var action_1 = component.get("c.getAccSRTCheck");
            action_1.setParams({
                'solId': solID
            });
            action_1.setCallback(this, function(response){
                var state1 = response.getState();
                console.log('state1::'+state1);
                errorBool = response.getReturnValue();
                console.log('errorBool**'+errorBool);
                if(errorBool == true){
                    component.set("v.isOpen", true);
                    $A.util.addClass(spinner, "slds-hide");
                    component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
                }  
            });
            
            if(commvalue == null || commvalue == ''){
                console.log('Inside Comments If**');
                errorComment = true;
                component.set("v.isOpen", true);
                $A.util.addClass(spinner, "slds-hide");
                component.set("v.errorMsg",'Please enter comments before saving');
            }
            $A.enqueueAction(action_1);    
        }
        /*if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.') && (commvalue == null || commvalue == '')){
            console.log('Inside Second If**');
            component.set("v.isOpen", true);
            $A.util.addClass(spinner, "slds-hide");
            component.set("v.errorMsg",'Please enter comments before saving');
        }*/
        if(errorComment==false){ 
            if(parentValue != undefined && parentuserstamp == undefined){
                        component.set("v.isOpen", true);
                        //Road 108 changes by Murali - Changing warning message
                        var errorMessage = $A.get("$Label.c.FSL_Parent_Solution_Message");
                        component.set("v.errorMsg",errorMessage);
                        $A.util.addClass(spinner, "slds-hide");  
                    // component.set("v.childSol", true);
                    }   
            else{
                // checking parent perform onclick of save
            var parentValue=component.get("v.parentsol");
            var parentuserstamp=component.get("v.parentuserstamp");
            var woid = component.get("v.recordId");
            console.log('selectComps>>>'+component.get("v.selectComps"));
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
                console.log('state::'+state);
                if (resval != undefined  && commvalue != undefined || (resval =='Could not perform the solution verification') || (resval != undefined && resval !='Could not perform the solution verification' && commvalue != undefined)
                    ||(resval !='Could not perform the solution verification' && parentuserstamp != undefined) && state === "success") {
                        //console.log('insidesucess1=='+resval);
                    //component.set("v.comment",null); //CT3-26
                    //component.set("v.childevevalue",undefined); //CT3-26
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Solution comments are added',
                        type: 'success',
                    });
                    //if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.') && state === "success" && response.getReturnValue() == false){
                    if(response.getReturnValue() == true){
                    toastEvent.fire();
                        //Added by Murali for Road 106/107 Changes 11/29/2021 - START	
                        var activesession = component.get("v.activeSections");
                        var preactivesession = activesession; //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021
                      	helper.insertPerformedDiagAuditEventLogger(component,event,helper,resval,commvalue); //Infant care change by Murali for CPS 128 2/2/22
                        helper.focusOpenaccordion(component,event,resval);	
                        var nexttoggle = component.get("v.NextToggle");
                        this.getSolutionsKnw(component, event, activesession);//Infant care change by Murali for CPS 128 2/2/22
                        
                        //Infant care change by Murali for CPS 128 2/2/22 - START
                        //helper.insertPerformedDiagAuditEventLogger(component,event,helper,resval,commvalue); 
                        component.set("v.isreloads",false);
                        if(activesession != nexttoggle)
                        {
                            setTimeout(function()
                                       { 
                                        component.set("v.isreloads",false); 
                                        component.set("v.activeSections",nexttoggle);                                          
                                       }, 5000)  
                        }
                        else
                        {
                            component.set("v.isreloads",true); 
                        } //END CPS 128
                      //Commented by Murali for CPS128 changes 2/4/2022
                        //Added by Murali for Road 106/107 Audit trail Changes 12/16/2021 
                      /*component.set("v.isreloads",false);
                      var nexttoggle = component.get("v.NextToggle");
                        if(preactivesession == nexttoggle)
                         {
                              component.set("v.activeSections", component.get("v.NextToggle")); //Infant care change by Murali for CPS 128 2/2/22
                              component.set("v.isreloads",true); 
                         }*/
                         //this.getSolutionsKnw(component, event, activesession); //Infant care change by Murali for CPS 128 2/2/22
                    //added by Mani  PHEON - 33 -->
                      //component.set("v.isreloads",true); //Commented by Murali for 106/107 changes 12/16/2021. Moved the logic to above method as it is conflicting with the audit trail updates
                    //added by Mani  PHEON - 33 -->
                            //  location.reload();//added by vinod for reloading -7/11	
                        }	
                            
                    }	
                    else if(state === "success")	
                    {	 
                        //Added by Murali for Road 106/107 Audit trail Changes - 12/16/2021
                        $A.util.addClass(spinner, "slds-hide");
                        helper.focusOpenaccordion(component,event,resval);	
                        component.set("v.activeSections", component.get("v.NextToggle"));   
                    }
                else if (state === "INCOMPLETE")
                {
                    // alert('Response is Incompleted');
                }else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // console.log("Error message: " + errors[0].message);
                        } //Added by Murali for Road 106/107 Changes - END
                    } else {
                        // alert("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
            }
        }
    },
    //by Mallika
    setLPTsListViewHelper: function(component,event,helper) {
        var spinner = component.find('mySpinner');
        var toggl = event.getParam("openSections");
            var a = event.getSource();
        component.set("v.activeSections", toggl);
        var knowledgeList = component.get("v.knowledgeList");
        for(var i=0;i<knowledgeList.length;i++){
            if(toggl.includes(knowledgeList[i].solname)){
                // alert('selectedSolutionId:'+knowledgeList[i].kurlName);
                component.set("v.comment",knowledgeList[i].solcomm); //Infant care change by Murali for CPS 128 2/2/22
                component.set("v.SoluId",knowledgeList[i].kurlName);
                //component.set("v.comment",knowledgeList[i].solcomm); //Infant care change by Murali for CPS 128 2/2/22
                //alert('selected option:'+knowledgeList[i].parentUserStamp);
                component.set("v.childevevalue",knowledgeList[i].soldiagnostic);
                // checking parent perform onchange accordian
                component.set("v.parentuserstamp",knowledgeList[i].parentUserStamp);
                component.set("v.parentsol",knowledgeList[i].nestedSolVal);
                var parentValue=component.get("v.parentsol");
                var parentuserstamp=component.get("v.parentuserstamp");
                //alert('parentValue == '+parentValue);
                //alert('parentuserstamp == '+parentuserstamp);
                // Road 106 by Murali 1/11/2022
                //var isAutoOpenChild = component.get("v.isAutoOpen"); //Commented for CPS 128
                if(parentValue != undefined && parentuserstamp == undefined){
                    component.set("v.isOpen", true);
                   // component.set("v.isAutoOpen",false); //Commented for CPS 128
                    //Road 108 changes by Murali - Changing warning message
                    var errorMessage = $A.get("$Label.c.FSL_Parent_Solution_Message");
                    component.set("v.errorMsg",errorMessage);
                    component.set("v.childSol", true);
                    $A.util.addClass(spinner, "slds-hide");
                }   // end of checking parent onchange accordian
                
            }
        }
    },
    
    //by Mallika
    continueToSolutionInRepair: function(component, event,helper)
    {
        var woId = component.get("v.recordId");
        //var solutionId = solId;
        var solId = component.get("v.SoluId");
        var errorBoolRepair = false;  
        //alert(solId);
        //CT3-26:START
        /*var action_2 = component.get("c.getAccSRTCheck");
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
            $A.util.addClass(spinner, "slds-hide");
            component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
            } 
        } 
        else{
            errorBoolRepair = false;
        }  
        });
            $A.enqueueAction(action_2);*/
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        component.set("v.showSpinner",true);
        var resval= component.get("v.childevevalue");
        var  commvalue= component.get("v.comment");
        
        console.log('resval**'+resval);
        console.log('commvalue**'+commvalue);
        if((resval == 'Most likely the solution. Repair recommended.'|| resval == 'Not the solution. Continue troubleshooting.')){
            //alert('Inside MOst Likely loop');
            console.log('resvalInsideIfRepair**'+resval);
            console.log('errorBoolRepairInMyIf**'+errorBoolRepair);
            if(errorBoolRepair == true){
                component.set("v.isOpen", true);
            $A.util.addClass(spinner, "slds-hide");
            component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
            } 
            //errorBoolRepair = false;
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
            $A.util.addClass(spinner, "slds-hide");
            component.set("v.errorMsg",'Please select Access SRTs from Open the Access SRT checklist or click No Access SRT required checkbox');
            } 
        } 
        else{
            errorBoolRepair = false;
        }  
        });
            $A.enqueueAction(action_2);
            /* if(commvalue == null || commvalue == ''){
                console.log('Inside Comments If**');
            component.set("v.isOpen", true);
            $A.util.addClass(spinner, "slds-hide");
            component.set("v.errorMsg",'Please enter comments before saving');
            }*/
            
        }
        console.log('Outside If**'+errorBoolRepair);
            if(errorBoolRepair==false){ //CT3-26:END
            console.log('Inside If**');
        var action = component.get("c.continueToRepairNew");
        action.setParams({
            'workId': woId,
            'solId': solId,
            'resval': resval
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            var setError = response.getReturnValue();
            console.log(state);
            console.log('setError::'+setError);
            if (state === "SUCCESS")
            {
                if(response.getReturnValue() == true)
                location.reload();
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
    /* Road 106/107 by Murali 11/29/2021 - START */
    // Commented isAutoOpen as part of CPS 128 changes by Murali - 2/4/2022
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
                    //component.set("v.isAutoOpen",true);
                    component.set("v.NextToggle", toggleName); 
                }
                else
                {
                    var i = currentIndex+1;
                     for(i;i<knowledgeList.length;i++){
                         if(knowledgeList[i].isParent === true || knowledgeList[i].nestedSolVal == null )
                         {           console.log('in 3');
                             //component.set("v.isAutoOpen",true); 
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
                     //component.set("v.isAutoOpen",true);
                     component.set("v.NextToggle", toggleName); 	
                 }
                 else
                 {
                     //component.set("v.isAutoOpen",false);
                     component.set("v.NextToggle", component.get("v.activeSections")); 	
                 }
             }
            else if (currentToggle.isParent === false )
            {
                //component.set("v.isAutoOpen",false);
                component.set("v.NextToggle", component.get("v.activeSections")); 	
            }
         }
        else
        {
            //component.set("v.isAutoOpen",false);
            component.set("v.NextToggle", 'no open section'); 
        }
        
            
    },/* ROAD 106/107 END */
    //236 changes by Murali 2/15/22
    resetRadioButton: function(component,event,resval)
    {
        var  cmpRadio = component.find('radioCmp');
        var chIndex = component.get('v.selectIndx');
    	if(typeof(chIndex) != 'undefined'  )
        { 
            var childcmp = cmpRadio[chIndex];
            childcmp.resetRadioButton();
        }
        
    }
    
    
    })