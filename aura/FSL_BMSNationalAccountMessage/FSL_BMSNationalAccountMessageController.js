({
    doInit : function(component, event, helper) {
        var woId = component.get("v.recordId");
        var action = component.get("c.getWorkOrderData");
        debugger;
        action.setParams({
            'workOrderId': woId
        });

        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                let data = response.getReturnValue();
                console.log('check for the detail @@ '+JSON.stringify(data));
                let sObjectList = data.sObjectList;
                component.set("v.workOrderDetail", sObjectList.length > 0 ? sObjectList[0] : {});                
            } else {
                console.log('::: Error in getWorkOrderData');
            }
        });
        $A.enqueueAction(action);
    },
})