/**********************************************************************
Name:CSS_SiebelSendClaimStatusInbound
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Adjudicator response and Claim Status from Siebel #133403                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -    Vignesh S      04/19/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CG_SiebelApprovalAuthCodeResponseJ2A
{
    public Header Header;
    public List<DataArea> DataArea;
    
    public class DataArea{
        public string WWID;
        public string FirstName;
        public string LastName;
        public string ApprovalCode;
        public string ApprovalCodeActiveFlag;
        public List<string> AuthCode;
    }

    public class Header{
        public string ReturnCodeDescription;
        public string Status;
        public string ReturnCode;
        public string MessageIdentifier;
    }
    
    public static CG_SiebelApprovalAuthCodeResponseJ2A parse(String json) {
        return (CG_SiebelApprovalAuthCodeResponseJ2A) System.JSON.deserialize(json, CG_SiebelApprovalAuthCodeResponseJ2A.class);
    }
}