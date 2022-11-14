/**********************************************************************
Name:CSS_SiebelSendClaimStatus_Req_Json
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:  
Get Adjudicator response and Claim Status from Siebel-request Wrapper class #133403                                                        
=======================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                 DETAIL                                 
1.0 -   Rajkumar BT      04/09/2018        INITIAL DEVELOPMENT  
=======================================================================
***********************************************************************/
public class CSS_SiebelSendClaimStatus_Req_Json{

    public class Header{
        public Target Target;
        public Sender Sender;
    }

    public class Sender{
        public string ServiceName;
        public string SenderID;
    }

    public class Target{
        public string TargetID;
        public string SourceEnvironment;
    }   

    public class DataArea{
        public string SiebelClaimNumber;
        public string GuidanzClaimNumber;
        public string ClaimStatus;
        public List<NoteDetail> NoteDetails;
    }

    public class NoteDetail{
        public string Note;
        public string NoteType;
        public string RowId;
        public DateTime LastUpdateDate;
        public DateTime CreatedDate;
        public string FirstName;
        public string LastName;
        public string UserID; 
    }

    public Header Header;
    public DataArea DataArea;

    public static CSS_SiebelSendClaimStatus_Req_Json parse(String json) {
        return (CSS_SiebelSendClaimStatus_Req_Json) System.JSON.deserialize(json, CSS_SiebelSendClaimStatus_Req_Json.class);
    }
}