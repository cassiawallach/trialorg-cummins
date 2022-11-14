/******
Name:  OSM_RequestForApprovalController
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                                                             
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            	DATE              	DETAIL                                
1.0 -   Neha Mehta       	27/03/2019    		INITIAL DEVELOPMENT
1.1 - 	Charlynn Stubbert	09/08/2022			Changes for LL-34 add Revoke Approval button logic
*******/
public with sharing class OSM_RequestForApprovalController {
    public CC_Request_For_Approval__c requestApprovalObject;
    public Id requestId {get;set;}
    public String DistComments;
    public Boolean isdisable {get;set;}
    
    public OSM_RequestForApprovalController(ApexPages.StandardController stdcontroller) {
        this.requestApprovalObject= (CC_Request_For_Approval__c)stdController.getRecord();
        requestId =requestApprovalObject.id;
        isdisable=false;
    }
    
    //Approve Request
    public PageReference acceptRequest(){
        //  update requestApprovalObject;
        System.debug('requestApprovalObject_____'+requestApprovalObject);
        PageReference detailpage;
        
        List<CC_Request_For_Approval__c> requestUpdateList=new List<CC_Request_For_Approval__c>();
        
        List<CC_Request_For_Approval__c> acceptRequestList=([SELECT Id,Distributor_Comments__c,Product_Name__c,Quantity__c,Customer_Comments__c,Request_Status__c FROM CC_Request_For_Approval__c  WHERE Id =:requestApprovalObject.Id]);
        for(CC_Request_For_Approval__c req:acceptRequestList){
            
            req.Request_Status__c='Approved';
            req.Distributor_Comments__c=requestApprovalObject.Distributor_Comments__c;
            req.Product_Name__c=requestApprovalObject.Product_Name__c;
            req.Quantity__c=requestApprovalObject.Quantity__c;
            req.Customer_Comments__c=requestApprovalObject.Customer_Comments__c;
            String completeURL = '/apex/CCRequestForApprovalVFPage?id=' +req.id;
            detailpage = new pageReference (completeURL);
            detailpage.setRedirect(true);
            
            requestUpdateList.add(req);
            System.debug('______accept___disabled'+isdisable);
        }
        update requestUpdateList;
        
        return detailPage;
    }
    
    //Reject Request 
    public PageReference rejectRequest(){
        // update requestApprovalObject;
        PageReference detailpage;
        List<CC_Request_For_Approval__c> requestUpdateList=new List<CC_Request_For_Approval__c>();
        List<CC_Request_For_Approval__c> rejectRequestList=([SELECT Id,Distributor_Comments__c,Product_Name__c,Quantity__c,Customer_Comments__c,Request_Status__c FROM CC_Request_For_Approval__c  WHERE Id =:requestApprovalObject.Id]);
        System.debug('________Distributor_Comments__c___'+requestApprovalObject.Distributor_Comments__c);
        for(CC_Request_For_Approval__c req:rejectRequestList){
            if(requestApprovalObject.Distributor_Comments__c==null || requestApprovalObject.Distributor_Comments__c==''){
                System.debug('________req.Distributor_Comments__c___'+requestApprovalObject.Distributor_Comments__c);
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter distributor comments.');
                ApexPages.addMessage(myMsg);
                // isdisable=true;
                
            }
            else{
                
                req.Request_Status__c='Rejected';
                req.Distributor_Comments__c=requestApprovalObject.Distributor_Comments__c;
                req.Product_Name__c=requestApprovalObject.Product_Name__c;
                req.Quantity__c=requestApprovalObject.Quantity__c;
                
                String completeURL = '/apex/CCRequestForApprovalVFPage?id=' +req.id;
                detailpage = new pageReference (completeURL);
                detailpage.setRedirect(true);
                
                System.debug('_________disabled'+isdisable);
            }    
            requestUpdateList.add(req);
        }
        
        
        update requestUpdateList;
        
        return detailpage; 
        
    }
    //Added below method for Mar-753
    
    Public static void UpdateRFA_OnOrderCancellation(Set<Id> orderIdSet){  
        system.debug('Inside UpdateRFA_OnOrderCancellation==');
        try{
            If(orderIdSet.size() !=null && orderIdSet.size()>0) {
                List<CC_Request_For_Approval__c> requestUpdateList=new List<CC_Request_For_Approval__c>();
                List<CC_Request_For_Approval__c> requestUpdateList1=new List<CC_Request_For_Approval__c>();
                set<id> dupchecker = new set<id>();
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                lstOrderItem = [Select Id,ccrz__Order__r.ccrz__OrderStatus__c,ccrz__Order__c,ccrz__Order__r.ccrz__EffectiveAccountID__c, ccrz__DisplayProduct__c  from ccrz__E_OrderItem__c where ccrz__Order__c IN: orderIdSet];
                system.debug('Product_Name__c =: '+lstOrderItem[0].ccrz__DisplayProduct__c +' Customer_Account_Name__c '+lstOrderItem[0].ccrz__Order__r.ccrz__EffectiveAccountID__c);
                Set<Id> accountId = new Set<Id>();
                Set<Id> ProductId = new Set<Id>();
                List<ccrz__E_OrderItem__c> lstOrderItemToCancleRFA = new List<ccrz__E_OrderItem__c>();
                for(ccrz__E_OrderItem__c ordrItem:  lstOrderItem)
                {
                    if(ordrItem.ccrz__Order__r.ccrz__OrderStatus__c == Label.OSM_Cancelled)
                    {
                        accountId.add(ordrItem.ccrz__Order__r.ccrz__EffectiveAccountID__c);
                        ProductId.add(ordrItem.ccrz__DisplayProduct__c);
                        lstOrderItemToCancleRFA.add(ordrItem);
                    }
                }
                if(accountId.size()>0){
                    requestUpdateList= [SELECT Id,Customer_Account_Name__c,Distributor_Comments__c,Product_Name__c,Quantity__c,Customer_Comments__c,Request_Status__c FROM CC_Request_For_Approval__c  WHERE Product_Name__c =: ProductId AND Customer_Account_Name__c =: accountId AND Request_Status__c != 'Order Cancelled'];
                }
                
                for(CC_Request_For_Approval__c objRFA : requestUpdateList)
                {
                    for(ccrz__E_OrderItem__c ordrItem:  lstOrderItemToCancleRFA)
                    {
                        if(objRFA.Product_Name__c == ordrItem.ccrz__DisplayProduct__c && objRFA.Customer_Account_Name__c == ordrItem.ccrz__Order__r.ccrz__EffectiveAccountID__c && !dupchecker.contains(objRFA.id))
                        {
                            objRFA.Request_Status__c = 'Order Cancelled';
                            requestUpdateList1.add(objRFA);
                            dupchecker.add(objRFA.id);
                        }
                    }
                }
                
                system.debug('List to update'+requestUpdateList1);
                if(requestUpdateList1 != null && requestUpdateList1.size() > 0)
                    update requestUpdateList1;
           }
         }catch(exception ex){
            system.debug('Exception in OSM_RequestForApprovalController line '+ex.getLineNumber());
            system.debug('Exception in OSM_RequestForApprovalController message '+ex.getMessage());
        }
    }
    
    //LL-34 Code Start
    // Revoke request logic - updates status to 'Revoke Approval' as long as distrubtor comments are not blank
    public PageReference revokeRequest(){
        PageReference detailpage;
        List<CC_Request_For_Approval__c> requestUpdateList=new List<CC_Request_For_Approval__c>();
        List<CC_Request_For_Approval__c> revokeRequestList=([SELECT Id,Distributor_Comments__c,Product_Name__c,Quantity__c,Customer_Comments__c,Request_Status__c FROM CC_Request_For_Approval__c  WHERE Id =:requestApprovalObject.Id]);
        //System.debug('________Distributor_Comments__c___'+requestApprovalObject.Distributor_Comments__c);
        for(CC_Request_For_Approval__c req:revokeRequestList){
            /*if(String.isBlank(requestApprovalObject.Distributor_Comments__c)){
                System.debug('________req.Distributor_Comments__c___'+requestApprovalObject.Distributor_Comments__c);
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter distributor comments.');
                ApexPages.addMessage(myMsg);                
            }
            else{*/
                
                req.Request_Status__c='Approval Revoked';
                req.Distributor_Comments__c=requestApprovalObject.Distributor_Comments__c;
                req.Product_Name__c=requestApprovalObject.Product_Name__c;
                req.Quantity__c=requestApprovalObject.Quantity__c;
                
                String completeURL = '/apex/CCRequestForApprovalVFPage?id=' +req.id;
                detailpage = new pageReference (completeURL);
                detailpage.setRedirect(true);
                
                System.debug('_________disabled'+isdisable);
            //}    
            requestUpdateList.add(req);
        }
        
        
        update requestUpdateList;
        
        return detailpage; 
        
    }
    // LL-34 Code End
    
}