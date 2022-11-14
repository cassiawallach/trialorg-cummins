/**********************************************************************
Name:FSL_CL_SolutionContent
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
------- This is the wrapper class for handling solution
content and related components
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   SRIPRADA SESHAM    4/15/2019       INITIAL DEVELOPMENT                     
***********************************************************************/
public class FSL_CL_SCWrapper
{
    public string TransactionId = '';
    public string ToolID = '';
    public string JobNumber = '';
    public string WorkgroupID = '';
    public string UserID = '';
    public string LowLevelSymptom = '';
    public string SolutionCount = '';
    public list<Solutionitems> Solutions ;
    public FSL_CL_SCWrapper()
    {
        Solutions = new list<Solutionitems>();
    }
      
    public class Solutionitems
    {
        public string SolutionId = '';
        public string SolutionTitle = '';
        public string SolutionPosition = '';
        public string SolutionPriority = '';       
        public Verification Verification;
		public Repair Repair;
		public Validation Validation;
       	public string LinkedSolutionCount = '';
       // public string Validation = '';
        public string PoleFlag = '';
        public string RedirectionFlag = '';
        public string Setp1FaultCodeCheck = '';
        public string OEMServiceManual = '';
        public string ATR = '';
        public String LanguageKey = '';
        public list<ComponentItems> Components;
        public Solutionitems()
        {
            Components = new list<ComponentItems>();
        }
    }
    
    public class ComponentItems
    {
        public string FailureId = '';
        public string ComponentName = '';
    }
    
    public class Verification 
    {
		public String SectionName;
		public List<Sections> Sections;
        public Verification () 
        {
            Sections = new List<Sections>();
        }
	}
    
    public class Repair 
    {
		public String SectionName;
		public List<Sections> Sections;
        public Repair() 
        {
            Sections = new List<Sections>();
        }
	}
    
     public class Validation
     {
		public String SectionName;
		public List<Sections> Sections;
        public Validation() 
        {
            Sections = new List<Sections>();
        }
     }
    
    public class Sections 
    {
		public String SectionName;
		public List<SectionContent> SectionContent;
	}
    
    public class SectionContent
    {
		public String FormattingType = '';
		public String Text = '';
		public List<Links> Links;
        public SectionContent ()
        {
            Links = new list<Links>();
        }
	}
    public class Links 
    {
        public String LinkType = '';
		public String LinkText = '';
        public String LinkParam = '';
    }
    
     /* public class RepairSection {
		public String SectionName;
		public List<SectionContent> SectionContent;
	} 
    
    public class ValidationSection {
		public String SectionName;
		public List<SectionContent> SectionContent;
	
	}*/
}