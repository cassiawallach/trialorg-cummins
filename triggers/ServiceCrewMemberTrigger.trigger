trigger ServiceCrewMemberTrigger on ServiceCrewMember (after insert) {
    if(Trigger.isInsert && Trigger.isAfter) {
    	ServiceCrewMemberTriggerHandler.cloneServiceAppointments(Trigger.New);
    }
}