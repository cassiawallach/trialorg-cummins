@isTest
public class dbu_EXTEND_ccLogicWLCreate_Test {
    @isTest static void testmethod1(){
                //system.debug('kirov');
        Map<string,object> transindex = new Map<string,object>();
        Map<string,object> InputData = new Map<string,object>{
            'transformIndex' => transindex
        };
        Test.startTest();
	    dbu_EXTEND_ccLogicWLCreate LogicWLCreate = new dbu_EXTEND_ccLogicWLCreate();
        LogicWLCreate.createWishList(InputData);
		Test.stopTest();
    }
}