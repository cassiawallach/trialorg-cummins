({
    checkForAssetData: function(component, event, helper)
    {
        var action2 = component.get("c.checkforSMNDTC");
        action2.setParams({
            "woId" : component.get("v.recordId")
        });


        action2.setCallback(this, function(a)
                            {
                                var state = a.getState();
                                console.log('action status:::'+state);
                                if (state === "SUCCESS")
                                {
                                    console.log(a.getReturnValue());
                                    if (a.getReturnValue() == true ) {
                                        //helper.getassetdata(component,event);
                                        component.set("v.showMessage",true);
                                    }
                                    else
                                        component.set("v.showMessage",false);
                                }
                            }
                           );
        $A.enqueueAction(action2);
              //  $A.get("e.force:refreshView").fire();

    }
})