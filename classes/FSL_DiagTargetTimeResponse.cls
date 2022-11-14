/**********************************************************************
Name: FSL_DiagTargetTimeResponse
Copyright © 2022  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for  
            Diagnostic Target Time
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Charan         18/08/2022         INITIAL DEVELOPMENT
***********************************************************************/
public class FSL_DiagTargetTimeResponse {
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

    public static FSL_DiagTargetTimeResponse parse(String json) {
        return (FSL_DiagTargetTimeResponse) System.JSON.deserialize(json, FSL_DiagTargetTimeResponse.class);
    }
}