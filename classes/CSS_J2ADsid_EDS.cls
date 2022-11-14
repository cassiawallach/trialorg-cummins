public class CSS_J2ADsid_EDS {
	public String dsid;
	public String key;
	public String message;
	public List<String> messageArg;
	public static CSS_J2ADsid_EDS parse(String json) {
		return (CSS_J2ADsid_EDS) System.JSON.deserialize(json, CSS_J2ADsid_EDS.class);
	}
}