public class CSS_J2AFaultCodeSearch_EDS {
    
    public List<faultCode> faultCode;
    public search search;
    class faultCode {
       public cls_guidanzQuery guidanzQuery; // Modified by roopa on 01/17/2018
        public state state;
        public views views;
    }
     public class cls_guidanzQuery {
    public cls_attributeValues[] attributeValues;
  }// Modified by roopa on 01/17/2018
  class cls_attributeValues {
    public String attributeCaption;  //Service Model Name
    public String valueID;  //175970#60062
    public String valueName;  //ISB6.7 CM2350 B101
    public String attributeID;  //10#43353
    public String classCaption;  //Engine
  } // Modified by roopa on 01/17/2018
    public class state {
        public String name; //dialog
        public dialogParamater dialogParamater;
    }
    public class dialogParamater {
        public String freeTextSearch;
    }
    public class views {
        public result result;
        public dialog dialog;
        public guide guide;
    }
    public class result {
        public List<Cases> cases;
        public pagination pagination;
        public String hideSolutions;    //label.hide-solutions
        public String state;    //results
        public boolean searchCompleted;
        public ErrorMessage errorMessage;
    }
    public class errorMessage {
        public String key;  //error.search.nosolutions
        public String message;  //error.search.nosolutions
    }
    public class dialog {
        public boolean searchCompleted;
        public String freeTextSearch;
        public string dialogState;
        public string state;
    }
    public class guide {
        public questions[] questions;
        public String state;    //guide
        public boolean searchCompleted;
    }
   public class search {
        public state state;
        public views views;
    }
    public class pagination {
        public Integer numberOfPages;   //7
        public Integer totalNumberOfRecord; //50
        public Integer numberPerPage;   //8
        public Integer currentPage; //0
    }
    public class questions {
        public String caption;  //Fault Codes
        public String id;   //10#1494
        public String question; //Select the active fault code from the list below. If no fault codes are active, select 'No Fault Codes Present' and click the NEXT button.
        public Integer cardinality; //1
        public boolean isShowMoreValue;
        public properties[] properties;
        public values[] values;
        public boolean empty;
        public boolean showValuesScore;
        public boolean zeroScores;
    }
    public class properties {
        public String name; //EXTERNAL-LINK
        public String value;    //qsol?doctype=fc&docid=No Fault Codes&pgroup=EBU
    }
   
    public class Cases {
        public Integer rank;
        public String name;
        public string image;
        public string imageStyleName;
        public Boolean imageUseStyle;
        public Integer caseId;
        public String title;
        public Integer similarity;
        public String similarityImage;
        public List<CaseViews> caseViews;
        public Integer versionNumber;
        public Boolean selected;
        public CaseViews headerView;
        public Boolean favorite;
    }
    public class CaseViews {
        public List<Sections> sections;
        public String viewName;
        public String viewCaption;
    }
    
    public class Sections {
        public String caption;
        public String baseType;
        public String id;
        public List<Attributes> attributes;
    }
    public class Attributes {
        public String caption;
        public String templateName;
        public String baseType;
        public String id;
        public List<Values> values;
    }
    public class Values {
        public String caption;
        public String id;
        public String name;
        public Integer score;
        public Boolean selected;
        public List<Properties> properties;
    }
   
    
    public static CSS_J2AFaultCodeSearch_EDS parse(String json){
        return (CSS_J2AFaultCodeSearch_EDS) System.JSON.deserialize(json, CSS_J2AFaultCodeSearch_EDS.class);
    }
}