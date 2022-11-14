/******************************************************************************************
* Name      :    FSL_AddressUpdateTrigger
* Purpose   :    update address in service Appointment
* History   :
* Test class:    FSL_AddressUpdateTrigger_Test
------------------------------------------------------------------------------------------- 
* VERSION         AUTHOR             DATE             DETAIL 
* 1.0             Ravi Teja      14/01/2020       Initial Development
*******************************************************************************************/
trigger FSL_AddressUpdateTrigger on IAM_CDH_Cross_references__c (after update) 
{
    List<Id> IdList = new List<Id>();
    Map<Id,IAM_CDH_Cross_references__c> crossRefMap = new Map<Id,IAM_CDH_Cross_references__c>();
    Map<Id,Id> worksvsSiteMap = new Map<Id,Id>();
    List<ServiceAppointment> srAppointMentList = new List<ServiceAppointment>();
    
    for(IAM_CDH_Cross_references__c crossRef : Trigger.new)
    {
        IAM_CDH_Cross_references__c oldCrossRef = Trigger.oldMap.get(crossRef.Id);
        if((oldCrossRef.FSL_Address_Line_1__c !=crossRef.FSL_Address_Line_1__c ||
            oldCrossRef.FSL_Address_Line_2__c !=crossRef.FSL_Address_Line_2__c ||
            oldCrossRef.FSL_Address_Line_3__c !=crossRef.FSL_Address_Line_3__c ||
            oldCrossRef.FSL_City__c !=crossRef.FSL_City__c ||
            oldCrossRef.FSL_State__c !=crossRef.FSL_State__c ||
            oldCrossRef.FSL_Country__c !=crossRef.FSL_State__c ||
            oldCrossRef.FSL_Postal_Code__c !=crossRef.FSL_Postal_Code__c) //crossRef.Repair_Location__c == 'Mobile' 
            )
        {
            crossRefMap.put(crossRef.Id,crossRef);
            IdList.add(crossRef.Id);
        }
    }
    System.debug('IdList : ' + IdList);
    if(IdList != null && IdList.size()>0)
    {
        for(WorkOrder worder : [SELECT Id,Repair_Site_Name__c,Status FROM WorkOrder WHERE Repair_Site_Name__c IN:IdList AND Repair_Location__c = 'Mobile'])
        {
            if(worder.Status == 'Intake' || worder.Status == 'Scheduled')
            worksvsSiteMap.put(worder.Id,worder.Repair_Site_Name__c);
        }
    }
    System.debug('worksvsSiteMap : ' + worksvsSiteMap);
    if(!worksvsSiteMap.isEmpty())
    {
        for(ServiceAppointment srp : [SELECT Id,ParentRecordId,Status,street,City,State,PostalCode,Country FROM ServiceAppointment WHERE ParentRecordId IN:worksvsSiteMap.keySet()])
        {
            if(worksvsSiteMap.containsKey(srp.ParentRecordId) && srp.Status!= 'Dispatched')
            {
                Id crossId = worksvsSiteMap.get(srp.ParentRecordId);
                if(!crossRefMap.isEmpty() && crossRefMap.containsKey(crossId))
                {
                    IAM_CDH_Cross_references__c cros = crossRefMap.get(crossId);
                    srp.street = cros.FSL_Address_Line_1__c +' ' + cros.FSL_Address_Line_2__c;
                    srp.City = cros.FSL_City__c;
                    srp.State = cros.FSL_State__c;
                    srp.PostalCode = cros.FSL_Postal_Code__c;
                    srp.Country=cros.FSL_Country__c;
                    srAppointMentList.add(srp);
                    
                }
                
            }
        }
    }
    System.debug('srAppointMentList : ' + srAppointMentList);    
    if(srAppointMentList !=null && srAppointMentList.size()>0)
    {
        try{
            update srAppointMentList;
        }
        catch(Exception e)
        {
            System.debug('Something went wrong' + e.getMessage() + e.getLineNumber());
        }
    }
}