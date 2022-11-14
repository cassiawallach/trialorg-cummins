public class CG_OP_LinkMgmtRespWrapper {
    public String qsolLink;
	public String language;
    public static CG_OP_LinkMgmtRespWrapper ParseData(String response) {
        if(response==null)return null;
        else return (CG_OP_LinkMgmtRespWrapper) System.JSON.deserialize(response, CG_OP_LinkMgmtRespWrapper.class);
	}
}