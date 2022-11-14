/*****************************************************************************************************************************
Name : FSL_TSB_Integration 
Description : This Class is used to get TSB and insert in to Css_campTsbtrps object on change of PSN on the work order

Version                 Date                    Author                             Summary Of Change
-------------------------------------------------------------------------------------------------------------------------------                  
1.0                   08/15/2019                Ravikanth Macherla                      Inserting TSB and showing on 
2.0                   10/08/2020                Dinesh Yadav                            Instert Group Number, Group Name, Fault Code & Symtoms in TSBs
3.0                   10/20/2020                Dinesh Yadav                            Language Translation in TSBs
*******************************************************************************************************************************/
public class FSL_TSB_Integration{
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    public static string getTokenQSOL(){
        string strgetacess = FSL_CL_QSOLIntegrations.getToken('FSL_GetApiToken_QSOL');
        return strgetacess ;
    }
    @future (callout=true)  
    public  static void TSBFromQSOL(string strservicejobid){
       DateTime startTime = System.Now();
        executionLog = FSL_ApplicationLogger.logStart('FSL_TSB_Integration: TSBFromQSOL method ' + startTime, executionLog , isEligibleForAppLogging);
       
        executionLog = FSL_ApplicationLogger.logMessage('WorkOrder Id '+strservicejobid,executionLog,isEligibleForAppLogging);
            
        
        string strSerialNumber ;
        workorder  objWO =[SELECT Id, Asset.Name FROM WorkOrder WHERE id=:strservicejobid];
        
        if(objWO.Asset.Name!=null){
            strSerialNumber = objWO.Asset.Name ;
        }
        
        HttpRequest req;
        HttpResponse res=new HttpResponse();
        String tokenStr2;
        Http h = new Http();
        List<FSL_QSOLResponsewrapper> fslQSOLResps = new list<FSL_QSOLResponsewrapper>();
        
        string endPoint;       
        try{    
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();                     
            conDetails = CSS_Integration_Details__c.getValues('FSL_QSOL_Getwarrantydocs');   
            system.debug('conDetails--->'+conDetails);          
            if(conDetails!=null && conDetails.End_Point__c!=null){
                system.debug('conDetailsin--->'+conDetails);     
                endPoint = conDetails.End_Point__c;
                system.debug('endPoint--->'+endPoint );
            }   
            
            req = new HttpRequest();
            req.setMethod('GET');
            req.setTimeout(100000);
            //  req.setBody(reqBody);  
            
            //-----CT3-152 ----
            //Modified By: Dinesh Yadav, 20 Oct 2020 For QSOL launguage.
            System.debug(' ::::: ' + UserInfo.getLanguage()) ;
            CSS_accountLanguage__c csAccountLang = CSS_accountLanguage__c.getValues(UserInfo.getLanguage());
            system.debug('csAccountLang :: '+csAccountLang);
            string strCSS_QsolLanguage ='en';
            if(csAccountLang != null){
                if(csAccountLang.CSS_QsolLanguage__c != null && string.isNotBlank(csAccountLang.CSS_QsolLanguage__c))
                    strCSS_QsolLanguage = csAccountLang.CSS_QsolLanguage__c;
            }
            req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ 'TSB' +'&'+'language='+strCSS_QsolLanguage+'&businessUnit=EBU');
            /* ------------End * CT3-152 -----*/
            
            //req.setEndpoint(endPoint+'serialNumber='+strSerialNumber+'&'+'documentType='+ 'TSB' +'&'+'language=en&businessUnit=EBU'); //CT3-152
            
            //  req.setEndpoint('https://qs-stg.cummins.com/integrationservices/api/getWarrantyDocs?serialNumber=79643468&documentType=TRP&language=en&businessUnit=EBU');
            tokenStr2 = getTokenQSOL();
            
            String authorizationHeader = 'Bearer '+ getTokenQSOL();
            req.setHeader('Authorization', authorizationHeader);      
            system.debug('reqreqreq:::'+req);
            // if(!Test.isRunningTest()) {    
            res = h.send(req);
             executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+req,executionLog,isEligibleForAppLogging);

            String responseBody = res.getBody();
            // responseBody = ' [ ' + responseBody + ' ] '; 
            
            if(Test.isRunningTest()){
                 responseBody  = '[{"documentNum":"TSB070007","documentDesc":"Troubleshooting High Blowby and/or Oil Consumption","type":"TSB","language":"en","groupNum":"7","groupName":"07 - Lubricating Oil Systems","documentLink":"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/tsb/2007/tsb070007.html"}]';
            }
            system.debug('responseBody  ::: '+responseBody );
            fslQSOLResps = (List<FSL_QSOLResponsewrapper>)JSON.deserialize(responseBody, List<FSL_QSOLResponsewrapper>.Class);
            system.debug('response for syptoms\n::'+responseBody);
            list<CSS_CampTsbTrp__c > lsttsb= new list<CSS_CampTsbTrp__c >();
            // String strUrlDom = 'https://qs-stg.cummins.com/';
            // String strUrltwo;
            // String finalString;
            for(FSL_QSOLResponsewrapper owrapper : fslQSOLResps ){
                CSS_CampTsbTrp__c  objcamp = new CSS_CampTsbTrp__c ();
                objcamp.Doc_Num__c = owrapper.documentNum ;
                objcamp.Name = owrapper.documentNum ;
                objcamp.Doc_Title__c = owrapper.documentDesc ;
                objcamp.Type__c= owrapper.type ;
                objcamp.Cu_Language__c = owrapper.language ;
                objcamp.URL__c = owrapper.documentLink;
                objcamp.FSL_ServiceJob__c = strservicejobid ;
                
                //------------ CT3-114 Stats here ---------------//
                objcamp.Group_Name__c= owrapper.groupName;
                objcamp.Group_Num__c= owrapper.groupNum;
                
                system.debug('owrapper.faultCodes '+owrapper.faultCodes);
                if(owrapper.faultCodes != null && owrapper.faultCodes.size() > 0){
                    string strFaultCodes= string.join(owrapper.faultCodes,',');
                    objcamp.Fault_Code__c= strFaultCodes;
                }
                
                system.debug('owrapper.symptoms '+owrapper.symptoms);
                if(owrapper.symptoms != null && owrapper.symptoms.size() > 0){
                    string strSymptoms = owrapper.symptoms[0];
                    objcamp.Symptom__c = strSymptoms;
                }
                lsttsb.add(objcamp);
                //---------CT3-114 End --------------------------//  
            }
            
            list<CSS_CampTsbTrp__c> lstCampDelete = [select id,FSL_ServiceJob__c  from CSS_CampTsbTrp__c where FSL_ServiceJob__c=:strservicejobid];
            if(lstCampDelete.size()>0){
                Database.Delete(lstCampDelete ,false) ;
            }
            if(lsttsb.size()>0){
                Database.insert(lsttsb,false) ;
                system.debug('lsttsb---->'+lsttsb);
                FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),strservicejobid );
            }
        }
        catch (exception e){} 
        //   }
    }
}