/**********************************************************************
Name: EVL_WorkOrderTechnicianHandler
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:                                              
-------  
To give access to Users assigned to a Work Order 

======================================================
======================================================
History                                               
-------                                                            
VERSION  AUTHOR                     DATE             Detail                      
1.0     Devon Sumbry          10/05/2020          
***********************************************************************/
public  class EVL_WorkOrderTechnicianHandler 
{   
    public static void WorkOrderTechnicianShare(string  recordId, string  userOrGroupId , string caseid)
    {
        //Sruthi Changes - To prevent sharing access to users who already have the required level of access
        
        Boolean hasWOAccess = FALSE;
        Boolean hasCaseAccess = FALSE;
        
        Set<String> recIds = new Set<String>{recordId, caseid};
        
        if(userOrGroupId.startsWith('005')){
            for(UserRecordAccess usr : [Select RecordId, HasReadAccess, HasEditAccess from UserRecordAccess where RecordId IN : recIds AND UserId =: userOrGroupId ]){
                if(usr.RecordId == recordId && usr.HasEditAccess){
                    hasWOAccess = TRUE;
                }
                if(usr.RecordId == caseid && usr.HasReadAccess){
                    hasCaseAccess = TRUE;
                }
            }
        }
        
        if(!hasWOAccess){
            WorkOrderShare woShare = new WorkOrderShare();//Service Request share also has to be given.
            woShare.AccessLevel = 'Edit';//Access should be read/Write for WorkOrder 
            woShare.ParentId = recordId;
            woShare.UserOrGroupId = userOrGroupId ;//Should be changed to Technicians User Id.
            Database.SaveResult WOsr = Database.insert(woShare,true);
        }
        
        if(!hasCaseAccess){
            CaseShare caShare = new CaseShare();
            caShare.CaseAccessLevel  = 'Edit'; // Edit for Service Requests so that status changes can be tracked
            caShare.CaseId = caseid;
            caShare.UserOrGroupId = userOrGroupId;     
            Database.SaveResult CASEsr = Database.insert(caShare,true);
        }    
    }
}