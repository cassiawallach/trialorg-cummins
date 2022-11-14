//Added for Code Coverage
@isTest
public class FSL_CL_GetShopVehicles_Test {
 @isTest static void getShopVehicleNumbers(){
        
        OperatingHours opH = new OperatingHours();
        opH.Name = 'test'+system.now();
        opH.TimeZone = 'America/New_York';
        insert opH;
        ServiceTerritory stnew = new ServiceTerritory();
        stnew.name = 'Test'+system.now();
        stNew.OperatingHoursId = opH.id;
        stNew.FSL_Service_Territory_Code__c ='04977-IA';
        stNew.Location_Code__c = '04959-04977-Ip';
        stNew.Region__c = 'NORTH AMERICA';
        stNew.Territory__c = 'UNITED STATES';
        stNew.Type__c = 'GROUP';
        insert stNew;
        ServiceTerritory stnew1 = new ServiceTerritory();
        stnew1.name = 'Test'+system.now()+1;
        stNew1.OperatingHoursId = opH.id;
        stNew1.FSL_Service_Territory_Code__c ='04977-IA1';
        stNew1.Location_Code__c = '04959-04977-Ip1';
        stNew1.Region__c = 'NORTH AMERICA';
        stNew1.Territory__c = 'UNITED STATES';
        stNew1.ParentTerritoryId = stNew.Id;
        stNew1.IsActive = true;
        insert stNew1;
        
        
		ServiceTerritoryMember stm = new ServiceTerritoryMember();
		stm.ServiceTerritoryId = stNew1.Id; 
       	Id profid = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        //create user
        List<User> users = new List<User>();
        users.add(new User(
            ProfileId = profid,
            LastName = 'testUser',
            Email = 'testUserRaghav@testEmail.com',
            Username = 'testUserRaghav@testEmail.com',
            CompanyName = 'testCompany',
            Title = 'testTitle',
            Alias = 'testUsr',
            ERP__C = 'BMS',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true,
            IAM_UID__c = 'testUserRaghav@testEmail.com',
            FederationIdentifier = 'testUserRaghav@testEmail.com'
        ));
       // Insert users;
        ServiceResource sr = new ServiceResource();
        user u = [select id from user where profile.name = 'CSS_Service_Advanced' and isactive = true limit 1];
        sr.User__c = u.id;
        sr.name = 'sd';
        sr.relatedrecordid = u.id;
        sr.IsActive = true;
        //.ServiceCrewId = sc.id;
        insert sr;
        stm.ServiceResourceId = sr.id;
       	//stm.TerritoryType = 'Primary';
       	stm.EffectiveStartDate = system.now();
        Insert stm;
        workOrder wo = new workOrder();
        wo.ServiceTerritoryId = stNew1.Id;
        wo.Service_Team_Contact__c = u.id;
        try{
            insert wo;
        }catch(Exception e){
            System.debug(e.getMessage());
        }
        system.debug('at 77'+wo);
        wo = [select id,ServiceTerritory.ParentTerritoryId from workorder limit 1];
        System.debug(stNew.Id);
        System.debug(wo.ServiceTerritory.ParentTerritoryId);
        List<Id> woId = new List<Id>();
        woId.add(wo.Id);
        Shop_Vehicle_Number__c svc = new Shop_Vehicle_Number__c();
        svc.name = string.valueOf(system.now());
        svc.Service_Territory__c = stNew.id;
        insert svc;
        //WorkOrder serOrder =[Select id,ServiceTerritoryId,ServiceTerritory.ParentTerritoryId,
//                         ServiceTerritory.Type__c from workOrder
        //                 where ServiceTerritory.ParentTerritory.Type__c='GROUP' and id in :woId limit 1];
        //System.debug('abc'+serOrder);
       List<List<Shop_Vehicle_Number__c>> result =FSL_CL_GetShopVehicles.getShopVehicleNumbers(woId); 
        //system.debug('at 84'+result);
        FSL_CL_GetUserDefinedVehicle.getShopVehicleNumbers(woId);
    }
    
}