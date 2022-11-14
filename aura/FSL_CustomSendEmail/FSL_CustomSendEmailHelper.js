({
    sendHelper: function(component,event,helper, getEmail, getccEmail, getSubject, getbody,getrecid, docIds) {
        var action = component.get("c.sendMailMethod");
        action.setParams({
            'mMail': getEmail,
            'ccMail': getccEmail,
            'mSubject': getSubject,
            'mbody': getbody,
            'recid':getrecid,
            'docIds': docIds
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.mailStatus", true);
                component.set("v.bodytext", null);
            }
        });
        $A.enqueueAction(action);
    }, 
})