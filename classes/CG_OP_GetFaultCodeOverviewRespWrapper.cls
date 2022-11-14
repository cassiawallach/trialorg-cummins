public class CG_OP_GetFaultCodeOverviewRespWrapper {

	public String faultCode;
	public String pid;
	public String spn;
	public String fmi;
	public String lamp;
	public String srt;
	public String description;
	public String compLocation;
	public String circuitDescription;
	public String reason;
	public String effect;
	public String sysName;
	public String url;
	public String engine;

	
	public static CG_OP_GetFaultCodeOverviewRespWrapper parse(String json) {
		return (CG_OP_GetFaultCodeOverviewRespWrapper) System.JSON.deserialize(json, CG_OP_GetFaultCodeOverviewRespWrapper.class);
	}
}