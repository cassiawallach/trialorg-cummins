public class dbu_VertexquoteResponseWrapper {
    /*
    	public DataArea DataArea {get;set;} 
		public Header Header {get;set;} 
    
	public class ProductList {
		public String LineItemNumber {get;set;} 
		public List<Taxes> Taxes {get;set;} 
		public String ProductClassCode {get;set;} 
		public String Product {get;set;} 
		public String LineItemTotalTax {get;set;} 		
	}	
	/*public class Vertexrespose {
		public DataArea DataArea {get;set;} 
		public Header Header {get;set;} 		
	}*/	
    /*
	public class DataArea {
		public List<ProductList> ProductList {get;set;} 
		public String TotalTax {get;set;} 		
	}	
	public class Taxes {
		public String TaxRuleId {get;set;} 
		public String ImpositionValue {get;set;} 
		public String CalculatedTax {get;set;} 
		public String JurisdictionValue {get;set;} 
		public String JurisdictionLevel {get;set;} 
		public String taxStructure {get;set;} 
		public String TaxResult {get;set;} 
		public String JurisdictionId {get;set;} 
		public String NonTaxable {get;set;} 
		public String TaxType {get;set;} 
		public String ImpositionId {get;set;} 
		public String TaxCollectedFromParty {get;set;} 
		public String ImpositionTypeValue {get;set;} 
		public String ImpositionTypeId {get;set;} 
		public String EffectiveRate {get;set;} 
		public String Situs {get;set;} 
		public String Taxable {get;set;} 		
	}	
	public class Header {
		public Transaction_Z Transaction_Z {get;set;} // in json: Transaction		
	}
	public class Transaction_Z {
		public String QuotationResponseDocumentNumber {get;set;} 
		public String TransactionID {get;set;} 	
	}
    */
    
    public class ProductList {
		public String LineItemNumber {get;set;} 
		public String ProductClassCode {get;set;} 
		public String ProductCode {get;set;} 
		public String LineItemTotalTax {get;set;} 
		public List<Taxes> Taxes {get;set;}
		public ProductList(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'LineItemNumber') {
							LineItemNumber = parser.getText();
						} else if (text == 'ProductClassCode') {
							ProductClassCode = parser.getText();
						} else if (text == 'ProductCode') {
							ProductCode = parser.getText();
						} else if (text == 'LineItemTotalTax') {
							LineItemTotalTax = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ProductList consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class DataArea {
		public List<ProductList> ProductList {get;set;} 
		public String TotalTax {get;set;} 

		public DataArea(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'ProductList') {
							ProductList = arrayOfProductList(parser);
						} else if (text == 'TotalTax') {
							TotalTax = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'DataArea consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public DataArea DataArea {get;set;} 
	public Header Header {get;set;} 

    public dbu_VertexquoteResponseWrapper()
    {}
	public dbu_VertexquoteResponseWrapper(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'DataArea') {
						DataArea = new DataArea(parser);
					} else if (text == 'Header') {
						Header = new Header(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Header {
		public Transaction_Z Transaction_Z {get;set;} // in json: Transaction

		public Header(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'Transaction') {
							Transaction_Z = new Transaction_Z(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Header consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Transaction_Z {
		public String InvoiceResponseDocumentNumber {get;set;} 
		public String TransactionID {get;set;} 

		public Transaction_Z(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'InvoiceResponseDocumentNumber') {
							InvoiceResponseDocumentNumber = parser.getText();
						} else if (text == 'TransactionID') {
							TransactionID = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'Transaction_Z consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static dbu_VertexquoteResponseWrapper parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new dbu_VertexquoteResponseWrapper(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	




    private static List<ProductList> arrayOfProductList(System.JSONParser p) {
        List<ProductList> res = new List<ProductList>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new ProductList(p));
        }
        return res;
    }

	public class Taxes {
		public String TaxRuleId {get;set;} 
		public String ImpositionValue {get;set;} 
		public String CalculatedTax {get;set;} 
		public String JurisdictionValue {get;set;} 
		public String JurisdictionLevel {get;set;} 
		public String taxStructure {get;set;} 
		public String TaxResult {get;set;} 
		public String JurisdictionId {get;set;} 
		public String NonTaxable {get;set;} 
		public String TaxType {get;set;} 
		public String ImpositionId {get;set;} 
		public String TaxCollectedFromParty {get;set;} 
		public String ImpositionTypeValue {get;set;} 
		public String ImpositionTypeId {get;set;} 
		public String EffectiveRate {get;set;} 
		public String Situs {get;set;} 
		public String Taxable {get;set;} 		
	}	

}