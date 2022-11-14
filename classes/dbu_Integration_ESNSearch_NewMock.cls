@isTest
global with sharing class dbu_Integration_ESNSearch_NewMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        
         String json = '{'+
        '  \"Header\": {'+
        '    \"MessageIdentifier\": \"1-f8f3b620-fcd0-11ea-892c-024ce88bbcc4\",'+
        '    \"ReturnCode\": \"PARTLIST001\",'+
        '    \"ReturnCodeDescription\": \"PartLists Retrieved successfully\",'+
        '    \"Status\": \"SUCCESS\",'+
        '    \"MessageType\": \"S\"'+
        '  },'+
        '  \"DataArea\": {'+
        '    \"PartLists\": ['+
        '      {'+
        '        \"ESN\": \"79971431\",'+
        '        \"Parts\": ['+
       
        '          {'+
        '            \"Number\": \"3964307\",'+
        '            \"Description\": \"TAPE\",'+
        '            \"Systems\": ['+
        '              \"ELECTRICS\",'+
        '              \"CONTROLS\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4298929\",'+
        '            \"Description\": \"SCREW,CAPTIVE WASHER CAP\",'+
        '            \"Systems\": ['+
        '              \"ELECTRICS\",'+
        '              \"CONTROLS\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4373988\",'+
        '            \"Description\": \"HARNESS,ETR CNT MDL WRG\",'+
        '            \"Systems\": ['+
        '              \"ELECTRICS\",'+
        '              \"CONTROLS\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4373989\",'+
        '            \"Description\": \"HARNESS,ETR CNT MDL WRG\",'+
        '            \"Systems\": ['+
        '              \"ELECTRICS\",'+
        '              \"CONTROLS\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4952223\",'+
        '            \"Description\": \"CLAMP,WIRE TIE\",'+
        '            \"Systems\": ['+
        '              \"ELECTRICS\",'+
        '              \"CONTROLS\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4367100\",'+
        '            \"Description\": \"FILTER,LUBRICATING OIL\",'+
        '            \"Systems\": ['+
        '              \"LUBRICATION\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"4367101\",'+
        '            \"Description\": \"DECAL,INFORMATION\",'+
        '            \"Systems\": ['+
        '              \"LUBRICATION\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"186780\",'+
        '            \"Description\": \"SEAL,THERMOSTAT\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"3082439\",'+
        '            \"Description\": \"SCREW,HEX FLANGE HEAD CAP\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"3089016\",'+
        '            \"Description\": \"SCREW,HEX FLANGE HEAD CAP\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"3682667\",'+
        '            \"Description\": \"COVER,THERMOSTAT HOUSING\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"3682673\",'+
        '            \"Description\": \"GASKET,THM HOUSING COVER\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          },'+
        '          {'+
        '            \"Number\": \"3916069\",'+
        '            \"Description\": \"SCREW,HEX FLANGE HEAD CAP\",'+
        '            \"Systems\": ['+
        '              \"COOLING\"'+
        '            ]'+
        '          }'+
        '        ],'+
        '        \"Kits\": ['+
        '          {'+
        '            \"Number\": \"5579419\",'+
        '            \"Description\": \"Injector Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376566\",'+
        '            \"Description\": \"Engine Piston Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034222\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5406049\",'+
        '            \"Description\": \"Exhaust Recirculation Valve Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955778\",'+
        '            \"Description\": \"Oil Cooler Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955699\",'+
        '            \"Description\": \"Valve Cover Blowby Sensor Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376565\",'+
        '            \"Description\": \"Piston Ring Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376219\",'+
        '            \"Description\": \"Valve Seal Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034182\",'+
        '            \"Description\": \"Mounting Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4352360\",'+
        '            \"Description\": \"\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5406130\",'+
        '            \"Description\": \"Fuel Pump Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"3803431\",'+
        '            \"Description\": \"V-Band Clamp Kits\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"2882041\",'+
        '            \"Description\": \"Cylinder Head Rebuild Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5303604\",'+
        '            \"Description\": \"Filter Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"3800298\",'+
        '            \"Description\": \"Main Bearing Set\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034208\",'+
        '            \"Description\": \"Turbocharger Electric Actuator Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376361\",'+
        '            \"Description\": \"Oversize Rod Bearing Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4309500\",'+
        '            \"Description\": \"Lubricating Pump Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376168\",'+
        '            \"Description\": \"Liner Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4352304\",'+
        '            \"Description\": \"\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034085\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034289\",'+
        '            \"Description\": \"Turbocharger Actuator Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5579438\",'+
        '            \"Description\": \"Cylinder Head Rebuild Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955711\",'+
        '            \"Description\": \"Valve Cover Blowby Sensor Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4089846\",'+
        '            \"Description\": \"Main Bearing (.020) Set\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"3800751\",'+
        '            \"Description\": \"Shims\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376143\",'+
        '            \"Description\": \"Exhaust Recirculation Cooler Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955831\",'+
        '            \"Description\": \"Oil Cooler Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955710\",'+
        '            \"Description\": \"Valve Cover Blowby Sensor Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5454048\",'+
        '            \"Description\": \"Turbocharger Gasket Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4955829\",'+
        '            \"Description\": \"Oil Cooler Gasket Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"2882087\",'+
        '            \"Description\": \"Connection Rod Bearing Set\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034242\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034246\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4032165\",'+
        '            \"Description\": \"Turbocharger Actuator Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"5406048\",'+
        '            \"Description\": \"Water Pump Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4965569\",'+
        '            \"Description\": \"Seal And Spacer Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4089845\",'+
        '            \"Description\": \"Main Bearing (.010) Set\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4309349\",'+
        '            \"Description\": \"Aftertreatment Injector Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376360\",'+
        '            \"Description\": \"Oversize Rod Bearing Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034238\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034250\",'+
        '            \"Description\": \"Turbocharger Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"3798514\",'+
        '            \"Description\": \"Turbocharger Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376196\",'+
        '            \"Description\": \"Oil Cooler Repair Kit\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4034201\",'+
        '            \"Description\": \"Speed Sensor Kit\"'+
        '          }'+
        '        ],'+
        '        \"Gaskets\": ['+
        '          {'+
        '            \"Number\": \"2881766\",'+
        '            \"Description\": \"KIT,LOWER ENGINE GASKET\"'+
        '          },'+
        '          {'+
        '            \"Number\": \"4376104\",'+
        '            \"Description\": \"KIT,UPPER ENGINE GASKET\"'+
        '          }'+
        '        ]'+
        '      }'+
        '    ]'+
        '  }'+
        '}';
        
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(json);
        response.setStatusCode(200);
        system.debug('response'+response);
        return response;
    }
}