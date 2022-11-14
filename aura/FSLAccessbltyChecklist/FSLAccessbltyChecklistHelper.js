({
    
    getSRTsHelper : function(component,event)
    {
        var woId = component.get("v.recordId");
        console.log(woId);
        var recordTypeNameValue =  component.get("v.recordTypeName");
      	var action="";
        
        
        action = component.get("c.getAccessbilitySRTs");
        /* if(component.get("v.recordTypeName")=="SolutionRepair"){
           //   alert('Solution Repair')
              action = component.get("c.getAccessbilityRepairSRTs");
        }else{
           //   alert('T&D')
          action = component.get("c.getAccessbilitySRTs");
        } */
        
        // alert(action)
        // alert(action)
        action.setParams
        (
            {
                'woId': woId,
                'cssSolId': component.get("v.cssSolId")
            }
        );
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var data = response.getReturnValue();
                console.log('data>>'+data);
                if(data == null)
                {
                    /* var resultsToast = $A.get("e.force:showToast");
                    resultsToast.setParams ({
                        "type": "Error",
                        "title": "Something went wrong while retrieving Accessibility Checklist data.",
                        "message": "Please check with admin or helpdesk team."
                    });
                    //resultsToast.fire(); */
                    component.set("v.isOpen", true);
                    //Starts- added by vinod to show spinner as well as show no SRTs found msg - 9/6
                    component.set("v.noRespFound", true);
                    component.set("v.showSpinner",false);
                    component.set("v.fetchSRT",false);
                    component.set("v.openModelCmp",true);
                    //Ends- added by vinod to show spinner as well as show no SRTs found msg - 9/6
                }
                else
                {
                    component.set("v.isOpen", true);
                    if(data.length == 0)
                        component.set("v.noRespFound", true);
                    else
                    {
                        //component.set("v.cssSRTs", data);
                        if(data.length > 0)
                        {
                            component.set('v.cssSRTs', data);
                            var pageSize = component.get("v.pageSize");
                            var totalRecordsList = data;
                            var totalLength = totalRecordsList.length ;
                            component.set("v.totalRecordsCount", totalLength);
                            component.set("v.startPage",0);
                            component.set("v.endPage",pageSize-1);
                            
                            var PaginationLst = [];
                            for(var i=0; i < pageSize; i++){
                                if(component.get("v.cssSRTs").length > i)
                                {
                                    console.log(data[i].cssSrt);
                                    PaginationLst.push(data[i]);    
                                } 
                            }
                            component.set('v.PaginationList', PaginationLst);
                            component.set("v.selectedCount" , 0);
                            console.log("'v.PaginationList Done");
                              // added by Sailaja Guntupalli for access SRT
                            component.set('v.orginalSRTList', JSON.parse(JSON.stringify(data)));
                            console.log("'v.orginalSRTList Done", component.get('v.orginalSRTList'));
                            console.log("'v.orginalSRTList Done");
                            //use Math.ceil() to Round a number upward to its nearest integer
                            component.set("v.totalPagesCount", Math.ceil(totalLength / pageSize));  
                            var recsToSave =[];
                            var selectedRecKeys=[];
                            component.set("v.selectedRecKeys", selectedRecKeys);
                            component.set("v.recsToSave", recsToSave);
                        }
                        else
                        {
                            // if there is no records then display message
                            component.set("v.bNoRecordsFound" , true);
                        }
                    }
                    component.set("v.showSpinner",false);
                    component.set("v.fetchSRT",false);
                    component.set("v.openModelCmp",true);
                    console.log('in helper class::'+component.get("v.openModelCmp"));
                }
            }
        });        
        $A.enqueueAction(action);
    },
    saveSRTsHelper : function(component,event)
    {
        /*Starts Added by vinod 9/5*/
        var recsToSave=[];
        var totalRecs=[];
        totalRecs = component.get("v.PaginationList");
        recsToSave = component.get("v.recsToSave");
        console.log('recsToSave length::'+recsToSave.length);
        /*Ends */
        if(recsToSave.length > 0 && totalRecs.length > 0 )            
        {
            component.set("v.openModelCmp", false); 
            component.set("v.disableNoAccSRT",true); //CT3-25
            var action = component.get("c.saveSRTsToDB");
            var woId = component.get("v.recordId");
            action.setParams
            (
                {
                    'cssSRTs': component.get("v.recsToSave"),
                    'woId': woId,
                    'cssSolId': component.get("v.cssSolId")
                }
            );
            action.setCallback(this, function(response)
                               {
                                   var state = response.getState();
                                   console.log(state);
                                   if (state === "SUCCESS")
                                   {
                                        component.set('v.orginalSRTList', component.get("v.PaginationList")); //CT3-632 Changes by Murali
                                        $A.get('e.force:refreshView').fire();
                                       var data = response.getReturnValue();
                                       console.log('save result flag>>'+data );
                                       var resultsToast = $A.get("e.force:showToast");
                                       if(data == true)
                                       {
                                           component.set('v.orginalSRTList', JSON.parse(JSON.stringify(component.get('v.PaginationList'))));                                           
                                           resultsToast.setParams ({
                                               "type": "Success",
                                               "message": $A.get("$Label.c.FSLSRTsSaved")                                       
                                           });
                                                 	
                                          // alert('hi1');	
                                           //debugger;	
                                            component.set('v.noOneSelected', true);	
                                                   component.set('v.disableNoAccSRT', false);	
                                            	
                                           var totalRecsnew=[];	
                                           totalRecsnew = component.get("v.PaginationList");	
                                           for(var k in totalRecsnew)	
                                           {	
                                               if(totalRecsnew[k].isSelected)	
                                               {	
                                                   component.set('v.noOneSelected', false);	
                                           component.set('v.disableNoAccSRT', true);	
                                                  	
                                               }	
                                           }	
                                          
                                           resultsToast.fire();	
                                           //component.set(orginalSRTList, component.get("v.PaginationList")); //CT3-632 Changes by Murali
                                        //  this.orginalSRTList = component.get("v.PaginationList");	
                                         //  location.reload();//added by vinod 10/2 //Commented by sailaja guntupalli to not reload the page upon save

                                      
                                       }
                                       else
                                       {
                                           resultsToast.setParams ({
                                               "type": "Error",
                                              "message": $A.get("$Label.c.FSLSRTsSavingError")
                                           });
                                           resultsToast.fire();	
                                       }
                                   }
                                   else if (state === "ERROR") {
                                       var errmsg= '';
                                        var errors = response.getError();
                                        if (errors) {
                                            if (errors[0] && errors[0].message) {
                                                // log the error passed in to AuraHandledException
                                                console.log("Error message: " + 
                                                         errors[0].message);
                                                errmsg += errors[0].message;
                                            }
                                        } else {
                                            console.log("Unknown error");
                                            errmsg += 'Unknown error';
                                        }
                                       
                                   }
                               });        
            $A.enqueueAction(action);
            }	
        else{	
          component.set("v.AccessSRTCheckbox",false);
          component.set('v.disableNoAccSRT', false);
          component.set("v.openModelCmp",false);
        }
        /*else if(recsToSave.length == 0 && totalRecs.length > 0 )
        {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams ({
                "type": "Error",
                 "message": $A.get("$Label.c.FSLNoRowselection")
            });
            resultsToast.fire();	
        }*/
    },
    
    // navigate to next pagination record set   
    next : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i = end + 1; i < end + pageSize + 1; i++){
            if(sObjectList.length > i){ 
                //if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                //}else{
                  //  Paginationlist.push(sObjectList[i]);  
                //}
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    // navigate to previous pagination record set   
    previous : function(component,event,sObjectList,end,start,pageSize){
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                /*if(component.find("selectAllId").get("v.value")){
                    Paginationlist.push(sObjectList[i]);
                }else{*/
                    Paginationlist.push(sObjectList[i]); 
                //}
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.PaginationList', Paginationlist);
    },
    saveSelectedHelper: function(component,event)
    {
        component.set("v.isSaveCloseHit",true);
        var currentRecs = [];
        currentRecs = component.get('v.PaginationList');
        var selectedRecs=[];
        var prevSelectedRecs = [];
        prevSelectedRecs=component.get("v.recsToSave");
        var totalSelectedRecs=prevSelectedRecs.length;
        var selectedRecKeys=[];
        selectedRecKeys = component.get("v.selectedRecKeys");
        console.log('selectedRecKeys>>'+selectedRecKeys.length);
        console.log('selectedRecKeys>>'+currentRecs.length);
        var showErrorAlert=false;
        var noOneSelected = true;
        for(var i=0; i<currentRecs.length; i++)
        {
            //if(currentRecs[i].isSelected == true)
            {
                if((currentRecs[i].isSelected == false && 
                    currentRecs[i].cssSrt.Id != null && 
                    currentRecs[i].cssSrt.Id != ''  &&
                    currentRecs[i].cssSrt.Id != undefined) ||
                   (currentRecs[i].isSelected == true && 
                    currentRecs[i].cssSrt.SRT_Quantity__c > 0 && 
                    currentRecs[i].cssSrt.SRT_Quantity__c <= 9999))
                {
                      console.log('select key:'+currentRecs[i].cssSrt.Name);
                      console.log('select SRT_Quantity__c:'+currentRecs[i].cssSrt.SRT_Quantity__c);
                    var indx=selectedRecKeys.indexOf(currentRecs[i].cssSrt.Name);
                    //CT3-613 Changes done by Murali
                    if(indx > -1)
                    {
                        prevSelectedRecs[indx]=currentRecs[i];
                        if(currentRecs[i].isSelected == false && 
                            currentRecs[i].cssSrt.Id != null && 
                            currentRecs[i].cssSrt.Id != ''  &&
                            currentRecs[i].cssSrt.Id != undefined)
                        prevSelectedRecs[indx].cssSrt.Id = null;
                    }
                    else
                    {
                        selectedRecKeys[totalSelectedRecs]=currentRecs[i].cssSrt.Name;
                        prevSelectedRecs[totalSelectedRecs]=currentRecs[i];
                        ++totalSelectedRecs;
                    }
                }
                else if(currentRecs[i].isSelected == true)
                {
                    showErrorAlert=true;
                     //Newly added by Harsha START	
                    noOneSelected = false;	
                     //Newly added by Harsha END
                    break;
                }
            } 
            /*else
            {
                console.log(selectedRecKeys);
                var indx=selectedRecKeys.indexOf(currentRecs[i].cssSrt.Name);
                console.log('1--indx>>'+indx);
                if(indx>-1)
                {
                    console.log('12');
                    selectedRecKeys.splice(indx, 1);
                    console.log('123');
                    prevSelectedRecs.splice(indx, 1);
                    console.log('1234');
                }
            }*/
            
            //prevSelectedRecs.push(currentRecs[i]);
        }
        //Newly added by Harsha START	
        if(noOneSelected){	
            component.set("v.noOneSelected",true);	
        }else{	
            component.set("v.noOneSelected",false);	
            component.set("v.disableNoAccSRT",true);	
        }	
        	        	
        //Newly added by Harsha END
        console.log('showErrorAlert>>'+showErrorAlert);
        if(showErrorAlert == true)
        {
            var resultsToast = $A.get("e.force:showToast");
            resultsToast.setParams ({
                "type": "Error",
                "message": $A.get("$Label.c.FSLAccessChklistQtySavealert")
            });
            resultsToast.fire(); 
             component.set("v.hasValidData",false);
        }
        else
        {   
            component.set("v.recsToSave", prevSelectedRecs);
            component.set("v.selectedRecKeys", selectedRecKeys);
            console.log('selectedRecKeys length>>'+selectedRecKeys.length+'<>prevSelectedRecs length>'+prevSelectedRecs.length);
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
    logAccessSRTAuditEventHelper: function(component, event, helper) {
        //console.log('woID == '+woID);        
        var action = component.get("c.logAccessSRTAuditEvent");
        action.setParams({
            'woId': component.get("v.recordId"),
            'cssSolId': component.get("v.cssSolId")
            
        });
        action.setCallback(this, function(response)
                           {
                               var state = response.getState();
                               console.log(state);
                               if (state === "SUCCESS")
                               {
                                   var data = response.getReturnValue();
                                   console.log('OverView data =: '+data);
                                   //component.set("v.overViewDetail",JSON.parse(data));
                               }
                           });
        $A.enqueueAction(action);
    },
    
     showSpinner : function (component, event, helper) {
        var spinner = component.find('mySpinner');
        $A.util.removeClass(spinner, "slds-hide");
        /*window.setInterval(
            $A.getCallback(function() { 
                $A.util.addClass(spinner, "slds-hide");
            }), 15000
        );*/
    }
})