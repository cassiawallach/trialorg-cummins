/**********************************************************************
Name: FSLgetCampaignRequestwrap
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This process is used to call Getcampaigndata web service on change of PSN inorderto get Field action number,type and desc.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE                                   
1.0     Ravikanth Macherla         6/019/2019                         
***********************************************************************/
public class FSLgetCampaignRequestwrap{

    public class Sender {
        public String ServiceName;
        public String SenderID;
        public String MessageID;
    }

    public class DataArea {
        public String Territory;
        public String Region;
        public String FailureDate;
        public String Esn;
    }

    public Header Header;
    public DataArea DataArea;

    public class Header {
        public String Target;
        public Sender Sender;
    }

    
    //public static JSON2Apex parse(String json) {
        //return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    //}
}