({
    doInit : function(component, event, helper)
    {
        component.set("v.showSpinner",false);

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
        woID = component.get('v.recordId');        
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
        
        var action4 = component.get('c.getAppErrorMsg');
        action4.setParams({
            "woId" : woID            
        });
        action4.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS") {
                var appErrMsg = response.getReturnValue();
                component.set('v.appErrorMsg', appErrMsg);
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
                                    component.set("v.selectedApplicationCode",woAppCode);
                                   helper.fetchTypePicklist(component); 

                                }

                            }
                           ); 
               
        //Below method Added by Sripal Kotha for Application definition LOV on 03/05/2021 |CT2-85
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
                                     helper.FetchSelectedAppDescription(component,event,helper); // Added by Sripal Kotha on 03/05/2021 | CT2-85
                                }
                             }
                           ); 


		//Below method Added by Harish Kolasani for CT2-         
        var action6 = component.get('c.isAssetCumminsOrNot');
        woID = component.get('v.recordId') ;  
        action6.setParams({
            "woId" : woID            
        });
        action6.setCallback(this, function(a) 
                            {
                                var state = a.getState();
                                console.log('action status::: action6::'+state);
                                if (state === "SUCCESS")
                                {
                                    console.log(a.getReturnValue());
                                    component.set("v.isCumminsAsset", a.getReturnValue());
                                    /*component.set("v.selectedMake", '');
                                    component.set("v.selectedModel", '');*/
                                    if(a.getReturnValue()){
                                          /* $A.enqueueAction(action);         
                                        $A.enqueueAction(action4);
                                        $A.enqueueAction(action3);        
                                        $A.enqueueAction(action2);
                                        $A.enqueueAction(action5);  // Added by Sripal Kotha on 03/05/2021 | CT2-85    */                                 
                                    }else{
                                    }
                                }
                            }
                           );
        
        
        $A.enqueueAction(action);         
        $A.enqueueAction(action4);
        $A.enqueueAction(action3);        
        $A.enqueueAction(action2);
        $A.enqueueAction(action5);  // Added by Sripal Kotha on 03/05/2021 | CT2-85 
        $A.enqueueAction(action6);  // Added by Harish Kolasani 
    },
    //Added by Sripal Kotha on 03/05/2021 | CT2-85
    getSelectedAppDescription : function(component,event,helper){
        helper.FetchSelectedAppDescription(component,event,helper);
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
        console.log(component.get("v.modelsList"));
    },
    saveMakeModelsOnWO : function(component, event, helper)
    {
        component.set("v.showSpinner",true);

        console.log('saveMakeModels'+component.get("v.assetId"));
        console.log('saveMakeModels@'+component.get("v.selectedMake"));
        console.log('saveMakeModels@@'+component.get("v.selectedMake"));
        var selmodel=component.get("v.selectedModel");
        var selmake=component.get("v.selectedMake");
        var appCode = component.find("makeAppCodeList1").get("v.value");
        console.log('saveMakeModels@@'+component.find("makeAppCodeList1").get("v.value"));
        if(appCode != '' || appCode != undefined || selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined){
            console.log('aaaattt00');
            helper.getAppCodeHelper(component, event, appCode);
            console.log('aaaattt');
            
        }

        if(selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined) {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Make and/or Model fields are missing',
                type: 'error',
            });
            toastEvent.fire();
        }
        else
        {
            console.log('aaaa@@');
            var action = component.get('c.saveMakeModels');
            action.setParams({
                "atId" : component.get("v.assetId"), 
                "make" : component.get("v.selectedMake"),
                "model" : component.get("v.selectedModel"),
                "woId" : component.get("v.recordId")
            }); 
            console.log('aaaa');
            action.setCallback(this, function(a) 
            {
                console.log('inside aaaa ');
                var state = a.getState();
                console.log('action status:::'+state);
                if (state === "SUCCESS")
                {
                    // alert(appCode);
                    var resultsToast = $A.get("e.force:showToast");

                    console.log(a.getReturnValue());
                    if(a.getReturnValue() == true)
                    {                                     
                        helper.getAppCodeHelper(component, event, appCode,true);
                        resultsToast.setParams ({
                            "type": "Success",
                            "message": $A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                        });
                        resultsToast.fire();
                    //   location.reload();
                    }//$A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                    /* else
                    {
                        resultsToast.setParams ({
                            "type": "Error",
                            "message": $A.get("$Label.c.FSLMakeModelUpdateFailureAlert")
                        });
                    }*/
                    
                }
                else{
                    console.log('action message:::'+a.getError()[0].message);
                }
                component.set("v.showSpinner",false);
                location.reload();
                

            });
            $A.enqueueAction(action);
        }
    },
    saveMakeModelsOnWOForNonCumminsAsset : function(component, event, helper)
    {
        console.log('Inside NonAsset Method ::');
        //component.set("v.showSpinner",true);
        var selmodel=component.get("v.selectedModel");
        var selmake=component.get("v.selectedMake");
        //component.set("v.showSpinner",true);
        console.log('selectedModel::'+ selmodel);
        console.log('selectedMake::'+selmake);
        var appCode = component.find("makeAppCodeList").get("v.value");
        console.log('saveMakeModels@@23'+component.find("makeAppCodeList").get("v.value"));
        console.log('saveMakeModels'+component.get("v.assetId"));

       if(appCode != '' || appCode != undefined || selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined){
            helper.getAppCodeHelper(component, event, appCode);
            
        }
        if(selmake == '' || selmodel == '' || selmake == undefined || selmodel == undefined) {
            console.log('Inside Error Message ::');
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                message: 'Make and/or Model fields are missing',
                type: 'error',
            });
            toastEvent.fire();
        }
        else
        {
            component.set("v.showSpinner",true);
            var action = component.get('c.saveMakeModelsForNonCumminsAsset');
            action.setParams({
                "atId" : component.get("v.assetId"), 
                "make" : component.get("v.selectedMake"),
                "model" : component.get("v.selectedModel"),
                "woId" : component.get("v.recordId")
            }); 
            console.log('aaaa');
            action.setCallback(this, function(a) 
                               {
                                   console.log('inside aaaa');
                                   var state = a.getState();
                                   console.log('action status:::'+state);
                                   
                                   if (state === "SUCCESS")
                                   {
                                      // alert(appCode);
                                       var resultsToast = $A.get("e.force:showToast");

                                      
                                       if(a.getReturnValue() == true)
                                       {                                     
                                           //helper.getAppCodeHelper(component, event, appCode,true);
                                           resultsToast.setParams ({
                                               "type": "Success",
                                               "message": $A.get("$Label.c.FSLMakeModelUpdateSuccessAlert")
                                           });
                                            resultsToast.fire();
                                           console.log('action value:::'+a.getReturnValue());
                                       }
                                      
                                   }
                                  component.set("v.showSpinner",false);
                                  location.reload();
                                   

                               });
            $A.enqueueAction(action);
        }
    }
})