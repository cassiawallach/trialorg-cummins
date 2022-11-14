/*
* CT3-237: Test class for class FSL_MW_ResWrapper
* @Author: Dinesh Yadav, Created Date: 9 Dec 2020.
*/ 

@IsTest
public class FSL_MW_ResWrapperTest {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"Header\": {'+
        '        \"MessageIdentifier\": \"1-0c3c0bb1-32a0-11eb-81a4-021fef071cef\",'+
        '        \"ReturnCode\": \"IGM01\",'+
        '        \"ReturnCodeDescription\": \"Image details Successfully Retrieved\",'+
        '        \"Status\": \"SUCCESS\",'+
        '        \"MessageType\": \"S\"'+
        '    },'+
        '    \"DataArea\": {'+
        '        \"Images\": ['+
        '            {'+
        '                \"FileName\": \"I-20190421-111230469-EA2C1D72.eif\",'+
        '                \"Exists\": \"Yes\",'+
        '                \"LastModifiedDateTime\": \"2019-04-21T12:52:31.000\"'+
        '            },'+
        '            {'+
        '                \"FileName\": \"I-20191002-111230700-EB2C1D01.csv\",'+
        '                \"Exists\": \"Yes\",'+
        '                \"LastModifiedDateTime\": \"2019-04-21T12:52:31.000\"'+
        '            },'+
        '            {'+
        '                \"FileName\": \"I-20190421-111230101-EB2C1D72.eif\",'+
        '                \"Exists\": \"No\",'+
        '                \"LastModifiedDateTime\": \"\"'+
        '            },'+
        '            {'+
        '                \"FileName\": \"I-20190421-111230101-EB2C1D72.csv\",'+
        '                \"Exists\": \"No\",'+
        '                \"LastModifiedDateTime\": \"\"'+
        '            }'+
        '        ]'+
        '    }'+
        '}';
        FSL_MW_ResWrapper obj = FSL_MW_ResWrapper.parse(json);
        System.assert(obj != null);
    }
}