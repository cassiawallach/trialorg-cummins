public class CSS_IntegrationAdminController {
    public String selectedValue{set;get;}
    public List<selectoption> integrList {set;get;}
    public boolean errorMsg{get;set;}    
    public List<CSS_Integration_Details__c> recordList{set;get;}
    public CSS_Integration_Details__c record{set;get;}
    public Boolean viewMode{set;get;}
    public Boolean editMode{set;get;}
    public Blob key;
    
    public CSS_IntegrationAdminController(){
        viewMode = true;
        editMode = false;
        queryDB();
        key = Blob.valueOf('12345678901234567890123456789012');
    }  
    public pageReference getValues(){
        queryDB();
        editMode = false;        
        if(selectedValue!='--Select--'){
            for(CSS_Integration_Details__c rec:recordList){               
                if(rec.Id == selectedValue){
                    record = rec;
                    viewMode = true;
                }
            } 
        }
        else{
            errorMsg=false;
        }
        return null;
    }    
    public void queryDB(){
        integrList=new List<selectoption>();    
        //String qryString = 'Select Id,Name,ApplicationName__c,End_Point__c,IsActive__c,Key__c,Passcode__c,Username__c, from CSS_Integration_Details__c Limit 100';
        //String qryString = 'Select Id,Name,ApplicationName__c,End_Point__c,IsActive__c,Key__c,grant_type__c,Passcode__c,Username__c,Logging__c,Method_Type__c,Timeout__c,AuthEnv__c from CSS_Integration_Details__c Limit 200'; //Generic Service Changes //Mule Integration:Modified the limit from 100 to 150, as some of the services are not visible in the dropdown
        String qryString = 'Select Id,Name,ApplicationName__c,End_Point__c,IsActive__c,Key__c,grant_type__c,Passcode__c,Username__c,Logging__c,Method_Type__c,Timeout__c,AuthEnv__c from CSS_Integration_Details__c order by ApplicationName__c ASC Limit 500'; //Generic Service Changes //Mule Integration:Modified the limit from 100 to 150, as some of the services are not visible in the dropdown
        recordList=Database.query(qryString);
        integrList.add(new selectoption('--Select--','--Select--'));   
        for(CSS_Integration_Details__c rec:recordList){
            integrList.add(new selectoption(rec.Id,rec.ApplicationName__c));
        }                   
        errorMsg=false;        
    }    
    public void editRecord(){
        try{
            editMode = true;
            viewMode = false;
            record.Key__c = Crypto.decryptWithManagedIV('AES256', key, EncodingUtil.base64Decode(record.Key__c)).toString();
            record.Passcode__c = Crypto.decryptWithManagedIV('AES256', key, EncodingUtil.base64Decode(record.Passcode__c)).toString();
            record.Username__c = Crypto.decryptWithManagedIV('AES256', key, EncodingUtil.base64Decode(record.Username__c)).toString();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+e));
        }
    }
    public void deleteRecord(){
        try{
            delete record;
            selectedValue = '--Select--';
            getValues();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+e));
        }        
    }
    public void saveRecord(){
        try{
            if(record.Name == null) record.Name = record.ApplicationName__c;
            record.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(record.Key__c)));
            record.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(record.Passcode__c)));
            record.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf(record.Username__c)));
            upsert record;
            selectedValue = record.Id;
            getValues();
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error: '+e));
        }             
    }
    public void cancelSave(){
        getValues();      
    }
    public void newRecord(){
        record = new CSS_Integration_Details__c();
        editMode = true;
        viewMode = false;
    }
}