Public  class IAM_createConProvforContact {

    public static String createConApps(String username,String email,String conId,Boolean GuidanzUser){
        String conAppResult = 'OK';
        String errString = 'OK';
        String allGroupsToSplit='';
        List<IAM_Contact_Provisioning__c> lstConapplications = new List<IAM_Contact_Provisioning__c>();
        List<IAM_Application__c> lstAccapplications = new List<IAM_Application__c>();
        List<IAM_Application__c> lstUpdateExistingApp = new List<IAM_Application__c>();
        
        Try{
            conAppResult = reclaimConUpdate(username,email,conid); //This will directly update the contact record with our creating provisioning records
            String Promotionid='';
            String userId='';
            List<user> u1=[select id,IAM_UID__c,IAM_Promotion__c from user where username=:username];
            System.debug('Printing username'+u1);
            if(!u1.isEmpty()){
                if(!string.isEmpty(u1[0].IAM_Promotion__c)){
                    PromotionId=u1[0].IAM_Promotion__c;
                }
                userId=u1[0].id;
            }
            
            Map<String,IAM_Application__c>  mapApp=new Map<String,IAM_Application__c>();
            Map<String,IAM_Application_Groups__c> mapAppGrp= new Map<String,IAM_Application_Groups__c>();//Custom settings
            //fix - defect - D-2767 - create Account provisioning record and contact provisioning record for free application if not already exist, and create contact provision record for paid application only if related account provision record already exist else do not create.
            Map<String,IAM_Application_Groups__c> mapPaidAppGrp = new Map<String,IAM_Application_Groups__c>();
            List<IAM_Application_Groups__c> lstAppGroup = IAM_Application_Groups__c.getall().values();//getting all the custom settings
            Map<String,String> mapAppRoles= new Map<String,String>();
            Set<String> Roles= new Set<String>();
            Set<String> Modularity = new Set<String>();
            set<String> qsol=new Set<String>();
            set<String> guidanz= new Set<String>();
            set<String> WWSPS=new Set<String>();
            set<String> EDS=new Set<String>();
            set<String> Cumpas = new Set<String>();
            set<String> warranty=new Set<String>();
            set<String> cst =new Set<String>();
            set<String> guidanzMobile= new Set<string>();
            Set<string> applicationNames=new Set<String>();
            Map<String,Set<String>> mapRoles= new Map<String,set<String>>();// map to store roles for all the applications except Gudanz mobile
            Map<string,Set<String>> mapGuidanzMobileRoles= new Map<String,Set<String>>();// map to store roles for Guidanz mobile.

            for(IAM_Application_Groups__c appGrp : lstAppGroup){
                mapAppGrp.put(appGrp.IAM_DN_value__c.toUpperCase(), appGrp);
                mapPaidAppGrp.put(appGrp.IAM_Application_Name__c, appGrp);
            }
            System.debug('mapPaidAppGrp...  ' + mapPaidAppGrp);
            Contact cont = [Select id,IAM_Applications__c,Accountid,IAM_is_Member_of__c,Username__c from Contact where id=:conId];
            System.debug('cont12345...  ' + cont);
            //adding is member off and application groups filed on the contact.
            if(!String.isEmpty(cont.IAM_Applications__c)&&!String.isEmpty(Cont.IAM_is_member_of__c)){
                allGroupsToSplit=cont.IAM_applications__c+'|'+cont.IAM_is_Member_of__c;
            }else if(!String.isEmpty(cont.IAM_Applications__c)){
                allGroupsToSplit=cont.IAM_applications__c;
            }else if(!String.isEmpty(Cont.IAM_is_member_of__c)){
                allGroupsToSplit=cont.IAM_is_Member_of__c;
            }
            
            System.debug('Prining all the applications that need to be split'+allGroupsToSplit);
            
            System.debug('cont...12345  ' + cont); 
            if(!String.isEmpty(allGroupsToSplit)){
                List<IAM_Application__c> IAMapp=[select id,IAM_Application_Name__c,IAM_Account_Name__c,IAM_Free_Subscription__c,IAM_Role__c,IAM_Status__c,IAM_Subscription_Start_Date__c,IAM_Subscription_End_Date__c,IAM_Subscription_Name__c,IAM_Subscription_Count__c,IAM_Qsolview__c,IAM_Qsolexpiration__c,IAM_swregExpire__c  from IAM_Application__c where IAM_Account_Name__c=:cont.Accountid and IAM_Status__c='Active']; // get all account access and features.
                
                for(IAM_Application__c a:IAMapp){
                    mapApp.put(a.IAM_Application_Name__c,a); //Since we are doing this with application Name only either one of the qsol appliciton records exsists.
                }
                System.debug('mapApp...  ' + mapApp);
                //if(!IAMapp.isEmpty()){
                List<String> tmpString = allGroupsToSplit.split('\\|');
                List<String> dnString=new List<String>();
                set<String> applicationCSTNames= new Set<String>();
                for(String st:tmpString){
                    dnString.add(st.toUpperCase());
                    
                }

                System.debug('Printng string list'+tmpString);
                System.debug('Printing list Size'+tmpString.Size());

                for(String appname:dnString){
                    IAM_Application_Groups__c appGrp = null;
                    System.debug('Printing app Name from group'+mapAppGrp.get(appname));
                    if(mapAppGrp.containsKey(appname)){ //Checking if DN is present in the list of emails or not.
                        appGrp = mapAppGrp.get(appname);
                        System.debug('Printing app Name from group'+appGrp.IAM_Application_Name__c);
                        applicationCSTNames.add(appGrp.IAM_Application_Name__c);
                        if(System.Label.IAM_AppName_Guidanz==appGrp.IAM_Application_Name__c){
                        
                            if(!guidanz.Contains(appGrp.IAM_Role_Name__c)){
                                guidanz.add(appGrp.IAM_Role_Name__c);
                            }

                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,guidanz);
                            }
                        }else if(System.Label.IAM_AppName_Promotion==appGrp.IAM_Application_Name__c){
                            if(!cst.contains(appGrp.IAM_Role_Name__c)){
                               if(!String.isEmpty(appGrp.IAM_Role_Name__c)){
                                cst.add(appGrp.IAM_Role_Name__c);
                                }
                            }

                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,cst);
                            }
                        }else if(System.Label.IAM_WWSPS==appGrp.IAM_Application_Name__c){
                            
                            if(!wwsps.contains(appGrp.IAM_Role_Name__c)){
                                wwsps.add(appGrp.IAM_Role_Name__c);
                            }

                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,wwsps);
                            }

                        }else if(System.Label.IAM_AppName_Cumpas==appGrp.IAM_Application_Name__c){//Here I need to check for ou value as well
                            //Need to check the dn value now
                            System.debug('Pritning cumpas check'+(appname.ContainsIgnoreCase('ou=app_cumpas')));
                            if(appname.ContainsIgnoreCase('ou=app_dbu')){ 
                                System.debug('Pritning cumpas check ..... '+cumpas);
                                System.debug('Pritning cumpas role check ..... '+appGrp.IAM_Role_Name__c);
                                if(!cumpas.Contains(appGrp.IAM_Role_Name__c)){
                                    cumpas.add(appGrp.IAM_Role_Name__c);
                                }
                            }else if(appname.ContainsIgnoreCase('ou=app_cumpas')){
                                System.debug('Printing app_cumpas'+appname);
                                if(!Modularity.Contains(appGrp.IAM_Role_Name__c)){
                                    Modularity.add(appGrp.IAM_Role_Name__c);
                                }
                            }
                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,cumpas);
                            }
                        }else if(System.Label.IAM_AppName_EDS==appGrp.IAM_Application_Name__c){
                            if(!eds.contains(appGrp.IAM_Role_Name__c)){
                                eds.add(appGrp.IAM_Role_Name__c);
                            }
                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,eds);
                            }           
                        }else if(System.Label.IAM_AppName_QSOL==appGrp.IAM_Application_Name__c){
                            if(!qsol.contains(appGrp.IAM_Role_Name__c)){
                                qsol.add(appGrp.IAM_Role_Name__c);
                            }
                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapRoles.put(appGrp.IAM_Application_Name__c,qsol);
                            }           
                        }else if(System.Label.IAM_Guidanz_Mobile_App_Name==appGrp.IAM_Application_Name__c){
                            if(!guidanzMobile.contains(appGrp.IAM_Role_Name__c)){
                                guidanzMobile.add(appGrp.IAM_Role_Name__c);
                            }
                            if(!mapRoles.ContainsKey(appGrp.IAM_Application_Name__c)){//Since there is no application name              
                                mapGuidanzMobileRoles.put(appGrp.IAM_Application_Name__c,guidanzMobile);
                            }           
                        }

                        applicationNames.add(appGrp.IAM_Application_Name__c);
                    }       
                }
                System.debug('Printing map of applications'+mapRoles);
                System.debug('Printing modularity'+Modularity);
                System.debug('Prirnintg application Names'+applicationNames);

                if(!mapRoles.isEmpty()){
                    //Once we have the values then insert these with corresponding contact features.
                    set<String> finalApp=mapRoles.keyset();
                    
                    //checking if Account application exist if not then create a new one.
                    for(String app:finalApp){
                        //fix - defect - D-2767 - create new account provisioning record if not already exist for free application.
                        if(mapPaidAppGrp.containsKey(app) && mapPaidAppGrp.get(app).IAM_Free_application__c){
                            IAM_Application__c accApp = new IAM_Application__c();
                            System.debug('record name'+Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(app).getRecordTypeId());
                            accApp.recordtypeid = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(app).getRecordTypeId(); 
                            accApp.IAM_Account_Name__c = cont.Accountid;
                            if(app.equalsIgnoreCase(System.Label.IAM_EDS) || app.equalsIgnoreCase(System.Label.IAM_INSITE) || app.equalsIgnoreCase(System.Label.IAM_Cummins_Service_Training) || app.equalsIgnoreCase(System.Label.IAM_Quick_Serve_Online)){
                                accApp.IAM_Free_Subscription__c = false;
                                accApp.IAM_Subscription_Start_Date__c = System.today();
                                accApp.IAM_Subscription_End_Date__c = System.today() + 365;
                                accApp.IAM_Subscription_Name__c = app;
                            }else{
                                accApp.IAM_Free_Subscription__c = true;
                            }
                            accApp.IAM_Application_Name__c = app;
                            accApp.IAM_Subscription_Count__c = Integer.valueof(System.Label.IAM_Default_App_Subscription_Count.trim()); 
                            accApp.IAM_Status__c = System.Label.IAM_Status_Active;
                            String rls= '';
                            boolean isRoleExist = false;
                            //defect - D-2801 - if account provisioning record already exist then take roles which is not available in  application group custom setting and create a new account provisioning record and add role taken from existing record and application group custom setting and create a new account provisioning record and inactive existing one for free application
                            if(mapApp.containsKey(app)){
                                String[] appRoles = mapApp.get(app).IAM_Role__c.split(';');
                                Set<String> setRole = new Set<String>();
                                System.debug('appRoles ....343434.  '+ appRoles); 
                                System.debug('mapRoles....343434.  '+ mapRoles);
                                //removing duplication role from account provisioning and application group custom setting.
								//checking role and making sure that role is present are not.
                                for(String role : appRoles)
                                    setRole.add(role);
                                for(String mRole : mapRoles.get(app)){
                                    if(!appRoles.contains(mRole))
                                        isRoleExist = true;
                                    setRole.add(mRole);
                                }
                                    
                                    
                                System.debug('setRole....343434.  '+ setRole);
                                for(String finalRole : setRole)
                                    rls += (rls == '' ? '' : ';') + finalRole;
								/*Commenting the code part because of the 
                                if(isRoleExist){    
                                    IAM_Application__c updateApp = mapApp.get(app);
                                   // updateApp.IAM_Status__c = System.Label.IAM_Status_Inactive;
								   updateApp.IAM_Role__C=
                                    lstUpdateExistingApp.add(updateApp);
                                }
								*/
                            }else{
                                System.debug('rls..448989...  '+ rls);  
                                for(String s : mapRoles.get(app)){
                                    rls+= (rls==''?'':';')+s;
                                }
                            }
							
							if(isRoleExist){    
                                    IAM_Application__c updateApp = mapApp.get(app);
                                   // updateApp.IAM_Status__c = System.Label.IAM_Status_Inactive;
								   updateApp.IAM_Role__C=rls;
                                    lstUpdateExistingApp.add(updateApp);
                                }
							
                            System.debug('rls....343434.  '+ rls);
                            accApp.IAM_Role__c = rls;
                            
                            if(System.Label.IAM_AppName_Cumpas == app){
                                String m= '';
                                for(String s:Modularity){
                                    m+= (m==''?'':';')+s;
                                }
                                accApp.IAM_Cumpas_Modularity__c = m;  
                            } 
                            //defect - D-2801 create new account provisioning record if existing record role is not same.
							//Commented on 5-26-2020
                            /*if(!mapApp.containsKey(app) || (mapApp.containsKey(app) && isRoleExist))
                                lstAccapplications.add(accApp);*/
                        }                       
                    }
                    
                    System.debug('lstUpdateExistingApp..... ' + lstUpdateExistingApp);
                    if(!lstUpdateExistingApp.isEmpty()){
                        errString = insertUpdateDataRecord(lstUpdateExistingApp, 'update');
                    } 
                    
                    System.debug('lstAccapplications..... ' + lstAccapplications);
                    if(!lstAccapplications.isEmpty()){
                        if(errString.equalsIgnoreCase('OK'))
                            errString = insertUpdateDataRecord(lstAccapplications, 'insert');
                        else
                            errString += insertUpdateDataRecord(lstAccapplications, 'insert');
                    }
                    
                    System.debug('lstAccapplications...1234.. ' + lstAccapplications);
                    Map<String,String> mapAppName = new Map<String,String>();
                    for(IAM_Application__c iamApplication : lstAccapplications){
                        if(!mapAppName.containsKey(iamApplication.IAM_Application_Name__c))
                            mapAppName.put(iamApplication.IAM_Application_Name__c, iamApplication.id);
                    }
                    
                    List<IAM_Contact_Provisioning__c> lstContProv = [Select id,IAM_Application_Name__c,IAM_User__c,IAM_Promotion__c from IAM_Contact_Provisioning__c where IAM_Contact__c =: conId];
                    
                    System.debug('lstContProv..... ' + lstContProv);
                    Map<String,String> mapContProv = new Map<String,String>();
                    Map<String,IAM_Contact_Provisioning__c> mapCont=new Map<String,IAM_Contact_Provisioning__c>();
                    for(IAM_Contact_Provisioning__c iamContProv : lstContProv){
                        if(!mapContProv.containsKey(iamContProv.IAM_Application_Name__c))
                            mapContProv.put(iamContProv.IAM_Application_Name__c, iamContProv.id);
                            mapCont.put(iamContProv.IAM_Application_Name__c,iamContProv);
                    }
                    
                    System.debug('mapContProv..... ' + mapContProv);                    
                    for(String app:finalApp){
                        //fix - defect - D-2767 - create new contact provisioning record if not already exist for free application and for paid application create contact provisioning reocrd if account provisioning record already exist.
                        if(!mapContProv.containsKey(app) && ((mapPaidAppGrp.containsKey(app) && mapPaidAppGrp.get(app).IAM_Free_application__c) || (mapPaidAppGrp.containsKey(app) && mapApp.containsKey(app)))){
                            System.debug('Printing app Name'+app);
                            IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
                            System.debug('record name'+Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(app).getRecordTypeId());
                            conApp.recordtypeid = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(app).getRecordTypeId(); 
                            conApp.IAM_Contact__c = conId;
                            conApp.IAM_Start_Date__c = system.Today();
                            conApp.IAM_Status__c = System.Label.IAM_Status_Active;
							//Need to add start end date/Subsription date.QSOL Expiration /SwregEcxpire
                            //issue# 38 making this check box checked to stop triggering application access approval email once contact status set from Reclaimed to Active
                            conApp.IAM_Is_Reclaim_Access_Email_Send__c = true;
                            System.debug('Printing..IAM_Is_Reclaim_Access_Email_Send__c... ' + conApp.IAM_Is_Reclaim_Access_Email_Send__c);
                            System.debug('Printing roles that are getting assigned to the user'+mapRoles.get(app)+'for application'+app);

                            String rls= '';
                            //defect - D-2801 - role should be taken from account provisioning record for paid application while creating contact provisioning record
                            if(mapApp.containsKey(app) && !mapPaidAppGrp.get(app).IAM_Free_application__c){
                                String[] appRoles = mapApp.get(app).IAM_Role__c.split(';');
                                for(String role : appRoles){
                                    for(String s : mapRoles.get(app)){
                                        if(role.equalsIgnoreCase(s))
                                            rls += (rls==''?'':';')+s;
                                    }
                                    System.debug('rls.....  '+ rls);
                                }
                            }else{
                                for(String s:mapRoles.get(app)){
                                    rls+= (rls==''?'':';')+s;
                                }
                            }
                            System.debug('rls..9999...  '+ rls);
                            if(app=='Cummins Service Training'){
                                conApp.IAM_Promotion__c=PromotionId;
                            }
                            conApp.IAM_Role__c =rls;//need to get roles from map roles
                            conApp.IAM_User__c=userId;
							conApp.IAM_End_Date__c=mapApp.get(app).IAM_Subscription_End_Date__c;
                            conApp.IAM_Application_Name__c = app;
                            conApp.IAM_Account_Application__c = (null != mapApp.get(app))? mapApp.get(app).id : mapAppName.get(app); //Need to get app id from the applications list
                            if(System.Label.IAM_AppName_Cumpas==app){
                                String m= '';
                                for(String s:Modularity){
                                    m+= (m==''?'':';')+s;
                                }
                                conApp.IAM_Cumpas_Modularity__c=m;  
                                
                                if(conApp.IAM_Role__c==null||conApp.IAM_Role__c==''){
                                    conApp.IAM_Role__c=System.Label.IAM_Cumpas_Default_Role;
                                }
                            }else if(System.Label.IAM_AppName_QSOL == app){
                                conApp.IAM_Qsolexpiration__c = mapApp.get(app).IAM_Qsolexpiration__c;
                                conApp.QSOLView__c = mapApp.get(app).IAM_Qsolview__c;
                            }
                            if(!String.isBlank(conApp.IAM_Role__c))
                                lstConapplications.add(conApp);
                        }else{
                            // Need to update the User id for the exsiting records as and as well as Promotion Id.
                            if(mapCont.ContainsKey(app)){
                                mapCont.get(app).IAM_User__c=userId;
                                if(app=='Cummins Service Training'){
                                    mapCont.get(app).IAM_Promotion__c=PromotionId;
                                }
                                 mapCont.get(app).IAM_Is_Reclaim_Access_Email_Send__c = true;
                                
                            }
                            
                        }
                    }
                }// this iff will close the loop for all the applications except Guidanz Mobile.
                
                if(!mapGuidanzMobileRoles.isEmpty()){//if loop to check for the guidanz mobiel applicationn access and give access to them.
                    
                    //Querying at accoutn level to get the account Provisiongs.
                    List<IAM_Application__c> lstguidanzMob=[SELECT id,IAM_Application_Name__c,IAM_Role__c,IAM_Subscription_Name__c,IAM_swregExpire__c,IAM_Guidanz_Mobile_Roles__c,IAM_Subscription_End_Date__c FROM IAM_Application__c where IAM_Account_Name__c=:cont.Accountid and IAM_Status__c=:System.Label.IAM_Status_Active and IAM_Application_Name__c=:System.Label.IAM_Guidanz_Mobile_App_Name];
                    
                    system.debug('Printing all the records from Account level'+lstguidanzMob);
                    Map<String,IAM_Application__c> gmobileMapActive=new Map<String,IAM_Application__c>();
                    
                    if(!lstguidanzMob.isEmpty()){
                        for(IAM_Application__c appGMZ : lstguidanzMob){
                            gmobileMapActive.put(appGMZ.IAM_Guidanz_Mobile_Roles__c,appGMZ);
                        }
                        System.debug('Printing Map for active Contact Provisionigs Guidanz Mobile'+gmobileMapActive);
                        
                        //Now we need to create contact provisiong records for each role for Guidanz mobile 
                        if(!guidanzMobile.isEmpty()){
                            for(String gmroles: guidanzMobile){
                                System.debug('Printing role value for each role'+roles);
                                //we should create records for the roles that are present at the account level.so we need to check if this string is present in the keyset or not.
                                if(gmobileMapActive.containsKey(gmroles)){
                                    if(gmobileMapActive.get(gmroles)!=null){
                                        IAM_Contact_Provisioning__c appGMCont= new IAM_Contact_Provisioning__c();
                                        appGMCont.IAM_Application_Name__c=System.Label.IAM_Guidanz_Mobile_App_Name;
                                        appGMCont.IAM_Role__c=gmroles;
                                        appGMCont.IAM_Guidanz_Mobile_Roles__c=gmroles;
                                        appGMCont.IAM_Subscription_Name__c=gmobileMapActive.get(gmroles).IAM_Subscription_Name__c;
                                        appGMCont.IAM_Status__c=System.Label.IAM_Status_Active;
                                        appGMCont.IAM_User__c=userId;
                                        appGMCont.IAM_Account_Application__c=gmobileMapActive.get(gmroles).id;
                                        appGMCont.IAM_Is_Reclaim_Access_Email_Send__c=TRUE;
                                        appGMCont.IAM_userId__c=Cont.Username__c;
                                        appGMCont.IAM_Contact__c=Cont.id;
                                        appGMCont.recordTypeId=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(System.Label.IAM_Guidanz_Mobile_App_Name).getRecordTypeId();
                                        appGMCont.IAM_swregExpire__c=gmobileMapActive.get(gmroles).IAM_swregExpire__c;
                                        appGMCont.IAM_End_date__c=gmobileMapActive.get(gmroles).IAM_Subscription_End_Date__c;
                                        lstConapplications.add(appGMCont);
                                    }
                                }
                            }
                        }
                    }
                }
                
                    System.debug('lstConapplications..... ' + lstConapplications);
                    if(!lstConapplications.isEmpty()){
                        if(errString.equalsIgnoreCase('OK'))
                            errString = insertUpdateDataRecord(lstConapplications, 'insert');
                        else
                            errString += insertUpdateDataRecord(lstConapplications, 'insert');
                        //Calling the assign app feature class to assign permission sets for respective applications.
                        //We need to pass list of Contact Provisionings for this class.
                        if(GuidanzUser){
                            System.debug('Printing is GuidanzUser');
                            IAM_Assign_Application_Permissionset.AssignApplication(lstConapplications);
                        }
                    }
                    /*if(!lstContProv.isEmpty()){
                       // update lstContProv;
                    }*/
                    System.debug('lstConapplications...12345.. ' + lstConapplications);
                    //Check if lsit od contact applications are empty.

                
            //} 
            }
            System.debug('errString...before description ' + errString); 
            if(!errString.equalsIgnoreCase('OK')){
                cont.Description = errString;
                update cont;
            }
        }catch(Exception e){
            System.debug('Printing Exception'+e);
            conAppResult = e.getMessage();
            List<Contact> lstUpdateCon = [select id, Description from contact where id=:conid];
            if(!lstUpdateCon.isEmpty()){
                lstUpdateCon[0].Description = 'Contact reclaim is not done properly. Please see the error:- '+  e.getMessage();
                update lstUpdateCon;
            }
            System.debug('Printing Stack Trace string'+e.getStackTraceString());
            String ProcessedData='Contact Id that needs insertion of Con Prov is'+conid;
            String origin='from Reclaim Process in Contat feature and Access insertion.';
            IAM_ErrorHandling.IAMerrorCapture(ProcessedData,origin,e.getStackTraceString());
        }    
        return conAppResult;
    }
   
   
   //Writting a seperate method to incorporate Contact Update
    public Static String reclaimConUpdate(String username, string email,String contactid){
        String conUpdate = 'OK';
        try{
            List<Contact> lstNewcon = [select IAM_Contact_Status__c,email,Username__c,IAM_Promotion__c,IAM_Applications__c,IAM_Application_Roles__c,IAM_swregexpire__c from contact where id=:contactid];
            List<User> lstUser = [select IAM_UID__c,IAM_Promotion__c,IAM_Application_Roles__c,IAM_Applicationgroups__c,IAM_swregexpire__c from user where Username =: username ];
            System.debug('Printing user record details'+lstUser);
            if(!lstNewcon.isEmpty()){
                lstNewcon[0].IAM_Contact_Status__c='Active';
                lstNewcon[0].Username__c=username;
                lstNewcon[0].email=email;
                lstNewcon[0].IAM_Legacy_User__c=false;
                if(!lstUser.isEmpty()){
                    lstNewcon[0].IAM_Ext_Legacy_Uid__c = lstUser[0].IAM_UID__c;
                    if(!String.isEmpty(lstUser[0].IAM_Promotion__c)){
                    lstNewCon[0].IAM_Promotion__c=lstUser[0].IAM_Promotion__c; 
                    }
                    lstNewcon[0].IAM_Application_Roles__c=lstUser[0].IAM_Application_Roles__c;
                    lstNewcon[0].IAM_Applications__c=lstUser[0].IAM_Applicationgroups__c;
                    lstNewcon[0].IAM_swregexpire__c=lstUser[0].IAM_swregexpire__c;   
                }
                update lstNewcon;
            }
        }catch(exception e){
            System.debug('Printing exception'+e);
            conUpdate = e.getMessage();
            String ProcessedData='Contact getting updated in reclaim Contact Update'+contactid;
            String  origin='Reclaim Contact Update Future Method';
            IAM_ErrorHandling.IAMerrorCapture(ProcessedData,origin,e.getStackTraceString());
        }
        return conUpdate;
    }
    
    @TestVisible private static String insertUpdateDataRecord(List<sObject> lstRecord, String Operation){
        Database.SaveResult[] srList;
        String errorString = '';
        // DML statement
        if(Operation.equalsIgnoreCase('insert'))
            srList = Database.insert(lstRecord, false);
        else if(Operation.equalsIgnoreCase('update'))
            srList = Database.update(lstRecord, false);

        // Iterate through each returned result
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()){
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted/updated records: ' + sr.getId());
            }else{
                 errorString = 'Contact reclaim is not done properly. Please see the error:- ';
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()){
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    errorString += err.getMessage();
                }
            }
        }
        System.debug('error during inset or update errorString... ' + errorString); 
        return errorString;
    }

}