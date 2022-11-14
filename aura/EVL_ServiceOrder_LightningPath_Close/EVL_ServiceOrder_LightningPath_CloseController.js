({
	loadChevron :function(component, event, helper) {
        if(component.get("v.currentStage") == 'Triage & Diagnosis' || 
           component.get("v.currentStage") == 'Repair' || 
           component.get("v.currentStage") == 'Job Plan'){
            helper.handleTAndDRepairJobPlanClose(component, event, helper);
            helper.getRepairRespPickListValues(component, event, helper);
            helper.getLoggedinUserInfo(component, event, helper);
        }
    },
    
    handleCancelModal : function(component, event, helper) {
        component.find("overlayLibClose").notifyClose();
    },
    
    handleScheduleClose : function(component, event, helper) {
        var resolution = component.find("resolution").get("v.value");
       console.log('resolutionmsg'+resolution);
        if (resolution === '' || resolution === null || resolution === undefined){
            helper.showToast('Error','Error',$A.get("$Label.c.EVL_ResolutionErrMsg"));
            return;
        }
        component.find("recordScheduleForm").submit();
        helper.handleClose(component, event, helper);
    },
    
    handleSolutionClose : function(component, event, helper) {
        var isClose = false;
        var retJSON = component.get("v.cssSolns");
        console.log('Test'+retJSON);
        var resolutionmsg = component.find("resolutionmsg").get("v.value");
        var repairresponses= component.get("v.SelectedRepair");
        //VGRS2-348 By Priyanka 3/4/2022 
        if(!repairresponses)
        {
            repairresponses = component.find("RepairResponseId").get("v.value");
        }
        console.log('repairresponae'+repairresponses);
       console.log('resolutionmsg'+resolutionmsg);
        for(var i=0;i<retJSON.length;i++){
           // alert(retJSON[i].Id+":"+retJSON[i].repairResponse)
           if(retJSON[i].repairResponse==='Repair Successful.' || retJSON[i].repairResponse=== 'Repair Successful with additional parts/procedures.'){
               component.set("v.resolutionSection",false); 
              helper.handleClose(component, event, helper);
                return;
            }
         }
         for(var i=0;i<retJSON.length;i++){
          //  alert(retJSON[i].Id+":"+retJSON[i].repairResponse)
            if(retJSON[i].repairResponse==='' || retJSON[i].repairResponse=== null || retJSON[i].repairResponse=== undefined){
                helper.showToast('Error','Error','Please select repair response for all the solutions');
                isClose = true;
                return;
            }
        }
       if (repairresponses === '' || repairresponses === null || repairresponses === undefined){
            helper.showToast('Error','Error',$A.get("$Label.c.EVL_RepairErrMsg"));
            isClose = true;
           return;
        }
       else if(resolutionmsg === '' || resolutionmsg === null || resolutionmsg === undefined){
            helper.showToast('Error','Error',$A.get("$Label.c.EVL_ResolutionErrMsg"));
            isClose = true;
            return;
        } 
       /* for(var i=0;i<retJSON.length;i++){
            alert(retJSON[i].Id+":"+retJSON[i].repairResponse)
            if(retJSON[i].repairResponse==='' || retJSON[i].repairResponse=== null){
                helper.showToast('Error','Error','Please select repair response for all the solutions');
                isClose = true;
                break;
            }
        } */
        if(!isClose){
             helper.handleClose(component, event, helper);
        }
      
    },
    
    handleRepairClose:function(component, event, helper) {   
        var retJSON = component.get("v.cssSolns");
    	var repairresponses= component.get("v.SelectedRepair");
        console.log('repairresponae'+repairresponses);
         for(var i=0;i<retJSON.length;i++){
           // alert(retJSON[i].Id+":"+retJSON[i].repairResponse)
           if(retJSON[i].repairResponse==='Repair Successful.' || retJSON[i].repairResponse=== 'Repair Successful with additional parts/procedures.'){
               component.set("v.resolutionSection",false);
              helper.handleClose(component, event, helper);
                return;
            }
         }
        for(var i=0;i<retJSON.length;i++){
          if(retJSON[i].repairResponse==='' || retJSON[i].repairResponse=== null || retJSON[i].repairResponse=== undefined){
                helper.showToast('Error','Error','Please select repair response for all the solutions');
                isClose = true;
                return;
            }
        }
        if (repairresponses === '' || repairresponses === null || repairresponses === undefined){
            helper.showToast('Error','Error',$A.get("$Label.c.EVL_RepairErrMsg"));
            return;
        }
        else{
             helper.handleClose(component, event, helper);
        }
    },
 
   /* closeJob:function(component, event, helper) {
        helper.handleClose(component, event, helper);
    },  */
    
    handleRepairValueChange:function(component, event, helper) {
        //Getting css solution Id 
        var selectedItem = event.getSource().get("v.class");
        console.log('1'+selectedItem);
        //Getting selected pick list value from repair response
        //var selectedValue = component.find("RepairResponseId").get("v.value");
        var selectedValue = event.getSource().get("v.value");
        console.log('2'+selectedValue);
        //event.getSource().get("v.value");
        console.log('hi'+selectedValue);
        var retJSON = component.get("v.cssSolns");
        component.set("v.SelectedRepair",selectedValue);
        if(selectedValue === '' ||selectedValue === null){
         helper.showToast('Error','Error',$A.get("$Label.c.EVL_RepairErrMsg"));   
            
        }
        if(selectedValue == 'Repair performed but didnot resolve the root cause.' || selectedValue == 'Repair not performed.'){
          component.set("v.resolutionSection",true);  
        } else{
            component.set("v.resolutionSection",false);
        }
       
        //Iterating over through all the solutions and if matches id , 
        //assigning selected repair response to the key value
        for(var i=0;i<retJSON.length;i++){
            if(retJSON[i].Id === selectedItem ){
                retJSON[i].repairResponse = selectedValue;
                break; 
            }
        }
    }
})