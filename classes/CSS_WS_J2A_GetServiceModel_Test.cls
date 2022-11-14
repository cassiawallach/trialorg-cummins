@IsTest
public class CSS_WS_J2A_GetServiceModel_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"OutputMessageCode\": \"ORA-00000\",'+
        '    \"OutputMessage\": \"Normal, Successful completion.\",'+
        '    \"EquipmentData\": ['+
        '      {'+
        '        \"Status\": \"ACTIVE\",'+
        '        \"Configuration\": \"BUS\",'+
        '        \"EngineFamilyCode\": 56,'+
        '        \"ServiceModelDetails\": ['+
        '          {'+
        '            \"EF\": 56,'+
        '            \"SMN\": \"L9 CM2350 L116B\"'+
        '          },'+
        '          {'+
        '            \"EF\": 56,'+
        '            \"SMN\": \"L9 CM2350 L123B\"'+
        '          },'+
        '          {'+
        '            \"EF\": 56,'+
        '            \"SMN\": \"ISL CM2150\"'+
        '          },'+
        '          {'+
        '            \"EF\": 56,'+
        '            \"SMN\": \"ISL CM554\"'+
        '          },'+
        '          {'+
        '            \"EF\": 56,'+
        '            \"SMN\": \"ISL9 CM2350 L101\"'+
        '          }'+
        '        ],'+
        '        \"EquipmentId\": \"EQ534\",'+
        '        \"Model\": \"ALL AMERICAN A\",'+
        '        \"AccessCode\": \"D\",'+
        '        \"Make\": \"BLUE BIRD\",'+
        '        \"ApplicationCategory\": \"A\"'+
        '      },'+
        '      {'+
        '        \"Status\": \"ACTIVE\",'+
        '        \"Configuration\": \"CONVENTIONAL\",'+
        '        \"EngineFamilyCode\": 10,'+
        '        \"ServiceModelDetails\": ['+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX CM870\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX15 CM2350 X101\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX15 CM2250\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX CM570\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX CM871\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"X15 CM2350 X116B\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"ISX CM871 E\"'+
        '          },'+
        '          {'+
        '            \"EF\": 10,'+
        '            \"SMN\": \"X15 CM2350 X114B\"'+
        '          }'+
        '        ],'+
        '        \"EquipmentId\": \"EQ5436\",'+
        '        \"Model\": \"T600 SERIES\",'+
        '        \"AccessCode\": \"B\",'+
        '        \"Make\": \"KENWORTH\",'+
        '        \"ApplicationCategory\": \"A\"'+
        '      },'+
        '      {'+
        '        \"Status\": \"ACTIVE\",'+
        '        \"Configuration\": \"TRENCHER\",'+
        '        \"EngineFamilyCode\": 31,'+
        '        \"ServiceModelDetails\": ['+
        '          {'+
        '            \"EF\": 31,'+
        '            \"SMN\": \"QSB6.7 CM2250 B128\"'+
        '          },'+
        '          {'+
        '            \"EF\": 31,'+
        '            \"SMN\": \"QSB6.7 CM2250\"'+
        '          },'+
        '          {'+
        '            \"EF\": 31,'+
        '            \"SMN\": \"QSB6.7 CM2250 EC\"'+
        '          }'+
        '        ],'+
        '        \"EquipmentId\": \"EQ12608\",'+
        '        \"Model\": \"DD10\",'+
        '        \"AccessCode\": \"C\",'+
        '        \"Make\": \"AMERICAN AUGER\",'+
        '        \"ApplicationCategory\": \"I\"'+
        '      }'+
        '    ],'+
        '    \"OutputMessageType\": \"S\"'+
        '  },'+
        '  \"Header\": {'+
        '    \"Status\": \"SUCCESS\",'+
        '    \"ReturnCodeDescription\": \"Normal, Successful completion.\"'+
        '  }'+
        '}';
        CSS_WS_J2A_GetServiceModel obj = CSS_WS_J2A_GetServiceModel.parse(json);
        System.assert(obj != null);
    }
}