/**********************************************************************
Name: FSL_GETCampaignServiceswrapper
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
1.0     Ravikanth Macherla         5/28/2019                         
***********************************************************************/
public class FSL_GETCampaignServiceswrapper {
    
    public cls_DataArea DataArea;
    public cls_Header Header;
    
    public class cls_DataArea {
        public cls_Details[] Details;
    }
    
    public class cls_Details {
        public String Status;   //Approved
        public String CampaignStartDate;    //2015-02-27
        public String FailCode; //WEQP
        public cls_SrtList[] SrtList;
        public String MultipleTimes;    //N
        public String CampaignDesc; //ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST
        public String FailMode; //EZ
        public String InShopSrtLimitFlag;   //N
        public String CompleteIndicator;    //N
        public Integer CampaignNumber;  //1609
        public String BusinessUnit; //CMI
        public String CampaignEndDate;  //2020-12-31
        public cls_PartList[] PartList;
        public String CampaignType; //TRP
    }
    
    public class cls_SrtList {
        public String SrtCode;  //00-901-00
        public String SrtDescription;   //Administrative Time - Open and Close Repair Order (Shop Repairs)
    }
    
    public class cls_PartList {
        public String PartNumber;   //388639600
        public String PartDescription;  //6.2 CALIBRATION FLT REG.
        public Integer PartQuantity;    //1
    }
    
    public class cls_Header {
        public String Status;   //Success
        public String ReturnCode;   //ORA-00000
        public String ReturnCodeDescription;    //Normal, Successful completion.
        public string MessageIdentifier;
        public string MessageType;
    }  
    
    public static FSL_GETCampaignServiceswrapper parse(String json) {
        return (FSL_GETCampaignServiceswrapper) System.JSON.deserialize(json, FSL_GETCampaignServiceswrapper.class);
    }
}