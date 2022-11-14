@RestResource(urlMapping='/IAMaccount')
global class IAM_AccountCreation {
    
    //==============================================================================================
    // *** REST Post *** :  Requires the cummins customer id of Account and reutrn results as Response Type
    //===============================================================================================
    @HttpPost
    global static CMI_ResponseHandler Post(LocationPayloadInfo LocationPayloadInfo)
    {
        system.debug('request====' + LocationPayloadInfo);
                                
        RestRequest req = RestContext.request;
        CMI_ResponseHandler response = new CMI_ResponseHandler();
         
         //Getting TSP deatils for Update
         
        string Fieldname = ValidateRequest(LocationPayloadInfo);
        system.debug('Fieldname====' + Fieldname);
          List<Account> accntDist= new List<Account>();
          
          Map<String,String> region=new Map<String,String>();
        region.put('1','US and Canada');
        region.put('3','Europe');
        region.put('4','Africa');
        region.put('5','Middle East');
        region.put('6','Latin America');
        region.put('8','Mexico');
        region.put('10','Southeast Asia');
        region.put('11','South Pacific');
        region.put('12','East Asia');
        region.put('13','India');
        region.put('15','CIS');
        region.put('16','Japan');
        region.put('17','Korea');
        if(Fieldname == '')
        {
            accntDist=[Select id,name,parentid,ownerid from Account where IAM_Service_Provider_Code__c=:LocationPayloadInfo.distributorCode LIMIT 1];
            
            try
            {
                Savepoint sp = Database.setSavepoint(); 
                  Account accObj = new Account();
                    
               try{
              if(!accntDist.isEmpty()){
              //Assigning parent id.
              System.debug('Printing parent id'+accntDist[0].id);
                  accObj.parentid=accntDist[0].id;
              }
                
                accObj.Ownerid=accntDist[0].ownerid;
                accObj.Name = LocationPayloadInfo.name;
                accObj.BillingCountryCode= LocationPayloadInfo.countryName;
                accObj.CSS_Language__c = LocationPayloadInfo.language;
                accObj.CMI_Region__c = LocationPayloadInfo.region;
                accObj.BillingStreet = LocationPayloadInfo.addressLine1;
                accObj.CMI_Address2__c = LocationPayloadInfo.addressLine2;
               
                accObj.BillingCity = LocationPayloadInfo.city;
                accObj.BillingState = LocationPayloadInfo.stateName;
                accObj.BillingPostalCode = LocationPayloadInfo.zipCode; 
                if(LocationPayloadInfo.accountSource.equalsIgnoreCase('WWSPS')){
                    accObj.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('WWSPS').getRecordTypeId();
                    accObj.IAM_For_W_Code_Creation_From_WWSPS__c=True;
                }else {
                    accObj.RecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
                }                
                
                accObj.Type=LocationPayloadInfo.type;
               // accObj.IAM_ABO_code__c=LocationPayloadInfo.aboCode;
                accObj.CMI_Account_Status__c=LocationPayloadInfo.accountStatus;
                accObj.AccountSource=LocationPayloadInfo.accountSource;
                accObj.CSS_DistributorCode__c=LocationPayloadInfo.distributorCode;
                if(!region.isEmpty()){
                    if(region.ContainsKey(LocationPayloadInfo.aboCode)){
                        accObj.IAM_WWSPS_Regions__c=region.get(LocationPayloadInfo.aboCode);
                    }
                }   
               //accObj.parent=accntDist;
                System.debug('Account insert'+accObj);
                insert accObj;
                //end of Account insertion
                    

                    response.Message = 'Inserted Successfully';
                    response.StatusCode = '200';
                response.Status = 'Success';
                Account a=[Select id,IAM_Service_Provider_Code__c from Account where id=:accObj.id LIMIT 1];

                response.message='Service Provide code-'+a.IAM_Service_Provider_Code__c;
                response.Data = null;
               
                 }
           catch (System.DmlException e) {
            cmiError(e.getMessage());
             
          //return response;
                system.debug('DmlException====' + e);
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                Database.rollback(sp);
                return response;
            // return null;
             }  
                 
           
            }
            catch (System.DmlException e) {
            cmiError(e.getMessage());
          
                
                response.StatusCode = '404';
                response.Status = 'error';
                response.Data = null;
                for (Integer i = 0; i < e.getNumDml(); i++) {
                    // Process exception here
                    response.Message =  e.getDmlMessage(i); 
                }
                
            }            
        }
        else
        {
            response.StatusCode = '404';
            response.Status = 'error';
            response.Data = null;
            string tspexist = '';            
            response.Message = 'Fail : ' + Fieldname;
            
        }
        return response;
    }
    
    private static string ValidateRequest(LocationPayloadInfo locationPayloadObj)
    {
        string Fieldname = '';
   
        
       
        if(locationPayloadObj.name == null || locationPayloadObj.name.trim() == '')
        {
            Fieldname = Fieldname + 'name is required, ';
         }
        if(locationPayloadObj.CountryName == null || locationPayloadObj.CountryName.trim() == '')
        {
            Fieldname = Fieldname + 'CountryName is required, ';
        }
      /*  if(locationPayloadObj.CountryName != null && locationPayloadObj.CountryName.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('BillingCountryCode','Account');
        System.debug('***************'+tmplist );
         String s=(locationPayloadObj.CountryName).tolowercase();
            String s1=s.subString(0 ,1).ToUpperCase()+s.subString(1);
            Boolean result = tmplist.equals(locationPayloadObj.CountryName);
            system.debug('Country name'+result);
             if(!tmplist.contains(locationPayloadObj.CountryName.tolowercase()))
            {
                Fieldname = Fieldname + 'Provide a valid CountryName, ' ;
            }
            
        }*/
       
        
        if(locationPayloadObj.AddressLine1 == null || locationPayloadObj.AddressLine1.trim() == '')
        {
            Fieldname = Fieldname + ' AddressLine1 is required, ';
        }
        if(locationPayloadObj.City == null || locationPayloadObj.City.trim() == '')
        {
            Fieldname = Fieldname + 'City is required, ';
        }
        if(locationPayloadObj.StateName == null || locationPayloadObj.StateName.trim() == '')
        {
                Fieldname = Fieldname + 'StateName is required';
        }
        {
       /* if(locationPayloadObj.StateName != null && locationPayloadObj.StateName.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('BillingStateCode','Account');
            System.debug('***************'+tmplist );
            String s=(locationPayloadObj.StateName).tolowercase();
            String s1=s.subString(0 ,1).ToUpperCase()+s.subString(1);

            system.debug('state'+s1);
            
            if(!tmplist.contains(s1.tolowercase()))
            {
                Fieldname = Fieldname + 'Provide a valid StateName,' ;
            }
        }*/
     
        }
        if(locationPayloadObj.Zipcode == null || locationPayloadObj.Zipcode.trim() == '')
        {
            Fieldname = Fieldname + 'Zipcode is required, ';
        }
        if(locationPayloadObj.region == null || locationPayloadObj.region.trim() == '')
        {
            Fieldname = Fieldname + 'region is required, ';
        }
         if(locationPayloadObj.region != null && locationPayloadObj.region.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CMI_Region__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(locationPayloadObj.region))
            {
                Fieldname = Fieldname + 'Provide a valid Region,' ;
            }
        }
        
        if(locationPayloadObj.language == null || locationPayloadObj.language.trim() == '')
        {
            Fieldname = Fieldname + 'language is required, ';
        }
         if(locationPayloadObj.language != null && locationPayloadObj.language.trim() != '')
        {
            Set<string> tmplist = getPicklistValues('CSS_Language__c','Account');
            System.debug('***************'+tmplist );
            if(!tmplist.contains(locationPayloadObj.language))
            {
                Fieldname = Fieldname + 'Provide a valid language,' ;
            }
        }
        if(locationPayloadObj.accountStatus == null || locationPayloadObj.accountStatus.trim() == '')
        {
            Fieldname = Fieldname + 'Location Status is required,';
        }
        if(locationPayloadObj.distributorCode == null || locationPayloadObj.distributorCode.trim() == '')
        {
            Fieldname = Fieldname + 'Distributor Code is required,';
        }
        if(locationPayloadObj.distributorCode != null && locationPayloadObj.distributorCode.trim() != '')
        {
            //Query on the Account aobject to get the Distributor Information
            List<Account> Dist=[Select id,Name,parentid,ownerid from Account where CSS_DIstributorCode__c=:locationPayloadObj.distributorCode LIMIT 1];
            if(Dist.isEmpty()){
                Fieldname = Fieldname + 'Distributor is not Present in the System,';
            }
            
        }
        if(locationPayloadObj.type == null || locationPayloadObj.type.trim() == '')
        {
            Fieldname = Fieldname + 'Location Type is required,';
        }
        if(locationPayloadObj.aboCode == null || locationPayloadObj.aboCode.trim() == '')
        {
            Fieldname = Fieldname + 'ABO code is required,';
        }
        return Fieldname ;
    }
    public static Boolean validateEmail(List<String> lstemails) {      
        Boolean res = true;
        
                
             
        system.debug('lstemails==' + lstemails);        
        for(string email: lstemails)        
        {
            system.debug('email==' + email); 
            String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
            Pattern MyPattern = Pattern.compile(emailRegex);        
            Matcher MyMatcher = MyPattern.matcher(email);       
            if (!MyMatcher.matches())       
                res = false;        
            
system.debug('res==' + res);            
        }       
        system.debug('res==' + res);        
        return res;         
                    
                
        }    

    
    //Adding custom Exception sub-class 
    public class NoRecordMatchException extends Exception {}    
    
    public static void cmiError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
        errObj.Source__c='CS';
        errObj.Error_Description__c = msg;
        
        errObj.Source__c='IDENTITY';
       
       errObj.Error_Description__c = msg;
       errObj.Processed_Data__c=msg;
        
        insert errObj;
    }
    global class CMI_ResponseHandler {
    
        //List of custom attributes that we want to check the status of the org
        public String Status {get; set;}
        public List<sObject> Data {get;set;}
        public String Message {get;set;}
        public String StatusCode {get; set;}
        
         
    }
    Public static Set<String> getPicklistValues(string fieldName,String objectName)
    {
        Set<String> setPickvals=new Set<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(objectName);
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType();
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe();
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap();
        List<Schema.PicklistEntry> pick_list_values = field_map.get(fieldName).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a : pick_list_values) { 
        if(fieldName == 'BillingCountryCode' || fieldName=='BillingStateCode'){
            //System.debug('Printing value getting added in State and Country'+a.getLabel().tolowercase());
            setPickvals.add(a.getLabel().tolowercase());
        }else{  
          setPickvals.add(a.getLabel());
       }
       }
          return setPickvals;
    }
    global class LocationPayloadInfo{
           
             
             public string name{set;get;}
             public string countryName{set;get;}
             public string addressLine1{set;get;}
             public string addressLine2{set;get;}
             public string city{set;get;}
             public string stateName{set;get;}
             public string zipCode{set;get;}
             public string language{set;get;}
             public string region{set;get;}
             public string accountStatus{set;get;}
             public string distributorCode{set;get;}
             public string type{set;get;}
             public string aboCode{set;get;}   
             public string accountSource {set;get;}            
        }  
  

   

                   
}