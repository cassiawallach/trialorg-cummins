public class IAM_GL_ResponseParser{
    public getSPSearchResultsReturn getSPSearchResultsReturn;
    Public class getSPSearchResultsReturn {
        public errorCode errorCode;
        public Integer langId;  //1
        public cumminsLocationDTO cumminsLocationDTO;
        public paginationDTO paginationDTO;
        public spDTO spDTO;
        public omrResultFlag omrResultFlag;
    }
    Public class errorCode {
        public boolean nil;
    }
    Public class cumminsLocationDTO {
        public branchDTO branchDTO;
        public hqDTO hqDTO;
    }
    Public class branchDTO {
        public String countryName;  //United States
        public String businessPhone;    //248 573-1900
       // public String countyDistrict;   //Oakland
        public String spName;   //East - New Hudson
        public String hqCode;   //02850
        //public String emergencyPhone;   //248 255-6306
        //public webAddress webAddress;
        public String cityName; //New Hudson
        public String spcode;   //02857
        public String durationText; //1 min
        public String address1; //54250 Grand River Ave.
       // public address2 address2;
       // public address3 address3;
        //public Integer zipCode; //48165
        public String distanceText; //0.3 mi
        public Double longitude;    //-83.58677009999997
        public Integer distanceValue;   //0
       // public String fax;  //248 573-4010
       // public tollFreeFax tollFreeFax;
       // public custServicePhone custServicePhone;
        //public amenityComments amenityComments;
       // public tollFreePhone tollFreePhone;
        //public email email;
        public String stateName;    //Michigan
        public Integer spLocType;   //101
        public Double latitude; //42.5054122
        //public marketProgram marketProgram;
    }
    /*Public class webAddress {
        public boolean nil;
    }
    Public class emergencyPhone {   
        public boolean nil;             
        }
    
    Public class address2 {
        public boolean nil;
    }
    Public class address3 {
        public boolean nil;
    }
    Public class tollFreeFax {
        public boolean nil;
    }
    Public class custServicePhone {
        public boolean nil;
    }
    Public class amenityComments {
        public boolean nil;
    }
    Public class tollFreePhone {
        public boolean nil;
    }
    Public class email {
        public boolean nil;
    }
    Public class marketProgram {
        public boolean nil;
    }*/
    Public class hqDTO {
        public boolean nil;
    }
    Public class paginationDTO {
        public boolean nil;
    }
    Public class spDTO {
        public boolean nil;
    }
    Public class omrResultFlag {
        public boolean nil;
    }
    Public class countyDistrict {
        public boolean nil;
    }
    public static IAM_GL_ResponseParser parse(String json){
        return (IAM_GL_ResponseParser) System.JSON.deserialize(json, IAM_GL_ResponseParser.class);
    }
 }