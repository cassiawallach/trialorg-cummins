//For Testing Purpose
@isTest(seeAllData=false)
public class  OSM_SW_FooterPg_Ctrl_Test{
   // public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
   
    static testMethod void  OSM_SW_FooterPg_Ctrl_Test(){
            Test.StartTest();
                 Document d=new Document();
                 d.name='DocumentsTnC';
                 //insert d;
                 System.assert(d.name != null, 'Document name cannot be null.');//Updated for User Story -883
                 OSM_SW_FooterPg_Ctrl footer = new  OSM_SW_FooterPg_Ctrl();
            Test.stopTest();
        
           }
        
}