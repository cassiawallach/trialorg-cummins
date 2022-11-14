public class fsl_cssp_contactController {
    @AuraEnabled(cacheable=true)
    public static Case updateServiceReq(string caseId){
        system.debug('entered into save'+userinfo.getUserId());
         Case cs = [Select id,Location__c from Case where id=:caseId];
        // cs.Location__c = locValues[0] + ' ' + locValues[1] + ' '+ locValues[2] + ' '+ locValues[3] + ' '+ locValues[4];
        // update cs;
        // system.debug('entered into save'+cs);
        return cs;
         
     }
     @AuraEnabled 
     public static void updateServiceReqContact(string caseId,contact con){
        system.debug('entered into save');
         Case cs = [Select id,Location__c from Case where id=:caseId];
         cs.Contact = con;
         update cs;
         system.debug('entered into save'+cs);
         
     }
    
     @AuraEnabled
     public static void updateContactPhone(string conId, string phonenumber){
        system.debug('entered into save'+conId+'------ '+phonenumber);
        // string contid = conId;
     
         string contid = conId.replace('"','');
        
         contact cs = [Select id, phone from contact where id= :contid];
         cs.phone = phonenumber;
         update cs;
         system.debug('entered into save'+cs);
        
     }
    
    
     @AuraEnabled 
     //public static List<case> updateContact(string serviceReqId,string assetId,string fname,string lname,string email,string mobileno){
     // public static List<case> updateContact(string serviceReqId,string assetId,string conId){
        public static List<ServiceReqWrapper> updateContact(string serviceReqId){
          List<ServiceReqWrapper> serReqList = new List<ServiceReqWrapper>();
         system.debug('serviceReqId<>'+serviceReqId);
       
        // String caseId;
        List<Case> cs ;
         try {          
           // caseId = serviceReqId;
            /*contact cont = new contact();
            cont.FirstName = fname;
            cont.LastName = lname;
            cont.Email = email;
            cont.MobilePhone = mobileno;
            insert cont;
            system.debug('cont'+cont);
            system.debug('cont'+cont.Id);*/
            cs = [Select id,CaseNumber,CreatedDate,AssetId,Asset.Unit_Number__c,Asset.Name,General_Symptoms__c,Description,Unit_Number__c,Location__c,ContactId from Case where id=:serviceReqId];
           // if(conId!=null && assetId!=null){
            /* cs[0].ContactId = conId;
             cs[0].AssetId= assetId;
             update cs;*/
             system.debug('csasset'+cs[0].AssetId);
             system.debug('assetname'+cs[0].Asset.Name);
             ServiceReqWrapper serReq = new ServiceReqWrapper();
             serReq.AssetName = cs[0].Asset.Name;
            // serReq.AssetUnitNumber = cs[0].Asset.Unit_Number__c; //Commented the line, new line added below
             serReq.AssetUnitNumber = cs[0].Unit_Number__c;//Fetching the Unit Number from Case and assigning to wrapper
             serReq.CaseNumber = cs[0].CaseNumber;
             serReq.GeneralSymptom = cs[0].Description;
             serReq.Location = cs[0].Location__c;             
             String dateTimeStr = cs[0].CreatedDate.format('MMM dd YYYY');
             serReq.CreateDate = dateTimeStr;
             serReq.Id = cs[0].Id;
             system.debug('serReq<>'+serReq);
             serReqList.add(serReq);
             system.debug('serReqList<>'+serReqList);
          //  }
            
           
             
         } catch (Exception e) {
             System.debug(e.getMessage() + e.getLineNumber() + e.getCause());
             
         }
        // return cs;
        return serReqList;
      
       

       //return cont;

         
         
     }
     public class ServiceReqWrapper{
      @AuraEnabled 
      public String Id{get;set;}
      @AuraEnabled 
      public String AssetUnitNumber{get;set;}
      @AuraEnabled 
      public String AssetName{get;set;}
      @AuraEnabled 
      public String Location{get;set;}
      @AuraEnabled 
      public String GeneralSymptom{get;set;}
      @AuraEnabled 
      public String CaseNumber{get;set;}
      @AuraEnabled 
      public String CreateDate{get;set;}
  }
}