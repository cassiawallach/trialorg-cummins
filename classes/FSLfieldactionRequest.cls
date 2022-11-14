public class FSLfieldactionRequest{
    public cls_Header Header;
    public cls_DataArea DataArea;
    public class cls_Header {
        public cls_Target Target;
        public cls_Sender Sender;
    }
    public class cls_Target {
        public String TargetID; //SRT
    }
    public class cls_Sender {
        public String ServiceName;  //GetFieldActionSRTs
        public String SenderID; //SF
        public String MessageID;    //MID123456786
    }
    public class cls_DataArea {
        public String ServiceModelName; //ISX15 CM2350 X101
        public String Language; //en
        public cls_FieldAction[] FieldAction;
        public String EquipmentID;  //EQ2564
        public String EngineFamilyCode; //10
        public String EffectiveDTTime;  //2019-02-19T06:42:15
        public String DTTimestamp;  //2019-02-19T06:42:15
    }
    public class cls_FieldAction {
        public cls_SRTTab SRTTab;
        public String FieldActionType;  //TRP
        public String FieldActionNumber;    //1609
    }
    public class cls_SRTTab {
    }
    public static FSLfieldactionRequest parse(String json){
        return (FSLfieldactionRequest) System.JSON.deserialize(json, FSLfieldactionRequest.class);
    }

   /* static testMethod void testParse() {
        String json=        '{ "Header": { "Target": { "TargetID": "SRT" }, "Sender": { "ServiceName": "GetFieldActionSRTs","SenderID": "SF","MessageID": "MID123456786" }}, "DataArea": { "ServiceModelName": "ISX15 CM2350 X101","Language": "en","FieldAction": [{ "SRTTab": null, "FieldActionType": "TRP", "FieldActionNumber": "1609"},{ "SRTTab":null,"FieldActionType": "TRP","FieldActionNumber": "1603"}],"EquipmentID": "EQ2564","EngineFamilyCode": "10","EffectiveDTTime": "2019-02-19T06:42:15", "DTTimestamp": "2019-02-19T06:42:15" }}';
        FSLfieldactionRequest obj = parse(json);
        System.assert(obj != null);
    }*/
}