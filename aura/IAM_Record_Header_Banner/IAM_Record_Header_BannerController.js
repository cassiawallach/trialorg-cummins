({  
	getRole : function(component, event, helper) {
		console.log(component.get("v.selectedRoleCm"));
		var role = component.get("v.selectedRoleCm");
        if(role == 'Field Test CalAssist Units Guidanz Mobile'
          || role == 'Field Test Intapp Units Guidanz Mobile'
          || role == 'Field Test Intapp OEM Units Guidanz Mobile'){
           component.set("v.isCountApp", "true");
        } else {
			component.set("v.isCountApp", "false");
		}
    },
	getsName: function(component, event, helper) {      
	// Fetch the account list from the Apex controller   
		if(component.get("v.IsFromVF")=="false"){
	helper.getsObjName(component);
	helper.getsetpassword(component);
	helper.getUnlock(component);
	helper.getUserInfo(component); 
	helper.getProfile(component);
		}else 
		{
		  helper.updateSelect(component, event, helper);
		}
		helper.getUserReclaimStatus(component);
		helper.getUserType(component);
  },
	
  getsObjInfo: function(component, event, helper) {  
	   if(component.get("v.IsFromVF")=="false"){

	// Fetch the account list from the Apex controller   
		  helper.getsObjList(component);
	  }
	  helper.getUserType(component);
	  helper.getUserReclaimStatus(component);
	helper.getAppFeatStatus(component);
	  helper.UserHavePerm(component);
  },

editRole: function(component, event, helper) {  
		console.log('Clicked on Edit role button');
		console.log('=======Record id=========='+component.get("v.recordId"));
		helper.getsApplicationName(component);
		component.set('v.showEditRole',"true");
				  
  },
 
	editRecord : function(component, event, helper) {
	var editRecordEvent = $A.get("e.force:editRecord");
	editRecordEvent.setParams({
		 "recordId": component.get("v.recordId")
   });
	editRecordEvent.fire();
},
   getSendToPC: function(component, event, helper) {      
	// Fetch the send to PC from the Apex controller
	   
	helper.getSendToPCInfo(component,event);
  }, 
	
	doInt: function(component, event, helper) {      
	// Fetch the account list from the Apex controller   
	helper.getsObjName(component);
	helper.getsObjList(component);
	helper.getsetpassword(component);
	helper.getUnlock(component);
	helper.getProfile(component);
	helper.getUserType(component);
	helper.getUserReclaimStatus(component);
  },
   
	getCDAINFO: function(component, event, helper) {      
	// Fetch the Generate CDA from the Apex controller   
	helper.getCDAToPC(component,event);
  },
	getUserName: function(component, event, helper) {      
	// function for Generate Uaser id button   
	helper.getUserInfo(component,event);
  },
	getContName: function(component, event, helper) {      
	// funtion for Activate user in the user contact record
	 console.log('Activate Button clicked');  
	helper.getContInfo(component,event);
   
  },
	 getdeactivate: function(component, event, helper) {      
	// funtion for Activate user in the user contact record  
	//Amarnath Mishra added logic for the cancellation reason
	if(component.get("v.rejectionReason") && component.get("v.comments")){
		helper.getContInfo(component,event);
		helper.hideModal(component,event);
	}
	else{
		console.log('====Inside else of getdeactivate==');
	}
	
  },
	//password reset functionality
	resetPasswrd: function(component, event, helper) {      
	// funtion for reset password and Unlock user.
	
	//Console.log('Clicked on reset password button');
   var action = component.get('c.setPassword');
	action.setParams({
		 recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")
	 }); 
	// Set up the callback
	var self = this;
	action.setCallback(this, function(actionResult) {
	  
	   console.log('Printing return value'+actionResult.getReturnValue());
	   console.log('Prinitng return status'+actionResult.getState());
		
		if(actionResult.getState()=="SUCCESS"){
			
			console.log('Printing return value'+actionResult.getReturnValue());
				component.set('v.successMessage',actionResult.getReturnValue());
				var actionSuccess=component.get('c.showSuccessToast');
					$A.enqueueAction(actionSuccess);
			   $A.get('e.force:refreshView').fire();
			   $A.get('e.c:IAM_PageReload').fire();
					
		}else{
			//error component to invoke
			 component.set('v.errorContactProvisioning', actionResult.getReturnValue());
				 component.set('v.errorContactProvisioningFlag',"true")
			   $A.get('e.c:IAM_ShowErrorMessages').fire();
		}
	});
	$A.enqueueAction(action);
  },
	
navigate : function(component, event, helper) {
console.log('INSIDE NAVIGATE');
var userid = component.get("v.ConUid");
console.log('INSIDE NAVIGATE222'+userid);
//Code to make a call to Controller and do the excrytion.    
	var action = component.get('c.encryptUserID');
	action.setParams({
		 username:component.get("v.ConUid")
	 }); 
	// Set up the callback
	var self = this;
	action.setCallback(this, function(actionResult) {
	 //alert('encrypted Value'+actionResult.getReturnValue());
		
 var urlEvent = $A.get("e.force:navigateToURL");
urlEvent.setParams({
  "url": 'https://userreg-prd.cummins.com/userreg/controller.jsp?action=channelAdmin&lang=en&uid=' +actionResult.getReturnValue()
});
urlEvent.fire();   
	});
	$A.enqueueAction(action);
},
	showModal : function(component, event, helper) {
		
		//debugger;
		//document.getElementById("DeActive").style.display = "block";
		component.set("v.displayModal",true);
	
	},
	
	//function to show warnign message
	showError : function(component, event, helper) {
		
		component.set("v.displayErrorModal",true);
		//document.getElementById("Warning").style.display = "block";
	
	},
	hideError : function(component, event, helper) {
	
		component.set("v.displayErrorModal",false);
		window.location.reload()
		//document.getElementById("Warning").style.display = "none";
	
	},    
   hideModal : function(component,event, helper){
	
	   //document.getElementById("DeActive").style.display = "none" ;
	   component.set("v.displayModal",false);
   },
	
	//showing toast messages
	showInfoToast : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Info Message',
			message: 'Mode is dismissible ,duration is 5sec and this is normal Message',
			messageTemplate: 'Record {0} created! See it {1}!',
			duration:' 5000',
			key: 'info_alt',
			type: 'info',
			mode: 'dismissible'
		});
		toastEvent.fire();
	},
	showSuccessToast : function(component, event, helper) {
		
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Success Message',
			message: component.get("v.successMessage"),
			messageTemplate: 'Record {0} created! See it {1}!',
			duration:' 5000',
			key: 'info_alt',
			type: 'success',
			mode: 'stick'
		});
		toastEvent.fire();
		setTimeout(location.reload.bind(location), 1000);
	},
	showErrorToast : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Error Message',
			message:'Mode is pester ,duration is 5sec and Message is not overrriden because messageTemplateData is not specified',
			messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
			//duration:' 5000',
			key: 'info_alt',
			type: 'error',
			mode: 'sticky'
		});
		toastEvent.fire();
	},
	showWarningToast : function(component, event, helper) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title : 'Warning',
			message: 'Mode is pester ,duration is 5sec and normal message',
			messageTemplate: 'Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {1}',
			messageTemplateData: ['Salesforce', {
				url: 'http://www.webkul.com/',
				label: 'Click Here',
			}],
			duration:' 5000',
			key: 'info_alt',
			type: 'warning',
			mode: 'sticky'
		});
		toastEvent.fire();
	},
	showErrorMessages : function(Component,event,helper) {
	
		//$A.get('e.c:IAM_ShowError_Toast').fire();
		
		$A.get('e.force:refreshView').fire();
		$A.get('e.c:IAM_PageReload').fire();
		
	},
	//function is to update the application status to Inactive
	appInactivate:function(component,event,helper){
		if(component.get("v.rejectionReason") && component.get("v.comments")){
			console.log('==Contact Provisioning button clicked==');
			var action = component.get('c.AppDeleteSingle');
			action.setParams({
				 recordid:component.get("v.recordId"),
				 buName:event.getSource().get("v.value"),
				 rejectReason:component.get("v.rejectionReason"),
				 rejectcomments:component.get("v.comments")
			 }); 
			// Set up the callback
			var self = this;
			action.setCallback(this, function(actionResult) {
				if(actionResult.getState()=="SUCCESS"){
					component.set("v.displayModal",false);
					if(actionResult.getReturnValue()=="Ok"){
					   component.set('v.successMessage','Application Deactivated Successfully');
					   //$A.get('e.c:IAM_ShowSuccess_Toast').fire();
					   var actionSuccess=component.get('c.showSuccessToast');
							$A.enqueueAction(actionSuccess);
					   $A.get('e.force:refreshView').fire();
					   $A.get('e.c:IAM_PageReload').fire();
					 }else{
					   component.set('v.errorContactProvisioning', actionResult.getReturnValue());
						 component.set('v.errorContactProvisioningFlag',"true")
					   $A.get('e.c:IAM_ShowErrorMessages').fire();					
					 } 
				}
			});
			$A.enqueueAction(action); 
		}else{
			console.log('===Inside else part of appInactivate==');
		}
	},
	
	//below function is to display Subscription roles in the dropdown
	updateSelect: function(component, event, helper){
		
		var status = component.get("v.sObjInfo");
		//component.get('v.IsInactiveContact',false);
		if(status.IAM_Contact_Status__c == 'Inactive'||status.IAM_Contact_Status__c == 'Pending')
		{
			//component.get('v.IsInactiveContact',"true");
			component.set('v.IsInactiveContact',"true");                
		}
		else{
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
			//alert('setting showApp assign value',component.get('v.showAppAssaign'));
		}else{
			
			alert('Something unexpected has happened please contact System administrator.');
		}        
	});
	 
	$A.enqueueAction(action1); 
		}
	},
	

	//this function is to hide the  App assaign modal
	hideApp : function(component, event, helper) {

		//Setting component values to default inorder to open it as a new component.
		//this is not  a good practice need to modify this login by creating copmponent dynamically.
		component.set('v.selectedAppFree',"None")
		component.set('v.PCRole','');
		component.set('v.CustList','');
		component.set('v.session','');
		component.set('v.showAppAssaign',"false");
	  window.location.reload()
		
		//document.getElementById("AppAssign").style.display = "none";
		//Even we need to make all the values in Compoent to null irrespective of the previous value
		
	   
	},
	
	//Below function is to get the application names from application table on selection of Subcription name
	diplaySelected:function(component,event,helper){
		
		if(component.get("v.selectedValue")!="None"){
		var action=component.get('c.getApplicationNames')
		action.setParams({
		recordid:component.get("v.recordId"),
		selectedVal:component.get("v.selectedValue")      
		});
		 var self = this;
		action.setCallback(this, function(actionResult) {
			
	   // Code commented need to be used as an enhancement for the current application 
		 //Create an empty array to store the map keys 
				var arrayMapKeys = [];
				//Store the response of apex controller (return map)   
				 
				var result = actionResult.getReturnValue();
				//Create and empty array Amarnath Mishra added for role visiblity of Qsol and Guidanz
				var arrayMaptest = [];
				//Set the store response[map] to component attribute, which name is map and type is map. 
				 
				component.set('v.companyMap', result);
				
				for (var key in result) {
					arrayMapKeys.push(key);
				}
				component.set('v.showServiceId',false);
			for(var i=0;i<arrayMapKeys.length;i++){
				 console.log("LET SEE==>"+arrayMapKeys[i]);
				if(arrayMapKeys[i]=='Cummins Service Training')
					component.set('v.showServiceId',true);
				 }
				 
				//Set the list of keys.  
				if(arrayMapKeys!='NoValue'){  // D-2818 
				component.set('v.keyList',arrayMaptest);
				//$A.get('e.force:refreshView').fire();  
				component.set('v.keyList', arrayMapKeys);
			
			var optsApp=[];
		optsApp.push({value: "None", label: "None",Selected:true });
		for(var i=0;i<actionResult.getReturnValue().length;i++){
			
			optsApp.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
		}
		
		component.set('v.appOptionsSub', optsApp);
			component.set('v.selectedAppSub',"None");
		}
		else{ // D-2818 
			component.set('v.noApp','No applications are present for assignment');
			}
		});
		$A.enqueueAction(action);
	   }     
		
	},
	
	

	//function to check pattern of the customer list and Rls Cusotomer number
	displayclist:function(component,event,helper){
	
		var CList=component.find("CList");
		
		var list=component.find("CList").get("v.value");
		
 
		if(list!=''){
		var re = /^[0-9]+(,[0-9]+)*$/;

		var valid=re.test(list);
		
		 // Is input numeric?
		if(valid) {
			// Set error 
			//CList.set("v.errors", null);
			
			component.set("v.custError",null);
		} else {
			// Clear error
			//CList.set("v.errors", [{message:"Please enter number with Comma seperation and please do not place comma after last number"}]);
			
			component.set("v.custError","Please enter numbers with Comma seperation and do not place comma after last number");
		}
		}else{
			if(component.get("v.custError")!=null)
			{
				component.set("v.custError",'Complete this field');
			}
		}   
	   //	var validity = component.find("CList").get("v.validity").valid;
		
	},
	
	//javascript to call comtroller to save the application in Contact Provisioning table 
	saveApp: function(component,event,helper){
		//Checking validity of all the fields before executing the save operation
		
		
		if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
	   var allValid = component.find('PCfield').reduce(function (validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			console.log('====Inside save 01====');
			//Harshini Coded to handle inputCmp.get('v.validity') undified
			   var isvalid = false;
			if(typeof inputCmp.get('v.validity') != "undefined") 
				isvalid = inputCmp.get('v.validity').valid;
			return validSoFar && isvalid;
		 }, true);
		}  
		
		if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_RLS")){
	   var allValid = component.find('rlsRole').reduce(function (validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get('v.validity').valid;
		 }, true);
		} 
		
	  /*  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Cumpas")){
			console.log('===just in cumpas2.0===');
			console.log('#@#@#@#@'+component.find("cumpasr"));
	  var allValid = component.find("cumpasr").reduce(function (validSoFar, inputCmp) {
			
		   inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get('v.validity').valid;
		 }, true);
		   console.log('===Inside cumpas 2.0======');
		} */
		
		/*if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Guidanz")){
	   var allValid = component.find('Guidanz').reduce(function (validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get('v.validity').valid;
		 }, true);
		} */
		//IAM_None
		var none_Text = $A.get("$Label.c.IAM_None");
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree").length);
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree"));
		console.log('======Value of None===='+none_Text);
		//Amar fixed the issue#520-1,542 added one extra "or" condition in the if below if condition
		if(allValid|| (component.get("v.selectedAppFree")||component.get("v.ShowSaveButton")>0) || component.get("v.selectedValue") == none_Text){
		//End of validation
		
		//Close the app assign Modal by setting up the component dispaly flag to false
		
			console.log('====Inside if All valid=');
			if(component.get("v.selectedValue") == none_Text) {
				console.log('===Inside if none text 01====');
				if (component.get("v.selectedAppFree") != none_Text) {
					//need to call only free application access only
					console.log('==inside if selected free app 03===');
					component.set('v.showAppAssaign',"false");
					
					helper.appFreeSave(component,event,helper);
				}
			}
			else {
				if (component.get("v.ShowSaveButton") > 0) {
					console.log('===Inside else none text====03');
					 if  (component.get("v.selectedAppFree") == none_Text) {
						//need to call only subscribed application helper function
						component.set('v.showAppAssaign',"false");
						console.log('===Inside if if selected Free app==04');
						helper.SaveSubscribedApp(component,event,helper);
					}
					else {
						//need to call helper where both the calls are made.
						console.log('===Inside if else selected Free app 05==');
						helper.saveBothApps(component,event,helper);
					}
				}
			}
		
		} 
	  
		},
	
	
	//Function to check if a field has an error or not
	
	onClick: function (component, evt, helper) {
		var allValid = component.find('field').reduce(function (validSoFar, inputCmp) {
			inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get('v.validity').valid;
		 }, true);
		
		 if (allValid) {
			// alert('All form entries look valid. Ready to submit!');
		 } else {
			// alert('Please update the invalid form entries and try again.');
		 }
	 },

   
	
	
	
	
	//controller function to close the error modal on the contact layout
	hideContactError:function(component,event,helper){
	component.set('v.errorContactFlag',"false");
	window.location.reload()
	},
	hideContactProvisioningError:function(component,event,helper){
		component.set('v.errorContactProvisioningFlag',"false");
		window.location.reload()
	},
	
	//function to deactivate subcription record in Account application
	appAccountInactivate:function(component,event,helper){
		if(component.get("v.rejectionReason") && component.get("v.comments")){
			console.log('=====Application button clicked=====');
			component.set("v.displayModal",false);
			var action=component.get('c.deactivateAccountSub')
				action.setParams({
				recordId:component.get("v.recordId"),
				rejectReason:component.get("v.rejectionReason"),
				rejectcomments:component.get("v.comments")
				
			});
			 var self = this;
			action.setCallback(this, function(actionResult) {
			   component.set("v.displayModal",false);
				if(action.getState()=="SUCCESS"){
					//component.set("v.displayModal",false);
					if(action.getReturnValue()=="OK"){
						$A.get('e.force:refreshView').fire();
						$A.get('e.c:IAM_PageReload').fire();
						component.set('v.successMessage',"Succesfully Inactivated Subscription");
						var actionSuccess=component.get('c.showSuccessToast');
						$A.enqueueAction(actionSuccess);
					}else{
						//need to set the value to be displayed on the front end
						component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
						component.set('v.errorAccountProvisioningFlag',"true");
						//$A.get('e.c:showErrorMessages').fire();
						var errorRefresh=component.get('c.showErrorMessages');
						$A.enqueueAction(errorRefresh);
					}
				}else{
					//component.set("v.displayModal",false);
					//need to say why call got failed
					component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
					component.set('v.errorAccountProvisioningFlag',"true");
					//$A.get('e.c:showErrorMessages').fire();
					var errorRefresh=component.get('c.showErrorMessages');
					$A.enqueueAction(errorRefresh);
				}
			});
			$A.enqueueAction(action);
		}
		else{
			console.log('===Inside else part of appAccountInactivate==');
		}
	  },
 
	hideAccountProvisioningError:function(component,event,helper){
	component.set("v.errorAccountProvisioningFlag","false");
	}   ,
	
	//controller function which will get invoked by firing an event in IDM_Application_Table to show Save button and to 
	handleIDMEvent:function(component,event,helper){
		var IsIncrease = event.getParam("IsIncrease");
		var pushChosenValue= event.getParam("pushChosenValue");
		console.log("#######"+component.get("v.ShowSaveButton"));
		if(pushChosenValue=="false" && IsIncrease=="true" )
		{
			component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")+1);
			console.log('Inside Increase'+component.get("v.ShowSaveButton")); 
			//console.log('Printing is choosen in header banner'+event.getParam("ChosenValue"));
		}
		else if(pushChosenValue=="false" && IsIncrease=="false"){
			
			component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")-1); 
			console.log('Inside deccrease'+component.get("v.ShowSaveButton"));
		}
		else if(pushChosenValue=="true"){
			var SelectedValue =[];
			if(!$A.util.isEmpty(event.getParam("ChosenValue"))){ 
				SelectedValue=component.get("v.SelectedIDMApplication");
				SelectedValue.push(event.getParam("ChosenValue")[0]);
				console.log('vvv vvv '+SelectedValue);
				console.log('vvv vvv2 '+component.get("v.SelectedIDMApplication"));

				component.set("v.SelectedIDMApplication",SelectedValue);               
			}
			
		}
		/*if(component.get("v.ShowSaveButton")<0)
		{
			component.set("v.ShowSaveButton",0);            
		}*/
		
	},
	
	//refresh function gets invokes on change of subscription name 
	RefreshValue: function(component,event,helper){
		
		var oldValue= event.getParam("oldValue");
		var newValue = event.getParam("value");
		
		if( oldValue!='None' && oldValue!=null && oldValue!='')
		 {
			 
			 console.log('Printing appmap inrefresh'+component.get("v.appMap"));
			  var appEvent = $A.get("e.c:IAM_Application_Table_Event2");
			  appEvent.setParam({
				 "isRefreshAndNotSave": "true"});
			  appEvent.fire();
			
		 }
	  
	},
	
	 //function to display fetch adn set modular and roles for cumpas application
getModularandRoleValues:function(component,event,helper){
	console.log('=== Inside the value for get modualr values===');
	console.log('Selected free App'+component.get("v.selectedAppFree"));
	var modularity=[];
	var cumRoles=[];
	var rolesCm=[];
	var errors=[];
	
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_App_GuidanzMobileFieldTest")){
		console.log('====Inside IAM_App_GuidanzMobileFieldTest Serve====');
		var action = component.get('c.getGuidanzFieldTestRole')
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});            
		var self = this;
		rolesCm = [];
		console.log('=======Inside IAM_App_GuidanzMobileFieldTest Serve========');
		action.setCallback(this, function(actionResult) {
			console.log('Action Status'+action.getState());  
			  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue() != 'Please Contact administrator. Something went wrong') {                   
					for(var i=0;i<actionResult.getReturnValue().length;i++) {					
						rolesCm.push({label: actionResult.getReturnValue()[i],
									  value: actionResult.getReturnValue()[i]} );
					}
					console.log('Printing app roles'+rolesCm);    
					component.set("v.showRolemodular",false);
					component.set("v.GuidanzMobileFT",rolesCm);
				} else {
					//error handling
					component.set("v.showRolemodular",false);
					component.set("v.cumpasError",actionResult.getReturnValue());
				}
			}else{
				//Need to set a boolean variable to display message.
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",namesMap['error'][0]); 
			} 
		});
		$A.enqueueAction(action);
	}
	
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_FT_NPBU_Diagnostics")){
		var action = component.get('c.getGuidanzFieldTestRole')
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});            
		var self = this;
		rolesCm = [];
		action.setCallback(this, function(actionResult) {
			console.log('Action Status'+action.getState());  
			  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue() != 'Please Contact administrator. Something went wrong') {                   
					for(var i=0;i<actionResult.getReturnValue().length;i++) {					
						rolesCm.push({label: actionResult.getReturnValue()[i],
									  value: actionResult.getReturnValue()[i]} );
					}
					console.log('Printing app roles'+rolesCm);    
					component.set("v.showRolemodular",false);
					component.set("v.NPBUDiagnosticsFT",rolesCm);
				} else {
					//error handling
					component.set("v.showRolemodular",false);
					component.set("v.cumpasError",actionResult.getReturnValue());
				}
			}else{
				//Need to set a boolean variable to display message.
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",namesMap['error'][0]); 
			} 
		});
		$A.enqueueAction(action);
	}

	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Cumpas")){
		
		var action=component.get('c.getModularandRole')
		 action.setParams({
		recordid:component.get("v.recordId"),
			 selectedApp:component.get("v.selectedAppFree")	                 
		});
		
		 var self = this;
		action.setCallback(this, function(actionResult) {
		  
			if(action.getState()=="SUCCESS"){
				var namesMap= {};
				namesMap=action.getReturnValue();
				
				if(namesMap['error'][0]=='No Error'){
				   
				for(var i=0;i<namesMap['modular'].length;i++){
				
				modularity.push({label: namesMap['modular'][i],value: namesMap['modular'][i]} );
				}
				
				/*for(var i=0;i<namesMap['cumpasRoles'].length;i++){
				
				cumRoles.push({label: namesMap['cumpasRoles'][i],value: namesMap['cumpasRoles'][i]} );
				}*/
				
				for(var i=0;i<namesMap['roles'].length;i++){
				
				rolesCm.push({label: namesMap['roles'][i],value: namesMap['roles'][i]} );
				}
				
				component.set("v.modularOptions",modularity);
				component.set("v.showRolemodular",true);
				component.set("v.rolesCumpas",rolesCm);
				}else{
					//Need to set a boolean variable to display message.
				   
				 
				   
				   
					
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			}
		});
		$A.enqueueAction(action);
	}
	console.log("#######"+component.get("v.ShowSaveButton"));
	console.log('===Before Guidanz===='+component.get("v.selectedAppFree"));
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_Guidanz")){
		console.log('====Inside Guidanz Serve====');
			var action=component.get('c.getGuidanzRole')
		 action.setParams({
		recordid:component.get("v.recordId"),
		selectedApp:component.get("v.selectedAppFree")	                 
		});
		
		 var self = this;
		 rolesCm = [];
		 console.log('=======Inside Guidanz Serve========');
		action.setCallback(this, function(actionResult) {
		  console.log('Action Status'+action.getState());  
		  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			   // rolesCm=actionResult.getReturnValue();
					
				 
				for(var i=0;i<actionResult.getReturnValue().length;i++){
				
				rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
				}    
					
				console.log('Printing app roles'+rolesCm);    
				component.set("v.showRolemodular",true);
				component.set("v.Guidanz",rolesCm);
			}else{
				//error handling
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",actionResult.getReturnValue());
			}
				}else{
					//Need to set a boolean variable to display message.
					 component.set("v.showRolemodular",false);
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			
		});
		$A.enqueueAction(action);
	}
	
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_OSM_App_Name")){
		console.log('====Inside Marketplace role 01====');
		console.log('====component.get("v.selectedAppFree")	==='+component.get("v.selectedAppFree")	);
		//component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")-1); 
			var action=component.get('c.getMarketPlaceRole')
		 action.setParams({
		recordid:component.get("v.recordId"),
		selectedApp:component.get("v.selectedAppFree")	                 
		});
		
		 var self = this;
		 rolesCm = [];
		 console.log('=======Inside Marketplace role 02========');
		action.setCallback(this, function(actionResult) {
		  console.log('Action Status'+action.getState());  
		  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			   // rolesCm=actionResult.getReturnValue();
					
				 
				for(var i=0;i<actionResult.getReturnValue().length;i++){
				
				rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
				}    
					
				console.log('Printing app roles'+rolesCm);    
				component.set("v.showRolemodular",false);
				component.set("v.MarketPlace",rolesCm);
			}else{
				//error handling
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",actionResult.getReturnValue());
			}
				}else{
					//Need to set a boolean variable to display message.
					 component.set("v.showRolemodular",false);
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			
		});
		$A.enqueueAction(action);
	}
	
	 // Added logic for Fleetguard fit admin
	console.log('selectedAppFree===*****'+component.get("v.selectedAppFree"));
	if(component.get("v.selectedAppFree")== "Fleetguard FIT"){//$A.get("$Label.c.IAM_AppName_FleetguardFit")
		console.log('====Inside Fleetguard role 01====');
		console.log('====component.get("v.selectedAppFree")	==='+component.get("v.selectedAppFree")	);
		//component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")-1); 
			var action=component.get('c.getFleetguardFitRole')
		 action.setParams({
		recordid:component.get("v.recordId"),
		selectedApp:component.get("v.selectedAppFree")	                 
		});
		
		 var self = this;
		 rolesCm = [];
		 console.log('=======Inside Fleetguard role 02========');
		action.setCallback(this, function(actionResult) {
		  console.log('Action Status'+action.getState());  
		  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			   // rolesCm=actionResult.getReturnValue();
					
				 
				for(var i=0;i<actionResult.getReturnValue().length;i++){
				
				rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
				}    
					
				console.log('Printing app roles'+JSON.stringify(rolesCm));    
				component.set("v.showRolemodular",false);
				component.set("v.FleetguardFit" ,rolesCm);
				console.log('FleetguardFit==**=='+component.get("v.FleetguardFit"));
				
			}else{
				//error handling
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",actionResult.getReturnValue());
			}
				}else{
					//Need to set a boolean variable to display message.
					 component.set("v.showRolemodular",false);
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			
		});
		$A.enqueueAction(action);
	}
	
	 //Fix- D-3194 - added logic for RSW app
	  
	  if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_RSW_App")){
		  console.log('====Inside RSW role 01====');
		  console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		  var action=component.get('c.getRSWRole')
		  action.setParams({
			  recordid:component.get("v.recordId"),
			  selectedApp:component.get("v.selectedAppFree")	                 
		  });
		
		 var self = this;
		 rolesCm = [];
		 console.log('=======Inside RSW role 02========');
		action.setCallback(this, function(actionResult) {
		  console.log('Action Status'+action.getState());  
		  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
				for(var i=0;i<actionResult.getReturnValue().length;i++){
					rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
				}    
				console.log('Printing app roles'+rolesCm);    
				component.set("v.showRolemodular",false);
				component.set("v.RSWRoles",rolesCm);
			}else{
				//error handling
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",actionResult.getReturnValue());
			}
				}else{
					//Need to set a boolean variable to display message.
					 component.set("v.showRolemodular",false);
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			
		});
		$A.enqueueAction(action);
	}

	//Changes added by anupam for Global dealer portal	  
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_GlobalDealerPortal")){
		console.log('====Inside GDP role 01====');
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		var action=component.get('c.getGlobalDealerPortalRole')
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});
	  
	   var self = this;
	   rolesCm = [];
	   console.log('=======Inside GDP role 02========');
	  action.setCallback(this, function(actionResult) {
		console.log('Action Status'+action.getState());  
		console.log('actionResult'+actionResult.getReturnValue());
		  if(action.getState()=="SUCCESS"){
			  if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			  for(var i=0;i<actionResult.getReturnValue().length;i++){
				  rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
			  }    
			  console.log('Printing app roles'+JSON.stringify(rolesCm));    
			  component.set("v.showRolemodular",false);
			  component.set("v.GDPRoles",rolesCm);
		  }else{
			  //error handling
			  component.set("v.showRolemodular",false);
			  component.set("v.cumpasError",actionResult.getReturnValue());
		  }
			  }else{
				  //Need to set a boolean variable to display message.
				   component.set("v.showRolemodular",false);
				  component.set("v.cumpasError",namesMap['error'][0]); 
			  } 
			  
		  
	  });
	  $A.enqueueAction(action);
  }

  //Changes added by Anupam for FluidWatch Role - CHG0065800	  
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_FluidWatch")){
		console.log('====Inside FluidWatch role 01====');
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		var action=component.get('c.getFluidwatchRole')
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});
	  
	   var self = this;
	   rolesCm = [];
	   console.log('=======Inside FluidWatch role 02========');
	  action.setCallback(this, function(actionResult) {
		console.log('Action Status'+action.getState());  
		console.log('actionResult'+actionResult.getReturnValue());
		  if(action.getState()=="SUCCESS"){
			  if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			  for(var i=0;i<actionResult.getReturnValue().length;i++){
				  rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
			  }    
			  console.log('Printing app roles'+JSON.stringify(rolesCm));    
			  component.set("v.showRolemodular",false);
			  component.set("v.FluidWatch",rolesCm);
		  }else{
			  //error handling
			  component.set("v.showRolemodular",false);
			  component.set("v.cumpasError",actionResult.getReturnValue());
		  }
			  }else{
				  //Need to set a boolean variable to display message.
				   component.set("v.showRolemodular",false);
				  component.set("v.cumpasError",namesMap['error'][0]); 
			  } 
			  
		  
	  });
	  $A.enqueueAction(action);
  }

	//Amarnath Mihra added for the connected solution roles.
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
		console.log('====Inside Connected Serve====');
			var action=component.get('c.getConnectedSolutionRole')
		 action.setParams({
		recordid:component.get("v.recordId"),
		selectedApp:component.get("v.selectedAppFree")	                 
		});
		
		 var self = this;
		 rolesCm = [];
		  var roleSiteAdmin = [];
		 console.log('=======Inside Connected Serve========');
		action.setCallback(this, function(actionResult) {
		  console.log('Action Status'+action.getState());  
		  console.log('actionResult'+actionResult.getReturnValue());
			if(action.getState()=="SUCCESS"){
				if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			   // rolesCm=actionResult.getReturnValue();
					
				 
				for(var i=0;i<actionResult.getReturnValue().length;i++){
				
				rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
				}    
				if(component.get("v.IsFromVF") == "true"){
						roleSiteAdmin.push({label:"AccountManager",value:"AccountManager"});
						roleSiteAdmin.push({label:"Operator",value:"Operator"});
						roleSiteAdmin.push({label:"ServiceTechnician",value:"ServiceTechnician"});
						roleSiteAdmin.push({label:"Subscriber",value:"Subscriber"});
						component.set("v.showRolemodular",false);
						component.set("v.ConnectedSolution",roleSiteAdmin);
				}
				else{
					component.set("v.showRolemodular",false);
					component.set("v.ConnectedSolution",rolesCm);
					 
				}    
				console.log('Printing app roles'+rolesCm);    
				//component.set("v.showRolemodular",false);
				//component.set("v.ConnectedSolution",rolesCm);
				console.log('==connected solution roles===='+component.get("v.ConnectedSolution"));
			}else{
				//error handling
				component.set("v.showRolemodular",false);
				component.set("v.cumpasError",actionResult.getReturnValue());
			}
				}else{
					//Need to set a boolean variable to display message.
					 component.set("v.showRolemodular",false);
					component.set("v.cumpasError",namesMap['error'][0]); 
				} 
				
			
		});
		$A.enqueueAction(action);
	}

	/* Logic to get roles for Fluid Registration - @Anupam*/ 
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_FluidRegistraion")) {
		console.log('====Inside FluidReg role 01===='+component.get("v.recordId"));
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		var action=component.get('c.getFluidRegisterRole')
		action.setParams({
			recordId:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});	  
        var self = this;
        rolesCm = [];
        console.log('=======Inside FluidReg role 02========');
	  	action.setCallback(this, function(actionResult) {
            console.log('Action Status'+action.getState());  
            console.log('actionResult'+actionResult.getReturnValue());
            if(action.getState()=="SUCCESS"){
                if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
                    for(var i=0;i<actionResult.getReturnValue().length;i++){
                        rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
                    }    
                    console.log('Printing app roles'+JSON.stringify(rolesCm));    
                    component.set("v.showRolemodular",false);
                    component.set("v.fluidRegist",rolesCm);
                } else {
                    //error handling
                    component.set("v.showRolemodular",false);
                    component.set("v.cumpasError",actionResult.getReturnValue());
                }
            } else {
                //Need to set a boolean variable to display message.
                component.set("v.showRolemodular",false);
                component.set("v.cumpasError",namesMap['error'][0]); 
            } 
        });
        $A.enqueueAction(action);
    }
	//Start-Cummins API Portal changes -@Suresh
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_Application_Name_Cummins_API_Portal")){
		console.log('====Inside Cummins API Portal role 01====');
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		var action=component.get('c.getCumminsAPIPortalRole')
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});
	  
	   var self = this;
	   rolesCm = [];
	   console.log('=======Inside Cummins API Portal role 02========');
	  action.setCallback(this, function(actionResult) {
		console.log('Action Status'+action.getState());  
		console.log('actionResult'+actionResult.getReturnValue());
		  if(action.getState()=="SUCCESS"){
			  if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
			  for(var i=0;i<actionResult.getReturnValue().length;i++){
				  rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
			  }    
			  console.log('Printing app roles'+JSON.stringify(rolesCm));    
			  component.set("v.showRolemodular",false);
			  component.set("v.CumminsAPIPortalRoles",rolesCm);
		  }else{
			  //error handling
			  component.set("v.showRolemodular",false);
			  component.set("v.cumpasError",actionResult.getReturnValue());
		  }
			  }else{
				  //Need to set a boolean variable to display message.
				   component.set("v.showRolemodular",false);
				  component.set("v.cumpasError",namesMap['error'][0]); 
			  } 
			  
		  
	  });
	  $A.enqueueAction(action);
  }
	/* Logic to get roles for Guidanz Service Portal */  
	if(component.get("v.selectedAppFree")==$A.get("$Label.c.IAM_AppName_GuidanzServicePortal")) {
		console.log('====Inside GDP role 01===='+component.get("v.recordId"));
		console.log('====component.get("v.selectedAppFree")==='+component.get("v.selectedAppFree")	);
		var action=component.get('c.getGuidanzServicePortalRole')
		action.setParams({
			recordId:component.get("v.recordId"),
			selectedApp:component.get("v.selectedAppFree")	                 
		});	  
        var self = this;
        rolesCm = [];
        console.log('=======Inside GDP role 02========');
	  	action.setCallback(this, function(actionResult) {
            console.log('Action Status'+action.getState());  
            console.log('actionResult'+actionResult.getReturnValue());
            if(action.getState()=="SUCCESS"){
                if(actionResult.getReturnValue()!='Please Contact administrator. Something went wrong'){
                    for(var i=0;i<actionResult.getReturnValue().length;i++){
                        rolesCm.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
                    }    
                    console.log('Printing app roles'+JSON.stringify(rolesCm));    
                    component.set("v.showRolemodular",false);
                    component.set("v.GuidanzServicePRoles",rolesCm);
                } else {
                    //error handling
                    component.set("v.showRolemodular",false);
                    component.set("v.cumpasError",actionResult.getReturnValue());
                }
            } else {
                //Need to set a boolean variable to display message.
                component.set("v.showRolemodular",false);
                component.set("v.cumpasError",namesMap['error'][0]); 
            } 
        });
        $A.enqueueAction(action);
    }
},

showWrkGrpPopUp:function(component,event,helper){
	var regions=[];
	var sortedRegions=[];
	component.set("v.showWorkGrp","True");
	console.log('Printing WRK grp pop up in region');
	//setting up picklist value for region  
	//
	var action=component.get('c.wrkGrpRegions');
	action.setParams({
		 recordId:component.get("v.recordId")  
	 });
	action.setCallback(this, function(actionResult) {	
		console.log('Printing return values'+actionResult.getReturnValue());
		console.log('setting all values'+actionResult.getState());
		if(actionResult.getState()=="SUCCESS"){
			console.log('Printing success messgae');
			regions.push({label: "--Select--",value:"None",selected: true} );
			console.log('Printing applicaion length'+actionResult.getReturnValue().length);
			
			for(var i=0;i<actionResult.getReturnValue().length;i++){
				sortedRegions.push({label: actionResult.getReturnValue()[i],value:actionResult.getReturnValue()[i]} );  
			}
		}
		//sorting region 
		sortedRegions.sort(function(a, b){
			var x = a.label.toLowerCase();
			var y = b.label.toLowerCase();

			if (x < y) //sort string ascending
				return -1 
			if (x > y)
				return 1
			return 0 //default return value (no sorting)
		});
		regions.push.apply(regions, sortedRegions);
		console.log('Printing regions in the'+regions);
		component.set('v.regionsToDisplay',regions);
	});
	 $A.enqueueAction(action);
	//fetching Primary location 
	//console.log('Printing primary location recordId... '+ component.get("v.recordId"));
	var actionPrimaryLoc = component.get('c.getPrimaryLocation');
	actionPrimaryLoc.setParams({
		 recordId:component.get("v.recordId")  
	 });
	actionPrimaryLoc.setCallback(this, function(result) {	
		var primaryLoc = result.getReturnValue().primaryLocation;
		var selectedAccounts ; 
		var secondryWorkGroupId;
		selectedAccounts = result.getReturnValue().allAccounts;
		/*for (index = 0; index < selectedAccounts.length; index++) { 
			console.log(array[index]); 
			//secondryWorkGroupId = secondryWorkGroupId +'|'+array[index].Location__c;
		} 
		*/
		console.log('===selectedAccounts==='+selectedAccounts);
		console.log('Printing primary location===== '+ primaryLoc);
		component.set('v.primaryWrkGrp',primaryLoc.toString());
		console.log('====secondryWorkGroupId=='+secondryWorkGroupId);
		component.set('v.AllSecondryWrkGrp',selectedAccounts);
	});
	 $A.enqueueAction(actionPrimaryLoc);
	
},

//popup for remove work group
showRemoveWrkGrpPopUp:function(component,event,helper){
	
	component.set("v.showRemoveWorkGrp","True");
	console.log('Printing remove WRK grp pop up in region');
	 //Setting component values
	component.set('v.wrkGrpcolumns', [
	{label: 'Account name', fieldName: 'Name', type: 'text'},
	{label: 'Location Code', fieldName: 'Location__c', type: 'text'},
	{label: 'Type of Location', fieldName: 'Type', type: 'Picklist'},
	]);
	//calling action method for getting assigned work group   
	var action=component.get('c.getAssignedWorkGroup');
	action.setParams({
		 recordId:component.get("v.recordId")  
	 });
	action.setCallback(this, function(actionResult){
		 var sortedAccount = [];
		 sortedAccount = actionResult.getReturnValue();
		 //sorting account based on name
		 sortedAccount.sort(function(a, b){
			var x = a.Name.toLowerCase();
			var y = b.Name.toLowerCase();

			if (x < y) //sort string ascending
				return -1 
			if (x > y)
				return 1
			return 0 //default return value (no sorting)
		 });
		 console.log('sortedAccount ....  '+sortedAccount);
		 component.set('v.wrkGrpAccounts', sortedAccount);
		 
	});
	$A.enqueueAction(action);
},

//Method to get Distributor accounts under that location
getDistributors:function(component,event,helper){
	console.log('Printing selected region ... '+component.get("v.selectedRegion"));
	var selectedType=component.get("v.selectedRegion");
   
	if(component.get("v.selectedRegion")!="None"){
		console.log('before calling getDistributors function');
	var action = component.get("c.getAccountList");
		action.setParams({
			region:component.get("v.selectedRegion") 
		});
		action.setCallback(this, function(result){
		var accounts = result.getReturnValue();
		console.log("Printing all the account"+accounts);
		component.set("v.DistributorsToDisplay", accounts);
		console.log('Printing accounts lengthss'+accounts.length);
		var accountValues=[];
		var sortedAccountValues=[];
		if(accounts.length=='1'){
			component.set("v.DistributorsToDisplay", accounts);
		}else{
			accountValues.push({Name:"--Select--",Id:"None",});
			for (var value of accounts){
				//console.log(value);  
				sortedAccountValues.push({Name:value.Name,Id:value.Id});    
			}
			
			//sorting accountValues 
			sortedAccountValues.sort(function(a, b){
				var x = a.Name.toLowerCase();
				var y = b.Name.toLowerCase();

				if (x < y) //sort string ascending
					return -1 
				if (x > y)
					return 1
				return 0 //default return value (no sorting)
			});
			accountValues.push.apply(accountValues, sortedAccountValues);
			console.log("Printing all the accountValues .. "+accountValues);
			component.set("v.DistributorsToDisplay", accountValues);
			
		}	
		 
		if(accounts.length=='1'){
			var disributors=[];
			var selectedDist='';
			var selectedDistId;
			disributors = result.getReturnValue();
			for (var value of disributors){
				console.log(value);  
				selectedDist=value["Name"];
				selectedDistId=value["Id"]    
			}
				console.log('Select dist Id'+selectedDistId);
				component.set("v.selectedDistributor",selectedDistId);
				var actionLocType=component.get('c.getLocType');
				$A.enqueueAction(actionLocType);
		}
	});
	$A.enqueueAction(action);
		
	
	}else{
		console.log('Selected values is none');
	}    
},

//Method to get location type under that distributor
getLocType:function(component,event,helper){
	console.log('Printing selected distributor getLocType... '+component.get("v.selectedDistributor"));
	if(component.get("v.selectedDistributor")!="None"){
		console.log('before calling getLocType function');
		var action = component.get("c.showLocationType");
		action.setParams({
			recordid:component.get("v.recordId"),
			selectedDistributor:component.get("v.selectedDistributor") 
		});
		action.setCallback(this, function(result){
		var types = result.getReturnValue();
		console.log("Printing all the location types .. "+types);
		console.log('Printing types lengths  .. '+types.length);
		var typeValues=[];
		var sortedTypeValues=[];
		if(types.length=='1'){
			component.set("v.typeToDisplay", types);
		}else{
			typeValues.push("--Select--");
			for (var value of types){
				//console.log(value);  
				sortedTypeValues.push(value);    
			}
			//sorting typeValues
			sortedTypeValues.sort();
			typeValues.push.apply(typeValues, sortedTypeValues);
			component.set("v.typeToDisplay", typeValues);
			console.log("Printing all the location types .. "+typeValues);
		}	
		
		if(types.length=='1'){
			//fix of issue D-3025 - fix some code
			for (var value of types){
				console.log('distributer selected type ......  '+value);  
				component.set("v.selectedType",value);   
			}
			var actionShowWrkGrp = component.get('c.ShowWrkGrp');
			$A.enqueueAction(actionShowWrkGrp);
		}
	});
	$A.enqueueAction(action);
		
	
	}else{
		console.log('Selected values is none');
	}    
},

//Method to display Work group id pop up on the contact page layout

	ShowWrkGrp:function(component,event,helper){
	if(component.get("v.selectedType")!="None"){     
		console.log('work group assaign');
		//fix of issue D-3025 - remove column location type and add 3 new columns city,state and country
		component.set('v.columns', [
			{label: 'Account name', fieldName: 'Name', type: 'text'},
			{label: 'Location Code', fieldName: 'Location__c', type: 'text'},
			{label: 'City', fieldName: 'BillingCity', type: 'text'},
			{label: 'State', fieldName: 'BillingState', type: 'Picklist'},
			{label: 'Country', fieldName: 'BillingCountry', type: 'Picklist'}
		]);
		//End of column values setting
		console.log('Printing selected recordid  '+component.get("v.recordId"));
		console.log('Printing selected Distributor  '+component.get("v.selectedDistributor"));
		console.log('Printing selected type  '+component.get("v.selectedType"));
		var action = component.get('c.AccountsList');
		action.setParams({
		 recordid:component.get("v.recordId"),
		 selectedDistributor:component.get("v.selectedDistributor"),
			selectedType:component.get("v.selectedType")   
	 }); 
	// Set up the callback
	var self = this;
	action.setCallback(this, function(actionResult){
		 var sortedAccount = [];
		 sortedAccount = actionResult.getReturnValue();
		 //sorting account based on name
		 if(sortedAccount){
		 sortedAccount.sort(function(a, b){
			var x = a.Name.toLowerCase();
			var y = b.Name.toLowerCase();

			if (x < y) //sort string ascending
				return -1 
			if (x > y)
				return 1
			return 0 //default return value (no sorting)
		 });
		
		 sortedAccount.forEach(function(item,index){
			console.log(index,item); 
		 });
	   }
		 //console.log('sortedAccount ....  '+sortedAccount);
		 component.set('v.allAccounts', sortedAccount);
		 component.set('v.mydata', actionResult.getReturnValue());
	});
	$A.enqueueAction(action);
	}else{
		console.log('Selected type value is none');
	} 
},
 
  //method to update the rows selection number
  updateSelectedText: function (component, event) {
	console.log('Printg event parameter'+event.getParam('selectedRows'));       
	var selectedRows = event.getParam('selectedRows');
	if(selectedRows.length > 0){
		component.set("v.showAssignWorkGroup",true);
		component.set("v.showRemoveWorkGroup",true);
	}
	else{
		component.set("v.showAssignWorkGroup",false);
		component.set("v.showRemoveWorkGroup",false);
	}
	  
	component.set('v.selectedRowsCount', selectedRows.length);
	component.set("v.selectedRows",event.getParam('selectedRows'));
   
			 let obj =[] ; 
	for (var i = 0; i < selectedRows.length; i++){
		
		obj.push({Name:selectedRows[i].Name});
		
	}
	component.set("v.selectedRowsDetails" ,JSON.stringify(obj) );
	component.set("v.selectedRowsList" ,event.getParam('selectedRows') );
},

//Method to close the assaign work group
	closeWrkGrp:function(component,event,helper){
		console.log('Printing close');
		component.set("v.showWorkGrp","false");
		window.location.reload()
	},
	
   //Method to close the remove assaign work group
	closeRemWrkGrp:function(component,event,helper){
		console.log('Printing close remove assign work group');
		component.set("v.showRemoveWorkGrp","false");
		window.location.reload()
	},	
 
  //Method to update the application group on the user or contact          
  assignWrkGrp:function(component,event,helper){
	console.log('Printing selected Work group Id'+component.get("v.selectedRowsList"));
	console.log('Printing selected Work group Id json'+component.get("v.selectedRowsDetails"));  
	console.log('Printing selction list id'+component.get('v.selection'));        
	  var selectedAccounts=component.get("v.selectedRowsList");
	
	var action = component.get('c.assaignWrokGrpID');
	action.setParams({
		 recordId:component.get("v.recordId"),
			accnts:component.get("v.selectedRowsList")   
	 });
		   
	   action.setCallback(this, function(actionResult) {
		console.log('Printing return values'+actionResult.getReturnValue());
		console.log('setting all values'+actionResult.getState());
		   if(actionResult.getState()=="SUCCESS"){
			   if(actionResult.getReturnValue()=="Updated Successfully"){
				   component.set("v.showWorkGrp","false");
				  component.set('v.successMessage',"Succesfully updated Work Group Id");
				  var actionSuccess=component.get('c.showSuccessToast');
				  $A.enqueueAction(actionSuccess); 
			   }else{
				   //Pop up for error
				component.set('v.errorContact',actionResult.getReturnValue());
				component.set('v.errorContactFlag',"true");   
				component.set('v.showWorkGrp',"false");
				$A.get('e.c:IAM_ShowErrorMessages').fire();
			   }
		   }else{
			   //Pop up for error message
			   component.set('v.errorContact',"Something Unexpected has happened. Please contact System Administrator.");
				component.set('v.errorContactFlag',"true");   
				component.set('v.showWorkGrp',"false");
				$A.get('e.c:IAM_ShowErrorMessages').fire();
		   }
	});
	$A.enqueueAction(action);
	   
  },

 //Method to remove work group on the user or contact          
  removeWrkGrp:function(component,event,helper){
	console.log('Printing selected Work group Id'+component.get("v.selectedRowsList"));
	console.log('Printing selected Work group Id json'+component.get("v.selectedRowsDetails"));  
	console.log('Printing selction list id'+component.get('v.selection'));        
	  var selectedAccounts=component.get("v.selectedRowsList");
	
	var action = component.get('c.removeWrokGrpID');
	action.setParams({
		 recordId:component.get("v.recordId"),
			accnts:component.get("v.selectedRowsList")   
	 });
		   
	   action.setCallback(this, function(actionResult) {
		console.log('Printing return values'+actionResult.getReturnValue());
		console.log('setting all values'+actionResult.getState());
		   if(actionResult.getState()=="SUCCESS"){
			   if(actionResult.getReturnValue()=="Updated Successfully"){
				  component.set("v.showRemoveWorkGrp","false");
				  component.set('v.successMessage',"Succesfully updated Work Group Id");
				  var actionSuccess=component.get('c.showSuccessToast');
				  $A.enqueueAction(actionSuccess); 
			   }else{
				   //Pop up for error
				component.set('v.errorContact',actionResult.getReturnValue());
				component.set('v.errorContactFlag',"true");   
				component.set('v.showRemoveWorkGrp',"false");
				$A.get('e.c:IAM_ShowErrorMessages').fire();
			   }
		   }else{
			   //Pop up for error message
			   component.set('v.errorContact',"Something Unexpected has happened. Please contact System Administrator.");
				component.set('v.errorContactFlag',"true");   
				component.set('v.showRemoveWorkGrp',"false");
				$A.get('e.c:IAM_ShowErrorMessages').fire();
		   }
	});
	$A.enqueueAction(action);
	   
  },


//Send to pc on the account application object
getSendToPCApp:function(component,event,helper){
	var displayMessage;
	//Console.log('Entering the send to pc on the click of activate Provisioning Object');
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
				//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
				$A.get('e.force:refreshView').fire();
				$A.get('e.c:IAM_PageReload').fire();
				var actionSuccess=component.get('c.showSuccessToast');
					$A.enqueueAction(actionSuccess);
			
				
			}
		}else{
		console.log('error messge if return value not equal to ok');	
		component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
				component.set('v.errorAccountProvisioningFlag',"true");
				//$A.get('e.c:showErrorMessages').fire();
				var errorRefresh=component.get('c.showErrorMessages');
				$A.enqueueAction(errorRefresh);
		
		}
		
	}else{
		console.log('error messge if state of the call is not equal to ok');
			component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
				component.set('v.errorAccountProvisioningFlag',"true");
				//$A.get('e.c:showErrorMessages').fire();
				var errorRefresh=component.get('c.showErrorMessages');
				$A.enqueueAction(errorRefresh);
					   
		   }
	});
	$A.get('e.force:refreshView').fire(); 
	$A.enqueueAction(action1);
},

getSendToPCApp:function(component,event,helper){
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
		  
			if(bname=="Send To PC"){
				displayMessage="Company Information is successfully send to PC.";
				component.set('v.successMessage',displayMessage);
				//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
				$A.get('e.force:refreshView').fire();
				$A.get('e.c:IAM_PageReload').fire();
				var actionSuccess=component.get('c.showSuccessToast');
					$A.enqueueAction(actionSuccess);
				
				
			}
		}else{
			
		component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
			component.set("v.errorAccountProvisioningFlag",true);
							$A.get('e.c:IAM_ShowErrorMessages').fire();
		
		}
		
	}else{
			component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
		component.set("v.errorAccountProvisioningFlag",true);	
		$A.get('e.c:IAM_ShowErrorMessages').fire();
					
		   }
	});
	$A.get('e.force:refreshView').fire(); 
	$A.enqueueAction(action1);
},
//Method for activating Account in DA
activateAppDA:function(component,event,helper){
  
   var displayMessage;
   var action1 = component.get('c.appActivateDA');
	  
	   var bname=event.getSource().get("v.value");
   action1.setParams({ recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")}); 
	//Set up the callback
	var self = this;
	action1.setCallback(this, function(actionResult) { 
	var state = actionResult.getState();
		if(state=="SUCCESS"){
  
		if(actionResult.getReturnValue()=="Activated"){ 
		   
			
				displayMessage="Account Access Feature Activated Successfully.";
				component.set('v.successMessage',displayMessage);
				//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
				$A.get('e.force:refreshView').fire();
				$A.get('e.c:IAM_PageReload').fire();
				var actionSuccess=component.get('c.showSuccessToast');
					$A.enqueueAction(actionSuccess);
				
				
			
		}else{
			
		component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
			component.set("v.errorAccountProvisioningFlag",true);
							$A.get('e.c:IAM_ShowErrorMessages').fire();
		
		}
		
	}else{
			component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
		component.set("v.errorAccountProvisioningFlag",true);	
		$A.get('e.c:IAM_ShowErrorMessages').fire();
					
		   }
	});
	$A.get('e.force:refreshView').fire(); 
	$A.enqueueAction(action1);
},

generateCDAApp:function(component,event,helper){
   // Console.log('Printing applicatoin NAme and button');
	var displayMessage;
   var action1 = component.get('c.generateCDA');
	  
	   var bname=event.getSource().get("v.value");
   action1.setParams({ recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")}); 
	//Set up the callback
	var self = this;
	action1.setCallback(this, function(actionResult) {
		
		if(actionResult.getState()=="SUCCESS"){
			
			if(actionResult.getReturnValue()=="CDA"){
				var action2=component.get('c.appDAUpdate');
				
				action2.setParams({recordid:component.get("v.recordId"),buName:event.getSource().get("v.value")})
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
						component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
						component.set("v.errorAccountProvisioningFlag",true);
						$A.get('e.c:IAM_ShowErrorMessages').fire();
							
					}
				}                    
				});
				$A.get('e.force:refreshView').fire(); 
				$A.enqueueAction(action2);
			}else{
				component.set('v.errorAccountProvisioning', actionResult.getReturnValue());
		component.set("v.errorAccountProvisioningFlag",true);	
		$A.get('e.c:IAM_ShowErrorMessages').fire();
			}
		}
	});
	$A.get('e.force:refreshView').fire(); 
	$A.enqueueAction(action1);
},

appMapStorage:function(component,event,helper){
	var app=new Map();
	//app=component.get("v.appMap");
	app.set(event.getParam("Key"),event.getParam("newValue"));
	if($A.util.isEmpty(component.get("v.appMap"))){
		//console.log('Printing that appMap is  null');
		component.set(("v.appMap"),app);
	}else if(!$A.util.isEmpty(component.get("v.appMap"))){
		//console.log('Printng keys in the app'+[...component.get("v.appMap").keys()]);
		if([...component.get("v.appMap").keys()].includes(event.getParam("Key"))){
			//console.log('Printg be role value in old application'+component.get("v.appMap").get(event.getParam("Key")));
			//console.log('same applicaiton but new role');
			(component.get("v.appMap")).set(event.getParam("Key"),event.getParam("newValue"));
			//console.log('Printg be role value in old application'+component.get("v.appMap").get(event.getParam("Key")));
		}else if(![...component.get("v.appMap").keys()].includes(event.getParam("Key"))){
			//console.log('new application is selected');
			(component.get("v.appMap")).set(event.getParam("Key"),event.getParam("newValue"));
			 //console.log('Printg be role value to be in old application'+component.get("v.appMap").get(event.getParam("Key")));
		}
	}
	//console.log('Printng keys in the app last'+[...component.get("v.appMap").keys()]);
	
	
	var appMappings=new Map();
	var appnew={} ;
			appnew=component.get("v.appMap");
	var keyValues=[...component.get("v.appMap").keys()];
	console.log('Printng isze of the element'+component.get("v.appMap"));
	console.log('Printng isze of the element'+keyValues.length);
	for(var i=0;i<keyValues.length;i++){
		console.log(keyValues[i]+'Printnig roles'+appnew.get(keyValues[i]));
		var roles=appnew.get(keyValues[i]).toString().split(',');
		console.log('Printnting roles'+roles);
		appMappings.set(keyValues[i].toString(),roles);
	}
	component.set("v.appMaps",appMappings);
},
	
 //Controller methods for creating component on fly for Subscription
 //Amarnath Mishra updated the logic
ShowSubscription:function(component,event){
	console.log('Printing subction shows');
		 var cmpTarget = component.find('Modalbox');
	var cmpBack = component.find('MB-Back');
	$A.util.addClass(cmpTarget, 'slds-fade-in-open');
	$A.util.addClass(cmpBack, 'slds-backdrop--open');
	   var roles=[];
		//calling the controller class to get the roels values for the subscription.
		var action=component.get('c.getRoles');
		console.log('2222222');
		action.setParams({
			recordId:component.get("v.recordId"),
			role:component.get("v.selectedSubRole")
		});
		var self= this;
	   action.setCallback(this, function(actionResult) {
		   if(actionResult.getState()=="SUCCESS"){
			   //alert('Printin retunr Value'+actionResult.getReturnValue());
			   if(actionResult.getReturnValue().ApplicationName != "No value Found"){
					   //component.set("v.applicationName","Test");
					   console.log('=====Application Name 04==='+actionResult.getReturnValue().ApplicationName);
					  var appname = JSON.stringify(actionResult.getReturnValue().ApplicationName);
				   console.log('==appname=='+appname);
				   appname = appname.replace('["', '');
				   console.log('===appname02=='+appname);
				   appname = appname.replace('"]', '');
				   console.log('===appname03===='+appname);
				   
				   component.set("v.applicationName",appname);
				  
					   console.log('====Application Name 04=='+component.get("v.applicationName"));
			   }
			   if(actionResult.getReturnValue().Roles != "No value Found"){
				   console.log('====roles 02======='+actionResult.getReturnValue().Roles);
					component.set("v.RolesToDisplay",actionResult.getReturnValue().Roles);
					component.set("v.RolesToSelect","True");
					component.set("v.subscriptionAssign","True");
				}
				   if(actionResult.getReturnValue().ApplicationName == $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
					if(actionResult.getReturnValue().Customerlist != ''){
						console.log('====value of custlist===='+actionResult.getReturnValue().Customerlist);
						var customerlist = JSON.stringify(actionResult.getReturnValue().Customerlist);
						console.log('==customerlist fresh===='+customerlist);
						customerlist = customerlist.replace('["','');
						   customerlist = customerlist.replace('"]','');
						console.log('==value of customerlist02=='+customerlist);
						component.set("v.CustList","");
						component.set("v.CustList",customerlist);
						console.log('==value of custlist03==='+component.get("v.CustList"));
					}		
				}  
				if(actionResult.getReturnValue().ApplicationName == $A.get("$Label.c.IAM_AppName_Cumpas")){
					console.log('====Inside cumpas role===');
					console.log('====Modularity======='+actionResult.getReturnValue().Modularity);
					if(actionResult.getReturnValue().Modularity != ''){
						console.log('====Inside value set modularity=====');
						component.set("v.modularOptions",actionResult.getReturnValue().Modularity);
						/*
						var namesMap= {};
						var modularity=[];
						
						namesMap =actionResult.getReturnValue();
						modularity.push({label: '--Select--',value:""});
						for(var i=0;i<namesMap['Modularity'].length;i++){
				
							modularity.push({label: namesMap['Modularity'][i],value: namesMap['Modularity'][i]} );
						}
						*/
						//component.set("v.modularOptions",modularity);
						//console.log('===value of modularity=='+modularity);
					}	
				}
			   
			   /*
			   if(actionResult.getReturnValue()!="Error role not defined"&&actionResult.getReturnValue()!="Error Application Not Found"){
			   
				component.set("v.RolesToDisplay",actionResult.getReturnValue());
				  component.set("v.RolesToSelect","True");
				  component.set("v.subscriptionAssign","True");  
			   }else if(actionResult.getReturnValue()!="Error role not defined"){
				   component.set("v.errorMessageSub","Pl xease Select a Role for this application at Record level.");
				   component.set("v.errorMsgdispaly","True");
			   }else if(actionResult.getReturnValue()!="Error Application Not Found"){
				 component.set("v.errorMessageSub","Something unexpected has happened please contact System administrator.");
				   component.set("v.errorMsgdispaly","True");  
			   }
			   */
		   }
	  
	 
	}); 
	$A.enqueueAction(action);   
	},
		
		
	//Amarnath Mishra updated the logic
getSubscriptionCompnent: function(component,event) {
  
	console.log('Printing selected role'+component.get("v.selectedSubRole"));
	console.log('Printing application event');
	console.log('=== Before Role change max select contact==='+component.get("v.IsMaxContacts"));
   	component.set("v.IsMaxContacts",0);
   	console.log('===After Role change max select contact==='+component.get("v.IsMaxContacts"));
	component.set("v.errorMessageSub","Maximum 40 records are allowed to move at a time. Currently you have moved "+component.get("v.IsMaxContacts")+" records.");
	var action = component.get('c.getContacts1');
	action.setParams({
		 recordId:component.get("v.recordId")
	 }); 
	// debugger;
	// Set up the callback
	var self = this;
   
	action.setCallback(this, function(actionResult) {
	
		var contactMap={};
		var mapkeys=[];
		contactMap=actionResult.getReturnValue();
		for(var keys in contactMap){
			mapkeys.push(keys);
		}
		var availablelist=[];
		var selectedlist=[];
		//alert('Printing array includes available'+mapkeys.includes('available'));
		//alert('Printing error is present or not'+(!mapkeys.includes('error')));
		if(actionResult.getState()=="SUCCESS"){
		if(!mapkeys.includes('error')){    
		  if(mapkeys.includes('available')){
			for(var i=0;i<actionResult.getReturnValue()['available'].length;i++){
			  
				availablelist.push({value:actionResult.getReturnValue()['available'][i].Name,label:actionResult.getReturnValue()['available'][i].Name});
			}
			   //component.set("v.optionsToSelect", availablelist);   
		  }
		  
		  if(mapkeys.includes('selected')){
			for(var i=0;i<actionResult.getReturnValue()['selected'].length;i++){
			 selectedlist.push({value:actionResult.getReturnValue()['selected'][i].Name,label:actionResult.getReturnValue()['selected'][i].Name});
			}
		  // component.set("v.values", selectedlist); 
		   //component.set("v.oldValues",selectedlist);
		   
		  }
			component.set("v.dualListFlag","True");  
			//logic added for the save button visibility
			   if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
					console.log('=======Inside if condition======');
					if(component.get("v.selectedSubRole") != '--Select--' && component.get("v.CustList")){
						component.set("v.showSaveOnAssignSubscription",true);
						console.log('=======Inside if condition 02======');
					}
					else{
						console.log('===Inside else====');
						component.set("v.showSaveOnAssignSubscription",false);
					}
				}
				if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_Cumpas")){
					console.log('===selectedSubRole==='+component.get("v.selectedSubRole"));
					console.log('====selectedModular===='+component.get("v.selectedModular"));
					if(component.get("v.selectedSubRole") != '--Select--' && (component.get("v.selectedModular") != '--Select--' && component.get("v.selectedModular") != '')){
						component.set("v.showSaveOnAssignSubscription",true);   
					}
					else{
						   component.set("v.showSaveOnAssignSubscription",false); 
					}
				}
				
				if(component.get("v.applicationName") != $A.get("$Label.c.IAM_AppName_Cumpas") && component.get("v.applicationName") != $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
					if(component.get("v.selectedSubRole") != '--Select--'){
						component.set("v.showSaveOnAssignSubscription",true);     
					}
					else{
						component.set("v.showSaveOnAssignSubscription",false);
					}
				}
			}else{
				
				//error message to display that contacts are not present.
			   component.set("v.errorForContact","There are no Contacts associated to this location.");
			   component.set("v.errorForContactFlag","True");
				
			}
		
		}else{
			//add error message.
			component.set("v.errorForContact","Something Unexpected has happened, Please contact System Administrator.");
			component.set("v.errorForContactFlag","True");
		}
		//alert('before fire event changed');
		 var appEvent = $A.get("e.c:IAM_PicklistValueChange");
		appEvent.setParams({
		"record" :component.get("v.recordId"),
		"SelectedRoleValue":component.get("v.selectedSubRole"),
		"SelectedModularityValue":component.get("v.selectedModular")
		});
	appEvent.fire();
		//alert('After fire');
		
	}); 
	$A.enqueueAction(action);
	},

		
 handleChange: function (component, event) {
	 
	// This will contain an array of the "value" attribute of the selected options
	var selectedOptionValue = event.getParam("value");
	alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
},

 closeSubscription:function(component,event){
 // alert('Printing close');
 component.set("v.subscriptionAssign","false");
 window.location.reload()
 },   
closeConfirmModel:function(component,event){
	component.set("v.IsConfirmModel","false"); 
	component.set("v.subscriptionAssign","true"); 
},
openConfirmModel:function(component,event){
	console.log('OPEN CONFIRM');
	component.set("v.IsConfirmModel","true");
	component.set("v.subscriptionAssign","false"); 
	//console.log('22222222'+component.get(v.IsConfirmModel));
},
	
 //Pratima updated the logic
saveAssignSubscription:function(component,event){
	//alert('Printing entered Save');
	//alert('Printing final selected Role'+component.get("v.selectedSubRole"));
   console.log('====Inside save subcription=====');
   //alert('Printing final options2323'+component.get("v.CustList"));
   var modularity = JSON.stringify(component.get("v.selectedModular"));
   modularity = modularity.replace('["','');
   modularity = modularity.replace('"]','');
   console.log('===value of final modularity==='+modularity);
   console.log('===value of modularity===='+JSON.stringify(component.get("v.selectedModular")));
   //alert('Printing final options'+component.get("v.selectedModular"));
	//console.log('=====APP NAME==='+component.get("v.applicationName"));
   // var action=component.get('c.saveAssignedSubscription');
   var temp;
	//$A.get("$Label.c.IAM_AppName_ConnectedSolutions")
	//$Label.c.IAM_AppName_ConnectedSolutions
	//$Label.c.IAM_AppName_Cumpas
	if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_ConnectedSolutions"))
	{
		temp=component.get("v.CustList");
		console.log('==Insdie connected solution===');
	}
	if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_Cumpas"))
	{	console.log('==Inside cumpas===');
		temp=modularity;
	}
	var action=component.get('c.saveAssignedSubscription');
			action.setParams({
				selectedContacts:component.get("v.SelectedContacts").toString(),                
				role:component.get("v.selectedSubRole"),
				recordId:component.get("v.recordId"),
				   depField:temp
	 });
	
			var self= this;
		   action.setCallback(this, function(actionResult) {
			   if(actionResult.getState()=="SUCCESS"){
				   console.log('===actionResult.getState()===='+actionResult.getState());
				   var message = actionResult.getReturnValue();
				   if(message != 'Record Updated')
				   {	console.log('===Inside record not updated==');
					   //alert(actionResult.getReturnValue());  
						component.set("v.subscriptionAssign",false);
						   component.set("v.IsConfirmModel",false); 
						   component.set('v.errorContact', actionResult.getReturnValue());
						component.set('v.errorContactFlag',true);
						$A.get('e.c:IAM_ShowErrorMessages').fire();
				   }
				   else
				   {   console.log("====Inside success message====");
					   component.set("v.subscriptionAssign","false");
					   component.set("v.RolesToDisplay",actionResult.getReturnValue());
						component.set("v.RolesToSelect","False");
					   component.set("v.selectedSubRole","None");
					   component.set("v.IsConfirmModel","false");
				
			   component.set('v.successMessage','Role Updated Successfully.');
			   var actionSuccess=component.get('c.showSuccessToast');
			   $A.enqueueAction(actionSuccess);
			   $A.get('e.force:refreshView').fire();
			   $A.get('e.c:IAM_PageReload').fire();
				   }
				   
										 
			   }
			   else
			   {
				   
					component.set("v.subscriptionAssign","true");
				   component.set("v.IsConfirmModel","false"); 
			   }
		  
		 
		}); 
		$A.enqueueAction(action);
	
},   

 setSelectedContacts: function (component, event) {
	 
	// This will contain an array of the "value" attribute of the selected options
	var selectedOptionValue = event.getParam("SelectedContacts");
	var IsMaxContacts = event.getParam("IsMaxContacts");
	component.set("v.SelectedContacts",selectedOptionValue); 
	component.set("v.IsMaxContacts",IsMaxContacts);
	console.log('## MaxContacts ##'+component.get("v.IsMaxContacts"));
	component.set("v.errorMessageSub","Maximum 40 records are allowed to move at a time. Currently you have moved 0 records.");
    if(component.get("v.IsMaxContacts")>=0){
		console.log('Inside Max Allowed Users');
		component.set("v.errorMessageSub","Maximum 40 records are allowed to move at a time. Currently you have moved "+component.get("v.IsMaxContacts")+" records.");
		console.log('Error to display: '+component.get("v.errorMessageSub"));
    }
    if(component.get("v.IsMaxContacts")==40){
		console.log('Inside Max Allowed Users');
		component.set("v.errorMessageSub","Maximum 40 records are allowed to move at a time. Currently you have moved "+component.get("v.IsMaxContacts")+" records. If you need to move more than 40 users at a time then hit save button and repeat the process.");
		console.log('Error to display: '+component.get("v.errorMessageSub"));
    }
	if(component.get("v.IsMaxContacts")>40){
		console.log('Inside Max Allowed Users');
		component.set("v.errorMessageSub","Maximum limit is 40 records at a time. You are performing operation on "+component.get("v.IsMaxContacts")+" records. Kindly move extra records from bottom of right hand 'Selected' list back to left hand side 'Available' list.");
		console.log('Error to display: '+component.get("v.errorMessageSub"));
    }
},
//End code addition for Subscription addition
//Code to show and off loading spinner added by Amar
showSpinner: function(component, event, helper) {
   // make Spinner attribute true for display loading spinner 
	component.set("v.Spinner", true); 
   },

 // this function automatic call by aura:doneWaiting event 
hideSpinner : function(component,event,helper){
 // make Spinner attribute to false for hide loading spinner    
   component.set("v.Spinner", false);
},
doOpentheRecord : function(component,event,helper){
	console.log('==link clicked===');
	var navEvt = $A.get("e.force:navigateToSObject");
	navEvt.setParams({
		 "recordId": component.get("v.conPorRecordId"),
		  "slideDevName": "Available Provisioning Record"
	});
	navEvt.fire();
},
	
evaluateShowSaveButton : function(component,event,helper){
	console.log('==show save button evaluation===');
	console.log('=======component.get("v.selectedSubRole")========='+component.get("v.selectedSubRole"));
	console.log('====component.get("v.CustList")====='+component.get("v.CustList"));
	
	if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
		console.log('=======Inside if condition======');
		if(component.get("v.selectedSubRole") != '--Select--' && component.get("v.CustList")){
			component.set("v.showSaveOnAssignSubscription",true);
			console.log('=======Inside if condition 02======');
		}
		else{
			console.log('===Inside else====');
			component.set("v.showSaveOnAssignSubscription",false);
		}
	}
	if(component.get("v.applicationName") == $A.get("$Label.c.IAM_AppName_Cumpas")){
		if(component.get("v.selectedSubRole") != '--Select--' && component.get("v.selectedModular") != ''){
			 component.set("v.showSaveOnAssignSubscription",true);   
		}
		else{
		   component.set("v.showSaveOnAssignSubscription",false); 
		}
	}
	
	if(component.get("v.applicationName") != $A.get("$Label.c.IAM_AppName_Cumpas") && component.get("v.applicationName") != $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
		if(component.get("v.selectedSubRole") != '--Select--'){
			component.set("v.showSaveOnAssignSubscription",true);     
		}
		else{
			component.set("v.showSaveOnAssignSubscription",false);
		}
	}
	
},
evaluateShowSaveButtonCumpas :  function(component,event,helper){
		if(component.get("v.selectedSubRole") != '--Select--' && component.get("v.selectedModular") != '' && component.get("v.selectedModular") != '--Select--'){
			 component.set("v.showSaveOnAssignSubscription",true);   
		}
		else{
		   component.set("v.showSaveOnAssignSubscription",false); 
		}
   console.log('===Modularity in showsavebutton==='+component.get("v.selectedModular")); 
   console.log('=== Before Modularity change max select contact==='+component.get("v.IsMaxContacts"));
   component.set("v.IsMaxContacts",0);
   console.log('===After Modularity change max select contact==='+component.get("v.IsMaxContacts"));
   component.set("v.errorMessageSub","Maximum 40 records are allowed to move at a time. Currently you have moved "+component.get("v.IsMaxContacts")+" records.");
   var appEvent = $A.get("e.c:IAM_PicklistValueChange");
		appEvent.setParams({
		"record" :component.get("v.recordId"),
		"SelectedRoleValue":component.get("v.selectedSubRole"),
		"SelectedModularityValue":component.get("v.selectedModular")    
		});
		appEvent.fire();
},
	//Below method is for - D-3197
	selectoptionvalueRoles:function(component,event,helper){
	var checkbox = component.find("cumpasr");
	var checkbox2 = component.find("cumpasm");
	if(checkbox.get("v.value")!='' && checkbox2.get("v.value")!='')
	{
		  component.set("v.ShowSaveButton",1);
	}
	if(checkbox.get("v.value")=='' || checkbox2.get("v.value")=='')
	component.set("v.ShowSaveButton",0);
	
	console.log("#####=="+component.get("v.ShowSaveButton"));
}
	
})