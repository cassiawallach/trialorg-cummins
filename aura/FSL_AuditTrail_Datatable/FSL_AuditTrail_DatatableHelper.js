({
	getData : function(component,helper) {
		var action = component.get("c.getAuditTrailData");
        action.setParams({
            strServiceOrderId : component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var rows = response.getReturnValue();
                for (var i = 0; i < rows.length; i++) {
                var row = rows[i];
					//if (row.Service_Order__r.WorkOrderNumber) {
                    row.ServiceOrder = row.Service_Order__r.WorkOrderNumber;
                   // alert(row.CreatedBy.Name)
                 	row.UserName = row.CreatedBy.Name;
                 //  alert(row.UserName);
				//}
           }
                component.set('v.data', rows);
            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
         
        $A.enqueueAction(action);
	},
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.data");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        // to handel number/currency type fields 
        if(fieldName == 'NumberOfEmployees'){ 
            data.sort(function(a,b){
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a>b) - (b>a));
            }); 
        }
        else{// to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        }
        //set sorted data to accountData attribute
        component.set("v.data",data);
    }
})