({
	doInit : function(component, event, helper) {
	if(component.get("v.IsFromVFPage") == 'true'){
		//showOnVFPage
		component.set("v.showOnVFPage" ,'true');
	}
	//helper.diplaySelected(component,event,helper);	
	},
    hideApp : function(component, event, helper) {
		//window.location.reload()
		//$A.get('e.force:refreshView').fire();
		//component.destroy();
		//helper.diplaySelected(component,event,helper);
		//helper.diplaySelected(component,event,helper);	
		//$A.get("e.force:closeQuickAction").fire()
		window.location.reload();
	},
    doInt: function(component, event, helper) {      
		// Fetch the account list from the Apex controller   
		/*helper.getsObjName(component);
		helper.getsObjList(component);
		helper.getsetpassword(component);
		helper.getUnlock(component); 
		helper.getProfile(component);
		*/
	},
	
	selectoptionvalueRoles:function(component,event,helper){
		
		var checkCmp = component.find("checkboxRoles");
		var checkbox = event.getSource();
		console.log(checkbox.get("v.value"));
		console.log(checkbox.get("v.label"))
		
		var updatedRoles = [];
		var currentRoles = [];
		updatedRoles = component.get("v.valueRoles");
		for(var i=0;i<updatedRoles.length;i++){
			if(updatedRoles[i].label == checkbox.get("v.label")){
				currentRoles.push({label:updatedRoles[i].label,value:checkbox.get("v.value")});
			}
			else{
				currentRoles.push({label:updatedRoles[i].label,value:updatedRoles[i].value});
			}
		}
		var JSONStr = JSON.stringify(currentRoles); 
		console.log('======JSONStr======'+JSONStr);
		console.log('==current roles====='+currentRoles);
		component.set("v.valueRoles" , currentRoles);
		console.log('============='+component.get("v.valueRoles"));
		component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")+1);
		console.log('=========valuetest==='+component.get("v.valuetest"));
		//label
        //var resultCmp = component.find("checkResult");
        //resultCmp.set("v.value", ""+checkCmp.get("v.value"));
		//console.log('===Real value====='+checkCmp.get("v.value"));
		 
	},
	
	selectoptionvalueModularity:function(component,event,helper){
		
		var checkCmp = component.find("checkboxRoles");
		var checkbox = event.getSource();
		console.log(checkbox.get("v.value"));
		console.log(checkbox.get("v.label"))
		
		var updatedModularity = [];
		var currentModularity = [];
		updatedModularity = component.get("v.value");
		for(var i=0;i<updatedModularity.length;i++){
			if(updatedModularity[i].label == checkbox.get("v.label")){
				currentModularity.push({label:updatedModularity[i].label,value:checkbox.get("v.value")});
			}
			else{
				currentModularity.push({label:updatedModularity[i].label,value:updatedModularity[i].value});
			}
		}
		var JSONStr = JSON.stringify(currentModularity); 
		console.log('======JSONStr======'+JSONStr);
		console.log('==current roles====='+currentModularity);
		component.set("v.value" , currentModularity);
		console.log('============='+component.get("v.value"));
		component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")+1);
		console.log('========valueModularity====='+component.get("v.valueModularity"));
		//label
        //var resultCmp = component.find("checkResult");
        //resultCmp.set("v.value", ""+checkCmp.get("v.value"));
		//console.log('===Real value====='+checkCmp.get("v.value"));
		 
	},
	
	handleChange:function(component,event,helper){
		// var selectedOptionValue = event.getParam("value");
        //alert("Option selected with value: '" + selectedOptionValue + "'");
        var selectedOptionValue = event.getParam("value");
        //alert("Option selected with value: '" + selectedOptionValue + "'");
		console.log('=====insdie handlechange==');
		//selectedOptionValue
		component.set('v.roleForConnectedSolution',selectedOptionValue);
		component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")+1);
		//ShowSaveButton
		
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
            message:component.get("v.errorContact"),
            messageTemplate: 'Mode is pester ,duration is 5sec and Message is overrriden',
            duration:' 4000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    diplaySelected:function(component,event,helper){
			//helper.getsObjName(component);
			console.log('=====v.ObjectName====='+component.get("v.ObjectName"));
			console.log('=======value of data======='+component.get("v.contactProvisioningId"));
			console.log('===Record id in display===='+component.get("v.recordid"));
			component.set("v.ShowSaveButton",component.get("v.ShowSaveButton")+0);
			var appName = [];
			var allRoles = [];
			
			var application = [];
			var allModularity = [];
			var allModularitystr;
			var existingModularitystr;
			var selectedrolesstr;
			var allrolesstr;
			var selectedRoles = [];
			var existingModularity = [];
			if(component.get("v.selectedValue")!="None"){
			var action=component.get('c.getApplicationNRoleNames')
			action.setParams({
			recordid:component.get("v.contactProvisioningId")      
			});
			 var self = this;
			action.setCallback(this, function(actionResult) {
				
		   // Code commented need to be used as an enhancement for the current application 
			 //Create an empty array to store the map keys 
					var arrayMapKeys = [];
					var arrayMapKeysRoles = [];
                	
					//Store the response of apex controller (return map)   
					  
					var result = actionResult.getReturnValue();
					
					application= actionResult.getReturnValue().Application;
                	//application = JSON.stringify(application);
                	application = application.toString();
					component.set('v.applicationName',application);
					component.set('v.appName',application);
                	console.log('===Selected Application====='+application);
					if(application == $A.get("$Label.c.IAM_AppName_Cumpas")){
						component.set('v.isCUMPAS',true);
					}
					
					if(application == $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
						component.set('v.isConnected',true);
                        console.log('===UserType==='+actionResult.getReturnValue().UserType);
                        component.set('v.usertype',actionResult.getReturnValue().UserType);
						var JSONStr = JSON.stringify(actionResult.getReturnValue().Customerlist);
                        var newStr = JSONStr.replace('["', '');
                        newStr = newStr.replace('"]', '');
                        component.set("v.customerlist",newStr);
						
					}
					console.log('==Application name latest===='+component.get("v.applicationName"));
					selectedRoles = actionResult.getReturnValue().ExistingRoles;
					
					
					allRoles = actionResult.getReturnValue().AllRoles;
					console.log('===allRoles First value======'+allRoles);
					
					if(application == $A.get("$Label.c.IAM_AppName_Cumpas" )){
						existingModularity = actionResult.getReturnValue().ExistingModularity;
						allModularity	= actionResult.getReturnValue().AllModularity;
						allModularitystr = allModularity.toString();
						allModularity = allModularitystr.split(';');
						existingModularitystr = existingModularity.toString();
						existingModularity = existingModularitystr.split(';');
							
							//for Modularity 
						for(var i=0;i<allModularity.length;i++){
							//alert(Result[i]);
							flag = false;
							for(var j=0;j<existingModularity.length;j++){
								if(allModularity[i] == existingModularity[j]){
									flag = true;
									break;
								}
							}
							if(flag == true){
								arrayMapKeys.push({label:allModularity[i],value: true} );
							}
							else{
								arrayMapKeys.push({label:allModularity[i],value: false} );
							}
							
						}
						var allvalueModule = [];
						var selectedvalueModule =[];
						for(var l=0;l<allModularity.length;l++){
							allvalueModule.push({label:allModularity[l],value: allModularity[l]});
						}
						for(var k=0;k<arrayMapKeys.length;k++){
							
							if(arrayMapKeys[k].value == true){
								selectedvalueModule.push(arrayMapKeys[k].label);
							}
							
						}
						console.log('====allvalueModule===='+allvalueModule);
						console.log('====selectedvalueModule===='+selectedvalueModule);
						component.set("v.optionsModularity" , allvalueModule);
						component.set("v.valueModularity" , selectedvalueModule);
					}
					
					
					selectedrolesstr = selectedRoles.toString();
					selectedRoles = selectedrolesstr.split(';');
					
					
					allrolesstr = allRoles.toString();
					//var temp = allrolesstr.replace(',', ';');
					console.log('====All role in string format===='+allrolesstr);
					
					console.log('====after replace====='+temp);
					allRoles = allrolesstr.split(';');
					
					var temp = allRoles.toString();
					allRoles = temp.split(',');
					
					if(application == $A.get("$Label.c.IAM_AppName_ConnectedSolutions" )){
						var allPCRoles = [];
                        var roleSiteAdmin = [];
						for(var k=0;k<allRoles.length;k++){
							allPCRoles.push({label:allRoles[k],value: allRoles[k]});
						}
                        if(component.get("v.IsFromVFPage") == "true"){
							roleSiteAdmin.push({label:"AccountManager",value:"AccountManager"});
							roleSiteAdmin.push({label:"Operator",value:"Operator"});
                            roleSiteAdmin.push({label:"ServiceTechnician",value:"ServiceTechnician"});
							roleSiteAdmin.push({label:"Subscriber",value:"Subscriber"});
							component.set("v.options",roleSiteAdmin);
						}
                        else{
                            component.set("v.options",allPCRoles);
						}
						//component.set("v.options",allPCRoles);
					}
					
					
					console.log('===allRoles latest 02 wala======'+allRoles);
					console.log('====allModularitystr======='+allModularitystr);
					console.log('====application==='+application);
					console.log('====ExistingRoles======='+selectedRoles);
					console.log('====existingModularity==='+existingModularity);
					console.log('====allModularity==='+allModularitystr);
					console.log('====allRoles==='+allRoles);
					
					var flag = false;
					//Set the store response[map] to component attribute, which name is map and type is map. 
					// for Roles
					for(var i=0;i<allRoles.length;i++){
						//alert(Result[i]);
						flag = false;
						console.log('===allRoles==='+allRoles[0]);
						console.log('===selectedRoles========'+selectedRoles[0]);
							/*var str = allRoles[i];
							str = str.trim();

							str = str.replaceAll('(\\s+)', ' ');
							*/
						var	str = allRoles[i];
							str = str.replace(/  +/g, ' ');
							console.log('====final value of string======='+str);
							
						for(var j=0;j<selectedRoles.length;j++){
							
							if(str == selectedRoles[j]){
								console.log('===Inside matching roles[i]==='+allRoles[i]+'==selectedRoles[j]==='+selectedRoles[j]);
								flag = true;
								break;
							}
						}
						if(flag == true){
							console.log('====Inside flag true===');
							arrayMapKeysRoles.push({label:allRoles[i],value: true} );
						}
						else{
							console.log('====Inside flag flase===');
							arrayMapKeysRoles.push({label:allRoles[i],value: false} );
						}
						
					}
					var allvaluetest = [];
					for(var i=0;i<allRoles.length;i++){
						console.log('====Inside all  value test=========');
						allvaluetest.push({label:allRoles[i],value: allRoles[i]});
					}
					//valueRoles
					var selectedRolesValue =[];
					for(var k=0;k<arrayMapKeysRoles.length;k++){
						console.log('======Inside selected roletest loop==========');
						if(arrayMapKeysRoles[k].value== true){
							console.log('=====Inside selected rolestest if condition=====');
							selectedRolesValue.push(arrayMapKeysRoles[k].label);
						}
						
					}
					
					component.set("v.valuetest" , selectedRolesValue);
					component.set("v.optionstest",allvaluetest);
					console.log('====selectedrolesstr====='+selectedrolesstr);
					if(application == $A.get("$Label.c.IAM_AppName_ConnectedSolutions" )){
						console.log('=====Inside connected solution=====');
						console.log('====selectedrolesstr==='+selectedrolesstr);
						component.set("v.PCRole",selectedrolesstr);	
					}
					console.log('=========='+component.get("v.PCRole"));
					console.log('===arrayMapKeys===='+arrayMapKeys);
					component.set("v.value" , arrayMapKeys);
					//component.set('v.companyMap', result);
					component.set('v.companyMap', arrayMapKeys);
					var arraykeylist = [];
					for (var key in arrayMapKeys) {
						arraykeylist.push(key);
                        appName.push(result[key]);
                        
					}
					
					
					//Set the list of keys.   
					  
					component.set('v.keyList', arraykeylist);
				
				var optsApp=[];
                
				optsApp.push({value: "None", label: "None",Selected:true });
				for(var i=0;i<actionResult.getReturnValue().length;i++){
				
					optsApp.push({label: actionResult.getReturnValue()[i],value: actionResult.getReturnValue()[i]} );
					//appName.push(actionResult.getReturnValue()[i]);
                console.log('value of array'+actionResult.getReturnValue()[i]);
				}
			
				component.set('v.appOptionsSub', optsApp);
				console.log('====optsApp===='+component.get("v.keyList"));
				console.log('====Application===='+arrayMapKeys[1]);
				console.log('=====AppName real=========='+appName[0]);
                //component.set('v.appName',appName[0]);
				console.log('====App n Roles===='+component.get("v.appOptionsSub"));
				console.log('====appName==============='+component.get("v.companyMap"));
				component.set('v.selectedAppSub',"None");
				//component.set('v.appName',appName[0]);
				console.log('====Application name==='+component.get("v.appName"));
		});
			$A.enqueueAction(action);
			} 
			
			//var self = this;
			//helper.findRolenModularity(component);
			
	},
	saveApp : function(component,event,helper){
		
		
		var applicationName = component.get("v.appName");
		var roles = [];
		var rolestosend = '';
		var moudularity = [];
		var modularitytosend = '';
		//roles = component.get("v.valueRoles");
		//moudularity = component.get("v.value");
		
		roles = component.get("v.valuetest");
		moudularity = component.get("v.valueModularity");
		
		for(var i=0;i<roles.length;i++){
				
					if(rolestosend == ''){
						rolestosend = roles[i];
						console.log('=inside if role===');
					}
					else{
						rolestosend = rolestosend +';'+ roles[i];
						console.log('=inside else role===');
					}
				
		}
		
		for(var i=0;i<moudularity.length;i++){
				
					if(modularitytosend == ''){
						modularitytosend = moudularity[i];
						console.log('=inside if Moudularity===');
					}
					else{
						modularitytosend = modularitytosend +';'+ moudularity[i];
						console.log('=inside else modularity===');
					}
				
		}
		
		console.log('=======final value of roles======='+rolestosend);
		console.log('=======final moudularity========='+modularitytosend);
		//For CUMPAS2.0 application 
		if(applicationName == $A.get("$Label.c.IAM_AppName_Cumpas")){
			var rolescheckbox = component.find("CheckboxGroupRoles");
			var roleValue = rolescheckbox.get("v.value");
			var modularitycheckbox = component.find("CheckboxGroupModule");
			var moduleValue = modularitycheckbox.get("v.value");
			console.log('=======value role========'+roleValue);
			console.log('=======value module======'+moduleValue);
			
			if(roleValue.length != 0 && moduleValue.length != 0 ){
				
				console.log('===Inside if of cumpas value check====');
				//updateAppCumpas
				//Id recordid,list<String> rolesNames,list<string> moudularity
				console.log('===component.get("v.valueRoles")==='+component.get("v.valueRoles").label);
				console.log('====component.get("v.value")==='+component.get("v.value").label);
				var action2=component.get('c.updateAppCumpas')
				action2.setParams({
					recordid:component.get("v.contactProvisioningId"), 
					rolesNames:rolestosend,
					moudularity:modularitytosend,
				});
				action2.setCallback(this, function(actionResult) {
					console.log('====actionResult.getReturnValue()====='+actionResult.getReturnValue());
					if(actionResult.getState()=="SUCCESS"){
						if(actionResult.getReturnValue()=="Record Updated"){
							
							if(component.get("v.IsFromVFPage")== "true"){
								helper.showSuccessMessage(component);
							}
							else{
								//then display Success Toast
								$A.get('e.force:refreshView').fire();
								$A.get('e.c:IAM_PageReload').fire();
								component.set('v.successMessage',"Role(s) updated Successfully");
								//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
								
							var actionSuccess=component.get('c.showSuccessToast');
							$A.enqueueAction(actionSuccess);
								
							}
							
						}else{
							if(component.get("v.IsFromVFPage")== "true"){
								component.set('v.errorMessage','Something went wrong please contact System administrator.');
								helper.showErrorMessage(component);
							}
							else{
								// Display Error message Toast
								component.set('v.errorContact', 'Something went wrong please contact System administrator.');
								component.set('v.errorContactFlag',"true");
								$A.get('e.c:IAM_ShowErrorMessages').fire();
								
							}
							
						}
					}else{
						if(component.get("v.IsFromVFPage")== "true"){
							component.set('v.errorMessage','Something went wrong please contact System administrator.');
							helper.showErrorMessage(component);
						}
						else{
							//define why call goy failed. and check result 1 value and display message accordingly
							component.set('v.errorContact', 'Something went wrong please contact System administrator.');
							component.set('v.errorContactFlag',"true");
							$A.get('e.c:IAM_ShowErrorMessages').fire();
							
						}
						
					}    
				});
				$A.enqueueAction(action2);
			}
		}
		
		//For Connected Solution application
		if(applicationName == $A.get("$Label.c.IAM_AppName_ConnectedSolutions")){
			//updateRoles
						
			console.log('===Inside connected solution=====');
			console.log('===component.get("v.valueRoles")==='+component.get("v.valueRoles").label);
			console.log('====component.get("v.value")==='+component.get("v.value").label);
        if(component.get("v.customerlist")!= ''){    
			var action2=component.get('c.updateRolesConnectedSolution')
			action2.setParams({
				recordid:component.get("v.contactProvisioningId"), 
				rolesNames:component.get("v.PCRole"),
				customerlist:component.get("v.customerlist")
			});
			action2.setCallback(this, function(actionResult) {
				console.log('====actionResult.getReturnValue()====='+actionResult.getReturnValue());
				if(actionResult.getState()=="SUCCESS"){
					console.log('====Inside if SICCESS=01');
					if(actionResult.getReturnValue()=="Record Updated"){
						console.log('===Inside if Record updated===02');
						if(component.get("v.IsFromVFPage")== "true"){
							console.log('===Inside IsFromVFpage=03');
							helper.showSuccessMessage(component);
						}
						else{
							console.log('===Inside else FromVF==04');
							//then display Success Toast
							 $A.get('e.force:refreshView').fire();
							 $A.get('e.c:IAM_PageReload').fire();
							component.set('v.successMessage',"Role(s) updated Successfully");
							//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
							
							var actionSuccess=component.get('c.showSuccessToast');
							$A.enqueueAction(actionSuccess);
						}
					}else{
						if(component.get("v.IsFromVFPage")== "true"){
							console.log('===Inside Error if IsFromVFPag===05');
							component.set('v.errorMessage','Something went wrong please contact System administrator.');
							helper.showErrorMessage(component);
						}
						else{
							// Display Error message Toast
							console.log('====Inside error else===06');
							component.set('v.errorContact', 'Something went wrong please contact System administrator.');
							component.set('v.errorContactFlag',"true");
							$A.get('e.c:IAM_ShowErrorMessages').fire();
							
						}
						
					}
				}else{
					if(component.get("v.IsFromVFPage")== "true"){
						console.log('====Inside IsFromVFPage true something wrong===07');
						component.set('v.errorMessage','Something went wrong please contact System administrator.');
						helper.showErrorMessage(component);
					}
					else{
						//define why call goy failed. and check result 1 value and display message accordingly
						console.log('=====inside connnected solution something went wrong======08');
						component.set('v.errorContact', 'Something went wrong please contact System administrator.');
						component.set('v.errorContactFlag',"true");
						$A.get('e.c:IAM_ShowErrorMessages').fire();
						
					}
					
				}    
			});
			$A.enqueueAction(action2);
        }
		}
		
		if( applicationName != $A.get("$Label.c.IAM_AppName_ConnectedSolutions") && applicationName != $A.get("$Label.c.IAM_AppName_Cumpas")){
			
			
			console.log('====rolestosend==='+rolestosend);
			var rolescheckbox = component.find("CheckboxGroupRoles");
			var roleValue = rolescheckbox.get("v.value");
			console.log('==roleValue==='+roleValue);
						
			if(roleValue.length != 0){
				
			
				console.log('===Inside if=component.get("v.valueRoles")==='+component.get("v.valueRoles").label);
				console.log('===Inside if=component.get("v.value")==='+component.get("v.value").label);
				var action2=component.get('c.updateRoles')
				action2.setParams({
					recordid:component.get("v.contactProvisioningId"), 
					rolesNames:rolestosend
				});
				action2.setCallback(this, function(actionResult) {
					console.log('====actionResult.getReturnValue()====='+actionResult.getReturnValue());
					console.log('=====In side success block========');
					console.log('=====Inside success value of IsFromVFPage======'+component.get("v.IsFromVFPage"));
					if(actionResult.getState()=="SUCCESS"){
						if(actionResult.getReturnValue()=="Record Updated"){
							console.log('=====In side record updation========');
							if(component.get("v.IsFromVFPage")== "true"){
								
								helper.showSuccessMessage(component);
								
							}
							else{
								console.log('===Inside else of IsfromVF======');
								//then display Success Toast
								 $A.get('e.force:refreshView').fire();
								 $A.get('e.c:IAM_PageReload').fire();
								component.set('v.successMessage',"Role(s) updated Successfully");
								//$A.get('e.c:IAM_ShowSuccess_Toast').fire();
								
								var actionSuccess=component.get('c.showSuccessToast');
								$A.enqueueAction(actionSuccess);
							
							}
							
						}else{
							if(component.get("v.IsFromVFPage")== "true"){
								component.set('v.errorMessage','Something went wrong please contact System administrator.');
								helper.showErrorMessage(component);
								
							}
							else{
								console.log('===Inside else of Record created===');
								// Display Error message Toast
								//component.set('v.showEditRole',"false");
								component.set('v.errorContact', 'Something went wrong please contact System administrator.');
								component.set('v.errorContactFlag',"true");
								$A.get('e.c:IAM_ShowErrorMessages').fire();
							}
						}
					}else{
						if(component.get("v.IsFromVFPage")== "true"){
							component.set('v.errorMessage','Something went wrong please contact System administrator.');
							helper.showErrorMessage(component);
						}
						else{
							console.log('====inside else of "SUCCESS"====');
							//define why call goy failed. and check result 1 value and display message accordingly
						
							component.set('v.errorContact', 'Something went wrong please contact System administrator.');
							component.set('v.errorContactFlag',"true");
							$A.get('e.c:IAM_ShowErrorMessages').fire();
							
						}
						console.log('====inside else of "SUCCESS"====');
						//define why call goy failed. and check result 1 value and display message accordingly
						
						component.set('v.errorContact', 'Something went wrong please contact System administrator.');
							component.set('v.errorContactFlag',"true");
							$A.get('e.c:IAM_ShowErrorMessages').fire();
					}    
				});
				$A.enqueueAction(action2);
			
			}
			
			
			
		}
		
		
	},
	showErrorMessages : function(Component,event,helper) {
		
			$A.get('e.c:IAM_ShowError_Toast').fire();
			console.log('======Inside showError message=======');
			$A.get('e.force:refreshView').fire();
			$A.get('e.c:IAM_PageReload').fire();
			
	},
    
    handleError : function(component,event,helper){
        console.log('=====Inside handle error section======');
    }
})