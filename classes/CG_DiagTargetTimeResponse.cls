/**********************************************************************
Name: CG_DiagTargetTimeResponse
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for  
            Diagnostic Target Time
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Rajkumar BT      10/15/2019       INITIAL DEVELOPMENT
***********************************************************************/
public class CG_DiagTargetTimeResponse {
    public class DataArea {
        public List<Solutions> Solutions;
    }

    public DataArea DataArea;
    public Header Header;

    public class Header {
        public String ReturnCodeDescription;
        public String MessageType;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
    }

    public class Solutions {
        public String SolutionId;
        public String DiagnosticTargetTime;
        public String TargetMessage;
    }

    public static CG_DiagTargetTimeResponse parse(String json) {
        return (CG_DiagTargetTimeResponse) System.JSON.deserialize(json, CG_DiagTargetTimeResponse.class);
    }
}