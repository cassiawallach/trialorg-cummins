public class FSL_CL_ServiceHistoryWrapper
{
    public Header Header{get;set;}
    public list<DataAreaVal> DataArea {get;set;}
    
    public FSL_CL_ServiceHistoryWrapper()
    {
        Header = New Header();
        DataArea = new list<DataAreaVal>();
    }
    
    public class Header
    {
        String Status='';
        String ReturnCodeDescription='';
        Sender Sender = New Sender();
        Target Target = New Target ();
        Location Location = new Location();
    }
    
    public class Sender
    {
        String ServiceName='';
        String SenderID='';
        String MessageID='';
    }
    
    public class Target
    {
        String TargetID='';
    }
    
    public class Location
    {
        String LocationID='';
    }
    
    public class DataAreaVal
    {
        public String WorkSummaryCOMPLAINT;
        public String ClaimNumber;
        public String Invoice;
        public String BMSWOreference;
        public String DistanceType;
        public String FaultcodesCORRECTION;
        public String UnitHours;
        public String WorkSummaryCAUSE;
        public String ReceivedDate;
        public String FuelBurn;
        public String BMSLink;
        public String CustomerName;
        public String ProductModel;
        public String Distance;
        public String Location;
    }
}