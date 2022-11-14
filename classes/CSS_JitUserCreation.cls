/**********************************************************************
Name:  CSS_JitUserCreation
Copyright © 2011  Cummins
======================================================
======================================================
Purpose:                                                            
Create and Update Distributor and Dealer Users
Note: Update for Dealer Role is still pending                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                DATE            DETAIL
1.0 -    Sandeep Ravikanti    3/8/2016        INITIAL DEVELOPMENT                    
2.0 -    Gyan Pany            7/4/2016        Modified for following Defect Fixes
                                              62791, 62792, 62793, 62795,62798
2.1 -    Gyan Pany            9/20/2016       Defect ID - 68558
2.2 -    Gyan Pany            12/5/2016       Story 77088 - As a CSS Warranty Claims user, my account  
                                              should not be reset by CSS user provisioning logic
2.3 -    Vignesh S            03/02/2017      Story 85634 - As a dealer data exchange user, I need JIT classes 
                                              updated such that my role/profile is handled properly
3.0 -    Anirudh Pesari       05/24/2017      Story 89785 -As a CSS admin, I will need to be able to parse multiple 
                                              workgroup IDs from LDAP to display to the user in CSS     
3.1-    Rajesh Narra          12/26/2017      Story 124599 need to be updated, This enhancement is used to support the 
                                              CIHR user to access the Guidanz through user provisioning.
3.2-    Rajesh Narra          02/01/2018      Need to add the Guidanz users to the content public groups,
                                              based on the type of user(dealer or distributor).
3.3-    Rajesh Narra          02/12/2018      As part of this CRQ 130369 Rajesh Narra have added the following String.isNotBlank(factoryWorkGroupFirstFiveDigits) 
                                              == String.isNotBlank(factoryWorkGroupFirstFiveDigits) criteria to check weather the first five digits and last five 
                                              digits of the workgroupid is equal or not.
3.4-    Krishnamoorthi        11/07/2018      167730 - As the Guidanz Product Owner, I need updates to JIT so that it will support Mexico, 
                                              Puerto Rico and other locations with same HQ and Branch location codes
3.5-   	Rajkumar/Vamsi		  09/20/2021	  Added logic to bypass JIT for Dealer Evolution (IsPartner) locations
***********************************************************************/
global class CSS_JitUserCreation implements Auth.SamlJitHandler
{   
    private class CSS_JITProvException extends Exception{}
    
    String distributorCode,dealerCode,distribranchCode,fleetCode,cumminsEmployeeEmailAddress;
    Account acctn;
    Contact cont = new Contact();
    Set<Id> acctnIDs = new Set<Id>();
    Set<String> cssMatchingAttriValues = new Set<String>();
    public Map<String,String> accountLocaleMap = new Map<String,String> ();
    public Map<String,String> accountLanguageMap = new Map<String,String> ();
    public Map<String,String> accountTimeZoneMap = new Map<String,String> ();
    public Map<String,String> accountEmailEncodingMap = new Map<String,String> ();
    public String Fedid;
    public String FName {get;set;}
    public String Workgroupid {get; set;}
    public String CumminsUserID {get;set;}
    public Boolean emailSent{get;set;}
    public Boolean accountVerified;
    public boolean cssAppUsrAccountValidation;
    public boolean cssAPPUsr;
    public boolean appAccess;
    public boolean cssVerifiedUser;
    public Map<String,String> attributesMap = new Map<String,String>();
    public String surname{get;set;}
    Public String applications{get;set;}
    public string guidanzSP = '';   //167730 - Krishnamoorthi
    public string primaryWorkgroupId;
    //public string userHave = '';
    
    public User usr = new User();
    
    global User createUser( Id samlSsoProviderId, Id communityId, Id portalId,String federationIdentifier, 
                           Map<String, String> attributes, String assertion)
    { 
        guidanzSP = Label.CSS_Guidanz_SP;   //167730 - Krishnamoorthi 
        system.debug('**CSS JIT Create Method BEGIN**');
        System.debug('**CSS JIT Create Method - Raw Attributes  = '+attributes);
        
        //START - 167730 - Krishnamoorthi - Allowing only OAM Service provider.
        //if(guidanzSP != null && guidanzSP != '' && guidanzSP == 'OAM') {
            applications=Parser.parse(assertion);       
            system.debug('Printing attributes from the Parser class'+applications);
        //}
        //END - 167730 - Krishnamoorthi - Allowing only OAM Service provider.
        Map<String,String> attributesUpper = new Map<String,String>();

        for(String sKey :attributes.Keyset())
        {
            attributesUpper.put(skey.toUpperCase(),attributes.get(sKey));
        }
        System.debug('**CSS JIT Create Method - Convert Attributes to UpperCase = '+attributesUpper);
        attributes.clear();
        attributes = attributesUpper;

        //System.debug('assertion VAlues: '+assertion);
        System.debug('**CSS JIT Create Method - Value of Community ID = '+communityId);
        System.debug('**CSS JIT Create Method - Value of Portal ID = '+portalId);
        if(attributes.containsKey('FLEETCODE') && (String.isNotBlank(attributes.get('FLEETCODE')) && attributes.get('FLEETCODE')!=null)){
            portalId = System.label.CSS_OrgPortalId;    
            communityId = System.label.CSS_CommunityId;
            System.debug('Fleet portalID==>'+portalId);
            System.debug('Fleet attributes:  => '+attributes);
            //usr = new User();
            cssVerifiedUser = cssApplicationAccessCheck(true,usr,communityId,portalId,federationIdentifier,attributes);
            //System.debug('cssVerifiedUser '+cssVerifiedUser+cssApplicationAccessCheck(true,usr,communityId,portalId,federationIdentifier,attributes) );
            dealerContentAccess(String.valueOf(federationIdentifier));
            System.debug('cssVerifiedUser '+cssVerifiedUser );
        }else if(attributes.containsKey('DEALERCODE') && (String.isNotBlank(attributes.get('DEALERCODE')) && attributes.get('DEALERCODE')!=null)){
            portalId = System.label.CSS_OrgPortalId;    
            communityId = System.label.CSS_CommunityId; 
            System.debug('portalID==>'+portalId);
            System.debug('attributes:  => '+attributes);
            //usr = new User();
            //System.debug('cssVerifiedUser '+cssVerifiedUser+cssApplicationAccessCheck(true,usr,communityId,portalId,federationIdentifier,attributes) );
            cssVerifiedUser = cssApplicationAccessCheck(true,usr,communityId,portalId,federationIdentifier,attributes);
            dealerContentAccess(String.valueOf(federationIdentifier));
            System.debug('cssVerifiedUser '+cssVerifiedUser );
        }
        else{
            cssVerifiedUser = cssApplicationAccessCheck(true,usr,communityId,portalId,federationIdentifier,attributes);
            //START - 167730 - Krishnamoorthi
            /*if(attributes.containsKey('DISTRIBUTORBRANCHCODE') && (String.isNotBlank(attributes.get('DISTRIBUTORBRANCHCODE')) 
            && attributes.get('DISTRIBUTORBRANCHCODE')!=null)) {    //Checking DISTRIBUTORBRANCHCODE has value
                if(attributes.containsKey('DISTRIBUTORCODE') && (String.isNotBlank(attributes.get('DISTRIBUTORCODE')) 
                && attributes.get('DISTRIBUTORCODE')!=null)) {      //Checking DISTRIBUTORCODE has value
                    if(attributes.get('DISTRIBUTORBRANCHCODE') != attributes.get('DISTRIBUTORCODE')) {  //Distributor NOT EQUAL TO distributorbranchcode.
                        userHave = 'Distributor';
                        distributorContentAccess(String.valueOf(federationIdentifier));
                    } else {        //Distributor EQUAL TO distributorbranchcode.
                        //HQ User
                        identifyHQUser(federationIdentifier, attributes);
                    }
                }
            } else {    //DISTRIBUTORBRANCHCODE has NULL
                Workgroupid = attributes.get('WORKGROUP');
                Workgroupid = Workgroupid.replace('|', ';');
                system.debug('Workgroupid>>>>>>>'+Workgroupid);
                list<String> wrkgrpIds = Workgroupid.split(';');
                String factoryWorkGroupid;          //CRQ 130369
                List<String> splitFirstWorkGroupId = new List<String>(); //CRQ 130369
                String factoryWorkGroupFirstFiveDigits; //CRQ 130369
                String factoryWorkGroupSecondFiveDigits; //CRQ 130369
                if(wrkgrpIds!=null && wrkgrpIds.size()>0){ 
                    factoryWorkgroupid = wrkgrpIds[0]; 
                    if(factoryWorkgroupid!=null && String.isNotEmpty(factoryWorkgroupid)){
                        splitFirstWorkGroupId = factoryWorkgroupid.split('-');
                        if(splitFirstWorkGroupId!=null && splitFirstWorkGroupId.size()>0){
                            factoryWorkGroupFirstFiveDigits = splitFirstWorkGroupId[0];
                            factoryWorkGroupSecondFiveDigits = splitFirstWorkGroupId[1];
                            System.debug('** first'+factoryWorkGroupFirstFiveDigits);
                            System.debug('** second'+factoryWorkGroupSecondFiveDigits);
                        }
                    }
                    
                }
                if(Workgroupid != null && Workgroupid != '' && factoryWorkgroupid != null && factoryWorkgroupid != '') {
                    if(factoryWorkGroupFirstFiveDigits == factoryWorkGroupSecondFiveDigits) {
                        //HQ USER.
                        identifyHQUser(federationIdentifier, attributes);
                    } else {
                        //JIT ERROR.
                        system.debug('** WWWID is Invalid **');
                        accountVerified = false;
                    }
                } else {
                    //JIT ERROR.
                    system.debug('** WWWID is Invalid **');
                    accountVerified = false;
                }
            }
            
            distributorContentAccess(String.valueOf(federationIdentifier));
            System.debug('** Service'+attributes);
            if((attributes.containsKey('DISTRIBUTORCODE') && (String.isBlank(attributes.get('DISTRIBUTORCODE')) || attributes.get('DISTRIBUTORCODE')==null)) && 
            (attributes.containsKey('DISTRIBUTORBRANCHCODE') && (String.isBlank(attributes.get('DISTRIBUTORBRANCHCODE')) || attributes.get('DISTRIBUTORBRANCHCODE')==null))) {
                System.debug('*** Providing access to dealer mateiral');
                dealerContentAccess(String.valueOf(federationIdentifier));
            }
            System.debug('The returned Value if new user:'+cssVerifiedUser);
            */
            //END - 167730 - Krishnamoorthi
        }
        if(cssVerifiedUser){
            System.debug('Contact id :'+usr.ContactId);
            // user.portalID='0603B0000004cB9';
            System.debug('Created Use Detatils'+usr);
            System.debug('portalID==>'+portalId);
            System.debug('account Created Succesfully');
            system.debug('**CSS JIT Create Method END cssVerifiedUser=' + cssVerifiedUser);
            return usr; 
        } else {
            system.debug('**CSS JIT Create Method END cssVerifiedUser=' + cssVerifiedUser);
            //sendEmail();
            if(!Test.isRunningTest()){
            	throw new CSS_JITProvException('You are not authorized to access Guidanz with this URL anymore');
            }
            else{
                return null;
            }
            //return null;
       }
    
    }
    
    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
                           String federationIdentifier, Map<String, String> attributes, String assertion){
                               
        Boolean verifyUser = verifyPartnerUser(attributes);
        If(verifyUser == true){
        	throw new CSS_JITProvException('You are not authorized to access Guidanz with this URL anymore');
        }
        guidanzSP = Label.CSS_Guidanz_SP;   //167730 - Krishnamoorthi                         
        system.debug('**CSS JIT Update Method BEGIN**');
        //System.debug('Printing Assertion'+assertion);
        Map<String,String> attributesUpper = new Map<String,String>();
        System.debug('**CSS JIT Update Method - Raw Attributes  = '+attributes);
        
        //START - 167730 - Krishnamoorthi - Allowing only OAM Service provider.
        //if(guidanzSP != null && guidanzSP != '' && guidanzSP == 'OAM') {
            applications=Parser.parse(assertion);       
            system.debug('Printing attributes from the Parser class'+applications); 
        //}
        //END - 167730 - Krishnamoorthi - Allowing only OAM Service provider.
        
        for(String sKey :attributes.Keyset())
        {
            attributesUpper.put(skey.toUpperCase(),attributes.get(sKey));
            //System.debug(skey.toUpperCase());
        }
        System.debug('**CSS JIT Update Method - Convert Attributes to UpperCase = '+attributesUpper);
        attributes.clear();
        attributes = attributesUpper;
        for(String sKey: attributes.Keyset()){
            system.debug('** '+attributes.get(sKey));
        }
        String MailId_Test = attributes.get('MAIL');
        System.debug('** Email Id'+MailId_Test);
        try { 
            usr = [SELECT Id, FirstName,federationIdentifier,UserRoleId,ProfileId, Modify_Role_Manually__c FROM User WHERE Id=:userId];
            System.debug('**CSS JIT Update Method - Display attributed in TRY block: --->'+attributes);
            cssVerifiedUser = cssApplicationAccessCheck(false,usr,communityId,portalId,federationIdentifier,attributes);
            //getInfoBtnDisplay();
            if(!cssVerifiedUser){
                system.debug('**CSS JIT Update Method - END** Verfied = ' + cssVerifiedUser);
                throw new CSS_JITProvException('No Valid Account Found');
            }
            system.debug('**CSS JIT Update Method - END** Verfied = ' + cssVerifiedUser);
        } 
        catch(exception e){
            system.debug('**CSS JIT Update Method Exception - END**' + e.getLineNumber() + ' ' +e.getMessage());
            throw new CSS_JITProvException('No Valid Account Found');
        }
    }
    
    public boolean cssApplicationAccessCheck(boolean create, User user ,Id communityId, Id portalId,String federationIdentifier, Map<String, String> attributes)
    {
        system.debug('**CSS JIT Application Access Check Method - BEGIN**');
        system.debug('**CSS JIT Application Access Check Method - Invoked from create value = ' + create);
        system.debug('**CSS JIT Application Access Check Method - User Value = ' + user);
        Fedid = attributes.get('UID');

        if( attributes.containsKey('UID') && attributes.get('UID')!= null){
            user.FederationIdentifier = attributes.get('UID');
        } else {
            user.FederationIdentifier = federationIdentifier;
        }
        if(!user.isActive)
        {
            user.IsActive = true;
        }
        
        //if (attributes.containsKey('MEMBER')) {
        if (attributes.containsKey('APPLICATIONGROUPS')) {
            //String member = attributes.get('MEMBER');
            String member = attributes.get('APPLICATIONGROUPS');
            /*String[] memberList = member.Split(',');
            for(String st:memberList){
                if((st.contains('cn=CSS_') || st.contains('cn=css_')||st.Contains('APP_CSS'))){
                    cssMatchingAttriValues.add(st.substringAfter('cn='));
                }
            }*/
            //Converted the member to upper case to ignore the case sensitivity for the user story 124599
            
            //We can check with Karthik Golakaram.
            String memberUpper = member.toUpperCase(); 
            String[] memberList = memberUpper.Split(',');
            
           
            for(String st:memberList){
                if((st.contains('CN=CSS_') ||st.Contains('APP_CSS'))){
                    cssMatchingAttriValues.add(st.substringAfter('CN='));
                }
            }
            //We can check with Karthik Golakaram.
        }
        
        //START - 167730 - Krishnamoorthi - Allowing only OAM Service provider.
        //if(guidanzSP != null && guidanzSP != '' && guidanzSP == 'OAM') {
            //Checking applications string which we got from parser to check access.        
            if (cssMatchingAttriValues.isEmpty()) {     
                cssMatchingAttriValues.clear();     
                System.debug('string Memebers List1'+cssMatchingAttriValues);       
                String memberUpper = applications.toUpperCase();        
                String[] memberList = memberUpper.Split(',');       
                for(String st:memberList){      
                    if((st.contains('CN=CSS_') || st.contains('APP_CSS'))){     
                        system.debug('Values in list'+st);              
                        cssMatchingAttriValues.add(st.substringAfter('CN=').trim());        
                    }       
                }       
                        
            }
        //}
        //END - 167730 - Krishnamoorthi - Allowing only OAM Service provider.     
                    
            //end check from applications string
        
        system.debug('**CSS JIT Application Access Check Method - CSS Attribute Check = ' + cssMatchingAttriValues);
        if(attributes.containsKey('PRODUCTGROUPACCESS')){
            user.Product_Group_Access__c = attributes.get('PRODUCTGROUPACCESS');
        } else { /*** BEGIN Fix for Defect ID 62795 ***/
            user.Product_Group_Access__c = 'PGA01';
        }
        if (user.Product_Group_Access__c == null || user.Product_Group_Access__c == '') {
            user.Product_Group_Access__c = 'PGA01';
        }
        /*** END Fix for Defect ID 62795 ***/
        
        /* adding  all the CSS_ profiles into cssMatching Accounts List
         * This ensures ,if SAML Contains any CSS_ related profiles User has APP_CSS Access 
         */
        if(!cssMatchingAttriValues.isEmpty()) {
            System.debug('Matching cn attributes are found');
            cssAppUsr = getInfoValidation(create,user,communityId,portalId,federationIdentifier,attributes);
            appAccess=true;
        } else {
            System.debug('Matching cn attributes are not found');
            System.debug('User doesnot have CSS_APP Access');
            cssAppUsr = false;
            appAccess=false; 
        }
        system.debug('**CSS JIT Application Access Check Method - END**');
        return cssAppUsr;
    }
    public boolean getInfoValidation(boolean create, User user ,Id communityId,ID portalId,String federationIdentifier, Map<String, String> attributes)
    {
        system.debug('**CSS JIT Get Info Validation Method - BEGIN***');
        system.debug('**CSS JIT Get Info Validation Method - Invoked from create value = ' + create);
        if(create){
            cssAppUsrAccountValidation = accountContactVerification(true,user,communityId,portalId,federationIdentifier,attributes,cssMatchingAttriValues);
        } else {
            cssAppUsrAccountValidation = accountContactVerification(false,user,communityId,portalId,federationIdentifier,attributes,cssMatchingAttriValues);
        }
        system.debug('**CSS JIT Get Info Validation Method - AccountContactVerification = ' + cssAppUsrAccountValidation);
        system.debug('**CSS JIT Get Info Validation Method - END***');
        return cssAppUsrAccountValidation;
    }

    public boolean accountContactVerification(boolean create,User user,Id communityId,Id portalId,
                                              String federationIdentifier,Map<String, String> attributes,Set<String> profiles)
    {
        system.debug('**CSS JIT Account Contact Verification Method - BEGIN***');

        for (CSS_accountLanguage__c lang: CSS_accountLanguage__c.getAll().values()){
            System.debug('lang'+lang);
            accountLanguageMap.put(lang.CSS_userLanguage__c,lang.name);
        }
        system.debug('**CSS JIT Account Contact Verification Method - Language Map = ' + accountLanguageMap);
        for (CSS_accountLocale__c lang: CSS_accountLocale__c.getAll().values()){
            accountLocaleMap.put(lang.CSS_userLocale__c,lang.name);
        }
        system.debug('**CSS JIT Account Contact Verification Method - Locale Map = ' + accountLocaleMap);
        for (CSS_accountTimeZone__c lang: CSS_accountTimeZone__c.getAll().values()){
            accountTimeZoneMap.put(lang.CSS_userTimeZone__c,lang.name);
        }
        system.debug('**CSS JIT Account Contact Verification Method - Timezone Map = ' + accountTimeZoneMap);
        for (CSS_emailEncoding__c lang: CSS_emailEncoding__c.getAll().values()){
            accountEmailEncodingMap.put(lang.CSS_userEmailEncoding__c,lang.name);
        }
        system.debug('**CSS JIT Account Contact Verification Method - Email Encoding = ' + accountEmailEncodingMap);
        Workgroupid = attributes.get('WORKGROUP');
        Workgroupid = Workgroupid.replace('|', ';');
        user.CSS_User_MultiLocValues__c = Workgroupid;
        system.debug('Workgroupid>>>>>>>'+Workgroupid);
        list<String> wrkgrpIds = Workgroupid.split(';');
        // As part of this CRQ 130369 Rajesh Narra have added this following code from line number 265 to 283
        String factoryWorkGroupid;          //CRQ 130369
        List<String> splitFirstWorkGroupId = new List<String>(); //CRQ 130369
        String factoryWorkGroupFirstFiveDigits; //CRQ 130369
        String factoryWorkGroupSecondFiveDigits; //CRQ 130369
        //CRQ 130369
        if(wrkgrpIds!=null && wrkgrpIds.size()>0){ 
            factoryWorkgroupid = wrkgrpIds[0]; 
            if(factoryWorkgroupid!=null && String.isNotEmpty(factoryWorkgroupid)){
                splitFirstWorkGroupId = factoryWorkgroupid.split('-');
                if(splitFirstWorkGroupId!=null && splitFirstWorkGroupId.size()>0){
                    factoryWorkGroupFirstFiveDigits = splitFirstWorkGroupId[0];
                    factoryWorkGroupSecondFiveDigits = splitFirstWorkGroupId[1];
                    System.debug('** first'+factoryWorkGroupFirstFiveDigits);
                    System.debug('** second'+factoryWorkGroupSecondFiveDigits);
                }
            }
            
        }

        system.debug('**CSS JIT Account Contact Verification Method - WorkGroup ID from LDAP = ' + wrkgrpIds.size() + ' ' +wrkgrpIds);
         // Verifing the length 19 for the fleet users for the CIHR story 124599
        if(Workgroupid != null && String.isNotEmpty(Workgroupid))
        {
            for(string st:wrkgrpIds)
            {
                if(st.length()!=null && st.length()>0 && st.length()==Integer.ValueOf(System.label.CIHR_Fleet_Code_Length)){
                    if(st.subString(0,19).contains('-P')){
                        user.User_Location__c = st.subString(7,19).replace('-P','');
                        primaryWorkgroupId = st.subString(7,19).replace('-P','');
                    }
                }else{
                    if(st.subString(0,13).contains('-P'))
                    {
                        user.User_Location__c =  st.subString(0,13).replace('-P','');
                        primaryWorkgroupId = st.subString(0,13).replace('-P','');
                    }
                }
            }
        }
        
        boolean cumminsEmployeeVerificationFlag;
        if(attributes.containsKey('MAIL') && (String.isNotBlank(attributes.get('MAIL')) && attributes.get('MAIL')!=null) ){
            cumminsEmployeeEmailAddress = attributes.get('MAIL');   
            if(cumminsEmployeeEmailAddress!=null && cumminsEmployeeEmailAddress!=''){
                cumminsEmployeeVerificationFlag = cumminsEmployeeEmailAddress.contains('@cummins.com');
            }
        }
        System.debug('** cummmins Email id'+cumminsEmployeeEmailAddress);
        System.debug('** cumminsEmployeeEmailAddress'+cumminsEmployeeVerificationFlag);
        System.debug('** Workgroup id'+Workgroupid);
        // Anirudh- This method is used to store multiple location in MTM object 
       
        if(create) {
            system.debug('**CSS JIT Account Contact Verification Method - For Create User BEGIN ***');
            user.UserGroup__c='EDS_USER';
           
            if(attributes.containsKey('SURNAME')){
                user.LastName = attributes.get('SURNAME');
            }
            
            String name = attributes.get('FULLNAME');
            String sName = attributes.get('SURNAME');
            String parsename = name.replace(sName,'').replace(',','');
            system.debug('**CSS JIT Account Contact Verification Method - For Create User First Name = ' + parsename);
            user.firstName = parsename;
            String oneCharFrmFN =parsename.substring(0,1);
            String fiveCharsFrmSN ;
            /**BEGIN fix for Defect Id 62792 **/
            if(sName.length()>4){ fiveCharsFrmSN =sName.substring(0,4);}
            else{fiveCharsFrmSN = sName;}
            /**END fix for Defect Id 62792 **/
            String Fedid = attributes.get('UID')+'@cummins.com';
            
            /**BEGIN fix for Defect Id 62793 **/
            String sNickNm;
            String Mail_Test1 = attributes.get('MAIL');
            System.debug('** mail'+Mail_Test1);
            if(( attributes.containsKey('MAIL')) && ( attributes.get('MAIL') != null 
                                                && String.isnotblank(attributes.get('MAIL')))) {
                user.Email = attributes.get('MAIL');
                /**BEGIN fix for Defect Id 68558 **/
                //user.Username = attributes.get('MAIL')+System.label.css_org;
                user.Username = parsename.replace(' ','')+'.'+sName.replace(' ','')+'.'+attributes.get('UID')+'@cummins.com'+System.label.css_org;
                //sNickNm = attributes.get('MAIL').substring(0,attributes.get('MAIL').indexOf('@')) +'.'+ attributes.get('UID')+'.'+System.label.css_org;
                sNickNm = parsename.replace(' ','')+'.'+sName.replace(' ','');
                sNickNm = sNickNm.left(24) +'.<'+attributes.get('UID')+'>'+System.label.css_org;
                /**END fix for Defect Id 68558 **/
            }
            else {
                user.Email = attributes.get('UID')+'@cummins.com';
                /**BEGIN fix for Defect Id 68558 **/
                //user.Username = attributes.get('UID')+'@cummins.com'+System.label.css_org;
                user.Username = parsename.replace(' ','')+'.'+sName.replace(' ','')+'.'+attributes.get('UID')+'@cummins.com'+System.label.css_org;
                //sNickNm = parseName+sName+'.'+ attributes.get('UID')+'.'+System.label.css_org;
                sNickNm = parsename.replace(' ','')+'.'+sName.replace(' ','');
                sNickNm = sNickNm.left(24) +'.<'+attributes.get('UID')+'>'+System.label.css_org;                
                /**END fix for Defect Id 68558 **/
            }
            user.CommunityNickname = sNickNm.left(39);
            /**END fix for Defect Id 62793 **/
            if(attributes.containsKey('CUMMINSMANAGER')){
                String cumminsManager = attributes.get('CUMMINSMANAGER');
                List<User> usrMgr = [Select Id,Name,FederationIdentifier from User where FederationIdentifier = :cumminsManager limit 1];
                if(usrMgr.size()>0){
                    user.ManagerId = usrMgr[0].Id;
                }
            }
            if(attributes.containsKey('CONTACT')){
                user.Phone = attributes.get('CONTACT');
            }
            user.Alias = oneCharFrmFN+fiveCharsFrmSN;
            system.debug('**CSS JIT Account Contact Verification Method - For Create User END ***');
        }
        
         
        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User BEGIN***');
        //Looking for the profiles from Salesforce
        List<profile> cssprofiles = [select id,name from profile where name like 'CSS_%'];
        Map<string,id> cssprofmap = new Map<string,id>();
        for(profile pf:cssprofiles){
            cssprofmap.put(pf.name,pf.id);
        }
        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User Profile Map=' + cssprofmap);
        if(( attributes.containsKey('DEALERCODE') && (attributes.containsKey('DISTRIBUTORCODE') || attributes.containsKey('DISTRIBUTORBRANCHCODE') ) &&
           ( attributes.get('DEALERCODE') != null && ( attributes.get('DISTRIBUTORCODE') != null || attributes.containsKey('DISTRIBUTORBRANCHCODE') != null )) &&
           ( String.isnotblank(attributes.get('DEALERCODE')) && (String.isnotblank(attributes.get('DISTRIBUTORCODE')) || String.isnotblank(attributes.get('DISTRIBUTORBRANCHCODE'))))))
        {   
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DLR BEGIN***');
            dealerCode = attributes.get('DEALERCODE');
            distributorCode = attributes.get('DISTRIBUTORCODE');
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DEALERCODE = ' + dealerCode);
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTICODE = ' + distributorCode);
            List<Account> acctn = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                CSS_DistributorCode__c,BillingCity,ShippingCity FROM Account 
                                WHERE (Location__c =: primaryWorkgroupId) AND isPartner = FALSE
                                limit 1];
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DEALER RECFOUND CSS = ' + acctn);
            //Account Search Query Criteria is updated by Rajesh Narra  (CSS_DistributorCode__c =: distributorCode and IAM_Service_Provider_Code__c =: dealerCode)
            
            if(acctn.Size()>0) {
                if(create) {
                    user.LocaleSidkey = accountLocaleMap.get(acctn[0].CSS_Locale__c);
                    user.LanguageLocaleKey = accountLanguageMap.get(acctn[0].CSS_Language__c) ; 
                    user.EmailEncodingkey = accountEmailEncodingMap.get(acctn[0].CSS_EmailEncoding__c);
                    user.TimeZoneSidKey= accountTimeZoneMap.get(acctn[0].CSS_Timezone__c);
                    user.DEPARTMENT = dealerCode;
                    user.Division = distributorCode;
                    /**BEGIN fix for Defect Id 68558 **/
                    user.CompanyName = acctn[0].Name;
                    /**END fix for Defect Id 68558 **/
                    /**BEGIN fix for Defect Id 62798 **/
                    user.Work_Group_Name__c = acctn[0].EDS_Workgroup_Name__c;
                    /**END fix for Defect Id 62798 **/
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Point-1***');
                }else{
                    user.DEPARTMENT = dealerCode; //Added to update the user info
                    user.Division = distributorCode;// Added to update the user info
                    user.CompanyName = acctn[0].Name;// Added to update the user info
                    user.Work_Group_Name__c = acctn[0].EDS_Workgroup_Name__c;//Added to update user info
                }
                String acctnid = acctn[0].id;
                handleContact(acctnid,user,create,attributes);
                if(!create){
                    System.debug('** Entering into the dealer group');
                    dealerContentAccess(String.valueOf(federationIdentifier));
                }
                /** BEGIN - Fix for Defect ID Portal Role **/
                // Story 85634 - Ignore Profile and Role Changes for users with manual check flag
                if(!(user.Modify_Role_Manually__c)){
                    //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced'))
                    if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED'))
                    {
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' + cssprofmap.get(System.label.dealer_advanced));
                        user.profileId = cssprofmap.get(System.label.dealer_advanced);
                        if(create) {
                            user.PortalRole = 'Executive';
                        }
                    } else {
                        //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                        if(profiles.contains('CSS_DN_TECH'))
                        {
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' +cssprofmap.get(System.label.dealer_technician));
                            user.ProfileId = cssprofmap.get(System.label.dealer_technician);
                            if(create) {
                                user.PortalRole = 'Worker';
                            }
                        }
                    }
                }
                /** END - Fix for Defect ID Portal Role **/
                accountVerified = true;
            } else {
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER #No matching Account Found#');
                accountVerified = false;
            }
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DLR END***');
        }
        ////Added the FLEETCODE if to support the CIHR users for the user story 124599
        //&& attributes.containsKey('DISTRIBUTORBRANCHCODE'), //attributes.get('DISTRIBUTORBRANCHCODE') != null && && //String.isnotblank(attributes.get('DISTRIBUTORBRANCHCODE')) removed by Rajesh Narra.
        
        else if (( attributes.containsKey('DISTRIBUTORCODE') && attributes.containsKey('FLEETCODE')) && (attributes.get('DISTRIBUTORCODE') != null && attributes.get('FLEETCODE')!=null) && (String.isnotblank(attributes.get('DISTRIBUTORCODE')) && String.isnotblank(attributes.get('FLEETCODE')))) 
        {
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DLR BEGIN***');
            //dealerCode = attributes.get('DEALERCODE');
            distributorCode = attributes.get('DISTRIBUTORCODE');
            fleetCode = attributes.get('FLEETCODE');
            //distribranchCode = attributes.get('DISTRIBUTORBRANCHCODE');
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User FLEETCODE = ' + fleetCode);
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTICODE = ' + distributorCode);
            //system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTBRANCHCODE = ' + distribranchCode);
            List<Account> acctn = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                CSS_DistributorCode__c,BillingCity,ShippingCity FROM Account
                                WHERE (Location__c =: primaryWorkgroupId) AND isPartner = FALSE
                                limit 1];
            //Account Search Query Criteria is updated by Rajesh Narra CSS_DistributorCode__c =: distributorCode and IAM_Service_Provider_Code__c =: distribranchCode and IAM_Service_Provider_Code__c=: fleetCode)

            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DEALER RECFOUND CSS = ' + acctn);
            system.debug('** dis code '+distributorCode +'** fleet code '+fleetCode + 'work group id'+primaryWorkgroupId);
            if(acctn.Size()>0) {
                if(create) {
                    user.LocaleSidkey = accountLocaleMap.get(acctn[0].CSS_Locale__c);
                    user.LanguageLocaleKey = accountLanguageMap.get(acctn[0].CSS_Language__c) ; 
                    user.EmailEncodingkey = accountEmailEncodingMap.get(acctn[0].CSS_EmailEncoding__c);
                    user.TimeZoneSidKey= accountTimeZoneMap.get(acctn[0].CSS_Timezone__c);
                    user.DEPARTMENT = fleetCode;
                    user.Division = distributorCode;
                    /**BEGIN fix for Defect Id 68558 **/
                    user.CompanyName = acctn[0].Name;
                    /**END fix for Defect Id 68558 **/
                    /**BEGIN fix for Defect Id 62798 **/
                    user.Work_Group_Name__c = acctn[0].EDS_Workgroup_Name__c;
                    /**END fix for Defect Id 62798 **/
                    user.Fleet_Code__c = acctn[0].IAM_Service_Provider_Code__c;
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Point-1***');
                }else{
                    user.DEPARTMENT = fleetCode;
                    user.Division = distributorCode;
                    user.CompanyName = acctn[0].Name;
                    user.Work_Group_Name__c = acctn[0].EDS_Workgroup_Name__c;
                    user.Fleet_Code__c = acctn[0].IAM_Service_Provider_Code__c;
                }
                String acctnid = acctn[0].id;
                System.debug('** user'+user);
                System.debug('*** conid'+user.ContactId);
                handleContact(acctnid,user,create,attributes);
                if(!create){
                    System.debug('** Entering into the dealer fleet group');
                    dealerContentAccess(String.valueOf(federationIdentifier));
                }
                /** BEGIN - Fix for Defect ID Portal Role **/
                // Story 85634 - Ignore Profile and Role Changes for users with manual check flag
                System.debug('** Fleet Modify Role Manually'+user.Modify_Role_Manually__c);
                System.debug('profile Name Raj'+profiles);
                    if(!(user.Modify_Role_Manually__c)){
                         //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced'))
                         //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                          if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED'))
                        {
                           system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' + cssprofmap.get(System.label.dealer_advanced));
                            user.profileId = cssprofmap.get(System.label.dealer_advanced);
                            if(create) {
                                user.PortalRole = 'Executive';
                            }
                        } else {
                            //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                            //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                             if(profiles.contains('CSS_DN_TECH'))
                            {
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' +cssprofmap.get(System.label.dealer_technician));
                                user.ProfileId = cssprofmap.get(System.label.dealer_technician);
                                if(create) {
                                    user.PortalRole = 'Worker';
                                }
                            }
                        }
                        
                    } //For loop closed for handling contains ignore case RTC Defect 124599
                    

                /** END - Fix for Defect ID Portal Role **/
                accountVerified = true;
            } else {
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER #No matching Account Found#');
                accountVerified = false;
            }
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DLR END***');
        }
        //START - 167730 - Krishnamoorthi
        else if(
        attributes.containsKey('DISTRIBUTORBRANCHCODE') 
        && String.isNotBlank(attributes.get('DISTRIBUTORBRANCHCODE')) 
        && attributes.get('DISTRIBUTORBRANCHCODE')!=null 
        && attributes.containsKey('DISTRIBUTORCODE') 
        && String.isNotBlank(attributes.get('DISTRIBUTORCODE')) 
        && attributes.get('DISTRIBUTORCODE')!=null
        ) { 
            //Checking DISTRIBUTORBRANCHCODE and DISTRIBUTORCODE has value
            /*
            if(attributes.get('DISTRIBUTORBRANCHCODE') != attributes.get('DISTRIBUTORCODE')) {  //Distributor NOT EQUAL TO distributorbranchcode.
                /*********************************** Distributor Code ******************************************************
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI BEGIN***');
                distributorCode = attributes.get('DISTRIBUTORCODE');
                distribranchCode = attributes.get('DISTRIBUTORBRANCHCODE');
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTIBRCODE = ' + distribranchCode);
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTICODE = ' + distributorCode);
                List<Account> acctnDb = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                                CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                                IAM_Service_Provider_Code__c,CSS_DistributorCode__c,BillingCity
                                        FROM    Account
                                        WHERE   (CSS_DistributorCode__c =: distributorCode and IAM_Service_Provider_Code__c =: distribranchCode and (IAM_Service_Provider_Code__c= null OR IAM_Service_Provider_Code__c ='')) limit 1];
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI RECFOUND CSS = ' + acctnDb);
    
                if(acctnDb.size()>0){
                    if(create) {
                        user.DEPARTMENT = distribranchCode;
                        user.Division = distributorCode;
                        user.LocaleSidkey = accountLocaleMap.get(acctnDb[0].CSS_Locale__c);
                        user.LanguageLocaleKey = accountLanguageMap.get(acctnDb[0].CSS_Language__c) ;
                        user.EmailEncodingkey = accountEmailEncodingMap.get(acctnDb[0].CSS_EmailEncoding__c);
                        user.TimeZoneSidKey= accountTimeZoneMap.get(acctnDb[0].CSS_Timezone__c);
                        user.Work_Group_Name__c = acctnDb[0].EDS_Workgroup_Name__c;
                        user.CompanyName = acctnDb[0].Name;
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DISTI Point-1***');
                    }
                    // Story 77088 - Ignore Profile and Role Changes for users with manual check flag
                    if(!(user.Modify_Role_Manually__c)){
                        //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) 
                        if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED') )
                        {
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV= ' + cssprofmap.get(System.label.service_advanced));
                            user.profileId = cssprofmap.get(System.label.service_advanced);
                        }else if((profiles.contains('CSS_DN_ADVANCED')) && (profiles.contains('CSS_DN_TECH')))
                        //((profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) && (profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech')))
                        {
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV & TECH= ' + cssprofmap.get(System.label.service_advanced));
                            user.profileId = cssprofmap.get(System.label.service_advanced);
                        }
                        else 
                        {
                            //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                            if(profiles.contains('CSS_DN_TECH'))
                            {
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile TECH= ' + cssprofmap.get(System.label.service_technician));
                                user.ProfileId = cssprofmap.get(System.label.service_technician);
                            }
                        }
                    } // End Condition for Story 77088
                    String userRole;
                    if(acctnDb[0].Name != null) {
                        userRole = acctnDb[0].Name.toUpperCase();
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Role from Account = ' + userRole);
                    }
                    if(userRole != null && !(user.Modify_Role_Manually__c)){ // Story 85634 - Ignore Profile and Role Changes for users with manual check flag
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI NO DFSE ');
                        //if(profiles.contains('CSS_DN_Advanced') || profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('css_dn_advanced'))
                        if(profiles.contains('CSS_DN_ADVANCED') || profiles.contains('CSS_DN_ADMIN')){
                            userRole = '%Advanced%'+userRole+'%';
                        }else {
                            userRole = '%Technician%'+userRole+'%';
                        }
                        System.debug('userRoleFinal'+userRole);
                        List<UserRole> rol = [SELECT Id,name FROM UserRole WHERE Name like:userRole limit 1];
                        if(rol.size()!=0){
                            user.UserRoleId = rol[0].Id;
                        }
                        
                    }
                    else { system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI IS A DFSE ');}
                    //String acctnid = acctnDb[0].id;
                    //handleContact(acctnid, user,create,attributes);
                    if(!create){
                        update(user);
                        distributorContentAccess(String.valueOf(federationIdentifier));
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Update User DISTI Complete***');
                    }
                    accountverified = true;
                } else {
                    accountVerified = false;
                }
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI END***');
                /*********************************** Distributor code ******************************************************
                distributorContentAccess(String.valueOf(federationIdentifier));*/
            //} else {      //Distributor EQUAL TO distributorbranchcode.
                //HQ User
                //identifyHQUser(federationIdentifier, attributes);
                Boolean distributorUser = false;
                Boolean dealerUser = false;
                Boolean EmpEmailFlag = false;
                if(attributes.containsKey('MAIL') && (String.isNotBlank(attributes.get('MAIL')) && attributes.get('MAIL')!=null)){
                    cumminsEmployeeEmailAddress = attributes.get('MAIL'); 
                    cumminsEmployeeEmailAddress = cumminsEmployeeEmailAddress.toUpperCase();  
                    if(cumminsEmployeeEmailAddress!=null && cumminsEmployeeEmailAddress!=''){
                        string Emaildomain = Label.CSS_Email_Domain;
                        if(Emaildomain != null && Emaildomain != '') {
                            string[] emaildomains = Emaildomain.split(',');
                            for(string domains:  emaildomains) {
                                if(domains != null && domains != '') {
                                    cumminsEmployeeVerificationFlag = cumminsEmployeeEmailAddress.contains(domains.trim());
                                    if(cumminsEmployeeVerificationFlag)
                                        break;
                                }
                            }
                        }
                    }
                    if(cumminsEmployeeVerificationFlag) 
                        distributorUser = true;
                    else
                        dealerUser = true;
                } else {    //No Email.
                    if(attributes.containsKey('UID') && (String.isNotBlank(attributes.get('UID')) && attributes.get('UID')!=null)) {    
                        //HANDLE IF UID IS EMPTY THEN TAKE/CHECK WITH  "federationIdentifier" ---> CONFIRMATION NEEDED.
                        string fId = attributes.get('UID'); 
                        if(fId != null && fId.length() == 5) {
                            string fidText = fId.subString(0,2);
                            string FidNum = fId.subString(2,5);
                            if(!fidText.isNumeric() && FidNum.isNumeric()) {
                                //distributorContentAccess(String.valueOf(federationIdentifier));
                                distributorUser = true;
                            } else {
                                //JIT ERROR.
                                system.debug('** WWWID is Invalid **');
                                accountVerified = false;
                            }
                        } else {
                            //JIT ERROR.
                            system.debug('** WWWID is Invalid **');
                            accountVerified = false;
                        }
                    } else {
                        //JIT ERROR.
                        system.debug('** WWWID is Invalid **');
                        accountVerified = false;        
                    }
                }
                
                //Logic for deaelr and distributor.
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI BEGIN***');
                distributorCode = attributes.get('DISTRIBUTORCODE');
                distribranchCode = attributes.get('DISTRIBUTORBRANCHCODE');
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTIBRCODE = ' + distribranchCode);
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTICODE = ' + distributorCode);
                List<Account> acctnDb = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                                CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                                CSS_DistributorCode__c,BillingCity
                                        FROM    Account
                                        WHERE   (Location__c =: primaryWorkgroupId) AND isPartner = FALSE limit 1];
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI RECFOUND CSS = ' + acctnDb);
                //Account Search Query Criteria is updated by Rajesh Narra  (CSS_DistributorCode__c =: distributorCode and IAM_Service_Provider_Code__c =: distribranchCode)
                
                if(acctnDb.size()>0 && (dealerUser ||distributorUser)){
                    if(create) {
                        user.DEPARTMENT = distributorCode;  //distribranchCode;     Updated.
                        user.Division = distributorCode;
                        user.LocaleSidkey = accountLocaleMap.get(acctnDb[0].CSS_Locale__c);
                        user.LanguageLocaleKey = accountLanguageMap.get(acctnDb[0].CSS_Language__c) ;
                        user.EmailEncodingkey = accountEmailEncodingMap.get(acctnDb[0].CSS_EmailEncoding__c);
                        user.TimeZoneSidKey= accountTimeZoneMap.get(acctnDb[0].CSS_Timezone__c);
                        /**BEGIN fix for Defect Id 62798 **/
                        user.Work_Group_Name__c = acctnDb[0].EDS_Workgroup_Name__c;
                        /**END fix for Defect Id 62798 **/
                        /**BEGIN fix for Defect Id 68558 **/
                        user.CompanyName = acctnDb[0].Name;
                        /**END fix for Defect Id 68558 **/
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DISTI Point-1***');
                        //PermissionSetAssignment DealerPerSetAssignment = new PermissionSetAssignment(PermissionSetId ='0PS3B0000009Ewv',AssigneeId =user.id);
                        //upsert DealerPerSetAssignment;
                    }else{
                        user.DEPARTMENT = distributorCode;
                        user.Division = distributorCode;
                        user.Work_Group_Name__c = acctnDb[0].EDS_Workgroup_Name__c;
                        user.CompanyName = acctnDb[0].Name;
                    }
                    // Story 77088 - Ignore Profile and Role Changes for users with manual check flag
                    if(distributorUser) {
                        if(!(user.Modify_Role_Manually__c)){
                            //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) 
                            if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED') )
                            {
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV= ' + cssprofmap.get(System.label.service_advanced));
                                user.profileId = cssprofmap.get(System.label.service_advanced);
                            }else if((profiles.contains('CSS_DN_ADVANCED')) && (profiles.contains('CSS_DN_TECH')))
                            //((profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) && (profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech')))
                            {
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV & TECH= ' + cssprofmap.get(System.label.service_advanced));
                                user.profileId = cssprofmap.get(System.label.service_advanced);
                            }
                            else 
                            {
                                //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                                if(profiles.contains('CSS_DN_TECH'))
                                {
                                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile TECH= ' + cssprofmap.get(System.label.service_technician));
                                    user.ProfileId = cssprofmap.get(System.label.service_technician);
                                }
                            }
                        } // End Condition for Story 77088
                        String userRole;
                        if(acctnDb[0].Name != null) {
                            userRole = acctnDb[0].Name.toUpperCase();
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Role from Account = ' + userRole);
                        }
                        /** BEGIN - Fix for Defect ID 62791 **/
                        if(userRole != null && !(user.Modify_Role_Manually__c)){ // Story 85634 - Ignore Profile and Role Changes for users with manual check flag
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI NO DFSE ');
                            //if(profiles.contains('CSS_DN_Advanced') || profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('css_dn_advanced'))
                            if(profiles.contains('CSS_DN_ADVANCED') || profiles.contains('CSS_DN_ADMIN')){
                                userRole = '%Advanced%'+userRole+'%';
                            }else {
                                userRole = '%Technician%'+userRole+'%';
                            }
                            System.debug('userRoleFinal'+userRole);
                            List<UserRole> rol = [SELECT Id,name FROM UserRole WHERE Name like:userRole limit 1];
                            if(rol.size()!=0){
                                user.UserRoleId = rol[0].Id;
                            }
                            
                        }
                        else { system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI IS A DFSE ');}
                        /** END - Fix for Defect ID 62791 **/
                        //String acctnid = acctnDb[0].id;
                        //handleContact(acctnid, user,create,attributes);
                        if(!create){
                            update(user);
                            distributorContentAccess(String.valueOf(federationIdentifier));
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Update User DISTI Complete***');
                        }
                    }
                    
                    if(dealerUser) {
                        String acctnid = acctnDb[0].id;
                        handleContact(acctnid, user,create,attributes);
                        if(!(user.Modify_Role_Manually__c)){
                             //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced'))
                             //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                              if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED'))
                            {
                               system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' + cssprofmap.get(System.label.dealer_advanced));
                                user.profileId = cssprofmap.get(System.label.dealer_advanced);
                                if(create) {
                                    user.PortalRole = 'Executive';
                                }
                            } else {
                                //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                                //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                                 if(profiles.contains('CSS_DN_TECH'))
                                {
                                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' +cssprofmap.get(System.label.dealer_technician));
                                    user.ProfileId = cssprofmap.get(System.label.dealer_technician);
                                    if(create) {
                                        user.PortalRole = 'Worker';
                                    }
                                }
                            }
                            
                        } //For loop closed for handling contains ignore case RTC Defect 124599
                        dealerContentAccess(String.valueOf(federationIdentifier));
                    }
                    accountverified = true;
                } else {
                    accountVerified = false;
                }
                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI END***');
            //}
        } else if(
        attributes.containsKey('DISTRIBUTORBRANCHCODE') 
        && (String.isBlank(attributes.get('DISTRIBUTORBRANCHCODE')) 
        || attributes.get('DISTRIBUTORBRANCHCODE') ==null)
        && attributes.containsKey('DISTRIBUTORCODE') 
        && String.isNotBlank(attributes.get('DISTRIBUTORCODE')) 
        && attributes.get('DISTRIBUTORCODE')!=null
        ) { //Checking DISTRIBUTORBRANCHCODE has no value
            Workgroupid = attributes.get('WORKGROUP');
            Workgroupid = Workgroupid.replace('|', ';');
            system.debug('Workgroupid>>>>>>>'+Workgroupid);
            list<String> wrkgrpIds1 = Workgroupid.split(';');
            String WorkGroupid;          //CRQ 130369
            List<String> splitFirstWorkGroupId1 = new List<String>(); //CRQ 130369
            String WorkGroupFirstFiveDigits; //CRQ 130369
            String WorkGroupSecondFiveDigits; //CRQ 130369
            if(wrkgrpIds1 !=null && wrkgrpIds1.size()>0){ 
                WorkGroupid = wrkgrpIds1[0]; 
                if(WorkGroupid!=null && String.isNotEmpty(WorkGroupid)){
                    splitFirstWorkGroupId1 = WorkGroupid.split('-');
                    if(splitFirstWorkGroupId1!=null && splitFirstWorkGroupId1.size()>0){
                        WorkGroupFirstFiveDigits = splitFirstWorkGroupId1[0];
                        WorkGroupSecondFiveDigits = splitFirstWorkGroupId1[1];
                        System.debug('** first'+WorkGroupFirstFiveDigits);
                        System.debug('** second'+WorkGroupSecondFiveDigits);
                    }
                    WorkGroupid = WorkGroupFirstFiveDigits + '-'+ WorkGroupSecondFiveDigits;    //New code on nov 13
                }

            }
            if(Workgroupid != null && Workgroupid != '' && WorkGroupid != null && WorkGroupid != '') {
                if(WorkGroupFirstFiveDigits == WorkGroupSecondFiveDigits) {
                    //HQ USER.
                    //identifyHQUser(federationIdentifier, attributes);
                            //Distributor EQUAL TO distributorbranchcode.
                    //HQ User
                    //identifyHQUser(federationIdentifier, attributes);
                    Boolean distributorUser = false;
                    Boolean dealerUser = false;
                    Boolean EmpEmailFlag = false;
                    if(attributes.containsKey('MAIL') && (String.isNotBlank(attributes.get('MAIL')) && attributes.get('MAIL')!=null)){
                        cumminsEmployeeEmailAddress = attributes.get('MAIL');  
                        cumminsEmployeeEmailAddress = cumminsEmployeeEmailAddress.toUpperCase();                
                        System.debug('** cumminsEmployeeEmailAddress'+cumminsEmployeeEmailAddress);
                        if(cumminsEmployeeEmailAddress!=null && cumminsEmployeeEmailAddress!=''){
                            string Emaildomain = Label.CSS_Email_Domain;
                            System.debug('** Emaildomain'+Emaildomain);
                            if(Emaildomain != null && Emaildomain != '') {
                                string[] emaildomains = Emaildomain.split(',');
                                System.debug('** emaildomains'+emaildomains);
                                for(string domains:  emaildomains) {
                                    if(domains != null && domains != '') {
                                        cumminsEmployeeVerificationFlag = cumminsEmployeeEmailAddress.contains(domains.trim());
                                        System.debug('** cumminsEmployeeVerificationFlag'+cumminsEmployeeVerificationFlag);
                                        if(cumminsEmployeeVerificationFlag)
                                            break;
                                    }
                                }
                            }
                        }
                        if(cumminsEmployeeVerificationFlag) 
                            distributorUser = true;
                        else
                            dealerUser = true;
                    } else {    //No Email.
                        if(attributes.containsKey('UID') && (String.isNotBlank(attributes.get('UID')) && attributes.get('UID')!=null)) {    
                            //HANDLE IF UID IS EMPTY THEN TAKE/CHECK WITH  "federationIdentifier" ---> CONFIRMATION NEEDED.
                            string fId = attributes.get('UID'); 
                            if(fId != null && fId.length() == 5) {
                                string fidText = fId.subString(0,2);
                                string FidNum = fId.subString(2,5);
                                if(!fidText.isNumeric() && FidNum.isNumeric()) {
                                    //distributorContentAccess(String.valueOf(federationIdentifier));
                                    distributorUser = true;
                                } else {
                                    //JIT ERROR.
                                    system.debug('** WWWID is Invalid **');
                                    accountVerified = false;
                                }
                            } else {
                                //JIT ERROR.
                                system.debug('** WWWID is Invalid **');
                                accountVerified = false;
                            }
                        } else {
                            //JIT ERROR.
                            system.debug('** WWWID is Invalid **');
                            accountVerified = false;        
                        }
                    }
                    
                    //Logic for deaelr and distributor.
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI BEGIN***');
                    distributorCode = attributes.get('DISTRIBUTORCODE');
                    distribranchCode = attributes.get('DISTRIBUTORBRANCHCODE');
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTIBRCODE = ' + distribranchCode);
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTICODE = ' + distributorCode);
                    List<Account> acctnDb = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                                    CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                                    CSS_DistributorCode__c,BillingCity
                                            FROM    Account
                                            WHERE   (Location__c =: WorkGroupid) AND isPartner = FALSE limit 1];
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI RECFOUND CSS = ' + acctnDb);
                    
                    if(acctnDb.size()>0 && (dealerUser ||distributorUser)){
                        if(create) {
                            user.DEPARTMENT = distributorCode;  //distribranchCode;     Updated.
                            user.Division = distributorCode;
                            user.LocaleSidkey = accountLocaleMap.get(acctnDb[0].CSS_Locale__c);
                            system.debug('accountLanguageMap----> ' + accountLanguageMap);
                            system.debug('accountLanguageMap.get(acctnDb[0].CSS_Language__c)--->>> ' + accountLanguageMap.get(acctnDb[0].CSS_Language__c));
                            user.LanguageLocaleKey = accountLanguageMap.get(acctnDb[0].CSS_Language__c);
                            system.debug('user.LanguageLocaleKey>>> ' + user.LanguageLocaleKey);
                            user.EmailEncodingkey = accountEmailEncodingMap.get(acctnDb[0].CSS_EmailEncoding__c);
                            user.TimeZoneSidKey= accountTimeZoneMap.get(acctnDb[0].CSS_Timezone__c);
                            /**BEGIN fix for Defect Id 62798 **/
                            user.Work_Group_Name__c = acctnDb[0].EDS_Workgroup_Name__c;
                            /**END fix for Defect Id 62798 **/
                            /**BEGIN fix for Defect Id 68558 **/
                            user.CompanyName = acctnDb[0].Name;
                            /**END fix for Defect Id 68558 **/
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DISTI Point-1***>>> '+user);
                            //PermissionSetAssignment DealerPerSetAssignment = new PermissionSetAssignment(PermissionSetId ='0PS3B0000009Ewv',AssigneeId =user.id);
                            //upsert DealerPerSetAssignment;
                        }else{
                            user.DEPARTMENT = distributorCode;
                            user.Division = distributorCode;
                            user.Work_Group_Name__c = acctnDb[0].EDS_Workgroup_Name__c;
                            user.CompanyName = acctnDb[0].Name;
                        }
                        // Story 77088 - Ignore Profile and Role Changes for users with manual check flag
                        if(distributorUser) {
                            if(!(user.Modify_Role_Manually__c)){
                                //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) 
                                if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED') )
                                {
                                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV= ' + cssprofmap.get(System.label.service_advanced));
                                    user.profileId = cssprofmap.get(System.label.service_advanced);
                                }else if((profiles.contains('CSS_DN_ADVANCED')) && (profiles.contains('CSS_DN_TECH')))
                                //((profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) && (profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech')))
                                {
                                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile ADV & TECH= ' + cssprofmap.get(System.label.service_advanced));
                                    user.profileId = cssprofmap.get(System.label.service_advanced);
                                }
                                else 
                                {
                                    //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                                    if(profiles.contains('CSS_DN_TECH'))
                                    {
                                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Profile TECH= ' + cssprofmap.get(System.label.service_technician));
                                        user.ProfileId = cssprofmap.get(System.label.service_technician);
                                    }
                                }
                            } // End Condition for Story 77088
                            String userRole;
                            if(acctnDb[0].Name != null) {
                                userRole = acctnDb[0].Name.toUpperCase();
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI Role from Account = ' + userRole);
                            }
                            /** BEGIN - Fix for Defect ID 62791 **/
                            if(userRole != null && !(user.Modify_Role_Manually__c)){ // Story 85634 - Ignore Profile and Role Changes for users with manual check flag
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI NO DFSE ');
                                //if(profiles.contains('CSS_DN_Advanced') || profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('css_dn_advanced'))
                                if(profiles.contains('CSS_DN_ADVANCED') || profiles.contains('CSS_DN_ADMIN')){
                                    userRole = '%Advanced%'+userRole+'%';
                                }else {
                                    userRole = '%Technician%'+userRole+'%';
                                }
                                System.debug('userRoleFinal'+userRole);
                                List<UserRole> rol = [SELECT Id,name FROM UserRole WHERE Name like:userRole limit 1];
                                if(rol.size()!=0){
                                    user.UserRoleId = rol[0].Id;
                                }
                                
                            }
                            else { system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI IS A DFSE ');}
                            /** END - Fix for Defect ID 62791 **/
                            //String acctnid = acctnDb[0].id;
                            //handleContact(acctnid, user,create,attributes);
                            if(!create){
                                update(user);
                                distributorContentAccess(String.valueOf(federationIdentifier));
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Update User DISTI Complete***');
                            }
                        }
                        
                        if(dealerUser) {
                            String acctnid = acctnDb[0].id;
                            handleContact(acctnid, user,create,attributes);
                            if(!(user.Modify_Role_Manually__c)){
                                 //if(profiles.contains('CSS_DN_Admin') || profiles.contains('css_dn_admin') || profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced'))
                                 //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                                  if(profiles.contains('CSS_DN_ADMIN') || profiles.contains('CSS_DN_ADVANCED'))
                                {
                                   system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' + cssprofmap.get(System.label.dealer_advanced));
                                    user.profileId = cssprofmap.get(System.label.dealer_advanced);
                                    if(create) {
                                        user.PortalRole = 'Executive';
                                    }
                                } else {
                                    //By Rajesh Narra Commented the above line added belowe line as part of RTC Defect fix :124599
                                    //if(profiles.contains('CSS_DN_Tech') || profiles.contains('css_dn_tech'))
                                     if(profiles.contains('CSS_DN_TECH'))
                                    {
                                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User DEALER Profile = ' +cssprofmap.get(System.label.dealer_technician));
                                        user.ProfileId = cssprofmap.get(System.label.dealer_technician);
                                        if(create) {
                                            user.PortalRole = 'Worker';
                                        }
                                    }
                                }
                                
                            } //For loop closed for handling contains ignore case RTC Defect 124599
                            dealerContentAccess(String.valueOf(federationIdentifier));
                        }
                        accountverified = true;
                    } else {
                        accountVerified = false;
                    }
                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User DISTI END***');               
                } else {
                    //JIT ERROR.
                    system.debug('** WWWID is Invalid **');
                    accountVerified = false;
                }
            } else {
                //JIT ERROR.
                system.debug('** WWWID is Invalid **');
                accountVerified = false;
            }
        }//END - 167730 - Krishnamoorthi
        //If User is Employee No associated Dealer or Distributor Account would Existing
        else {
            // Entered User is Employee.
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User EMPLOYEE BEGIN***');
            List<Account> empActn = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                CSS_DistributorCode__c,BillingCity FROM Account
                                WHERE(Location__c =: system.label.CSS_Factory_User_Location) AND isPartner = FALSE limit 1];
            //Rajesh Narra has commented the criteria to fetch the factory CSS_DistributorCode__c = null and IAM_Service_Provider_Code__c =null and IAM_Service_Provider_Code__c = null)  and Name = 'Factory')
                                      
            
            System.debug('Factory Acc'+empActn);
            System.debug('** cumminsEmployeeVerificationFlag'+cumminsEmployeeVerificationFlag);
            System.debug('** Workgroup id'+workgroupid);
            System.debug('** First workgroupid'+factoryWorkGroupFirstFiveDigits);
            System.debug('** Second workgroupid'+factoryWorkGroupSecondFiveDigits);
            /* As part of this CRQ 130369 Rajesh Narra have added the following String.isNotBlank(factoryWorkGroupFirstFiveDigits) == String.isNotBlank(factoryWorkGroupFirstFiveDigits) criteria to check weather the first five digits and last five digits of the workgroupid is equal or not.*/
            if(cumminsEmployeeVerificationFlag == true){ 
                
                if((workgroupid==null || workgroupid=='') || (String.isNotBlank(factoryWorkGroupFirstFiveDigits) == String.isNotBlank(factoryWorkGroupSecondFiveDigits))){
                     If(empActn.size()>0 || !empActn.isEmpty())
                     {
                        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User EMPLOYEE Account Found in CSS***');
                        String emailRajesh = attributes.get('MAIL');
                        system.debug('** mail  '+emailRajesh);
                        system.debug('** Creating Info'+create);
                            If(create){
                                //START - 167730 - Krishnamoorthi - No CREATE access for Factory Users
                                /*
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User EMPLOYEE BEGIN***');
                            
                                user.LocaleSidkey = accountLocaleMap.get(empActn[0].CSS_Locale__c);
                                user.LanguageLocaleKey = accountLanguageMap.get(empActn[0].CSS_Language__c) ;
                                user.EmailEncodingkey = accountEmailEncodingMap.get(empActn[0].CSS_EmailEncoding__c);
                                user.TimeZoneSidKey= accountTimeZoneMap.get(empActn[0].CSS_Timezone__c);
                                String customValue = 'blank';
                                user.CompanyName = 'Cummins';
                                
                                if(customValue==System.label.Read_only && !(user.Modify_Role_Manually__c)){ 
                                    System.debug('Entered into if:');                   
                                    //if(profiles.contains('CSS_DN_Advanced') || profiles.contains('css_dn_advanced')) {
                                    if(profiles.contains('CSS_DN_ADVANCED')) {
                                        //System.debug('profilemapped==='+cssprofmap.get('CSS_DN_Advanced'));
                                        System.debug('profilemapped==='+cssprofmap.get('CSS_DN_ADVANCED'));
                                        user.ProfileId = cssprofmap.get(System.label.service_advanced);
                                    } else {
                                         //System.debug('profilemapped==='+cssprofmap.get('CSS_DN_Tech'));
                                         System.debug('profilemapped==='+cssprofmap.get('CSS_DN_TECH'));
                                         System.debug('profile fetch from Custom label'+cssprofmap.get(System.label.service_technician));
                                         user.ProfileId = cssprofmap.get(System.label.service_technician);
                                    }
                                } else{
                                System.debug('Entered else loop');
                                    user.ProfileId = cssprofmap.get(System.label.read_only); //00e61000000sNkhAAE
                                }
                                List<UserRole> rol = [SELECT Id,name FROM UserRole WHERE Name like '%Factory' limit 1];
                                if(rol.size()> 0 && !(user.Modify_Role_Manually__c)){
                                    system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User EMPLOYEE NO DFSE***');
                                    user.UserRoleId = rol[0].Id;
                                    System.debug('******'+user.UserRoleId);
                                }
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create User EMPLOYEE END***');
                                */                              
                                //END - 167730 - Krishnamoorthi - No CREATE access for Factory Users
                            } 
                            else {
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Update User EMPLOYEE BEGIN***');
                                String name = attributes.get('FULLNAME');
                                String sName = attributes.get('SURNAME');
                                String sRName =sName+',';
                                String parsename = name.replace(sName,'').replace(',','');
                                System.debug('parsename-->'+parsename);
                                user.firstName = parsename;
                                update user;
                                dealerContentAccess(String.valueOf(federationIdentifier));
                                distributorContentAccess(String.valueOf(federationIdentifier));
                                //user already exists in the CSS - Will have their Own Profile.
                                accountVerified = true;
                                system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Update User EMPLOYEE END***');
                            }
                            accountVerified=true;
                        } else{
                            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User EMPLOYEE Account NOT Found in CSS***');
                            accountVerified = false; 
                        }
                } else {
                    system.debug('**workgroup id is not empty and either the first five and last five of the workgroupid is not equal**');
                    accountVerified = false;
                }
            }else{
                system.debug('** User doesn\'t have Cummins email id **');
                accountVerified = false;
            }
            
            system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User EMPLOYEE END***');
        }
        system.debug('**CSS JIT Account Contact Verification Method - Setting Values for Create & Update User END***');
        if(!create) {
            Update user;
            system.debug('**CSS JIT Account Contact Verification Method - Update User Complete***');
        }
       /* if(wrkgrpIds.size()>0){
           addLocations(wrkgrpIds,federationIdentifier,attributes);
        }*/
        system.debug('**CSS JIT Account Contact Verification Method - END***Account Verified=' + accountVerified);
        return accountVerified;
    }

    private void handleContact(String accountId,User usr, boolean create, Map<String,String> attributes) {
        //We are calling this method only for Fleet users, Dealer users and HQ externalUsers.- 167730 - Krishnamoorthi 
        system.debug('**CSS JIT Handle Contact Method - BEGIN***');
        Contact c;
        boolean newContact = false;
        if(create){ // && ( (dealerCode != null && string.isNotBlank(dealerCode)) || (fleetcode != null && string.isNotBlank(fleetcode)) )
            List<Contact> cc = [SELECT Id, AccountId FROM Contact where id=:accountid limit 1];
            if(cc.size()==0){
                c = new Contact();
                newContact = true;
            }
        } else {
            String contact = usr.ContactId;
            System.debug('contact'+contact);
            List<Contact> c2 = [SELECT Id, AccountId FROM Contact WHERE Id=:contact];
            /*if((dealerCode!=null && string.isNotBlank(dealerCode)) || (fleetcode != null && string.isNotBlank(fleetcode))){
                String contact = usr.ContactId;
                System.debug('contact'+contact);
                List<Contact> c2 = [SELECT Id, AccountId FROM Contact WHERE Id=:contact];
            }else {
                System.debug('Distributor Doesnot require contact');
            }*/
        } 
        
        if(newContact) {
            c.AccountId = accountId;
            String contactName = attributes.get('FULLNAME');
            String contactsName = attributes.get('SURNAME');
            String parsename = contactName.replace(contactsName,'').replace(',','');
            c.firstname = parsename;
            system.debug('first name'+c.firstname);
            c.lastname = attributes.get('SURNAME');
            c.email = attributes.get('MAIL');
            c.IAM_Cummins_login_ID__c = attributes.get('MAIL');
            insert(c);
            
            
            usr.ContactId = c.Id; 
            /*if((String.isnotblank(dealerCode)|| dealerCode!= null) || (String.isNotBlank(fleetcode) || fleetcode!=null))
            {
                System.debug('Entered If Loop');
                usr.ContactId = c.Id; 
            }*/
            System.debug('Contact id has been Created: 3'+usr.ContactId);
        } else {
          //update(c);
          //
        }
        system.debug('**CSS JIT Handle Contact Method - END***');
    }
    
    
    public void sendEmail() 
    {
        String subject ='hello';        
        String emailL = 'rajesh.narra@cummins.com';
        subject = 'Following user may not have CSS_APP access or No Associated Account Found';
        String emailBody = '<html><h>Hi,</h></html><br/>';
               emailBody+='Please do verify a dealer or distributor account exists for this user:<br/> <br/><br/>';
               emailBody+='<b> Full Name:</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'+ FName+'<br/>';
               emailBody+='<b> <br/>Cummins User Id:</b>&nbsp;&nbsp; '+ cumminsUserId+'</br>';
               emailBody+='<b> <br/>WorkGroup Id:</b>&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp' + Workgroupid +'\n \n <br/>';
               emailBody+='<br/><br/><br/><br/><br/><br/> Regards, \n \n<br/><br/> System Administrator' ;
         
        List<String> toAddresses= new List <String>();       
        List<CSS_sendEmail__c> emails = CSS_sendEmail__c.getAll().values();
            for(CSS_sendEmail__c css:emails ){
                ToAddresses.add(css.Email_ID__c);
            } 
                 
        //String[] toAddresses = new String[] {'vamsi.jandhyala@cummins.com'};//
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            // mail.setccAddresses(cc);
            mail.setSubject(subject);
            mail.setHtmlBody(emailBody);
            emailSent = true;
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {mail};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        
        if (results[0].success) {
            System.debug('The email was sent successfully.');
        } else {
            System.debug('The email failed to send: '+ results[0].errors[0].message);
        }
    }
    
    /**************************************************************
    Author: Rajesh Narra
    Method Name: dealerContentAccess
    Description: This method serve the purpose of granting the
                 users access to the dealer training materials  
    Return Type: Void
    ***************************************************************/
    @future
    public static void dealerContentAccess(string userId){
        System.debug('** Enter Into Dealer Method');
        GroupMember dealerGroup = new GroupMember();
        dealerGroup.GroupId = [select id,name from group  where type='Regular' and name=:System.label.Guidanz_Content_Dealer_Users LIMIT 1].id;
        dealerGroup.UserOrGroupId=[select id,FederationIdentifier from user where FederationIdentifier=:userId LIMIT 1].id;
        Set<String> dealerUsers = new set<String>();
        
        for(GroupMember gm:[SELECT UserOrGroupId FROM GroupMember WHERE Group.Name=:System.label.Guidanz_Content_Dealer_Users LIMIT 50000]){
            dealerUsers.add(gm.UserOrGroupId);
        }
        System.debug('** '+dealerUsers.size());
        if((dealerUsers.size()== 0) || (dealerUsers!=null && dealerUsers.size()>0 && !(dealerUsers.contains(userId)))){
            System.debug('** Dealer');
            try{
                upsert dealerGroup;
            } catch(Exception e){
                System.debug('** Did not inserrt the user to the Dealer Public Group'+e.getMessage());
            }
        }
        System.debug('** Enter Into Dealer Method');
    }
    
    /**************************************************************
    Author: Rajesh Narra
    Method Name: distributorContentAccess
    Description: This method serve the purpose of granting the
                 users access to the distributor training materials  
    Return Type: Void
    ***************************************************************/
    @future
    public static void distributorContentAccess(String userId){
         System.debug('** Enter Into Distributor Method');
        GroupMember distributorGroup = new GroupMember();
        distributorGroup.GroupId = [select id,name from group  where type='Regular' and name=:System.label.Guidanz_Content_Distributor_Users LIMIT 1].id;
        System.debug('** Fed Id'+userId);
        System.debug('** Fed Identifier'+userId);
        distributorGroup.UserOrGroupId=[select id,FederationIdentifier from user where FederationIdentifier=:userId LIMIT 1].id;
        Set<String> distributorUsers = new set<String>();
        
        for(GroupMember gm:[SELECT UserOrGroupId FROM GroupMember WHERE Group.Name=:System.label.Guidanz_Content_Distributor_Users LIMIT 50000]){
            distributorUsers.add(gm.UserOrGroupId);
        }
        System.debug('** '+distributorUsers.size());
        if((distributorUsers.size()==0) || (distributorUsers!=null && distributorUsers.size()>0 && !(distributorUsers.contains(userId)))){
            System.debug('** Distributor');
            try{
                upsert distributorGroup;
            }catch(Exception E){
                System.debug('** Did not inserrt the user to the Dealer Public Group'+e.getMessage());
            }
        } 
    } 
    
    //Method to Identify Partner User
    public Boolean verifyPartnerUser(Map<String, String> attributes){
        
        Boolean partnerFlag = false;
        
        Workgroupid = attributes.get('WORKGROUP');
        Workgroupid = Workgroupid.replace('|', ';');
        
        list<String> wrkgrpIds = Workgroupid.split(';');
        
        if(Workgroupid != null && String.isNotEmpty(Workgroupid))
        {
            for(string st:wrkgrpIds)
            {
                if(st.length()!=null && st.length()>0 && st.length()==Integer.ValueOf(System.label.CIHR_Fleet_Code_Length)){
                    if(st.subString(0,19).contains('-P')){
                        primaryWorkgroupId = st.subString(7,19).replace('-P','');
                    }
                }else{
                    if(st.subString(0,13).contains('-P'))
                    {
                        primaryWorkgroupId = st.subString(0,13).replace('-P','');
                    }
                }
            }
        }
        
        if(primaryWorkgroupId != null && primaryWorkgroupId != ''){
            List<Account> lstAccount = [Select Id,Name,CSS_Timezone__c,CSS_Language__c,CSS_Locale__c,
                                           CSS_EmailEncoding__c,IAM_Service_Provider_Code__c,EDS_Workgroup_Name__c,
                                           CSS_DistributorCode__c,BillingCity,ShippingCity FROM Account
                                           WHERE(Location__c =: primaryWorkgroupId AND isPartner = TRUE)
                                           limit 1];
            
            if(lstAccount != null && lstAccount.size() > 0){
                partnerFlag = true;
            }
        }
        
        return partnerFlag;
    }
}