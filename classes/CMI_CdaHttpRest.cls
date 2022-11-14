global with sharing class CMI_CdaHttpRest{
    // Returns a string that indicates success or failure.
    webservice static String send(string appDAid,String aid,string buttonName) {
        
        string errorDescription='';
        HttpResponse res;
        String sCompanyId;
        String JSONString;
        String returnResult='';
        try{
            
            
            //string accountid='0014100000350dq';
            list<id> cids = new list<id>();
            contact conPrimary=new contact();
            IAM_Application__c appDA= new IAM_Application__c();
            CustomerPayloadInfo lstWapperforPut;
          
             Account obj=[select id,IAM_Service_Provider_Code__c,CMI_Cummins_Support_email__c,CMI_CId__c,(select id,CMI_CDA_Status__c,CMI_Indemnified__c from Applications__r where IAM_Account_Name__c=:aid and IAM_Application_Name__c='Connected Solutions' and id=:appDAid),(select id,Name,email from Contacts where accountid=:aid and CMI_Contact_Type__c='Primary') from Account where id=:aid];
             System.debug('obj=='+obj);
             if(!obj.Applications__r.isEmpty()){
                 appDA=obj.Applications__r[0];
             }
             if(!obj.Contacts.isEmpty()){
                 conPrimary=obj.Contacts[0];
             }
             
            
                lstWapperforPut=new CustomerPayloadInfo(obj,appDA,conPrimary);
                 System.debug('lstWapper====='+lstWapperforPut);
                
             
            if(lstWapperforPut!=null){
                //string url='https://connectedsolutions-stg.cummins.com/customerRegistration/customer/258';
                string url=System.label.CMI_httpurlforAccount+obj.CMI_CId__c+'/serviceagreement';
                System.debug(url);
                string key=System.label.CMI_APIKey;
                //string url=system.label.CMI_httpurlforAccount+'258';
                JSONString = JSON.serialize(lstWapperforPut);
                Http h = new Http();
                HttpRequest req = new HttpRequest();
                req.setEndpoint(url);
                req.setMethod('POST');
                system.debug(JSONString);
                req.setHeader('Content-Type','application/json');
                req.setHeader('Authorization','APIKEY '+key);
                
                req.setBody(JSONString);
                //req.setCompressed(true);  
                System.debug(req.getBody());
                System.debug(req.getEndpoint());
                System.debug(req.getHeader('Content-Type')); 
                System.debug(req.getHeader('Authorization')); 
              //  if(!test.isrunningtest()){
                    res = h.send(req);
                //}
                
                 if(res!=null && res.getStatusCode() != 200 ){
                    JSONParser parser = JSON.createParser(res.getBody());
                    System.debug('response===='+res.getBody());
                    
                    while(parser.nextToken() != null){
                    
                        if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'errorDescription'){
                        
                            parser.nextToken();
                            errorDescription += parser.getText()+',\n';
                            System.debug('error Description==='+errorDescription);
                           
                           //errorDescription += JSONToken.VALUE_STRING+'===='+parser.nextToken() +';';
                          }
                          
                    }
                    
                    cmiError(res.getStatus(),buttonName,JSONString+errorDescription); 
                }
            }
        }catch(exception e){
            cmiError(e.getMessage(),buttonName,JSONString);
            System.debug('ERROR Message:-->:'+ e);
            return e.getMessage();
        }
        System.debug('Printing status from service'+res.getStatusCode());
        System.debug('Printing Status from Service '+res.getBody());
        System.debug('Printing Status'+res.getStatus());
        if(res.getStatusCode()==200){
            returnResult='OK';
        }
        string strresult=errorDescription!='' && errorDescription!=null ?errorDescription:res!=null?returnResult:null;
        // On success, return a message to the calling program.
        system.debug(strresult);
        return strresult;
        
        }

    
    public static void cmiError(String msg,string buttonName,String s){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='IDENTITY';
        errObj.Error_Type__c=buttonName;
        errObj.Error_Description__c = msg;
        errObj.Processed_Data__c=s;
        insert errObj;
        }
     
    public class CustomerPayloadInfo{
      List<String> to= new List<String>();
      List<String> cc;
      List<String> bcc= new List<String>();
      public boolean indemnified{set;get;}
      
     public CustomerPayloadInfo(Account Acc,IAM_Application__c app,contact c){
     
        to.add(c.Email);
        //cc.add(Acc.CMI_Cummins_Support_email__c);
        if(Acc.CMI_Cummins_Support_email__c!=null&&Acc.CMI_Cummins_Support_email__c!=''){
                cc=new List<string>();
                cc=Acc.CMI_Cummins_Support_Email__c.Split(',');
        }
        bcc.add(system.label.CMI_CDA_BCCemail);
        this.indemnified=app.CMI_Indemnified__c;
            
       
     }
    
    }
}