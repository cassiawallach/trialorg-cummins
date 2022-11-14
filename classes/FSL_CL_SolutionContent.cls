/**********************************************************************
Name:FSL_CL_SolutionContent
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
------- This class is used for inserting the solutions
and related components
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE               DETAIL                                
1.0 -   SRIPRADA SESHAM    4/15/2019       INITIAL DEVELOPMENT     
1.1 -   Sunitha Mattaparthi 9/23/2020        CT3-46 Devlopment
***********************************************************************/
public class FSL_CL_SolutionContent {
    
    Static Boolean isEligibleForAppLogging = FSL_Utility.setEligibilityForApplicationLogging();
    Static String executionLog = 'Log Start';
    
    public static string handleSolutionRequest(RestRequest req)
    {
        DateTime startTime = System.Now();
        executionLog = FSL_ApplicationLogger.logStart('FSL_CL_SolutionContent : handleSolutionRequest method ' + startTime, executionLog , isEligibleForAppLogging);
        
        executionLog = FSL_ApplicationLogger.logMessage('JSON Request Body '+req,executionLog,isEligibleForAppLogging);
        string msg = 'Record Saved Sucessfully!';
        string jSONRequestBody = req.requestBody.toString().trim();
        try
        {            
            //system.debug('jSONRequestBody  : '+jSONRequestBody);
            FSL_CL_SCWrapper obj = new FSL_CL_SCWrapper();
            obj = (FSL_CL_SCWrapper) System.JSON.deserialize(jSONRequestBody, FSL_CL_SCWrapper.class);
            system.debug('obj : '+ obj.Solutions);
            system.debug('Solutions : '+ obj.Solutions[0].Verification);
            insertSolutions(obj);
            msg = '{"TransactionID":"'+obj.TransactionId+'","ToolID":"CDS","ReturnCode":"200","ReturnCodeDescription":"Records processed successfully"}';
        }
        catch(Exception ex)
        {
            System.debug('Execption at line no :: '+ex.getLineNumber()+' Exception Message>>>is:  '+ex.getMessage());
            //msg = 'Exception Message : '+ex.getMessage();
            string tID;
            if(jSONRequestBody.contains('"TransactionId":'))
            {          
                JSONParser parser = JSON.createParser(jSONRequestBody);  
                while (parser.nextToken() != null)
                {        
                    if(parser.getText() == 'TransactionId') 
                    {               
                        parser.nextToken(); 
                        tID = (parser.getText());                        
                    } 
                } 
            }
            msg = '{"TransactionID":"'+tID+'","ToolID":"CDS","ReturnCode":"401","ReturnCodeDescription":"'+ex.getMessage()+'"}'; 
        }
        FSL_ApplicationLogger.createLog(executionLog, isEligibleForAppLogging ,startTime , System.Now(),Null);
        return msg;
    }
    
    public static void insertSolutions(FSL_CL_SCWrapper solWrap)
    {
        list<Knowledge__kav> listknw = new list<Knowledge__kav>();
        // list<Knowledge__kav> databaseKnowledge = new list<Knowledge__kav>();
        set<id> knwIds = new Set<id>();
        map<string,string> mapOldNewKnwIds = new map<string,string>();
        set<id> updateknwId = new set<id>();
        set<string> setURLs = new set<string>();
        set<string> setLang = new set<string>();
        string cssLang;
        map<string,string> seturllang=new map<string,string>();
        map<string,Knowledge__kav> mapKnwURLsId = new map<string,Knowledge__kav>();
        map<string,Knowledge__kav> mapToUpdateKnw = new map<string,Knowledge__kav>();
        map<string,string> mapToUpdateKnwlang = new map<string,string>();
        Map<string,list<FSL_Component__c>> mapSolIDCmp = new Map<string,list<FSL_Component__c>>();
        Map<string,list<FSL_Component__c>> mapToUpdateCmp = new Map<string,list<FSL_Component__c>>();
        list<FSL_Component__c> listCmp ;
        //  CT3-46 Devlopment by Sunitha start
        map<string,string> CDSlang=new map<string,string>();
        list<CSS_accountLanguage__c> cssLangList=[select FSL_CDSLanguage__c ,Name,CSS_userLanguage__c
                                                  from CSS_accountLanguage__c where FSL_CDSLanguage__c!=null ];
        system.debug(cssLangList);
        for(CSS_accountLanguage__c css:cssLangList){
            CDSlang.put(css.FSL_CDSLanguage__c,css.name); //en_us  
            
            
        }  
        system.debug('langaggemapping '+CDSlang);
        //  CT3-46 Devlopment by Sunitha end
        if(solWrap != null && solWrap.Solutions != null && solWrap.Solutions.size()>0)
        {
            for(integer i=0;i<solWrap.Solutions.size();i++)
            {
                setURLs.add(solWrap.Solutions[i].SolutionId); //fetching the solution ids
                setlang.add(CDSlang.get(solWrap.Solutions[i].LanguageKey));                
                system.debug('setURLs==='+setURLs);
                system.debug('setLang==='+setLang);
                //  CT3-46 Devlopment by Sunitha end
            }
            
            for(Knowledge__kav knw : [select id ,UrlName,KnowledgeArticleId,Language from 
                                      Knowledge__kav where language in:setLang and UrlName in : setURLs
                                      and PublishStatus = 'Online'])
            {
                mapKnwURLsId.put(knw.UrlName+'-'+knw.Language,knw);
                system.debug('mapKnwURLsId==='+mapKnwURLsId);
            }
            for(integer i=0;i<solWrap.Solutions.size();i++)    
            {                                                      //for inserting the knowledge
                if(CDSlang.containsKey(solWrap.Solutions[i].LanguageKey))//  CT3-46 Devlopment for language
                {
                    system.debug('test');
                    
                    Knowledge__kav knwObj = new Knowledge__kav();
                    cssLang=CDSlang.get(solWrap.Solutions[i].LanguageKey);
                    system.debug(cssLang);
                    //  system.debug('Language is:'+solWrap.Solutions[i].LanguageKey);//  CT3-46 Devlopment for language
                    if(mapKnwURLsId.containsKey(solWrap.Solutions[i].SolutionId+'-'+cssLang))//  CT3-46 Devlopment for language
                    {
                        
                        system.debug('knw '+ mapKnwURLsId.get(solWrap.Solutions[i].SolutionId+'-'+cssLang).KnowledgeArticleId);//  CT3-46 Devlopment for language
                        String sId = KbManagement.PublishingService.editOnlineArticle(mapKnwURLsId.get(solWrap.Solutions[i].SolutionId+'-'+cssLang).KnowledgeArticleId, true); //Draft the article //  CT3-46 Devlopment for language
                        String Lang = mapKnwURLsId.get(solWrap.Solutions[i].SolutionId+'-'+cssLang).Language;
                        system.debug(sId);
                        system.debug(Lang);
                        
                        if(string.isNotBlank(sId))
                        {
                            //knwObj.Id = mapKnwURLsId.get(solWrap.Solutions[i].SolutionId).Id; // fetching the Id of drafted article
                            knwObj.Id = sId ; // fetching the Id of drafted article
                            updateknwId.add(mapKnwURLsId.get(solWrap.Solutions[i].SolutionId+'-'+cssLang).Id);
                            system.debug(updateknwId);          //  CT3-46 Devlopment for language
                            mapOldNewKnwIds.put(mapKnwURLsId.get(solWrap.Solutions[i].SolutionId+'-'+cssLang).Id,sId);//  CT3-46 Devlopment for language
                            system.debug('mapOldNewKnwIds'+mapOldNewKnwIds);
                            //ka00r0000000Or5AAE=ka00r0000000OsI
                            //kid--sid
                            system.debug('knowledge article ID'+ sId);
                        }
                        else{continue;}
                    }                
                    knwObj.UrlName = solWrap.Solutions[i].SolutionId;    //knowledge insert                			
                    knwObj.Title = solWrap.Solutions[i].SolutionTitle;
                    
                    //  CT3-46 Devlopment for language start
                    if(!mapKnwURLsId.containsKey(solWrap.Solutions[i].SolutionId+'-'+cssLang)){
                        knwObj.Language = CDSlang.get(solWrap.Solutions[i].LanguageKey);
                        //system.debug('knwObj.Language=='+knwObj.Language);
                    }
                    //  CT3-46 Devlopment for language end
                    
                    if(string.isNotBlank(solWrap.Solutions[i].SolutionPriority))
                    {
                        knwObj.Solution_Priority__c = decimal.valueOf(solWrap.Solutions[i].SolutionPriority);    
                    }  
                    
                    knwObj.Verification__c = handleSections(solWrap.Solutions[i].Verification.Sections,'Verification');
                    knwObj.Repairs__c = handleSections(solWrap.Solutions[i].Repair.Sections,'Repair');
                    knwObj.Validations__c = handleSections(solWrap.Solutions[i].Validation.Sections,'Validation');
                    knwObj.IsVisibleInPrm = true;

                    if(string.isNotBlank(solWrap.Solutions[i].PoleFlag))
                    {
                        knwObj.Pole_Flag__c = boolean.valueOf(solWrap.Solutions[i].PoleFlag);    
                    }
                    if(string.isNotBlank(solWrap.Solutions[i].PoleFlag))
                    {
                        knwObj.Redirection_Flag__c = boolean.valueOf(solWrap.Solutions[i].RedirectionFlag);
                    }
                    
                    if(mapKnwURLsId.containsKey(solWrap.Solutions[i].SolutionId+'-'+cssLang))//  CT3-46 Devlopment for language
                    {
                        //mapToUpdateKnw.put(mapKnwURLsId.get(solWrap.Solutions[i].SolutionId).Id,knwObj);
                        mapToUpdateKnw.put(knwObj.id,knwObj); 
                        mapToUpdateKnwlang.put(knwObj.id,CDSlang.get(solWrap.Solutions[i].LanguageKey));                      
                        // system.debug('mapToUpdateKnw==='+mapToUpdateKnw);
                        // system.debug('mapToUpdateKnwlang==='+mapToUpdateKnwlang);
                        
                    }
                    else
                    {
                        listknw.add(knwObj);   // Add for insert only 
                        system.debug('firstliknw '+listknw);
                    }
                    
                    // for Components
                    listCmp = new list<FSL_Component__c>();
                    if(solWrap != null && solWrap.Solutions[i].Components != null &&  solWrap.Solutions[i].Components.size()>0)
                    {
                        system.debug('solWrap.Solutions : '+json.serialize(solWrap.Solutions[i].Components));                    
                        for(integer j = 0 ;j<solWrap.Solutions[i].Components.size();j++)
                        {
                            FSL_Component__c cmpObj = new FSL_Component__c();
                            cmpObj.Component_ID__c  = solWrap.Solutions[i].Components[j].FailureId;
                            //  CT3-46 Devlopment for language
                            if(solWrap.Solutions[i].Components[j].ComponentName.length() <= 80) {
                                cmpObj.Name  = solWrap.Solutions[i].Components[j].ComponentName;
                            }
                            else {
                                cmpObj.Name  = solWrap.Solutions[i].Components[j].ComponentName.left(80);
                            }
                            //  CT3-46 Devlopment for language
                            // cmpObj.Knowledge__c = solWrap.Solutions[i].SolutionTitle;
                            listCmp.add(cmpObj);
                            system.debug('components'+listCmp);
                        }
                    }
                    if(string.isNotBlank(solWrap.Solutions[i].SolutionId+'-'+cssLang))//  CT3-46 Devlopment for language
                    {
                        mapSolIDCmp.put((solWrap.Solutions[i].SolutionId+'-'+cssLang),listCmp);
                        // mapSolIDCmp.put(solWrap.Solutions[i].SolutionId,listCmp);                                                                                           //  CT3-46 Devlopment for language
                        system.debug('mapsolidcmp'+mapSolIDCmp);
                        
                    }				
                }
            }
        }
        
        
        listCmp = new list<FSL_Component__c>();
        //   system.debug('listcmp : '+listCmp);
        if(listknw.size()>0)
        {
            insert listknw;
            
            for(Knowledge__kav knw :listknw)
            {
                mapToUpdateKnwlang.put(knw.Id,knw.Language); // CT3-46 Devlopment for language start 
            }
            
            system.debug(listknw);
            //upsert listknw;  
        }
        list<Knowledge__kav> listknwUpdate = new list<Knowledge__kav>();        
        system.debug('mapToUpdateKnw '+ mapToUpdateKnw.keyset());
        //for Knw Update 
        for(Knowledge__kav knw :[select id,UrlName,language,KnowledgeArticleId from Knowledge__kav where 
                                 PublishStatus ='Draft' And id in:mapToUpdateKnw.keyset()])
        {
            system.debug('fullrecord==='+knw);
            //  Knowledge__kav:{Id=ka00r0000000OnXAAU, UrlName=S00001570, Language=en_US}
            if(mapToUpdateKnw.containsKey(knw.Id)){
                listknwUpdate.add(mapToUpdateKnw.get(knw.Id));
                system.debug('listknwUpdate'+listknwUpdate);
                updateknwId.add(knw.Id);  
                system.debug('UpdatedId::::'+updateknwId);
                // {ka00r0000000OnSAAU, ka00r0000000OnXAAU}
                // {ka00r0000000OpOAAU=ka00r0000000OpT}
            }     
        }
        
        list<FSL_Component__c> listCompUpdate = new list<FSL_Component__c>();
        map<string,list<FSL_Component__c>> mapOldCmp = new map<string,list<FSL_Component__c>>();
        //  system.debug('testbefore component'+mapOldNewKnwIds);        
        // for component Duplicate and update
        for(FSL_Component__c cmp : [select id,Component_ID__c,name,Knowledge__c,Knowledge__r.UrlName,
                                    Knowledge__r.language                                   
                                    from FSL_Component__c where Knowledge__c in :mapOldNewKnwIds.keyset()])//  CT3-46 Devlopment for language
            //ka00r0000000OpiAAE=ka00r0000000Oq2}
        {
            system.debug('CMP===='+cmp);
            cmp.Knowledge__c = mapOldNewKnwIds.get(cmp.Knowledge__c);
            FSL_Component__c cmpobj = new FSL_Component__c(name =cmp.Name,Component_ID__c =cmp.Component_ID__c);
            if(mapOldCmp.containskey(cmp.Knowledge__r.UrlName+'-'+cmp.Knowledge__r.language))//  CT3-46 Devlopment for language
            {
                list<FSL_Component__c> cmplist = new list<FSL_Component__c>();
                cmplist = mapOldCmp.get(cmp.Knowledge__r.UrlName+'-'+cmp.Knowledge__r.language);//  CT3-46 Devlopment for language
                //cmplist = mapOldCmp.get(cmp.Knowledge__r.UrlName);
                cmplist.add(cmpobj);
                //  system.debug('cmplist +' +cmplist);
                mapOldCmp.put(cmp.Knowledge__r.UrlName+'-'+cmp.Knowledge__r.language,cmplist);//  CT3-46 Devlopment for language
                //  mapOldCmp.put(cmp.Knowledge__r.UrlName,cmplist);
            }
            
            else
            {
                list<FSL_Component__c> cmplist = new list<FSL_Component__c>();
                cmplist.add(cmpobj);
                mapOldCmp.put(cmp.Knowledge__r.UrlName+'-'+cmp.Knowledge__r.language,cmplist);//  CT3-46 Devlopment for language
                
            }
            
            listCompUpdate.add(cmp);
            // system.debug('listCompUpdate==='+listCompUpdate);
        }   
        //  system.debug('mapOldCmp : '+mapOldCmp);
        if(listknwUpdate.size()>0)
        {
            system.debug(listknwUpdate);
            update listknwUpdate;
            listknw.addAll(listknwUpdate);
            delete [select id from FSL_Component__c where Knowledge__c in :updateknwId];
        }
        for(Knowledge__kav knw :listknw)
        {
            // system.debug('end know '+knw);
            knwIds.add(knw.id); // To publish Article
            //  system.debug(knwIds);
            //  system.debug('Lang '+knw.language);
            knwIds.add(knw.id); // To publish Article
            if(mapSolIDCmp.containsKey(knw.UrlName+'-'+mapToUpdateKnwlang.get(knw.Id))) // CT3-46 Devlopment for language 
            {
                for(FSL_Component__c cmp : mapSolIDCmp.get(knw.UrlName+'-'+mapToUpdateKnwlang.get(knw.Id))) // CT3-46 Devlopment for language 
                {
                    cmp.Knowledge__c = knw.id;
                    listCmp.add(cmp);          
                }
            }
            
        }
        
        system.debug('listCmp : '+listCmp);
        if(listCmp.size()>0)
        {
            insert listCmp;
            // system.debug(listCmp);
        }
        
        for(Knowledge__kav knw: [select id,KnowledgeArticleId  from Knowledge__kav where id in:knwIds])
        {
            if(string.isNotBlank(knw.KnowledgeArticleId))
            {
                KbManagement.PublishingService.publishArticle(knw.KnowledgeArticleId, true);    //publish articlemapOldNewKnwIds
            }            
        }
    } 
    
    private Static string handleSections(list<FSL_CL_SCWrapper.Sections> listSecContent,string SecName)
    {        
        string htmlText = '';
        if(listSecContent != null && listSecContent.size()>0)
        {
            for(integer i=0 ;i<listSecContent.size() ;i++)
            {
                htmlText += '<strong>'+listSecContent[i].SectionName+'</strong> ';
                htmlText += '<ul style="margin-left: 40px;"> ';
                if(listSecContent[i].SectionContent != null && listSecContent[i].SectionContent.size()>0)
                {
                    for(integer j =0;j<listSecContent[i].SectionContent.size();j++)
                    {
                        htmlText += '<li>'+listSecContent[i].SectionContent[j].Text+' ';
                        if(listSecContent[i].SectionContent[j].Links != null && listSecContent[i].SectionContent[j].Links.size()>0)
                        {
                            
                            for(integer k = 0 ; k<listSecContent[i].SectionContent[j].Links.size() ;k++)
                            {
                                if(listSecContent[i].SectionContent[j].Links[k].LinkType == 'Child Link'){
                                    //Added by Ramya as part of VGRS2-363
                                   if(listSecContent[i].SectionContent[j].Links[k].LinkText!= null) 
                                   {
                                    	htmlText += listSecContent[i].SectionContent[j].Links[k].LinkText;
                                   }
                                    htmlText += ' <a href="/articles/Knowledge/'+listSecContent[i].SectionContent[j].Links[k].LinkParam+'" target="_blank">'+listSecContent[i].SectionContent[j].Links[k].LinkParam+'</a> ';
                                }
                                else if(listSecContent[i].SectionContent[j].Links[k].LinkType == 'Procedure Link'){
                                    htmlText += listSecContent[i].SectionContent[j].Links[k].LinkText;
                                    htmlText += ' <a href="/apex/FSL_qsolRedirect?doctype=pro&docid='+listSecContent[i].SectionContent[j].Links[k].LinkParam+'&pgroup=EBU&serialNumber={*#SnNo#*}'+'" target="_blank">'+listSecContent[i].SectionContent[j].Links[k].LinkParam+'</a> ';
                                }
                                //Added by Sriprada S as part of VGRS2-362
                                 else if(listSecContent[i].SectionContent[j].Links[k].LinkType == 'TSB Link'){
                                    htmlText += listSecContent[i].SectionContent[j].Links[k].LinkText;
                                    htmlText += ' <a href="/apex/FSL_qsolRedirect?doctype=tsb&docid='+listSecContent[i].SectionContent[j].Links[k].LinkParam+'&pgroup=EBU&serialNumber={*#SnNo#*}'+'" target="_blank">'+listSecContent[i].SectionContent[j].Links[k].LinkParam+'</a> ';
                                } //Code Ends here --- Sriprada S
                                 //Service Bulletin link type added by Ramya K as part of VGRS2-405: 08/19/2022
                                 else if(listSecContent[i].SectionContent[j].Links[k].LinkType == 'Service Bulletin Link'){
                                    htmlText += listSecContent[i].SectionContent[j].Links[k].LinkText;
                                    htmlText += ' <a href="/apex/FSL_qsolRedirect?doctype=SB&docid='+listSecContent[i].SectionContent[j].Links[k].LinkParam+'&pgroup=EBU&serialNumber={*#SnNo#*}'+'" target="_blank">'+listSecContent[i].SectionContent[j].Links[k].LinkParam+'</a> ';
                                } 
                                else if(listSecContent[i].SectionContent[j].Links[k].LinkType == 'ECM Calibration Link'){
                                   // htmlText += listSecContent[i].SectionContent[j].Links[k].LinkText;
                                    htmlText += ' <a href="' + System.Label.ECM_Link+'" target="_blank">'+listSecContent[i].SectionContent[j].Links[k].LinkText+'</a> ';
                                } 
                            }
                            
                        }
                        htmlText += ' </li> ';
                    }                    
                }
                htmlText += ' </ul> <br/> ';
            }            
        }
        //system.debug('htmlText :'+htmlText);
        return htmlText;
    }
}