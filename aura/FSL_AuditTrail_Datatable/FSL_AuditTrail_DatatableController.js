({
    doInit : function(component, event, helper) {
        var actions = [
            { label: 'Show details', name: 'show_details' }
            
        ];
        var userName = $A.get("$Label.c.FSL_AuditUserName");
        var symptom = $A.get("$Label.c.FSLAuditSymptom");
        var dateTime = $A.get("$Label.c.FSL_AuditDate_Time");
        var rank = $A.get("$Label.c.FSL_Audit_DataTable_Rank");
        var description = $A.get("$Label.c.FSL_Audit_Description");
        var solution = $A.get("$Label.c.FSL_Audit_Solution");
        component.set('v.columns', [
            { label: userName, fieldName: 'UserName', type: 'text',sortable: true },
            { label: dateTime, fieldName: 'CreatedDate', type: 'date',sortable: true,
            	typeAttributes: {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric',
                    hour: '2-digit',
                    minute: '2-digit'
                }
            },
            { label: symptom, fieldName: 'Symptom__c', type: 'text',sortable: true },
            { label: rank, fieldName: 'Rank__c', type: 'text',sortable: true },
           // { label: 'Event', fieldName: 'Event__c', type: 'text',sortable: true },
            { label: description, fieldName: 'FSL_Description__c', type: 'text',sortable: true },
            {label: solution, fieldName: 'Icon__c',type:'text' }
            // Icon__c { label: 'Service Order', fieldName: 'ServiceOrder', type: 'text',sortable: true },
          //  { label: 'Show diagnostic trail', fieldName: 'FSL_Diagnostic_Audit__c', type: 'text',sortable: true },
            //{ type: 'action', typeAttributes: { rowActions: actions } } 
        ]);
            helper.getData(component,event);
    },
    //Method gets called by onsort action,
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    }  
})