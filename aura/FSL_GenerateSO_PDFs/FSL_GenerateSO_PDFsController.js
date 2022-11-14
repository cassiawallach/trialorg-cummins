({
    init : function (component, event, helper) {
        var Service_OrderId = component.get("v.recordId");
        var flow = component.find("flowData1");
        helper.renderFlow(component, event, helper,flow, Service_OrderId);
    },
    
    handleRecordsChangeEvent: function (component, event, helper) {
        var Service_OrderId = component.get("v.recordId");
        const data = event.getParam('messageData');
        const record = event.getParam('record');
        const changeType = record.ChangeEventHeader.changeType;
        const changedFields = record.ChangeEventHeader.changedFields;
        
        if((changeType == 'UPDATE' && changedFields.includes('Service_Order__c')) || ((changeType == 'CREATE' || changeType == 'UNDELETE') && record.Service_Order__c == Service_OrderId) || (changeType == 'DELETE')){
            
            component.set("v.isLoad2", !component.get("v.isLoad2"));
            component.set("v.isLoad1", !component.get("v.isLoad1"));
            var flow;     
            if(component.get("v.isLoad1")){
                flow = component.find("flowData1");
            }
            if(component.get("v.isLoad2")){
                flow = component.find("flowData2");
            }
            helper.renderFlow(component, event, helper,flow, Service_OrderId);
        }
    },
})