//
// v1.0    Bharat Reddy        10/10/2018
//
public class CG_ANVL_ResWrapper {
	public String id;	//12
	public String timestamp;	//2018-05-10T10:25:22.210Z
	public String anvlId;	//deef-feed-feeb-1234
	public String updatedAt;	//2018-06-24T09:15:21.100Z
    
    public static CG_ANVL_ResWrapper parse(String json) {
        return (CG_ANVL_ResWrapper) System.JSON.deserialize(json, CG_ANVL_ResWrapper.class);
    }
}