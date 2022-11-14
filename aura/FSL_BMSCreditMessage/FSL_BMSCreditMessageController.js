({
	doInit : function(component, event, helper) {
		var woId = component.get("v.recordId");
        console.log(':::WorOrder Id = '+woId);
        var action = component.get("c.getPayerDetails");
        action.setParams({
            'workOrderId': woId
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log(state);
            if (state === "SUCCESS")
            {
                var data = response.getReturnValue();
                console.log('::: Payer data = '+JSON.stringify(data));
                component.set("v.payerData", data);
                console.log('::: Payment Type - '+data.paymentType);
                if(data.paymentType === 'Charge') {
                    component.set("v.showTable", true);
                }
                
            }else {
                console.log('::: Error in fetch Payer Detail');
            }
        });
        $A.enqueueAction(action);
	},
})