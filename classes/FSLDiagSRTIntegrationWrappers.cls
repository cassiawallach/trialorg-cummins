public class FSLDiagSRTIntegrationWrappers {
    
    public RequestHeader Header;
    public DataArea DataArea;
    //public SRTLookupDataArea DataArea;
    public Class RequestHeader {
        
        public Sender Sender;
        public Target Target;
        public RequestHeader() {
            
            Sender = new Sender();
            Target = new Target();
        }
    }
    
    public Class Sender {
        
        public String MessageID;
        public String SenderID;
        public String ServiceName;
        public Sender() {
            
            ServiceName = '';
            SenderID = '';
            MessageID = '';
        }
    }
    
    public Class Target {
        
        public String TargetID;
        public Target() {
            
            TargetId = '';
        }
    }
    
    Public Class DataArea {
        
        public String LanguageID;
        public String EngineFamilyCode;
        public String ServiceModelName;
        public String EquipmentID;
        public String SRTType;
        public String SolutionType;
        public String TimeStamp;
        public string EffectiveDateTime;
        public String CSSJobID;
        public String ClaimID;
        public List<CaseList> XCase;
        public List<string> FailureID;
        //public List<JobAttributeList> JobAttribute;
        public DataArea() {
            
            LanguageID = '';
            EngineFamilyCode = '';
            ServiceModelName = '';
            EquipmentID = '';
            SRTType = '';
            SolutionType = '';
            TimeStamp = '';
            EffectiveDateTime = '';
            ClaimID = '';
            XCase = new List<CaseList>();
            FailureID = new list<string>();
            //JobAttribute=new List<JobAttributeList>();
        }
    }
    
    public Class CaseList {
        
        public String CaseNumber;
        public String VerifyRepeatValue;
        public String SRTEventPerfDateTime;
    }
    
    public Class JobAttributeList {
        
        public String Key;
        public String Value;
        public JobAttributeList() {
            
            Key = '';
            Value = '';
        }
    }
    
    public Class DiagnosticSRTResp {
        
        public RespDataArea DataArea;
    }
    
    public Class RespDataArea {
        
        public List<DiagSRTDataArea> CaseResponse = new List<DiagSRTDataArea>();
    }
    
    public Class DiagSRTDataArea {
        
        public string Assignment 	= '';
        public string SRTAccessCode = '';
        public string SRTID 		= '';
        public string CaseNumber 	= '';
        public string FlexSRT 		= '';
        public String SRTTitle 		= '';
        public VerifyRepeatValue VerifyRepeatValue = new VerifyRepeatValue();
        /* public String AccessCodeB;
        public String AccessCodeC;
        public String AccessCodeR;
        public String AccessCodeA;
        public String AccessCodeD;
        Public Integer SRTQuantity;
        Public Decimal SRTTime; */ // Changed as per the SRT webservice response - 09/16 Vinod Yellala
    }
    
    public Class VerifyRepeatValue {
        
        public String SRTEventPerfDateTime = '';
        public String SRTType = '';
        public Step Step = new Step();
    }
    
    public Class Step {
        
        public String StepID = '';
        public List<String> StepDescription;
        public String SRTStatusMessage = '';
        public String Percentage = '';
        public SRTTime SRTTime = new SRTTime();
    }
    
    public Class SRTTime {
        
        public String AccessCodeD = '';
        public String AccessCodeC = '';
        public String SpecialAccessCode = '';
        public String AccessCodeB = '';
        public String AccessCodeR = '';
        public List<String> SpecialAccessCodeDescription = new List<String>();
        public String AccessCodeA = '';
    }
}