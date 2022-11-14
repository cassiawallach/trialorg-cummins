public class CSS_WPR_TG_IASMDCResJSON {

    public Header Header;
    
	public class Header {
		public String Status;
		public String ReturnCode;
		public String ReturnCodeDescription;
	}
	
	public static CSS_WPR_TG_IASMDCResJSON parse(String json) {
		return (CSS_WPR_TG_IASMDCResJSON) System.JSON.deserialize(json, CSS_WPR_TG_IASMDCResJSON.class);
	}
}