/************************************************************
Name:  IAM_getConnnectionDetails
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex class for IAM Project to get Ingegration details from the 
CSS remote connetions Custom Settings and return it to the respective integration Class.
this class will have a method which will accept a string which will be integration or application Name.This is class for IAM_Mule_oAuth_Access_Token class.This class is used for generating 
Access Token for Mule Services  2                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                DATE              DETAIL                                
1.0 -    Karthik Raj Golakaram     11/16/2018        INITIAL DEVELOPMENT
1.1 -    Karthik Raj Golakaram     11/16/2020     Added Resource Type field to the class fo Mule API      
*****************************************************/
/********************************************************************************
***********************************************************************************/
public class IAM_getConnnectionDetails {

    public static CSS_Integration_Details__c getConnection(string appName){
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        System.debug('Application Name is '+appName);
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(appName);
        system.debug('getting app'+conDetails);
        if(conDetails != null && conDetails.IsActive__c == true)
        {
            inteDetails.Name = conDetails.Name;
            inteDetails.ApplicationName__c = conDetails.ApplicationName__c;
            inteDetails.End_Point__c = conDetails.End_Point__c;
            inteDetails.IsActive__c = conDetails.IsActive__c;
            inteDetails.Key__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Key__c)).toString();
            inteDetails.Passcode__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Passcode__c)).toString();
            inteDetails.Username__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Username__c)).toString();
            //Added below two lines for IAM purpose by Karthik Golakaram
            inteDetails.Logging__c = conDetails.Logging__c;
            inteDetails.Method_Type__c = conDetails.Method_Type__c;
            inteDetails.AuthEnv__c= conDetails.AuthEnv__c;
            inteDetails.grant_type__c=conDetails.grant_type__c;
            inteDetails.Resource__c=conDetails.Resource__c;
            inteDetails.Timeout__c=conDetails.Timeout__c;
            //End of Addition 
            System.debug('Prinitng return Details'+inteDetails);
            return inteDetails;
        }
        else
            return null;
    }
}