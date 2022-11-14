public class CSS_J2AFCSearch_EDS {

    public faultCode[] faultCode;
    public search search;
    public class faultCode {
        public cls_guidanzQuery guidanzQuery; // Modified by roopa on 01/17/2018
        public state state;
        public views views;
    }
    public class cls_guidanzQuery { // Modified by roopa on 01/17/2018
    public cls_attributeValues[] attributeValues;
  }
    class cls_attributeValues { // Modified by roopa on 01/17/2018
    public String attributeCaption;  //Service Model Name
    public String valueID;  //175970#60062
    public String valueName;  //ISB6.7 CM2350 B101
    public String attributeID;  //10#43353
    public String classCaption;  //Engine
  }
    public class search {
        public state state;
        public views views;
    }
    public class headerView {
        public sections[] sections;
        public String viewName; //_TEK_RHEADER
        public String viewCaption;  //Results List Header
    }
    public class Slots {
        public List<String> valueId;
        public String id;
    }

    public class Pagination {
        public Integer numberOfPages;
        public Integer totalNumberOfRecord;
        public Integer currentPage;
        public Integer numberPerPage;
    }

    public class Guide {
        public List<Questions> questions;
        public String state;
        public Boolean searchCompleted;
    }

    public class Views {
        public Result result;
        public Guide guide;
        public Dialog dialog;
    }

    public State state;
    public Selection selection;
    public Views views;
    public String dsid;

    public class State {
        public String transition;
        public String name; //dialog
        public dialogParamater dialogParamater;
    }

    class dialogParamater {
        public String freeTextSearch;
    }
    public class Selection {
        public List<Slots> slots;
    }

    public class Dialog {
          public boolean searchCompleted;
        public String freeTextSearch;
        public string dialogState;
        public string state;
    }

    public class Values {
        public String caption;
        public String id;
        public String name;
        public Integer score;
        public Boolean selected;
        public List<Properties> properties;
    }

    public class Questions {
        public String caption;
        public String id;
        public String question;
        public Integer cardinality;
        public Boolean isShowMoreValue;
        public List<Properties> properties;
        public List<Values> values;
        public Boolean empty;
        public Boolean showValuesScore;
        public Boolean zeroScores;
    }

    public class Result {
        public List<Cases> cases;
        public String hideSolutions;
        public Pagination pagination;
        public String state;
        public Boolean searchCompleted;
    }

    public class Values_Z {
        public String caption;
        public String name;
    }

    public class Attributes {
        public String caption;
        public String templateName;
        public String baseType;
        public String id;
        public List<Values> values;
    }

    public class Properties {
        public String name;
        public String value;
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

    
    public static CSS_J2AFCSearch_EDS parse(String json) {
        return (CSS_J2AFCSearch_EDS) System.JSON.deserialize(json, CSS_J2AFCSearch_EDS.class);
    }
}