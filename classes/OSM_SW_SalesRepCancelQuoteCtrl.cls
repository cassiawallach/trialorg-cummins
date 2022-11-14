/**********************************************************************
Name:  OSM_SW_SalesRepCancelQuoteCtrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to update status values based on click of Cancel quote button                                
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                      DATE              DETAIL                                
 1.0 -    Adarsh Pidaparthy           4/13/2018     INITIAL DEVELOPMENT           


*****************************************************/
public class OSM_SW_SalesRepCancelQuoteCtrl {

    ApexPages.StandardController stdCntrlr;
    Public ccrz__E_RequestForQuote__c request;
    public ccrz__E_RequestForQuote__c newrequest{set;get;}
    public integer onloadCount{get;set;}
    public OSM_SW_SalesRepCancelQuoteCtrl(ApexPages.StandardController controller){
        stdCntrlr = controller;
        this.request = (ccrz__E_RequestForQuote__c) stdCntrlr.getRecord();
        onloadCount = 0;
    }
  /*----------------------------------------------------------------------------------
1. cancelAction
Description:Used to update status values
Param: 
Output: 
------------------------------------------------------------------------------------*/   
 public void cancelAction(){    
         
    
         //ccrz__E_RequestForQuote__c newrequest = [select id,ccrz__Account__c,ccrz__Contact__c,status__c from ccrz__E_RequestForQuote__c where id
                                                                  // =: ApexPages.currentPage().getParameters().get('id')];
     try{
     ccrz__E_RequestForQuote__c newrequest = [select id,ccrz__Account__c,ccrz__Contact__c,status__c from ccrz__E_RequestForQuote__c where id
                                                                   =: request.id];
              System.debug('newrequest____'+newrequest);                                                           
             if(newrequest.status__c == label.InprogressQuoteRfq){
               newrequest.Operation__c = 'Cancel';         
               update newrequest;
               System.debug('newrequest after update____'+newrequest); 
               OSM_SW_SalesRepSendQuoteCtrl.validateAction(newrequest.status__c,newrequest.Operation__c);        
             }
             else{
                   OSM_SW_SalesRepSendQuoteCtrl.validateAction(newrequest.status__c,'Cancel');
             }         
         }Catch(Exception ex){
            // Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, 'Quote cannot be cancelled as status is not '+label.InprogressQuoteRfq));
         }
    onloadCount = 1;
 }      
 /*----------------------------------------------------------------------------------
1. backAction
Description:Used to navigate to record detail page
Param: 
Output: 
Navigates to record detail page on click of back button
------------------------------------------------------------------------------------*/       
       
    public pageReference backAction(){
        
         String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
         string recordid = ApexPages.currentPage().getParameters().get('id');
         String completeURL = baseURL +'/' +recordid;
         PageReference detailpage = new pageReference (completeURL);
        detailpage.setRedirect(true);
         return detailpage;
    }
            }