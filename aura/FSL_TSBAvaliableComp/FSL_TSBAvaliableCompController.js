({
    onInit : function(component,event,helper){
        //Setting up colum information
        component.set("v.tsbColums",
                      [
                          /* {
                              label : 'Doc Title',
                              fieldName: 'linkName',
                              type : 'url',
                              typeAttributes:{label:{fieldName:'Doc_Title__c'}, name: 'view_details' , target:'_blank'}
                          }, */
                          {
                              label : 'Doc Title',
                              fieldName: 'linkName',
                              type : 'button',
                              typeAttributes:{label:{fieldName:'Doc_Title__c'}, name: 'view_details' , target:'_blank' ,title: 'Click to View Details of TSBs'}
                          }
                      ]);
        // Call helper to set the data for account table
        helper.getData(component);
    },
    
    handleLoadMore : function(component,event,helper){
        if(!(component.get("v.currentCount") >= component.get("v.totalRows"))){
            //To display the spinner
            event.getSource().set("v.isLoading", true); 
            //To handle data returned from Promise function
            helper.loadData(component).then(function(data){ 
                var currentData = component.get("v.TSBData");
                var newData = currentData.concat(data);
                component.set("v.TSBData", newData);
                //To hide the spinner
                event.getSource().set("v.isLoading", false); 
            });
        }
        else{
            //To stop loading more rows
            component.set("v.enableInfiniteLoading",false);
            event.getSource().set("v.isLoading", false);
            var toastReference = $A.get("e.force:showToast");
            toastReference.setParams({
                "type":"Success",
                "title":"Success",
                "message":"All TSBs records are loaded",
                "mode":"dismissible"
            });
            toastReference.fire();
        }
    },
    
    sectionOne : function(component, event, helper) {
        helper.hideshowtoggle(component,event,'articleOne');
    },
    
    handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                helper.insertviewedTSBs(row,component, event, helper);
                break;
                
        }
    },
})