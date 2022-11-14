/**********************************************************************
Name:  OSM_SW_SalesRepSendQuoteCtrl
Copyright © 2018  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class is to update status values based on click of send quote button                                
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Adarsh            4/13/2018     INITIAL DEVELOPMENT          


*****************************************************/
global class OSM_SW_SalesRepSendQuoteCtrl {

    ApexPages.StandardController stdCntrlr;
    global ccrz__E_RequestForQuote__c request;
    global ccrz__E_RequestForQuote__c newrequest{set;get;}
    global string rfqstatus{set;get;}
    global string rfqoperation{set;get;}
    global list<ListView> SentQuoteIdList;
    global string recordid;
    public integer onloadCount{get;set;}
    global PageReference listView;    
    
    public OSM_SW_SalesRepSendQuoteCtrl(ApexPages.StandardController controller){
        stdCntrlr = controller;
        this.request = (ccrz__E_RequestForQuote__c) stdCntrlr.getRecord();
        	//onloadCalls = true;
        onloadCount = 0;
       }    
    public OSM_SW_SalesRepSendQuoteCtrl()
    {}
/*----------------------------------------------------------------------------------
1. sendAction
Description:Used to update status values
Param: 
Output: 
------------------------------------------------------------------------------------*/    
        global PageReference sendAction(){
            
        //Commented by Vaibhav on 29-Sep to implement CC Review
       //ccrz__E_RequestForQuote__c newrequest = [select id,Date__c,Expired_Date__c,ccrz__Account__c,ccrz__Contact__c,status__c from ccrz__E_RequestForQuote__c where id
                                                                  // =:ApexPages.currentPage().getParameters().get('id')]; 
                                                                  // 
    ccrz__E_RequestForQuote__c newrequest = [select id,Date__c,Expired_Date__c,ccrz__Account__c,ccrz__Contact__c,status__c from ccrz__E_RequestForQuote__c where id
                                                                  =:this.request.id];
        
            if(newrequest.Status__c == label.InprogressQuoteRfq || newrequest.Status__c == label.ExpiredQuoteRfq || newrequest.Status__c == label.sentquoteRfq)
            {
                newrequest.Operation__c = 'Send';
                //newrequest.OwnerId = UserInfo.getUserId();
                newrequest.Date__c = system.now();
                newrequest.Expired_Date__c = system.now()+3;
                update newrequest;
               validateAction(newrequest.status__c,newrequest.Operation__c);
            }
            else{
              validateAction(newrequest.status__c,'Send');
            } 
            //onloadCalls = false;
            onloadCount = onloadCount+1;
           return null;
     
        }
/*----------------------------------------------------------------------------------
1. validateAction
Description:Used to validate actions on click of Send Quote button based on status
Param: string statusVal,string operationVal
Output: 
Display messages to sales rep based on status and operation
------------------------------------------------------------------------------------*/       
                
    
    global static void validateAction(string statusVal,string operationVal){
       
      
      
        if(statusVal==label.RequestedQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.RequestedSendMessage));
            
        }
        else if(statusVal==label.AcceptedQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.NoSendMessage));
          
        }
        else if(statusVal==label.RejectedQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.NoSendMessage));
        
        }
        else if(statusVal==label.InActiveQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.NoSendMessage));
             
        }
        else if(statusVal==label.InprogressQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, label.SendMessage));
        
        }
        else if(statusVal==label.SentQuoteRfq && operationVal=='Send'){ 
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, label.SendMessage));
         
        }
        else if(statusVal==label.ExpiredQuoteRfq && operationVal=='Send'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, label.SendMessage));
        }
         else if(statusVal!=label.InprogressQuoteRfq && operationVal=='Cancel'){       
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.CancelMessage)); 
    }
        else if(statusVal==label.InActiveQuoteRfq && operationVal=='Cancel'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR, label.CancelMessage));
        }
        else if(statusVal==label.InprogressQuoteRfq && operationVal=='Cancel'){
           Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.INFO, label.SendMessage));
        }
    } 
    
   /*----------------------------------------------------------------------------------
1. backAction
Description:Used to navigate to record detail page
Param: 
Output: 
Navigates to record detail page on click of back button
------------------------------------------------------------------------------------*/ 
   global pageReference backAction(){
            
       if((rfqstatus == label.AcceptedQuoteRfq || rfqstatus==label.RejectedQuoteRfq  ||rfqstatus ==label.RequestedQuoteRfq|| rfqstatus ==label.InActiveQuoteRfq)   ) {
           
         String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
         string quoterecordId = ApexPages.currentPage().getParameters().get('id');
         String completeURL = baseURL +'/' +quoterecordId;
         PageReference detailpage = new pageReference (completeURL);
         detailpage.setRedirect(true);
         return detailpage;
           
       }
      
       else{
       
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm(); 
       SentQuoteIdList = [SELECT Id FROM ListView WHERE SObjectType = 'ccrz__E_RequestForQuote__c' and name = 'Sent Quotes'];
       if(SentQuoteIdList.size()>0)
        recordid = String.valueOf(SentQuoteIdList[0].id).subString(0, 15);
       Schema.DescribeSObjectResult anySObjectSchema = ccrz__E_RequestForQuote__c.SObjectType.getDescribe();
       String objectIdPrefix = anySObjectSchema.getKeyPrefix();
        listView = new PageReference(baseURL+'/'+objectIdPrefix+'?fcf='+recordid);
       listView.setRedirect(true);
       return listView;
       
       }
   } }