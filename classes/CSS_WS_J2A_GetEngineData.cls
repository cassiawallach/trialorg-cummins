public class CSS_WS_J2A_GetEngineData {
    
    public class DataArea {
        public String Esn;
        public String ServiceModelName;
        public String EngineFamilyCode;
        public String EngineAppCode;
        public String ProdAppCode;
        public String ProdAppDesc;
        public String BuildDate;
        public String EngineBillToCode;
        public String MarineAppFlag;
        public String AutomotiveAppFlag;
        public String EngineAppDesc;
        public String CustomerName;
        public String Manufacturer;
        public String Model;    
        public String WarrantyStartDate;
        public String EtoConversionDate;
        public String EquipmentId;
        public String AccessCode;
    }

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public DataArea DataArea;
    public Header Header;
  
    public static CSS_WS_J2A_GetEngineData parse(String json) {
        return (CSS_WS_J2A_GetEngineData) System.JSON.deserialize(json, CSS_WS_J2A_GetEngineData.class);
    }
}