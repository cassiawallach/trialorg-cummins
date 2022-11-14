({
    doInit : function(component, event, helper)
    {
        console.log('---0WO0r0000013sVlGAI');
        var woID = component.get('v.recordId') ;
        var action2 = component.get('c.getAssetId');
        woID = component.get('v.recordId') ;        
        action2.setParams({
            "woId" : woID            
        });            
        action2.setCallback(this, function(a) 
                            {
                                var state = a.getState();
                                console.log('action status:::'+state);
                                if (state === "SUCCESS")
                                {
                                    console.log(a.getReturnValue());
                                    component.set("v.assetId", a.getReturnValue());
                                }
                            }
                           );
        //helper.getmakeModelsHelper(component, event, helper);
        var action3 = component.get('c.getWOMakeModels');
        woID = component.get('v.recordId') ;        
        action3.setParams({
            "woId" : woID            
        });
        action3.setCallback(this, function(a) 
                            {
                                var state = a.getState();
                                console.log('action status:::'+state);
                                if (state === "SUCCESS")
                                {
                                    console.log(a.getReturnValue());
                                    var womakemodel=[];
                                    
                                    womakemodel = a.getReturnValue();
                                    console.log('first value::'+womakemodel[0]);
                                    console.log('second value::'+womakemodel[1]);
                                    //   if(womakemodel.length == 2)
                                    {
                                        //added condition by vinod 9/25
                                        if(womakemodel[0] != undefined)
                                            component.set("v.selectedMake",womakemodel[0]);
                                        //added condition by vinod 9/25
                                        if(womakemodel[0] != undefined)
                                            component.set("v.selectedModel",womakemodel[1]);
                                        console.log('selected maker::'+component.get("v.selectedMake"));
                                        console.log('selected model::'+component.get("v.selectedModel"));
                                        helper.getmakeModelsHelper(component, event, helper);
                                    }
                                }
                            }
                           ); 
        
        
        $A.enqueueAction(action3);        
        $A.enqueueAction(action2);
        var action4 = component.get('c.getAppErrorMsg');
        action4.setParams({
            "woId" : woID            
        });
        action4.setCallback(this, function(response){
            var state = response.getState();
            console.log("State"+state);
            if(state === "SUCCESS") {
                
                var appErrMsg = response.getReturnValue();
                component.set('v.appErrorMsg', appErrMsg);
                console.log('::: getAppErrorMsg - '+appErrMsg);
                helper.fetchTypePicklist(component); 
            }
        });
        
        var action = component.get('c.getApplicationCode');
        woID = component.get('v.recordId') ;        
        action.setParams({
            "woId" : woID            
        });
        action.setCallback(this, function(a) 
                           {
                               var state = a.getState();
                               console.log('action status:::'+state);
                               if (state === "SUCCESS")
                               {
                                   //alert(a.getReturnValue());
                                   console.log(a.getReturnValue());
                                   var woAppCode=[];
                                   
                                   woAppCode = a.getReturnValue();
                                   component.set("v.appPicklist",woAppCode);
                                   //component.set("v.selectedApplicationCode",woAppCode);
                                   helper.fetchTypePicklist(component); 
                                   
                               }
                               
                           }
                          ); 
         //Below method Added by Added by Priyanka on 11/10/2021 | VGRS-76 for Application definition LOV 
         var action5 = component.get('c.getApplicationDescMetadata');
       	  action5.setCallback(this, function(a) 
                           {
                                var state = a.getState();
                                //alert('action status:::'+state);
                                if (state === "SUCCESS")
                                {
                                    //alert(a.getReturnValue());
                                    //alert(JSON.stringify(a.getReturnValue()));
                                    component.set("v.ApplicationMetadataMap",a.getReturnValue()); 
                                    setTimeout(function(){helper.FetchSelectedAppDescription(component,event,helper);  }, 3000);
                                    // helper.FetchSelectedAppDescription(component,event,helper); // Added by Priyanka on 11/10/2021 | VGRS-76
                                }
                             }
                           ); 
        var action6 = component.get("c.fetchWORecord");
        action6.setParams({ recordId : component.get("v.recordId") });
        action6.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var resp = response.getReturnValue();
                if(resp.Status == "Closed"){
                    component.set("v.isAssetLocked",true);
                    component.set("v.isClosed", true);
                }
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
        $A.enqueueAction(action6);  

        $A.enqueueAction(action);  
        $A.enqueueAction(action4); 
        $A.enqueueAction(action5); // Added by Priyanka on 11/10/2021 | VGRS-76
        
    },
    
       //Added by Priyanka on 11/10/2021 | VGRS-76
    getSelectedAppDescription : function(component,event,helper){
        helper.FetchSelectedAppDescription(component,event,helper);
    },  
    eventHandler : function(component, event, helper){
      $A.get('e.force:refreshView').fire();   
    },
    loadModels : function(component, event, helper)
    {
        var makeModelMap = component.get("v.makeModelsMap");
        component.set("v.selectedModel",'');
        //console.log('makeModelMap::'+makeModelMap)
        var isValidMake=false;
        var currentModelVal = component.get("v.selectedModel");
        console.log('currentModelVal>>'+currentModelVal);
        for( var key in makeModelMap)
        {
            //console.log('key:::'+makeModelMap[key].maker);
            if(makeModelMap[key].maker == component.get("v.selectedMake"))
            {
                //console.log('inside for loop sym values::'+makeModelMap[key].maker);
                var symparr=[];
                symparr = makeModelMap[key].models;
                var indx = symparr.indexOf(currentModelVal);
                console.log('row index>>'+indx);
                if(indx > -1) 
                    symparr.splice(indx,1);
                component.set("v.modelsList",makeModelMap[key].models);  
                isValidMake=true;
                break;
            }
            /*else if(component.get("v.selectedMake") == 'Choose one ..')
            {
                component.set("v.modelsList",'');
                component.set("v.selectedModel",'');
                break;
            }*/
            //symptomCatArr.push({sympCat:key, symptom:symptomCatgyMap[key]});            
        }
        if(isValidMake == false)
        {
            component.set("v.modelsList",'');
            component.set("v.selectedModel",'');
        }
        component.set("v.makeModelChange", true);
        component.set("v.MMFlag", true);
        console.log(component.get("v.modelsList"));
    },
    
    onModelChange : function(component, event, helper)
    {
        component.set("v.makeModelChange", true);
        component.set("v.MMFlag", true);
        console.log('::: ModelChange = '+component.get("v.makeModelChange"));
    }, 
    
    onAppCodeChange : function(component, event, helper)
    {
        component.set("v.appCodeChange", true);
        component.set("v.MMFlag", true)
        console.log('::: AppCodeChange = '+component.get("v.appCodeChange"));
    },
    
    
 
    saveMakeModelsOnWO : function(component, event, helper)
    {
        console.log('::saveMakeModels'+component.get("v.assetId"));
        var selmodel=component.get("v.selectedModel");
        var selmake=component.get("v.selectedMake");
        var applCode = component.get("v.selectedApplicationCode");
        console.log('::: ApplCode - '+applCode);
        console.log('selmodel 103 '+ selmodel);
        console.log('selmake 104 '+ selmake);
        var appCode = component.find("makeAppCodeList").get("v.value");
        console.log('::: appCode - '+appCode);
        console.log('*** Application Code - '+component.get("v.selectedApplicationCode"));
        if(appCode == '' || appCode == undefined || appCode == '--None--'){
            var toastEventError = $A.get("e.force:showToast");
            toastEventError.setParams({
                message: $A.get("$Label.c.EVL_Select_Application_Code_Message"),
                type: 'error',
            });
            toastEventError.fire();
        }
        else{
            if(appCode != '' || appCode != undefined || selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined){
                console.log(':::: before getAppCodeHelper');
                helper.getAppCodeHelper(component, event, appCode);
            }
                if(selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined) {
                    console.log('ERROR');
                    console.log('make 106'+ selmodel);
                    console.log('mooooodel 107 '+ selmake);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message: 'Make and/or Model fields are missing',
                        type: 'error',
                    });
                    toastEvent.fire();
                }
                else
                {
                    console.log('SUCCESS');
                    var action = component.get('c.saveMakeModels');
                    console.log('assetId', component.get("v.assetId"));
                    console.log('make', component.get("v.selectedMake"));
                    console.log('Flag', component.get("v.MMFlag"));

                    console.log('model', component.get("v.selectedModel"));
                    console.log('RecId', component.get("v.recordId"));
                    action.setParams({
                        "atId" : component.get("v.assetId"), 
                        "make" : component.get("v.selectedMake"),
                        "model" : component.get("v.selectedModel"),
                        "woId" : component.get("v.recordId"),
                        "app" : component.get("v.selectedApplicationCode"), // added by PiyushR for CT1-642 passing Application Code  
                        "flag" : component.get("v.MMFlag")

                    }); 
                    console.log('aaaa');
                    action.setCallback(this, function(a) 
                                       {
                                           console.log('inside aaaa');
                                           var state = a.getState();
                                           
                                           console.log('action status:::'+state);
                                           if (state === "SUCCESS")
                                           {
                                               var isMMChange = component.get("v.makeModelChange");
                                               var isChange = component.get("v.appCodeChange");
                                               var isChangeFlag = component.get("v.MMFlag");

                                               var makeModelToast = $A.get("e.force:showToast");
                                               var appCodeToast = $A.get("e.force:showToast");
                                               console.log(a.getReturnValue());
                                               console.log('::: Toast Values'+isMMChange+' & App Code - '+isChange);
                                               if(a.getReturnValue() == true && isMMChange == true) {
                                                   component.set("v.makeModelChange", false);
                                                   component.set("v.MMFlag", false);
                                                   makeModelToast.setParams ({
                                                       "type": "Success",
                                                       "message": $A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                                                   });
                                               }
                                               if(a.getReturnValue() == true && isChange == true)
                                               {
                                                   component.set("v.appCodeChange", false);
                                                   component.set("v.MMFlag", false);
                                                   appCodeToast.setParams ({
                                                       "type": "Success",
                                                       "message": $A.get("$Label.c.EVL_Application_updated_successfully")
                                                   });
                                                   
                                               } 
                                               if(a.getReturnValue() == true && isMMChange == true && isChange == true ){
                                                   component.set("v.makeModelChange", false);
                                                   component.set("v.appCodeChange", false);
                                                   component.set("v.MMFlag", false);
                                                   makeModelToast.setParams ({
                                                       "type": "Success",
                                                       "message": $A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                                                   });
                                                   appCodeToast.setParams ({
                                                       "type": "Success",
                                                       "message": $A.get("$Label.c.EVL_Application_updated_successfully")
                                                   });
                                               }
                                               //$A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                                              /* else
                                               {
                                                   resultsToast.setParams ({
                                                       "type": "Error",
                                                       "message": $A.get("$Label.c.FSLMakeModelUpdateFailureAlert")
                                                   });
                                                   
                                               }*/
                                               makeModelToast.fire();
                                               appCodeToast.fire();
                                               location.reload();
                                           }
                                       });
                    $A.enqueueAction(action);
                }
            }            
        }
})