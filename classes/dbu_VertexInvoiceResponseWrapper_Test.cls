@isTest
public class dbu_VertexInvoiceResponseWrapper_Test {

    static testMethod void testParse() {
		String json = '{'+
		'	\"Header\": {'+
		'		\"Transaction\": {'+
		'			\"Trusted_ID\": \"\",'+
		'			\"TransactionID\": \"\",'+
		'			\"Transaction_Type\": \"SALE\",'+
		'			\"InvoiceRequestDocumentNumber\": \"I-0000000241\",'+
		'			\"DocumentDate\": \"2018-07-13\"'+
		'		},'+
		'		\"Target\": {'+
		'			\"TargetID\": \"Vertex\"'+
		'		},'+
		'		\"Sender\": {'+
		'			\"ServiceName\": \"InvoiceRequest\",'+
		'			\"SenderID\": \"OSM\"'+
		'		}'+
		'	},'+
		'	\"DataArea\": {'+
		'		\"Seller\": {'+
		'			\"Physical_Origin\": {'+
		'				\"State\": \"IN\",'+
		'				\"Postal_Code\": \"47201-6258\",'+
		'				\"Country\": \"USA\",'+
		'				\"City\": \"Columbus\",'+
		'				\"AddressLine2\": \"\",'+
		'				\"AddressLine1\": \"500 Jackson St\"'+
		'			},'+
		'			\"Division_Code\": \"CMI\",'+
		'			\"Company_Code\": \"00\",'+
		'			\"AdministrativeOrigin\": {'+
		'				\"State\": \"IN\",'+
		'				\"Postal_Code\": \"47201-6258\",'+
		'				\"Country\": \"USA\",'+
		'				\"City\": \"Columbus\",'+
		'				\"AddressLine2\": \"\",'+
		'				\"AddressLine1\": \"500 Jackson St\"'+
		'			}'+
		'		},'+
		'		\"ProductList\": [{'+
		'			\"UnitOfMeasure\": \"\",'+
		'			\"RC\": \"207\",'+
		'			\"Quantity\": \"4\",'+
		'			\"ProductCode\": \"5678902-OHT\",'+
		'			\"ProductClassCode\": \"SW-Web Access\",'+
		'			\"LineItemNumber\": \"714\",'+
		'			\"ExtendedPrice\": \"470.40\",'+
		'			\"DiscountPercentage\": \"\",'+
		'			\"DiscountAmount\": \"\",'+
		'			\"CustomerName\": \"USA Truck Inc\",'+
		'			\"BC\": \"598\"'+
		'		}],'+
		'		\"DiscountPercent\": \"\",'+
		'		\"DiscountAmount\": \"\",'+
		'		\"Customer\": {'+
		'			\"Destination_Addesss\": {'+
		'				\"State\": \"IN\",'+
		'				\"Postal_Code\": \"47201\",'+
		'				\"Country\": \"United States\",'+
		'				\"City\": \"Indiana\",'+
		'				\"AddressLine2\": \"Ashbrook Dr\",'+
		'				\"AddressLine1\": \"3701\"'+
		'			},'+
		'			\"Customer_Code\": \"409280\",'+
		'			\"Administrive_Destination\": {'+
		'				\"Postal_Code\": \"47201\",'+
		'				\"Country\": \"United States\",'+
		'				\"City\": \"Indiana\",'+
		'				\"Administrative_Main_Division\": \"IN\",'+
		'				\"AddressLine2\": \"Ashbrook Dr\",'+
		'				\"AddressLine1\": \"3701\"'+
		'			}'+
		'		}'+
		'	}'+
		'}';
		dbu_VertexInvoiceResponseWrapper r = dbu_VertexInvoiceResponseWrapper.parse(json);
		System.assert(r != null);

		
	}
}