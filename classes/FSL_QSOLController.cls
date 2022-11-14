/**********************************************************************
Name:FSL_QSOLController
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                             
-------  
This class written to for QSOL Links 
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         05/16/2019                         
***********************************************************************/

public class FSL_QSOLController {
    public string recordID {get;set;}
    public FSL_QSOLController(){
        recordID = ApexPages.CurrentPage().getparameters().get('id'); 
    }
    
    public static string getTokenQSOL(){
        string strgetacess = FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        return strgetacess ;
    }
    public  PageReference CSSSolutionsFromQSOL(){
        
        
        string strSerialNumber ;
        string endPoint ;
        string docType ;
        string strCSS_QsolLanguage ='en';
        string businessUnit ;
        CSS_Solution_Component__c objCSS =[select id ,FSL_Service_Order__c,FSL_Service_Order__r.Asset.Name,Component_Id__c from CSS_Solution_Component__c where id=:recordID];
        
        if(objCSS.FSL_Service_Order__r.Asset.Name!=null){
            strSerialNumber = objCSS.FSL_Service_Order__r.Asset.Name ;
        }
        HttpRequest req;
        HttpResponse res;
        String tokenStr2;
        
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_Getwarrantydocs');                
        endPoint = conDetails.End_Point__c;
        docType = conDetails.DocumentType__c;
        
        //-----CT3-44 , CT3-68----
        //Modified By: Dinesh Yadav,Sailaja Guntupalli 24 Sept 2020 For QSOL launguage.
        //language = conDetails.Language__c ;
        System.debug(' ::::: ' + UserInfo.getLanguage()) ;
        CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
        system.debug('csAccountLang :: '+csAccountLang);
        
        if(csAccountLang != null){
            if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
        }
        /* ------------End * CT3-44 -----*/
        
        businessUnit = conDetails.BusinessUnit__c ;
        
        Http h = new Http();
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        
        try{
        req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(100000);
        //  req.setBody(reqBody);   
        req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ docType +'&'+'language='+strCSS_QsolLanguage +'&'+'businessUnit='+businessUnit );
        
        // req.setEndpoint('https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=79643468&documentType=TRP&language=en&businessUnit=EBU');
        tokenStr2 = getTokenQSOL();
        
        String authorizationHeader = 'Bearer '+ getTokenQSOL();
        req.setHeader('Authorization', authorizationHeader);      
        system.debug('reqreqreq:::'+req);
        res = h.send(req);
        
        String responseBody = res.getBody();
        if(test.isrunningtest()){
         responseBody = ' [ ' + responseBody + ' ] '; 
        fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
        }
        else{
           //  responseBody = ' [ ' + responseBody + ' ] '; 
        fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
        }
            system.debug('response for syptoms\n::'+responseBody);
        list<CSS_Solution_Component__c> lstSol = new list<CSS_Solution_Component__c>();
        string strURL ;
        string docNumber;
        if(objCSS.Component_Id__c!=null && objCSS.Component_Id__c!=''){
            docNumber =objCSS.Component_Id__c ; // To Identy document type based on document number
        }    
        for(FSL_QSOLResponsewrapper owrapper : fslQSOLResps ){
            system.debug('checkdoc-->'+owrapper.documentNum);
            system.debug('checkdocdocNumber-->'+docNumber);
            if(owrapper.documentNum == docNumber){
                // Added by Sailaja Guntupalli to use QSOL Desc from QSOL Service
                objcss.QSOL_Description__c = owrapper.documentDesc;
                strURL = owrapper.documentLink ;
            }
             
        }
        //  viewcampaigns(objCSS.FSL_Service_Job__r.id);
        if(strURL !=null){
            system.debug('strURL==='+strURL);
            PageReference QSOLPage = new PageReference(strURL);
            QSOLPage.setRedirect(true);
            return QSOLPage;
        }
        else{
            PageReference QSOLPageError = new PageReference('/apex/FSL_FieldActionsError');
            return QSOLPageError ;
            
        }
        }
        catch (Exception e){
            PageReference QSOLPageError = new PageReference('/apex/FSL_FieldActionsError');
            return QSOLPageError ;
        }
        
    }
    @future 
    public static void viewcampaigns(string serviceorderId){
        FSL_CumminsUtilities.auditTrailInsert('Event-08',serviceorderId,'','','','');
    }
    
}