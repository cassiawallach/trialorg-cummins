({
	handleMessage : function(component, event, helper) {
        if (event != null && event.getParams() != null) {
            let params = event.getParams();
            console.log('params > ' + JSON.stringify(params));
            component.set("v.recordValue", JSON.stringify(params, null, "\t"));
            component.set("v.strikeValue", JSON.stringify(params, null, "\t")); 
            //component.set("v.strikeValue", params); 
            console.log('RAFAEL AGUILAR GUARDO > ' + JSON.stringify(component.get("v.strikeValue")));
            //console.log('emir kusturica > ' + component.find("evtfirebtn").click());
			console.log('ortiz >>>>>' + document.querySelector("#evtfirebutton"));
             document.querySelector("#evtfirebutton").click();
        }		
	},
    
    fireComponentEvent : function(cmp, event, helper) {
        try{
            var compEvents = cmp.getEvent("componentEventFired");// getting the Instance of event
            console.log('MIGUEL ANGEL FELIX > ' + JSON.stringify(cmp.get("v.strikeValue")));
            //console.log('ALEXANDER SESELIJ  > ' + cmp.get("v.strikeValue"));
            compEvents.setParams({ "message" : cmp.get("v.strikeValue") });// setting the attribute of event
            compEvents.fire();// firing the event.            
        }catch(err) {
            console.log('TRAVNIK ' + err);
            
        } 	

    }    
    
})