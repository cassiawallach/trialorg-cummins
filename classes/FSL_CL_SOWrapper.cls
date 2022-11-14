/**********************************************************************
Name:FSL_CL_SOWrapper
Copyright Â© 2020  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This is class written for User story CT2-352 to receive PM service order from BMS. 
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     Ravikanth Macherla        11/30/2020    Initial Development 

********************************************************************************************************************/

public class FSL_CL_SOWrapper{
    public Header Header;
    public list<DataArea> DataArea;
    public class Header {
        public Sender Sender;
        public String Target;   //CSS
        public String LocationCode; //02850-02651
        
    }
    public class Sender {
        public String ServiceName;  //PMWO
        public String SenderID; //BMS
        
    }
    public class DataArea {
        public String ERPWorkOrder; //49440
        public String CustomerCode; //102686
        public String PaymentType;  //
        public String Prepaid;  //PM Prepay
        public String SiteId;   //2
        public String SiteLocation; //Mobile
        public String SiteRating;   //
        public String SiteContactId;    //3
        public String ERPContractNumber;    //
        public String ProjectNumber;
        public String Type; //ENGINE CORE
        public String PSN;  //77346855
        public String Complaint;    //
        public String SupervisorFirstName; //
        public String SupervisorLastName; //
        public String Cause;    //
        public String Correction;   //
        public String ScheduledDate;    //
        public String PromisedDate; //
        public String TransactionType;  //PM
        public String ServiceType;    //
        public String SubType;  //
        public String StandardService;  //
        public String NumberOfTechnicians;  //2
        public String PreferredTechnician;  //
        public String StatusNotes;  //
        public String EngineFamily;
        public String ServiceModelName;
        public String UnitNumber;
        public String SalesSegment;
        public list<Parts> Parts;
        public String EPRFlag;  //
        public String WorkOrderNotes;   //Internal Comments
        public String TotalDuration;    //Total SRT Hours
        public list<SRTs> SRTs;
        public String InvoiceDate;  //
        public String TaskGroup;    //
        public string LaborMultiplier ;
    }
    public class Parts {
        public String PartLineNumber;   //898493
        public String PartLineType; //PM
        public String PartNumber;   //32798404
        public String ProductCode;  //
        public String PartDescription;  //Test Part1 Description
        public String PartLocation; //
        public String PartQuantityOrdered;  //3
        public String PartQuantityUsed; //2
        public String EPRFlag;//
        
    }
    public class SRTs {
        public String SRTGroup; //Group1
        public String SRTProcedure; //Procedure1
        public String PartNumber;   //32798404
        public String SRTDescription;   //SRT1 Description
        public String SRTTime;  //0.6
        public String SRTQuantity;  //2
        public String TotalDuration; //
       
    }
    // Wrapper class to store the Result.
    public class FSL_CL_PMOrderwraperResult{
        public String ResponseCode; 
        public String WorkOrderNumber;
        public String ResponseMessage;
    } 
    
    public static FSL_CL_SOWrapper parse(String json) {
        return (FSL_CL_SOWrapper) System.JSON.deserialize(json, FSL_CL_SOWrapper.class);
    }
    
}