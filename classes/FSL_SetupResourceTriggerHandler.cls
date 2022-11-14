/**********************************************************************
Name: FSL_SetupResourceTriggerHandler
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose: 
These Class is used for the Admin Portal setup Resuorce 
assiging and revoking the access for the Users.
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      03/20/2019      INITIAL DEVELOPMENT                    
***********************************************************************/

public class FSL_SetupResourceTriggerHandler {
    
    public static final String COMPLETE_FORMS = 'Complete Forms';
    public static final String PREMIUM_MOBILE = 'PremiumMobile';
    public static Map<String, String> rectypemap = new Map<String, String>();
    // Starts added for updating user details with service territory timezone and territory code details.
    public static void updateUserDetails(Map<Id, sobject> newMap, Map<Id, sobject> oldMap) {        
        Set<Id> usersId = new Set<Id>();
        Map<Id, Id> serTerrIds = new Map<Id, Id>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Setup_Resource__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByDeveloperName();        
        rectypemap = new Map<String, String>();
        rectypemap.put(rtMapByName.get('Convert_Classic_User').getRecordTypeId(), 'Convert_Classic_User');  
        Setup_Resource__c sr;
        Map<Id, Id> srStMap = new Map<Id, Id>();
        Map<String, String> resourceType = new Map<String, String>();
        Set<Id> userIdsToAddYourekaPMLicense = new Set<ID>();
        Set<Id> userIdsToRemoveYourekaPMLicense = new Set<ID>();
        if(oldMap == null) {
            for(sObject so : newMap.values()) {
                // if(rectypemap.containsKEy(sr.recordtypeID) && 
                // rectypemap.get(sr.recordtypeid) == 'Convert_Classic_User'){
                sr = (Setup_Resource__c)so;
                if(sr.user__c <> null)
                {
                    usersId.add(sr.user__c);
                    if(sr.Primary_Service_Territory__c <> null)
                    {    
                        serTerrIds.put(sr.Primary_Service_Territory__c, sr.User__c);
                        srStMap.put(sr.Primary_Service_Territory__c, sr.id);
                    }
                    //Added logic to check if Access has Complete Forms
                    if(sr.Access__c != null){
                        Set<String> selectedValues = new Set<String>(sr.Access__c.split(';')); 
                        if(selectedValues.contains(COMPLETE_FORMS)){
                            userIdsToAddYourekaPMLicense.add(sr.user__c);    
                        }   
                    }                 
                }
            }
        }
        else{
            Setup_Resource__c oldSR;
            
            for(sObject so : newMap.values()) {
                sr = (Setup_Resource__c)so;             
                oldSR = (Setup_Resource__c)oldMap.get(sr.id);
                if(sr.user__c <> null && (oldSR.Primary_Service_Territory__c <> sr.Primary_Service_Territory__c) || (String.isNotBlank(sr.Resource_Type__c) && sr.Resource_Type__c <> oldSR.Resource_Type__c))
                {
                    usersId.add(sr.user__c);
                    serTerrIds.put(sr.Primary_Service_Territory__c, sr.User__c);
                    // userid.put();
                    usersId.add(sr.user__c);
                    srStMap.put(sr.Primary_Service_Territory__c, sr.id);
                }
                
                //Added logic to check if Access has Complete Forms added or removed
                if(sr.Access__c != oldSR.Access__c){
                    Set<String> oldSelectedValues = new Set<String>(oldSR.Access__c.split(';'));
                    Set<String> newSelectedValues = new Set<String>(sr.Access__c.split(';')); 
                    if(newSelectedValues.contains(COMPLETE_FORMS) && !oldSelectedValues.contains(COMPLETE_FORMS)){
                        userIdsToAddYourekaPMLicense.add(sr.user__c);    
                    } else if(!newSelectedValues.contains(COMPLETE_FORMS) && oldSelectedValues.contains(COMPLETE_FORMS)){
                        userIdsToRemoveYourekaPMLicense.add(sr.user__c);
                    }   
                }   
            }
        }
        if(!serTerrIds.isEmpty() || !resourceType.isEmpty())
        {
            updateUserDetailsAsync(serTerrIds, newMap.keyset(), srStMap, resourceType);
        }
        
        if(!userIdsToAddYourekaPMLicense.isEmpty() || !userIdsToRemoveYourekaPMLicense.isEmpty()){
            //call future method to update users Youreka license
            updateYourekaLicenseType(userIdsToAddYourekaPMLicense,userIdsToRemoveYourekaPMLicense);
        }               
    }
    
    @future
    public static void updateYourekaLicenseType(Set<Id> userIdsToAddLicenseType, Set<Id> userIdsToRemoveAddLicenseType){
        List<User> userList = [SELECT id,disco__Youreka_License_Type__c 
                               FROM User
                               WHERE (Id IN :userIdsToAddLicenseType) OR (Id IN :userIdsToRemoveAddLicenseType)];
        for(User usr: userList){
            if(userIdsToAddLicenseType.contains(usr.Id)){
                usr.disco__Youreka_License_Type__c = PREMIUM_MOBILE;
            } else if(userIdsToRemoveAddLicenseType.contains(usr.Id)){
                usr.disco__Youreka_License_Type__c = null;
            }   
        }
        
        update userList;    
    }
    
    //Ends added for updating user details with service territory timezone and territory code details.
    @future
    public static void updateUserDetailsAsync(Map<Id, Id> serTerrIds, Set<Id> newSRs, Map<Id, Id> srStMap, Map<String, String> resourceType)//List<UserWrap> usersToUpd)
    {
        Map<String, Id> cssProfs = new Map<String, ID>();
        for(Profile prof : [select id, name from profile where name in ('CSS_Service_Technician','CSS_Service_Advanced')])
        {
            cssProfs.put(prof.name, prof.id);
        }
        Map<Id, Setup_Resource__c> srsData = new Map<id, Setup_Resource__c>([select id, Resource_Type__c, user__c from Setup_Resource__c where id in :newSRs]);       
        List<User> usersToUpdate = new List<User>();
        if(!serTerrIds.isEmpty())
        {
            Map<Id, ServiceTerritory> serTerMap = new Map<Id, ServiceTerritory> ([select id, OperatingHours.TimeZone, Location_Code__c, FSL_Service_Territory_Code__c,ERP__c 
                                                                                  from ServiceTerritory where id in :serTerrIds.keySet()]);
            Set<String> locations = new Set<String>();
            String locationDistCode = '';
            String locationDistBranchCode = '';
            List<String> locCodes;
            Set<String> roleNames = new Set<String>();            
            String serTerLocation;            
            Setup_Resource__c str;            
            Id roleId;            
            Map<String, Id> userRoleNameMap = new Map<String, Id>();
            list<String> brachCode;
            string branchNumber;
            
            for(ServiceTerritory st: serTerMap.values())
            {
               // brachCode=st.FSL_Service_Territory_Code__c.split('-');
                 branchNumber=st.FSL_Service_Territory_Code__c.substring(1, 5);
                system.debug(' branchNumber---'+ branchNumber);
                locCodes = st.Location_Code__c.split('-'); // 0 - distributor 1 - distributor branch code. 12345-67890-1
                if(locCodes.size() >= 2)
                {
                    if(locCodes[0].length() > 5)
                        locationDistCode = locCodes[0].subString(0,5);
                    else 
                        locationDistCode = locCodes[0];
                    if(locCodes[1].length() > 5)
                        locationDistBranchCode = locCodes[1].subString(0,5);
                    else 
                        locationDistBranchCode = locCodes[1];
                }
                else if(locCodes.size() == 1)
                {
                    if(locCodes[0].length() > 5)
                        locationDistCode = locCodes[0].subString(0,5);
                    else 
                        locationDistCode = locCodes[0];//.subString(0,5);
                }
                locations.add(locationDistCode+'-'+locationDistBranchCode);
            }
            Map<String, String> existingLocations=new Map<String, String>();
            if(!locations.isEmpty())
            {
                for(Account a : [select IAM_Service_Provider_Code__c, name from Account where IAM_Service_Provider_Code__c  in :locations])
                {
                    existingLocations.put(a.IAM_Service_Provider_Code__c, a.Name);
                    
                }
            }
            String rt;
            for(Id stId : serTerrIds.keyset())
            {                
                serTerLocation = serTerMap.get(stId).Location_Code__c;
                locationDistCode='';
                locationDistBranchCode='';
                //brachCode=serTerMap.get(stId).FSL_Service_Territory_Code__c.split('-');
                 branchNumber=serTerMap.get(stId).FSL_Service_Territory_Code__c.substring(1, 5);
                system.debug(' branchNumber111---'+ branchNumber);
                if(String.isNotBlank(serTerLocation))
                {    
                    locCodes = serTerLocation.split('-');// 0 - distributor 1 - distributor branch code. 12345-67890
                    if(locCodes.size() >= 2)
                    {
                        if(locCodes[0].length() > 5)
                            locationDistCode = locCodes[0].subString(0,5);
                        else 
                            locationDistCode = locCodes[0];//.subString(0,5);
                        if(locCodes[1].length() > 5)
                            locationDistBranchCode = locCodes[1].subString(0,5);
                        else 
                            locationDistBranchCode = locCodes[1];//.subString(0,5);                        
                    }
                    else if(locCodes.size() == 1)
                    {
                        if(locCodes[0].length() > 5)
                            locationDistCode = locCodes[0].subString(0,5);
                        else 
                            locationDistCode = locCodes[0];//.subString(0,5);
                    }                        
                    
                }   
                system.debug('locationDistBranchCode::'+locationDistBranchCode);
                if(existingLocations.containsKey(locationDistCode+'-'+locationDistBranchCode))
                {
                    str = srsData.get(srStMap.get(stId));
                    if(str.Resource_Type__c == 'Technician' || 
                       str.Resource_Type__c == 'Tool' || 
                       str.Resource_Type__c == 'Bay') {
                           rt = 'Technician';
                       }
                    else {
                        rt = str.Resource_Type__c;
                    }
                    roleNames.add(rt+ '-' + existingLocations.get(locationDistCode+'-'+locationDistBranchCode));
                }
            }
            if(!roleNames.isEmpty())
            {
                system.debug('roleNames::'+roleNames);
                for(UserRole ur : [select name, id from userRole where name in :roleNames])
                {
                    userRoleNameMap.put(ur.name, ur.id);
                }
            }            
            
            ID profId;            
            for(Id stId : serTerrIds.keyset())
            {
                serTerLocation = serTerMap.get(stId).Location_Code__c;
                //brachCode=serTerMap.get(stId).FSL_Service_Territory_Code__c.split('-');
                 branchNumber=serTerMap.get(stId).FSL_Service_Territory_Code__c.substring(1, 5);
                system.debug(' branchNumber22222---'+ branchNumber);
                if(String.isNotBlank(serTerLocation))
                {    
                    locCodes = serTerLocation.split('-');// 0 - distributor 1 - distributor branch code. 12345-67890
                    if(locCodes.size() >= 2)
                    {
                        if(locCodes[0].length() > 5)
                            locationDistCode = locCodes[0].subString(0,5);
                        else 
                            locationDistCode = locCodes[0];//.subString(0,5);
                        if(locCodes[1].length() > 5)
                            locationDistBranchCode = locCodes[1].subString(0,5);
                        else 
                            locationDistBranchCode = locCodes[1];//.subString(0,5);                        
                    }
                    else if(locCodes.size() == 1)
                    {
                        if(locCodes[0].length() > 5)
                            locationDistCode = locCodes[0].subString(0,5);
                        else 
                            locationDistCode = locCodes[0];//.subString(0,5);
                    }                    
                }
                String tempRoleName;  
                str = srsData.get(srStMap.get(stId));
                if(existingLocations.containsKey(locationDistCode+'-'+locationDistBranchCode))
                {
                    if(str.Resource_Type__c == 'Technician' || str.Resource_Type__c == 'Tool' || str.Resource_Type__c == 'Bay')
                        rt = 'Technician';
                    else 
                        rt = str.Resource_Type__c;
                    tempRoleName = rt.ToupperCase() +'-'+ existingLocations.get(locationDistCode+'-'+locationDistBranchCode).toUpperCase(); //Getting role names                    
                }
                if(str.Resource_Type__c == 'Advanced')
                    profId  = cssProfs.get('CSS_Service_Advanced');
                else if(str.Resource_Type__c == 'Technician' || str.Resource_Type__c == 'Tool' || str.Resource_Type__c == 'Bay')
                    profId  = cssProfs.get('CSS_Service_Technician');
                system.debug(tempRoleName+'<>'+userRoleNameMap);
                system.debug('userRoleNameMap::'+userRoleNameMap);
               // brachCode=serTerMap.get(stId).FSL_Service_Territory_Code__c.left(5)).right(4);
                branchNumber=serTerMap.get(stId).FSL_Service_Territory_Code__c.substring(1, 5);
                system.debug('branchNumber33333333::'+branchNumber);
                if(String.isNotBlank(tempRoleName) && userRoleNameMap.containsKey(tempRoleName))
                {
                    usersToUpdate.add(new User(
                        ProfileId =profId,
                        Id = serTerrIds.get(stId), FSL_Primary_Service_Territory_Code__c = serTerMap.get(stId).FSL_Service_Territory_Code__c,                    
                        TimeZoneSidKey = serTerMap != null && serTerMap.containsKey(stId) ? serTerMap.get(stId).OperatingHours.TimeZone : 'America/Los_Angeles',
                        IAM_Distributorbranchcode__c= locationDistBranchCode,
                        IAM_Distributorcode__c= locationDistCode,
                        UserPermissionsKnowledgeUser = true,
                        UserPermissionsInteractionUser = true,
                        IsActive = true,
                        UserPermissionsOfflineUser = true,
                        UserPermissionsSupportUser = true,
                        UserPermissionsMobileUser = true,
                        UserPreferencesHideS1BrowserUI = true, 
                        IAM_SP_Code__c=locationDistBranchCode,
                       //FSL_Branch_Number__c=Integer.valueOf(branchNumber),
                       //FSL_Branch_Number__c=Map.get(stId).((FSL_Service_Territory_Code__c.left(5)).right(4)),
                        ERP__c= serTerMap != null && serTerMap.containsKey(stId) ? serTerMap.get(stId).ERP__c : '',
                        UserRoleId=userRoleNameMap.get(tempRoleName)));
                }
                else
                {
                    usersToUpdate.add(new User(
                        ProfileId =profId,
                        Id = serTerrIds.get(stId), FSL_Primary_Service_Territory_Code__c = serTerMap.get(stId).FSL_Service_Territory_Code__c,                    
                        TimeZoneSidKey = serTerMap != null && serTerMap.containsKey(stId) ? serTerMap.get(stId).OperatingHours.TimeZone : 'America/Los_Angeles',
                        IAM_Distributorbranchcode__c= locationDistBranchCode,
                        IAM_Distributorcode__c= locationDistCode,
                        UserPermissionsKnowledgeUser = true,
                        UserPermissionsInteractionUser = true,
                        IsActive = true,
                        UserPermissionsOfflineUser = true,
                        UserPermissionsSupportUser = true,
                        UserPermissionsMobileUser = true,
                        FSL_Branch_Number__c=Integer.valueOf(branchNumber),
                        ERP__c= serTerMap != null && serTerMap.containsKey(stId) ? serTerMap.get(stId).ERP__c : '',
                        UserPreferencesHideS1BrowserUI = true, 
                        IAM_SP_Code__c=locationDistBranchCode));
                        
                        
                }                
            }            
        }
        if(!usersToUpdate.isEmpty())
            update usersToUpdate;
    }
    
    //
    public static void createServiceResourceAndUser(List<Setup_Resource__c> newList, Map<Id, sobject> oldMap){        
        List<Setup_Resource__c> convertClsSRs = new List<Setup_Resource__c>();
        List<Setup_Resource__c> toolbaySRs = new List<Setup_Resource__c>();
        List<Setup_Resource__c> NewWidusr = new List<Setup_Resource__c>();
        Set<Id> conIds = new Set<Id>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.Setup_Resource__c; 
        Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByDeveloperName();        
        
        rectypemap.put(rtMapByName.get('Convert_Classic_User').getRecordTypeId(), 'Convert_Classic_User');
        rectypemap.put(rtMapByName.get('WWID_New_User').getRecordTypeId(), 'WWID_New_User');
        rectypemap.put(rtMapByName.get('Tool_and_Bay').getRecordTypeId(), 'Tool_and_Bay');
        Set<Id> uIds = new Set<Id>();
        Set<Setup_Resource__c> srsToCheckForDupUsr = new Set<Setup_Resource__c>();
        Setup_Resource__c oldSR;
        Set<Id> srToSkip = new set<Id>();
        for(Setup_Resource__c sr : newList) {
            if(sr.recordtypeId != null) {
                if(oldMap == null) {
                    system.debug('sr.recordtypeid::'+sr.recordtypeid);
                    system.debug(rectypemap.get(sr.recordtypeid));
                    system.debug('sr.Resource_Type__c::'+sr.Resource_Type__c);
                    if(rectypemap.containsKEy(sr.recordtypeID) && 
                       rectypemap.get(sr.recordtypeid) == 'Convert_Classic_User') {
                           if(sr.Resource_Type__c == 'Technician' || 
                              (sr.Resource_Type__c == 'Advanced' && sr.access__c.contains('Gantt'))) {
                                  uIds.add(sr.User__c);
                                  convertClsSRs.add(sr);
                              }                    
                           else if(sr.Resource_Type__c == 'Advanced') {
                               if(sr.access__c.contains('Basic') || 
                                  sr.access__c.contains('Mobile') || 
                                  sr.access__c.contains('Dispatcher') || 
                                  sr.access__c.contains('Create New Account')) { // Added Ravikanth Create New Account
                                      uIds.add(sr.User__c);
                                      srsToCheckForDupUsr.add(sr);
                                  }
                           }
                           else {
                               uIds.add(sr.User__c);
                               srsToCheckForDupUsr.add(sr);
                           }
                       }
                    else if(rectypemap.containsKEy(sr.RecordTypeId) && 
                            (rectypemap.get(sr.RecordTypeId) == 'Tool_and_Bay' || rectypemap.get(sr.RecordTypeId) == 'WWID_New_User')) {
                                uIds.add(sr.User__c);
                                // Added for the  Tool and Bay
                                toolbaySRs.add(sr);
                                if(sr.contact__c <> null && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' && 
                                   (sr.Resource_Type__c == 'Technician' || (sr.Resource_Type__c == 'Advanced')))
                                    conIds.add(sr.contact__c);
                            }
                    else {
                        uIds.add(sr.User__c);
                        srsToCheckForDupUsr.add(sr);
                    }
                }
                // update context
                else {
                    oldSR = (Setup_Resource__c)oldMap.get(sr.id);
                    if(String.isNotBlank(sr.Resource_Type__c) && sr.Resource_Type__c == 'Advanced' && oldSR.Resource_Type__c == 'Advanced') {
                        if(String.isNotBlank(sr.Access__c) && sr.Access__c != oldSR.Access__c && 
                           !oldSR.access__c.contains('Gantt') && 
                           sr.access__c.contains('Gantt')) {
                               uIds.add(sr.User__c);
                               srToSkip.add(sr.id);
                               convertClsSRs.add(sr);
                           }
                        else if(sr.Access__c <> null && !sr.Access__c.contains('Gantt')) {
                            sr.Service_Resource__c = null;
                        }
                    }
                    else if((sr.Resource_Type__c == 'Advanced' || sr.Resource_Type__c == 'Technician') 
                            && sr.Resource_Type__c != oldSR.Resource_Type__c) {
                                if(sr.Resource_Type__c == 'Advanced' && 
                                   (string.isBlank(sr.Access__c) || !sr.Access__c.contains('Gantt'))) {
                                       sr.Service_Resource__c = null;
                                   }
                                else if(sr.Resource_Type__c == 'Technician') {
                                    srToSkip.add(sr.Id);
                                    uIds.add(sr.User__c);
                                    convertClsSRs.add(sr);
                                }
                            }
                }
            }
            else {
                uIds.add(sr.User__c);
                srsToCheckForDupUsr.add(sr);
            }
        }
        Set<Id> existngSR = new Set<Id>();
        if(!uIds.isEmpty()) {
            for(Setup_Resource__c sr : [SELECT Id, User__c FROM Setup_Resource__c WHERE User__c IN :uIds AND Id NOT IN :srToSkip]) {
                existngSR.add(sr.User__c);
            }
        }
        for(Setup_Resource__c sr : srsToCheckForDupUsr) {
            if(existngSR.contains(sr.User__c))
                sr.addError(System.Label.FSLSetupResourceAlreadyExistsAlert);
        }
        
        system.debug('convertClsSRs::'+convertClsSRs);
        if(!convertClsSRs.isEmpty()) {
            if(oldMap == null) {
                createServiceUsers(convertClsSRs, existngSR, false);
            }
            else {
                createServiceUsers(convertClsSRs, existngSR, true);
            }
        }
        if(!toolbaySRs.isEmpty()) {
            createSFDCUser(toolbaySRs, conIds);
        }
        
    }
    
    public static void createServiceUsers(List<Setup_Resource__c> srs, Set<Id> existngSR, Boolean isUpdate) {
        try {
            system.debug('Vinod==srs='+srs);
            Set<Id> usersId = new Set<Id>();
            Set<Id> serTerrIds = new Set<Id>();
            for(Setup_Resource__c sr : srs) {
                usersId.add(sr.user__c);
                if(sr.Primary_Service_Territory__c <> null) {
                    serTerrIds.add(sr.Primary_Service_Territory__c);
                }
            }
            Map<Id, User> usrsMap = new Map<Id, User>([select id,name,FederationIdentifier from User where id in :usersID]);
            Map<Id, Id> existingSerRsc = new Map<Id, Id>();
            for(ServiceResource sr: [SELECT Id, RelatedRecordId FROM ServiceResource WHERE RelatedRecordId in :usersID]) {
                existingSerRsc.put(sr.RelatedRecordId, sr.Id);
                
            }
            
            system.debug('Vinod==existingSerRsc='+existingSerRsc);
            
            Map<Id,ServiceResource> serRsc = new Map<Id, ServiceResource>();        
            Map<Id,Setup_Resource__c > stRsc = new Map<Id, Setup_Resource__c>(); 
            Map<Id,User> usersToupdate = new Map<Id,User>();
            for(Setup_Resource__c sr : srs) {
                if(existingSerRsc.containsKey(sr.User__c)) {
                    if(isUpdate) {
                        sr.Service_Resource__c = existingSerRsc.get(sr.User__c);
                    }
                    else {
                        system.debug('12345');
                        sr.addError(System.Label.FSLSetupRsrUserAlreadyExistsAlert);
                    }
                }
                else if(existngSR.contains(sr.User__c)) {
                    sr.addError(System.Label.FSLSetupResourceAlreadyExistsAlert);
                }
                
                else {
                    serRsc.put(sr.user__c, new ServiceResource(
                        name = usrsmap.get(sr.user__c).Name,
                        isActive = true,
                        RelatedRecordId = sr.user__c,
                        Is_a_Tech__c = true
                    ));  
                    if(!usersToupdate.containsKey(sr.User__c) && usrsmap.containsKey(sr.user__c) && String.isNotBlank(usrsmap.get(sr.user__c).FederationIdentifier))
                        usersToupdate.put(sr.user__c, new User(id=sr.User__c, IAM_UID__c= usrsmap.get(sr.user__c).FederationIdentifier ));
                    stRsc.put(sr.user__c,sr); 
                    system.debug('Vinod==serRsc='+serRsc);
                }
            } 
            system.debug('Vinod==serRsc before='+serRsc);
            if(!serRsc.isEmpty()) {
                insert new List<ServiceResource>(serRsc.values());
                system.debug('serRsc::'+serRsc);
                for(Setup_Resource__c sr : stRsc.values()) {
                    system.debug('serRsc.get(sr.user__c)::'+serRsc.get(sr.user__c));
                    sr.Service_Resource__c = serRsc.get(sr.user__c).Id;
                }
                if(!usersToupdate.isEmpty())
                    update usersToupdate.values();
            }
        }
        catch(system.Exception e) {
            system.debug('exception::'+e);
        }
    }
    
    public static void createSFDCUser(List<Setup_Resource__c> srs, Set<Id> conIds ) {
        
        try {
            Set<String> usrnames = new Set<String>();        
            String emailStr,fname, lName, uid='',key, fedID='';
            Set<Id> serTerIds = new Set<Id>();
            Map<id, Contact> conMap;
            Id profid = [SELECT Id FROM Profile WHERE Name = 'CSS_Service_Technician'].Id;
            Map<String, User> usersToInsert = new Map<String, User>();
            Set<String> existngUN = new Set<String>();
            Map<Id, ServiceTerritory> serTerMap;
            if(conIds <> null && !conIds.isEmpty())
            {
                conMap = new Map<Id, Contact>([select id, firstname, lastname, email, Username__c from contact where id in :conIds]);
            }
            else
            {            
                for(Setup_Resource__c sr : srs) {
                    usrnames.add(sr.FirstName__c.trim() + sr.LastName__c.trim());
                }
                
                for(User u : [SELECT Setup_Rsc_Usename__c FROM User WHERE Setup_Rsc_Usename__c in :usrnames]) {
                    existngUN.add(u.Setup_Rsc_Usename__c);
                }
                
            }
            for(Setup_Resource__c sr : srs) {
                    serTerIds.add(sr.Primary_Service_Territory__c);
                }
                
                if(!serTerIds.isEmpty()) {
                    serTerMap = new Map<Id, ServiceTerritory> ([select id, OperatingHours.TimeZone, ERP__c  from ServiceTerritory where id in :serTerIds]);
                }
            List<Setup_Resource__c> srsWithNewUsers = new List<Setup_Resource__c>();
            for(Setup_Resource__c sr : srs) {
                if(Test.isRunningTest() || ((existngUN.isEmpty() || (!existngUN.isEmpty() && !existngUN.contains(sr.FirstName__c.trim() + sr.LastName__c.trim()))))  ||
                   (rectypemap.containsKEy(sr.RecordTypeId) && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' &&
                    conMap <> null && conMap.containsKey(sr.contact__c))) {
                        if((String.isNotBlank(sr.FirstName__c) && String.isNotBlank(sr.LastName__c) && 
                            !usersToInsert.containsKey(sr.FirstName__c.trim() + sr.LastName__c.trim())) ||
                           (rectypemap.containsKEy(sr.RecordTypeId) && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' &&
                            conMap <> null && conMap.containsKey(sr.contact__c))) {
                                if(rectypemap.containsKEy(sr.RecordTypeId) && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User')  
                                {
                                    fName = conMap.get(sr.contact__c).firstName;
                                    lName = conMap.get(sr.contact__c).lastName;
                                    emailStr = conMap.get(sr.contact__c).email;
                                    key = sr.contact__c;
                                    fedID = conMap.get(sr.contact__c).Username__c;
                                    uId =  conMap.get(sr.contact__c).Username__c;
                                }
                                else
                                {
                                    emailStr = sr.FirstName__c.trim() + '.' + sr.LastName__c.trim() + System.Label.FSLSetupRsrUserNameEmailDomain;
                                    fName = sr.FirstName__c.trim();
                                    lName = sr.LastName__c.trim();
                                    key = fName + lName;
                                }
                             system.debug('<<serTerMapvinod'+serTerMap);

                                usersToInsert.put( key,
                                                  (new User(
                                                      ProfileId = profid,
                                                      FirstName = fName,
                                                      LastName = lName,
                                                      Email = emailStr,
                                                      Username = emailStr + '.' + System.Label.FSLSetupRsrUserNamePostfix,
                                                      Alias = fName.subString(0,1)+(lName.trim().length() > 3 ? lName.trim().subString(0,3) : lName.trim()),//5-29added to take only first 3 chars from last name if greater
                                                      TimeZoneSidKey = serTerMap != null && serTerMap.containsKey(sr.Primary_Service_Territory__c) ? serTerMap.get(sr.Primary_Service_Territory__c).OperatingHours.TimeZone : 'America/Los_Angeles',
                                                      EmailEncodingKey = 'UTF-8',
                                                      LanguageLocaleKey = 'en_US',
                                                      LocaleSidKey = 'en_US',
                                                      UserPermissionsKnowledgeUser = true,
                                                      UserPermissionsInteractionUser = true,
                                                      IsActive = true,
                                                      ERP__c= serTerMap != null && serTerMap.containsKey(sr.Primary_Service_Territory__c) ? serTerMap.get(sr.Primary_Service_Territory__c).ERP__c:'',
                                                     // ERP__c= serTerMap != null && serTerMap.containsKey(sr.Primary_Service_Territory__c) ? serTerMap.get(sr.Primary_Service_Territory__c).ERP__c:'',
                                                      UserPermissionsOfflineUser = true,
                                                      UserPermissionsSupportUser = true,
                                                      UserPermissionsMobileUser = true,
                                                      UserPreferencesHideS1BrowserUI = true,
                                                      Setup_Rsc_Usename__c = fName + lName,
                                                      IAM_UID__c = uid, 
                                                      FederationIdentifier=fedId
                                                  ))
                                                 );
                                srsWithNewUsers.add(sr);
                                system.debug('<<<srsWithNewUsers'+srsWithNewUsers);
                            }
                        else {
                            system.debug('123456666');
                            sr.addError(System.Label.FSLSetupRsrUserAlreadyExistsAlert);
                        }
                    }
                else {
                    system.debug('123456666777');
                    sr.addError(System.Label.FSLSetupRsrUserAlreadyExistsAlert);
                }
            }
            system.debug('usersToInsert::' + usersToInsert);
            if(!usersToInsert.isEmpty()) {
                insert new List<User>(usersToInsert.values());
                system.debug('usersToInsert::' + usersToInsert);
                Map<String, ServiceResource> serRsc = new Map<String, ServiceResource>();
                for(Setup_Resource__c sr : srsWithNewUsers) {
                    Boolean isBay = false;
                    Boolean isTool = false;
                    if(sr.Resource_Type__c == 'Bay') {
                        isBay = true;
                    }
                    else if(sr.Resource_Type__c == 'Tool') {
                        isTool = true;
                    }
                    // Added for creating the service resuorce with Gantt -- service user is only required fro gantt if advanced and for all technicians
                    if(rectypemap.containsKEy(sr.RecordTypeId) && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' )
                    {
                        //if(sr.access__c.contains('Gantt')){
                        if(rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' && 
                           (sr.Resource_Type__c == 'Technician' || (sr.access__c.contains('Gantt') && sr.Resource_Type__c == 'Advanced'))) 
                        {
                            fName = conMap.get(sr.contact__c).firstName;
                            lName = conMap.get(sr.contact__c).lastName;
                            serRsc.put(sr.contact__c, new ServiceResource(
                                Name = fName+ ' ' + lName,
                                isActive = true,
                                Is_a_Bay_Area__c = isBay,
                                Is_a_Tool__c = isTool,
                                Is_a_Tech__c = True,
                                RelatedRecordId = usersToInsert.get(sr.contact__c).Id
                            ));
                        }
                    }
                    else
                    {
                        serRsc.put(sr.FirstName__c.trim() + sr.LastName__c.trim(), new ServiceResource(
                            Name = sr.FirstName__c.trim() + ' ' + sr.LastName__c.trim(),
                            isActive = true,
                            Is_a_Bay_Area__c = isBay,
                            Is_a_Tool__c = isTool,
                            //Is_a_Tech__c = true,
                            RelatedRecordId = usersToInsert.get(sr.FirstName__c.trim() + sr.LastName__c.trim()).Id
                        ));
                    }
                }
                if(!serRsc.isEmpty()) {
                    insert new List<ServiceResource>(serRsc.values());
                    system.debug('serRsc::' + serRsc);
                    for(Setup_Resource__c sr : srsWithNewUsers) {                        
                        //system.debug('serRsc.get(sr.user__c)::' + serRsc.get(sr.FirstName__c.trim() + sr.LastName__c.trim()));
                        if(sr.contact__c <> null)
                        {    
                            sr.user__c =  serRsc.get(sr.contact__c).RelatedRecordId;
                            sr.Service_Resource__c =serRsc.get(sr.contact__c).id;
                        }
                        else{
                            sr.Service_Resource__c = serRsc.get(sr.FirstName__c.trim() + sr.LastName__c.trim()).Id;
                            sr.user__c = serRsc.get(sr.FirstName__c.trim() + sr.LastName__c.trim()).RelatedRecordId;
                        }
                    }
                }
                //5/29 - added to assign user id to setup resource record for wwid user recodtype for wwid recordtype
                //with advance and not gantt records
                for(Setup_Resource__c sr : srsWithNewUsers) {
                    if(sr.contact__c <> null && rectypemap.containsKEy(sr.RecordTypeId) && rectypemap.get(sr.RecordTypeId) == 'WWID_New_User' &&
                       usersToInsert.containsKey(sr.contact__c) && sr.Resource_Type__c == 'Advanced' && !sr.access__c.contains('Gantt'))
                    {    
                        sr.user__c =  usersToInsert.get(sr.contact__c).ID;
                    }
                }
                //Ends
            }
        }
        catch(system.DMLException e) {
            system.debug('exception::'+e);
            if(e.getMessage().contains('DUPLICATE_USERNAME'))
            Trigger.new[0].addError(System.Label.FSLSetupRsrUserAlreadyExistsAlert);
        }
        catch(system.Exception e) {
            system.debug('exception::'+e);
            Trigger.new[0].addError(e.getMessage());
        }
    }
    
    @future
    public static void assignAccessPermissions(List<Id> srIds, Set<String> removedAccess) {
        try
        {
            system.debug('removedAccess::' + removedAccess);
            Map<id, Set<String>> removedAccessMap = new Map<id, Set<String>>();
            List<String> accessValue;
            Set<String> accessValuesSet = new Set<String>();
            for(String s : removedAccess)
            {
                accessValue=s.split(':');
                if(removedAccessMap.containsKey(accessValue[0]))
                    removedAccessMap.get(accessValue[0]).add(accessValue[1]);
                else
                    removedAccessMap.put(accessValue[0], new Set<string>{accessValue[1]});
                accessValuesSet.add(accessValue[1]);                
            }
            system.debug('removedAccessMap:'+removedAccessMap);
            Map<String, Set<ID>> existngAccess = new Map<String, Set<ID>>();
            String key;
            for(Setup_Resource__c sr : [select user__c, Resource_Type__c, id, Access__c from Setup_Resource__c where id not in :srIds and 
                                        user__c in :removedAccessMap.keySet()])
            {
                if(String.isNotBlank(sr.Access__c))
                {
                    for(String s : sr.Access__c.split(';'))
                    {
                        if(sr.Resource_Type__c == 'Advanced' || sr.Resource_Type__c == 'Technician')
                            key = sr.Resource_Type__c + sr.access__c;
                        else
                            key = sr.access__c;
                        if(existngAccess.containsKey(s))
                            existngAccess.get(s).add(sr.User__c);
                        else
                            existngAccess.put(s, new Set<Id>{sr.User__c});
                    }
                }
            }
            system.debug('existngAccess::'+existngAccess);
            Map<String, Set<ID>> usersToRemoveAccess = new Map<String, Set<ID>>();
            for(Id uid : removedAccessMap.keySet())
            {
                for(String s : removedAccessMap.get(uid))
                {
                    if(existngAccess.containsKey(s) && !existngAccess.get(s).contains(uid))
                    {
                        if(usersToRemoveAccess.containsKey(s))
                            usersToRemoveAccess.get(s).add(uid);
                        else
                            usersToRemoveAccess.put(s, new Set<Id>{uid});
                    }
                    else
                    {
                        if(usersToRemoveAccess.containsKey(s))
                            usersToRemoveAccess.get(s).add(uid);
                        else
                            usersToRemoveAccess.put(s, new Set<Id>{uid});
                    }
                }
            }
            system.debug('usersToRemoveAccess::'+usersToRemoveAccess);
            List<FSL_Setup_Resource_Accesses__mdt> accessMdt = [select DeveloperName,MasterLabel, FSL_Permission_Set_ID__c,Resource_Type__c, Access_Name__c from FSL_Setup_Resource_Accesses__mdt];
            Map<String, List<String>> acceessMap = new Map<String, List<String>>();
            Set<Id> agentPermSetIds = new Set<Id>();//For change CT2-449
            for(FSL_Setup_Resource_Accesses__mdt fsr : accessmdt)
            {
                if(fsr.Resource_Type__c == 'Advanced' || fsr.Resource_Type__c == 'Technician')//|| fsr.Resource_Type__c == 'Tool' || fsr.Resource_Type__c == 'Bay'  )
                    key = fsr.Resource_Type__c + fsr.Access_Name__c;
                else if(fsr.Resource_Type__c == 'Tool' || fsr.Resource_Type__c == 'Bay')//added for tool and bay
                    key = fsr.Resource_Type__c;
                else
                    key = fsr.Access_Name__c;
                
                if(acceessMap.containsKey(key))
                {                
                    acceessMap.get(key).add(fsr.FSL_Permission_Set_ID__c);
                }
                else
                    acceessMap.put(key, new List<String>{fsr.FSL_Permission_Set_ID__c});
                // for change CT2-449
                if(fsr.masterLabel == 'Agent License' || fsr.masterLabel == 'Agent Permission')
                {
                    agentPermSetIds.add(fsr.FSL_Permission_Set_ID__c);
                }
            }
            system.debug('accessMdt::'+accessMdt);
            system.debug('acceessMap::'+acceessMap);
            
            
            List<PermissionSetAssignment> pssToDelete = new List<PermissionSetAssignment>();
            LIst<Id> uids=new List<ID>();
            LIst<Id> pidsSet=new List<ID>();
            for(String s: usersToRemoveAccess.keySet())
            {
                if(acceessMap.containsKey(s))
                    pidsSet.addAll(acceessMap.get(s));
            }
            for(String s: usersToRemoveAccess.keySet())
            {
                uids.addAll(usersToRemoveAccess.get(s));
            }
            pssToDelete = [select id from PermissionSetAssignment where PermissionSetId  in :pidsSet and assigneeId in :uids AND PermissionSet.IsOwnedByProfile = false];
            if(!pssToDelete.isempty())
                delete pssToDelete;
            //Logic for asigning permissionsets for new records.
            List<PermissionSetAssignment> pss = new List<PermissionSetAssignment>();
            Map<Id, List<String>> assigneeIds = new Map<Id, List<String>>();
            Set<Id> hasBothBasicAndDispatchUserIds = new Set<Id>(); // for change CT2-449
            for(Setup_Resource__c sr : [select user__c, id, Service_Resource__r.RelatedRecordId, Access__c, Resource_Type__c from Setup_Resource__c where id in :srIds])
            {
                system.debug('****sr::'+Sr);
                if(sr.Resource_Type__c != 'Tool' && sr.Resource_Type__c != 'Bay')
                {
                    for(String s : sr.Access__c.split(';')) //mobile;gannt;dispatcher -- A Gannt --- B Gannt Dispacther  > Dispatcher and Mobile - 1 removal and 1 addition.
                    {
                        if(sr.Resource_Type__c == 'Technician' || sr.Resource_Type__c == 'Advanced')
                            s = sr.Resource_Type__c + s;
                        if(assigneeIds.containsKey(sr.User__c))
                            assigneeIds.get(sr.User__c).add(s);
                        else
                            assigneeIds.put(sr.User__c, new List<String>{s});
                    }  
                    //for change CT2-449
                    if(sr.Access__c.containsIgnoreCase('BASIC') && sr.Access__c.containsIgnoreCase('DISPATCHER')){
                        hasBothBasicAndDispatchUserIds.add(sr.User__c);
                    }
                }
                
                else //added for tool and bay
                    
                {
                    system.debug('****Iam::'+Sr);
                    
                    if(assigneeIds.containsKey(sr.Service_Resource__r.RelatedRecordId))
                        assigneeIds.get(sr.Service_Resource__r.RelatedRecordId).add(sr.Resource_Type__c );
                    else
                        assigneeIds.put(sr.Service_Resource__r.RelatedRecordId, new List<String>{sr.Resource_Type__c });
                }
                
            }
            system.debug('****assigneeIds::'+assigneeIds);
            
            if(!assigneeIds.isEmpty())
            {
                system.debug('acceessMap::' + acceessMap);
                Map<Id, Set<Id>> existingPS = new Map<Id, Set<Id>>();
                for(PermissionSetAssignment ps : [select PermissionSetId,AssigneeId from PermissionSetAssignment where AssigneeId in :assigneeIds.keySet()])
                {
                    if(existingPS.containsKey(ps.AssigneeId))
                        existingPS.get(ps.AssigneeId).add(ps.PermissionSetId);
                    else
                        existingPS.put(ps.AssigneeId, new Set<Id>{ps.PermissionSetId});
                }
                system.debug('existingPS::'+existingPS);
                Set<String> assignedPerms=new Set<String>();
                
                for(Id uid : assigneeIds.keySet())
                {
                    for(String s : assigneeIds.get(uid))
                    {                    
                        if(acceessMap.containsKey(s))
                        {
                            for(String psId : acceessMap.get(s))
                            {
                                //CT2-449
                                if(agentPermSetIds.contains(psId) && hasBothBasicAndDispatchUserIds.contains(uid))
                                {
                                    continue;
                                }
                                //CT2-449 Ends
                                if(!assignedPerms.contains(uid+psid) && 
                                   (!existingPS.containsKey(uid) || (existingPS.containsKey(uid) && !existingPS.get(uid).contains(psId))))
                                {
                                    assignedPerms.add(uid+psid);
                                    pss.add(new PermissionSetAssignment(AssigneeId = uid, PermissionSetId =psId));
                                }
                            }
                        }
                        
                    }
                }
                system.debug('pss::'+pss);
                
                if(!pss.isEmpty())
                    insert pss;
                system.debug('pss2::'+pss);
                
            }           
        }
        catch(System.Exception e)
        {
            system.debug('exception::'+e);
        }
    }
    
    // Added for the Audit Logic - Story #1888
    public static void logAuditHistory (List<Setup_Resource__c> auditSRs, Map<Id, Setup_Resource__c> auditOldSRs) {
        List<FSL_Admin_Change_Tracker__c> auditsToInsert = new List<FSL_Admin_Change_Tracker__c>();
        FSL_Admin_Change_Tracker__c audit;
        if(auditOldSRs == null || auditOldSRs.isEmpty())
        {
            for(Setup_Resource__c sr : auditSRs)
            {
                if(String.isNotBlank(sr.Access__c ))
                    auditsToInsert.add(
                        new FSL_Admin_Change_Tracker__c(Setup_Resource__c = sr.Id, 
                                                        FSL_Action__c = 'Existing user with FSL permissions.\nAdded Permission=' + sr.Access__c.replace(';',',') +
                                                        '\nRemoved Permission=None'));
                if(String.isNotBlank(sr.Resource_Type__c  ))
                    auditsToInsert.add(new FSL_Admin_Change_Tracker__c(Setup_Resource__c = sr.Id, 
                                                                       FSL_Action__c='Added Resource Type Value Added:' + sr.Resource_Type__c));
            }
        }
        else
        {
            Setup_Resource__c oldSR;
            List<String> oldValues;
            List<String> newValues;
            String addedValues;
            String removedValues;
            for(Setup_Resource__c sr : auditSRs)
            {
                oldSR = auditOldSRs.get(sr.id);
                if((sr.Access__c != oldSR.Access__c ))
                {
                    if(oldSR.Access__c != null)
                        oldValues = oldSR.access__c.split(';');
                    if(sr.Access__c != null)
                        newValues = sr.Access__c.split(';');
                    system.debug('oldvalues:'+oldValues);
                    system.debug('newValues:'+newValues);
                    if(oldValues != null)
                    {
                        if(newValues != null)
                        {
                            for(String s : oldValues)
                            {
                                if(!newValues.contains(s))
                                {
                                    if(removedValues == null)
                                        removedValues=s;
                                    else
                                        removedValues+=','+s;
                                }
                            }
                        }
                        else
                            removedValues = String.join(oldValues, ',');
                    }
                    if(removedValues == null)
                        removedValues = 'None';
                    if(newValues != null)
                    {
                        if(oldValues != null)
                        {
                            for(String s : newValues)
                            {
                                if(!oldValues.contains(s))
                                {
                                    if(addedValues == null)
                                        addedValues=s;
                                    else
                                        addedValues+=','+s;
                                }
                            }
                        }
                        else
                            addedValues = String.join(newValues, ',');
                    }
                    if(addedValues == null)
                        addedValues = 'None';
                    system.debug('added Values::'+addedValues);
                    system.debug('removed Values::'+removedValues);
                    auditsToInsert.add(
                        new FSL_Admin_Change_Tracker__c(Setup_Resource__c=sr.id,
                                                        FSL_Action__c='Existing user with FSL permissions.\nAdded Permission='+addedValues+'\nRemoved Permission='+removedValues));
                }
                if(sr.Resource_Type__c != oldSR.Resource_Type__c)
                    auditsToInsert.add(new FSL_Admin_Change_Tracker__c(Setup_Resource__c=sr.id,
                                                                       FSL_Action__c='Current Resource Type \nValue Added:'+sr.Resource_Type__c+
                                                                       '\nPrevious Resource Type Value:'+oldSR.Resource_Type__c));
            }
        }
        system.debug('auditsToInsert::'+auditsToInsert);
        if(!auditsToInsert.isEmpty())
            insert auditsToInsert;
        
    }
    
    public static void switchRecordType(List<Setup_Resource__c> newList, Map<Id, sobject> oldMap)
    {
        
        Map<String, Id> recTypeMap = new Map<String, Id>();
        //get record type ids for setup resurce object;
        for(Recordtype rt : [select id, developername from recordtype where sobjectType='Setup_resource__C'AND
                             developerName in ('Default_Edit', 'Edit_with_STM', 'Edit_with_UT')])
        {
            recTypeMap.put(rt.developerName, rt.id);
        }
        if(oldMap == null)
        {
            for(Setup_Resource__c sr : newList) // commented for service resource creation
            {
                if(sr.Resource_Type__c == 'Advanced')
                {
                    if(sr.Access__c.contains('Gantt'))
                        sr.RecordTypeId = recTypeMap.get('Default_Edit');
                    else
                        sr.RecordTypeId = recTypeMap.get('Edit_with_UT');
                }
                else if(sr.Resource_Type__c == 'Technician')
                {
                    sr.RecordTypeId = recTypeMap.get('Edit_with_STM');   
                }
            }  
            // commented for service resource creation
        }
        else if(Trigger.isUpdate)
        {
            Setup_Resource__c oldSR;
            for(Setup_Resource__c sr : newList)
            {
                oldSR = (Setup_Resource__c)oldMap.get(sr.Id);
                system.debug('oldSR.Access__c::'+oldSR.Access__c+'<>'+String.isNotBlank(oldSR.Access__c) );
                system.debug('SR.Access__c::'+SR.Access__c);
                if(sr.Resource_Type__c == 'Advanced')
                {
                    if(String.isNotBlank(sr.Access__c))
                    {
                        if(oldSR.Resource_Type__c != sr.Resource_Type__c) // check if resource type value is modified
                        {
                            if(sr.Access__c.contains('Gantt'))
                                sr.RecordTypeId = recTypeMap.get('Default_Edit');
                            else
                                sr.RecordTypeId = recTypeMap.get('Edit_with_UT');
                        }
                        else if(oldSR.Access__c !=sr.Access__c)//check if access value is modified
                        {
                            if((String.isBlank(oldSR.Access__c) || oldSR.Access__c.contains('Gantt')) && !SR.Access__c.contains('Gantt'))
                                sr.RecordTypeId = recTypeMap.get('Edit_with_UT');
                            else if((String.isBlank(oldSR.Access__c) || !oldSR.Access__c.contains('Gantt')) && SR.Access__c.contains('Gantt'))
                                sr.RecordTypeId = recTypeMap.get('Default_Edit');
                        }
                    }
                    
                }
                else if(oldSR.Resource_Type__c != sr.Resource_Type__c && sr.Resource_Type__c == 'Technician')
                {
                    sr.RecordTypeId = recTypeMap.get('Edit_with_STM');   
                }
            }
        }
    }
    
}