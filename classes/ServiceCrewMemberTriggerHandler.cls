public class ServiceCrewMemberTriggerHandler {
    private static final Map<Id,ServiceCrewMember> mapSAIDToSCM1 = new Map<Id,ServiceCrewMember>();
    private static Map<String, AssignedResource> mapIdsToARs = new Map<String, AssignedResource>();

    public static void cloneServiceAppointments(List<ServiceCrewMember> scmList) {
        system.debug('kkk::::scmList>>>'+scmList);
        Set<Id> crewIds = new Set<Id>();    

        //Get CrewIds for the new Service Crew Members
        for(ServiceCrewMember scm : scmList) {
            if(String.isNotBlank(scm.ServiceCrewId)) { 
                crewIds.add(scm.ServiceCrewId);
            }
        }
        system.debug('crewIds>>>'+crewIds);

        /***
            * For each Crew member, find parent Crew Apppointments
            * and insert relate AR for each of those appointments.
        */
        List<AssignedResource> crewMemberARs= new List<AssignedResource>();
        if(!crewIds.isEmpty()) {
        	Map<Id, List<AssignedResource>> crewIdToARList = getCrewsScheduledAppointments(crewIds);

            for(ServiceCrewMember scm : scmList) {
                if(crewIdToARList.containsKey(scm.ServiceCrewId)) {
                    List<AssignedResource> crewARList = crewIdToARList.get(scm.ServiceCrewId);
                    for(AssignedResource ar : crewARList) {
                        String ids = (String)ar.ServiceCrewId + (String)ar.ServiceResourceId + (String)ar.ServiceAppointmentId;
                        mapIdsToARs.put(ids, ar); //used later for removing existing dups
                        if(ar.ServiceResource.ResourceType == 'C') {
                            crewMemberARs.add(
                                new AssignedResource(
                                    ServiceResourceId = scm.ServiceResourceId,
                                    ServiceCrewId = scm.ServiceCrewId, 
                                    ServiceAppointmentId = ar.ServiceAppointmentId
                                )
                            );
                        }
                    }
                }
            }

            System.debug('\n Individual Appointments to insert (may have dups): ' + crewMemberARs);
            System.debug ('\n size dups = ' + crewMemberARs.size());

            // Get non-duplicate ARs - i.e. where there's no appointment existing for the same Crew member
            // for the same Crew and same Service Appt already. 
            List<AssignedResource> nonDuplicateCrewMemberARs = getNonDuplicateARs(crewMemberARs);                
            if(!nonDuplicateCrewMemberARs.isEmpty()) {
                //
                 // Inserting AR for each related Parent Crew will fire the AssignedResourceTrigger 
                 // and insert individual appointments for each Crew Member 
                //
                
                insert nonDuplicateCrewMemberARs ;
            }  
        }
    }
    
    // Get Parent Crew appointments for the Crew Id of Service Crew Members
    private static Map<Id, List<AssignedResource>> getCrewsScheduledAppointments(Set<Id> crewIds) {
        Set<String> saStatus = new Set<String>{'Scheduled', 'Dispatched'};
        Map<Id, List<AssignedResource>> crewIdToARList = new Map<Id, List<AssignedResource>>();
        for(AssignedResource ar : [SELECT Id, ServiceCrewId, ServiceResourceId, ServiceAppointmentId, 
                                    ServiceResource.ResourceType, ServiceAppointment.Status 
                                    FROM AssignedResource 
                                    WHERE ServiceCrewId IN :crewIds
                                    AND ServiceAppointment.Status IN : saStatus]) { 
            if(crewIdToARList.containsKey(ar.ServiceCrewId)) {
                crewIdToARList.get(ar.ServiceCrewId).add(ar);
            }
            else {
                crewIdToARList.put(ar.ServiceCrewId, new List<AssignedResource>{ar});
            }
        }
        system.debug('crewIdToARList>>>'+crewIdToARList.values());
        system.debug('crewIdToARList keyset' + crewIdToARList.keySet());
        return crewIdToARList;
    }
    
    public static List<AssignedResource> getNonDuplicateARs(List<AssignedResource> crewMemberARToInsert) {
        List<AssignedResource> nonDuplicateCrewMemberARs = new List<AssignedResource>();
        List<AssignedResource> existingCrewMemberARs = new List<AssignedResource>();

        for(AssignedResource ar: crewMemberARToInsert) {
            String ids = (String)ar.ServiceCrewId + (String)ar.ServiceResourceId + (String)ar.ServiceAppointmentId;
            if(!mapIdsToARs.containsKey(ids)) {
                //non dup
                nonDuplicateCrewMemberARs.add(ar);
            }
            else {
                // for dups, i.e. where a relationship already exists for same Crew member, same Crew and same SA,
                // an AR cannont be inserted. In that case, find that AR and call the Asynch call to create individual SA.
                existingCrewMemberARs.add(
                    new AssignedResource(
                        Id = mapIdsToARs.get(ids).Id,
                        ServiceResourceId = mapIdsToARs.get(ids).ServiceResourceId,
                        ServiceCrewId = mapIdsToARs.get(ids).ServiceCrewId, 
                        ServiceAppointmentId = mapIdsToARs.get(ids).ServiceAppointmentId
                    )
                );
            }
        }
        System.debug ('\n size non dups = ' + nonDuplicateCrewMemberARs.size());

        if(!existingCrewMemberARs.isEmpty()) {
            createIndividualServiceAppt(existingCrewMemberARs);
        }       
    
        return nonDuplicateCrewMemberARs;
    }

    public static void createIndividualServiceAppt(List<AssignedResource> crewMemberARs) {
        Map<Id,AssignedResource> mapAssignedResources = new Map<Id,AssignedResource>();
        for(AssignedResource ar: crewMemberARs){
            mapAssignedResources.put(ar.id,ar);
        }
        if(mapAssignedResources.size()>0) {
            //call the synchrounous method, not the asynch one
            FSLAssignedResourceAsynchronousCall.cloneSAForAssignedResourceSynch(JSON.serialize(mapAssignedResources));
        }
    }
    
}