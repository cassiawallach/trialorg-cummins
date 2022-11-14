/******************************************************************************************************
Name : FSL_shareworkorder 
Description : This is an apex sharing class for workorders(fslservicejobs)

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   26/02/2019               Srinivas Reddy Katkam                   apex class created          
*********************************************************************************************************/


public class FSL_workOrderShare {

    
    public static void workOrderRecShare(list<workorder> workorderList){   
        set<Id> workorderId=new set<Id>();
        Map<Id,string> terrName=new Map<Id,string>();
         Map<string,Id> grpMap=new Map<string,Id>();
        List<WorkOrderShare> woShareList = new List<WorkOrderShare>();
        List<CaseShare> SRShareList = new List<CaseShare>();
        set<string> serTer=new  set<string>();
        Id CId;
       for(workorder wo:workorderList){
               workorderId.add(wo.id);
               //CId = WO.caseID;
           }
           system.debug('**CId**'+CId);
       list<workorder> wlist =[select id,caseID,ServiceTerritory.name from workorder where id in:workorderId];
           for(workorder wo:wlist){
               terrName.put(wo.id,wo.ServiceTerritory.name);
           }
        system.debug('**terrName**'+terrName);
           list<Group> grp=[SELECT Id, Name FROM Group WHERE name in:terrName.values()];
       system.debug('>>>group name<<<'+grp);
        for(Group gp:grp){
          grpMap.put(gp.name, gp.id); 
        }
       
       if(grp.size()>0){
           for(workorder w:workorderList){
            // Create a new workorderShare object for each workorder where serviceterritoryId field is not NULL.
            WorkorderShare woShare = new WorkorderShare();
            // Give Read write access to that UserOrGroupId for this particular workorder record.
            woShare.AccessLevel = 'edit';
            // Assign workorder Id of workorder record.
            woShare.parentId = w.id;
              // system.debug('');
            // Assign UserOrGroupId id to grant read write access to this particular workorder record.  
            woShare.UserOrGroupId =grpMap.get(terrName.get(w.id));
            woShareList.add( woShare );
            /*if( CId != null ) {
                    CaseShare SRShare = new CaseShare();
                    SRShare.CaseAccessLevel = 'edit';
                    SRShare.CaseId = CId;
                    SRShare.UserOrGroupId = grpMap.get(terrName.get(w.id));
                    SRShareList.add(SRShare);
           }*/       
        }
        
        if( woShareList != null && woShareList.size() != 0 ) {
            try {
                  system.debug('***woShareList**'+woShareList);
               insert woShareList;
            }catch( Exception e ) {
                system.debug('Error::::::'+e.getMessage());
            }
        }
         /*if( SRShareList != null && SRShareList.size() != 0 ) {
            try {
                  system.debug('***SRShareList**'+SRShareList);
               insert SRShareList;
            }catch( Exception e ) {
                system.debug('Error::::::'+e.getMessage());
            }
        } */
        //CT4-585
        for(workorder wo:workorderList){
                   CId = WO.caseID;
        }
        system.debug('**CId**'+CId);
        for(workorder w:workorderList){
            if( CId != null ) {
                    CaseShare SRShare = new CaseShare();
                    SRShare.CaseAccessLevel = 'edit';
                    SRShare.CaseId = CId;
                    SRShare.UserOrGroupId = grpMap.get(terrName.get(w.id));
                    SRShareList.add(SRShare);
           }
            
        }
        if( SRShareList != null && SRShareList.size() != 0 ) {
            try {
               system.debug('***SRShareList**'+SRShareList);
               insert SRShareList;
            }catch( Exception e ) {
                system.debug('Error::::::'+e.getMessage());
            }
        }
        
    }
    //CT4-585
    

}
}