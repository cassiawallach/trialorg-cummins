public class FSL_SymptomFCSearch_Request_Wrap {

	public String ToolId;
	public Boolean Contentflag;
	public String JobNumber;
	public String UserID;
	public String WorkgroupID;
	public String Usertype;
	public String Userrole;
	public String PGAGroup;
	public String Customername;
	public String Unitnumber;
	public String ShopWONumber;
	public String ESN;
	public String SMN;
	public String Domain;
	public String ApplicationCode;
	public String Applicationdescription;
	public String Marketingconfigurationcode;
	public String Generatornumber;
	public String Alternatornumber;
	public String Controllername;
	public String PSBUPlant;
	public String PSBUModel;
	public String PSBUSpec;
	public String ECMCode;
	public String Make;
	public String Model;
	public String Faulttype;
	public List<FaultCodelist> FaultCodelist;
	public String Highlevelsymptom;
	public String Lowlevelsymptom;
	public String Complaintcode;
	public Boolean Offlineflag;
	public Boolean Repeatvisitflag;
	public Boolean Reconflag;
	public String EngineMileage;
	public String Mileageunit;
	public String Enginehours;
	public String VIN;
	public String Languagekey;
	public String ABRTransactionID;

	public class FaultCodelist {
		public String CumminsFaultCode;
		public String SPN;
		public String FMI;
		public String PCode;
	}
	
	public static FSL_SymptomFCSearch_Request_Wrap parse(String json) {
		return (FSL_SymptomFCSearch_Request_Wrap) System.JSON.deserialize(json, FSL_SymptomFCSearch_Request_Wrap.class);
	}
}