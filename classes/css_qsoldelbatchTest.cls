@isTest
private class css_qsoldelbatchTest {

    static testmethod void test() {
        
        

	   
	  CSS_JobEventTemporary__c JO = NEW CSS_JobEventTemporary__c();
		JO.Name = 'Test Name';
		JO.Type__c = 'TRPs';
		JO.Source__c = 'QSOL';
	
	   insert JO;
	   String  whereClause = ' Id = \'' + JO.Id + '\' ';
       String query = 'SELECT Id,Type__c FROM CSS_JobEventTemporary__c WHERE' + whereClause;
       Test.startTest();
	   css_qsoldelbatch c = new css_qsoldelbatch(query);
	   Database.executeBatch(c);
       Test.stopTest();

    }
}