({
	onTabClick : function(component, event, helper) {
        component.find("setOfTabs").set("v.selectedTabId", "solution");
    },
    handleComponentEvent : function(component, event, helper) {
        
        console.log('insidehandlecomp');
        component.find("setOfTabs").set("v.selectedTabId", "solution");
         var message = event.getParam("faultCode");
		console.log('message  ==  '+message);
        // set the handler attributes based on event data
        component.set("v.faultCodes", message);
        
        var disSol = component.find("displaySolutions");
        disSol.displaySol(message);
        //var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        //cmp.set("v.numEvents", numEventsHandled);
    },
    tabSelected : function(component, event, helper) {
    
     var Tabname = component.get("v.SelectTabId");
        if(Tabname == 'trouble'){
            $A.get('e.force:refreshView').fire();
        } 
        //Added by Sriprada for VGRS2-6: 10/19/2021
        else if(Tabname == 'solution'){
            console.log('ElseTestMethodTab:::'+Tabname);
            
            var action1 = component.get('c.fetchSolData');
            action1.setParams({
                "recordId" : component.get("v.recordId")            
            });
            action1.setCallback(this, function(response){
                var state = response.getState();
                console.log('State::'+state);
                if(state === "SUCCESS") {
                    var appErrMsg = response.getReturnValue();
                    console.log('appErrMsg'+appErrMsg);

                    if(appErrMsg == true){
                        component.set('v.errSolMsg', true);
                        component.set('v.RepairErrMsg', false);

                        component.set('v.faultID', true);


                    } else{
                        component.set('v.errSolMsg', false);
                        component.set('v.RepairErrMsg', true);

                        component.set('v.faultID', true);


                    }
                }
            });
            $A.enqueueAction(action1);  //Code Ends here - Sriprada
            }
    },
       handleApplicationEvent :	 function(component, event, helper) {
        
        alert('applicationevent');
       console.log('insidehandlecomp>>>>>>22');
    },
    
   
    doInit : function(cmp, event, helper) {   		
        var action = cmp.get("c.recordStatus");
        action.setParams({"recId": cmp.get("v.recordId")});
        action.setCallback(this, function(response){            
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set('v.showTabContent',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
        
       var id = helper.GetWebOrderId(); 
        if(id != '' ) {
         cmp.set("v.SelectTabId",id);
        console.log('id>>>'+id);
        console.log('id>>>'+window.location.href);
       var URl =  helper.removeParam("TabId",window.location.href);
           console.log('id>>>'+URl);
            window.history.pushState({}, '', URl);
            
               
       /* var cmpEvent = component.getEvent("cmpEvent");
        console.log('Faultid  ==  '+cmpEvent);
        cmpEvent.setParams({
            "faultCode" : faultID });
        cmpEvent.fire();
         */
        }
        // Added by shirisha 08/25/2022 ROAD-556
        var actionFlag = cmp.get('c.fetchFTRFlag');
        var woId = cmp.get("v.recordId");
        console.log('#### recordId :: '+woId);
        actionFlag.setParams({
            woId : woId
        });
        actionFlag.setCallback(this,function(response){
            //console.log('#### response ::'+response); 
            if(response.getState()==="SUCCESS"){
                if(response.getReturnValue() == true){
                    cmp.set("v.showTable", false);
                }
            }
        });
        $A.enqueueAction(actionFlag);
        // end
     
}
})