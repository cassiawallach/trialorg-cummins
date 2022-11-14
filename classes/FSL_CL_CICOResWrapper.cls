public class FSL_CL_CICOResWrapper {
    public Header Header;
    public DataArea DataArea;
    
    public class Header {
        public String Status;
        public String ReturnCodeDescription;
        public Location Location;
    }
    
    public class Location {
        public String LocationID;
    }
    
    public class DataArea {
        public List<Timesheet> Timesheets;
    }
    
    public class Timesheet {
        public String TimesheetNumber;
        public String ReturnCodeDescription;
        public String Status;
    }
    
    public FSL_CL_CICOResWrapper(){}
}