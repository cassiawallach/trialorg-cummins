public class CG_payCodeResJ2A {

	public String PAYCODEDESCRIPTION;
	public String PAYCODE;

	
	public static List<CG_payCodeResJ2A> parse(String json) {
		return (List<CG_payCodeResJ2A>) System.JSON.deserialize(json, List<CG_payCodeResJ2A>.class);
	}
}