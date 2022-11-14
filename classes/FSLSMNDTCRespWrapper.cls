/**********************************************************************
Name: FSLSMNDTCRespWrapper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the Setting all the records in one wrapper itself.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
global class FSLSMNDTCRespWrapper {
    global String ID;
    //CHANGE FSLSMNDTCupdateBatchProcess CLASS FOR ALL ITS REFERENCES
    
    global String Name;
    global String BusinessUnit;
    global String FaultTypePcode;
    global String Status;
    global String FaultTypeSPNFMI;
    global String FaultTypeFC;
    global String CreatedOn;
    global String ModifiedOn;
    global String CreatedBy;
    global string CDSID;
    global FSLSMNDTCRespWrapper()
    {}
    /*sample response
     * {
         "ID": "81d0eec6-d385-e811-a95e-000d3a1c53e4",
        "Name": "ISL9 CM2250",
        "BusinessUnit": "Engine",
        "FaultTypeFC": "No",
        "FaultTypeSPNFMI": "No",
        "FaultTypePCode": "No",
        "Status": "Active",
        "CreatedOn": "2018-07-12T13:02:14",
        "ModifiedOn": "2018-07-12T13:02:15",
        "CreatedBy": "Shobhit Tandon"
    }
    */
}