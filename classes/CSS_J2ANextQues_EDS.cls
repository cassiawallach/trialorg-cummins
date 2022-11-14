public class CSS_J2ANextQues_EDS {


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
        public Boolean searchCompleted;
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
    /*public class Guide {
        public List<Questions> questions;
        public String state;
        public Boolean searchCompleted;
    }*/

    /*public class Views {
        public Result result;
        public Guide guide;
        public Dialog dialog;
    }*/

    //public Selection selection;
    //public Views views;
    //public String dsid;

    /*public class Selection {
        public List<Slots> slots;
    }*/

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

    /*public class Result {
        public List<Cases> cases;
        public Pagination pagination;
        public String state;
        public Boolean searchCompleted;
    }*/

    /*public class Values {
        public String caption;
        public String id;
        public String name;
        public List<Properties> properties;
    }*/

    public class CaseViews {
        public List<Sections> sections;
        public String viewName;
        public String viewCaption;
    }

    /*public class Slots {
        public Object valueId;
        public String id;
    }*/

    /*public class Pagination {
        public Integer numberOfPages;
        public Integer totalNumberOfRecord;
        public Integer currentPage;
        public Integer numberPerPage;
    }*/

    public class Sections {
        public String caption;
        public String baseType;
        public String id;
        public List<Attributes> attributes;
    }

    /*public class Dialog {
        public Boolean searchCompleted;
    }*/


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

    
    public static CSS_J2ANextQues_EDS parse(String json) {
        return (CSS_J2ANextQues_EDS) System.JSON.deserialize(json, CSS_J2ANextQues_EDS.class);
    }
}