@IsTest
public class FSL_CL_SCWrapper_Test {
    
    static testMethod void testParse() {
        String json = '{'+
            
            '{'+
            '"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304",'+
              '"ToolID":"CDS",'+
              '"WorkgroupID":"ALBANY-EAST-ALBANY-02024",'+
              '"UserID":"AB123",'+
              '"SolutionCount":1,'+
              '"Solutions":[{'+
              '"SolutionID":"k18769004",'+
              '"SolutionTitle":"Aftertreatment DPF differential pressure sensor voltage check",'+
              '"SolutionPosition":1,'+
              '"SolutionPriority":5.8,'+
              '"Verification":{'+
              '"SectionName":"Verification",'+
              '"Sections":[{'+
              '"SectionName":"Conditions",'+
              '"SectionContent":[{'+
              '"FormattingType":"Bulleted",'+
              '"Text":"Turn keyswitch OFF.",'+
              '"Links":['+
              ']'+
              '}]'+
              '{'+
               '"SectionName":"Action",'+
               '"SectionContent":[{'+
               '"FormattingType":"Bulleted",'+
               '"Text":"Inspect the pins and connectors for damage.",'+
               '"Links":[{'+
               '"LinkType":"Child Link",'+
               '"LinkText":"Refer to Solution",'+
               '"LinkParam":"S00000877"'+
                 '}]'+
               '}]'+
            '},'+
               '}]'+
               '"Repair":{'+
               '"SectionName":"Repair",'+
               '"Sections":[{'+
               '"SectionName":"Repair",'+
               '"SectionContent":[{'+
               '"FormattingType":"Bulleted",'+
               '"Text":"No additional action is required for this solution.",'+
               '"Links":['+
               ']'+
               '}]'+
               '}]'+
            '},'+
               '"Validation":{'+
               '"SectionName":"Validation",'+
               '"Sections":[{'+
               '"SectionName":"Validation",'+
               '"SectionContent":[{'+
               '"FormattingType":"Bulleted",'+
               '"Text":"Check ECM Calibration Revision History",'+
               '"Links":['+
               ']'+
               '}]'+
               '}]'+
            '},'+
               '"PoleFlag":"Y",'+
               '"RedirectionFlag":"N",'+
               '"Step1FaultCodeCheck":"Y",'+
               '"OEMServiceManual":"Y",'+
               '"ATR":"N",'+
               ' "LanguageKey":"en",'+
               '"Components":[{'+
               '"ComponentName":"Test",'+
               '"FailureID":"F1111087"'+
               '}]'+
            '}]'+
            '}'+
          '}';
         FSL_CL_SCWrapper obj = new FSL_CL_SCWrapper();
            //obj = (FSL_CL_SCWrapper) System.JSON.deserialize(json, FSL_CL_SCWrapper.class);
       // FSL_CL_SCWrapper.parse(json);
        FSL_CL_SCWrapper.Solutionitems Sitem = new FSL_CL_SCWrapper.Solutionitems();
        FSL_CL_SCWrapper.ComponentItems Scmp = new FSL_CL_SCWrapper.ComponentItems();
        FSL_CL_SCWrapper.Links Slink = new FSL_CL_SCWrapper.Links();
        FSL_CL_SCWrapper.Repair Srpr = new FSL_CL_SCWrapper.Repair();
        FSL_CL_SCWrapper.Sections Ssec = new FSL_CL_SCWrapper.Sections();
        FSL_CL_SCWrapper.Validation Sval = new FSL_CL_SCWrapper.Validation();
        FSL_CL_SCWrapper.Verification sVer = new FSL_CL_SCWrapper.Verification();
        FSL_CL_SCWrapper.SectionContent sCont = new FSL_CL_SCWrapper.SectionContent();
    }
}