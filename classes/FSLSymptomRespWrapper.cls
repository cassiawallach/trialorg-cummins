/**********************************************************************
Name: FSLSymptomRespWrapper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the setting all the records in one single wrapper class.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSymptomRespWrapper {
    global String ID;//Is it CDS_ID__c field on Symptos object? need to confirm----******do we need to map ID field from json response to cds_id__c field on fsl_symptoms object.
    //CHANGE FSLSymptomUpdatesBatchProcess CLASS FOR ALL ITS REFERENCES
    global String Name;
    global String BusinessUnit;
    global String ComplaintCode;
    global String Status;
    global String cds_highlevelcategoryId;
    global String cds_highlevelcategory;
    global String CreatedOn;
    global String ModifiedOn;
    global String CreatedBy;
    global String LanguageKey;  
    global string filter;
    global string CDSID;
    global FSLSymptomRespWrapper()
    {}
    
    /*sample response
     * {
        "ID": "6d5e6138-149f-e811-a95c-000d3a3780dd",
        "Name": "1939 Display Does Not Respond/Function",
        "BusinessUnit": "Engine",
        "ComplaintCode": "999",
        "Status": "Active",
        "cds_highlevelcategoryId": "1b37027a-119f-e811-a95b-000d3a37870e",
        "cds_highlevelcategory": "Lubricating Oil Symptom",
        "CreatedOn": "2018-08-13T16:16:26",
        "ModifiedOn": "2018-08-13T16:16:26",
        "CreatedBy": "CDS D365WebJob",
        "LanguageKey": "en"
    }
    */
}