({
    handleShowModal:function (component, event, helper) {
        component.set("v.isOpen",true);
    },
    CloseDialog : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
})