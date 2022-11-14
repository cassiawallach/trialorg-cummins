@IsTest
public  class eVL_4C_Comp_Test 
{
        @IsTest public static void   TestUtilitiesWrapperClass()
    {
        String objectName  = 'WorkOrder';
        String fieldSetName  = 'EVL_4Cs';  
        
        List<eVL_4C_Comp.UtilitiesWrapperClass> wrapperList = new List<eVL_4C_Comp.UtilitiesWrapperClass>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
            eVL_4C_Comp.UtilitiesWrapperClass wrapper = new eVL_4C_Comp.UtilitiesWrapperClass();
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
        eVL_4C_Comp.getFieldSetMember( objectName, fieldSetName );
    }    
    @IsTest public static void   TestUtilitiesWrapperClass2()
    {
        string objectApiName = 'WorkOrder';
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectApiName);
        
        List<String> fieldSetList = new List<String>();
        
        for(Schema.FieldSet FS : sObj.getDescribe().fieldSets.getMap().values())
        {
            if(fs.getName() == 'EVL_4Cs')
            {
                fieldSetList.add(fs.getName());
                
                
            }
        }
        eVL_4C_Comp.getFieldSet(objectApiName);
    }
}