/**********************************************************************
Name: CG_FieldActionSRTResponse
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This is used to parse the Response JSON for  
            Field Action Service
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Rajkumar BT      02/07/2018       INITIAL DEVELOPMENT
***********************************************************************/
public class CG_FieldActionSRTResponse {

    public class DataArea {
        public List<FieldAction> FieldAction;
    }

    public DataArea DataArea;
    public Header Header;

    public class Header {
        public String ReturnCodeDescription;
        public String Status;
        public String ReturnCode;
        public String MessageIdentifier;
        public String MessageType;//Added as part Of Mule Integration
    }

    public class FieldAction {
        public String FieldActionNumber;
        public String FieldActionType;
        public List<FieldActionSRTTime> FieldActionSRTTime;
    }

    public class FieldActionSRTTime {
        public String SRTDetails;
        public String SRTTitle;
        public Integer StepID;
        public String StepDescription;
        public Double RTIME;
        public Double ATIME;
        public Double BTIME;
        public Double CTIME;
        public Double DTIME;
        public Double S1TIME;
        public String S1DESCRIPTION;
        public Double S2TIME;
        public String S2DESCRIPTION;
        public Double S3TIME;
        public String S3DESCRIPTION;
        public Double S4TIME;
        public String S4DESCRIPTION;
        public Double S5TIME;
        public String S5DESCRIPTION;
        public Double S6TIME;
        public String S6DESCRIPTION;
        public Double S7TIME;
        public String S7DESCRIPTION;
        public Double S8TIME;
        public String S8DESCRIPTION;
        public Double S9TIME;
        public String S9DESCRIPTION;
        public Integer SRTQuantity;
        public String SRTMessage;
        public String Assignment;
        public String SRTAccessCode;
        public Double SRTTime;
        public Integer QuoteID;
        public String ECMFlag;//Added as part of story - GSSC-125
    }

    public static CG_FieldActionSRTResponse parse(String json) {
        return (CG_FieldActionSRTResponse) System.JSON.deserialize(json, CG_FieldActionSRTResponse.class);
    }
}