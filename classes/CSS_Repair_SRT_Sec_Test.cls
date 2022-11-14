@isTest
global class CSS_Repair_SRT_Sec_Test implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) 
    {
        HttpResponse res = new HttpResponse();
        {
            //Create a fake response
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            //            res.setBody('{"DataArea":{"CaseResponse":[{"SRTTitle":"Injector - Remove and Install, First, (Common Rail Fuel System)","SRTQuantity":1,"VerifyRepeatValue":{"SRTType":"","Step":{"Percentage":0,"SRTModifyDateTime":"","StepDescription":["(Refer to the appropriate Troubleshooting and\nRepair Manual)\nIncludes:\n -Disconnect and connect batteries\n -Clean area around injector\n -Disconnect and connect injector solenoid from\n    harness\n -Remove and install:\n  . Rocker lever cover\n  . Rocker lever assembly\n  . Adjust Valves\n  . High pressure connector fuel supply line\n  . High pressure connector\n  . Injector clamp\n  . Injector\n -Clean injector bore in cylinder head\n -Operate engine to check for leaks\nNote:  Refer to the following repair procedures\nand times, as necessary\n-10-025 Air Intake Connection with EGR - Remove\n    and Install\n-19-602 Programmable Parameters - Read and Adjust","DUMMY","DUMMY"]},"SRTEventPerfDateTime":""},"SRTDetails":"06-026-00","CaseNumber":"F05000100","SRTTime":1.1,"SRTAccessCode":"D","SRTMessage":""},{"SRTTitle":"Steam Clean - Single Component Repair","SRTQuantity":1,"VerifyRepeatValue":{"SRTType":"","Step":{"Percentage":0,"SRTModifyDateTime":"","StepDescription":["Steam Clean - Single Component Replacement","DUMMY","DUMMY"]},"SRTEventPerfDateTime":""},"SRTDetails":"00-400-00","CaseNumber":"F05000100","SRTTime":0.2,"SRTAccessCode":"D","SRTMessage":""},{"SRTTitle":"DUMMY"},{"SRTTitle":"DUMMY"}],"ResponseMessage":""},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');
            res.setBody('{"DataArea":{"ResponseMessage":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination."},"Header":{"ReturnCodeDescription":"Error:: Code:ORA-21001 Message:No SRT found for the input Failure ID, Service Model Name, Engine Family and Timestamp combination.","Status":"Error"}}');
        }
        return res;
    }
}