@istest
public class OSM_PopulateAccountGroups_Test {
      static testMethod void testMethod1() 
    {
        List<Account> lstAccount= new List<Account>();
        for(Integer i=0 ;i <200;i++)
        {  
        
            Account acc = new Account();
            acc.Name ='Name'+i;
            //acc.RecordType.Name='IAM';
            lstAccount.add(acc);
        }
        
        insert lstAccount;
        
        Test.startTest();

            OSM_PopulateAccountGroups obj = new OSM_PopulateAccountGroups();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }


}