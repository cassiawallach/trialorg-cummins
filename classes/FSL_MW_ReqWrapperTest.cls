/*
* CT3-237: Test class for class FSL_MW_ReqWrapper
* @Author: Dinesh Yadav, Created Date: 9 Dec 2020.
*/ 

@IsTest
public class FSL_MW_ReqWrapperTest {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\":{'+
        '      \"Sender\":{'+
        '         \"ServiceName\":\"ECMimages\",'+
        '         \"SenderID\":\"GuidanzWeb\"'+
        '      },'+
        '      \"Target\":{'+
        '         \"TargetID\":\"AzureFiles\"'+
        '      }'+
        '   },'+
        '   \"DataArea\":{'+
        '      \"Images\":['+
        '         \"I-20190421-111230469-EA2C1D72.eif\",'+
        '         \"I-20191002-111230700-EB2C1D01.csv\",'+
        '         \"I-20190421-111230101-EB2C1D72.eif\",'+
        '         \"I-20190421-111230101-EB2C1D72.csv\"'+
        '      ]'+
        '   }'+
        '}';
        FSL_MW_ReqWrapper obj = FSL_MW_ReqWrapper.parse(json);
        System.assert(obj != null);
    }
}