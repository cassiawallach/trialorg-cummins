/************************************************************
Name:  IAM_AssignApplication_PS_Extension
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_AssignApplication_PS_Extension class.
//below class is mainly used as a invokable class fron process builder in order to assaign and delete permission sets from users.
//this class will have two functions which gets invoked on insertion and update on the application status                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                  
1.0 -    Nishant Verma             02/10/2020        Fluidwatch Changes for site admin page 
1.1 -    Karthik Raj Golakaram     01/25/2021        Making Changes for OSM High Prod issue - INC1022619
1.2 -    Karthik Raj Golakaram     03/25/2021        Made changes for bulk user provisioning.
*****************************************************/
/********************************************************************************
***********************************************************************************/ 
public class IAM_AssignApplication_PS_Extension implements Queueable{
    Public map<ID,string> roleUrsIdsMap;
    Public map<string,ID> rolePsIdsMap;
    Public string Action;
    
    Public IAM_AssignApplication_PS_Extension(Map<Id,String> roleUrsIdsMap,Map<String,Id> rolePsIdsMap,String Action){
        this.roleUrsIdsMap=roleUrsIdsMap;
        this.rolePsIdsMap=rolePsIdsMap;
        this.Action=Action;
    
    }
    
    public void execute(QueueableContext Context) {
           
        System.debug('begin AssignPermissionSetToUsers.......'+roleUrsIdsMap + 'pSMAp... '+rolePsIdsMap+' Action... ' + Action); 
        if(Action=='Insert'){
            List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
            
            if(!roleUrsIdsMap.isEmpty()){
                for (User u : [Select Id, Name FROM User Where ID =:roleUrsIdsMap.keyset()]){ // Add fields as per your requirement...
                    list<string> roles=roleUrsIdsMap.get(u.id).split(';');
                    system.debug('@@@@'+roles);
                    for(string str : roles){
                        system.debug('######'+str);
                        system.debug('######'+rolePsIdsMap.get(str));
                        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = rolePsIdsMap.get(str), AssigneeId = u.Id);
                        permissionSetList.add(psa);
                    }
                }
                
                System.debug('Permission set list that is going to updated......'+permissionSetList);
                Database.SaveResult[] saveResult=Database.insert(permissionSetList,false);//added false in the lsit.
                for(Database.SaveResult sr:saveResult){
                    if(!sr.isSuccess()){
                        //notSuccess=True;
                        for(Database.Error err : sr.getErrors()) {
            				System.debug('The following error has occurred.');                    
            				System.debug(err.getStatusCode() + ': ' + err.getMessage());
            				System.debug('Account fields that affected this error: ' + err.getFields());
        				}
                    }
                }
            } 
        }  
        //part where delete of permision sets need to written
        if(Action == 'Delete'){
            try{
                Set<id> permissionSetIds= new Set<id>(rolePsIdsMap.values());
                Boolean notSuccess=false;
              	List <PermissionSetAssignment> ps=[SELECT Id from PermissionSetAssignment WHERE PermissionSetId IN :permissionSetIds AND AssigneeId IN :roleUrsIdsMap.keyset()];
            	system.debug('Printing User details and permissionsset assaignment that are going to get delete '+ps);
             	Database.deleteResult[] srList= Database.Delete(ps,false);
                System.debug('Printing Save Result'+srList);
                for(Database.deleteResult sr:srList){
                    if(!sr.isSuccess()){
                        notSuccess=True;
                        for(Database.Error err : sr.getErrors()) {
            				System.debug('The following error has occurred.');                    
            				System.debug(err.getStatusCode() + ': ' + err.getMessage());
            				System.debug('Account fields that affected this error: ' + err.getFields());
        				}
                    }
                }    
                
                if(notSuccess){
                   System.debug('Printing future class from queueable'); 
                    removePermissionSetsFromUser(permissionSetIds,roleUrsIdsMap.keyset());
                }
                //Delete ps;  
            }catch(Exception ex){
               System.debug('Printing Exception ex'+ex.getStackTraceString()); 
            }
        }
}
    @future
    Public Static void removePermissionSetsFromUser(Set<id> pIds,Set<id> userIds){
        List<PermissionSetAssignment> ps=[SELECT Id from PermissionSetAssignment WHERE PermissionSetId IN :pIds AND AssigneeId IN :userIds ];
        	Database.deleteResult[] srList= Database.Delete(ps,false);
                System.debug('Printing Save Result'+srList);
                for(Database.deleteResult sr:srList){
                    if(!sr.isSuccess()){
                        for(Database.Error err : sr.getErrors()) {
            				System.debug('The following error has occurred.');                    
            				System.debug(err.getStatusCode() + ': ' + err.getMessage());
            				System.debug('Account fields that affected this error: ' + err.getFields());
        				}
                    }
                } 
    }
}