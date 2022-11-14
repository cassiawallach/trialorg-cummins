/***********************************************************************************************
Name:CSS_CDAlertList
Copyright © 2011  Cummins
=======================================================================================
=======================================================================================
Purpose:                                                            
This class is the custom controller class for the CSS_CDAlertsList component to display
the 30 dat alerts received from Connected Diagnostics.                                                             
=======================================================================================
=======================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                   DETAIL                                 
1.0 -   Shruti Umamaheshwaran   1/29/2016 5:03 PM      INITIAL DEVELOPMENT                     
2.0 -   Gyan Pany               2/9/2016 12:25 PM      UDAC WIRE FRAME CHANGES                
3.0 -   Anirudh                 2/11/2016              Coding Standards
4.0 -   Satish                  5/4/2016               Added Dashboard URL code
5.0 -   Shruti                  5/4/2016
 
Input: 
CSS Job Id
Output: 
The 30 days alerts is retrived from the database using CSS_ConnectedDiagnostics__c custom object

Methods:
1. getAlerts(): This function retrives the 30 day alerts from Connected diagnostics
2. AlertSearch():  This function is used to get the alerts from Connected Diagnostics too.
*************************************************************************************************/
public with sharing class CSS_CDAlertList
{
    public String showPopup { get; set; }
    public List<CSS_ConnectedDiagnostics__c> AlertList {get;set;}
    
    public String DashboardURL {get;set;}
    
    public ID JobID ;
    public ID ClaimsId {get;set;}

    public String sJobESN { get; set{ sJobESN=value;  getDashboardURL();} }

    public ID getJobID(){ return JobID; }
    public ID jID {get; set;}
    public void setJobID(ID j)
    {
        JobID = j;
        system.debug('JJJJJ Testing' + JobID);
        if (JobID != null) {
            getAlerts();
        }
    }
    
    public CSS_CDAlertList() 
    {
        jID = ApexPages.CurrentPage().getParameters().get('id');
        //system.debug('inside CD contructor strESN'+sJobESN);
        
    }
    public CSS_CDAlertList(ApexPages.StandardController stdController) 
    {
        //system.debug('inside CD contructor strESN 2'+sJobESN);
        //getDashboardURL();
    } 
    
    public List<CSS_ConnectedDiagnostics__c> getAlerts()
    {
         system.debug('JobID**'+JobID);
        system.debug('ClaimsId**'+ClaimsId);
        if(JobID == null){JobID = ClaimsId;}
        AlertList = [Select Fault_Code__c,Fault_Code_Description__c,Latest_Occurrence_Date_Time__c,Total_Occurrence_Count__c from CSS_ConnectedDiagnostics__c where CSSJobId__c=: JobID LIMIT 30];
        System.debug('AlertList ' + AlertList);
        return AlertList;
    }
    
    public PageReference AlertSearch() 
    {
        getAlerts();
        return null;
    }
    
    public string getDashboardURL()
    {
   
        //User u = [select FederationIdentifier,UserGroup__c from user where id=:Userinfo.getUserId()]; 

        /*
        String strESN='42012678'; 
        String strJobId='CSS-00001152';
        String strUserId='nt382';    
        String strToolName='CSS';
        
        System.debug('The key is !#!#@!'+CSS_getConnnectionDetails.getConnection('CDDashbrd').Key__c);
        System.debug('The Passcode is !#!#@!'+CSS_getConnnectionDetails.getConnection('CDDashbrd').Passcode__c);
        System.debug('The URL is !#!#@!'+CSS_getConnnectionDetails.getConnection('CDDashbrd').End_Point__c);*/
        
        String strESN=sJobESN; 
        String strJobId=jID;
        //String strUserId=u.FederationIdentifier;    
        String strUserId=css_utility.getFederationId(Userinfo.getUserId());
        system.debug('strUserId'+strUserId);
        String strToolName='CSS';

if (strUserId==null || strUserId=='')
        {
         strUserId='NA';
        }
        
        Blob sESN = Blob.Valueof(strESN);
        Blob sJobId = Blob.Valueof(strJobId);
        Blob sUserid = Blob.Valueof(strUserId);
        Blob sToolName = Blob.Valueof(strToolName);
            
        Blob sConcStr = Blob.valueOf(strESN+strJobId+strToolName+strUserId);
        
        String password = CSS_getConnnectionDetails.getConnection('CDDashbrd').Passcode__c; //'11506891751244444444';
        String salt =  CSS_getConnnectionDetails.getConnection('CDDashbrd').Key__c; //'23143546777777777777777';
        String strURL = CSS_getConnnectionDetails.getConnection('CDDashbrd').End_Point__c;
            
        //Blob key = crypto.generateMac('HmacSHA1',Blob.valueOf(salt), Blob.valueOf(password));
        //Blob key = EncodingUtil.base64Decode('mRMjHmlC1C+1L/Dkz8EJuw==');
        
            Blob key = EncodingUtil.base64Decode(password+salt);
        
            //System.debug('key'+key);
        
        Blob cTESN = Crypto.encryptWithManagedIV('AES256', key, sESN);
        Blob cTjobId = Crypto.encryptWithManagedIV('AES256', key, sJobId);
        Blob cTuserId = Crypto.encryptWithManagedIV('AES256', key, sUserid);
        Blob cCancStr = Crypto.encryptWithManagedIV('AES256', key, sConcStr);
            
        String encodedCipherTextesn = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cTESN),'UTF-8'); 
        String encodedCipherTextjid = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cTjobId),'UTF-8'); 
        String encodedCipherTextuid = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cTuserId),'UTF-8'); 
        String encodedCipherTextarg5 = EncodingUtil.urlEncode(EncodingUtil.base64Encode(cCancStr),'UTF-8'); 
            
        //DashboardURL = 'https://connectedsolutions-stg.cummins.com/Services/getServiceEventDashboard1.do?arg1='+encodedCipherTextesn+'&arg2='+encodedCipherTextjid+'&arg3=CSS&arg4='+encodedCipherTextuid+'&arg5='+encodedCipherTextarg5; 
        DashboardURL = strURL+'?arg1='+encodedCipherTextesn+'&arg2='+encodedCipherTextjid+'&arg3=CSS&arg4='+encodedCipherTextuid+'&arg5='+encodedCipherTextarg5; 
        System.debug('DashboardURL?'+DashboardURL);
        
        return DashboardURL;
    }
    
}