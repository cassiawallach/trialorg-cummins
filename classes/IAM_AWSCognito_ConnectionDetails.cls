/*Return Connection Details of AWS Cognito Service */
public class IAM_AWSCognito_ConnectionDetails {
    
    /* Return connection details */
    public static CSS_Integration_Details__c getConnection(string appName){
        Blob key = Crypto.generateAesKey(256);
        String algo = 'AES256';
        CSS_Integration_Details__c inteDetails = new CSS_Integration_Details__c(); 
        System.debug('#### appName '+appName);
        CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(appName);
        system.debug('#### conDetails '+conDetails);
        if(conDetails != null && conDetails.IsActive__c == true) {
            inteDetails.Name = conDetails.Name;
            inteDetails.ApplicationName__c = conDetails.ApplicationName__c;
            inteDetails.End_Point__c = conDetails.End_Point__c;
            inteDetails.IsActive__c = conDetails.IsActive__c;
            Blob encryptedKey;
            Blob encryptedPasscode;
            if(String.isNotBlank(conDetails.Key__c)) {
                encryptedKey = Crypto.encryptWithManagedIV(algo, key, Blob.valueOf(conDetails.Key__c));
                inteDetails.Key__c = Crypto.decryptWithManagedIV(algo, key, encryptedKey).toString();
            }
            if(String.isNotBlank(conDetails.Passcode__c)) {
                encryptedPasscode = Crypto.encryptWithManagedIV(algo, key, Blob.valueOf(conDetails.Passcode__c));
                inteDetails.Passcode__c = Crypto.decryptWithManagedIV(algo, key, encryptedPasscode).toString();
            }            
            inteDetails.Method_Type__c = conDetails.Method_Type__c;
            inteDetails.Resource__c=conDetails.Resource__c;
            System.debug('#### inteDetails ' + inteDetails);
            return inteDetails;
        } else {
            return null;
        }
    }
}