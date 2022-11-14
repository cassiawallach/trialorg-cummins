({
    doInit : function(component, event, helper)
    {
        var action = component.get('c.getSymptomsCategories');
        /*action.setParams({
            "keyWord" : component.get('v.sSymptomCategory') 
        });*/
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
                                   component.set("v.symtpomCatsMap",a.getReturnValue()); //picklistvalues);// a.getReturnValue());
                                   console.log(component.get("v.picklistValues"));
                                   var symptomCatgyMap = a.getReturnValue();
                                   var symptomCatArr=[];
                                   var symptomCatLst=[];
                                   for( var key in symptomCatgyMap)
                                   {
                                       symptomCatArr.push({sympCat:key, symptom:symptomCatgyMap[key]});
                                       symptomCatLst.push(key);
                                       //console.log('map value::'+symptomCatgyMap[key]);
                                       //console.log('key value::'+key);
                                   }
                                   component.set("v.symptomCatList", symptomCatArr);
                                   component.set("v.symtpomCats", symptomCatLst);
                                   //console.log('after setting to attributes:::sym cats::'+component.get("v.symptomCatList"));
                                   //console.log('after setting to attributes:::sym::'+component.get("v.symtpomCats"));
                               } 
                           });
      helper.showHidesearchstring(component, event, helper);
      //  helper.getRecordType(component,event,helper);
        $A.enqueueAction(action);
        // Added by shirisha 07/21/2022 ROAD-470 
        var actionFlag = component.get('c.fetchFTRFlag');
        var woId = component.get("v.recordId");
        console.log('#### recordId :: '+woId);
        actionFlag.setParams({
            woId : woId
        });
        actionFlag.setCallback(this,function(response){
            //console.log('#### response ::'+response); 
            if(response.getState()==="SUCCESS"){
                if(response.getReturnValue() == true){
                    component.set("v.showSearch", false);
                }
            }
        });
        $A.enqueueAction(actionFlag);
        // end
    },
    //Added By Mallika
    populateTable : function(component, event, helper){
    //    helper.showSpinner(component, event, helper); //commented by Piyush for VGRS2-321
        helper.populateTableHelper(component, event, helper);
        helper.trackSearchFaultCode(component, event, helper);
    },
    //Ended Here
    
    loadSymptoms: function(component, event, helper) 
    {
        //console.log('searchSymptom:::'+component.get("v.searchSymptom"));
        var symptomCatgyMap = component.get("v.symptomCatList");
        for( var key in symptomCatgyMap)
        {
            //console.log('key:::'+symptomCatgyMap[key].sympCat);
            if(symptomCatgyMap[key].sympCat == component.get("v.searchSymptom"))
            {
                //console.log('inside for loop sym values::'+symptomCatgyMap[key].symptom);
                var symparr=symptomCatgyMap[key].symptom;                
                component.set("v.picklistValues",symptomCatgyMap[key].symptom);
                //console.log(component.get("v.picklistValues"));
                break;
            }
            //symptomCatArr.push({sympCat:key, symptom:symptomCatgyMap[key]});            
        }
    },
    /*getSymptosJS : function(component, event, helper) 
    {
        var action = component.get('c.getSymptos');
        action.setParams({
            "keyWord" : component.get('v.sSymptomCategory') 
        });
        action.setCallback(this, function(a) 
                           {
                               var state = a.getState();
                               //alert(state);
                               if (state === "SUCCESS")
                               {
                                   console.log(a.getReturnValue());
                                   var picklistvalues =[];
                                   picklistvalues.push(a.getReturnValue());
                                   //if(a.getReturnValue())
                                   component.set("v.picklistValues",a.getReturnValue()); //picklistvalues);// a.getReturnValue());
                                   console.log(component.get("v.picklistValues"));
                               } 
                           });
        $A.enqueueAction(action);
    },*/
    searchCodes : function(component, event, helper) {
        component.set('v.columns', [
            {label: 'FaultTypeFC', fieldName:'FaultTypeFC__c',type: 'text', sortable : true} ,
            {label: 'PCode', fieldName:'FaultTypePcode__c',type: 'text', sortable : true} ,
            {label: 'SPNFMI', fieldName:'FaultTypeSPNFMI__c',type: 'text', sortable : true} 
        ]);
        component.set('v.Pcodecolumns', [
            {label: 'FaultTypeFC', fieldName:'FaultTypeFC__c',type: 'text', sortable : true} ,
            {label: 'PCode', fieldName:'FaultTypePcode__c',type: 'text', sortable : true} ,
            {label: 'SPNFMI', fieldName:'FaultTypeSPNFMI__c',type: 'text', sortable : true},
        ]);
        component.set("v.SPNFMIcodecolumns", [
            {label: 'FSL SPN FMI', fieldName:'Name',type: 'text', sortable : true}   
        ]);
        if(component.get("v.searchString")!=null && component.get("v.searchString")!=''){
         //   helper.searchfalutecodes(component, event, helper); 
        }
        if(component.get("v.PcodesearchString")!=null && component.get("v.PcodesearchString")!=''){   
          //  helper.searchPcodes(component, event, helper); 
        }
        if(component.get("v.SPNFMIsearchString")!=null && component.get("v.SPNFMIsearchString")!=''){ 
          //  helper.SPNFMIsearchPcodes(component, event, helper);
        }
        // Added Ravi to search Pcode or Fault code or FSL SPN FMI
        if((component.get("v.PcodesearchString")!=null && component.get("v.PcodesearchString")!='' ) ||(component.get("v.SPNFMIsearchString")!=null && component.get("v.SPNFMIsearchString")!='')  ||(component.get("v.searchString")!=null && component.get("v.searchString") !='')){   
          helper.searchfalutecodes(component, event, helper);
        }
    },
    getSolutions :function(component, event, helper)
    {
        var faultID = event.target.getAttribute("data-id");
        console.log('Falutid  ==  '+faultID);
        var woId = component.get("v.recordId");
        
        helper.changeRECORDtype(component, event, helper);
    },
    //Added Ravikanth to hide component
    //Line 125 to 145 commented for April release
    handleRecordUpdated: function(component, event, helper) {
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        var eventParams = event.getParams();
        
        console.log('eventParams.changeType------>SFController'+eventParams.changeType);
        console.log('component.get("v.record").Clock_In_User_Ids_Formula__c ------>SFController'+component.get("v.record").Clock_In_User_Ids_Formula__c);
        console.log('userId----->SFController'+userId);
        console.log('component.get("v.record.User__r.Id")'+component.get("v.record.User__r.Id"));
        console.log('component.get("v.record").isCICOVisible__c'+component.get("v.record").isCICOVisible__c);
        //Modified by Krishna for TW-52 as part of CICO toggle Switch
        if(eventParams.changeType === "CHANGED"  ) {
            if((component.get("v.record").Clock_In_User_Ids_Formula__c !=null && component.get("v.record").Clock_In_User_Ids_Formula__c !='') || component.get("v.record").isCICOVisible__c == false) {
               component.set("v.hidecomponent",true);
               
            }
            if((component.get("v.record.User__r.Id")== null || component.get("v.record.User__r.Id") == ''|| component.get("v.record.User__r.Id") == userId) || component.get("v.record").isCICOVisible__c == false ){
                 component.set("v.usrcontrol",true);   
            } 
             if((component.get("v.record").Clock_In_User_Ids_Formula__c ==null || component.get("v.record").Clock_In_User_Ids_Formula__c =='') &&  component.get("v.record").isCICOVisible__c == true) {
                     component.set("v.hidecomponent",false);
             }
          
            
        }
        if(eventParams.changeType === "LOADED"){
                    if((component.get("v.record").Clock_In_User_Ids_Formula__c ==null || component.get("v.record").Clock_In_User_Ids_Formula__c =='') &&  component.get("v.record").isCICOVisible__c == true) {
                     component.set("v.hidecomponent",false);
        }
            else if(component.get("v.record.User__r.Id")!= null && component.get("v.record.User__r.Id") != '' && component.get("v.record.User__r.Id") != userId ){
                component.set("v.hidecomponent",false);
            }
                else {
                     component.set("v.hidecomponent",true);
                     component.set("v.usrcontrol",true);   
                    
                    
                }
           
            
        }
    }  
})