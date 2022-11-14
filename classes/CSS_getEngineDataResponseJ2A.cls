public class CSS_getEngineDataResponseJ2A  {

    public class DataArea {
        public String AutomotiveAppFlag;
        public String Model;
        public String Esn;
        public String EtoConversionDate;
        public String EngineAppCode;
        public String MarineAppFlag;
        public String EngineBillToCode;
        public String EquipmentId;
        public String CustomerName;
        public String BuildDate;
        public String Manufacturer;
        public String EngineFamilyCode;
        public String WarrantyStartDate;
        public String ProdAppCode;
        public String ServiceModelName;
        public String AccessCode;
        public String ProdAppDesc;
        public String EngineAppDesc;
        public string vin;
        public String Region;
        Public String Territory;
        
        //New Fields as part of #127006
        public String EquipmentConfiguration;
        public String NoWarranty;
        public String CriticalPartsListNumber;
        public String OEMSPCode;
        public String DesignPhaseCode;
        public String PACCARFlag;
        
        //New Fields as part of Story# 153520
        public String EngineFamilyName;
        public String ShipDate;
        public String ETOOldPSN;
        public String ETOOldESN {
            get {
                return ETOOldPSN; 
            } set; }
       
    }

    public class Header {
        public String Status;
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String MessageType;
    }

    public DataArea DataArea;
    public Header Header;


    public static CSS_getEngineDataResponseJ2A parse(String json) {
        return (CSS_getEngineDataResponseJ2A) System.JSON.deserialize(json, CSS_getEngineDataResponseJ2A.class);
    }


    /*public class DataArea {
        public String ESN;
        public String SERVICE_MODEL_NAME;
        public String ENGINE_FAMILY_CODE;
        public String ENGINE_APP_CODE;
        public String ENGINE_APP_DESC;
        public String CUSTOMER_NAME;
        public String MANUFACTURER;
        public String MODEL;
        public String WARRANTY_START_DATE;
        public String ACCESS_CODE;
        public String EQUIPMENT_ID;
    }

    public class Header {
        public String MessageIdentifier;
        public String ReturnCode;
        public String ReturnCodeDescription;
        public String Status;
    }

    public Header Header;
    public DataArea DataArea;


    public static CSS_getEngineDataResponseJ2A parse(String json) {
        return (CSS_getEngineDataResponseJ2A) System.JSON.deserialize(json, CSS_getEngineDataResponseJ2A.class);
    }*/
}