({
    doInit : function(component, event, helper) {
        var artId = component.get("v.WorkrecId");
        console.log('karthiknewId.Id >>>>>>>>>>>-> ' + artId);
        component.set("v.WorkrecIdnew",artId);
        var action = component.get("c.getUsers");
        action.setParams({ 
            "wordorderId": artId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('kartikstate',state);
            if (state === "SUCCESS") {
                var listItems = response.getReturnValue();
                var options = [];
                
                listItems.forEach(function(element) {
                    var uname =  element.UserId__r.FirstName + ' ' + element.UserId__r.LastName;
                    options.push({ value: element.UserId__r.Id, label: uname });
                });
                console.log('listItems',listItems);
                console.log('listItems',options);
                component.set("v.userList", options);
                
            }
        });
        
        $A.enqueueAction(action);
        
        
        /*   var action = component.get("c.getIndustry");
        console.log('kartikaction'+action)
        var inputIndustry = component.find("InputAccountIndustry");
        var opts=[];
        action.setCallback(this, function(a) {
            opts.push({
                class: "optionClass",
                label: "--- None ---",
                value: ""
            });
            
            for(var i=0;i< a.getReturnValue().length;i++){
                
                opts.push({"class": "optionClass", label: a.getReturnValue()[i], value: a.getReturnValue()[i]});
            }
            console.log('Karthik List',opts);
            inputIndustry.set("v.options", opts);
             
        });
        $A.enqueueAction(action); 
             
        action.setCallback(this, function(e) {
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue(); 
                component.set("v.lstIndustry",result);
                console.log('kkkk',result);
            }
        });*/
        
    },    
    pickTech: function(component, event, helper) {
        var selectedTechValue = event.getParam("value");
        var selectedTechValueLabel = event.getParam("label"); 
        //alert(event.getSource().get("v.value"));
        
        console.log('kkkselectedTechValue.Id >>>>>>>>>>>>>>-> ' + selectedTechValueLabel);
        console.log('kkkselectedTechValue.Id -> ' + selectedTechValue);
        component.set("v.newId",selectedTechValue);
        
    },
    
    saveTech:function(component, event, helper) {
        // alert('karthik');
        var newId = component.get("v.newId");
        var artId = component.get("v.WorkrecIdnew");
        console.log('karthiknewId.Id >>>>>artId>>>>>>-> ' + artId);
        
        console.log('karthiknewId.Id -> ' + newId);
        console.log('karthiknewId.Id -> ' + artId);
        var action = component.get("c.save");
        if(!newId){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title: 'Error',
                type: 'error',
                message: $A.get("$Label.c.EVL_Tech_Error_Msg")
            });
            toastEvent.fire();
            return;
        }
        if(newId){
             console.log('newId -> ' + newId);
            action.setParams({ 
                "Tech": newId,
                "Workordernumber" : artId
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                console.log('karthiknewId.Id -> ' + state);
                if (state === "SUCCESS") {
                    
                    var response = response.getReturnValue();
                    console.log('response -> ' + response);
                    if(response != 'Success')
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            title: 'Error',
                            type: 'error',
                            message: response
                        });
                        toastEvent.fire();
                    }
                    else{
                        component.find("navService").navigate({
                            type: 'standard__recordPage',
                            attributes: {
                                recordId : artId, 
                                actionName: 'view',  //Valid values include clone, edit, and view.
                                objectApiName: 'WorkOrder' //The API name of the record’s object
                            }}, true)
                       
                    }
                    //$A.get("e.force:closeQuickAction").fire();
                    //$A.get('e.force:refreshView').fire();
                    // window.sfdcPage.relatedLists;
                    //window.sfdcPage.makeRLAjaxRequest(null,window.sfdcPage.relatedLists[10].listId);
                    
                    
                    // window.open("{!'https://gevldlrdev-cumminscss.cs90.force.com/evolution/s/workorder/' + v.artId + '/detail?tabset-281b7=8c3ed'}");
                    // alert("success");
                    
                    /*  var navService = component.find("navService");
                           var pageReference = {    
                              "type": "standard__recordPage",
                              "attributes": {
                                   recordId : artId,
                                              "url": "https://gevldlrdev-cumminscss.cs90.force.com/evolution/s/workorder/' + v.recordId + '/detail" + "?tabset-281b7=4f860"
                               }
                             }
        event.preventDefault();
        navService.navigate(pageReference);*/
                }
                else if (state === "ERROR")
                {
                     //alert("Failed");
                }
            });
             $A.enqueueAction(action);
        }
    },
    //added by sai for CT1-61
    qualifiedTechnicians: function(component,event,helper){
        var artId = component.get("v.WorkrecId");
        var check = component.get("v.qualifiedcheckbox");
        console.log('Qualified checkbox' +check);
        component.set("v.newId", "");  
        if(check){
            var action = component.get("c.certUserLIst");
            action.setParams({ 
                "Workordernumber" : artId
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log('state'+state);
                if (state === "SUCCESS") {
                    var listItems = response.getReturnValue();
                    var options = [];
                    
                    listItems.forEach(function(element) {
                        options.push({ value: element.UserId, label: element.UserName});
                    });
                    console.log('listItems',listItems);
                    console.log('listItems',options);
                    component.set("v.userList", options);                
                }
            });        
            $A.enqueueAction(action);
        }
        else{
            var action1 = component.get("c.getUsers");
            action1.setParams({ 
                "wordorderId": artId
            });
            action1.setCallback(this, function(response){
                var state = response.getState();
                console.log('state',state);
                if (state === "SUCCESS") {
                    var listItems = response.getReturnValue();
                    var options = [];
                    
                    listItems.forEach(function(element) {
                        var uname =  element.UserId__r.FirstName + ' ' + element.UserId__r.LastName;
                        options.push({ value: element.UserId__r.Id, label: uname });
                    });
                    console.log('listItems',listItems);
                    console.log('listItems',options);
                    component.set("v.userList", options);                    
                }
            });        
            $A.enqueueAction(action1); 
        }        
    }
})