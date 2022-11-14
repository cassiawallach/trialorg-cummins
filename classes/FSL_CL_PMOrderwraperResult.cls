// Wrapper class to store the Result.
    public class FSL_CL_PMOrderwraperResult{
        public Header Header;
        public list<DataArea> DataArea;
       public class Header {
        public String LocationCode; //02850-02651
        public String ReturnCodeDescription;    //Records Processed
        public String Status;   //SUCCESS
      }
      public class DataArea {
        public String ERPWorkOrder; //49440
        public String GuidanzServiceOrder;  //00016625
        public String ReturnCodeDescription;    //Record Processed Successfully
        public String Status;   //SUCCESS
    }
    }