/******************************************************************
 * Purpose  : To check app access for different profiles
 History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthk Golakaram            ----------       INITIAL DEVELOPMENT          
1.1 -    Shubhangi Sardar            12/03/2020       Added NPBU Diagnostic app
1.2 -    Karthik Raj Golaakram       04/13/2021      Added Changes for Global Dealer Portal
 ******************************************************************/

public class IAM_Trigger_Check {
    
    Public Static Map<String,Boolean> checkApplicationAccess(String userId){
        Map<String,Boolean> apps=new Map<String,Boolean>();
        List<user> usr=new List<User>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
            usr=[select id,ProfileId from user where id=:userId];
        }
        if(!usr.isEmpty()){
            Profile pro=[select id,name from Profile where id =:usr[0].ProfileId];
            system.debug('PROFILE NAME'+pro.name);
            if(pro.name==System.Label.IAM_System_Admin || pro.name==System.Label.IAM_Distributor || pro.name=='IAM_Distributor_Admin_Platform'||pro.name=='IAM_CIHR_Platform')
            {
                apps.put('Connected Solutions',True);
                apps.put(System.Label.IAM_AppName_QSOL,true);
                apps.put('Cummins Service Training',True);
                apps.put('WWSPS',True);
                apps.put('Rapid Serve Web',True);
                apps.Put('Guidanz',True);
                apps.put('Guidanz Mobile',True);
                apps.put('EDS',True);
                apps.put('CUMPAS 2.0',True);
                apps.put('Marketplace',True);
                apps.put('Fleetguard FIT',True);
                apps.put(Label.IAM_App_GuidanzMobileFieldTest,True);
                /* 12/03/2020 - Added NPBU Diagnostic app */
                apps.put(Label.IAM_FT_NPBU_Diagnostics,True);
                apps.put('Global Dealer Portal',True);
                apps.put(Label.IAM_AppName_FluidRegistraion,True);
                apps.put(Label.IAM_AppName_GuidanzServicePortal,true);
                
            }
            else{
                List<PermissionSetAssignment> ps=[select id,PermissionSetId from PermissionSetAssignment where AssigneeId=:usr[0].id];
                System.debug('Printing user Permissions sets'+ps);
                if(!ps.isEmpty()){
                    set<id> pName=new set<id>();
                    for(PermissionSetAssignment P:ps){
                        pName.add(p.permissionSetId);
                    }
                    if(!pName.isEmpty()){
                        
                        List<PermissionSet> pNames=[Select id,Name,Label from PermissionSet where id=:pName];
                        System.debug('Printing permissionset Names'+pNames);
                        
                        for(PermissionSet s:pNames){
                            if(s.Name.ContainsIgnoreCase('IAM_DA')){
                                apps.put('Connected Solutions',True);                            
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_QSOL')){
                                apps.put(System.Label.IAM_AppName_QSOL,true);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_CST')){
                                apps.put('Cummins Service Training',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_Promotion')){
                                apps.put('Cummins Service Training',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_WWSPS')){
                                apps.put('WWSPS',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_RSW')){
                                apps.put('Rapid Serve Web',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_Guidanz')){
                                apps.Put('Guidanz',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_Guidanz_Mobile')){
                                apps.put('Guidanz Mobile',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_EDS')){
                                apps.put('EDS',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_Cumpas')){
                                apps.put('CUMPAS 2.0',True);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_OSM_Business_Admin')||s.Name.ContainsIgnoreCase('OSM_Fleet_Admin') || s.Name.ContainsIgnoreCase('OSM_Sales_Admin') || s.Name.ContainsIgnoreCase('OSM_Sales_User') || s.Name.ContainsIgnoreCase('OSM_Support_Admin') || s.Name.ContainsIgnoreCase('OSM_Distributor_Admin')){
                                apps.put('Marketplace',True);
                                apps.put('Guidanz',True);
                                apps.put('EDS',True);
                                apps.put('Guidanz Mobile',True);
                                apps.put('Cummins Service Training',True);
                                apps.put(System.Label.IAM_AppName_QSOL,true);
                            }
                            if(s.Name.ContainsIgnoreCase('IAM_Guidanz_Mobile_Field_Test')){
                                apps.put(Label.IAM_App_GuidanzMobileFieldTest,True);
                            }
                            /* 12/03/2020 - Added NPBU Diagnostic app */
                            if(s.Name.ContainsIgnoreCase('IAM_FT_NPBUDiagnostics')){
                                apps.put(Label.IAM_FT_NPBU_Diagnostics,True);
                            } 
                            if(s.Name.ContainsIgnoreCase('IAM_Fleetguard_Fit')){
                                apps.put('Fleetguard FIT',True);
                            } 
                            /* 12/03/2020 - Added NPBU Diagnostic app */    
                            if(s.Name.ContainsIgnoreCase('IAM_FT_NPBUDiagnostics')){    
                                apps.put(Label.IAM_FT_NPBU_Diagnostics,True); 
                              } 
                               // changes for Global dealer Portal
                            if(s.Name.containsIgnoreCase('IAM_Global_Dealer')){
                                apps.put('Global Dealer Portal',True);
                            }
                            if(s.Name.containsIgnoreCase('IAM_Fluids_Registration')) {
                                apps.put(Label.IAM_AppName_FluidRegistraion,True);
                            }
                            if(s.Name.containsIgnoreCase('IAM_Guidanz_Service')) {
                                apps.put(Label.IAM_AppName_GuidanzServicePortal,true);
                            } 
                                                     
                            if(s.Name.ContainsIgnoreCase('IAM_Distributor')){
                                //Add all applications in the Map.
                                apps.put('Connected Solutions',True);
                                apps.put(System.Label.IAM_AppName_QSOL,true);
                                apps.put('Cummins Service Training',True);
                                apps.put('WWSPS',True);
                                apps.put('Rapid Serve Web',True);
                                apps.Put('Guidanz',True);
                                apps.put('Guidanz Mobile',True);
                                apps.put('EDS',True);
                                apps.put('CUMPAS 2.0',True);
                                apps.put('Marketplace',True);
                                apps.put(Label.IAM_App_GuidanzMobileFieldTest,True);
                                /* 12/03/2020 - Added NPBU Diagnostic app */
                                apps.put(Label.IAM_FT_NPBU_Diagnostics,True);
                                apps.put('Global Dealer Portal',True);
                                apps.put(Label.IAM_AppName_FluidRegistraion,True);
                                apps.put(Label.IAM_AppName_GuidanzServicePortal,True);
                            }
                        }
                        System.debug('Printing application Map'+apps);
                    }
                }
            }
        }
        return apps;
    }
    
    @AuraEnabled
    Public Static Void throwException(){
        System.debug('Entered error Meesage');
        throw new AuraHandledException('Insufficient Access Privilages.');
    }
}