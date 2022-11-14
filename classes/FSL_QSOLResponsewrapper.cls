public class FSL_QSOLResponsewrapper{
    /*
    public String documentNum;  //T1609
    public String documentDesc; //ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST
    public String type; //TRP
    public String language; //en
    public String status;   //OPEN
    public String documentLink; //https://qs-stg.cummins.com/authenticate?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJRU09MX0lOVEVHUkFUSU9OX0FDQ0VTU19UT0tFTiIsImlzSU5UU0VSVklDRSI6InRydWUiLCJpc3MiOiJJbnRlcm5hbCBJbnRlZ3JhdGlvbiBTZXJ2aWNlcyAtIFFTT0wiLCJmbGVldGNvZGUiOiJUOTk5OTk5IiwiZXhwIjoxNTYzMjUyMzg0LCJpYXQiOjE1NjMyMDkxODQsImdyb3VwbmFtZSI6WyJJTlRFR1JBVElPTl9RVUlDS1NFUlZFIl0sInVzZXJuYW1lIjoidGVjX3VzZXIiLCJ0YXJnZXQiOiJodHRwczovL3FzLXN0Zy5jdW1taW5zLmNvbSJ9.STkwaooR30V0dP3H59MpiitwLshB-qjUdv0Fbczk3IwVW3jzM45CxnWveObozn4JA9WiQ830gZ3hH6YcCRDQwQnjR_wpgAQ_H9soc-SpF1RPxXReVXcFOPvxFeROyarVe-c_FJZU3n7lktqgL4BL0awC_TUqP7bBQFmd1Tnaqac&target=/integrations/pubsys2/xml/en/trp/2016/t1609.html
    
    //-----CT3-114 ----
    //Modified By: Dinesh Yadav, 24 Sept 2020 For Group Name, Group Number, Fault Codes & Symtoms in TSB
    public String groupNum; 
    public String groupName; 
    public String faultCodes; 
    public String symptoms; 
    //---------End ---------
    public static FSL_QSOLResponsewrapper parse(String json){
        return (FSL_QSOLResponsewrapper) System.JSON.deserialize(json, FSL_QSOLResponsewrapper.class);
    }
    */
/*
    static testMethod void testParse() {
        String json=        '{'+
        '        "documentNum": "T1609",'+
        '        "documentDesc": "ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST",'+
        '        "type": "TRP",'+
        '        "language": "en",'+
        '        "status": "OPEN",'+
        '        "documentLink": "https://qs-stg.cummins.com/authenticate?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJRU09MX0lOVEVHUkFUSU9OX0FDQ0VTU19UT0tFTiIsImlzSU5UU0VSVklDRSI6InRydWUiLCJpc3MiOiJJbnRlcm5hbCBJbnRlZ3JhdGlvbiBTZXJ2aWNlcyAtIFFTT0wiLCJmbGVldGNvZGUiOiJUOTk5OTk5IiwiZXhwIjoxNTYzMjUyMzg0LCJpYXQiOjE1NjMyMDkxODQsImdyb3VwbmFtZSI6WyJJTlRFR1JBVElPTl9RVUlDS1NFUlZFIl0sInVzZXJuYW1lIjoidGVjX3VzZXIiLCJ0YXJnZXQiOiJodHRwczovL3FzLXN0Zy5jdW1taW5zLmNvbSJ9.STkwaooR30V0dP3H59MpiitwLshB-qjUdv0Fbczk3IwVW3jzM45CxnWveObozn4JA9WiQ830gZ3hH6YcCRDQwQnjR_wpgAQ_H9soc-SpF1RPxXReVXcFOPvxFeROyarVe-c_FJZU3n7lktqgL4BL0awC_TUqP7bBQFmd1Tnaqac&target=/integrations/pubsys2/xml/en/trp/2016/t1609.html"'+
        '    }';
        FSL_QSOLResponsewrapper obj = parse(json);
        System.assert(obj != null);
    } */
    
    
    public String documentNum {get;set;} 
    public String documentDesc {get;set;} 
    public String type {get;set;} // in json: type
    public String language {get;set;} 
    public String groupNum {get;set;} 
    public String groupName {get;set;} 
    public List<String> faultCodes {get;set;} 
    public List<String> symptoms {get;set;} 
    public String documentLink {get;set;} 

    public FSL_QSOLResponsewrapper(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'documentNum') {
                        documentNum = parser.getText();
                    } else if (text == 'documentDesc') {
                        documentDesc = parser.getText();
                    } else if (text == 'type') {
                        type = parser.getText();
                    } else if (text == 'language') {
                        language = parser.getText();
                    } else if (text == 'groupNum') {
                        groupNum = parser.getText();
                    } else if (text == 'groupName') {
                        groupName = parser.getText();
                    } else if (text == 'faultCodes') {
                        faultCodes = arrayOfString(parser);
                    } else if (text == 'symptoms') {
                        symptoms = arrayOfString(parser);
                    } else if (text == 'documentLink') {
                        documentLink = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        //consumeObject(parser);
                    }
                }
            }
        }
    }
    
    
    public static FSL_QSOLResponsewrapper parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new FSL_QSOLResponsewrapper(parser);
    }

    private static List<String> arrayOfString(System.JSONParser p) {
        List<String> res = new List<String>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(p.getText());
        }
        return res;
    }

}