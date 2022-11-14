public class CSS_getConnnectionDetails {
    public static CSS_Integration_Details__c getConnection(string appName){
        System.debug('in getConnection appName:'+appName);
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        System.debug('Application Name is '+appName);
      /*  List<CSS_Integration_Details__c> conDetails = new List<CSS_Integration_Details__c>([select Name,ApplicationName__c,End_Point__c,IsActive__c,
                                                                                            Key__c,
                                                                                            Passcode__c,
                                                                                            Username__c 
                                                                                            from CSS_Integration_Details__c where ApplicationName__c=:appName AND IsActive__c = true limit 1]);
                                                                                    */
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(appName);
        system.debug('getting app'+conDetails);
        try{
        if(conDetails != null && conDetails.IsActive__c == true)
        {
            inteDetails.Name = conDetails.Name;
            inteDetails.ApplicationName__c = conDetails.ApplicationName__c;
            inteDetails.End_Point__c = conDetails.End_Point__c;
            inteDetails.IsActive__c = conDetails.IsActive__c;
            inteDetails.Key__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Key__c)).toString();
            inteDetails.Passcode__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Passcode__c)).toString();
            inteDetails.Username__c = Crypto.decryptWithManagedIV(algo, key, EncodingUtil.base64Decode(conDetails.Username__c)).toString();
            inteDetails.AuthEnv__c = conDetails.AuthEnv__c; // Added for Dynamic Authenctication
            inteDetails.Method_Type__c = conDetails.Method_Type__c;
            System.debug('returning inteDetails:'+appName);
            return inteDetails;
        }
        else
            return null;
        }
        catch(exception e){
            system.debug('Entered into catch block of getConnection method in CSS_getConnnectionDetails class' + e.getMessage() + ' *****' + e.getLineNumber());
            return null;
        }
    }
    
}