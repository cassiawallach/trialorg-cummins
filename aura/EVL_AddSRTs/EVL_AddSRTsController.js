({
	handleClick : function(component, event, helper) {
		//alert('Type-->'+component.get('v.Type'));
		 component.set("v.isModalOpen",true);
	},
    
    doInit : function(cmp, event, helper) {   		
        var action = cmp.get("c.recordStatus");
        var RecordID = cmp.get("v.recordId");

        var btnLabel = cmp.get("v.ButtonName");
        
        console.log('RecId**'+RecordID);
        if (RecordID){
            action.setParams({"recId": RecordID,
                    "btnLabel" : btnLabel});
   
        }
        action.setCallback(this, function(response){            
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.showButtons',response.getReturnValue());
                console.log('ResponseBtn:::'+response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

        //set button label
        var buttonCustomLabel;
        
        console.log('btnLabel:'+ btnLabel );
        if(btnLabel == 'Add Diagnostic SRTs') {
            buttonCustomLabel = $A.get("$Label.c.EVL_Add_Diagnostic_SRTs");
        }
        if(btnLabel == 'Add Repair SRTs') {
            buttonCustomLabel = $A.get("$Label.c.EVL_Add_Repair_SRTs");
        }
        if(btnLabel == 'Add Field Action SRTs') {
            buttonCustomLabel = $A.get("$Label.c.EVL_Add_Field_Action_SRTs");
        }
        console.log('buttonCustomLabel:' + buttonCustomLabel );

        cmp.set('v.ButtonName', buttonCustomLabel);
        console.log('buttonCustomLabel:' + buttonCustomLabel );

        //Added by Adam for NIN-37/46 to refresh the SRT tab
        //$A.get('e.force:refreshView').fire();

    }
})