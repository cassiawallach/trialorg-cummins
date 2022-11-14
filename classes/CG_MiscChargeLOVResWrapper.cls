/*
 * Block comments with details of changes
 */
public class CG_MiscChargeLOVResWrapper {

    public class Sender {
        public String ServiceName;
        public String MessageID;
        public String SenderID;
    }

    public List<DataArea> DataArea;
    public Header Header;

    public class Target {
        public String TargetID;
    }

    public class DataArea {
        public String MiscName;
        public String MiscDescription;
        public String Multiplier;
        public String FlatAmount;
        public String Maximum;
        public String AutoCharage;
        public String CreditType;
        public string ChargeCategory; //Story 150613 Added new field
        public string NewWarrantyClass; //Story 150613 Added new field
    }

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public Sender Sender;
        public Target Target;
        public Location Location;
    }

    public class Location {
        public String LocationID;
    }


    public static CG_MiscChargeLOVResWrapper parse(String json) {
        return (CG_MiscChargeLOVResWrapper) System.JSON.deserialize(json, CG_MiscChargeLOVResWrapper.class);
    }
}