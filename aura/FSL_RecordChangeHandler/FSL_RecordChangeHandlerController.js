({
	
    doInit : function(component, event, helper){
        var supportedStandardObject = ['Account','Asset','Campaign','Case','Contact','ContractLineItem','Entitlement','Lead',
                                        'LiveChatTranscript','Opportunity','Order','OrderItem','Product2','Quote', 'QuoteLineItem','ServiceContract'];
        component.set("v.supportedStandardObject", supportedStandardObject);
        
        helper.checkCompatibility(component, event, helper);
        helper.receiveNotification(component, event, helper);
    },
})