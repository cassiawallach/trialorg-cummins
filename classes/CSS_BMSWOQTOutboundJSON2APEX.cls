public class CSS_BMSWOQTOutboundJSON2APEX {

	public class DataArea {
		public String CSSjobID;
		public String Companycode;
		public String DivisionCode;
		public String LocationCode;
		public String CustomerNumber;
		public String TransactionType;
		public String OrderReference;
		public Integer ItemGrossSell;
		public Integer ItemWarranty;
		public Integer ItemBillable;
		public Integer LaborGrossSell;
		public Integer LaborWarranty;
		public Integer LaborBillable;
		public Integer MiscGrossSell;
		public Integer MiscWarranty;
		public Integer MiscBillable;
		public Integer Taxes;
		public Integer QuoteTotal;
		public Integer Diagnosticcharges;
		public Integer GrandTotal;
	}

	public class Header {
		public String Status;
		public String ReturnCodeDescription;
		public Location Location;
	}

	public Header Header;
	public DataArea DataArea;

	public class Location {
		public String LocationID;
	}

	
	public static CSS_BMSWOQTOutboundJSON2APEX parse(String json) {
		return (CSS_BMSWOQTOutboundJSON2APEX) System.JSON.deserialize(json, CSS_BMSWOQTOutboundJSON2APEX.class);
	}
}