//ModalController.js
({   
    
    applycss:function(cmp,event){
    //initialize        
    
       
        
    },
    
    handleApplicationEvent:function(component,event,helper){
       //alert("initiated handler changed");
       var role= event.getParam("SelectedRoleValue");
       var recordId=event.getParam("record");
       var modularity = component.get("v.selectedModularity").toString();
        //alert('Printing values for role'+role);
        //alert('Printing values for recordId'+recordId);
        var action = component.get('c.getContacts');
		action.setParams({
			 //recordId:component.get("v.recordId"),
			recordId:recordId,
            role:role,
            moudularity:modularity
		 }); 
		// Set up the callback
		var self = this;
       console.log('aaaaaa'+role+'bbbbbbbbb'+recordId);
		action.setCallback(this, function(actionResult) {
        //	debugger;
            var contactMap={};
            var mapkeys=[];
            contactMap=actionResult.getReturnValue();
            console.log('STATUS==='+actionResult.getState());
            for(var keys in contactMap){
                console.log('KEYS=='+keys);
                mapkeys.push(keys);
            }
            console.log('STATUS==='+mapkeys);
            var availablelist=[];
            var selectedlist=[];
            //alert('Printing array includes available in dual list'+mapkeys.includes('available'));
            //alert('Printing array includes selected in dual list'+mapkeys.includes('selected'));
            //alert('Printing error is present or not dual list'+(!mapkeys.includes('error')));
            if(actionResult.getState()=="SUCCESS"){
            if(!mapkeys.includes('error')){    
              if(mapkeys.includes('available')){
                for(var i=0;i<actionResult.getReturnValue()['available'].length;i++){
                  
                    availablelist.push({value:actionResult.getReturnValue()['available'][i].Username__c,label:actionResult.getReturnValue()['available'][i].Name});
                }
               	   
              }
              
              if(mapkeys.includes('selected')){
                  //alert('inside if selected');
                for(var i=0;i<actionResult.getReturnValue()['selected'].length;i++){
                    //alert('Inside for  loop');
                 //selectedlist.push({value:actionResult.getReturnValue()['selected'][i].Name,label:actionResult.getReturnValue()['selected'][i].Name});
                	selectedlist.push(actionResult.getReturnValue()['selected'][i].Username__c);
                   availablelist.push({value:actionResult.getReturnValue()['selected'][i].Username__c,label:actionResult.getReturnValue()['selected'][i].Name});

                }
                  //alert('selected list'+selectedlist);
               var appEvent = $A.get("e.c:IAM_DualListValueChange");
                appEvent.setParams({
                "SelectedContacts" :selectedlist
                });
            appEvent.fire();
               
              }
               component.set("v.options", availablelist); 
                component.set("v.values", selectedlist); 
                component.set("v.intialSelectedValues",selectedlist);
                }
            }
            
		}); 
        $A.enqueueAction(action);
       
        
    },
    removeComponent:function(component, event, helper){
        //get event and set the parameter of Aura:component type, as defined in the event above.
        var compEvent = component.getEvent("RemoveComponent");
        compEvent.setParams({
            "comp" : component
        });
    compEvent.fire();
    },
    
    
    
    
    handleChange: function (cmp, event) {
        //debugger;
        // This will contain an array of the "value" attribute of the selected options
        var selectedOptionValue = event.getParam("value");

        var initialselectvalue = cmp.get('v.intialSelectedValues');

        console.log('initial selected list length :' +initialselectvalue.length);
        
        var changedSelectedList = selectedOptionValue.filter(function(obj) { return initialselectvalue.indexOf(obj) == -1; });
        console.log('change in selected list values ::::' +changedSelectedList);//new code
        var changedSelectedListLength = changedSelectedList.length;
        console.log('change in selected list length ::::' +changedSelectedListLength);//new code
        
		var changedAvailableList = (initialselectvalue.length + changedSelectedList.length) -selectedOptionValue.length;//new code
        console.log('change in available list length:'+changedAvailableList);
        
        var changedTotalList = changedAvailableList + changedSelectedListLength;
        //var IsMaxContacts = "False";
        console.log('change in both Available and Selected list length :'+changedTotalList);
        //alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
         var appEvent = $A.get("e.c:IAM_DualListValueChange");
			appEvent.setParams({
            "SelectedContacts" :selectedOptionValue,
            "IsMaxContacts" :changedTotalList
            });
        appEvent.fire();
    }
})