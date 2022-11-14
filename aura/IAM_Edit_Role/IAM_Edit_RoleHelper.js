({
    findRolenModularity : function(component,event){
        	var appName = [];
			var allRoles = [];
			var allModularity = [];
			var selectedRoles = [];
			var selectedModularity = [];
        	console.log('===Application Name02===='+component.get('v.applicationName'));
			var action02=component.get('c.GetRolenModularityNames')
			action02.setParams({
			recordid:component.get("v.contactProvisioningId"),
			type:component.get('v.applicationName')
			});

        action02.setCallback(this, function(actionResult) {
				var allValues =[];
				var result = actionResult.getReturnValue();
				alert(JSON.stringify(actionResult.getReturnValue()));
				//allValues = actionResult.getReturnValue().split('+');
				allValues = actionResult.getReturnValue();
				console.log('===allValues==='+allValues);
				allRoles = allValues[0];
				if(allValues.length > 1)
				allModularity = allValues[0];
				console.log('===allValues='+allValues);
				console.log('===allRoles===='+allRoles);
				console.log('===allModularity=='+allModularity);
				component.set('v.myMap',actionResult.getReturnValue());
				console.log('=====result======='+JSON.stringify(component.get('v.myMap.Roles')));
				
			});
			
			$A.enqueueAction(action02);
    },
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
    
    showSuccessMessage: function(component){
       console.log('=======Is from VF true======01');
		component.set('v.successMessage',"Role(s) updated Successfully");
		console.log('=======Is from VF true======02'); 
		component.set('v.showEditRole',"false");
		component.set('v.displaySuccessOnVF',"true");
        console.log('=======Is from VF true======04');
    },
    
    showErrorMessage: function(component){
        
		component.set('v.showEditRole',"false");
		component.set('v.displayErrorOnVF',"true");
    }
})