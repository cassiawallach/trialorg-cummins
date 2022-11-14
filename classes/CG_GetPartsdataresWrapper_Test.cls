@IsTest
public class CG_GetPartsdataresWrapper_Test {
     static testMethod void testParse() {
         
         String json=		'{'+
		'	"DataArea": {'+
		      ' " SupersededPartNumber": "1-127827968",'+
              '  " PartNumberLong": "1-127827968",'+
               '  " PartDescription": "1-127827968",'+
                 ' " PartInService": "1-127827968",'+
                   ' " KitPartFlag": "1-127827968"'+
     '	},'+
		   '	"Header": {'+
		       '	 "MessageIdentifier": "",'+
               '	 "ReturnCode": "",'+
               '	 "ReturnCodeDescription": "",'+
               '	 "MessageType": "",'+
		       '	 "Status": "Success"'+
		'	}	'+
		'}';
   
         CG_GetPartsdataresWrapper obj = CG_GetPartsdataresWrapper.parse(json);
         
         CG_GetPartsdataresWrapper controller = CG_GetPartsdataresWrapper.parse(json);
         CG_GetPartsdataresWrapper.Header header = new CG_GetPartsdataresWrapper.Header();
         header.ReturnCodeDescription = '';
         header.Status = 'Success';
         header.MessageIdentifier='Test MessageIdentifier';
         header.MessageType ='Test MessageType';
         header.ReturnCode ='Test ReturnCode';
         
         CG_GetPartsdataresWrapper.DataArea dArea = new CG_GetPartsdataresWrapper.DataArea();
         dArea.SupersededPartNumber ='Test SupersededPartNumber';
         dArea.PartNumberLong ='Test Part Number Long';
         dArea.PartDescription ='Test Part Description';
         dArea.PartInService ='Test PartInService';
         dArea.KitPartFlag='Test KitPartFlag';
            
         
		System.assert(obj != null);
     }

}