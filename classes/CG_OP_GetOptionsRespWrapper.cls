public class CG_OP_GetOptionsRespWrapper {
    public String repairGroup;
	public String optionNumber;
	public String optionDescription;
    public static List<CG_OP_GetOptionsRespWrapper> parsedata(String response) {
        if(response==null)return null;
        else return (List<CG_OP_GetOptionsRespWrapper>) System.JSON.deserialize(response, List<CG_OP_GetOptionsRespWrapper>.class);
	}
}