public with sharing class eVL_4C_Comp 
{
    @AuraEnabled(cacheable = true) 
    public static List<String> getFieldSet(String objectApiName){
      //  System.debug('@@@@objectApiName'+objectApiName);
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectApiName);
        List<String> fieldSetList = new List<String>();
        for(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values()){
            if(fs.getName() == 'EVL_4Cs'){
                fieldSetList.add(fs.getName());
              //  System.debug(fs.getFields());
          
            }
            
        }
       // System.debug('@@@@@@'+fieldSetList);
        return fieldSetList;
    }
    
    public class UtilitiesWrapperClass{
        
        @AuraEnabled
        public Boolean isDBRequired 					 { get; set; }
        @AuraEnabled
        public Boolean isRequired 						 { get; set; }
        @AuraEnabled
        public String fieldType 						 { get; set; }
        @AuraEnabled
        public String fieldLabel 						 { get; set; }
        @AuraEnabled
        public String fieldAPIName 					     { get; set; }
        @AuraEnabled 
        public List<Schema.PicklistEntry> pickListValues { get; set; }
        
    }
    
    @AuraEnabled(cacheable = true)
    public static String getFieldSetMember(String objectName , String fieldSetName){
        
        List<UtilitiesWrapperClass> wrapperList = new List<UtilitiesWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
            UtilitiesWrapperClass wrapper = new UtilitiesWrapperClass();
            wrapper.isDBRequired = fieldMember.getDbRequired();
            wrapper.isRequired = fieldMember.getRequired();
            wrapper.fieldType = String.valueOf(fieldMember.getType()); 
            wrapper.fieldLabel = fieldMember.getLabel();
            wrapper.fieldAPIName = fieldMember.getFieldPath();
            if(String.valueOf(fieldMember.getType()) == 'PICKLIST' || 
               				String.valueOf(fieldMember.getType()) == 'MULTIPICKLIST'){
                wrapper.pickListValues = sObj.getDescribe().fields.getMap().get(fieldMember.getFieldPath())
                    									   .getDescribe().getPicklistValues();
            }
            wrapperList.add(wrapper);
        }
        //System.debug('#### wrapperList '+wrapperList);JSON.serialize
        
        return JSON.serialize(wrapperList);
    }

    /*@auraEnabled
    public static void GetUrl()
    {
        String url =  ApexPages.currentPage().getUrl();
        system.debug('+++URL'+url);
    }*/
}