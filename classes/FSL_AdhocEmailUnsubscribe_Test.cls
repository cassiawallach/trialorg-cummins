@isTest
public class FSL_AdhocEmailUnsubscribe_Test {
    static testMethod void adhocUnsubscribe() {
        Test.startTest();
       list<WorkOrder> wl = new list<WorkOrder>();
         WorkOrder wo = new WorkOrder();
            wo.Repair_Location__c='In Shop';
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.FSL_Additional_Email_Notifications__c='abc@gmail.com;qwe@yopmail.com;jkl@gmail.com';
        wl.add(wo);
        WorkOrder wo1 = new WorkOrder();
            wo1.Repair_Location__c='In Shop';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.FSL_Additional_Email_Notifications__c='abc@gmail.com;qwe@yopmail.com;jkl@gmail.com';
        wl.add(wo1);
        insert wl;
        list<case> cl=new list<case>();
        case cs=new case();
        cs.ServiceJob__c=wo.id;
        cs.FSL_Adhco_Email__c='abc@gmail.com';
        cl.add(cs);
        case cs1=new case();
        cs1.ServiceJob__c=wo.id;
        cs1.FSL_Adhco_Email__c='jkl@gmail.com';
        cl.add(cs1);
        insert cl;
         Map<Id, string> serviceJobIdVsEmail = new Map<Id, String>();
        serviceJobIdVsEmail.put(wl[0].id,'abc@gmail.com');
        serviceJobIdVsEmail.put(wl[1].id,'jkl@gmail.com');
        
        
        List<id> caseThreadid = new List<id>();
        caseThreadid.add(cl[0].id);
       
        FSL_AdhocEmailUnsubscribe_Invocable.deleteAdhocEmailAddress(caseThreadid);
        Test.stopTest();
        
    }
    static testMethod void adhocUnsubscribe_test1() {
        Test.startTest();
       list<WorkOrder> wl = new list<WorkOrder>();
         WorkOrder wo = new WorkOrder();
            wo.Repair_Location__c='In Shop';
            wo.Available_for_Service__c=datetime.now()+3;
            wo.SelectedSolution__c='abc';
            wo.FSL_Additional_Email_Notifications__c='abc@gmail.com';
        wl.add(wo);
        WorkOrder wo1 = new WorkOrder();
            wo1.Repair_Location__c='In Shop';
            wo1.Available_for_Service__c=datetime.now()+3;
            wo1.SelectedSolution__c='abc';
            wo1.FSL_Additional_Email_Notifications__c='abc@gmail.com';
        wl.add(wo1);
        insert wl;
        list<case> cl=new list<case>();
        case cs=new case();
        cs.ServiceJob__c=wo.id;
        cs.FSL_Adhco_Email__c='abc@gmail.com';
        cl.add(cs);
        case cs1=new case();
        cs1.ServiceJob__c=wo.id;
        cs1.FSL_Adhco_Email__c='jkl@gmail.com';
        cl.add(cs1);
        insert cl;
         Map<Id, string> serviceJobIdVsEmail = new Map<Id, String>();
        serviceJobIdVsEmail.put(wl[0].id,'abc@gmail.com');
        serviceJobIdVsEmail.put(wl[1].id,'jkl@gmail.com');
        
        
        List<id> caseThreadid = new List<id>();
        caseThreadid.add(cl[0].id);
       
        FSL_AdhocEmailUnsubscribe_Invocable.deleteAdhocEmailAddress(caseThreadid);
        Test.stopTest();
        
    }
}

//
//