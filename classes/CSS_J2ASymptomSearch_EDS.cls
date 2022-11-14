public class CSS_J2ASymptomSearch_EDS{
    public faultCode[] faultCode;
    public search search;
    public String dsid;
    public String key;
  public String message;
  public List<String> messageArg;
    public class faultCode {
        public cls_guidanzQuery guidanzQuery;
        public state state;
        public views views;
    }
    public class cls_guidanzQuery {
    public cls_attributeValues[] attributeValues;
  }
    class cls_attributeValues {
    public String attributeCaption;  //Service Model Name
    public String valueID;  //175970#60062
    public String valueName;  //ISB6.7 CM2350 B101
    public String attributeID;  //10#43353
    public String classCaption;  //Engine
  }
      public class search {
        public cls_guidanzQuery guidanzQuery;  
        public state state;
        public views views;
    }
    public class state {
        public String name;  //dialog
        public dialogParamater dialogParamater;
        public String transition;
    }
    public class dialogParamater {
        public String freeTextSearch;  //white smoke
    }
    public class views {
        public result result;
        public guide guide;
        public dialog dialog;
    }
    public class result {
        public pagination pagination;
        public cases[] cases;
        public String state;  //results
        public boolean searchCompleted;
        public string hideSolutions;
        public ErrorMessage errorMessage;
    }
    public class pagination {
        public Integer numberOfPages;  //3
        public Integer numberPerPage;  //8
        public Integer currentPage;  //0
        public Integer totalNumberOfRecord;  //24
    }
    
    public class guide {
        public questions[] questions;
        public String state;  //guide
        public boolean searchCompleted;
    }
    public class questions {
        public String caption;  //Fault Codes
        public String id;  //10#1494
        public String question;  //Select the active fault code from the list below. If no fault codes are active, select 'No Fault Codes Present' and click the NEXT button.
        public Integer cardinality;  //1
        public boolean isShowMoreValue;
        public properties[] properties;
        public values[] values;
        public boolean empty;
        public boolean showValuesScore;
        public boolean zeroScores;
    }
    public class properties {
        public String name;  //EXTERNAL-LINK
        public String value;  //qsol?doctype=fc&docid=No Fault Codes&pgroup=EBU
    }
    public class values {
        public String caption;  //No Fault Codes
        public String id;  //1132#38782
        public String name;  //No Fault Codes
        public Integer score;  //19
        public properties[] properties;
        public boolean selected;
    }
    public class dialog {
        
        public boolean searchCompleted;
        public String freeTextSearch;
        public string dialogState;
        public string state;
        public question question;
    }
    public class cases {
        public Integer rank;  //0
        public String name;  //K04557444
        public boolean imageUseStyle;
         public string imageStyleName;
        public string image;
        public Integer caseId;  //27922
        public String title;  //Malfunctioning low pressure fuel system component
        public Integer similarity;  //95
        public String similarityImage;  ///images/64x16_star4.gif
        public caseViews[] caseViews;
        public Integer versionNumber;  //0
        public boolean selected;
        public headerView headerView;
        public boolean favorite;
    }
    public class caseViews {
        public sections[] sections;
        public String viewName;  //Results List Body
        public String viewCaption;  //Results List Body
    }
    public class sections {
        public String caption;  //Solution
        public String baseType;  //CLASS
        public String id;  //4#108
        public attributes[] attributes;
    }
    public class attributes {
        public String caption;  //Title
        public String templateName;  //case-title
        public String baseType;  //TEXT
        public String id;  //4#82
        public values[] values;
    }
    public class headerView {
        public sections[] sections;
        public String viewName;  //_TEK_RHEADER
        public String viewCaption;  //Results List Header
    }
    public class errorMessage {
        public String key;  //error.search.nosolutions
        public String message;  //error.search.nosolutions
    }
    public class question {
        public String caption;  //Exhaust Smoke Color
        public String id;  //4#8846
        public String question;  //Please clarify Exhaust Smoke Color. By "smoke" do you mean:
        public Integer cardinality;  //1
        public boolean isShowMoreValue;
        public List<Properties> properties;
        public List<Values> values;
        public Boolean empty;
        public Boolean showValuesScore;
        public Boolean zeroScores;
    }
    
    public class Selection {
        public List<Slots> slots;
    }
    public class Slots {
        public List<String> valueId;
        public String id;
    } 

  public State state;
  public Selection selection;
  public Views views;
    
    public static CSS_J2ASymptomSearch_EDS parse(String json){
        return (CSS_J2ASymptomSearch_EDS) System.JSON.deserialize(json, CSS_J2ASymptomSearch_EDS.class);
    }
}