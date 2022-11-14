@IsTest
Public Class CSS_WS_J2A_GetCampaignData_Test{
    
    Static testMethod Void testParse(){
        String json = '{' +
        '    \"DataArea\":{' +
        '        \"Details\": [{' +
        '            \"InShopSrtLimitFlag\": \"N\",' +
        '            \"CampaignDesc\": \"ISX CYLINDER BLOCK/LINER COUNTERBORE REPAIR- US/CANADA\",' +
        '            \"CampaignEndDate\": \"2017-10-09\",' +
        '            \"CampaignStartDate\": \"2012-03-09\",' +
        '            \"PartList\": [{' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 288168200,' +
        '                \"PartDescription\": \"SET,PISTON RING\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 288171900,' +
        '                \"PartDescription\": \"KIT,LINER\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 288175600,' +
        '                \"PartDescription\": \"SET,PISTON RING\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 10,' +
        '                \"PartNumber\": 306430500,' +
        '                \"PartDescription\": \"RING,RETAINING\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 408915300,' +
        '                \"PartDescription\": \"KIT,LINER\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 529856400,' +
        '                \"PartDescription\": \"SHIM\"' +
        '            },' +
        '            {' +
        '                \"PartQuantity\": 5,' +
        '                \"PartNumber\": 529856500,' +
        '                \"PartDescription\": \"SHIM\"' +
        '            }],' +
        '            \"SrtList\": [{' +
        '                \"SrtCode\": \"00-901-00\",' +
        '                \"SrtDescription\": \"Administrative Time - Open and Close Repair Order (Shop Repairs)\"' +
        '            },' +
        '            {' +
        '                \"SrtCode\": \"01-151-00\",' +
        '                \"SrtDescription\": \"Piston and Liner - Remove and Install, Each Additional\"' + 
        '            },' +
        '            {' +
        '                \"SrtCode\": \"01-511-00\",' +
        '                \"SrtDescription\": \"Cylinder Block - Machine Counterbore Depth for Shims, Each Additional\"' +
        '            }],' +
        '            \"CampaignNumber\": 1213,' +
        '            \"FailMode\": \"LB\",' +
        '            \"FailCode\": \"KCWB\"' +
        '        }]' +
        '    },' +
        '    \"Header\":{' +
        '        \"Status\": \"Success\"' +
        '    }'+
        '}';
        CSS_WS_J2A_GetCampaignData obj = CSS_WS_J2A_GetCampaignData.parse(json);
        System.assert(obj != null);
    }
}