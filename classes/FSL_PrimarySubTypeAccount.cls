/*****************************************************************************************************************************
Name : FSL_PrimarySubTypeAccount 
Description : Work Order object Trigger Handler
Description2 : use this handler to create Primary Account and Primary Subtype

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  11/02/2021                Raghav Bansal               handler to create Primary Account and Primary Subtype 
2.0                  02/25/2022                Raghav Bansal                For MoveX UK we should only create Additional Account..
																			For MoveX we should only create Additional Subtype.
******************************************************************************************************************************/
public class FSL_PrimarySubTypeAccount {
 
    public static void createPrimarySubType(list <workorder> triggernew, Map<Id,workorder> newMap, map<id,workorder>oldmap){
        map <id,string> mSubtype = new map<id,string>();
        map <id,string> mAccount = new map<id,string>();
        boolean subTypeExist = false;
        boolean accountExist = false;
        boolean isDealer = false;
        for(workorder workorderObj: [SELECT Id,type__c, FSL_Sub_Type__c, FSL_Sub_Type__r.Name,FSL_Sub_Type__r.Branch_Code__c, Payer__c, Payer__r.Name,Payer__r.FSL_ERP_Customer_Code__c,ERP__c FROM workorder WHERE Id IN : newMap.KeySet()]){
            if(workorderObj.type__c == 'Dealer'){
                isDealer = true;
            }
            if(workorderObj.FSL_Sub_Type__c != null)
                mSubtype.put(workorderObj.FSL_Sub_Type__c, '010-'+workorderObj.FSL_Sub_Type__r.Name);
            if(workorderObj.Payer__c != null)
                mAccount.put(workorderObj.Payer__c,   '001-'+ workorderObj.Payer__r.FSL_ERP_Customer_Code__c +':'+ workorderObj.Payer__r.Name);
        }
        if(!isDealer){
            list <FSL_Additional_Sub_Type__c > additionaSubTypeList = new list<FSL_Additional_Sub_Type__c >(); // list to upsert
            for (workorder workorderObj : triggernew){
                 //MV-239 Raghav
   				if (String.isNotBlank(workorderObj.ERP__c) &&  workorderObj.ERP__c == 'MOVEX'  && workorderObj.FSL_Sub_Type__c!=null && (oldmap==null || workorderObj.FSL_Sub_Type__c != oldmap.get(workorderObj.id).FSL_Sub_Type__c)){
                    subTypeExist = true;
                    FSL_Additional_Sub_Type__c additional_Sub_Type = new FSL_Additional_Sub_Type__c();
                    additional_Sub_Type.Service_Order__c = workorderObj.id;
                    additional_Sub_Type.ERP_Job_Line_Number__c = '010';
                    additional_Sub_Type.name = mSubtype.get(workorderObj.FSL_Sub_Type__c);
                    additional_Sub_Type.Sub_Type__c = mSubtype.containsKey(workorderObj.FSL_Sub_Type__c) ? mSubtype.get(workorderObj.FSL_Sub_Type__c).split('-')[1] : null;
                    additional_Sub_Type.Primary__c = true;
                    additionaSubTypeList.add(additional_Sub_Type);
                }
                //MV-239 Raghav
  				if (String.isNotBlank(workorderObj.ERP__c) &&  workorderObj.ERP__c == 'MOVEX-UK' && workorderObj.payer__c!=null && (oldmap==null || workorderObj.payer__c != oldmap.get(workorderObj.id).payer__c)){ 
                    accountExist = true;
                    FSL_Additional_Sub_Type__c additional_Sub_Type = new FSL_Additional_Sub_Type__c();
                    additional_Sub_Type.Service_Order__c = workorderObj.id;
                    additional_Sub_Type.Assignment_Number__c = '001';
                    additional_Sub_Type.name = mAccount.get(workorderObj.payer__c);
                    additional_Sub_Type.Payer_Account__c = mAccount.containsKey(workorderObj.payer__c) ? mAccount.get(workorderObj.payer__c).split(':')[1] : null;
                    additional_Sub_Type.Primary__c = true;
                    additionaSubTypeList.add(additional_Sub_Type);
                }  
            }
            
            List<FSL_Additional_Sub_Type__c> updateSubType = new List<FSL_Additional_Sub_Type__c>();
            for(FSL_Additional_Sub_Type__c additional_Sub_Type : [SELECT Id,Assignment_Number__c,ERP_Job_Line_Number__c,Sub_Type__c,Payer_Account__c, Primary__c  FROM FSL_Additional_Sub_Type__c WHERE (ERP_Job_Line_Number__c = '010' or Assignment_Number__c = '001') AND Service_Order__c IN : triggernew]){
                if(accountExist && String.isNotBlank(additional_Sub_Type.Assignment_Number__c) && additional_Sub_Type.Assignment_Number__c == '001'){
                    additional_Sub_Type.Assignment_Number__c = '';
                    additional_Sub_Type.Payer_Account__c = '';
                    additional_Sub_Type.Primary__c = false;
                    updateSubType.add(additional_Sub_Type);
                }
                if(subTypeExist && String.isNotBlank(additional_Sub_Type.ERP_Job_Line_Number__c) && additional_Sub_Type.ERP_Job_Line_Number__c == '010'){
                    additional_Sub_Type.ERP_Job_Line_Number__c = '';
                    additional_Sub_Type.Sub_Type__c ='';
                    additional_Sub_Type.Primary__c = false;
                    updateSubType.add(additional_Sub_Type);
                }
            }
            
            
            if(!additionaSubTypeList.isEmpty())
                insert additionaSubTypeList ;
       
       
            if(!updateSubType.isEmpty())
                update updateSubType ;
             
            
        }
    }
    
}