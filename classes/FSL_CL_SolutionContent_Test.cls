//Adding Comment for Deploying changes ---- Sriprada S
@isTest
public class FSL_CL_SolutionContent_Test 
{
    @isTest
    static void testSolutionRequest()
    {
       String myJSON =  '{"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304","ToolID":"CDS","WorkgroupID":"ALBANY-EAST-ALBANY-02024","UserID":"AB123","SolutionCount":1,"Solutions":[{"SolutionID":"S00001256","SolutionTitle":"Test1","SolutionPosition":1,"SolutionPriority":5.8,"Verification":{"SectionName":"Verification","Sections":[{"SectionName":"Conditions","SectionContent":[{"FormattingType":"Bulleted","Text":"Turn .","Links":[]},{"FormattingType":"Bulleted","Text":"Disconnect ","Links":[]}]},{"SectionName":"Action","SectionContent":[{"FormattingType":"Bulleted","Text":"Inspect","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00000877"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "Procedure Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType":"Bulleted","Text":"Aftertreatment","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00001247"}]}]}]},"Repair":{"SectionName":"Repair","Sections":[{"SectionName":"Repair","SectionContent":[{"FormattingType":"Bulleted","Text":"No additional .","Links":[]}]}]},"Validation":{"SectionName":"Validation","Sections":[{"SectionName":"Validation","SectionContent":[{"FormattingType":"Bulleted","Text":"Check ECM ","Links":[]},{"FormattingType":"Bulleted","Text":"Use test","Links":[]},{"FormattingType":"Bulleted","Text":"Compare test","Links":[]},{"FormattingType":"Bulleted","Text":"Refer test","Links":[]},{"FormattingType":"Bulleted","Text":"Connect all components","Links":[]},{"FormattingType":"Bulleted","Text":"Connect test","Links":[]},{"FormattingType":"Bulleted","Text":"Operate Test.","Links":[]},{"FormattingType":"Bulleted","Text":"Verify test","Links":[]}]}]},"PoleFlag":"Y","RedirectionFlag":"N","Step1FaultCodeCheck":"Y","OEMServiceManual":"Y","ATR":"N","LanguageKey":"en","Components":[{"ComponentName":"Accessory Drive Pulley","FailureID":"F30002780"},{"ComponentName":"Aftertreatment DEF Tank Filter","FailureID":"F11000050"}]}]}';
    //String myJSON = '{"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304","ToolID":"CDS","WorkgroupID":"ALBANY-EAST-ALBANY-02024","UserID":"AB123","SolutionCount":1,"Solutions":[{"SolutionID":"S00001279","SolutionTitle":"Test1","SolutionPosition":1,"SolutionPriority":5.8,"Verification":{"SectionName":"Verification","Sections":[{"SectionName":"Conditions","SectionContent":[{"FormattingType":"Bulleted","Text":"Turn .","Links":[]},{"FormattingType":"Bulleted","Text":"Disconnect ","Links":[]}]},{"SectionName":"Action","SectionContent":[{"FormattingType":"Bulleted","Text":"Inspect","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00000877"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "Procedure Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType":"Bulleted","Text":"Aftertreatment","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00001247"}]}]}]},{"FormattingType":"Bulleted","Text":"Service Bulletin Link Test","Links":[ {"LinkType":"Service Bulletin Link","LinkText":"Refer to Solution","LinkParam":"S00001247" }] },{"FormattingType":"Bulleted","Text":"ECM Calibration Link Test","Links":[ {"LinkType":"ECM Calibration Link","LinkText":"Refer to Solution","LinkParam":"S00001247" }] }] }] },"Repair":{"SectionName":"Repair","Sections":[{"SectionName":"Repair","SectionContent":[{"FormattingType":"Bulleted","Text":"No additional .","Links":[]}]}]},"Validation":{"SectionName":"Validation","Sections":[{"SectionName":"Validation","SectionContent":[{"FormattingType":"Bulleted","Text":"Check ECM ","Links":[]},{"FormattingType":"Bulleted","Text":"Use test","Links":[]},{"FormattingType":"Bulleted","Text":"Compare test","Links":[]},{"FormattingType":"Bulleted","Text":"Refer test","Links":[]},{"FormattingType":"Bulleted","Text":"Connect all components","Links":[]},{"FormattingType":"Bulleted","Text":"Connect test","Links":[]},{"FormattingType":"Bulleted","Text":"Operate Test.","Links":[]},{"FormattingType":"Bulleted","Text":"Verify test","Links":[]}]}]},"PoleFlag":"Y","RedirectionFlag":"N","Step1FaultCodeCheck":"Y","OEMServiceManual":"Y","ATR":"N","LanguageKey":"en","Components":[{"ComponentName":"Accessory Drive Pulley","FailureID":"F30002780"},{"ComponentName":"Aftertreatment DEF Tank Filter","FailureID":"F11000050"}]}]}';
    
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/CDS/solutionContent/';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        FSL_receiveSolutionContent.doPostOperation();
		//string rslt = FSL_CL_SolutionContent.handleSolutionRequest(request);
    }
     @isTest
    static void testDuplicateRequest()
    {
        FSL_CL_SCWrapper sc = new FSL_CL_SCWrapper();
        Knowledge__kav knwObj = new Knowledge__kav();
        knwObj.UrlName = 'S00001279';              			
        knwObj.Title = 'Test1';
        knwObj.Validations__c ='test';
        knwObj.Language='en_US';//CT3-46 Language Devlopemnt
        insert knwObj;
        
        FSL_Component__c cmpObj = new FSL_Component__c();
		cmpObj.Name  = 'Accessory Drive Pulley';
		cmpObj.Component_ID__c  = 'F30002780';
        cmpobj.Knowledge__c = knwObj.id;
        
        insert cmpObj;
        
        FSL_Component__c cmpObj1 = new FSL_Component__c();
		cmpObj1.Name  = 'Accessory test';
		cmpObj1.Component_ID__c  = 'F30002782';
        cmpobj1.Knowledge__c = knwObj.id;
		insert cmpobj1;
      //CT3-46 Language devlopment start  		
        CSS_accountLanguage__c cal=new CSS_accountLanguage__c();
        cal.FSL_CDSLanguage__c='en';
        cal.name='en_US';
        insert cal;
       //CT3-46 Language devlopment end 
                      
    	for(Knowledge__kav knw: [select id,KnowledgeArticleId  from Knowledge__kav where id =: knwObj.id ])
        {
            if(string.isNotBlank(knw.KnowledgeArticleId))
            {
            	KbManagement.PublishingService.publishArticle(knw.KnowledgeArticleId, true);    //publish articlemapOldNewKnwIds
            }            
        }
        
       // String myJSON =  '{"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304","ToolID":"CDS","WorkgroupID":"ALBANY-EAST-ALBANY-02024","UserID":"AB123","SolutionCount":1,"Solutions":[{"SolutionID":"S00001279","SolutionTitle":"Test1","SolutionPosition":1,"SolutionPriority":5.8,"Verification":{"SectionName":"Verification","Sections":[{"SectionName":"Conditions","SectionContent":[{"FormattingType":"Bulleted","Text":"Turn .","Links":[]},{"FormattingType":"Bulleted","Text":"Disconnect ","Links":[]}]},{"SectionName":"Action","SectionContent":[{"FormattingType":"Bulleted","Text":"Inspect","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00000877"}]},{"FormattingType":"Bulleted","Text":"Aftertreatment","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00001247"}]}]}]},"Repair":{"SectionName":"Repair","Sections":[{"SectionName":"Repair","SectionContent":[{"FormattingType":"Bulleted","Text":"No additional .","Links":[]}]}]},"Validation":{"SectionName":"Validation","Sections":[{"SectionName":"Validation","SectionContent":[{"FormattingType":"Bulleted","Text":"Check ECM ","Links":[]},{"FormattingType":"Bulleted","Text":"Use test","Links":[]},{"FormattingType":"Bulleted","Text":"Compare test","Links":[]},{"FormattingType":"Bulleted","Text":"Refer test","Links":[]},{"FormattingType":"Bulleted","Text":"Connect all components","Links":[]},{"FormattingType":"Bulleted","Text":"Connect test","Links":[]},{"FormattingType":"Bulleted","Text":"Operate Test.","Links":[]},{"FormattingType":"Bulleted","Text":"Verify test","Links":[]}]}]},"PoleFlag":"Y","RedirectionFlag":"N","Step1FaultCodeCheck":"Y","OEMServiceManual":"Y","ATR":"N","LanguageKey":"en","Components":[{"ComponentName":"Accessory Drive Pulley","FailureID":"F30002780"},{"ComponentName":"Aftertreatment DEF Tank Filter","FailureID":"F11000050"}]}]}';
//        String myJSON = '{"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304","ToolID":"CDS","WorkgroupID":"ALBANY-EAST-ALBANY-02024","UserID":"AB123","SolutionCount":1,"Solutions":[{"SolutionID":"S00001279","SolutionTitle":"Test1","SolutionPosition":1,"SolutionPriority":5.8,"Verification":{"SectionName":"Verification","Sections":[{"SectionName":"Conditions","SectionContent":[{"FormattingType":"Bulleted","Text":"Turn .","Links":[]},{"FormattingType":"Bulleted","Text":"Disconnect ","Links":[]}]},{"SectionName":"Action","SectionContent":[{"FormattingType":"Bulleted","Text":"Inspect","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00000877"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "Procedure Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType":"Bulleted","Text":"Aftertreatment","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00001247"}]}]}]},"Repair":{"SectionName":"Repair","Sections":[{"SectionName":"Repair","SectionContent":[{"FormattingType":"Bulleted","Text":"No additional .","Links":[]}]}]},"Validation":{"SectionName":"Validation","Sections":[{"SectionName":"Validation","SectionContent":[{"FormattingType":"Bulleted","Text":"Check ECM ","Links":[]},{"FormattingType":"Bulleted","Text":"Use test","Links":[]},{"FormattingType":"Bulleted","Text":"Compare test","Links":[]},{"FormattingType":"Bulleted","Text":"Refer test","Links":[]},{"FormattingType":"Bulleted","Text":"Connect all components","Links":[]},{"FormattingType":"Bulleted","Text":"Connect test","Links":[]},{"FormattingType":"Bulleted","Text":"Operate Test.","Links":[]},{"FormattingType":"Bulleted","Text":"Verify test","Links":[]}]}]},"PoleFlag":"Y","RedirectionFlag":"N","Step1FaultCodeCheck":"Y","OEMServiceManual":"Y","ATR":"N","LanguageKey":"en","Components":[{"ComponentName":"Accessory Drive Pulley","FailureID":"F30002780"},{"ComponentName":"Aftertreatment DEF Tank Filter","FailureID":"F11000050"}]}]}';
        String myJSON = '{"TransactionID":"18B79D47-30E5-44A1-8EA5-62AF7D60F304","ToolID":"CDS","WorkgroupID":"ALBANY-EAST-ALBANY-02024","UserID":"AB123","SolutionCount":1,"Solutions":[{"SolutionID":"S00001279","SolutionTitle":"Test1","SolutionPosition":1,"SolutionPriority":5.8,"Verification":{"SectionName":"Verification","Sections":[{"SectionName":"Conditions","SectionContent":[{"FormattingType":"Bulleted","Text":"Turn .","Links":[]},{"FormattingType":"Bulleted","Text":"Disconnect ","Links":[]}]},{"SectionName":"Action","SectionContent":[{"FormattingType":"Bulleted","Text":"Inspect","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00000877"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "Procedure Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "TSB Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "Service Bulletin Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType": "Bulleted","Text": "Sample Text","Links":[{"LinkType": "ECM Calibration Link","LinkText": "Refer to procedure","LinkParam":"019-361"}]},{"FormattingType":"Bulleted","Text":"Aftertreatment","Links":[{"LinkType":"Child Link","LinkText":"Refer to Solution","LinkParam":"S00001247"}]}]}]},"Repair":{"SectionName":"Repair","Sections":[{"SectionName":"Repair","SectionContent":[{"FormattingType":"Bulleted","Text":"No additional .","Links":[]}]}]},"Validation":{"SectionName":"Validation","Sections":[{"SectionName":"Validation","SectionContent":[{"FormattingType":"Bulleted","Text":"Check ECM ","Links":[]},{"FormattingType":"Bulleted","Text":"Use test","Links":[]},{"FormattingType":"Bulleted","Text":"Compare test","Links":[]},{"FormattingType":"Bulleted","Text":"Refer test","Links":[]},{"FormattingType":"Bulleted","Text":"Connect all components","Links":[]},{"FormattingType":"Bulleted","Text":"Connect test","Links":[]},{"FormattingType":"Bulleted","Text":"Operate Test.","Links":[]},{"FormattingType":"Bulleted","Text":"Verify test","Links":[]}]}]},"PoleFlag":"Y","RedirectionFlag":"N","Step1FaultCodeCheck":"Y","OEMServiceManual":"Y","ATR":"N","LanguageKey":"en","Components":[{"ComponentName":"Accessory Drive Pulley","FailureID":"F30002780"},{"ComponentName":"Aftertreatment DEF Tank Filter","FailureID":"F11000050"}]}]}'; 
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/CDS/solutionContent/';
        request.httpMethod = 'POST';
		request.requestBody = Blob.valueof(myJSON);
        RestContext.request = request;
        //FSL_receiveSolutionContent.doPostOperation();
    	 FSL_CL_SolutionContent.handleSolutionRequest(request);
       // FSL_CL_SolutionContent.insertSolutions(sc);
    }

}