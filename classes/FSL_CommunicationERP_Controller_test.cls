/*
Class Name : FSL_CommunicationERP_Controller_test 
Description: This class is the Test class for FSL_CommunicationERP_Controller
Created By : Madhavi P
JIRA Story : FBI-83
18-11-2021 - Madhavi P - Created this class
*/
@isTest
public class FSL_CommunicationERP_Controller_test {
    public static testMethod void getallWorkorders() {
        
        Case newCase = new Case();
        newCase.Subject = 'Unittest';
        newCase.Status = 'New';
        insert newCase; 
        
        FSL_CommunicationERP_Controller controller = new FSL_CommunicationERP_Controller();
        controller.conId = newCase.Id;
        controller.getNightlycommlist();
        
    }
}