/*======================================================
Purpose: CSS_TestData is a test data class which is used 
 in the test classes .
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Rakesh Kumar         11/8/2016      INITIAL DEVELOPMENT                    
2.0 - Rajesh P             11/9/2016      Added create method for CSS_SRT__c object.
2.1 - Rajesh P             11/11/2016     Added create method for CSS_Solution__c. 
                                          CSS_Solution_Component__c, CSS_Solution_C object.
2.2 - Rajesh P             11/17/2016     Added create method for CSS_JobEventTemporary__c.
2.3 - Rajesh P             11/25/2016     Added create method for Account and CSS_Accreditation__c objects.
2.4 - Gopal Raj A          07/16/2018     Added create method for claims,Claims_Summission,Parts_option,SRT and PSN object.
***********************************************************************/
public class CSS_TestData {
    //Method to create test record for CSS_Job_Order__c
    public static CSS_Job_Order__c createJobOrder(boolean isInsert){
        
            String grpName = 'JQ'+'-'+'56270-56255';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
             system.runas(new User(Id=UserInfo.getUserId()))
            { 
                
                /*Account acc = new Account();
                acc.Name = 'bangalore';
                acc.Enable_Claims__c = true;
                acc.ERP_System__c = 'One BMS';
                acc.CSS_DBCode__c='56270';
                acc.type = 'Distributor Account';
                acc.CSS_DistributorCode__c='56270';
                acc.CMI_Account_Status__c = 'Active';
                acc.IAM_Service_Provider_Code__c='56255';
                insert acc;
                system.debug('RAJESH ' + acc);
                account acco = [select Id,Location__c from account where id=:acc.Id];
                system.debug('RAJESH LOCATION' + acc);*/
                QueueSObject tq = new QueueSObject(SobjectType='CSS_Job_Order__c', QueueId=testQue.Id);
                insert tq;
        
                Date d = Date.Today();
       // System.debug('date');
                SerRec.DSID__c='12345';
                //SerRec.OwnerId = tq.Id;
                SerRec.DSID_Status__c='open';
                SerRec.ESN__c ='79464646';
                SerRec.CSS_Channel_Code__c ='7943';
                SerRec.Customer_Name__c='ABC';
                SerRec.Failure_Date__c =d;
                SerRec.Failure_Point__c=2.2;
                SerRec.Unit_Number__c='1234';
                SerRec.Territory_Class__c='test';
                SerRec.Qsol_Engine_Family_Code__c='1234';
                SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
                SerRec.Make__c='test';
                SerRec.Model__c='test1';
                SerRec.VIN__c='1XKAD49X6CJ305490';
                SerRec.Customer_Name__c='ABC';
                SerRec.Warranty_Start_Date__c=d;
                SerRec.Application_Desc__c='test1';
                SerRec.Failure_Point_Measure__c = 'MI'; 
                SerRec.Application__c='Automotive'; 
                SerRec.sub_Type__c='cedan';
                SerRec.INSITE_UpdateTimeStamp__c= system.today();
                 SerRec.INSITE_ESN_Choice__c='Not Selected';
                 SerRec.Shop_Work_Order__c='1234';
                 SerRec.DSID_Creation_Timestamp__c=system.today();
                 SerRec.DSID_WorkGroup__c='Wrkgrp';
                 SerRec.Equipment_ID__c='Equip';
                 SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
                 SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
                 SerRec.CSS_Job_Location_Code__c='56270-56255';
                 SerRec.PSN_Not_Available__c = true;
                 SerRec.Actual_Technician_Time__c=1.2;
                SerRec.CSS_Resolution__c='Customer Rejected';
        
        if(isInsert){
            insert SerRec;
        }
            }
        return SerRec;
            
    }
    
    
    
    
    //Method to create custom setting data for CSS_accountLanguage__c
    public static CSS_accountLanguage__c createAccountLanguage(boolean isInsert){
    system.debug('inside the method');
    CSS_accountLanguage__c accLang = new CSS_accountLanguage__c();
    accLang.Name='en_US';
    accLang.CSS_EDSLanguage__c='English';
    accLang.CSS_QsolLanguage__c='English';
    accLang.CSS_userLanguage__c='en';
    if(isInsert){
    insert accLang;
    }
    system.debug('accLang>>>>'+accLang);
    return accLang;
    }

//Method to create test data for CSS_CampTsbTrp__c
public static CSS_CampTsbTrp__c createCampTsbTrp(boolean isInsert,String esn,Id workJobId){
CSS_CampTsbTrp__c campTsTr =new CSS_CampTsbTrp__c();
campTsTr.Name='campTsTr';
campTsTr.Type__c='TSB';
campTsTr.Job_Order__c=workJobId;
campTsTr.ESN__c=esn;
campTsTr.Doc_Num__c='1';
campTsTr.Doc_Title__c='CAM';
campTsTr.URL__c='test.sfdc.com';//need the data
campTsTr.Performed__c = true;
        campTsTr.Performed_Review__c = true;
        campTsTr.Reviewed__c= true;
        campTsTr.Cu_Language__c='English';//need to check
        if(isInsert){
        insert campTsTr;
        }
        
        return campTsTr;
}
    
    //Method to create CSS_Solutions__c 
    public static CSS_Solutions__c createSolutions(boolean isInsert,Id jobId){
        CSS_Solutions__c solAdd = new CSS_Solutions__c();
        solAdd.Service_Job__c = jobId;
        solAdd.Case_Name__c = 'Additional SRTS';
        solAdd.Solution_Title__c='Additional SRTS';
        
        solAdd.Name='TestSRTS'+Math.random();
        solAdd.Diagnostic_Response__c ='Most likely the solution';
        solAdd.Diagnostic_notes__c = 'solutions diagnostic notes';
        solAdd.Repair_Notes__c = 'Repair Notes';
        //solAdd.FaultCode__c = 'solution faultcode';
        //solAdd.Repair_Response__c = 'Most likely ';
        solAdd.Repair_Response__c = 'Repair Successful.';
        solAdd.Rank__c = 3;
        if(isInsert){
            insert solAdd;
        }
        
        return solAdd;
    }
        //Method to create CSS_SRT__c 
    public static CSS_SRT__c createSRT(boolean isInsert,string typ,Id solId,Id jobId){
        CSS_SRT__c srtVar = new CSS_SRT__c();
        srtVar.Solution_Number__c = solId;
        srtVar.Job_Order__c = jobId;
        srtVar.SRT_AccessiblityCheck__c=True;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = typ;
        srtVar.isPerformed__c =True;
        if(isInsert){
            insert srtVar;
        }
        
        return srtVar;
    }
    //Method to create  
    public static  CSS_Solution_Component__c createSRT(boolean isInsert,Id jobId,Id solAdd){
        
      CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.Service_Job__c = jobId;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = solAdd;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = '7';
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        //Addsolcomp.Part_Assignment__c ='Primary';
        //AddsolComp.Fail_Code__c ='Test-FAilcode';
      //  AddsolComp.FailCode_Formula__c = 'Test-FailCode';   Field is not writeable
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        if(isInsert)
        {
            insert AddsolComp;
        }
        
        return AddsolComp;
    }
    
     //Method to create CSS_Quote__c 
     public static CSS_Quote__c createquoteObj(boolean isInsert){
         
      CSS_Quote__c quoteObj = new CSS_Quote__c();
            quoteObj.BranchCode__c =    '123';
            quoteObj.CustomerNumber__c =  '123';
            quoteObj.DiagnosticCharges__c = 456;
            quoteObj.DistributorCode__c = 'popp';
            quoteObj.ItemBillable__c = 87;
            quoteObj.ItemGrossSell__c = 99;
            quoteObj.ItemWarranty__c = 67;
            quoteObj.LaborBillable__c = 77;
            quoteObj.LaborGrossSell__c = 88;
            quoteObj.LaborWarranty__c = 77;
            quoteObj.MiscBillable__c = 99;
            quoteObj.MiscGrossSell__c = 55;
            quoteObj.MiscWarranty__c = 88;
            //quoteObj.OrderReference__c = reqJSON.DataArea.OrderReference; //Quote number
            quoteObj.QuoteTotal__c = 77;
            quoteObj.Surcharge__c = 789;
            quoteObj.ServiceName__c = 'QOUTR';
            quoteObj.SenderID__c =  'QWER';
            quoteObj.TargetID__c = 'KLJ';
            quoteObj.LocationID__c = 'NORTH';
            quoteObj.Taxes__c =   78;
            quoteObj.TransactionType__c = 'uyyy';
           //insert quoteObj;
        if(isInsert){
            insert quoteObj;
        }
        
        return quoteObj;

     }
     
    //Method to create CSS_JobEventTemporary__c 
     public static CSS_JobEventTemporary__c  createJobEventTempObj(boolean isInsert){
         
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
         jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        //jobevent.key__c='79464646'+':'+cl.id;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        
         
        if(isInsert){
            insert jobevent;
        }
        
        return jobevent;

     }
    
      //Method to create Account 
      public static Account  createAccountObj(boolean isInsert){
             Account a= new Account();
           a.name='Rtest';
           a.CSS_DistributorCode__c='1111';
           a.IAM_Service_Provider_Code__c='2222';
          
       if(isInsert){
            insert a;
        }
        
        return a;

     }
          //Method to create CSS_Accreditation__c 
          public static CSS_Accreditation__c  createAccreditationtesObj(boolean isInsert,id Acid){
           CSS_Accreditation__c ac = new CSS_Accreditation__c();
           ac.name='Rtest';
           ac.Account__c=Acid;
           
          
       if(isInsert){
            insert ac;
        }
        
        return ac;

     }
    
    // Method to create User 
    public static User createTestUser(boolean isInsert){
        UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CSSNA- Central Region' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
        if(isInsert){
            try{
                insert objUser1;
            }catch(Exception e){
                system.debug('exception message>>>>>'+e.getMessage());
            }
            
        }
        
        return objUser1;
    }
    
    //Test data for CSS_Integration_Details__c 
    public static CSS_Integration_Details__c createIntegrationDetails(boolean iSInsert){
        CSS_Integration_Details__c cid = new CSS_Integration_Details__c();
        cid.ApplicationName__c = 'QSOL';
        cid.Name='QSOL';
        cid.End_Point__c='https://qsolpilot.cummins.com/csswebservices/qsoltestclass';
        cid.IsActive__c = true;
        cid.Key__c='lPSg6wv735E70O4ZV1fd0snAHUrWlfERplf9u0TR8Wg';
        cid.Passcode__c='ETNhGSqffElTsCL26DLrEAtSi+Py79h6+/xK1Zm7SIQ';
        cid.Username__c='Cibp902/PZ1TbGx7UUqHn9R1FRrOJEElHxA8g8+V8jw';
            
            if(isInsert){
                insert cid;
            }
        return cid;
    }
    
    //test data for CSS_DataExchange_Parent__c
    public static CSS_DataExchange_Parent__c createDataExchangeParentRecords(boolean isInsert){
        CSS_DataExchange_Parent__c de = new CSS_DataExchange_Parent__c();
        de.Customer_Name__c = 'customer1';
        de.Contact_Name__c = 'custContact';
        de.City__c= 'las vegas';
        de.Country__c = 'USA';
        if(isInsert){
            try{
                insert de;
            }catch(Exception e){
                system.debug('error message '+e.getMessage()+'error line number --->'+e.getLineNumber());
            }
            
        }
        return de ;
    }
    
     //Test data to create case 
    public static Case createCase(boolean isInsert,string recordTypeName){
        case cs = new case();
        cs.recordTypeId = css_utility.getRecordTypeId(case.sObjectType, recordTypeName);
        cs.SuppliedEmail = 'test@gmail.com';
        cs.SuppliedPhone = '1234567898';
        cs.Type = 'Problem';
        cs.status = 'New';
        cs.Subject = 'TestSubject';
        cs.Description = 'describecase';
        cs.Case_Update_Flag__c = true;
        if(isInsert){
             insert cs;
        }
       return cs;
        
    }
    
    //Test data to create UserLocation record
    public static CSS_UserLocation__c createUserLocation(){
        
          Account acc = new Account();
           acc.name='Rtest';
           acc.CSS_DistributorCode__c='562701';
           acc.IAM_Service_Provider_Code__c='562551';
          
            insert acc;

UserRole empRole = [Select Id From UserRole Where Name = 'DFSE-CUMMINS CENTRAL' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='css-cmi1@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com', User_Location__c='123456');
insert objUser1;

        CSS_UserLocation__c userLocation = new CSS_UserLocation__c(AccountId__c=acc.id,isActive__c=true,isPrimary__c=true,UserId__c=objUser1.Id,Location_code__c='56270-56270');
        insert userLocation;
        return userLocation;
    }
    
    //Test data to create Parts Option record
    public static CSS_Parts_Options__c createParts(boolean isInsert,Id jobId,Id solComId,Id solId)
    {
         Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML'); 
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = jobId;
        parts.selected_part__c = true;
        parts.FailurepartId__c = solComId;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=solId;
        //records added for TTMl records
        parts.Type__c='Commercial-Travel';
        parts.ExpenseTotal__c=100;
        parts.RecordTypeId=recTyIdpart;
        if(isInsert){
             insert parts;
        }
       return parts;
       
    }
    //Test Data to crete Parts options
    public static void createTechnicians(string wid)
    {
        CSS_Job_Order__c c = new CSS_Job_Order__c();
        list<user> userids = [select id,name from user limit 20]; 
        c.ID = wid;
        c.Additional_Tech1__c = userids[0].id;
        c.Additional_Tech2__c = userids[1].id;
        c.Additional_Tech3__c = userids[2].id;
        c.Additional_Tech4__c = userids[3].id;
        c.Additional_Tech5__c = userids[4].id;
        c.Additional_Tech6__c = userids[5].id;
        c.Additional_Tech7__c = userids[6].id;
        c.Additional_Tech8__c = userids[7].id;
        c.Additional_Tech9__c = userids[8].id;
        c.Additional_Tech10__c= userids[9].id; 
        //c.CreatedBy.Name='Test';
   update c;
    
    }
    //Test data to create TTML records
     public static decimal createTTMLRecords()
    {
        decimal gtotal;
         Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');         
        css_parts_options__c ct=new css_parts_options__c();
ct.Type__c='Commercial-Travel';
ct.ExpenseTotal__c=100;
ct.recordtypeid=recTyIdpart;
insert ct;
              
         
         
        css_parts_options__c nct=new css_parts_options__c();
        nct.Type__c='Non Commercial-Travel';
        nct.ExpenseTotal__c=100;
nct.recordtypeid=recTyIdpart;      
insert nct;
                
        css_parts_options__c twn=new css_parts_options__c();
        twn.Type__c='Towing';
        twn.ExpenseTotal__c=100;        
        twn.recordtypeid=recTyIdpart;
insert twn;        
        
        css_parts_options__c ml=new css_parts_options__c();
        ml.Type__c='Meals';
        ml.ExpenseTotal__c=100;
ml.recordtypeid=recTyIdpart;        
insert ml;
        
        css_parts_options__c ldg=new css_parts_options__c();
        ldg.Type__c='Lodging';
        ldg.ExpenseTotal__c=100;        
        ldg.recordtypeid=recTyIdpart; 
        insert ldg;
         
        return (ct.ExpenseTotal__c+nct.ExpenseTotal__c+twn.ExpenseTotal__c+ml.ExpenseTotal__c+ldg.ExpenseTotal__c);
       
    }
    
    //Method to create a claims
public static CSS_Claims__c createclaims(boolean isinsert,id jobid)
{
    CSS_Claims__c claims;
    String grpName = 'CQ'+'-'+'12345-12345';
            Group testQue = new Group(Name=grpName, type='Queue');
            insert testQue;
            
             system.runas(new User(Id=UserInfo.getUserId()))
            { 
            
                QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
                insert tq;
                claims = new CSS_Claims__c();
                claims.Status__c='Draft';
                claims.ESN__c='79462880';
                claims.Customer_Name__c='BRITESTONE COLONY';
                claims.Customer_Code__c='123';
                claims.Location_Code__c='12345-12345';
                claims.Multi_PSN_Claim__c=false;
                claims.OwnerId = UserInfo.getUserId();
    if(jobid!=null)
claims.CSS_Job__c=jobid;

    
if(isinsert)
{
insert claims;

}
            }        
return claims;
            
}

//Method to create a Claimsubmission.

public static CSS_Claim_Submission__c createclaimsub(boolean isinsert,id claimid)
{
CSS_Claim_Submission__c claimsub = new CSS_Claim_Submission__c();
claimsub.CSS_Claims__c=claimid;
claimsub.Status__c='Submitted';

if(isinsert)
{
insert claimsub;

}
return claimsub;
}

//method to create a partoption newly modified version

 public static CSS_Parts_Options__c createParts_new(boolean isInsert,Id jobId,Id solComId,Id solId,id claimid)
    {
          Id recTyIdpart = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables'); 
        CSS_Parts_Options__c parts = new CSS_Parts_Options__c();
        parts.Option_Number__c = 'O-111';
        parts.Service_Job__c = jobId;
        parts.selected_part__c = true;
        parts.FailurepartId__c = solComId;
        parts.Part_Assignment__c = 'Primary';
        parts.Solutions__c=solId;
parts.CSS_Claims__c=claimid;
        parts.RecordTypeId=recTyIdpart;
        parts.ExpenseTotal__c=100;
        if(isInsert){
             insert parts;
        }
       return parts;
       
    }

//Method to create a SRT object newly modified version.

 public static CSS_SRT__c createSRT_New(boolean isInsert,string typ,Id solId,Id jobId,id claimid){
        CSS_SRT__c srtVar = new CSS_SRT__c();
     if(solId!=null)
        srtVar.Solution_Number__c = solId;
     if(jobId!=null)
        srtVar.Job_Order__c = jobId;
        srtVar.SRT_AccessiblityCheck__c=True;
     if(claimid!=null)
        srtvar.CSS_Claims__c=claimid;
        srtVar.Access_Code_A__c = 65;
        srtVar.name = 'Test'+Math.random();
        srtVar.Type__c = typ;
        srtVar.isPerformed__c =True;
        if(isInsert){
            insert srtVar;
        }
        
        return srtVar;
    }


//Method to create a psn Object

public static CSS_PSN__c createpsn(boolean isinsert,id claimid)
{
CSS_PSN__c psn = new CSS_PSN__c();
psn.Name='73806085';
psn.Unit_Number__c='123';
psn.Application__c='AUTOMOTIVE';
psn.Service_Model__c='ISB6.7 CM2350 B101';
psn.Make__c='INTERNATIONAL';
psn.Model__c='DURASTAR';
psn.Mileage_Measure__c='Miles';
psn.Unit_Type__c='CONVENTIONAL';
psn.PSN__c='73806085';
psn.ApplicationCode__c ='130';
psn.CSS_Claims__c=claimid;
    psn.Primary__c=true;
    PSN.Before_In_Service__c=FALSE;
    //Test Data
if(isinsert)
{
insert psn;
}

return psn;
}
    
}