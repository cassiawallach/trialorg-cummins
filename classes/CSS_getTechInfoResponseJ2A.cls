public class CSS_getTechInfoResponseJ2A {

    public class DataArea {     
        public List<GetTechnicianInfoOutput> GetTechnicianInfoOutput;
    }

    public class Header {
        public String Status;
    }

    public DataArea DataArea;
    public Header Header;
    public class GetTechnicianInfoOutput{
        public String SPCode;
        public String Region;
        public String Territory;
        public String ProductCertification;
        public String WarrantyTrainingCertification;
        public String PromotionIDFlag;
        public List<TechDetails> TechDetails;
    }
    public class TechDetails {
        public String PassedDate;
        public String PromotionId;
        public String UserLoginId;
        public String FirstName;
        public String LastName;
        public Integer QualProgID;
    }

    
    public static CSS_getTechInfoResponseJ2A parse(String json) {
        return (CSS_getTechInfoResponseJ2A) System.JSON.deserialize(json, CSS_getTechInfoResponseJ2A.class);
    }
}