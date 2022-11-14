/**********************************************************************************************************************************
Name:FSL_TextUnsubscribeWrapper
Copyright © 2020  Cummins
===================================================================================================================================
===================================================================================================================================
Purpose:                                                            
This is the wrapper class for FSL_TextCommuniationUnsubscribe
===================================================================================================================================
========================================================================================================================================
History                                                            
-------                                                            
VERSION                     AUTHOR                  DATE                            DETAIL                                
1.0 -                       ManiKumar               08/10/2020                      INITIAL DEVELOPMENT                     
***********************************************************************************************************************************/


Global class FSL_TextUnsubscribeWrapper {
    public string contact_mobile_phone;
    public string smssubscribeFlag;
    
    Global Class UnsubscribeResponse {
        public string MessageIdentifier;
        public string ReturnCode;
        public string ReturnCodeDescription;
        public string Status;
        public string MessageType;
    }
}