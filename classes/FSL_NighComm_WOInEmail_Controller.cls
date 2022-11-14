/*
Class Name : FSL_NighComm_WOInEmail_Controller
Description: This class is used to refer in FSL_NightlyComm_WOEventInEmail.vfc visual force component to load respective work orders relaed to contactId
Created By : Madhavi P
JIRA Story : CT4-159
23-10-2020 - Madhavi P - Created this controller to load the all related work orders for this specific contact. 
*/
public class FSL_NighComm_WOInEmail_Controller {
    public Id conId {get; set;}  
    public String lang {get;set;}
    public list<FSL_Nightly_Communications__c> getNightlycommlist() {
        List<FSL_Nightly_Communications__c> nightlyCommunications = new List<FSL_Nightly_Communications__c>();
        if(conId != null) {
            nightlyCommunications = [SELECT id,User_date__c,Event__c, Nightly_Service_Teritory__c, Teritory_Branch_Phone__c,
                                        Service_Team_Contact__r.Name, STC_Email_Address__c, 
                                        Service_Order__r.WorkOrderNumber,Unit_Number__c,Make__c,Model__c,
                                        Asset__c,VIN__c,  Case_Thread_ID__c, contact__r.Lang_Pref_Code__c,
                                        event_formula__c,Createddate,Custom_Message__c,Nightly_Communication_Type__c,
                                        Service_Order__r.Registration__c,Service_Order__r.Repair_Location__c,
                                        Service_Order__r.Repair_Site_Address__r.Street,Service_Order__r.Repair_Site_Address__r.City,
                                        Service_Order__r.Repair_Site_Address__r.State,
                                        Service_Order__r.Repair_Site_Address__r.PostalCode,National_Account__c
                                    FROM FSL_Nightly_Communications__c 
                                    WHERE contact__c =:conId  AND Active__c = TRUE];
            if(nightlyCommunications != null) {
                lang = nightlyCommunications[0].Contact__r.Lang_Pref_Code__c;
            }
        }
        return nightlyCommunications;
    }
}