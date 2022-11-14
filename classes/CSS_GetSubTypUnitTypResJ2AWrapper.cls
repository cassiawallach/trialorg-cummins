public class CSS_GetSubTypUnitTypResJ2AWrapper {

    public class SubType {
        public String CodeValue;
        public String CodeDesc;
    }

    public class DataArea {
        public List<SubType> SubType;
        public List<SubType> SubTypeInt;
        public List<SubType> UnitTypes;
        public List<SubType> SalesSegment;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
    }

    public Header Header;
    public DataArea DataArea;

    public class Location {
        public String LocationID;
    }

    
    public static CSS_GetSubTypUnitTypResJ2AWrapper parse(String json) {
        return (CSS_GetSubTypUnitTypResJ2AWrapper ) System.JSON.deserialize(json, CSS_GetSubTypUnitTypResJ2AWrapper.class);
    }
}