public class CSS_J2AProblem_EDS {
	public String status;

	
	public static CSS_J2AProblem_EDS parse(String json) {
		return (CSS_J2AProblem_EDS) System.JSON.deserialize(json, CSS_J2AProblem_EDS.class);
	}
}