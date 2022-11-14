public class IAM_getDependentValues {

public class MyPickListInfo {
      public String validFor;
   } 
   
public static Map<String, List<String>> getFieldDependencies(String objectName, String controllingField, String dependentField) {
    Map<String, List<String>> controllingInfo = new Map<String, List<String>>();

    Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);

    Schema.DescribeSObjectResult describeResult = objType.getDescribe();
    Schema.DescribeFieldResult controllingFieldInfo = describeResult.fields.getMap().get(controllingField).getDescribe();
    Schema.DescribeFieldResult dependentFieldInfo = describeResult.fields.getMap().get(dependentField).getDescribe();

    List<Schema.PicklistEntry> controllingValues = controllingFieldInfo.getPicklistValues();
    List<Schema.PicklistEntry> dependentValues = dependentFieldInfo.getPicklistValues();

    for(Schema.PicklistEntry currControllingValue : controllingValues)
    {
        System.debug('ControllingField: Label:' + currControllingValue.getLabel());
        controllingInfo.put(currControllingValue.getLabel(), new List<String>());
    }
    
    System.debug('ControllingInfo: ' + controllingInfo);
     for(Schema.PicklistEntry currDependentValue : dependentValues)
    {
        String jsonString = JSON.serialize(currDependentValue);

        MyPickListInfo info = (MyPickListInfo) JSON.deserialize(jsonString, MyPickListInfo.class);

        String hexString = EncodingUtil.convertToHex(EncodingUtil.base64Decode(info.validFor)).toUpperCase();

        System.debug('DependentField: Label:' + currDependentValue.getLabel() + ' ValidForInHex:' + hexString + ' JsonString:' + jsonString);

        Integer baseCount = 0;

        for(Integer curr : hexString.getChars())
        {
            Integer val = 0;

            if(curr >= 65)
            {
                val = curr - 65 + 10;
            }
            else
            {
                val = curr - 48;
            }

            if((val & 8) == 8)
            {
                System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 0].getLabel());
                controllingInfo.get(controllingValues[baseCount + 0].getLabel()).add(currDependentValue.getLabel());
            }
            if((val & 4) == 4)
            {
                System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 1].getLabel());
                controllingInfo.get(controllingValues[baseCount + 1].getLabel()).add(currDependentValue.getLabel());                    
            }
            if((val & 2) == 2)
            {
                System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 2].getLabel());
                controllingInfo.get(controllingValues[baseCount + 2].getLabel()).add(currDependentValue.getLabel());                    
            }
            if((val & 1) == 1)
            {
                System.debug('Dependent Field: ' + currDependentValue.getLabel() + ' Partof ControllingField:' + controllingValues[baseCount + 3].getLabel());
                controllingInfo.get(controllingValues[baseCount + 3].getLabel()).add(currDependentValue.getLabel());                    
            }

            baseCount += 4;
        }            
    } 
    System.debug('ControllingInfo:Final*****' + controllingInfo);
     List<String> SelectedValueRoles = controllingInfo.get('Market Place');
    System.debug('Market Place Values------' +SelectedValueRoles );
    return controllingInfo;
  }
 
 
}