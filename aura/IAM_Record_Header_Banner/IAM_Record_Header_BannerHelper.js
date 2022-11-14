({
	// Fetch the accounts from the Apex controller
	getsObjName: function(component) {
	  var action = component.get('c.getName');
	  action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	   component.set('v.ObjectName', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);
	},
	   // Fetch the set password boolean Apex controller
	getsetpassword: function(component) {
	  var action = component.get('c.resetButton');
	  action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  // Set up the 
	  // 
	  // callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	   component.set('v.setPswrd', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);
	},
	  //fetch unlock button boolean
	  getUnlock: function(component) {
	  var action = component.get('c.unlockButton');
	  action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
		  
	   component.set('v.Unlock', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);
	},
  
	  //fetch the profile of current loggedin User
	  getProfile: function(component) {
	  var action = component.get('c.getProfile');
	  /*action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  */
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
		  
	   component.set('v.Profile', actionResult.getReturnValue());
	   var profile = actionResult.getReturnValue();
	   var getElementIndex = profile.indexOf('IAM_Cummins_Care');
	   console.log('==value of getelementIndex==='+getElementIndex);
	   if(getElementIndex != -1){
		  component.set('v.condition',true);
	   }else{
		  component.set('v.condition',false); 
	   }
		  
	  });
	  $A.enqueueAction(action);
	},
	  
	  getsObjList:function(component){
	  var action = component.get('c.getsObjectInfo');
	  action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	   component.set('v.sObjInfo', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);
	  
  },
	  
	   //Send to PC function
	 getSendToPCInfo : function(component,event){
		 debugger;
	 var displayMessage;
	 var action1 = component.get('c.SendPCInfo');
		
		 var bname=event.getSource().get("v.value");
	 action1.setParams({ recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")}); 
	  //Set up the callback
	  var self = this;
	  action1.setCallback(this, function(actionResult) { 
	  var state = actionResult.getState();
		  if(state=="SUCCESS"){
	
		  if(actionResult.getReturnValue()=="Ok"){ 
			 
			  if(bname=="Send to PC"){
				  displayMessage="Company Information is successfully send to PC.";
				  component.set('v.successMessage',displayMessage);
				  
				  $A.get('e.force:refreshView').fire();
				  $A.get('e.c:IAM_PageReload').fire();
				  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
				  
				  
			  }else if(bname=="Activate"){
				  var action2 = component.get('c.accUpdate');
				  action2.setParams({ 
				  recordid:component.get("v.recordId"),
				  buName:event.getSource().get("v.value"),
				  rejectReason:component.get("v.rejectionReason"),
				  rejectcomments:component.get("v.comments")
				  });
				  var self = this;
				  action2.setCallback(this, function(actionResult) {
				  var state = actionResult.getState();
						  if(actionResult.getReturnValue()=="Ok"){
							  displayMessage="Customer Activation successfull."
							  component.set('v.successMessage',displayMessage);
							  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
							  $A.get('e.force:refreshView').fire();
							  $A.get('e.c:IAM_PageReload').fire();
							  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
							  
			   
						  }else{
							  component.set('v.errorMessage', actionResult.getReturnValue());
							  component.set("v.displayErrorModal",true);
							  $A.get('e.c:IAM_ShowErrorMessages').fire();
							  //$A.get('e.c:IAM_ShowError_Toast').fire();
							  //$A.get('e.force:refreshView').fire();
							  //$A.get('e.c:IAM_PageReload').fire();
							  
						  }
					  });
				  $A.enqueueAction(action2);
				  }else if(bname=="De-Activate"){
				  var action3 = component.get('c.accUpdate');
				  action3.setParams({ 
				  recordid:component.get("v.recordId"),
				  buName:event.getSource().get("v.value"),
				  rejectReason:component.get("v.rejectionReason"),
				  rejectcomments:component.get("v.comments")
				  });
				  var self = this;
				  action3.setCallback(this, function(actionResult) {
				  var state = actionResult.getState();
						  if(actionResult.getReturnValue()=="Ok"){
							  displayMessage="Customer De-Activation successfull."
							  component.set('v.successMessage',displayMessage);
							  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
							  $A.get('e.force:refreshView').fire();
							  $A.get('e.c:IAM_PageReload').fire();
							  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
							  
							  
						  }else{
							  component.set('v.errorMessage', actionResult.getReturnValue());
							  component.set("v.displayErrorModal",true);
							  $A.get('e.c:IAM_ShowErrorMessages').fire();
							  //$A.get('e.c:IAM_ShowError_Toast').fire();
							  //$A.get('e.force:refreshView').fire();
							  //$A.get('e.c:IAM_PageReload').fire();
							  
						  }
					  });
				  $A.enqueueAction(action3);
				}
		  }else{
			  
		  component.set('v.errorMessage', actionResult.getReturnValue());
			  component.set("v.displayErrorModal",true);
			  
		  //$A.get('e.c:IAM_ShowError_Toast').fire();
		  //$A.get('e.force:refreshView').fire();
		  //$A.get('e.c:IAM_PageReload').fire();
			  $A.get('e.c:IAM_ShowErrorMessages').fire();
		  
		  }
		  
	  }else{
			  component.set('v.errorMessage', actionResult.getReturnValue());
		  component.set("v.displayErrorModal",true);	
		  $A.get('e.c:IAM_ShowErrorMessages').fire();
			  //$A.get('e.c:IAM_ShowError_Toast').fire();
			  //$A.get('e.force:refreshView').fire();
			  //$A.get('e.c:IAM_PageReload').fire();
						
			 }
	  });
	  $A.get('e.force:refreshView').fire(); 
	  $A.enqueueAction(action1);
  },
   

		 
	  //Code for Generate CDA
	  getCDAToPC : function(component,event){
	 var displayMessage;
	 var action1 = component.get('c.generateCDA');
		 
		 var bname=event.getSource().get("v.value");
	 action1.setParams({ recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")}); 
	  //Set up the callback
	  var self = this;
	  action1.setCallback(this, function(actionResult) {
		  
		  if(actionResult.getState()=="SUCCESS"){
			  
			  if(actionResult.getReturnValue()=="CDA"){
				  var action2=component.get('c.accUpdate');
				  
				  action2.setParams({recordid:component.get("v.recordId"),
				  buName:event.getSource().get("v.value"),
				  rejectReason:component.get("v.rejectionReason"),
				  rejectcomments:component.get("v.comments")
				  })
				  //Setting callback
				  var self= this;
				  action2.setCallback(this,function(actionResult){
				  if(actionResult.getState()=="SUCCESS"){
					  if(actionResult.getReturnValue()=="Ok"){
						  component.set('v.successMessage',"Service Agreement generation was successfull");
						  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
						  //
						  $A.get('e.force:refreshView').fire();
						  $A.get('e.c:IAM_PageReload').fire();
						  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
						  
					  }else{
						  component.set('v.errorMessage', actionResult.getReturnValue());
						  component.set("v.displayErrorModal",true);
						  $A.get('e.c:IAM_ShowErrorMessages').fire();
							  //$A.get('e.c:IAM_ShowError_Toast').fire();
							  //$A.get('e.force:refreshView').fire();
							  //$A.get('e.c:IAM_PageReload').fire();
							  
					  }
				  }                    
				  });
				  $A.get('e.force:refreshView').fire(); 
				  $A.enqueueAction(action2);
			  }else{
				  component.set('v.errorMessage', actionResult.getReturnValue());
				  component.set("v.displayErrorModal",true);
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
				  //$A.get('e.c:IAM_ShowError_Toast').fire();
				  //$A.get('e.force:refreshView').fire();
				  //$A.get('e.c:IAM_PageReload').fire();
				  
			  }
		  }
	  });
	  $A.get('e.force:refreshView').fire(); 
	  $A.enqueueAction(action1);
  },
	
	  getUserInfo:function(component,event){
	  
		  
		  var action1 = component.get('c.generateUser');
	  action1.setParams({ recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")});
	  // Set up the callback
	  var self = this;
	  action1.setCallback(this, function(actionResult) {
		  if(actionResult.getState()=="SUCCESS"){
			  if(actionResult.getReturnValue=="User succesfully generated"){
				  var action2=component.get('c.accUpdate');
				  action2.setParams({ recordid:component.get("v.recordId"),
				  buName:event.getSource().get("v.value"),
				  rejectReason:component.get("v.rejectionReason"),
				  rejectcomments:component.get("v.comments")
				  });
				  //setting up callback
				  var self=this;
				  action2.setCallback(this, function(actionResult) {
				  if(actionResult.getState()=="SUCCESS"){
						  if(actionResult.getReturnValue()=="Ok"){
							  component.set('v.successMessage',"User succesfully generated");
							  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
							  $A.get('e.force:refreshView').fire();
							  $A.get('e.c:IAM_PageReload').fire();
							  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
							  
						  }else{
							  component.set('v.errorMessage', actionResult.getReturnValue());
							  component.set("v.displayErrorModal",true);
							  $A.get('e.c:IAM_ShowErrorMessages').fire();
							  //$A.get('e.c:IAM_ShowError_Toast').fire();
							  //$A.get('e.force:refreshView').fire();
							  //$A.get('e.c:IAM_PageReload').fire();
							  
						  }
					  }
				  });
				  $A.enqueueAction(action2);
				  
			  }else{
				  component.set('v.errorMessage', actionResult.getReturnValue());
				  component.set("v.displayErrorModal",true);
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
							  //$A.get('e.c:IAM_ShowError_Toast').fire();
							  //$A.get('e.force:refreshView').fire();
							  //$A.get('e.c:IAM_PageReload').fire();
				  
			  }
		  }
	   
	  });
	  $A.enqueueAction(action1);   
  },
	  
	  //Below Script is to make a contact active and to create User.
	  getContInfo: function(component,event) {
	  var action1 = component.get('c.ActivateContact');
		  var bName=event.getSource().get("v.value");
		  console.log("Printing button name"+bName);
		  
	  action1.setParams({
		  recordid:component.get("v.recordId"),
		  buName:event.getSource().get("v.value"),
		  rejectReason:component.get("v.rejectionReason")
		  });
		
	  // Set up the callback
	  var self = this;
	  action1.setCallback(this, function(actionResult){
		  var state=actionResult.getState();
		 console.log("State for action activate"+ state);
		  console.log("Printing action1 result return "+actionResult.getReturnValue());
		  if(actionResult.getState()=="SUCCESS"){
			console.log("Printing action1 result return "+actionResult.getReturnValue());
			  if(actionResult.getReturnValue()=="Success"){
				  
				  var action2=component.get('c.accUpdate');
				  action2.setParams({ recordid:component.get("v.recordId"),
				  buName:event.getSource().get("v.value"),
				  rejectReason:component.get("v.rejectionReason"),
				  rejectcomments:component.get("v.comments")
				  });
				  //setting up call back
				  var self= this;
				  action2.setCallback(this, function(actionResult){
				  if(actionResult.getState()=="SUCCESS"){
					  
					  if(actionResult.getReturnValue()=="Ok"){ 
						  if(bName=="Activate"){
							  component.set('v.successMessage','User Created Successfully');
							  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
							  $A.get('e.force:refreshView').fire();
							  $A.get('e.c:IAM_PageReload').fire();
							  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
							  
						  }
						  if(bName=="De-Activate"){
							  
							  var action3=component.get('c.appDelete');
							  action3.setParams({ 
							  recordid:component.get("v.recordId"),
							  buName:event.getSource().get("v.value"),
							  rejectReason:component.get("v.rejectionReason")
							  });
							  //settting up call back
							  var self= this;
							  action3.setCallback(this,function(actionResult){
								  if(actionResult.getState()=="SUCCESS"){
									  
									  if(actionResult.getReturnValue()=="Ok"){
										  component.set('v.successMessage','User Deactivated Successfully');
										  //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
										  $A.get('e.force:refreshView').fire();
										  $A.get('e.c:IAM_PageReload').fire();
										  var actionSuccess=component.get('c.showSuccessToast');
										  $A.enqueueAction(actionSuccess);
										  
									  }else{
										  
										  $A.get('e.c:IAM_ShowErrorMessages').fire();
										  component.set('v.errorContact', actionResult.getReturnValue());       
										  component.set('v.errorContactFlag',"true")
										  
										  //$A.get('e.c:IAM_ShowError_Toast').fire();
										  //$A.get('e.force:refreshView').fire();
										  //$A.get('e.c:IAM_PageReload').fire();
									  }
								  }
							  });
							  $A.enqueueAction(action3);
						  }
					  }else{
						  
						  var displayMessage;
						  if(actionResult.getReturnValue()!=null){
							 displayMessage=actionResult.getReturnValue();
						  }else{
							  displayMessage='Something went wrong. Please contact System Administrator.'
						  }
						  component.set('v.errorContact', displayMessage);       
						  component.set('v.errorContactFlag',"true");
						  $A.get('e.c:IAM_ShowErrorMessages').fire();
						  //$A.get('e.c:IAM_ShowError_Toast').fire();
						  //$A.get('e.force:refreshView').fire();
						  //$A.get('e.c:IAM_PageReload').fire();
						  
					  }
				  }
				});
				  $A.enqueueAction(action2);
			  }else{
				  
				  component.set('v.errorContact', actionResult.getReturnValue());       
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
				  //$A.get('e.c:IAM_ShowError_Toast').fire();
				  //$A.get('e.force:refreshView').fire();
				  //$A.get('e.c:IAM_PageReload').fire();
				  
			  }
		  }else{
		  component.set('v.errorContact', actionResult.getReturnValue());       
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
		  }
	  });
	  $A.enqueueAction(action1);
	  },
	   hideModal : function(component,event, helper){
	  
		 document.getElementById("DeActive").style.display = "none" ;
	 },
	  
	  //Action to call the controller class when both the free and subscription app are present
	  
	  /*appSubSave:function(component,event,helper){
		if(component.get("v.selectedValue")!="None"){
			  
			  //Need to call controller class to save the record.
			  //var sub=component.get("v.selectedValue");
			  //var app=component.get("v.selectedAppSub")
			  //var role=component.get("v.selectedRole")
			  
			var app={
				Subscription:component.get("v.selectedValue"),
				Application:component.get("v.selectedAppSub"),
				Role:component.get("v.selectedRole")
			};
		   var action=component.get('c.saveApplication')
		  action.setParams({
		  recordid:component.get("v.recordId"), 
		  appInfo:app   
		  });
		   var self = this;
		  action.setCallback(this, function(actionResult) {
			  
			  if(actionResult.getState()=="SUCCESS"){
				  if(actionResult.getReturnValue()=="Record Created"){
					 //Display Success toast
					 var action3=component.get("c.hideApp");
					  $A.enqueueAction(action3);
					  component.set('v.successMessage',"Application Assaigned Successfully");
					  //$A.get('e.c:IAM_ShowSuccess_Toast').fire(); 
					  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
					  $A.get('e.force:refreshView').fire();
					  $A.get('e.c:IAM_PageReload').fire();
					  
				  }else{
					  //Display Error Toast
					  component.set('v.errorContact', actionResult.getReturnValue());
					  component.set('v.errorContactFlag',"true");
					  $A.get('e.c:showErrorMessages').fire();
					  //$A.get('e.force:refreshView').fire();
				  }
				  
			  }else{
				  //code to set if call doesnot happen properly
				  component.set('v.errorContact', 'Something Went wrong please contact System Administrator.');
					  component.set('v.errorContactFlag',"true");
					  $A.get('e.c:showErrorMessages').fire();
				  
			  }
		  });
		  $A.enqueueAction(action);
		  }  
		  
	  },*/
	  
	  //Method to call apex controller for Subscribed applications
		 SaveSubscribedApp: function(component,event,helper){
		/***  Sumit ***/
		   
				 var appMappings=new Map();
		 if(component.get("v.ShowSaveButton")>0)
		  {
		   var appEvent = $A.get("e.c:IAM_Application_Table_Event2");
			   appEvent.setParams({
				   "isRefreshAndNotSave": "false"});
			   appEvent.fire();
		  
		   console.log(component.get("v.recordId")+'   '+component.get("v.selectedValue")+'    '+component.get("v.SelectedIDMApplication"));
			  var serId= [] ;
			  serId.push(component.get("v.ServiceId"));
			
			  var mapToSend = {}
			  for (var key of (component.get("v.appMaps").keys())) {
			  mapToSend[key] = component.get("v.appMaps").get(key);
			  }
			  mapToSend['IAM_Promotion__c'] = serId;
			  //Console.log('Printing map'+mapToSend);
		  var action = component.get("c.ProcessSubscriptionAppRec");
		  action.setParams({ Conid : component.get("v.recordId"),
							 SelectedSubscription : component.get("v.selectedValue"),
							 SelectedApps : component.get("v.SelectedIDMApplication"),
							applicationMap:mapToSend,
							assignedCount : component.get("v.assignedCountPaid")});
								  
		  action.setCallback(this, function(response) {
			  var state = response.getState();
			  console.log(response.getReturnValue());
			  if (state === "SUCCESS") {
				console.log(response.getReturnValue());
				  if(response.getReturnValue()=='Record Created'){
					  $A.get('e.force:refreshView').fire();
					   $A.get('e.c:IAM_PageReload').fire();
					  component.set('v.successMessage',"Application Assigned Successfully");
					  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);
				  }else{
					 component.set('v.showAppAssaign',"false");
					  
				  console.log('===check return value==='+response.getReturnValue());
				  var mainstring = response.getReturnValue();
				  var finalmessage;
				  var value = mainstring.indexOf('If you are trying to edit existing application access');
					  if(value != -1){
						   var showmessage = response.getReturnValue().split(':');
						  console.log('===value of record is ===='+showmessage[2]);
						  component.set('v.conPorRecordId',showmessage[2]);
						  
						  //fix - Defect - D-2854 - display different error for site admin
						  console.log('===value of v.IsFromVF is ====  '+ component.get('v.IsFromVF'));
						  if(component.get('v.IsFromVF') == 'true'){
							  finalmessage = $A.get("$Label.c.IAM_duplicate_Application_error");
						  }else{
							  finalmessage = $A.get("$Label.c.IAM_duplicate_app_error_ba");  
							  component.set('v.showEditLink',"true");
						  }	
					  }
					  else{
						  finalmessage = response.getReturnValue();
					  }
				  component.set('v.errorContact',finalmessage);
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
				   console.log("Incomplete"); 
				  }
			  }
			  else if (state === "INCOMPLETE") {
				   component.set('v.showAppAssaign',"false");
				  component.set('v.errorContact','Please Contact System Administrator to provide access for paid Application.' );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
			   console.log("Incomplete");
			  }
			  else if (state === "ERROR") {
				  var errors = response.getError();
				  if (errors) {
					  if (errors[0] && errors[0].message) {
						  console.log("Error message: " + 
								   errors[0].message);
					  }
					   component.set('v.showAppAssaign',"false");
				  component.set('v.errorContact',errors[0].message );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
				  } else {
					   component.set('v.showAppAssaign',"false");
				  component.set('v.errorContact','Please Contact System Administrator to provide access for paid Application.' );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
					  console.log("Unknown error");
				  }
			  }
		  });

		
		  $A.enqueueAction(action);
	  
		   
		  component.set("v.SelectedIDMApplication",[]);   
		  
		  var appEvent2 = $A.get("e.c:IAM_Application_Table_Event2");
		  appEvent2.setParams({
				   "isRefreshAndNotSave": "true"});
		  appEvent2.fire();
		  /************/
	   }
	  },
	  
	  //Method to call apex controller class for free application
	  appFreeSave:function(component,event,helper){
		  
		  var action2;
		  
		  if(component.get("v.selectedAppFree")!="None"){
			  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
				  
				  var DA={Application :component.get("v.selectedAppFree"), 
						  Role:component.get("v.PCRole"),
						  custList:component.get("v.CustList"),
						  session:component.get("v.session"),
						  usertype:component.get("v.usertype")
						 }
				  
				  action2=component.get('c.saveFreeApp')
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:DA,
					  appName:component.get("v.selectedAppFree")
				  });
			  }
			  //if check the application name for RLS
			  
			  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_RLS")){
				  
				  var RLS={Application:component.get("v.selectedAppFree"),
						   Role:component.get("v.rlsRole"),
						   rlsNumber:component.get("v.rlsNumber"),
						   rlsEmail:component.get("v.rlsEmail")
						  }
				  action2=component.get('c.saveFreeApp')
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:RLS,
					  appName:component.get("v.selectedAppFree")
				  }); 
			  }
			  
			  //if Statement to check for Cumpas 2.0 application
			  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Cumpas")){
				  console.log('====component.get("v.recordId")==='+component.get("v.recordId"));
				  console.log('Printing selected application'+component.get("v.selectedAppFree"));
				  console.log('Printing Cumpas Modularity'+component.get("v.selectedModular"));
				  console.log('Printging slected applicaiton level'+component.get("v.selectedcumRole"));
				  var CUMPAS={Application:component.get("v.selectedAppFree"),
						   UserGroup:component.get("v.selectedcumRole"),
						   
							 }
				  action2=component.get('c.saveFreeAppCumpas')
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:CUMPAS,
					  modularity:component.get("v.selectedModular"),
					  appName:component.get("v.selectedAppFree"),
					  rolesNames:component.get("v.selectedRoleCm")
				  }); 
			  }
			  //end of Cumpas check
			  
			  // Amar Added code for the WWSPS 04-16-2019
			  // UAT Issue# 134
			  
			  if(component.get("v.selectedAppFree") == $A.get("$Label.c.IAM_AppName_WWSPS")){
					  
				  action2=component.get('c.saveFreeApp')
				  var WWSPS={Application:component.get("v.selectedAppFree"),
						  Role:$A.get("$Label.c.IAM_Role_WWSPS"),
						  }
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:WWSPS,
					  appName:component.get("v.selectedAppFree"),
				  }); 
					  
				  console.log('====Inside if condition WWSPS 01=====');
				  console.log('====component.get("v.selectedAppFree")======'+component.get("v.selectedAppFree"));
				  console.log('====component.get("v.selectedRoleCm")======='+component.get("v.selectedRoleCm"));
				  console.log('====component.get("v.rlsRole"),====='+component.get("v.rlsRole"));
				  console.log('====component.get("v.rlsNumber")===='+component.get("v.rlsNumber"));
				  console.log('====component.get("v.rlsEmail")==='+component.get("v.rlsEmail"));
					  
			  }
			  
			  //set attributes for Guidanz Mobile FT save.
			  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_App_GuidanzMobileFieldTest")
			  || component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_FT_NPBU_Diagnostics")){
				  
				  console.log('Printing selected Guidanz'+component.get("v.selectedAppFree"));
				  console.log('Printging slected Guidanz Roles'+component.get("v.selectedRoleCm"));					
				  action2=component.get('c.saveFreeAppGuidanzMobileFT')
				  action2.setParams({
					  recordid : component.get("v.recordId"), 
					  appName : component.get("v.selectedAppFree"),
					  rolesNames : component.get("v.selectedRoleCm"),
					  subEndDate : component.get("v.userSubEndDate"),
					  assignedCount : component.get("v.assignedCount")
				  }); 
			  }

                //set attributes for Guidanz save.
                if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Guidanz")){
					
					console.log('Printing selected Guidanz'+component.get("v.selectedAppFree"));
                    console.log('Printging slected Guidanz Roles'+component.get("v.selectedRoleCm"));
					var rolesGuidanz=[];
                    rolesGuidanz=component.get("v.selectedRoleCm");
					action2=component.get('c.saveFreeAppGuidanz')
					action2.setParams({
						recordid:component.get("v.recordId"), 
                        appName:component.get("v.selectedAppFree"),
                        rolesNames:rolesGuidanz
					}); 
				}
                
                //Amarnath Mishra added for the market place
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_OSM_App_Name")){
					
					console.log('Printing selected Guidanz'+component.get("v.selectedAppFree"));
                    console.log('Printging slected Guidanz Roles'+component.get("v.selectedRoleCm"));
					var rolesGuidanz=[];
                    rolesGuidanz=component.get("v.selectedRoleCm");
					if(rolesGuidanz.length > 0 ){
						action2=component.get('c.saveFreeAppMarketPlace')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:rolesGuidanz
						}); 
					}
				}
				if (component.get("v.selectedAppFree") == $A.get("$Label.c.IAM_FluidWatch")) {

					console.log('Printing selected Guidanz' + component.get("v.selectedAppFree"));
					console.log('Printging slected Guidanz Roles' + component.get("v.selectedRoleCm"));
					var rolesGuidanz = [];
					rolesGuidanz = component.get("v.selectedRoleCm");
					if (rolesGuidanz.length > 0) {
						action2 = component.get('c.saveFreeAppFluidWatch')
						action2.setParams({
							recordid: component.get("v.recordId"),
							appName: component.get("v.selectedAppFree"),
							rolesNames: rolesGuidanz
						});
					}
				}
                //Fleetgaurd fit
				if(component.get("v.selectedAppFree")== "Fleetguard FIT"){
					
					console.log('Printing selected Guidanz'+component.get("v.selectedAppFree"));
                    console.log('Printging slected Guidanz Roles'+component.get("v.selectedRoleCm"));
					//var rolesGuidanz=[];
                    //rolesGuidanz=component.get("User");
					//if(rolesGuidanz.length > 0 ){
						action2=component.get('c.saveFreeAppFleetguardFit')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:"User"
						}); 
					//}
				}
                
				//Changes for Global dealer portal 
				//Global Dealer Portal Changes
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_AppName_GlobalDealerPortal")){
				  
					console.log('Printing selected GDP'+component.get("v.selectedAppFree"));
					console.log('Printging slected GDP Roles'+component.get("v.selectedRoleCm"));
					var rolesGDP=[];
					rolesGDP=component.get("v.selectedRoleCm");
					if(rolesGDP.length > 0 ){
						action2=component.get('c.saveFreeAppGlobalDealerPortal')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:rolesGDP
						}); 
					}
				}

				/*Start Cummins API Portal changes -@Suresh */
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_Application_Name_Cummins_API_Portal")){
				  
					console.log('Printing selected Cummins API Portal'+component.get("v.selectedAppFree"));
					console.log('Printging slected Cummins API Portal Roles'+component.get("v.selectedRoleCm"));
					var rolesCumminsAPIPortal=[];
					rolesCumminsAPIPortal=component.get("v.selectedRoleCm");
					if(rolesCumminsAPIPortal.length > 0 ){
						action2=component.get('c.saveFreeAppCumminsAPIPortal')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:rolesCumminsAPIPortal
						}); 
					}
				}

              /*End Cummins API Portal changes -@Suresh */

				/* Fluids Registration Changes - @Anupam */
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_AppName_FluidRegistraion")){                  
					console.log('Printing selected FluidReg'+component.get("v.selectedAppFree"));
					console.log('Printging slected FluidReg Roles'+component.get("v.selectedRoleCm"));
                    var roleFluidReg = [];
                    roleFluidReg=component.get("v.selectedRoleCm");
					
					if(roleFluidReg.length > 0 ){
						action2=component.get('c.saveFreeAppFluidRegister')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:roleFluidReg
						}); 
					}
				}
				/* Guidanz Service Portal Changes */
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_AppName_GuidanzServicePortal")){                  
					console.log('Printing selected GDP'+component.get("v.selectedAppFree"));
					console.log('Printging slected GDP Roles'+component.get("v.selectedRoleCm"));
                    var roleList = component.get("v.selectedRoleCm");
					var appMap = {
						Application :component.get("v.selectedAppFree"), 
						Role:roleList.toString()
					}
					
					action2=component.get('c.saveFreeApp')
					action2.setParams({
						recordid:component.get("v.recordId"), 
						App:appMap,
						appName:component.get("v.selectedAppFree")
					});
				}

				//Fix - D-3194 - save logic for RSW app
				if(component.get("v.selectedAppFree")== $A.get("$Label.c.IAM_RSW_App")){
					
					console.log('Printing selected rsw'+component.get("v.selectedAppFree"));
                    console.log('Printging slected rsw Roles'+component.get("v.selectedRoleCm"));
					var rolesRSW =[];
                    rolesRSW=component.get("v.selectedRoleCm");
					if(rolesRSW.length > 0 ){
						action2=component.get('c.saveFreeAppRSW')
						action2.setParams({
							recordid:component.get("v.recordId"), 
							appName:component.get("v.selectedAppFree"),
							rolesNames:rolesRSW
						}); 
					}
				}
                
                //end for save
			 var self = this;
			action2.setCallback(this, function(actionResult) {
				
				if(actionResult.getState()=="SUCCESS"){
					if(actionResult.getReturnValue()=="Record Created"){
						//then display Success Toast
						 /*$A.get('e.force:refreshView').fire();
						 $A.get('e.c:IAM_PageReload').fire();
						component.set('v.successMessage',"Application Assigned Successfully");
						//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
						component.set('v.selectedAppFree',"None")
						component.set('v.PCRole','');
						component.set('v.CustList','');
						component.set('v.session','');
						var actionSuccess=component.get('c.showSuccessToast');
						$A.enqueueAction(actionSuccess);
                        */
                        if(component.get("v.IsFromVF")== "false"){
						 $A.get('e.force:refreshView').fire();
						 $A.get('e.c:IAM_PageReload').fire();
						component.set('v.successMessage',"Application Assigned Successfully");
						//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
						console.log('==value of IsFromVF==='+component.get("v.IsFromVF"));
                        
                            console.log('====Inside if is not from VF===');
                           component.set('v.selectedAppFree',"None")
							component.set('v.PCRole','');
							component.set('v.CustList','');
							component.set('v.session','');
							var actionSuccess=component.get('c.showSuccessToast');
							$A.enqueueAction(actionSuccess); 
                        }else{
                            console.log('===Inside else if form the VF==');
                           	component.set('v.errorContact', 'Application Assigned Successfully');
							component.set('v.successContactFlag',"true");
							$A.get('e.c:IAM_ShowErrorMessages').fire(); 
                        }
					}else if(actionResult.getReturnValue().includes('Exsisting User')){ //Code added by Karthik -01/25/2021
						const contactId= actionResult.getReturnValue().split('-');
						component.set('v.successMessage',"Application Assigned Successfully");
						var actionSuccess=component.get('c.showSuccessToast');
							$A.enqueueAction(actionSuccess);
							var urlEvent=$A.get("e.force:navigateToURL");
							urlEvent.setParams({
								"url":"/"+contactId[1]
							});
							urlEvent.fire();
							//Code added by Karthik -01/25/2021
					}else{
						// Display Error message Toast
						var mainstring = actionResult.getReturnValue();
						var finalmessage;
						var value = mainstring.indexOf('If you are trying to edit existing application access');
                        if(value != -1){
                         	var showmessage = actionResult.getReturnValue().split(':');
							console.log('===value of record is ===='+showmessage[2]);
                    		component.set('v.conPorRecordId',showmessage[2]);
							//fix - Defect - D-2854 - display different error for site admin
							console.log('===value of v.IsFromVF is ====  '+ component.get('v.IsFromVF'));
							if(component.get('v.IsFromVF') == 'true'){
								finalmessage = $A.get("$Label.c.IAM_duplicate_Application_error");
							}else{
								finalmessage = $A.get("$Label.c.IAM_duplicate_app_error_ba");  
								component.set('v.showEditLink',"true");
							}	
                        }
                        else{
                            finalmessage = actionResult.getReturnValue();
                        }
						
						component.set('v.errorContact',finalmessage);
						component.set('v.errorContactFlag',"true");
						$A.get('e.c:IAM_ShowErrorMessages').fire();
						
						component.set('v.errorContactFlag',"true");
						$A.get('e.c:IAM_ShowErrorMessages').fire();
					}
				}else{
					//define why call goy failed. and check result 1 value and display message accordingly
					
					component.set('v.errorContact', 'Something went wrong please contact System administrator.');
						component.set('v.errorContactFlag',"true");
						$A.get('e.c:IAM_ShowErrorMessages').fire();
				}    
			});
				
			$A.enqueueAction(action2);      
			}
		
		},
		
	   saveBothApps:function(component,event,helper) {
	  
	   
		  var result1;//value to store the call one value
		  var result2;//value to store the call2 value
		  if(component.get("v.selectedValue")!="None"){
			
			  //Need to call controller class to save the record.
			  var appEvent = $A.get("e.c:IDM_Application_Table_Event2");
			   appEvent.setParams({
				   "isRefreshAndNotSave": "false"});
			   appEvent.fire();
		  
		   console.log(component.get("v.recordId")+'   '+component.get("v.selectedValue")+'    '+component.get("v.SelectedIDMApplication"));
		   var action = component.get("c.ProcessSubscriptionAppRec");
		  action.setParams({ Conid : component.get("v.recordId"),
							 SelectedSubscription : component.get("v.selectedValue"),
							 SelectedApps : component.get("v.SelectedIDMApplication")});
		  action.setCallback(this, function(response) {
			  var state = response.getState();
			  if (state === "SUCCESS") {
				console.log(response.getReturnValue());
				  result1=response.getReturnValue();
			  }
			  else if (state === "INCOMPLETE") {
				  
			   console.log("Incomplete");
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
			  
		  component.set("v.SelectedIDMApplication",[]);   
		  
		  var appEvent2 = $A.get("e.c:IDM_Application_Table_Event2");
		  appEvent2.setParams({
				   "isRefreshAndNotSave": "true"});
		  appEvent2.fire();
			  
		  /************/
		  
		  }
		  
		  var action2;
		  
		  if(component.get("v.selectedAppFree")!="None"){
			  if(component.get("v.selectedAppFree")=="Product Connectivity"){
				  var DA={Application :component.get("v.selectedAppFree"), 
						  Role:component.find("pcRole").get("v.value"),
						  custList:component.find("CList").get("v.value"),
						  session:component.find("session").get("v.value")
						 }
				  
				  action2=component.get('c.saveFreeApp')
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:DA,
					  appName:component.get("v.selectedAppFree")
				  });
			  }
			  if(component.get("v.selectedAppFree")=="Repair logistics and Service"){
				  
				  var RLS={Application:component.get("v.selectedAppFree"),
						   Role:component.get("v.rlsRole"),
						   rlsNumber:component.get("v.rlsNumber"),
						   rlsEmail:component.get("v.rlsEmail")
						  }
				  
				  action2=component.get('c.saveFreeApp')
				  action2.setParams({
					  recordid:component.get("v.recordId"), 
					  App:RLS,
					  appName:component.get("v.selectedAppFree")
				  }); 
			  }
		   var self = this;
		  action2.setCallback(this, function(actionResult) {
			  
			  if(actionResult.getState()=="SUCCESS"){
				  
				  if(actionResult.getReturnValue()=="Record Created"){
					  //then Check the status for both the calls and display toast accordingly
					  result2=actionResult.getReturnValue();
				  }else{
					  // Why record not got created.and check result1 and display message accordingly
					  result2=actionResult.getReturnValue(); 
				  }
			  }else{
				  //define why call goy failed. and check result 1 value and display message accordingly
				  result2="Please contact System Adminstrator";
			  }
			  //part where we need to decide how to display the error message
			  
			  if(result1=="Record Created"&&result2=="Record Created"){
				  //Since both insertions are success we can dispaly toast saying both the applications are inserted
				  component.set('v.showAppAssaign',"false");
				  component.set('v.successMessage',"Application Assigned Successfully");
				  //$A.get('e.c:IAM_ShowSuccess_Toast').fire(); 
				  var actionSuccess=component.get('c.showSuccessToast');
					  $A.enqueueAction(actionSuccess);   
			  }else if(result1!="Record Created"&&result2=="Record Created"){
				  //need to set diaply error for result 1 and result 2 as success.
				  
				  component.set('v.showAppAssaign',"false");
				  component.set('v.errorContact','User can access free Application.But there is some issue with Paid application. Please Contact System Administrator to provide access for paid Application.' );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
				  
			  }else if(result1=="Record Created"&&result2!="Record Created"){
				  
				  component.set('v.showAppAssaign',"false");
				  component.set('v.errorContact','User can access paid Application.But there is some issue with free application. Please Contact System Administrator to provide access.' );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
			  }else{
					 //need to display a common Error saying insert failed.
				  component.set('v.showAppAssaign',"false"); 
				  component.set('v.errorContact','There is some issue while performing the operation /n Please Contact System Administrator.' );
				  component.set('v.errorContactFlag',"true");
				  $A.get('e.c:IAM_ShowErrorMessages').fire();
			  }
		  });
		  $A.enqueueAction(action);    
		  $A.enqueueAction(action2); 
		  }
	  },
  
	  updateSelect: function(component, event, helper){
		  
		  var result1;
		  var result2;
		var action=component.get('c.GetSubcriptionNames');
		  action.setParams({
		  recordid:component.get("v.recordId"),
			  type:"subName"
		  });
		   var self = this;
	  action.setCallback(this, function(actionResult) {
		  
		  if(actionResult.getState()=="SUCCESS"){
			  
			  result1=actionResult.getState();
			  
			  if(actionResult.getReturnValue()!='There are no subscriptions for this Location.'){
		  var opts=[];
		  opts.push({value: "None", label: "None",Selected: true });
		  
		  for(var i=0;i<actionResult.getReturnValue().length;i++){
			  
			  opts.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
		  }
	   component.set("v.selectedValue","None");   
	   component.set('v.options', opts);
	  //return the selected value
	  //component.find("mySelect").get("v.value");
			  }else{
				  //need to assaign return value to a string to show in apppopup
				  component.set('v.subPresent',actionResult.getReturnValue()[0]);
				   component.set("v.selectedValue","None");
			  }
			  
		  }else{
			  alert('Something unexpected has happened please contact System administrator.');
		  }
	  });
	  $A.enqueueAction(action);
		  
		  //Function to get free application names
		  var action1=component.get('c.GetSubcriptionNames');
		  action1.setParams({
		  recordid:component.get("v.recordId"),
			  type:"appName"
		  });
		   var self = this;
	  action1.setCallback(this, function(actionResult) {
		  
		  result2=actionResult.getState();
		  
		  if(actionResult.getState()=="SUCCESS"){
			  if(actionResult.getReturnValue()!='There are no subscriptions for this Location.'){
		  var opts=[];
				  opts.push({value: "None", label: "None" ,selected :true});
		
		  for(var i=0;i<actionResult.getReturnValue().length;i++){
		  
			  opts.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
		  }
		  
	   component.set('v.appOptionsfree', opts);
	   component.set('v.selectedAppFree',"None");           
	  //return the selected value
	  //component.find("mySelect").get("v.value");
			  }else{
				  
				  //need to assaign return value to a string to show in apppopup
				  component.set('v.appPresentFree','No Free applications are present for this location');
				  //setting the below attribute value so that other save function works properly
				  component.set('v.selectedAppFree',"None");
				  }
			  
		  }else{
			  alert('Something unexpected has happened please contact System administrator.');
		  }
		  if(result1=="SUCCESS"&&result2=="SUCCESS"){
			 //document.getElementById("AppAssign").style.display = "block"; 
			 //making showAppAssign boolean flag to true
			 component.set('v.showAppAssaign',"true");
			  
		  }else{
			  
			  alert('Something unexpected has happened please contact System administrator.');
		  }        
	  });
	   
	  $A.enqueueAction(action1);  
		  
	  },
  
  //function to get userInfo
  getUserInfo:function(component,event,helper){
	  var action = component.get('c.getUserInfo');
	  //action.setParams({
	  //	 recordid:component.get("v.recordId")
	   //}); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	   component.set('v.UserRole', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);
  },
  //Amarnath Mishra added for the edit role logic
  getsApplicationName:function(component){
	  var action = component.get('c.getsApplicationName');
	  action.setParams({
		   recordid:component.get("v.recordId")
	   }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	   component.set('v.applicationName', actionResult.getReturnValue());
	  });
	  $A.enqueueAction(action);	
  },
  
  getUserType:function(component,event,helper){
	  console.log('==Inside getUserType===');
	  var action = component.get('c.getUserType');
		  action.setParams({
		  recordid:component.get("v.recordId")
		  }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	  console.log('====actionResult.getReturnValue()===='+actionResult.getReturnValue());
	  var result = actionResult.getReturnValue();
	  if(actionResult.getReturnValue().IAM_Internal__c == 'false'){
		  component.set('v.IsInternalUser', false);
	  }
	  if(actionResult.getReturnValue().IAM_Internal__c == 'true'){
		  component.set('v.IsInternalUser', true);
	  }
	  if(actionResult.getReturnValue().IsInternalAccount == 'True') {
		  component.set('v.IsInternalAccount', true);
	  }
	  if(actionResult.getReturnValue().IsInternalAccount == 'False') {
		  component.set('v.IsInternalAccount', false);
	  }    
	  if(actionResult.getReturnValue().IAM_Legacy_User__c == 'false'){
		  component.set('v.IsLegacy', false);
	  }
	  if(actionResult.getReturnValue().IAM_Legacy_User__c == 'true'){
		  component.set('v.IsLegacy', true);
	  }
		 
	  if(actionResult.getReturnValue().CMI_CId__c != ''){
		  console.log('===Inside CMI_CID====');
		  component.set('v.CustList',actionResult.getReturnValue().CMI_CId__c);
	  }
	  component.set('v.contactStatus',actionResult.getReturnValue().IAM_Contact_Status__c);
	  component.set('v.ConUid',actionResult.getReturnValue().Username__c );
	  
	  console.log('===IsInternalUser===='+component.get("v.IsInternalUser"));
	  console.log('===contactStatus====='+component.get("v.contactStatus"));
	  console.log('===Username===='+component.get("v.ConUid"));
	  });
	  $A.enqueueAction(action);
  },
  
  getUserReclaimStatus:function(component,event,helper){
	  console.log('==Inside getUserType===');
	  var action = component.get('c.getUserReclaimStatus');
		  action.setParams({
		  recordid:component.get("v.recordId")
		  }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	  console.log('====actionResult.getReturnValue() in reclaim===='+actionResult.getReturnValue());
	   component.set('v.IsReclaim', actionResult.getReturnValue());
	   console.log('===IsReclaim===='+component.get("v.IsReclaim"));
	  });
	  $A.enqueueAction(action);
  },
  
  getAppFeatStatus:function(component,event,helper){
	  console.log('==Inside getAppFeatStatus===');
	  var action = component.get('c.getAppFeatStatus');
		  action.setParams({
		  recordid:component.get("v.recordId")
		  }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	  console.log('====actionResult.getReturnValue() in App Feat===='+actionResult.getReturnValue());
	   component.set('v.IsAppActive', actionResult.getReturnValue());
	   console.log('===IsAppActive===='+component.get("v.IsAppActive"));
	  });
	  $A.enqueueAction(action);
  },
  UserHavePerm:function(component,event,helper){
	  console.log('==Inside UserHavePerm===');
	  var action = component.get('c.UserHavePerm');
		  action.setParams({
		  recordid:component.get("v.recordId")
		  }); 
	  // Set up the callback
	  var self = this;
	  action.setCallback(this, function(actionResult) {
	  console.log('====actionResult.getReturnValue() in UserHavePerm===='+actionResult.getReturnValue());
	   component.set('v.UsrHasPerm', actionResult.getReturnValue());
	   console.log('===IsAppActive===='+component.get("v.IsAppActive"));
	  });
	  $A.enqueueAction(action);
  }
})