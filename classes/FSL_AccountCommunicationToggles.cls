public class FSL_AccountCommunicationToggles{

//Developer- Harini ShivKumar, Date: 03/12/2021, Track4 - CT4-195,  Default Communication Toggles on Account
@InvocableMethod (label='updateCommunicationToggles')
public Static void updateAccountCommToggles(List<Id> accIds){ 
    Set<String> ERPSystem = new Set<String>();
    Map<String,FSL_Communication_RegionToggles__mdt> metadataMap = new Map<String,FSL_Communication_RegionToggles__mdt>();
    /**List<Account> accList = [Select id,FSL_Source_ERP__c,Authorize_Work_Started__c,Equipment_Available__c,Invoice_Ready__c,
                             Service_Work_Completed__c,Troubleshooting_Started__c,Text_SMS_Notification_Frequency__c,
                             Email_Notification_Frequency__c from Account where
                             FSL_Source_ERP__c !=null AND
                             Authorize_Work_Started__c =false AND Equipment_Available__c =false AND
                             Invoice_Ready__c =false AND Service_Work_Completed__c=false AND
                             Troubleshooting_Started__c=false AND Id IN:accIds];*/

    //Developer- Harini ShivKumar, Date: 06/25/2021, Track4 - CT4-650,  Default Communication Language on Account

    List<Account> accList = [Select id,FSL_Source_ERP__c,Communication_Triggers__c,Text_SMS_Notification_Frequency__c,
                             Email_Notification_Frequency__c from Account where
                             FSL_Source_ERP__c !=null AND
                             Communication_Triggers__c =null AND Id IN:accIds];
    
    if(accList !=null && accList.size()>0){                         
    for(Account acc: accList){
        if((acc.FSL_Source_ERP__c !=null || acc.FSL_Source_ERP__c !='') && acc.Communication_Triggers__c==null){
            ERPSystem.add(acc.FSL_Source_ERP__c);
        } 
    }
    }
    if(!ERPSystem.isEmpty()){
       for(FSL_Communication_RegionToggles__mdt mtadata: [SELECT Id,DeveloperName, Label, Authorized_Work_Started__c,Equipment_Available__c,
                                                          ERP__c,Invoice_Ready__c,Service_Work_Completed__c,Troubleshooting_Started__c,Equipment_Ready_For_Pick_Up__c, Service_Work_Proceeding__c,
                                                          Text_Frequency__c,Email_Frequency__c
                                                          FROM FSL_Communication_RegionToggles__mdt where ERP__c IN:ERPSystem]){
                metadataMap.put(mtadata.ERP__c,mtadata);                                                       
                                                                    
        }
    }
    if(metadataMap !=null && accList !=null){
        for(Account acc: accList){
            List<String> commTriggermetaDataList = new List<String>();
            if(metadataMap.containsKey(acc.FSL_Source_ERP__c)){
                /**acc.Authorize_Work_Started__c = metadataMap.get(acc.FSL_Source_ERP__c).Authorized_Work_Started__c;
                    acc.Equipment_Available__c = metadataMap.get(acc.FSL_Source_ERP__c).Equipment_Available__c;
                    acc.Invoice_Ready__c = metadataMap.get(acc.FSL_Source_ERP__c).Invoice_Ready__c;
                    acc.Service_Work_Completed__c = metadataMap.get(acc.FSL_Source_ERP__c).Service_Work_Completed__c;
                    acc.Troubleshooting_Started__c = metadataMap.get(acc.FSL_Source_ERP__c).Troubleshooting_Started__c;*/
                if(metadataMap.get(acc.FSL_Source_ERP__c).Authorized_Work_Started__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Authorized_Work_Started);  
                if(metadataMap.get(acc.FSL_Source_ERP__c).Equipment_Available__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Equipment_Available);
                if(metadataMap.get(acc.FSL_Source_ERP__c).Invoice_Ready__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Invoice_Ready);
                if(metadataMap.get(acc.FSL_Source_ERP__c).Service_Work_Completed__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Service_Work_Completed);
                if(metadataMap.get(acc.FSL_Source_ERP__c).Troubleshooting_Started__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Troubleshooting_Started);
                if(metadataMap.get(acc.FSL_Source_ERP__c).Service_Work_Proceeding__c)
                    commTriggermetaDataList.add(Label.FSL_Service_work_Proceeding);
                    
                if(metadataMap.get(acc.FSL_Source_ERP__c).Equipment_Ready_For_Pick_Up__c)
                    commTriggermetaDataList.add(Label.FSL_CommTrigger_Equipment_ready_for_pickup);
                    
                if(commTriggermetaDataList !=null && commTriggermetaDataList.size()>0){
                    for(String st:commTriggermetaDataList){
                        if(acc.Communication_Triggers__c=='' || acc.Communication_Triggers__c==null)
                            acc.Communication_Triggers__c = st+';';  
                        else
                            acc.Communication_Triggers__c = acc.Communication_Triggers__c+';'+st;  
                    }
                    acc.Communication_Triggers__c = acc.Communication_Triggers__c.removeEnd(';');
                }
   //Developer- Harini ShivKumar, Date: 06/25/2021, Track4 - CT4-650,  Default Communication Language on Account
   
               if(acc.Text_SMS_Notification_Frequency__c =='None' || acc.Text_SMS_Notification_Frequency__c==null || acc.Text_SMS_Notification_Frequency__c=='')
                acc.Text_SMS_Notification_Frequency__c  = metadataMap.get(acc.FSL_Source_ERP__c).Text_Frequency__c;
               if(acc.Email_Notification_Frequency__c =='None' || acc.Email_Notification_Frequency__c ==null || acc.Email_Notification_Frequency__c =='')  
                acc.Email_Notification_Frequency__c  = metadataMap.get(acc.FSL_Source_ERP__c).Email_Frequency__c; 
            }
        }
        if(accList !=null && accList.size()>0){
        update accList;
        }
    }
} 
}