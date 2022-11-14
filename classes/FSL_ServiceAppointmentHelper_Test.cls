//Added by Mallika for CodeCoverage
//Added comment for sept 2022 release
@isTest
//Vamsi - 03/03/2022 - Added comments for test class run
public class FSL_ServiceAppointmentHelper_Test {
    @testSetup static void setup() {
        test.starttest();
         BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardusnew@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardunew@testorg.com'
                          , FederationIdentifier ='zxABCNew',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;

        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy_Guidanz';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
        insert con;
        
        Asset ase= new Asset();
        ase.name='79788861New';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644834';
        ase.Engine_Family_Code__c = '10';
        insert ase;
        
       
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
                
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        sr.Is_a_Tech__c=true;
        insert sr;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory; 
        
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=sr.id;
        stm.ServiceTerritoryId=objServiceTerritory.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
       
        workorder wo=new workorder();
        wo.AccountId=acc.id;
        wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.ServiceTerritoryId = objServiceTerritory.id;
        wo.Process_Step__c ='Schedule';
        wo.RPV_Notification_Flag__c='RNFLAG';
        insert wo;
        
        List<serviceappointment> serviceappointmentList = new List<serviceappointment>();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.now().addDays(2);
        sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addDays(3);
        sa.SchedEndTime = datetime.now().addDays(4);
        sa.Service_Order__c= wo.id;
        sa.Formatted_Scheduled_Start__c='FSS';
        sa.Assigned_ServiceResource__c = sr.Id;
        sa.Is_a_Tech_Appointment__c=true;
        //sa.ser
        //insert sa;
        serviceappointmentList.add(sa);
        
        //sa.Status = 'Scheduled';
        //update sa;
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = wo.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.now().addDays(2);
        sa1.DueDate = System.now().addDays(30);
        sa1.SchedStartTime=datetime.now().addDays(3);
        sa1.SchedEndTime = datetime.now().addDays(4);
        sa1.Service_Order__c= wo.id;
        sa1.Formatted_Scheduled_Start__c='populateResourceDetails';
        sa1.Is_a_Tech_Appointment__c=true;
        //insert sa1;
        serviceappointmentList.add(sa1);
        insert serviceappointmentList;
        
        sa.Status = 'Scheduled';
        update sa;
        test.stoptest();
    }
    
    public static testmethod void saHelper(){
    //Vijay/Rajkumar - Recursion logic coverage
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                              , FederationIdentifier ='zxABC');
            BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
            insert u;
            test.startTest();
            Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc= new Account();
            acc.RecordTypeId=accRecId;
            acc.Name='Timothy';
            acc.Email_Notification_Frequency__c='Real-Time';
            insert acc;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.AccountId=acc.id;
            insert con;
            
            Asset ase= new Asset();
            ase.name='79788861';
            ase.AccountId=acc.Id;
            //ase.ContactId=con.Id;
            ase.Safety_Requirement__c=True;
            ase.Type__c='Engines';
            ase.Type_PSN__c='Engines-79644334';
            insert ase;
            
            OperatingHours oh=new OperatingHours();
            oh.name ='test operating hours';
            //oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
            insert oh;
            
            ServiceTerritory st= new ServiceTerritory();
            st.name = 'TEST ST Mobile';
            st.OperatingHoursId=oh.id;
            st.Location_Code__c='03250-02851';
            st.IsActive=true;
            st.FSL_Service_Territory_Code__c='02851';
            st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            st.Territory__c = 'AUSTRALIA';
            st.ANVL_Enabled__c = true;
            insert st;
            
            ServiceResource sr=new ServiceResource();
            sr.Name='service resource';
            sr.IsActive=true;
            sr.RelatedRecordId=u.id;
            sr.ResourceType='T';
            insert sr;
            
            ServiceTerritoryMember stm=new ServiceTerritoryMember();
            stm.ServiceResourceId=sr.id;
            stm.ServiceTerritoryId=st.id;
            stm.TerritoryType='P';
            stm.EffectiveStartDate=datetime.now();
            stm.Street = '1460 N National Rd';
            stm.City = 'Columbus';
            stm.State = 'Indiana';
            stm.Country = 'United States';
            stm.PostalCode = '47201';
            insert stm;
            
            case cs=new case();
            cs.AccountId=acc.id;
            cs.ContactId=con.id;
            cs.AssetId=ase.id;
            //cs.Category1__c='Leak';
            //cs.Category1__c='AIR LEAK';
            //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
                //Replaced with description filed 
            // cs.General_Symptoms__c='test symptoms';
            cs.Description = 'test symptoms';
            cs.Service_Territory__c=st.id;
            //cs.ServiceJob__c=wo.id;
            cs.BusinessHoursId=bhs.id;
            insert cs;
            
            WorkType wt=new WorkType();
            wt.Name='Test work type';
            wt.EstimatedDuration=60.00;
            insert wt;
            //test.startTest();
            workorder wo=new workorder();
            wo.ServiceTerritoryId=st.id;
            wo.AccountId=acc.id;
            wo.ContactId=con.id;
            wo.Repair_Location__c='In Shop';
            wo.AssetId=ase.id;
            wo.Available_for_Service__c=datetime.now()+3;
            wo.CaseId=cs.id;
            wo.Process_Step__c='Intake';
            wo.WorkTypeId= wt.Id;
            wo.Shop_Work_Order__c='00001234';
            insert wo;
            
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = wo.Id;
            sa.Status = 'Dispatched';
            sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
            sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
            sa.SchedStartTime=datetime.now()+3;
            sa.SchedEndTime=datetime.now()+4;
            sa.Service_Order__c= wo.id;
            insert sa;
            
            serviceappointment sa1= new serviceappointment();
            sa1.parentrecordId = wo.Id;
            sa1.Status = 'Scheduled';
            sa1.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
            sa1.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
            sa1.SchedStartTime=sa.SchedStartTime;
            sa1.SchedEndTime=sa.SchedEndTime;
            sa1.Service_Order__c= wo.id;
            insert new List<serviceappointment >{sa,sa1}; 
            
            //CT3-198
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            string algo = 'AES256';
            
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'CG_ANVLService';
            conDetail.Logging__c='BOTH';
            conDetail.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
            conDetail.ApplicationName__c='ANVL';
            conDetail.Method_Type__c='POST';
            conDetail.Timeout__c=2.0;
            conDetail.IsActive__c=true;         
            conDetail.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            conDetail.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            conDetail.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            insert conDetail;
            
            AssignedResource ar= new AssignedResource();
            ar.ServiceResourceId=sr.id;
            ar.ServiceAppointmentId=sa.id;
            
            
          //  insert ar;  
            
         
            //failing here "Class.FSL_ServiceAppointmentHelper_Test.saHelper: line 121, column 1"
            
            /*System.DmlException: Insert failed. First exception on row 0; first error:
             *  CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY,
             *  FSL.TR021_AssignedResource_AfterInsert: execution of AfterInsert
                caused by: System.NullPointerException: Attempt to de-reference a null object*/
            
            
            /*   AssignedResource ar1= new AssignedResource();
                ar1.ServiceResourceId=sr.id;
                ar1.ServiceAppointmentId=sa1.id;
                insert ar1; */
            //test.startTest();
            sa.Status='Scheduled';
            wo.Status = 'Scheduled';
            wo.Scheduled__c = true;
            try{
                update sa;
                //   delete sa1;
                update wo;
                
            }catch(Exception e){
                system.debug('exception ** '+e.getMessage() + ' at ' + e.getLineNumber());
            }
            
            sa1.status = 'Dispatched';
            update sa1;
            
            test.stopTest();
            list<serviceappointment> salist=new List<serviceappointment>();
            salist.add(sa);
            list<serviceappointment> salist1=new List<serviceappointment>();
            //   salist1.add(sa1);
        } catch (Exception e) {
            System.debug('$$$ Exception details ' + e.getMessage() + ' at line ' + e.getLineNumber());   
        }
         
    } 
    
 @isTest
    public static void populateTechnicianDispatchStatusTest(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com', FederationIdentifier ='zxABC',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;
        test.startTest();
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
       // insert con;
        
        Asset ase= new Asset();
        ase.name='79788861Test1';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        insert ase;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
        
        ServiceTerritory st= new ServiceTerritory();
        st.name = 'TEST ST Mobile';
        st.OperatingHoursId=oh.id;
        st.Location_Code__c='03250-02851';
        st.IsActive=true;
        st.FSL_Service_Territory_Code__c='02851';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        st.ANVL_Enabled__c = true;
        insert st;
       
       
        case cs=new case();
        cs.AccountId=acc.id;
      // cs.ContactId=con.id;
        cs.AssetId=ase.id;
        //cs.Category1__c='Leak';
        //cs.Category1__c='AIR LEAK';
        //09/10/2020 ; Rajashekar N ; No Longer needed General_Symptoms__c field; 
            //Replaced with description filed 
        // cs.General_Symptoms__c='test symptoms';
        cs.Description = 'test symptoms';
        cs.Service_Territory__c=st.id;
        //cs.ServiceJob__c=wo.id;
        cs.BusinessHoursId=bhs.id;
        insert cs;

        //test.startTest(); 
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
        
        workorder wo=new workorder();
        wo.ServiceTerritoryId=st.id;
        wo.AccountId=acc.id;
      //  wo.ContactId=con.id;
        wo.Repair_Location__c=null;
        wo.AssetId=ase.id;
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.CaseId=cs.id;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.Category1__c='Leak';
        wo.Service_Model__c = null;
        wo.Application__c='130 - AUTOMOTIVE ';
        insert wo; 
        
        List<serviceappointment> Listsa = new List<serviceappointment>();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.now().addDays(2);
        sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addDays(3);
        sa.SchedEndTime = datetime.now().addDays(4);
        sa.Service_Order__c= wo.id;
         
        Listsa.add(sa);
        insert Listsa;
        
        List<serviceappointment> Listsa1 = new List<serviceappointment>();
        serviceappointment sa1= new serviceappointment();
        sa1.id = Listsa[0].id;
        //sa1.parentrecordId = wo.Id;
        sa1.Status = 'Scheduled';
        //sa1.EarliestStartTime = datetime.now().addDays(2);
        ///sa1.DueDate = System.now().addDays(30);
        //sa1.SchedStartTime=datetime.now().addDays(3);
        //sa1.SchedEndTime = datetime.now().addDays(4);
        //sa1.Service_Order__c= wo.id;
        Listsa1.add(sa1);
        Update Listsa1;
        
        
        
        
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        insert sr;
        
        List<ServiceAppointmentShare> SAShareList = new List<ServiceAppointmentShare>();
        ServiceAppointmentShare  SAShare= new ServiceAppointmentShare();
        SAShare.AccessLevel = 'Read';
         SAShare.ParentId = sa.Id;
         SAShare.UserOrGroupId = u.id;
         SAShareList.add(SAShare);
         insert SAShareList; 
         
         List<CaseShare> CaseShareList = new List<CaseShare>();
        CaseShare  SRShare= new CaseShare();
        SRShare.CaseAccessLevel = 'Read';
         SRShare.CaseId = cs.Id;
         SRShare.UserOrGroupId = u.id;
         CaseShareList.add(SRShare);
         insert CaseShareList; 
        
          
          Map<id,ServiceAppointment> SAList = new Map<id,ServiceAppointment>();
          SAList.put(Listsa[0].id,Listsa[0]);
          Map<id,ServiceAppointment> SAList1 = new Map<id,ServiceAppointment>();
          SAList1.put(Listsa1[0].id,Listsa1[0]);
          
        FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentUserSharing(Listsa,SAList1);
                 
      
        //CT3-198
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
        conDetail.Name = 'CG_ANVLService';
        conDetail.Logging__c='BOTH';
        conDetail.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
        conDetail.ApplicationName__c='ANVL';
        conDetail.Method_Type__c='POST';
        conDetail.Timeout__c=2.0;
        conDetail.IsActive__c=true;         
        conDetail.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        conDetail.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        conDetail.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        insert conDetail;
        
        AssignedResource ar= new AssignedResource();
        ar.ServiceResourceId=sr.id;
        ar.ServiceAppointmentId=sa.id;
        
        set<id> setWOId = new set<id>();
        setWOId.add(wo.id);
        FSL_ServiceAppointmentTriggerHandler.ftSendTechnicianInfoToANVL(setWOId);
        try{
           sa.status = 'Scheduled';
            update sa;
            
           insert ar;
          test.stopTest();
         
    
        }
        catch (Exception e) {
            System.debug('$$$ Exception details ' + e.getMessage() + ' at line ' + e.getLineNumber());   
        }
        
        try{            
            sa.status = 'Dispatched';            
            update sa;
            
        }
        catch (Exception e) {
            System.debug('$$$ Exception details ' + e.getMessage() + ' at line ' + e.getLineNumber());   
        }
        
    } 
    
     @isTest
    public static void populateTechnicianDispatchStatusTest2(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com', FederationIdentifier ='zxABC',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;
        
        test.startTest();
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
      //  insert con;
        
        Asset ase= new Asset();
        ase.name='79788861New2';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79644334';
        ase.Engine_Family_Code__c = '10';
        insert ase;
        
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
                
       
        
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        insert sr;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;
         
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
            objServiceTerritory.Name = 'Test ServiceTerritory MobileNew';
            objServiceTerritory.IsActive = true; 
            objServiceTerritory.Location_Code__c = '01234-01034';
            objServiceTerritory.FSL_Service_Territory_Code__c = '01234-01034';
            objServiceTerritory.OperatingHoursId = oh.Id;
            objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=sr.id;
        stm.ServiceTerritoryId=objServiceTerritory.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
        
        workorder wo=new workorder();
        wo.AccountId=acc.id;
     //   wo.ContactId=con.id;
        wo.Repair_Location__c='In Shop';
        wo.AssetId=ase.id;
        wo.Process_Step__c = 'Intake';
        wo.Available_for_Service__c=datetime.now()+3;
        wo.WorkTypeId= wt.Id;
        wo.Shop_Work_Order__c='00001234';
        wo.AssignedResource__c ='Teswtst';
        wo.ServiceTerritoryId = objServiceTerritory.id;
        insert wo;
        
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.now().addDays(2);
        sa.DueDate = System.now().addDays(30);
        sa.SchedStartTime=datetime.now().addDays(3);
        sa.SchedEndTime = datetime.now().addDays(4);
        sa.Service_Order__c= wo.id;
        insert sa;
        
        
            
            //CT3-198
            Blob key = Blob.valueOf('12345678901234567890123456789012');
            string algo = 'AES256';
            
            CSS_Integration_Details__c conDetail = new CSS_Integration_Details__c();
            conDetail.Name = 'CG_ANVLService';
            conDetail.Logging__c='BOTH';
            conDetail.End_Point__c = 'https://cdsdomain-dev.cummins.com/api/v1/GetToken';
            conDetail.ApplicationName__c='ANVL';
            conDetail.Method_Type__c='POST';
            conDetail.Timeout__c=2.0;
            conDetail.IsActive__c=true;         
            conDetail.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            conDetail.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
            conDetail.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
            insert conDetail;
            
        AssignedResource ar= new AssignedResource();
            ar.ServiceResourceId=sr.id;
            ar.ServiceAppointmentId=sa.id;
       
            set<id> setWOId = new set<id>();
            setWOId.add(wo.id);
            FSL_ServiceAppointmentTriggerHandler.ftSendTechnicianInfoToANVL(setWOId);
            
            try{                
                insert ar;
                FSL_ServiceAppointmentTriggerHandler.ftSendTechnicianInfoToANVL(setWOId);
            }
            catch(exception ex){}
       test.stopTest();
    } 
    
    @isTest
    public static void testCreateFormOnePerWO(){
    	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
        Test.startTest();
       Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
			acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        Id SRTDataId = [Select Id From RecordType Where SobjectType = 'CSS_Make_Model_Access__c' AND DeveloperName = 'SRTData'].Id;
        CSS_Make_Model_Access__c makemodel = new CSS_Make_Model_Access__c();
        makemodel.Make__c = 'MAKE';
        makemodel.Model__c = 'MODEL';
        makemodel.EngineFamilyCode__c = 'TEST';
        makemodel.RecordTypeId = SRTDataId;
        insert makemodel;
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'External-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = acc.Id;
        asset1.FSL_Site__c = addr.Id;
        asset1.Engine_Family_Code__c = 'TEST';
        asset1.Make_Model__c = makemodel.Id;
        asset1.Application__c = '130 - AUTOMOTIVE';
        insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType FTM';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        FSL_SubType__c st = new FSL_SubType__c();
        st.Name ='TestSubTypeFTM';
        insert st;

        FSL_SMN_DTC__c smn = new FSL_SMN_DTC__c();
        smn.name = 'TEST SMN';
        smn.FaultTypeFC__c = 'Yes';
        insert smn;
        //Test.startTest();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = workType.Id;
        objWorkOrder.FSL_Sub_Type__c = st.id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        objWorkOrder.Repair_Site_Address__c = addr.Id;
        objWorkOrder.Repair_Location__c = 'Mobile';
        objWorkOrder.FSL_SMN__c = smn.Id;
        insert objWorkOrder;
        
        List<ServiceResource> srList = new List<ServiceResource>();
        ServiceResource sr = new ServiceResource();
        sr.RelatedRecordId = UserInfo.getUserId();
        sr.Is_a_Tech__c = true;
        sr.name = 'Test Resource';
        srList.add(sr);
        ServiceResource sr1 = new ServiceResource();
        sr1.RelatedRecordId = u.Id;
        sr1.Is_a_Tech__c = true;
        sr1.name = 'Test Resource 1';
        srList.add(sr1);
        insert srList;
        
        List<serviceappointment> saList = new List<serviceappointment>();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa.SchedStartTime=datetime.now()+3;
        sa.SchedEndTime=datetime.now()+4;
        sa.Service_Order__c= objWorkOrder.id;
        sa.Is_a_Tech_Appointment__c = true;
        sa.Assigned_ServiceResource__c = sr.Id;
        saList.add(sa);
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = objWorkOrder.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa1.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa1.SchedStartTime=sa.SchedStartTime;
        sa1.SchedEndTime=sa.SchedEndTime;
        sa1.Service_Order__c= objWorkOrder.id;
        sa1.Is_a_Tech_Appointment__c = true;
        sa1.Assigned_ServiceResource__c = sr1.Id;
        saList.add(sa1);
        insert saList;
        sa.Status = 'Scheduled';
        sa1.status = 'Scheduled';
        update saList;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = st.Id;
        ftm.FSL_Work_Type__c = workType.Id;
        ftm.One_Form_Per_Service_Order__c = true;
        insert ftm;
        
        sa.status = 'Dispatched';
        update sa;
    	sa1.status = 'Dispatched';
        update sa1;
        Test.stopTest();
    } 
    
    @isTest
    public static void testCreateFormOnePerSA(){
    	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
        Test.startTest();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
         Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
			acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
        
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
        Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        Id SRTDataId = [Select Id From RecordType Where SobjectType = 'CSS_Make_Model_Access__c' AND DeveloperName = 'SRTData'].Id;
        CSS_Make_Model_Access__c makemodel = new CSS_Make_Model_Access__c();
        makemodel.Make__c = 'MAKE';
        makemodel.Model__c = 'MODEL';
        makemodel.EngineFamilyCode__c = 'TEST';
        makemodel.RecordTypeId = SRTDataId;
        insert makemodel;
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'External-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = acc.Id;
        asset1.FSL_Site__c = addr.Id;
        asset1.Engine_Family_Code__c = 'TEST';
        asset1.Make_Model__c = makemodel.Id;
        asset1.Application__c = '130 - AUTOMOTIVE';
        insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType FTM';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        FSL_SubType__c st = new FSL_SubType__c();
        st.Name ='TestSubTypeFTM';
        insert st;

        FSL_SMN_DTC__c smn = new FSL_SMN_DTC__c();
        smn.name = 'TEST SMN';
        smn.FaultTypeFC__c = 'Yes';
        insert smn;
        //Test.startTest();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = workType.Id;
        objWorkOrder.FSL_Sub_Type__c = st.id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        objWorkOrder.Repair_Site_Address__c = addr.Id;
        objWorkOrder.Repair_Location__c = 'Mobile';
        objWorkOrder.FSL_SMN__c = smn.Id;
        insert objWorkOrder;
        
        List<ServiceResource> srList = new List<ServiceResource>();
        ServiceResource sr = new ServiceResource();
        sr.RelatedRecordId = UserInfo.getUserId();
        sr.Is_a_Tech__c = true;
        sr.name = 'Test Resource';
        srList.add(sr);
        ServiceResource sr1 = new ServiceResource();
        sr1.RelatedRecordId = u.Id;
        sr1.Is_a_Tech__c = true;
        sr1.name = 'Test Resource 1';
        srList.add(sr1);
        insert srList;
        
        List<serviceappointment> saList = new List<serviceappointment>();
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa.SchedStartTime=datetime.now()+3;
        sa.SchedEndTime=datetime.now()+4;
        sa.Service_Order__c= objWorkOrder.id;
        sa.Is_a_Tech_Appointment__c = true;
        sa.Assigned_ServiceResource__c = sr.Id;
        saList.add(sa);
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = objWorkOrder.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa1.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa1.SchedStartTime=sa.SchedStartTime;
        sa1.SchedEndTime=sa.SchedEndTime;
        sa1.Service_Order__c= objWorkOrder.id;
        sa1.Is_a_Tech_Appointment__c = true;
        sa1.Assigned_ServiceResource__c = sr1.Id;
        saList.add(sa1);
        insert saList;
        sa.Status = 'Scheduled';
        sa1.status = 'Scheduled';
        update saList;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = st.Id;
        ftm.FSL_Work_Type__c = workType.Id;
        ftm.One_Form_Dispatched_ServiceAppointment__c = true;
        insert ftm;
        
        sa.status = 'Dispatched';
        update sa;
        sa1.status = 'Dispatched';
        update sa1;
        Test.stopTest();
    }
    
    @isTest
    public static void populateTechnicianDispatchStatus_New(){
        serviceappointment sass=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        test.startTest();
        sass.Status = 'Dispatched';
        update sass;
        test.stopTest();
    } 
    
    @isTest
    public static void populateTechnicianDispatchStatus_FTR(){
        serviceappointment sass=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        workorder wko = [Select id, Is_Tech_Dispatched__c, Process_Step__c from workorder where Shop_Work_Order__c='00001234'];
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        //soe.Name = 'FTR soe';
        soe.Service_Order_Id__c = wko.Id;
        soe.FSL_ABRFlag__c = True;
        insert soe;
        wko.Service_Order_Extension__c = soe.Id;
        update wko;
        test.startTest();
        sass.Status = 'Dispatched';
        update sass;
        test.stopTest();
    } 
    
     @isTest
    public static void createForms_New(){
        serviceappointment getSA=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        Account getA=[Select id from Account where Name='Timothy_Guidanz'];
        workorder getWO=[Select id from workorder Where RPV_Notification_Flag__c='RNFLAG']; 
        
        test.startTest();
        getSA.Status = 'Dispatched';
        update getSA;
        
         disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = stype.Id;
        ftm.FSL_Work_Type__c = pmWorkType.Id;
        ftm.Account__c =getA.Id;
        ftm.One_Form_Per_Service_Order__c = true;
        insert ftm;
        
        disco__Form__c dis = new disco__Form__c(Service_Order__c=getWO.id,disco__Form_Template__c=formTemplate.id,Form_Template_Matrix__c=ftm.id);
        insert dis;
        test.stopTest();
    }
    
      @isTest
    public static void createForms_New2(){
        serviceappointment getSA=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        Account getA=[Select id from Account where Name='Timothy_Guidanz'];
        workorder getWO=[Select id from workorder Where RPV_Notification_Flag__c='RNFLAG'];
        
        test.startTest();
        getSA.Status = 'Dispatched';
        update getSA;
         set<Id> saIds=new set<Id>();
        saIds.add(getSA.Id);
        
         disco__Form_Template__c testTemp = new disco__Form_Template__c(name='Test',FSL_Approval_Status__c='Approved' , disco__Status__c='In Use');
        insert testTemp;
        
         List<disco__Form__c> forms = [Select id,disco__Form_Template_Name__c From disco__Form__c Where Service_Order__c=:getWO.Id];
      
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
         WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = stype.Id;
        ftm.FSL_Work_Type__c = pmWorkType.Id;
        ftm.Account__c = getA.Id;
        ftm.One_Form_Per_Service_Order__c = true;
        
        insert ftm;
        
        disco__Form__c dis = new disco__Form__c(Service_Order__c=getWO.id,disco__Form_Template__c=formTemplate.id);
        insert dis;
        
       FSL_ServiceAppointmentHelper.createForms(saIds);
  
        test.stopTest();
    }
    
     @isTest
    public static void createForms_New3(){
        serviceappointment getSA=[Select id from serviceappointment where Formatted_Scheduled_Start__c='FSS'];
        Account getA=[Select id from Account where Name='Timothy_Guidanz'];
        workorder getWO=[Select id from workorder Where RPV_Notification_Flag__c='RNFLAG'];  
        
        test.startTest();
        getSA.Status = 'Dispatched';
        update getSA;
         set<Id> saIds=new set<Id>();
        saIds.add(getSA.Id);
        
         disco__Form_Template__c testTemp = new disco__Form_Template__c(name='Test',FSL_Approval_Status__c='Approved' , disco__Status__c='In Use');
        insert testTemp;
        
         List<disco__Form__c> forms = [Select id,disco__Form_Template_Name__c From disco__Form__c Where Service_Order__c=:getWO.Id];
      
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
         WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = stype.Id;
        ftm.FSL_Work_Type__c = pmWorkType.Id;
        ftm.Account__c = getA.Id;
        ftm.One_Form_Dispatched_ServiceAppointment__c = true;
        insert ftm;
        
        disco__Form__c dis = new disco__Form__c(Service_Order__c=getWO.id,disco__Form_Template__c=formTemplate.id);
        insert dis;
        
       FSL_ServiceAppointmentHelper.createForms(saIds);
  
        test.stopTest();
    }
    
     @isTest
    public static void populateResourceDetails_New(){
        BusinessHours bhs=[select id from BusinessHours where IsDefault=true];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardusnew2@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testingnew', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardunew2@testorg.com'
                          , FederationIdentifier ='zxABCNew2',
                          Country='United States',Street='14 ABC',City='Columbus',State='Indiana',PostalCode='74201');
        insert u;

        test.startTest();
        Id accRecId= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc= new Account();
        acc.RecordTypeId=accRecId;
        acc.Name='Timothy';
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.AccountId=acc.id;
      //  insert con;
        
        Asset ase= new Asset();
        ase.name='79788861New22';
        ase.AccountId=acc.Id;
        //ase.ContactId=con.Id;
        ase.Safety_Requirement__c=True;
        ase.Type__c='Engines';
        ase.Type_PSN__c='Engines-79642834';
        ase.Engine_Family_Code__c = '10';
        insert ase;
        
        WorkType wt=new WorkType();
        wt.Name='Test work type';
        wt.EstimatedDuration=60.00;
        insert wt;
                
        ServiceResource sr=new ServiceResource();
        sr.Name='service resource';
        sr.IsActive=true;
        sr.RelatedRecordId=u.id;
        sr.ResourceType='T';
        sr.Is_a_Tech__c=true;
        insert sr;
        
        OperatingHours oh=new OperatingHours();
        oh.name ='test operating hours';
        // oh.TimeZone='(GMT-04:00EasternDaylightTime(America/Indiana/Indianapolis))';
        insert oh;

        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile2';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-00000';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234-00000';
        objServiceTerritory.OperatingHoursId = oh.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory; 
        
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=sr.id;
        stm.ServiceTerritoryId=objServiceTerritory.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
       
        workorder getWO=new workorder();
        getWO.AccountId=acc.id;
       // getWO.ContactId=con.id;
        getWO.Repair_Location__c='In Shop';
        getWO.AssetId=ase.id;
        getWO.Process_Step__c = 'Intake';
        getWO.Available_for_Service__c=datetime.now()+3;
        getWO.WorkTypeId= wt.Id;
        getWO.Shop_Work_Order__c='00001234';
        getWO.AssignedResource__c ='Teswtst';
        getWO.ServiceTerritoryId = objServiceTerritory.id;
        getWO.Process_Step__c ='Schedule';
        insert getWO;
        
        Map<id,serviceappointment> oldmap = new Map<id,serviceappointment>();
        Map<id,serviceappointment> newmap = new Map<id,serviceappointment>();
        
        serviceappointment getSA= new serviceappointment();
        getSA.parentrecordId = getWO.Id;
        getSA.Status = 'None';
        getSA.EarliestStartTime = datetime.now().addDays(2);
        getSA.DueDate = System.now().addDays(30);
        getSA.SchedStartTime=datetime.now().addDays(3);
        getSA.SchedEndTime = datetime.now().addDays(4);
        getSA.Service_Order__c= getWO.id;
        getSA.Formatted_Scheduled_Start__c='populateResourceDetails';
        getSA.Is_a_Tech_Appointment__c=true;
        insert getSA;
        
      
        oldmap.put(getSA.id,getSA);
        getSA.Status='Scheduled';
        newmap.put(getSA.id,getSA);
        FSL_ServiceAppointmentHelper.populateResourceDetails(newmap,oldmap);
        test.stopTest();
    } 
    
    @isTest
    public static void postToChatter_Test(){
        test.startTest();
        List<serviceappointment> lstSA=new List<serviceappointment>();
        serviceappointment getSA=[SELECT Id,SR_Clocked_In__c,Overdue_Alert_Sent__c,FSL_Passedschtime__c FROM serviceappointment WHERE Formatted_Scheduled_Start__c='FSS' LIMIT 1];
        system.debug('getSA'+getSA);
        getSA.FSL_Passedschtime__c=true;
        //getSA.SR_Clocked_In__c=false;
        getSA.Overdue_Alert_Sent__c=false;
        upsert getSA;
        lstSA.add(getSA);
        //test.startTest();//Added by Krishna for soql 101 error
        FSL_ServiceAppointmentTriggerHandler.postToChatter(lstSA);
        FeedItem post = new FeedItem();
        post.ParentId = lstSA[0].Id;
        post.Body='test';
        Insert post;
        test.stopTest();
    }
    
}