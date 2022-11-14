/**********************************************************************
Name: CG_DiagTargetTimeRequest
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Request JSON for 
			Diagnostic Target Time
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Rajkumar BT      10/15/2019       INITIAL DEVELOPMENT
***********************************************************************/
public class CG_DiagTargetTimeRequest {
    public Header Header;
    public DataArea DataArea;
    
    public class Header {
        public Sender Sender;
        public Target Target;
    }

    public class Sender {
        public String MessageID;
        public String SenderID;
        public String ServiceName;
    }

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String[] SolutionIds;
        public String EquipmentId;
        public String ServiceModelName;
        public String EngineFamily;
        public String EffectiveDateTime;
        public String LanguageCode;
    }

    public static CG_DiagTargetTimeRequest parse(String json) {
        return (CG_DiagTargetTimeRequest) System.JSON.deserialize(json, CG_DiagTargetTimeRequest.class);
    }
}