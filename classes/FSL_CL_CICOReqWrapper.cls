public class FSL_CL_CICOReqWrapper{
    public Header Header;
    public DataArea DataArea;
    public class Header {
        public Sender Sender;
        public Target Target;   
        public Location Location;
        
    }
    public class Sender {
        public String ServiceName;
        public String SenderID;
        public Sender(String ServiceName, String SenderID){
            this.ServiceName = ServiceName;
            this.SenderID = SenderID;
        }
    }
    public class Target {
        public String TargetID;
        public Target(String TargetID){
            this.TargetID = TargetID;
        }
    }
    public class Location {
        public String LocationID;
        public Location(String LocationID){
            this.LocationID = LocationID;
        }
    }
    public class DataArea {
        public List<Timesheet> Timesheets;
        
        public DataArea(){
            Timesheets = new List<Timesheet>();
        }
    }
    public class Timesheet {
        public String WorkOrderNumber;
        public String ShopWorkOrder;
        public String RepairLocation;
        public String TimesheetNumber;
        public String Reason;
        public String Status;
        public String StartTime;
        public String EndTime;
        public String hrDuration;
        public String minDuration;
        public String ChangeReason;
        public String Notes;
        public String ResourceName;
        public String ResourceWWID;
        public String ApproverWWID;
        public String Type;
        public String SubType;
        public String AdditionalSubType;
        public String AssignmentNumber;
        Public String PayerAccount;
        public String LineNumber;
        public String BillingType;
        public String Vehicle;
        public String Mileage;
        public String MileageMeasure;
        public String StartAddress;
        public String EndAddress;
    }
     
    
}