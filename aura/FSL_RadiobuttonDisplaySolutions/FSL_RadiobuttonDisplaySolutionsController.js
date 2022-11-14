({
     doInit: function(component, event, helper) {
         // Initialize input select options
         var solRadioOptionHeader = $A.get("$Label.c.FSL_SolutionRadioHeader");
         var solutionRepairRadioHeader = $A.get("$Label.c.FSL_RepairRadioHeader");
         component.set("v.solutionRadioHeader", solRadioOptionHeader);
         component.set("v.solutionRepairRadioHeader", solutionRepairRadioHeader);
         
         var radioSolutionsOptions =[{label: $A.get("$Label.c.FSL_SolutionRadioOption1") ? $A.get("$Label.c.FSL_SolutionRadioOption1") : 'Not the solution. Continue troubleshooting.',
                                      value: 'Not the solution. Continue troubleshooting.'},
                                     {label: $A.get("$Label.c.FSL_SolutionRadioOption2") ? $A.get("$Label.c.FSL_SolutionRadioOption2") : 'Most likely the solution. Repair recommended.',
                                      value: 'Most likely the solution. Repair recommended.'},
                                     {label: $A.get("$Label.c.FSL_SolutionRadioOption3") ? $A.get("$Label.c.FSL_SolutionRadioOption3"): 'Could not perform the solution verification.',
                                      value: 'Could not perform the solution verification'}];
          component.set("v.options", radioSolutionsOptions);
          console.log('radioSolutionsOptions' + component.get("v.options"));

         var radioRepairOptions = [{label: $A.get("$Label.c.FSL_RepairRadioOption1") ? $A.get("$Label.c.FSL_RepairRadioOption1") : 'Repair Successful.',
                                    value: 'Repair Successful.'},
                                   {label: $A.get("$Label.c.FSL_RepairRadioOption2") ? $A.get("$Label.c.FSL_RepairRadioOption2") : 'Repair Successful with additional parts/procedures.',
                                    value: 'Repair Successful with additional parts/procedures.'},
                                   {label: $A.get("$Label.c.FSL_RepairRadioOption3") ? $A.get("$Label.c.FSL_RepairRadioOption3"): 'Repair performed but didnot resolve the root cause.',
                                    value: 'Repair performed but didnot resolve the root cause.'},
                                   {label: $A.get("$Label.c.FSL_RepairRadioOption4") ? $A.get("$Label.c.FSL_RepairRadioOption4"): 'Repair not performed.', 
                                    value: 'Repair not performed.'}];
         component.set("v.repairOptions", radioRepairOptions);
     },
  childComponentEvent : function(component, event,helper) { 
        var picklistval = component.find("mygroup").get("v.value");
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        console.log('selected indx on child comp>>'+component.get("v.selectedIdx"));
        //Set event attribute value
        cmpEvent.setParams({"pickvalues" : picklistval,
                            "selectedIdx" : component.get("v.selectedIdx")}); 
        cmpEvent.fire(); 
    },
    handleChange : function(component, event,helper) { 
      //  var picklistval = component.get("v.radioGroupRequired");
       var picklistval = event.getParam("value");
       // alert(picklistval);
        component.set("v.repairValue",picklistval);
        //Get the event using registerEvent name. 
      //  var cmpEvent = component.getEvent("sampleCmpEvent"); 
      //  console.log('selected indx on child comp>>'+component.get("v.selectedIdx"));
        //Set event attribute value
      //  cmpEvent.setParams({"pickvalues" : picklistval,
                     //       "selectedIdx" : component.get("v.selectedIdx")}); 
      //  cmpEvent.fire(); 
    },
    repairChange:function(component, event,helper){
        var picklistval = component.find("repairGroup").get("v.value");
        //Get the event using registerEvent name. 
        var cmpEvent = component.getEvent("sampleCmpEvent"); 
        console.log('selected indx on child comp>>'+component.get("v.selectedIdx"));
        //Set event attribute value
        cmpEvent.setParams({"repairPickListValue" : picklistval,
                            "selectedIdx" : component.get("v.selectedIdx")}); 
        cmpEvent.fire(); 
},
//236 Changes by Murali 2/15/22
	resetRadioButton : function(cmp, event) {
        cmp.set("v.value",undefined );
	}
})