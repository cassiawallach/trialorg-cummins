/*
 * Block comments with details of changes
 */
public class CG_PaidClaimsDetailsReqWrapper
{
    public Header Header;
	public DataArea DataArea;
	public class Header {
		public Sender Sender;
	}
	public class Sender {
		public String MessageID;	
		public String ServiceName;	
		public String SenderID;	
	}
	public class DataArea {
		public String IMSClaimNumber;	
		public String ClaimNumber;
	}
	public static CG_PaidClaimsDetailsReqWrapper parse(String json){
		return (CG_PaidClaimsDetailsReqWrapper) System.JSON.deserialize(json, CG_PaidClaimsDetailsReqWrapper.class);
	}
}