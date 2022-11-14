({
    /*
    doInit : function(component, event, helper) {
       
        component.set("v.showSpinner", false);
    },  */  
    AddNewRow : function(component, event, helper){
        // fire the AddNewRowEvt Lightning Event 
        component.getEvent("AddRowEvt").fire();     
    },
    
    removeRow : function(component, event, helper){
        // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
        var remRows = component.get("v.listSize")-1;
        component.set("v.remRows",remRows);
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },
    handleChange : function(component, event, helper) {
         component.set("v.partNot", false); //added by priyanka for VGRS2-204
        var reason =  component.get("v.repRsnLOVs");
        component.find("a_opt").set("v.value", reason[0]);
        component.set("v.showSpinner", true);
        var partNo = event.getSource().get("v.value");
        partNo = partNo.trim(); // Added by Sruthi VGRS2-32 10/20/2021
        if(partNo){ // Added by sruthi VGRS2-32 10/20/2021
            var action = component.get("c.getPartName");
            action.setParams({
                "partNo" : partNo
            });
            action.setCallback(this, function(response){
                var state = response.getState(); 
                //alert(state);
                console.log(state);
                if (state === "SUCCESS") {
                    console.log(response.getReturnValue());
                    var data = response.getReturnValue();
                    //alert(data);
                    if(data != '') {
                        //alert('not null');
                        component.set("v.cssPartInst.Name", data);
                        component.set("v.partNot", false);
                    } else {
                        //alert('null');
                        component.set("v.cssPartInst.Name", '');
                        component.set("v.partNot", true);
                    }
                    component.set("v.showSpinner", false);
                    //alert(response.getReturnValue());
                } else {
                    component.set("v.cssPartInst.Name", '');
                    component.set("v.partNot", true);
                    component.set("v.showSpinner", false);
                }
                console.log('in gets parts on wo');
            });
            
            // Added By Sriprada to check Profile Name for Part# validation - Dealers
            var action2 = component.get("c.getProfileInfo");
            action2.setCallback(this, function(response) {
                var state = response.getState();
                if(state == "SUCCESS" && component.isValid()) {
                    console.log("success") ;
                    var result = response.getReturnValue();
                    console.log(result);
                    console.log(result);
                    component.set("v.ProfileName", result);
                    
                    var woType = component.get("v.woType");  //added by sruthi as part of VGRS2-147 12/7/21
                    
                    if(woType == 'Dealer' && (result == 'true'|| result == 'FU')) {
                        component.set("v.DealerProfile", true);
                        component.set("v.FactoryUser", true);
                    } else if(result == 'false'){
                        component.set("v.DealerProfile", false);
                        component.set("v.FactoryUser", false);
                        
                    }
                } else {
                    console.error("fail:" + response.getError()[0].message); 
                }
            });
            $A.enqueueAction(action2);
            $A.enqueueAction(action);
        } //added by sruthi VGRS2-32 starts here
        else{
            component.set("v.showSpinner", false);
        } //ends here
        
    },
})