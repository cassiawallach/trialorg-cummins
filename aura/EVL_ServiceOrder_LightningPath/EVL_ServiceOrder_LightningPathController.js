({
    //doInit : function(component, event, helper) {},  
     loadChevron : function(component, event, helper) {
         helper.loadChevron(component, event, helper);
         helper.getStage(component, event, helper);
         helper.getRepair(component, event, helper);
         helper.getLoggedinUserInfo(component, event, helper);     
     },
     navigateToRecord :function(component, event, helper){
         var chevronClick = event.target.getAttribute('data-index');
         var currentStage = component.get("v.processStep");
         var rep = component.get("v.RepairClose");
         var prof = component.get("v.logguserprof");
         var exa = event.target.getAttribute('index');
         var toastmsg = $A.get("$Label.c.EVL_Service_Order_Closed");
         if(component.get("v.profileStageList").includes(chevronClick))
         {
             /*Below validations is for if user click on Close*/
             if(chevronClick =='Close' || chevronClick =='Closed'){
                 if(currentStage != 'Closed' && rep == true && prof == 'EVL_Dealer_Advanced' ){
                 		helper.handleClose(component,event,helper);
                 }
                 if (currentStage != 'Closed' && rep == false){
                      helper.handleCloseChevron(component,event,helper,currentStage);
                    }
                 if(currentStage == 'Closed'){
                     helper.showToast('Error','Error',toastmsg);
                 }
             }
             
         }
     },
     
     // Added by Ravikanth
     handleSuccess: function(component, event, helper) {
         var succ = $A.get("$Label.c.EVL_Sub_Status_Success_Msg");
         helper.insertstagingvalues(component, event, helper); // Added by Ravikanth
         var stageClick =  component.get("v.chevronClick");
         if(component.get("v.profileStageList").includes(stageClick)){
             helper.updateStageAndRecordType(component,event,helper);
         }
     },
    
    OnSave: function(component, event, helper) {
        var succ = $A.get("$Label.c.EVL_Sub_Status_Success_Msg");
        helper.showToast('Success','Success',succ);
    },
    
     ShowStatus : function(component, event, helper) 
     {
         var toggleText = component.find("substatus");
         $A.util.toggleClass(toggleText, "substatus");
     },
 
     handleOnLoad : function(component, event, helper) {}, 
 
     changePathEvent :function(component, event, helper)
     {
         component.set("v.chevronClick",event.getParam("statusValue"));
         var a = component.get('c.handleSuccess');
         $A.enqueueAction(a);
     },
     
    recordUpdated : function(component, event, helper) {    

    var changeType = event.getParams().changeType;
	//alert(changeType);
    if (changeType === "ERROR") { /* handle error; do this first! */ }
    else if (changeType === "LOADED") { /* handle record load */ }
    else if (changeType === "REMOVED") { /* handle record removal */ }
    else if (changeType === "CHANGED") { 
      /* handle record change; reloadRecord will cause you to lose your current record, including any changes you’ve made */ 
      //component.find("recordLoader").reloadRecord(true);
      }
    }
 })