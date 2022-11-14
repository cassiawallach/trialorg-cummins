/**********************************************************************
Name: FSL_getBasicCoverageResponseJ2A
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      01/20/2020      	INITIAL DEVELOPMENT                    
***********************************************************************/

public class FSL_getBasicCoverageResponseJ2A {
    
    public class ListOfCoverageDedutibles {
        public List<CoverageDedutibles> CoverageDedutibles {get;set;}
    }
    
    public class ListOfCoverageDetails {
        public List<CoverageDetails> CoverageDetails {get;set;}
    }
    
    public Header Header {get;set;}
    public BasicCoverageResponseHeader BasicCoverageResponseHeader {get;set;}
    
    public class ListOfExtCoverageDedutibles {
        public List<CoverageDedutibles> ExtendedCoverageDedutibles {get;set;} 
        
    }
    
    public class BasicCoverageResponseHeader {
        public Response Response {get;set;}
    }
    
    public class Response {
        public ListOfCoverageDetails ListOfCoverageDetails {get;set;} 
        public ListOfExtendedCoverageDetails ListOfExtendedCoverageDetails {get;set;} 
    }
    
    public class Header {
        public String ReturnCodeDescription {get;set;} 
        public String Status {get;set;} 
        //Added for defect 134966
        public String Remaining {get;set;} 
    }
    
    public class CoverageDetails {
        public ListOfCoverageComponentList ListOfCoverageComponentList {get;set;} 
        public String WarrantyManualURL {get;set;} 
        public String CoverageType {get;set;} 
        public ListOfCoverageDedutibles ListOfCoverageDedutibles {get;set;} 
        public String ProcedureNumber {get;set;} 
        public String Status { get; set;}//#85179    
        public String WarrantyEndDate { get; set;}//#85179
    }
    
    public class ExtendedCoverageDetails {
        public ListOfExtCoverageDedutibles ListOfExtCoverageDedutibles {get;set;} 
        public String WarrantyManualURL {get;set;} 
        public String BeginMiles {get;set;} 
        public String EndMiles {get;set;} 
        public String ProcedureNumber {get;set;} 
        public String CertificateNumber {get;set;} 
        // public String ProgramID {get;set;} 
        public String BeginHours {get;set;} 
        public String EndHours {get;set;} 
        public String EndDate {get;set;} 
        public String StartDate {get;set;} 
        public String CoverageType {get;set;}
        public String Months {get;set;} 
        public String CAPCoverageID {get;set;} 
        public String Status {get;set;}//#85179
        //  public String remaining { get; set;} //custom field
    }
    
    public class ListOfExtendedCoverageDetails {
        public List<ExtendedCoverageDetails> ExtendedCoverageDetails {get;set;} 
    }
    
    public class CoverageComponentList {
        public String MegawattHours {get;set;} 
        public String CoverageMaxMonths {get;set;} 
        public String CoverageComponentTypeCode {get;set;} 
        public String CoverageMinMonths {get;set;} 
        public String CoverageHours {get;set;} 
        public String CoverageDefenitionType {get;set;} 
        public String CoverageMiles {get;set;}
        public String Status { get; set;}
        public String Componentstatus { get; set;}
        public String ComponentEnddate { get; set;}
        public String WarrantyEndDate { get; set;}
        public String WarrantyManualURL { get; set;}
        public String Remaining { get; set;}
    }
    
    public class ListOfCoverageComponentList {
        public List<CoverageComponentList> CoverageComponentList {get;set;} 
    }
    
    // newly added by harsha
    public class CoverageDedutibles {
        public String BeginHours {get;set;} 
        public String ConstantDecutibleAmt {get;set;} 
        public String SubsequentVisitAmt {get;set;} 
        public String CoverageDefTypeCode {get;set;} 
        public String BeginMonths {get;set;} 
        public String FirstVisitAmt {get;set;} 
        public String ProgramID {get;set;} 
        public String BeginMiles {get;set;} 
        public String BeginMegawattHours {get;set;} 
    }
    public FSL_getBasicCoverageResponseJ2A(){}
}