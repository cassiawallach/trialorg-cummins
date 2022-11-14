/**********************************************************************
Name: CSS_IAFaultCodesController 
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is used for IA Prioritized/Unprioritized Fault Codes
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        02/23/2017     INITIAL DEVELOPMENT
2.0     Surender M        03/12/2020     INITIAL DEVELOPMENT
***********************************************************************/
public with sharing class CSS_IAFaultCodesController {

    public List<FaultCodeWrapper> priFCWrapList{get;set;}
    public List<FaultCodeWrapper> unPriFCWrapList{get;set;}

    public String jobNumber{get;
                            set{ jobNumber = value; 
                                System.debug('jobNumber>>>>>>>>>>>:'+jobNumber);
                                if(jobNumber !=null){
                                    List<css_job_order__c> jobList = new List<css_job_order__c>([Select Id, Name, Request_JSON__c, Response_JSON__c from css_job_order__c where Name=:jobNumber limit 1]);
                                    System.debug('jobList size>>>>>>>>>:'+jobList.size());
                                    if(jobList != null && jobList.size()>0){
                                        System.debug('jobList inner if...'+jobList.get(0));
                                        prepareFCsWrapper(jobList.get(0)); //This is for IA Guidanz Mobile
                                        System.debug('before calling prepareFCsWrapperForAWS...'+jobList.get(0));
                                        //if((priFCWrapList==null || priFCWrapList.size()<=0) ||  (unPriFCWrapList==null || unPriFCWrapList.size()<=0) )
                                        prepareFCsWrapperForAWS(jobList.get(0)); //This is for IA Guidanz AWS
                                    }
                                }

                               }
                           }

    public CSS_IAFaultCodesController(){
        System.debug('CSS_IAFaultCodesController constructor...');
        try{

        }catch(Exception ex){
            System.debug('in catch of constructor of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    /*
     * This method is used for preparing Wrapper class with Request/Response JSON's FC details for AWS
     */ 
    public void prepareFCsWrapperForAWS(css_job_order__c jobObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareFCsWrapperForAWS method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        FSL_CL_IA_CreateServiceRequestAPIReqJSON reqJSON;
        Map<String, FaultCodeWrapper> reqFCMap;
        List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.PrioritizedData> priFCList;
        List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.UnPrioritizedData> unPriFCList;
        FaultCodeWrapper priUnPriFCWrap;
        //FaultCodeWrapper reqFCWrap;
        //FaultCodeWrapper resFCWrap;
        try{
            //Preparing PrioritizedFCList & UnPrioritizedFCList
            priFCWrapList = new List<FaultCodeWrapper>();
            unPriFCWrapList = new List<FaultCodeWrapper>();

            reqJSON = FSL_CL_IA_CreateServiceRequestAPIReqJSON.parse(jobObj.Request_JSON__c);
            priFCList = reqJSON.DataArea.PrioritizedData;
            unPriFCList = reqJSON.DataArea.UnPrioritizedData;
            system.debug('reqJSON.DataArea.PrioritizedData:'+reqJSON.DataArea.PrioritizedData);
            system.debug('reqJSON.DataArea.UnPrioritizedData:'+reqJSON.DataArea.UnPrioritizedData);
            if(priFCList != null && priFCList.size()>0){
                for(FSL_CL_IA_CreateServiceRequestAPIReqJSON.PrioritizedData fcObj: priFCList){
                    priUnPriFCWrap = new FaultCodeWrapper();
                    priUnPriFCWrap.fc = fcObj.prifc;
                    system.debug('ocTime:'+fcObj.occurenceTime);
                    priUnPriFCWrap.formattedLastOccTime = fcObj.occurenceTime!=null && fcObj.occurenceTime.trim() !='' ? formatLastOccTime(Integer.valueOf(fcObj.occurenceTime)):'00:00:00';
                    priUnPriFCWrap.status = fcObj.status;
                    priUnPriFCWrap.count = Integer.valueOf(fcObj.count);

                    //Related FC Codes
                    String relCodesStr = '';
                    List<FSL_CL_IA_CreateServiceRequestAPIReqJSON.Relfc> relFCList = fcObj.relfc;
                    if(relFCList != null && relFCList.size()>0){
                        for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                            FSL_CL_IA_CreateServiceRequestAPIReqJSON.Relfc relFCObj = relFCList.get(relIndex);
                            if(relIndex==0)
                                relCodesStr = relFCObj.rfc;
                            else 
                                relCodesStr = relCodesStr + ',' + relFCObj.rfc;
                        }
                    }
                    priUnPriFCWrap.relCodes = relCodesStr;

                    priFCWrapList.add(priUnPriFCWrap);
                }
            }

            if(unPriFCList != null && unPriFCList.size()>0){
                for(FSL_CL_IA_CreateServiceRequestAPIReqJSON.UnPrioritizedData fcObj: unPriFCList){
                    priUnPriFCWrap = new FaultCodeWrapper();
                    priUnPriFCWrap.fc = fcObj.upfc;
                    //priUnPriFCWrap.formattedLastOccTime = formatLastOccTime(Integer.valueOf(fcObj.occurenceTime)); //fcObj.occurenceTime;
                    priUnPriFCWrap.formattedLastOccTime = fcObj.occurenceTime!=null && fcObj.occurenceTime.trim() !='' ? formatLastOccTime(Integer.valueOf(fcObj.occurenceTime)):'00:00:00'; //fcObj.occurenceTime;
                    priUnPriFCWrap.status = fcObj.status;
                    priUnPriFCWrap.count = Integer.valueOf(fcObj.count);
                    unPriFCWrapList.add(priUnPriFCWrap);
                }
            }
            System.debug('priFCWrapList:'+priFCWrapList);
            System.debug('unPriFCWrapList:'+unPriFCWrapList);

        }catch(Exception ex){
            System.debug('in catch of prepareFCsWrapperForAWS of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    /*
     * This method is used for preparing Wrapper class with Request/Response JSON's FC details
     */ 
    public void prepareFCsWrapper(css_job_order__c jobObj){
        System.debug('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ entered into prepareFCsWrapper method $$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2 reqJSON;
        Map<String, FaultCodeWrapper> reqFCMap;
        List<CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST> reqFaultList;
        FaultCodeWrapper reqFCWrap;
        FaultCodeWrapper resFCWrap;
        try{
            //Preparing a map with request FC wrappers
            reqJSON = CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.parse(jobObj.Request_JSON__c);
            reqFCMap = new Map<String, FaultCodeWrapper>();
            reqFaultList = reqJSON.DataArea.faultList;
            if(reqFaultList != null && reqFaultList.size()>0){
                for(CSS_WPR_TG_GetAssesDataReqJSON2Apex_V2.FAULTLIST fcObj: reqFaultList){
                    reqFCWrap = new FaultCodeWrapper();
                    reqFCWrap.fc = fcObj.fc;
                    reqFCWrap.lastOccTime = fcObj.occurenceTime;
                    reqFCWrap.status = fcObj.status;
                    reqFCWrap.count = fcObj.count;
                    reqFCMap.put(fcObj.fc, reqFCWrap);
                }
            }
            reqFCWrap = null;

            System.debug('reqJSON.Header.ServiceName>>>>>>>:'+reqJSON.Header.ServiceName);
            priFCWrapList = new List<FaultCodeWrapper>();
            unPriFCWrapList = new List<FaultCodeWrapper>();
            if(reqJSON.Header.ServiceName !=null && reqJSON.Header.ServiceName == 'GetPrioritizedFC'){
                CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 tgPriFCsResJSON = CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.parse(jobObj.Response_JSON__c);
                getPriUnPriWrapListsOfFC(priFCWrapList, unPriFCWrapList, reqFCMap, tgPriFCsResJSON);
            }else if(reqJSON.Header.ServiceName !=null && reqJSON.Header.ServiceName == 'GetLaborHrsData'){
                CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 tgLaborHrsDataResJSON = CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.parse(jobObj.Response_JSON__c);
                getPriUnPriWrapListsOfLaborHours(priFCWrapList, unPriFCWrapList, reqFCMap, tgLaborHrsDataResJSON);
            }else if(reqJSON.Header.ServiceName !=null && reqJSON.Header.ServiceName == 'GetAssessData'){
                CSS_WPR_TG_FaultDetailsDataResJSON_V2 tgFaultDetailsDataResJSON = CSS_WPR_TG_FaultDetailsDataResJSON_V2.parse(jobObj.Response_JSON__c);
                getPriUnPriWrapListsOfFaultDetails(priFCWrapList, unPriFCWrapList, reqFCMap, tgFaultDetailsDataResJSON);
            }
        }catch(Exception ex){
            System.debug('in catch of prepareFCsWrapper of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    /*
     * This method is used for formatLastOccTime
     */ 
    public String formatLastOccTime(Integer lastOccTime){
        String formulaStr = '00:00:00';
        try{
            String hoursStr = '00';
            String minStr = '00';
            String secStr = '00';

            Integer hours = Integer.valueOf(Math.floor(lastOccTime/3600));
            if(hours<10)
                hoursStr = '0'+hours;
            else
                hoursStr = String.valueOf(hours);
            System.debug('hoursStr:'+hoursStr);
            System.debug('Mod value:'+Math.mod(lastOccTime,3600));
            System.debug('Minutes:'+Math.floor(Math.mod(lastOccTime,3600)/60));
            System.debug('Seconds:'+Math.mod(Math.mod(lastOccTime,3600),60));
            Integer minutes = Integer.valueOf(Math.floor(Math.mod(lastOccTime,3600)/60));
            if(minutes<10)
                minStr = '0'+minutes;
            else
                minStr = String.valueOf(minutes);
            Integer seconds = Integer.valueOf(Math.mod(Math.mod(lastOccTime,3600),60));
            if(seconds<10)
                secStr = '0'+seconds;
            else
                secStr = String.valueOf(seconds);
            formulaStr = hoursStr+':'+minStr+':'+secStr;
            System.debug('formulaStr:'+formulaStr);
            //formulaStr = hours+':'+minutes+':'+seconds;
            //formulaStr = Math.floor(seconds/3600) + ':' + Math.floor(Math.mod(seconds,3600)/60) + ':' +   Math.mod(Math.mod(seconds,3600),60);
        }catch(Exception ex){
            System.debug('in catch of formatLastOccTime of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
        return formulaStr;
    }


    /*
     * This method is used for getting Pri UnPri Wrap Lists Of FC
     */
    public void getPriUnPriWrapListsOfFC(List<FaultCodeWrapper> priFCWrapList, List<FaultCodeWrapper> unPriFCWrapList, Map<String, FaultCodeWrapper> reqFCMap, CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2 tgPriFCsResJSON){
        System.debug('$$$$$$$$$$$$$ entered into getPriUnPriWrapListsOfFC method $$$$$$$$$$$$$');
        FaultCodeWrapper reqFCWrap;
        FaultCodeWrapper resFCWrap;
        try{
            List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.PrioritizedData> resPriFCList = tgPriFCsResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.PrioritizedData fcObj: resPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.prifc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.prifc);
                        resFCWrap.fc = fcObj.prifc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;

                        //Related FC Codes
                        String relCodesStr = '';
                        List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.Relfc> relFCList = fcObj.relfc;
                        if(relFCList != null && relFCList.size()>0){
                            for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                                CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.Relfc relFCObj = relFCList.get(relIndex);
                                if(relIndex==0)
                                    relCodesStr = relFCObj.rfc;
                                else 
                                    relCodesStr = relCodesStr + ',' + relFCObj.rfc;
                            }
                        }
                        resFCWrap.relCodes = relCodesStr;
                        priFCWrapList.add(resFCWrap);
                    }
                }
            }
            System.debug('priFCWrapList size>>>:'+priFCWrapList.size());

            //Preparing UnPrioritized map with response FC wrappers
            List<CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.UnPrioritizedData> resUnPriFCList = tgPriFCsResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V2.UnPrioritizedData fcObj: resUnPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.upfc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.upfc);
                        resFCWrap.fc = fcObj.upfc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;
                        resFCWrap.relCodes = '';
                        unPriFCWrapList.add(resFCWrap);
                    }
                }
            }
            System.debug('unPriFCWrapList size>>>:'+unPriFCWrapList.size());
        }catch(Exception ex){
            System.debug('in catch of getPriUnPriWrapListsOfFC of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    /*
     * This method is used for getting Pri UnPri Wrap Lists Of FC
     */
    public void getPriUnPriWrapListsOfLaborHours(List<FaultCodeWrapper> priFCWrapList, List<FaultCodeWrapper> unPriFCWrapList, Map<String, FaultCodeWrapper> reqFCMap, CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2 tgLaborHrsDataResJSON){
        System.debug('$$$$$$$$$$$$$ entered into getPriUnPriWrapListsOfLaborHours method $$$$$$$$$$$$$');
        FaultCodeWrapper reqFCWrap;
        FaultCodeWrapper resFCWrap;
        try{
            List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.PrioritizedData> resPriFCList = tgLaborHrsDataResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.PrioritizedData fcObj: resPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.prifc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.prifc);
                        resFCWrap.fc = fcObj.prifc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;

                        //Related FC Codes
                        String relCodesStr = '';
                        List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.Relfc> relFCList = fcObj.relfc;
                        if(relFCList != null && relFCList.size()>0){
                            for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                                CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.Relfc relFCObj = relFCList.get(relIndex);
                                if(relIndex==0)
                                    relCodesStr = relFCObj.rfc;
                                else 
                                    relCodesStr = relCodesStr + ',' + relFCObj.rfc;
                            }
                        }
                        resFCWrap.relCodes = relCodesStr;
                        priFCWrapList.add(resFCWrap);
                    }
                }
            }
            System.debug('priFCWrapList size>>>:'+priFCWrapList.size());

            //Preparing UnPrioritized map with response FC wrappers
            List<CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.UnPrioritizedData> resUnPriFCList = tgLaborHrsDataResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_LaborHrsDataResJSON2Apex_V2.UnPrioritizedData fcObj: resUnPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.upfc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.upfc);
                        resFCWrap.fc = fcObj.upfc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;
                        resFCWrap.relCodes = '';
                        unPriFCWrapList.add(resFCWrap);
                    }
                }
            }
            System.debug('unPriFCWrapList size>>>:'+unPriFCWrapList.size());
        }catch(Exception ex){
            System.debug('in catch of getPriUnPriWrapListsOfLaborHours of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    /*
     * This method is used for getting Pri UnPri Wrap Lists Of FC
     */
    public void getPriUnPriWrapListsOfFaultDetails(List<FaultCodeWrapper> priFCWrapList, List<FaultCodeWrapper> unPriFCWrapList, Map<String, FaultCodeWrapper> reqFCMap, CSS_WPR_TG_FaultDetailsDataResJSON_V2 tgFaultDetailsDataResJSON){
        System.debug('$$$$$$$$$$$$$ entered into getPriUnPriWrapListsOfFaultDetails method $$$$$$$$$$$$$');
        FaultCodeWrapper reqFCWrap;
        FaultCodeWrapper resFCWrap;
        try{
            List<CSS_WPR_TG_FaultDetailsDataResJSON_V2.PrioritizedData> resPriFCList = tgFaultDetailsDataResJSON.DataArea.prioritizedData;
            if(resPriFCList != null && resPriFCList.size()>0){
                for(CSS_WPR_TG_FaultDetailsDataResJSON_V2.PrioritizedData fcObj: resPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.prifc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.prifc);
                        resFCWrap.fc = fcObj.prifc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;

                        //Related FC Codes
                        String relCodesStr = '';
                        List<CSS_WPR_TG_FaultDetailsDataResJSON_V2.Relfc> relFCList = fcObj.relfc;
                        if(relFCList != null && relFCList.size()>0){
                            for(Integer relIndex=0; relIndex<relFCList.size(); relIndex++){
                                CSS_WPR_TG_FaultDetailsDataResJSON_V2.Relfc relFCObj = relFCList.get(relIndex);
                                if(relIndex==0)
                                    relCodesStr = relFCObj.rfc;
                                else 
                                    relCodesStr = relCodesStr + ',' + relFCObj.rfc;
                            }
                        }
                        resFCWrap.relCodes = relCodesStr;
                        priFCWrapList.add(resFCWrap);
                    }
                }
            }


            //Preparing UnPrioritized map with response FC wrappers
            List<CSS_WPR_TG_FaultDetailsDataResJSON_V2.UnPrioritizedData> resUnPriFCList = tgFaultDetailsDataResJSON.DataArea.unPrioritizedData;
            if(resUnPriFCList != null && resUnPriFCList.size()>0){
                for(CSS_WPR_TG_FaultDetailsDataResJSON_V2.UnPrioritizedData fcObj: resUnPriFCList){
                    if(css_utility.isMapContainsKey(reqFCMap, fcObj.upfc)){
                        resFCWrap = new FaultCodeWrapper();
                        reqFCWrap = reqFCMap.get(fcObj.upfc);
                        resFCWrap.fc = fcObj.upfc;
                        //resFCWrap.lastOccTime = reqFCWrap.lastOccTime;
                        resFCWrap.formattedLastOccTime = formatLastOccTime(reqFCWrap.lastOccTime);
                        resFCWrap.status = reqFCWrap.status;
                        resFCWrap.count = reqFCWrap.count;
                        resFCWrap.relCodes = '';
                        unPriFCWrapList.add(resFCWrap);
                    }
                }
            }
            System.debug('unPriFCWrapList size>>>:'+unPriFCWrapList.size());
        }catch(Exception ex){
            System.debug('in catch of getPriUnPriWrapListsOfFaultDetails of CSS_IAFaultCodesController>>>>>>>>>>>>>>>LineNumber is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    public class FaultCodeWrapper{
        public String fc{get;set;}
        public Integer lastOccTime{get;set;}
        public String status{get;set;}
        public Integer count{get;set;}
        public String relCodes{get;set;}
        public String formattedLastOccTime{get;set;}

    }
}