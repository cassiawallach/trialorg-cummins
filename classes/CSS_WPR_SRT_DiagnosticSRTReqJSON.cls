/**********************************************************************
Name: CSS_WPR_SRT_DiagnosticSRTReqJSON
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is a Request JSON Wrapper class of 
            Diagnostic SRT webservice
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        01/04/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
public class CSS_WPR_SRT_DiagnosticSRTReqJSON {
	
    public Header Header {get;set;} 
	public DataArea DataArea {get;set;} 
    
    public class Sender {
		public String MessageID {get;set;} 
		public String SenderID {get;set;} 
		public String ServiceName {get;set;} 
	}
	
	public class Target {
		public String TargetID {get;set;} 
	}
	
	public class DataArea {
		public List<Case_Z> Case_Z {get;set;} // in json: Case
		public String SRTType {get;set;} 
		public String SolutionType {get;set;} 
		public String CSSJobID {get;set;} 
		public String ClaimID {get;set;} 
		public String ServiceModelName {get;set;} 
		public String LanguageID {get;set;} 
		public String TimeStamp {get;set;} 
	}
	
	public class Header {
		public Sender Sender {get;set;} 
		public Target Target {get;set;} 
	}
	

	public class Case_Z {
		public String CaseNumber {get;set;} 
		public String VerifyRepeatValue {get;set;} 
		public String SRTEventPerfDateTime {get;set;} 
	}
	
    public static CSS_WPR_SRT_DiagnosticSRTReqJSON parse(String json) {
          return (CSS_WPR_SRT_DiagnosticSRTReqJSON) System.JSON.deserialize(json, CSS_WPR_SRT_DiagnosticSRTReqJSON.class);
    }
	
}