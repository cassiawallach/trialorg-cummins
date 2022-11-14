public class CSS_Service_Job_AssignTo_Sharing {
    public void assignToSharing(CSS_Job_Order__c[] triggernew){
        try{
            //END - Process Connected Diagnostic Data for 1st Record only. 
            List<CSS_Job_Order__share> jobShares = new List<CSS_Job_Order__share>();
            // For each of the Job records being inserted, do the following:
            for(CSS_Job_Order__c job : triggernew){
                
                
                // Create a new Job__Share record to be inserted in to the Job_Share table.
                
                CSS_Job_Order__share JobOrderShare= new CSS_Job_Order__share();
                
                // Populate the Job__Share record with the ID of the record to be shared.
                JobOrderShare.ParentId = job.Id;
                
                // Then, set the ID of user or group being granted access. In this case,
                // we’re setting the Id of the Assigned To User that was specified by 
                // the Writer in the Assigned_To__c lookup field on the SJob record.  
                
                // Tech -1
                JobOrderShare.UserOrGroupId = job.Assigned_To__c;
                
                // Techinician access for this particular Job record.
                JobOrderShare.AccessLevel = 'edit';
                
                JobOrderShare.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                
                // Add the new Share record to the list of new Share records.
                jobShares.add(JobOrderShare);
                
                // Repeate for Tech-2
                CSS_Job_Order__share JobOrderShare1= new CSS_Job_Order__share();
                JobOrderShare1.ParentId = job.Id;
                JobOrderShare1.UserOrGroupId = job.Additional_Tech1__c;
                JobOrderShare1.AccessLevel = 'edit';
                JobOrderShare1.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare1);
                
                // Repeate for Tech-3
                CSS_Job_Order__share JobOrderShare2= new CSS_Job_Order__share();
                JobOrderShare2.ParentId = job.Id;
                JobOrderShare2.UserOrGroupId = job.Additional_Tech2__c;
                JobOrderShare2.AccessLevel = 'edit';
                JobOrderShare2.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare2);
                
                // Repeat for Tech - 4
                CSS_Job_Order__share JobOrderShare3= new CSS_Job_Order__share();
                JobOrderShare3.ParentId = job.Id;
                JobOrderShare3.UserOrGroupId = job.Additional_Tech3__c;
                JobOrderShare3.AccessLevel = 'edit';
                JobOrderShare3.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare3);
                // Repeat for Tech - 5
                CSS_Job_Order__share JobOrderShare4= new CSS_Job_Order__share();
                JobOrderShare4.ParentId = job.Id;
                JobOrderShare4.UserOrGroupId = job.Additional_Tech4__c;
                JobOrderShare4.AccessLevel = 'edit';
                JobOrderShare4.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare4);
                // Repeat for Tech - 6
                CSS_Job_Order__share JobOrderShare5= new CSS_Job_Order__share();
                JobOrderShare5.ParentId = job.Id;
                JobOrderShare5.UserOrGroupId = job.Additional_Tech5__c;
                JobOrderShare5.AccessLevel = 'edit';
                JobOrderShare5.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare5);
                // Repeat for Tech - 7
                CSS_Job_Order__share JobOrderShare6= new CSS_Job_Order__share();
                JobOrderShare6.ParentId = job.Id;
                JobOrderShare6.UserOrGroupId = job.Additional_Tech6__c;
                JobOrderShare6.AccessLevel = 'edit';
                JobOrderShare6.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare6);
                // Repeat for Tech - 8
                CSS_Job_Order__share JobOrderShare7= new CSS_Job_Order__share();
                JobOrderShare7.ParentId = job.Id;
                JobOrderShare7.UserOrGroupId = job.Additional_Tech7__c;
                JobOrderShare7.AccessLevel = 'edit';
                JobOrderShare7.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare7);
                // Repeat for Tech - 9
                CSS_Job_Order__share JobOrderShare8= new CSS_Job_Order__share();
                JobOrderShare8.ParentId = job.Id;
                JobOrderShare8.UserOrGroupId = job.Additional_Tech8__c;
                JobOrderShare8.AccessLevel = 'edit';
                JobOrderShare8.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare8);
                // Repeat for Tech - 10
                CSS_Job_Order__share JobOrderShare9= new CSS_Job_Order__share();
                JobOrderShare9.ParentId = job.Id;
                JobOrderShare9.UserOrGroupId = job.Additional_Tech9__c;
                JobOrderShare9.AccessLevel = 'edit';
                JobOrderShare9.RowCause = Schema.CSS_Job_Order__share.RowCause.CSS_Apex_AssignedTo_Sharing__c;
                jobShares.add(JobOrderShare9);
                
            }
            
            // Insert all of the newly created Share records and capture save result 
            Database.SaveResult[] jobShareInsertResult = Database.insert(jobShares,false);
            // Database.SaveResult[] jobShareRemoveResult = Database.delete(removeJobShare,false);
        }
        catch (DmlException e) {
            system.debug('Catch' + e.getMessage() + ' ' + e.getLineNumber());
        }
    }    
}