@IsTest
private class CSS_MakeAndModel_Test {
   
    static TestMethod void testforMakeRecs(){
            CSS_Make_Model_Access__c MakRec = new CSS_Make_Model_Access__c();
                 MakRec.EquipmentId__c='EQ2314';
                 MakRec.Access__c ='A';
        		 MakRec.recordtypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
                 //MakRec.Name='WORKBOAT-EQ2314-32-A'; 
                 MakRec.EngineFamilyCode__c ='code123';
                 MakRec.Make__c='test123';
                 MakRec.UniqueKey__c='Test';
                 MakRec.Model__c='modeltest';
        
                     insert MakRec;
            
            CSS_Job_Order__c SerRec = CSS_TestData.createJobOrder(false);
                 SerRec.Make__c='test123';
                 SerRec.Model__c='modeltest';
                 SerRec.Qsol_Engine_Family_Code__c='code123';
                 SerRec.ESN__c='73806085';
                     insert SerRec;
                system.debug('output for CSS_Job_Order__c object'+SerRec);
        
             map<id,CSS_Job_Order__c> oldMap = new map<id,CSS_Job_Order__c>();
                oldMap.put(SerRec.Id, SerRec);
                    SerRec.Make__c = 'test123';
                    update SerRec;
        
        list<CSS_Job_Order__c> newList = new List<CSS_Job_Order__c>();
        newList.add(SerRec);
        
        CSS_Claims__c cj = new CSS_Claims__c();
		cj.CSS_Channel_Code__c='101';
		cj.Territory_Class__c='100';
		cj.ESN__c='73806085';
		cj.Location_Code__c='03742-03750';
		cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
		cj.Territory_Class_Name__c='UNITED STATES';
		cj.Territory__c='';
		
		//insert cj;
		String grpName = 'CQ'+'-'+'12345-12345';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            
             system.runas(new User(Id=UserInfo.getUserId()))
            { 
            
                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;
       Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
        css_job_order__c joorder = css_testdata.createJobOrder(true);
         cj = CSS_TestData.createclaims(true,null);
            }
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Make__c='test123';
        ps.Model__c='modeltest';
        ps.CSS_Claims__c=cj.id;
        ps.name='73806085';
        ps.Qsol_Engine_Family_Code__c='code123';
        list<CSS_PSN__c> pslist = new list<CSS_PSN__c>();
        pslist.add(ps);
        insert pslist;
        
        
        //Select EquipmentId__c,AccessCode__c From CSS_Make_Model__c where EngineFamily__c=:newList[0].Qsol_Engine_Family_Code__c AND Make__c=:oldMap.get(jobOrder.Id).Make__c AND Model__c=:oldMap.get(jobOrder.Id).Model__c LIMIT 1
        CSS_MakeAndModel.updateEquipmentId(newList, oldMap);
        css_makeandmodel.updateEquipmentId(pslist);
        System.debug('Out Put for CSS_MakeAndModel_Test Class'+MakRec);
        
    }
}