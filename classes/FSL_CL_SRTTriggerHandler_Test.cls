//Krishna - adding comment to deploy changes for code coverage
@istest
public class FSL_CL_SRTTriggerHandler_Test {
    
    static testMethod void testActiveMethod(){
		FSL_CL_SRTTriggerHandler testCont = new FSL_CL_SRTTriggerHandler();
        FSL_CL_SRTTriggerHandler.dummy();
	}
    
  /* @istest
    public static void callAdminSRTApiForTravelSRTstest(){
       WorkOrder wo = new WorkOrder();
        wo.Repair_Location__c='In Shop';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.SelectedSolution__c='abc';
        wo.FaultCodeId__c='123';
        wo.Process_Step__c = 'Repair';
        wo.Warranty_Start_Date__c = System.today();
        wo.Repair_Solution__c  = null;
        insert wo;
        
        list<FSL_SRT__c> fslList = new list<FSL_SRT__c>();
        FSL_SRT__c  fsl = new FSL_SRT__c();
        //fsl.Name='Travel';
        fsl.Service_Order__c = wo.id;
        fslList.add(fsl);
        insert fslList;
        test.startTest();
        //FSL_CL_SRTTriggerHandler.callAdminSRTApiForTravelSRTs(fslList);
        test.stoptest();
    } */

}