/**********************************************************************
Name: FSL_UpdateQSOLlinks
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This Class is used to the Get warranty docs on change of asset after insertion of Fieldactions on Css Soltuion Components.
For Fieldaction Overview on the job plan.
Inserting QSOl Links in the CSS Soltuion Comp and Displaying in the Job plan Overview
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE             Detail                      
1.0     Ravikanth Macherla         10/29/2019         Initial Development 
2.0     Charan                     03/19/2021         Bug CT3-380 - to avoid recursive 
***********************************************************************/
public class FSL_UpdateQSOLlinks implements Queueable,Database.AllowsCallouts {  
    list<CSS_Solution_Component__c> lstCssComp = new list<CSS_Solution_Component__c>();  
    String strWorkOrderId = '';  
    
    public FSL_UpdateQSOLlinks(list<CSS_Solution_Component__c> CssComp, string strWID) {  
        
        this.lstCssComp = CssComp;  
        this.strWorkOrderId = strWID ;
        
    }  
    
    public void execute(QueueableContext qc) {  
        
        string strSerialNumber ;
        string endPoint ;
        string docType ;
        string language ;
        string businessUnit ;
        string strURL ;
        string docNumber;
        system.debug('***strWorkOrderId***'+strWorkOrderId);
        HttpRequest req;
        HttpResponse res;
        String tokenStr2;
         //Added by Sailaja Guntupalli CT3-68 to pass the user lang if mapping exists for QSOL Translations
    CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
    system.debug('csAccountLang :: '+csAccountLang);
    string strCSS_QsolLanguage ='en';
    if(csAccountLang != null){
        if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
            strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
           }
           // CT3-68 END
        try{
        if(RecursiveTriggerHandler.isCheckFieldActions == true) //Added by Charan for bug CT3-380
        {
        RecursiveTriggerHandler.isCheckFieldActions = false; //Added by Charan for bug CT3-380
        map<string,CSS_Solution_Component__c> mapCSS = new map<string,CSS_Solution_Component__c>();
        if(!Test.isRunningTest()) {
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_Getwarrantydocs');                
            endPoint = conDetails.End_Point__c;
            docType = conDetails.DocumentType__c;
            language = strCSS_QsolLanguage ;
            businessUnit = conDetails.BusinessUnit__c ;
            }
        else {
            endPoint=  'https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?';
        }
        Http h = new Http();
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        
        req = new HttpRequest();
        req.setMethod('GET');
        req.setTimeout(100000);
        system.debug('i just added debug for strWorkOrderId**'+strWorkOrderId);
        workorder objSO =[SELECT id,Asset.Name FROM workorder WHERE id=:strWorkOrderId];
        strSerialNumber = objSO.Asset.Name;
        //  req.setBody(reqBody);   
        req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ docType +'&'+'language='+language +'&'+'businessUnit='+businessUnit );
        
        //  req.setEndpoint('https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=79643468&documentType=TRP&language=en&businessUnit=EBU');
        // system.debug('type check'+type);
        // system.debug('component id'+componentid);
        String authorizationHeader = 'Bearer '+ FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        req.setHeader('Authorization', authorizationHeader);      
        system.debug('reqreqreq:::'+req);
        res = h.send(req);
        system.debug('**res***'+res);
        String responseBody = res.getBody();
        // responseBody = ' [ ' + responseBody + ' ] ';
            if(responseBody!=null && responseBody!=''){
                fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
            }
        
        /* for(CSS_Solution_Component__c objcss : lstCssComp){
            mapCSS.put(objcss.Component_Id__c, objcss);
            }*/
        system.debug('fslQSOLResps--->'+fslQSOLResps);
        list<CSS_Solution_Component__c> lstComp = new list<CSS_Solution_Component__c>();
        set<CSS_Solution_Component__c> setComp = new set<CSS_Solution_Component__c>();
        for(FSL_QSOLResponsewrapper owrapper : fslQSOLResps ){
            CSS_Solution_Component__c objComp = new CSS_Solution_Component__c();
            for(CSS_Solution_Component__c objcss : lstCssComp){
                if(objcss.Component_Id__c ==owrapper.documentNum){
                    objcss.FSL_Link__c  = owrapper.documentLink ; 
                    // Added by Sailaja Guntupalli CT3-68 to use  QSOL Desc from QSOL Service call
                    objcss.QSOL_Description__c = owrapper.documentDesc;
                    setComp.add(objcss);
                }
            }
        }
        if(setComp.size()>0){ 
            lstComp.addall(setComp);
            Database.update(lstComp, false)  ;
            system.debug('lstComp--->'+lstComp);
        }
        }
    }
        catch(Exception ex){
            system.debug('ex'+ex+'Line number'+ex.getLineNumber());
        }
    }  
    
}