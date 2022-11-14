public class CSS_J2ADSIDDetails_EDS {
    public String key;
	public String message;
	public List<String> messageArg;
    
    public class Details {
        public String name;
        public String caption;
        public String value;
        public Boolean editable;
    }
    
    public class Actions_Y {
        public String caption;
        public Integer id;
        public String detail;
    }
    
    public Details_Z details;
    public List<Attachments> attachments;
    public List<AuditTrial> auditTrial;
    
    public class Actions {
        public String name;
        public String caption;
        public String status;
        public Boolean editable;
        public Integer id;
        public String detail;
    }
    
    public class Times {
        public String solo;
        public Integer id;
        public String time_x;
        public List<Actions> actions;
    }
    
    public class Details_Z {
        public String id;
        public String status;
        public String name;
        public String title;
        public List<Details> details;
        public List<Actions> actions;
        public Boolean canEdit;
        public Boolean canDownload;
    }
    
    public class Actions_Z {
        public String caption;
        public Integer id;
    }
    
    public class AuditTrial {
        public String date_x;
        public List<Times> times;
        public String solo;
        public Integer id;
        public String user;
    }
    
    public class Attachments {
        public String user;
        public String comment;
        public String time_x;
        public String link;
        public String fileName;
    }
    
    
    public static CSS_J2ADSIDDetails_EDS parse(String json) {
        return (CSS_J2ADSIDDetails_EDS) System.JSON.deserialize(json, CSS_J2ADSIDDetails_EDS.class);
    }
}