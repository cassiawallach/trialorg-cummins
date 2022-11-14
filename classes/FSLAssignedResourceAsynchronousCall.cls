/**********************************************************************
Name: FSLAssignedResourceAsynchronousCall
Copyright Â© 20121  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the asycnhronously call the assigned resuorce Logic For Crew Scheduling.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Harish Kolasani   18/06/2020      Accomodation of Crew Scheduling
***********************************************************************/ 
public class FSLAssignedResourceAsynchronousCall {

    @future
    public static void cloneSAForAssignedResource(String newMap) {
        System.debug('\nvp- Asynch');
        clonesSA(newMap);
    }

    public static void cloneSAForAssignedResourceSynch(String newMap) {
        System.debug('\nvp- Synch');
        clonesSA(newMap);
    }
    
    private static void clonesSA(String newMap) {
        Map<Id, AssignedResource> mapNewAssignedResource = (Map<id, AssignedResource>)Json.deserialize(newMap,Map<id, AssignedResource>.class);
        
        set<Id> serviceResourceIDs = new set<Id>();
        set<Id> serviceAppointmentIDs = new set<Id>();
        set<Id> serviceCrewIDs = new set<Id>();
        set<Id> serviceTerritoryIds = new set<Id>();

        Map<string,Assignedresource> heirarchyMap = new Map<string,AssignedResource>();
        Map<string,set<Id>> srCrewStringAndSAIds = new Map<string,set<id>>();
        Map<string,ServiceAppointment> hierarchyStringByClonedSA = new Map<string,ServiceAppointment>();
        Map<string,AssignedResource>  hierarchyStringByClonedAR =  new Map<string,AssignedResource>();

        system.debug('*****mapNewAssignedResource.Keyset()'+mapNewAssignedResource.Keyset().size());

        for(Id assigendRecordId: mapNewAssignedResource.Keyset()){
            
            ID serviceResourceID = mapNewAssignedResource.get(assigendRecordId).ServiceResourceId;
            ID serviceAppointmentID =  mapNewAssignedResource.get(assigendRecordId).ServiceAppointmentId;
            ID serviceCrewID =  mapNewAssignedResource.get(assigendRecordId).ServiceCrewID;
            
            serviceResourceIDs.add(serviceResourceID);
            serviceAppointmentIds.add(serviceAppointmentID);
            serviceCrewIds.add(serviceCrewID);
            
            if(serviceCrewID!=null){
                //AR is part of a Crew. This could be both Resource type of Crew or Crew member
                string concString = string.valueOf(serviceResourceID)+ string.valueOf(serviceCrewID); //unique ServiceResource composite
                string heirarchyString =  string.valueOf(serviceResourceID)+ string.valueOf(serviceCrewID) + string.valueOf(serviceAppointmentID); //unique SA composite
                
                //map of SR composite key to SA
                if(srCrewStringAndSAIds.containsKey(concString)){
                    srCrewStringAndSAIds.get(concString).add(serviceAppointmentID);
                }
                else {
                    srCrewStringAndSAIds.put(concString, new set<Id>{serviceAppointmentID});
                }

                //map of SA composite key to AR
                heirarchyMap.put(heirarchyString,mapNewAssignedResource.get(assigendRecordId));
            }  

        }
        System.debug('*****ServiceResourceIDs'+serviceResourceIDs);
        System.debug('*****ServiceCrewIds'+serviceCrewIds);
        System.debug('*****srCrewStringAndSAIds'+srCrewStringAndSAIds);
        System.debug('*****heirarchyMap'+heirarchyMap);

        // Map of all Service Appts - both parent and children SA
        List<ServiceAppointment> sas = new List<ServiceAppointment>();
        sas = [ SELECT status,ContactID,id,ActualEndTime, ParentRecordId,SchedStartTime,SchedEndTime,
            EarliestStartTime,DueDate,City,Country,Duration,DurationType,
            Formatted_Scheduled_Start__c,FSL__Auto_Schedule__c,Assigned_ServiceResource__c,FSL__GanttColor__c,FSL__GanttIcon__c,
            FSL__GanttLabel__c,FSL__IsMultiDay__c,FSL__Related_Service__c,FSL__Same_Day__c,FSL__IsFillInCandidate__c,General_Symptoms__c,
            FSL__Scheduling_Policy_Used__c,Is_a_Bay_Area_Appointment__c,Is_a_Tech_Appointment__c,PostalCode,SA_Duration_Check_In_Mins__c,
            ServiceNote,State,ServiceTerritoryId,Service_Order__c
            FROM ServiceAppointment 
            WHERE Id In :serviceAppointmentIDs
        ];
        Map<Id,ServiceAppointment> serviceAppointmentMap = new Map<ID,ServiceAppointment>(sas);
        for(ServiceAppointment sa : sas) {
            serviceTerritoryIds.add(sa.ServiceTerritoryId);
        }
        System.debug('\n vp: Svc Territories = ' + serviceTerritoryIds);

        /*Map<Id,ServiceAppointment> serviceAppointmentMap = new Map<ID,ServiceAppointment>( [
                SELECT status,ContactID,id,ActualEndTime, ParentRecordId,SchedStartTime,SchedEndTime,
                EarliestStartTime,DueDate,City,Country,Duration,DurationType,
                Formatted_Scheduled_Start__c,FSL__Auto_Schedule__c,Assigned_ServiceResource__c,FSL__GanttColor__c,FSL__GanttIcon__c,
                FSL__GanttLabel__c,FSL__IsMultiDay__c,FSL__Related_Service__c,FSL__Same_Day__c,FSL__IsFillInCandidate__c,General_Symptoms__c,
                FSL__Scheduling_Policy_Used__c,Is_a_Bay_Area_Appointment__c,Is_a_Tech_Appointment__c,PostalCode,SA_Duration_Check_In_Mins__c,
                ServiceNote,State,ServiceTerritoryId,Service_Order__c
                FROM ServiceAppointment 
                WHERE Id In :serviceAppointmentIDs
            ]
        );*/

        Map<String, ServiceAppointment> existingSAMap = getExistingSAMap(serviceAppointmentIDs);

        // Get Crew members for all SR
        // For each crew member, create indivdiual SA, only if a duplicate SA does not exist already
        for(ServiceCrewMember scm: [
                    SELECT serviceResourceID, ServiceResource.Name, ServiceCrewID, Startdate, Enddate 
                    FROM ServiceCrewMember 
                    WHERE ServiceResourceId IN: serviceResourceIDs 
                    AND ServiceResource.ResourceType = 'T' //not sure if this is needed because Crew member will always be type T
                    AND ServiceCrewID IN: serviceCrewIDs
                ]
            ) 
        {
            System.debug('@@@@@scm'+scm);
            
            string concString= string.valueOf(scm.serviceResourceID)+string.valueOf(scm.serviceCrewID);
            if(srCrewStringAndSAIds.containsKey(concString)) {
                for(Id saID:srCrewStringAndSAIds.get(concString)) {
                    ServiceAppointment sa = serviceAppointmentMap.get(saID);

                    System.debug('@@@@@SA'+sa);
                    String heirarchyString =  string.valueOf(scm.serviceResourceID)+ string.valueOf(scm.serviceCrewID) + string.valueOf(saID);

                    Datetime startDateTime;
                    Datetime endDateTime;
                    System.debug('####################Name'+scm.ServiceResource.Name);
                    System.debug('####################Start Time'+ sa.SchedStartTime + ':::' + scm.startDate);
                    System.debug('####################End Time'+ sa.SchedEndTime + ':::' + scm.EndDate);
                    
                    //Checks to make sure individual SA gets created for the Crew members' available time slots within the Parent SAs
                    if(!(scm.enddate <sa.SchedStartTime || scm.startdate >sa.SchedEndTime))
                    {
                        if (sa.SchedStartTime <= scm.StartDate && sa.SchedEndTime >= scm.EndDate){
                            startDateTime =scm.startDate;
                            endDateTime = scm.enddate;
                        }
                        if(sa.SchedStartTime >= scm.StartDate && sa.SchedEndTime <= scm.EndDate){

                            startDateTime =sa.SchedStartTime;
                            endDateTime = sa.SchedEndTime;

                        }
                        if(sa.SchedStartTime <= scm.StartDate && sa.SchedEndTime <= scm.EndDate){

                            startDateTime =scm.startDate;
                            endDateTime = sa.SchedEndTime;
                        }
        
                        if(sa.SchedStartTime>=scm.StartDate && sa.SchedEndTime >= scm.EndDate ){
                            startDateTime =sa.SchedStartTime;
                            endDateTime = scm.enddate;
                        } 
                    }

                    System.debug('____________'+startDateTime);
                    System.debug('____________'+endDateTime);
    
                    if(startDateTime!=null && endDateTime!=null) {
                        String saDupCheckKey = string.valueOf(startDateTime) + string.valueOf(endDateTime) + string.valueOf(sa.ID) + string.valueOf(scm.serviceResourceID);
                        if(!existingSAMap.containsKey(saDupCheckKey)) {
                            //only do if not an existing appointment, i.e. avoid duplicate SA
                            ServiceAppointment clonedSA= FSLAssignedResourceAsynchronousCall.populateSA(sa,startDateTime,endDateTime);
                            heirarchyString = heirarchyString + string.valueOf(startDateTime) +string.valueOf(endDateTime);
                            hierarchyStringByClonedSA.put(heirarchyString,clonedSA);
                            AssignedResource ar = heirarchyMap.get(heirarchyString);
                            AssignedResource clonedAr = new AssignedResource();
                            clonedAr.ServiceResourceId = scm.serviceResourceID;
                            hierarchyStringByClonedAR.put(heirarchyString,clonedAr);

                            system.debug('****Cloned');
                        }
                    }
                }
            }
        }

        if(hierarchyStringByClonedSA.keyset().size()>0){

            //prevent row locking error 
            /*ServiceTerritory [] sts = [SELECT Id 
                FROM ServiceTerritory 
                WHERE Id IN :serviceTerritoryIds 
                FOR UPDATE];*/

            System.debug('########Insert SA');
            insert hierarchyStringByClonedSA.values();

            for(string hString: hierarchyStringByClonedAR.keyset()){
                hierarchyStringByClonedAR.get(hString).serviceAppointmentID= hierarchyStringByClonedSA.get(hString).id;
            }
            System.debug('########Insert AR');
            insert hierarchyStringByClonedAR.values();

            for(string hString: hierarchyStringByClonedSA.keyset()){
                hierarchyStringByClonedSA.get(hString).Status = 'Scheduled';
            }
            System.debug('########Update AR');
            update hierarchyStringByClonedSA.values();
        }
    }

    public static ServiceAppointment populateSA(ServiceAppointment parentSA,DateTime startTime, DateTime endTime){
        ServiceAppointment clonedSA = new ServiceAppointment();
        ServiceAppointment parentSAToClone = parentSA;

        clonedSA.ParentRecordId = parentSAToClone.ParentRecordId;
        clonedSA.SchedStartTime = startTime; // get from crew member hours in crew level
        clonedSA.ActualEndTime = parentSAToClone.ActualEndTime; // remove 
        clonedSA.EarliestStartTime = parentSAToClone.EarliestStartTime;
        clonedSA.DueDate = parentSAToClone.DueDate;
        clonedSA.SchedEndTime = endTime;  // get from crew member hours in crew level 
        clonedSA.City = parentSAToClone.City;
        clonedSA.Country = parentSAToClone.Country;
        clonedSA.Duration = parentSAToClone.Duration;   // from crew member level 
        clonedSA.ContactId = parentSAToClone.ContactId;                    
        clonedSA.DurationType = parentSAToClone.DurationType; 
        clonedSA.FSL__Auto_Schedule__c = parentSAToClone.FSL__Auto_Schedule__c;
        clonedSA.FSL__GanttLabel__c = parentSAToClone.FSL__GanttLabel__c;
        clonedSA.General_Symptoms__c = parentSAToClone.General_Symptoms__c;
        clonedSA.FSL__Scheduling_Policy_Used__c = parentSAToClone.FSL__Scheduling_Policy_Used__c;
        clonedSA.Is_a_Bay_Area_Appointment__c = parentSAToClone.Is_a_Bay_Area_Appointment__c;
        clonedSA.Is_a_Tech_Appointment__c = parentSAToClone.Is_a_Tech_Appointment__c;
        clonedSA.PostalCode = parentSAToClone.PostalCode;
        clonedSA.ServiceNote = parentSAToClone.ServiceNote;
        clonedSA.State = parentSAToClone.State;
        clonedSA.ServiceTerritoryId = parentSAToClone.ServiceTerritoryId;
        clonedSA.Service_Order__c = parentSAToClone.Service_Order__c;
        clonedSA.FSL_Parent_Crew_SA__c	 = parentSAToClone.id;

        return clonedSA;
    } 

    private static Map<String, ServiceAppointment> getExistingSAMap(Set<Id> saIds) {
        Map<String, ServiceAppointment> existingSAMap = new Map<String, ServiceAppointment>();
        for( ServiceAppointment sa : [SELECT SchedStartTime, SchedEndTime, FSL_Parent_Crew_SA__c, Assigned_ServiceResource__c FROM ServiceAppointment WHERE FSL_Parent_Crew_SA__c IN: saIds]) {
            String dupCheckKey = string.valueOf(sa.SchedStartTime) + string.valueOf(sa.SchedEndTime) + string.valueOf(sa.FSL_Parent_Crew_SA__c) + string.valueOf(sa.Assigned_ServiceResource__c);
            existingSAMap.put(dupCheckKey, sa);
        }
        //System.debug('\n vp dupcheckmap = ' + existingSAMap);
        return existingSAMap;
    }
}