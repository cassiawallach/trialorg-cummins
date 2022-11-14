@IsTest
public class CSS_WPR_SRT_MakeModalEquipIdResJSON_Test {
	
	static testMethod void testParse() {
		String json = '{'+
		'    \"DataArea\": {'+
		'        \"EquipmentData\": ['+
		'            {'+
		'                \"ServiceModelDetails\": ['+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250 X115\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM871 E\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2250\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM871\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2350 X105\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM870\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2250 SN\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2350 X101\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM570\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"X15 CM2350 X114B\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"X15 CM2350 X116B\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM570\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250 ECF\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2350 X106\",'+
		'                        \"EF\": \"10\"'+
		'                    }'+
		'                ],'+
		'                \"Status\": \"ACTIVE\",'+
		'                \"ApplicationCategory\": \"A\",'+
		'                \"Model\": \"379\",'+
		'                \"EngineFamilyCode\": \"10\",'+
		'                \"Configuration\": \"Conventional\",'+
		'                \"EquipmentId\": \"EQ2610\",'+
		'                \"AccessCode\": \"B\",'+
		'                \"Make\": \"PETERBILT\"'+
		'            },'+
		'            {'+
		'                \"ServiceModelDetails\": ['+
		'                    {'+
		'                        \"SMN\": \"ISX CM871 E\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2250 SN\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250 X115\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2350 X105\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"X15 CM2350 X114B\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM570\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2350 X101\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM570\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM871\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250 ECF\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX15 CM2250\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2250\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"QSX15 CM2350 X106\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"ISX CM870\",'+
		'                        \"EF\": \"10\"'+
		'                    },'+
		'                    {'+
		'                        \"SMN\": \"X15 CM2350 X116B\",'+
		'                        \"EF\": \"10\"'+
		'                    }'+
		'                ],'+
		'                \"Status\": \"ACTIVE\",'+
		'                \"ApplicationCategory\": \"A\",'+
		'                \"Model\": \"HX 620\",'+
		'                \"EngineFamilyCode\": \"10\",'+
		'                \"Configuration\": \"Conventional\",'+
		'                \"EquipmentId\": \"EQ9205\",'+
		'                \"AccessCode\": \"B\",'+
		'                \"Make\": \"INTERNATIONAL\"'+
		'            }'+
		'        ]'+
		'    },'+
		'    \"Header\": {'+
		'        \"ReturnCodeDescription\": \"Normal, Successful completion.\",'+
		'        \"Status\": \"SUCCESS\"'+
		'    }'+
		'}';
        
		CSS_WPR_SRT_MakeModalEquipIdResJSON obj = CSS_WPR_SRT_MakeModalEquipIdResJSON.parse(json);
		System.assert(obj != null);
	}
}