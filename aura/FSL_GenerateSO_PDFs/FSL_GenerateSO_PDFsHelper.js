({
    renderFlow : function (component, event, helper,flow,recordId) {
        //var flow = component.find("flowData");
        var inputVariables = [{
            name : 'recordId',
            type : 'String',
            value : recordId
        }];
        flow.startFlow("Generate_Service_Order_PDFs", inputVariables);
    },
})