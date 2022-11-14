@IsTest(seealldata = true)
public class CSS_ADMIN_SRTs_Test {
    public static PageReference pref;
    static testMethod void CSS_ADMIN_SRTs_Test_Method1(){
        
        
        Test.setMock(HttpCalloutMock.class, new CSS_getAllRepDiagSRTs_Test());
        
        
        Profile profi = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = profi.Id, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com'+ System.currentTimeMillis(),CompanyName = 'TEST', User_Location__c='123456');
        objUser1.User_Location__c ='Bronx';
        insert objUser1;
        
         CSS_List_Of_Values__c css = new CSS_List_Of_Values__c();
        css.Name='test'+math.random();
        css.Picklist_Values_1__c= 'Automotive';
        css.Picklist_Values_2__c= 'AUTOMOTIVE';
       // css.Picklist_Values_3__c= 'dfg';
        css.Type__c='Application Code';
        css.Code__c='310';
        Insert css; 
        system.assertNotEquals('x1yz', css.Name);
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(false);
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.INSITE_UpdateTimeStamp__c = system.now();
        //JO.Repair_Location__c ='Mobile';
        JO.Repair_Location__c ='In Shop';
        //JO.Application__c='Automotive';
        //modified as per story# 64030
        //JO.Application__c='Recreational Vehicle Ad';
        JO.Application_Desc__c='Recreational Vehicle Ad';
        JO.Preventive_Maintenance__c = 'Yes';
        Jo.Assigned_To__c = UserInfo.getUserId();        
        insert(JO);
        
        
        css_srt__c jSRT = new css_srt__c();        
        jSRT.SRTAdmi_Check__c = true;
        jSRT.SRT_Details__c ='asdasdas';
        jSRT.SRT_Title__c = 'test9091';
        jSRT.Name = 'qwewqe'; 
        jSRT.SRT_Time__c = 66;
        jSRT.SRT_Notes__c='asdsad';
        //jSRT.SRT_Id__c ='testsrt901';
        jSRT.SRT_Id__c ='00-901-00';
        jSRT.Admin_Miles_In__c =1;
        jSRT.Admin_Miles_Out__c=2;
        jSRT.Admin_Arrive_Job__c=3;
        jSRT.Admin_Arrive_Shop__c=4;
        jSRT.SRT_Type__c='Admin';
        jSRT.Type__c='Admin';
        jSRT.Admin_Finish_Job__c=6;
        jSRT.Admin_Leave_Job__c=7;
        jSRT.Admin_Left_Shop__c=8;
        jSRT.Admin_Start_Job__c=9;
        jSRT.Job_Order__c =JO.id;        
        insert jSRT;
        
        
        css_srt__c jSRT2 = new css_srt__c();        
        jSRT2.SRTAdmi_Check__c = true;
        jSRT2.SRT_Details__c ='asdasdasbb';
        jSRT2.SRT_Title__c = 'test29091';
        jSRT2.Name = 'qwewqe'; 
        jSRT2.SRT_Time__c = 66;
        jSRT2.SRT_Time_String__c = ':';
        jSRT2.SRT_Notes__c='asdsad';
        //jSRT2.SRT_Id__c ='testsrt901';
        jSRT2.SRT_Id__c ='00-902-00';
        jSRT2.Admin_Miles_In__c =1;
        jSRT2.Admin_Miles_Out__c=2;
        jSRT2.Admin_Arrive_Job__c=3;
        jSRT2.Admin_Arrive_Shop__c=4;
        jSRT2.SRT_Type__c='Custom';
        jSRT2.Type__c='Custom';
        jSRT2.Admin_Finish_Job__c=6;
        jSRT2.Admin_Leave_Job__c=7;
        jSRT2.Admin_Left_Shop__c=8;
        jSRT2.Admin_Start_Job__c=9;
        jSRT2.Job_Order__c =JO.id;        
        insert jSRT2;
        
        css_srt__c jSRT3 = new css_srt__c();        
        jSRT3.SRTAdmi_Check__c = true;
        jSRT3.SRT_Details__c ='asdasdasbb';
        jSRT3.SRT_Title__c = 'test29091904';
        jSRT3.Name = 'qwewqe'; 
        jSRT3.SRT_Time__c = 66;
        jSRT3.SRT_Time_String__c = ':';
        jSRT3.SRT_Notes__c='asdsad';
        //jSRT2.SRT_Id__c ='testsrt901';
        jSRT3.SRT_Id__c ='00-904-00';
        jSRT3.Admin_Miles_In__c =1;
        jSRT3.Admin_Miles_Out__c=2;
        jSRT3.Admin_Arrive_Job__c=3;
        jSRT3.Admin_Arrive_Shop__c=4;
        jSRT3.SRT_Type__c='Custom';
        jSRT3.Type__c='Custom';
        jSRT3.Admin_Finish_Job__c=6;
        jSRT3.Admin_Leave_Job__c=7;
        jSRT3.Admin_Left_Shop__c=8;
        jSRT3.Admin_Start_Job__c=9;
        jSRT3.Job_Order__c =JO.id;        
        insert jSRT3;
        
        CSS_SRT__c srt=[ Select id,SRTAdmi_Check__c,SRT_Details__c,SRT_Title__c,Name,SRT_Time__c,SRT_Notes__c,Job_Order__c,SRT_Id__c,SRT_Time_Hr_Min__c,SRT_Decimal_Time__c,
                        Admin_Miles_In__c,Admin_Miles_Out__c,Admin_Arrive_Job__c,Admin_Arrive_Shop__c,Admin_Finish_Job__c,Admin_Leave_Job__c,Admin_Left_Shop__c,Admin_Start_Job__c,Type__c,SRT_Time_String__c
                        from CSS_SRT__c where Job_order__c=:jo.id AND (SRT_Type__c='Admin' OR Type__c ='Custom') limit 1];
        list<CSS_SRT__c> srtlist = new  list<CSS_SRT__c>();
        srtlist.add(srt);
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',JO.id);
        
        CSS_ADMIN_SRTs controller = new CSS_ADMIN_SRTs();
        controller.adminStr ='901';
        controller.JobID = JO.ID;
        controller.SRTList1 = srtlist;
        Test.startTest();
        controller.getallData();
        controller.getallSRTData();
        controller.saveBox();
        controller.lstDisplayAdmin = srtlist;  
        controller.getFilteredSRTs();
        
        
        controller.closePopup1();
        controller.closePopup2();
        
        controller.getallCustomSRTData();
        controller.saveCustSRT();
        
        
              
        Test.stopTest();
        
    }
    static testMethod void CSS_ADMIN_SRTs_Test_Method2(){
        
        
        CSS_Job_Order__c JO = new CSS_Job_Order__c();
        JO = CSS_TestData.createJobOrder(false);
        JO.Customer_Name__c = 'CumminsTnD';
        JO.Status__c = 'Repair Complete';
        JO.Make__c = 'test1234';
        JO.Model__c = 'test1234';
        JO.DSID__c = 'test1234';
        JO.Equipment_ID__c = 'test1234';
        JO.Service_Model__c = 'test1234';
        JO.Shop_Work_Order__c = 'test1234';
        JO.INSITE_UpdateTimeStamp__c = system.now();
        JO.Repair_Location__c ='Mobile';
        //modified as per story# 64030
        //JO.Application__c='Automotive';
        JO.Application_Desc__c='Automotive';
        JO.Preventive_Maintenance__c = 'Yes';
        Jo.Assigned_To__c = UserInfo.getUserId();        
        insert(JO);
        
        PageReference pageRef = new PageReference('/apex/JobTndTs?id=');
        test.setCurrentPage(pageRef);        
        pageRef.getParameters().put('id',JO.id);
      
        
        CSS_ADMIN_SRTs admin_srt =new CSS_ADMIN_SRTs();
        
        Test.startTest();
       
        admin_srt.getallCustomSRTData();
        admin_srt.getFilteredSRTs();
              
        Test.stopTest();
    }
}