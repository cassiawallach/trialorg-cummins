({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        console.log('moste likely popup');
        //component.set("v.isModalOpen", true);
        helper.getRepairRespList(component, event, helper);
        helper.getSolnDetailsHelper(component, event, helper);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
       // $A.get('e.force:refreshView').fire(); 
    },
    saveResoln:function (component, event, helper)
    {
     /*var getAllId = component.find("selectCB");
        console.log('getAllId>'+getAllId);
        // If the local ID is unique[in single record case], find() returns the component. not array
        console.log(Array.isArray(getAllId));
        if(Array.isArray(getAllId))
        {
            for (var i = 0; i < getAllId.length; i++)
            {
                console.log('current qty>'+component.find("qty")[i].get("v.value"));
                if (getAllId[i].get("v.value") == true)
                {
                    if(component.find("qty")[i].get("v.value") == null || component.find("qty")[i].get("v.value") == 0)                    
                        component.find("qty")[i].set("v.value", 1);
                    console.log('inside if when is true');
                }
                else if(component.find("qty")[i].get("v.value") != null && component.find("qty")[i].get("v.value") > 0)
                    component.find("qty")[i].set("v.value", 0);
                
            }
        }*/
        var resolns = component.find("resolutions");
        if(Array.isArray(resolns))
        {
            for(var i=0; i<resolns.length; i++)
            {
                console.log(resolns[i].get("v.value"));
                if(resolns[i].get("v.value") != 'Choose one')
                {
                    	
                }
            }
        }
    },
    submitDetails: function(component, event, helper) {
        // Set isModalOpen attribute to false
        //Add your code to call apex method or do some processing
        var cssVar=component.get("v.cssSolns");
        for( var key in cssVar)
        {
            console.log(cssVar[key]);
            //var makeModels=[];
            //makeModels = cssVar[key];
        }
        var action  = component.get("c.closeJobFromTndnJPforMostLikly");
        action.setParams({
            strWorkOrderId : component.get("v.recordId"),
            stageName : component.get("v.processStatus"),
            cssSolns : component.get("v.cssSolns")
        });
        action.setCallback(this,function(response){

            console.log(response.getReturnValue());
            if (response.getState() === 'SUCCESS') { 
                if(response.getReturnValue()==true)
                    component.set("v.showRepairPopup",true);
                else
               // $A.get('e.force:refreshView').fire();
               location.reload();
            }
        });
        $A.enqueueAction(action);
        component.set("v.isModalOpen", false);
    },
    countChangedValues : function(component, event, helper) {
        //var abc=component.find("resolutions").get("v.value");
        //var picklistval = component.find("mygroup").get("v.value");
        //console.log(abc);
        var picklistval = event.getParam("value");
        console.log('picklistval>>'+picklistval);
    }
})