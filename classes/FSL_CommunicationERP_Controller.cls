/*
Class Name : FSL_CommunicationERP_Controller
Description: This class is used for sending email template to contacts based on Case record from Vf template
Created By : Madhavi P
JIRA Story : FBI-83
18-11-2021 - Madhavi P - Created this class for sending email template to contacts based on Case record from Vf template
*/
public class  FSL_CommunicationERP_Controller {
    
    public Id conId {get; set;}  
    public String lang {get;set;}
    public list<Case> getNightlycommlist() {
        List<Case> nightlyCommunications = new List<Case>();
        if(conId != null) {
            nightlyCommunications = [select id, Communication_Type__c,Email_Communication_Trigger_Name__c,Language_Preference__c,  ServiceJob__r.CustomMessage__c, ServiceJob__r.Repair_Location__c, ServiceJob__r.ServiceTerritory.City, 
                                     ServiceJob__r.ServiceTerritory.State, ServiceJob__r.ServiceTerritory.Phone__c,  ServiceJob__r.Service_Team_Contact__r.Name, 
                                     ServiceJob__r.Service_Team_Contact__r.Email, ServiceJob__r.Repair_Site_Address__r.Street, ServiceJob__r.Repair_Site_Address__r.City, 
                                     ServiceJob__r.Repair_Site_Address__r.State, ServiceJob__r.Repair_Site_Address__r.PostalCode, ServiceJob__r.WorkOrderNumber, 
                                     ServiceJob__r.Unit_Number_Formula__c, ServiceJob__r.Make__c, ServiceJob__r.Model__c, ServiceJob__r.Engine_Serial_Number__c, 
                                     ServiceJob__r.Vehicle_Identification_Number__c, ServiceJob__r.Registration__c, National_Account_Update__c 
                                     FROM case 
                                     WHERE id =:conId ];
            if(nightlyCommunications != null) {
                lang = nightlyCommunications[0].Language_Preference__c;
            }
        }
        return nightlyCommunications;
    }
    
    
}