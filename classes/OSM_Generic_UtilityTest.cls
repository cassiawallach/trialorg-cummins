//Updated by Pooja 8/5/2022 story 1054
//including for deployment
//addingcomment
@IsTest
public class OSM_Generic_UtilityTest {
        
    static testMethod void testOSM_Generic_Utility (){
        OSM_Incremental_Count__c countSetting=new OSM_Incremental_Count__c();
        countSetting.name='CurrentCount';
        countSetting.Current_Count__c='999';
        insert countSetting;
        //Start Test
        test.startTest();
        DateTime dt = system.today();
        Date d = system.today();
        String utcDate = OSM_Generic_Utility.getUTCDate(dt);
        System.assert(utcDate!=null, 'Date is not Null');
        String getDate = OSM_Generic_Utility.getDate(d);
        System.assert(d!=null, 'Date is not Null');
        String getIncrement = OSM_Generic_Utility.getIncrementalCount();
        System.assert(getIncrement!=null, 'Increment is not Null');
        OSM_Generic_Utility.UpdateIncrementalCount();
        OSM_Generic_Utility.getUTCDate(system.now());
        OSM_Generic_Utility.getDate(system.today());
        OSM_Generic_Utility.getIncrementalCount();
        OSM_Generic_Utility.getRequiredDateFormat(d,'yyyy-mm-dd');
        OSM_Generic_Utility.fieldSizeRestriction(utcDate, 5, 'back');
        String woSymbol = OSM_Generic_Utility.removeSymbols('asdfg@dfgfg');
        system.assert(woSymbol == 'asdfg@dfgfg');
        //String requesterId = OSM_Generic_Utility.truncateRequesterId('sdfsggddfdfd');
        //system.assert(requesterId == 'sdfsggddfdfd');
        //Stop Test
        test.stopTest();
    }
}