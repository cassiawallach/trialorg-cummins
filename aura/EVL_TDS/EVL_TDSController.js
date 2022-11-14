({
    onTabClick : function(component, event, helper) {
        component.find("setOfTabs").set("v.selectedTabId", "solution");
        //component.set("v.errMsg", "true");
      

    },
    //karthik G Added as part of Ct1-182
    tabSelected : function(component, event, helper) {
        console.log('TestMethodTab:::');
     // alert('karthik selected>>>>'+component.get("v.SelectTabId"));
     var Tabname = component.get("v.SelectTabId");
        console.log('TestMethodTab:::'+Tabname);
        
        if(Tabname == 'trouble'){
            //alert('karthik selected> >>>'+Tabname);
           // $A.get('e.force:refreshView').fire();
           location.reload();
            console.log('T&DTab::');
        }
        //Added by Sriprada fro VGRS2-6 : 10/19/2021
        else if(Tabname == 'solution'){
            console.log('ElseTestMethodTab:::'+Tabname);
            
            var action1 = component.get('c.fetchFCData');
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
                        component.set('v.DiagnosticErrMsg', false);
                        component.set('v.errSolMsg', true);

                        component.set('v.faultID', true);

                    } else{
                        component.set('v.errSolMsg', false);
                        component.set('v.DiagnosticErrMsg', true);

                        component.set('v.faultID', true);


                    }
                }
            });
            $A.enqueueAction(action1); 
        } //Code Ends here
    },
    handleComponentEvent : function(component, event, helper) {
        //alert('karthikinsidetest');
        console.log('insidehandlecomp');
        component.find("setOfTabs").set("v.selectedTabId", "solution");
        var message = event.getParam("faultCode");
        console.log('message  ==  '+message);
        // set the handler attributes based on event data
        component.set("v.faultCodes", message);
        if(message){    //Added by sruthi VGRS2-365 4/1/22
            component.set("v.faultID", true);
        }
        
        var disSol = component.find("displaySolutions");
        disSol.displaySol(message);
        //var numEventsHandled = parseInt(cmp.get("v.numEvents")) + 1;
        //cmp.set("v.numEvents", numEventsHandled);
    },
    doInit : function(component, event, helper, Fid) {
        
        //alert('karthikinisdedoint');
        helper.fetchUserDetails(component, event, helper); // By Priyanka for VGRS2-15
        var id = helper.GetWebOrderId("TabId"); 
        if(id != '' ) 
            component.set("v.SelectTabId",id);
        console.log('id>>>'+id);
        console.log('kkkk>>>'+window.location.href);
        var URl =  helper.removeParam("TabId",window.location.href);
        console.log('id>>>'+URl);
        window.history.pushState({}, '', URl);
        
        var Fid = helper.GetWebOrderId("solId"); 
        console.log('Fid'+Fid);
         
       /* var action = component.get('c.handleInPlaceOfDoInIt');
        $A.enqueueAction(action);*/
        
        //alert('karthik1');
      
       var cmpEvent = component.getEvent("cmpEvent1");
        console.log('Fid  ==  '+cmpEvent);
        cmpEvent.setParams({
            "faultCode" : Fid });
        cmpEvent.fire();
        
        // Sruthi - Logic to pull the Work Order details
        // Enqueue action to call the apex controller
        var action = component.get("c.fetchWORecord");
        action.setParams({ recordId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var resp = response.getReturnValue();
             /*   if(resp.Status != "Closed" && resp.Asset.Make__c == null && resp.Model == null && resp.Equipment_Id == null){
                    console.log('Test:::'+resp);
                    component.set("v.isClosed", true);
                }*/
                if(resp.Status == "Closed"){
                    component.set("v.isClosed", true);
                }
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        // Added by Sriprada for VGRS2-6 to check fault code insertion on WO : 10/20/2021    
    var action1 = component.get('c.fetchFCData');
        console.log('IntoInit:::s');
            action1.setParams({
                "recordId" : component.get("v.recordId")            
            });
            action1.setCallback(this, function(response){
                var state = response.getState();
                console.log('State::'+state);
                if(state === "SUCCESS") {
                    var appErrMsg = response.getReturnValue();
                    console.log('InitappErrMsg'+appErrMsg);

                    if(appErrMsg == true){
                        component.set('v.DiagnosticErrMsg', false);
                        component.set('v.errSolMsg', false);

                        component.set('v.faultID', true);

                    } else{
                       
                        component.set('v.faultID', false);


                    }
                }
            });
            $A.enqueueAction(action1); //Code end here -- Sriprada
        	$A.enqueueAction(action);

    }
})