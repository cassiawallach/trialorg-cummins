public class CG_OP_GetWarrantyDocsRespWrapper {
    public String documentNum {get;set;} 
	public String documentDesc {get;set;} 
	public String type {get;set;} 
	public String language {get;set;} 
	public String status {get;set;} 
	public String documentLink {get;set;} 
    public static List<CG_OP_GetWarrantyDocsRespWrapper> ParseData(String json) {
        List<CG_OP_GetWarrantyDocsRespWrapper> res;
        if(json!=null)
        res = (List<CG_OP_GetWarrantyDocsRespWrapper>) System.JSON.deserialize(json, List<CG_OP_GetWarrantyDocsRespWrapper>.class);
        system.debug('QSOL Records----'+res);
		return res ;
	}
    
}