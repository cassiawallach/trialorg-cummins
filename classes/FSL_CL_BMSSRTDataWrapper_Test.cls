@IsTest
public class FSL_CL_BMSSRTDataWrapper_Test {
    
    static testMethod void testParse() {
        String json = '{'+
            '   \"Header\":{'+
            '      \"Sender\":{'+
            '         \"ServiceName\":\"SRTData\",'+
            '         \"SenderID\":\"GuidanzWeb\"'+
            '      },'+
            '      \"Target\":{'+
            '         \"TargetID\":\"BMS\"'+
            '      },'+
            '      \"Location\":{'+
            '         \"LocationID\":\"01234-01234\"'+
            '      }'+
            '   },'+
            '   \"DataArea\":{'+
            '      \"GuidanzJobID\":\"00001234\",'+
            '      \"ShopWONumber\":\"893242\",'+
            '      \"Make\":\"BMW\",'+
            '      \"Model\":\"X3\",'+
            '      \"EngineFamilyCode\":\"10\",'+
            '      \"SRTs\":['+
            '			{'+
            '         		\"AccessCode\":\"B\",'+
            '         		\"SRTgroupnum\":\"2\",'+
            '         		\"Procedureno\":\"21\",'+
            '         		\"Stepnumber\":\"239\",'+
            '         		\"SRTTime\":\"0.3\",'+
            '         		\"ActualSRTTime\":\"0.4\",'+
            '         		\"SRTquantity\":\"2\"'+
            '      		},'+
            '			{'+
            '         		\"AccessCode\":\"A\",'+
            '         		\"SRTgroupnum\":\"3\",'+
            '         		\"Procedureno\":\"23\",'+
            '         		\"Stepnumber\":\"279\",'+
            '         		\"SRTTime\":\"0.4\",'+
            '         		\"ActualSRTTime\":\"0.5\",'+
            '         		\"SRTquantity\":\"1\"'+
            '      		}'+
            '      ]'+
            '   }'+
            '}';
        FSL_CL_BMSSRTDataWrapper obj = FSL_CL_BMSSRTDataWrapper.parse(json);
        System.assert(obj != null);
    }
}