public class CSS_WS_J2A_GetServiceModel {

    public class DataArea {
        public String OutputMessageCode;
        public String OutputMessage;
        public List<EquipmentData> EquipmentData;
        public String OutputMessageType;
    }

    //public class ServiceModelDetails {
    //    public String EF;
    //    public String SMN;
    //}

    public class Header {
        public String Status;
        public String ReturnCodeDescription;
    }

    public DataArea DataArea;
    public Header Header;

    public class EquipmentData {
        public String Status;
        public String Configuration;
        public String EngineFamilyCode;
        //public List<ServiceModelDetails> ServiceModelDetails;
        public String EquipmentId;
        public String Model;
        public String AccessCode;
        public String Make;
        public String ApplicationCategory;
    }
    
    public static CSS_WS_J2A_GetServiceModel parse(String json) {
        return (CSS_WS_J2A_GetServiceModel) System.JSON.deserialize(json, CSS_WS_J2A_GetServiceModel.class);
    }
}