public class CSS_J2AQues_EDS {
    public List<faultCode> faultCode;
    public search search;
    public class faultCode {
        public state state;
        public views views;
    }
    class dialogParamater {
        public String freeTextSearch;   //engine aint starting
    }
    public class search {
        public state state;
        public views views;
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
     public cls_guidanzQuery guidanzQuery;//Added by Roopa 01/17/2018

    public class State {
        public String name;
        public String transition;
        public dialogParamater dialogParamater;
    }
     public class cls_guidanzQuery {
      public cls_attributeValues[] attributeValues;
     } //Added by Roopa 01/17/2018
    
    public class cls_attributeValues {     //Added by Roopa 01/17/2018
        public String attributeCaption;
        public String valueID;
        public String valueName;
        public String attributeID;
        public String classCaption;
    }

    public class Selection {
        public List<Slots> slots;
    }

    public class Dialog {
         public boolean searchCompleted;
        public String freeTextSearch;
        public string dialogState;
        public string state;
       public question question;
    }

    public class Values {
        public String caption;
        public String id;
        public String name;
        public Integer score;
        public Boolean selected;
        public List<Properties> properties;
    }
    /*class properties {
        public String name; //EXTERNAL-LINK
        public String value;    //qsol?doctype=fc&docid=No Fault Codes&pgroup=EBU
    }*/
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
    
    public class ErrorMessage {
        public String key;
        public String message;
    }
    public class Result {
        public ErrorMessage errorMessage;
        public List<Cases> cases;
        public String hideSolutions;
        public Pagination pagination;
        public String state;
        public Boolean searchCompleted;
    }

    public class Values_Z {
        public String caption;
        public String name;
        public String id;
        public List<Properties> properties;
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
    public class question {
        public String caption;  //Engine Starting Symptom
        public String id;   //4#8838
        public String question; //Please clarify Engine Starting Symptom. By "aint starting" do you mean:
        public Integer cardinality; //2
        public boolean isShowMoreValue;
        public values[] values;
        public boolean zeroScores;
    }
    
    public static CSS_J2AQues_EDS parse(String json) {
        return (CSS_J2AQues_EDS) System.JSON.deserialize(json, CSS_J2AQues_EDS.class);
    }
}