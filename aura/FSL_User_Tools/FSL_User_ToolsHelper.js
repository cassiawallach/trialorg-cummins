({
	
    //start: updated by Trupthi, NIN-47 Date:2/23/2022  
    
    getSessionPSN : function(component, event, helper) {
    	
        var soSessionPSN = component.get("c.getSessionPSN");
        soSessionPSN.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS') {
                component.set('v.psnValuetop', response.getReturnValue());
                var psnValue = component.get('v.psnValuetop');
                if(psnValue != null && psnValue != ''){
                	var childCmp = component.find("CWComp");
                	childCmp.sampleMethod(true);
                }
            }
        });
        $A.enqueueAction(soSessionPSN);
    },
    
    psnChangeSession : function(component, event, helper) {
        // var val1 =  component.get("val");
        //var seledRad = component.get("v.SelectedRadioval");
        //console.log('seledRad>>>'+seledRad);
        //if(seledRad == 'Checkwarrycoverage' || seledRad == undefined){
        var psnVal = component.get('v.psnValuetop');
        alert('PSN'+psnVal);
        component.set('v.radioValue', 'Checkwarrycoverage');
            var childCmp = component.find("CWComp");
	        childCmp.sampleMethod(true);
        //}
    }
      //updated by Trupthi, NIN-47 Date:2/23/2022 -END
})