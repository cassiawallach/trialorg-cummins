({
    checkForLockAsset : function(component, event, helper) {
        console.log('checkForLockAsset');
        var action = component.get('c.getLockAssetStatus');
        var woID = component.get('v.recordId') ;
        action.setParams({
            "woId" : woID            
        });
        action.setCallback(this, function(a) 
                           {
                               var state = a.getState();
                               console.log('action status:::'+state);
                               if (state === "SUCCESS")
                               {
                                   if(a.getReturnValue() == true)
                                       component.set("v.isAssetLocked",true);
                                   else
                                       component.set("v.isAssetLocked",false);
                               }
                           });
        $A.enqueueAction(action);                    
    },
    getmakeModelsHelper : function(component, event, helper) {
        var action = component.get('c.getMakeModels');
        var woID = component.get('v.recordId') ;
        helper.checkForLockAsset(component, event, helper);
        action.setParams({
            "woId" : woID            
        });
        var maker;
        var model;
        action.setCallback(this, function(a) 
                           {
                               var state = a.getState();
                               console.log('action status:::'+state);
                               if (state === "SUCCESS")
                               {
                                   console.log(a.getReturnValue());
                                   var picklistvalues =[];
                                   picklistvalues.push(a.getReturnValue());
                                   //if(a.getReturnValue())
                                   //component.set("v.symtpomCatsMap",a.getReturnValue()); //picklistvalues);// a.getReturnValue());
                                   //console.log(component.get("v.picklistValues"));
                                   var makeModelsMap = a.getReturnValue();
                                   var makesArr=[];
                                   var makereList=[];
                                   console.log('work order id after response::'+woID);
                                   for( var key in makeModelsMap)
                                   {
                                       //console.log('key:'+key)
                                       if(key == woID)
                                       {
                                           var makeModels=[];
                                           makeModels = makeModelsMap[key];
                                           //console.log(makeModels);
                                           if(makeModels[0] != null && makeModels[0] != '')
                                               maker=makeModels[0];//component.set("v.selectedMake",makeModels[0]);
                                           else
                                               maker = 'Choose one..';
                                           if(makeModels[1] != null && makeModels[1] != '')
                                               model=makeModels[1];//component.set("v.selectedModel",makeModels[1]);
                                           
                                       }
                                       else
                                       {
                                           makesArr.push({maker:key, models:makeModelsMap[key]});
                                           makereList.push(key);
                                       }
                                       //console.log('map value::'+symptomCatgyMap[key]);
                                       //console.log('key value::'+key);
                                   }
                                   component.set("v.makeModelsMap", makesArr);
                                   component.set("v.makesList", makereList);
                                   /*if(component.get("v.selectedMake") != null && component.get("v.selectedMake") != '' && 
                                      component.get("v.selectedMake") != undefined)
                                   {
                                       console.log('in if');                                       
                                       component.set("v.selectedMake",maker);
                                   }
                                   if(component.get("v.selectedModel") != null && component.get("v.selectedModel") != '' && 
                                      component.get("v.selectedModel") != undefined)               
                                   {                                      
                                       console.log('in if');                                       
                                       component.set("v.selectedModel",model);
                                   }*/
                                       
                                   
                                   console.log('selected maker::'+component.get("v.selectedMake"));
                                   console.log('selected model::'+component.get("v.selectedModel"));
                                   //console.log('after setting to attributes:::sym cats::'+component.get("v.symptomCatList"));
                                   //console.log('after setting to attributes:::sym::'+component.get("v.symtpomCats"));
                               } 
                           }); 
        $A.enqueueAction(action);
    },
    fetchTypePicklist : function(component){
        var action = component.get("c.getPicklistvalues");
        
        var woID = component.get('v.recordId') ;
        console.log("State CHeck");
        
        action.setParams({
            'objectName': component.get("v.ObjectName"),
            'field_apiname': component.get("v.Application"),
            'nullRequired': true // includes --None--
            
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS"){
                if(a.getReturnValue()){
                    component.set("v.appPicklist", a.getReturnValue());
                    if(component.find("makeAppCodeList")){
                     	//component.find("makeAppCodeList").set("v.value", '--None--');   
                    }
                }
            } 
        });
        $A.enqueueAction(action);
    },
    getAppCodeHelper : function(component, event, workOrder) {
        component.set("v.showSpinner",true);
        
        var action = component.get('c.validateApplicationCode');
        var woID = component.get('v.recordId') ;
        var wo = workOrder;
        
        //var appCode = component.find("makeAppCodeList").get("v.value");
        var appCode = component.get("v.selectedApplicationCode");
        console.log("::: Helper appcode "+appCode);
        action.setParams({
            "woId" : woID ,  
            "appCode" : appCode
        });
        var applicationCode;
        action.setCallback(this, function(a) 
                           {
                               var state = a.getState();
                               console.log('action status:::'+state);
                               if (state === "SUCCESS")
                               {
                                   var checkAppCode = a.getReturnValue();
                                   
                                   var asst = component.get("v.assetId"); 
                                   if(checkAppCode == false){
                                       if((asst != '' || appCode != '') || (asst != undefined || appCode != undefined)){
                                           component.set("v.Workorder.Application__c", appCode);
                                           component.set("v.appErrorMsg",$A.get("$Label.c.FSL_MarketingApplicationErrMsg"));     
                                           
                                       }
                                   }
                                   else{
                                       var updateAppCode = component.set("v.selectedApplicationCode",appCode);
                                       component.set("v.Workorder.Application__c", updateAppCode);
                                       // component.set("v.appPicklist",updateAppCode);
                                       component.set('v.appErrorMsg', null);
                                       var toastEvent = $A.get("e.force:showToast");
                                       var isappCodeChange = component.get("v.appCodeChange");
                                       console.log('::: isappCodeChange = '+isappCodeChange);
                                       if(isappCodeChange == true) {
                                           toastEvent.setParams({
                                               message: 'Application updated succesfully',
                                               type: 'success',
                                           });
                                       }
                                      
                                       component.set("v.appCodeChange", false);
                                       toastEvent.fire();
                                   }
                                   
                                   console.log('selected Application::'+component.get("v.appPicklist"));
                                   
                               } 
                               component.set("v.showSpinner",false);
                               
                           }); 
        $A.enqueueAction(action);
    },
    // Added by Priyanka on 11/10/2021 | VGRS-76
     FetchSelectedAppDescription: function(component,event,helper){
         component.set("v.appCodeChange", true);
        component.set("v.MMFlag", true)
        console.log('::: AppCodeChange = '+component.get("v.appCodeChange"));
         var selectedApplication =component.get("v.selectedApplicationCode");
         //alert(selectedApplication);
        //alert('======'+JSON.stringify(component.get("v.ApplicationMetadataMap")));
        var   ApplicationMetaMap  = component.get("v.ApplicationMetadataMap");
        
        for(var key in ApplicationMetaMap){
            //alert(key);
           if(ApplicationMetaMap.hasOwnProperty(key)){
            if(key==selectedApplication){
            	//alert('====key===='+key);
            	component.set("v.AppDescription",component.get("v.ApplicationMetadataMap")[key]);
                //alert('value======'+component.get("v.ApplicationMetadataMap")[key]);
            }
           }
        }
        component.set("v.AppDescription",component.get("v.ApplicationMetadataMap")[selectedApplication]);
    
	}
    
})