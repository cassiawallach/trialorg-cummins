/**********************************************************************
Name:FSLSRTIntegrationWrappers
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
1.0 - Vinod Yelala      05/15/2018      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSLSRTIntegrationWrappers {
    public RequestHeader Header;
    public DataArea DataArea;
    //public SRTLookupDataArea DataArea;
    public Class RequestHeader
    {
        public Sender Sender;
        public Target Target;
        public RequestHeader()
        {
            Sender = new Sender();
            Target = new Target();
        }
    }
    public Class Sender 
    {
        //public String MessageID;
        public String SenderID;
        public String ServiceName;
        public Sender()
        {
            ServiceName='';
            SenderID='';
            //MessageID='';
        }
    }
    public Class Target
    {
        public String TargetID;
        public Target()
        {
            TargetId='';
        }
    }
    Public Class DataArea
    {
        public String Languagecode;
        public String EngineFamilyCode;
        public String ServiceModelName;
        public String EquipmentID;
        public String SRTType;
        public String SRTCategory;
        public String EffectiveDTTime;
        public String ModelFamily;
        //public List<JobAttributeList> JobAttribute;
        public DataArea()
        {
            Languagecode='';
            EngineFamilyCode='';
            ServiceModelName='';
            EquipmentID='';
            SRTType='';
            SRTCategory='';
            EffectiveDTTime='';
            ModelFamily='';
            //JobAttribute=new List<JobAttributeList>();
        }
        
    }
    public Class JobAttributeList
    {
        public String Key;
        public String Value;
        public JobAttributeList()
        {
            Key='';
            Value='';
        }
    }
    public Class SRTLookupDataAreaList
    {
        public List<SRTLookupDataArea> DataArea;
        
    }
    public Class SRTLookupDataArea{
        public string ComponentType;
        public string BTime;
        public string SRTNumber;
        public string CTime;
        public string PrivateFlag;
        public string Regions;
        public string SRTTitle;
        public string SRTCategory;
        public string StepID;
        public string RTime;
        public string ATime;
        public string SRTType;
        public string DTime;
        public string ECMFlag;
        public string FlexSRT;
		public Integer SRTQuantity;
        
    }
}