@isTest
public class FSL_cssp_customersupportContollerTest 
{
   static testmethod void testGetMethods()
   {
       Test.startTest();
       String country='United States';
       List<FSL_Cummins_Care_Number__mdt> mdt = [ SELECT MasterLabel FROM FSL_Cummins_Care_Number__mdt LIMIT 1 ];
       FSL_cssp_customersupportController.getMetaData(country);
       FSL_cssp_customersupportController.fetchUser();
       Test.stopTest();
      
           }
}