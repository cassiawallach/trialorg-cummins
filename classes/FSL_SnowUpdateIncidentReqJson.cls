/*
 * Block comments with details of changes
 */
public class FSL_SnowUpdateIncidentReqJson
{
    public String comments;
    public String work_notes;
    public String impact;
    public String urgency;
    public String category;
    public String subcategory;
    public String short_description;
    public String description;
    
    public static FSL_SnowUpdateIncidentReqJson parse(String json) {
        return (FSL_SnowUpdateIncidentReqJson) System.JSON.deserialize(json, FSL_SnowUpdateIncidentReqJson.class);
    }
    
    //this comments use for Deployment Purpose Set missing comp  
}