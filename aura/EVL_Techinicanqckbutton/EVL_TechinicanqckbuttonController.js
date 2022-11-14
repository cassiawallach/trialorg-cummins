({
    handleShowModaltec: function(component, evt, helper) {
        var modalBody;
         var recId = component.get("v.recordId");
        $A.createComponent("c:EVL_Techniciandropdown", {
            WorkrecId :recId,
        },
           function(content, status) {
               if (status === "SUCCESS") {
                   modalBody = content;
                   component.find('overlayLib').showCustomModal({
                       header: "Assign Technician",
                       body: modalBody,
                       showCloseButton: true,
                       cssClass: "mymodal"
                      
                   })
               }
           });
    }
})