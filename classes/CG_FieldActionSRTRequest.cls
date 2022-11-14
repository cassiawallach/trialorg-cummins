/**********************************************************************
Name: CG_FieldActionSRTRequest
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Request JSON for 
			Field Action Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Rajkumar BT      02/07/2018       INITIAL DEVELOPMENT
***********************************************************************/
public class CG_FieldActionSRTRequest {
    
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
        public String DTTimestamp;
        public String EngineFamilyCode;
        public String ServiceModelName;
        public String EffectiveDTTime;
        public String EquipmentID;
        public String Language;
        public FieldAction[] FieldAction;
        //public List<FieldAction> FieldAction;
    }

    public class FieldAction {
        public String FieldActionNumber;
        public String FieldActionType;
        public String SRTTab;
    }

    public static CG_FieldActionSRTRequest parse(String json) {
        return (CG_FieldActionSRTRequest) System.JSON.deserialize(json, CG_FieldActionSRTRequest.class);
    }
}