@isTest
public class CG_ClaimsHeaderWrapperTest {
    
    static TestMethod void claimNewRec() {
        
        Test.startTest();
        CSS_Claims__c claimRec= new CSS_Claims__c();
        
        claimRec.Customer_Name__c = 'Test Ridhima';
        claimRec.Customer_Code__c = 'Test123';
        claimRec.Contact_First_Name__c = 'user1';
        claimRec.Contact_Last_Name__c = 'user2';
        claimRec.Customer_Contact_Phone__c = '1231231231';
        claimRec.Email_Address__c ='abc@cummins.com';
        claimRec.Address__c = 'Blr';
        claimRec.State__c = 'karnataka';
        claimRec.ZipCode__c = '909090';
        //claimRec.Repair_Location__c = 'alpha';
        claimRec.Service_Date__c = date.today()+10;
        claimRec.Repair_Completion__c= date.today()+20;
        
        insert claimRec;
        CG_ClaimsHeaderWrapper claimNewRec = new CG_ClaimsHeaderWrapper(claimRec);
        Test.stopTest();

}
}