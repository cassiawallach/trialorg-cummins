({
    /*doInit : function(component, event) {
         var action = component.get("c.fetchSolutionDetails");
        action.setParams({ 
            solId :  component.get("v.SolutionId"),
        });
         action.setCallback(this, function(a) {
             alert('a**'+a.getReturnValue().Name);
             component.set("v.SolutionDetails", a.getReturnValue());
         });
         $A.enqueueAction(action);
     },*/
    handleClick : function(component, event, helper) {
        
        component.set("v.showDescription",true);
        
    },
    
    checkCommentValue : function(component, event, helper){
        var rapData = component.get("v.textAreaValue");
        if(rapData === undefined || rapData === null || rapData === '' || rapData.trim() == "") {
            component.set("v.btndisable", true);
        } else {
            component.set("v.btndisable", false);
        }
        
    },
    
    handleSave : function(component, event, helper) {
        
        var commentsControl = component.find("comments");
        console.log(component.find("comments"));
        var values = commentsControl.get("v.value");
        console.log("event:"+commentsControl.get("v.value")) ;

        //alert(component.get("v.SolutionId"));
        var action = component.get("c.caseCreation");
        action.setParams({ 
            solutionId :  component.get("v.SolutionId"),
            description : commentsControl.get("v.value"),
            workOrderId : component.get("v.recordId"),
            solutionTitle : component.get("v.Solution")
        });
        
        action.setCallback( this, function(response) {
            var state = response.getState(); 
            console.log('State*****'+state);
            if (state === "SUCCESS") {
                component.set("v.showDescription",false);
                component.set("v.isModalOpen", true);
                //alert(response.getReturnValue());
            } 
            else{
                alert('Error message: Unknown error has occurred ');
            }
            
        });
        $A.enqueueAction(action);
        
    },
    handleCancel : function(component, event, helper) {
        
        component.set("v.showDescription",false);
        
    },
    closeModel: function(component, event, helper) {
        component.set("v.isModalOpen", false);
    }
})