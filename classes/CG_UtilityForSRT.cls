public class CG_UtilityForSRT {

    public List<String> getAccessCodesJob(String timeA, String timeB, String timeC, String timeD, String timeR, String jobOrClaimAccessCode, String srtAccessCode, 
                                          String sectionType){
        List<String> accessCodesList = new List<String>();
        system.debug('timeA>'+timeA+'>>timeB>>'+timeB+'>>timeC>>'+timeC+'>>timeD>>'+timeD+'>>timeR>>'+timeR);
        system.debug('jobOrClaimAccessCode>>'+jobOrClaimAccessCode+'>>srtAccessCode>>'+srtAccessCode+'>>sectionType>>'+sectionType);
        try{
            if( (sectionType !=null && (sectionType=='Diag' || sectionType=='Additional') )  ){  // || (srtAccessCode !=null && srtAccessCode=='A/B/C/D' )
                if(timeA!=null && decimal.valueOf(timeA)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='A')
                    accessCodesList.add('A');
                else if(timeB!=null && decimal.valueOf(timeB)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='B')
                    accessCodesList.add('B');
                else if(timeC!=null && decimal.valueOf(timeC)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='C')
                    accessCodesList.add('C');
                else if(timeD!=null && decimal.valueOf(timeD)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='D')
                    accessCodesList.add('D');

                if(timeR!=null && decimal.valueOf(timeR)>0)
                    accessCodesList.add('R');

            }else if(sectionType !=null && sectionType=='RepairOrFA'){
                if(timeA!=NULL && Decimal.valueOf(timeA)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='A')
                    accessCodesList.add('A');
                else if(timeB!=NULL && Decimal.valueOf(timeB)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='B')
                    accessCodesList.add('B');
                else if(timeC!=NULL && Decimal.valueOf(timeC)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='C')
                    accessCodesList.add('C');
                else if(timeD!=NULL && Decimal.valueOf(timeD)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='D')
                    accessCodesList.add('D');
                //Added condition for 'RTime' as SRTAccesscode from external system
                else if(srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='R'){
                    if(timeA!=NULL && decimal.valueOf(timeA)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='A')
                        accessCodesList.add('A');
                    else if(timeB!=NULL && decimal.valueOf(timeB)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='B')
                        accessCodesList.add('B');
                    else if(timeC!=NULL && decimal.valueOf(timeC)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='C')
                        accessCodesList.add('C');
                    else if(timeD!=NULL && decimal.valueOf(timeD)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='D')
                        accessCodesList.add('D');
                }
                if(timeR!=NULL && Decimal.valueOf(timeR)>0)
                    accessCodesList.add('R');
            }

        }catch(Exception e)  {
            system.debug('EXCEPTION of getAccessCodes method in CG_UtilityForSRT>>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return accessCodesList;
    }

    //for claims, logic is different from above Job method since no separate additional srt wrappers
    public List<String> getAccessCodesClaim(String timeA, String timeB, String timeC, String timeD, String timeR, String jobOrClaimAccessCode, String srtAccessCode, 
                                            String sectionType, Boolean isPopUpSRT){
        List<String> accessCodesList = new List<String>();
        system.debug('timeA>'+timeA+'>>timeB>>'+timeB+'>>timeC>>'+timeC+'>>timeD>>'+timeD+'>>timeR>>'+timeR);
        system.debug('jobOrClaimAccessCode>>'+jobOrClaimAccessCode+'>>srtAccessCode>>'+srtAccessCode+'>>sectionType>>'+sectionType);
        try{
            if( (sectionType !=null && (sectionType=='Diag' || sectionType=='Additional') ) || (srtAccessCode !=null && srtAccessCode=='A/B/C/D') ){
                if(timeA!=null && Decimal.valueOf(timeA)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='A')
                    accessCodesList.add('A');
                else if(timeB!=null && Decimal.valueOf(timeB)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='B')
                    accessCodesList.add('B');
                else if(timeC!=null && Decimal.valueOf(timeC)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='C')
                    accessCodesList.add('C');
                else if(timeD!=null && Decimal.valueOf(timeD)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='D')
                    accessCodesList.add('D');
                if(timeR!=null && Decimal.valueOf(timeR)>0)
                    accessCodesList.add('R');
            }else if(sectionType !=null && sectionType=='RepairOrFA'){
                if(timeA!=null && Decimal.valueOf(timeA)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='A')
                    accessCodesList.add('A');
                else if(timeB!=null && Decimal.valueOf(timeB)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='B')
                    accessCodesList.add('B');
                else if(timeC!=null && Decimal.valueOf(timeC)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='C')
                    accessCodesList.add('C');
                else if(timeD!=null && Decimal.valueOf(timeD)>0 && srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='D')
                    accessCodesList.add('D');
                //Added condition for 'RTime' as SRTAccesscode from external system
                else if(srtAccessCode !=null && srtAccessCode.trim() !='' && srtAccessCode.trim() =='R'){
                    if(timeA!=null && decimal.valueOf(timeA)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='A')
                        accessCodesList.add('A');
                    else if(timeB!=null && decimal.valueOf(timeB)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='B')
                        accessCodesList.add('B');
                    else if(timeC!=null && decimal.valueOf(timeC)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='C')
                        accessCodesList.add('C');
                    else if(timeD!=null && decimal.valueOf(timeD)>0 && jobOrClaimAccessCode !=null && jobOrClaimAccessCode.trim() !='' && jobOrClaimAccessCode.trim() =='D')
                        accessCodesList.add('D');
                }
                if(timeR!=null && Decimal.valueOf(timeR)>0)
                    accessCodesList.add('R');
            }

        }catch(Exception e)  {
            system.debug('EXCEPTION of getAccessCodes method in CG_UtilityForSRT>>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return accessCodesList;
    }

    public list<selectoption> getAccesscodejoboption(String timeA, String timeB, String timeC, String timeD, String timeR, String jobOrClaimAccessCode, String srtAccessCode,String sectionType){
        list<selectoption> accesscodelist = new list<selectoption>();
        try{
            list<string> tempstrlist= getAccessCodesJob(timeA,timeB,timeC,timeD,timeR,jobOrClaimAccessCode,srtAccessCode,sectionType);
            if(tempstrlist.size()>0){
                for(string sh:tempstrlist)
                {
                    accesscodelist.add(new selectoption(sh,sh));
                }
            }
        }
        catch(Exception e){
            system.debug('Exception in method getAccesscodejoboption:-'+e.getMessage()+'at line no:-'+e.getLineNumber());
        }
        return accesscodelist;
    }

    public list<selectoption> getAccesscodeclaimoption(String timeA, String timeB, String timeC, String timeD, String timeR, String jobOrClaimAccessCode, String srtAccessCode,String sectionType, Boolean isPopUpSRT){
        list<selectoption> accesscodelist = new list<selectoption>();
        try{
            list<string> tempstrlist= getAccessCodesClaim(timeA,timeB,timeC,timeD,timeR,jobOrClaimAccessCode,srtAccessCode,sectionType,isPopUpSRT);
            if(tempstrlist.size()>0){
                for(string sh:tempstrlist)
                {
                    accesscodelist.add(new selectoption(sh,sh));
                }
            }
        }
        catch(Exception e){
            system.debug('Exception in method getAccesscodejoboption:-'+e.getMessage()+'at line no:-'+e.getLineNumber());
        }
        return accesscodelist;
    }


    //Building logic for duplicate SRTs based on SRT Code/Account Code with AccessCode/%Requested
    public Static String buildDuplicateAccessCodesLogic(List<CSS_SRT__c> srtList, Boolean isJob, Boolean isClaim){
        System.debug('in buildDuplicateAccessCodesLogic...');
        List<CSS_SRT__c> tempList;
        String errorMsgs = '';
        try{
            //Prepare Data Maps
            //Preparing here duplicate SRTs based on SRT StepId & Account Code
            Map<String,List<CSS_SRT__c>> duplicateSRTsMap = new Map<String,List<CSS_SRT__c>>();
            Map<String,List<CSS_SRT__c>> duplicatePWSRTsMap = new Map<String,List<CSS_SRT__c>>();
            tempList = new List<CSS_SRT__c>();
            for(CSS_SRT__c srtObj: srtList){
                System.debug(' srtObj>:'+srtObj);
                if(srtObj.SRT_ID__c !=null && srtObj.SRT_ID__c=='99-999')
                    srtObj.Step_Id__c = '99-999';
                //For Parts Warranty Account Codes
                System.debug(' srtObj>:'+srtObj);
                System.debug('AccountCode_Formula__c SRT_ID__c>:'+srtObj.AccountCode_Formula__c);
                if((srtObj !=null && srtObj.AccountCode_Formula__c !=null && srtObj.AccountCode_Formula__c.length()>=2) && 
                   srtObj.AccountCode_Formula__c.Right(2)=='62' || srtObj.AccountCode_Formula__c.Right(2)=='97' || srtObj.AccountCode_Formula__c.Right(2)=='41' 
                   || srtObj.AccountCode_Formula__c.Right(2)=='35' || srtObj.AccountCode_Formula__c.Right(2)=='52' 
                   || srtObj.AccountCode_Formula__c.Right(2)=='65' || srtObj.AccountCode_Formula__c.Right(2)=='27'){ 
                    if(srtObj.SRT_ID__c=='99-902-00'){
                        System.debug('99-902-00 Intial SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Access_Code_Saved__c>:'+srtObj.Access_Code_Saved__c+' Id>:'+srtObj.Id);
                    }
                    if(duplicatePWSRTsMap.containsKey(srtObj.FailCode__c+'-'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c)){
                        tempList = duplicatePWSRTsMap.get(srtObj.FailCode__c+'-'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                        tempList.add(srtObj);
                        duplicatePWSRTsMap.put(srtObj.FailCode__c+'-'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c, tempList);
                        //system.debug('before srtKey:'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                    }else{
                        tempList = new List<CSS_SRT__c>();
                        tempList.add(srtObj);
                        duplicatePWSRTsMap.put(srtObj.FailCode__c+'-'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c, tempList);
                        //system.debug('after srtKey:'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                    }

                }else{ //For Regular Account Codes except Parts Warranty
                    if(duplicateSRTsMap.containsKey(srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c)){
                        tempList = duplicateSRTsMap.get(srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                        tempList.add(srtObj);
                        duplicateSRTsMap.put(srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c, tempList);
                        //system.debug('before srtKey:'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                    }else{
                        tempList = new List<CSS_SRT__c>();
                        tempList.add(srtObj);
                        duplicateSRTsMap.put(srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c, tempList);
                        //system.debug('after srtKey:'+srtObj.AccountCode_Formula__c+'-'+srtObj.Step_Id__c);
                    }
                }
            }
            system.debug('duplicateSRTsMap size:'+duplicateSRTsMap);

            //Check Access Code or %Requested same or not for duplicate SRTs
            tempList = new List<CSS_SRT__c>();
            List<CSS_SRT__c> updateList = new List<CSS_SRT__c>();
            //String errorMsgs = '';

            //Part1 Start: Logic for Regular Account Codes except Parts Warranty
            for(String srtKey: duplicateSRTsMap.keySet()){
                //system.debug('before srtKey:'+srtKey+' tempList>:'+tempList);
                tempList = duplicateSRTsMap.get(srtKey);
                if(tempList.size()<=1)
                    continue;
                system.debug('srtKey:'+srtKey+' tempList>:'+tempList);

                //Checking Access Code equal or not
                Boolean accessCodeFlag = false;
                String firstValue;
                Integer i =0;
                for(CSS_SRT__c srtObj: tempList){
                    System.debug('00 AccessCode SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Access_Code_Saved__c>:'+srtObj.Access_Code_Saved__c+' Id>:'+srtObj.Id);
                    if(i==0){
                        firstValue = srtObj.Access_Code_Saved__c;
                        System.debug('first accessCode>:'+firstValue);
                    }else{
                        if(firstValue != srtObj.Access_Code_Saved__c){
                            System.debug('second accessCode>:'+srtObj.Access_Code_Saved__c);
                            accessCodeFlag = true;
                            break;
                        }
                    }
                    i++;
                }

                //Checking % Requested equal or not
                Boolean percentRequestedFlag = false;
                firstValue = null;
                i=0;

                //Below is working fine for Job
                String percentReq;
                for(CSS_SRT__c srtObj: tempList){
                    System.debug('00 %Requested SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Hours_Percentage>:'+String.valueOf(srtObj.SRT_Warrantable__c)+' Warrantable>:'+srtObj.SRT_Warrantable__c);
                    /*if(srtObj.Type__c !=null && (srtObj.Type__c.trim()=='99Time' || srtObj.Type__c.trim()=='Field Action' || srtObj.Type__c.trim()=='Field Action Access'))
percentReq = String.valueOf(srtObj.SRT_Hours_Percentage__c);
else */
                    percentReq = srtObj.SRT_Warrantable__c;
                    if(i==0){
                        firstValue = percentReq;
                        System.debug('first percentReq>:'+firstValue);
                    }else{
                        if(firstValue != percentReq){
                            System.debug('second percentReq>:'+percentReq);
                            percentRequestedFlag = true;
                            break;
                        }
                    }
                    i++;
                }

                if(accessCodeFlag || percentRequestedFlag){
                    String srtCode = '';
                    for(CSS_SRT__c srtObj: tempList){
                        srtCode = srtObj.SRT_ID__c;
                        if(accessCodeFlag){
                            srtObj.Access_Code_Flag__c = true;
                        }
                        if(percentRequestedFlag){
                            srtObj.SRT_Warrantable_Flag__c = true;
                        }
                        updateList.add(srtObj);
                    }
                    //errorMsgSet.add('Access Code and % Requested should be same for '+srtCode);
                    if(errorMsgs==null || errorMsgs=='')
                        errorMsgs = Label.CG_Access_Code_and_Requested_should_be_the_same_for_each_entry_of+' '+srtCode;
                    //errorMsgs = 'Access Code and % Requested should be the same for each entry of '+srtCode;
                    else
                        errorMsgs = errorMsgs+'\\n'+Label.CG_Access_Code_and_Requested_should_be_the_same_for_each_entry_of+' '+srtCode;
                    //errorMsgs = errorMsgs+'\\n'+ 'Access Code and % Requested should be the same for each entry of '+srtCode;
                }

            }//end main map loop
            system.debug('Regular Account codes errorMsgs>>>:'+errorMsgs);
            //Part1 End

            //Part2 Start: Logic for Parts Warranty Account Codes 
            for(String srtKey: duplicatePWSRTsMap.keySet()){
                //system.debug('before srtKey:'+srtKey+' tempList>:'+tempList);
                tempList = duplicatePWSRTsMap.get(srtKey);
                if(tempList.size()<=1)
                    continue;
                system.debug('srtKey:'+srtKey+' tempList>:'+tempList);

                //Checking Access Code equal or not
                Boolean accessCodeFlag = false;
                String firstValue;
                Integer i =0;
                for(CSS_SRT__c srtObj: tempList){
                    System.debug('11 AccessCode SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Access_Code_Saved__c>:'+srtObj.Access_Code_Saved__c+' Id>:'+srtObj.Id);
                    if(i==0){
                        firstValue = srtObj.Access_Code_Saved__c;
                        System.debug('first accessCode>:'+firstValue);
                    }else{
                        if(firstValue != srtObj.Access_Code_Saved__c){
                            System.debug('second accessCode>:'+srtObj.Access_Code_Saved__c);
                            accessCodeFlag = true;
                            break;
                        }
                    }
                    i++;
                }

                //Checking % Requested equal or not
                Set<String> percentRequestedSet = new Set<String>();
                Boolean percentRequestedFlag = false;
                firstValue = null;
                i=0;

                //Below is working fine for Job
                if(isJob !=null && isJob){
                    for(CSS_SRT__c srtObj: tempList){
                        System.debug('11 %Requested Job SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Hours_Percentage>:'+String.valueOf(srtObj.SRT_Warrantable__c)+' Warrantable>:'+srtObj.SRT_Warrantable__c);
                        if(i==0){
                            //if(srtObj.AccountCode_Formula__c.Right(2)=='65' || srtObj.AccountCode_Formula__c.Right(2)=='27')
                            //firstValue = String.valueOf(srtObj.SRT_Hours_Percentage__c);
                            //else 
                            firstValue = srtObj.SRT_Warrantable__c; //need to check 99Time type here?
                            System.debug('first firstValue>:'+firstValue);
                        }else{
                            /*if(srtObj.AccountCode_Formula__c.Right(2)=='65' || srtObj.AccountCode_Formula__c.Right(2)=='27'){
if(firstValue != String.valueOf(srtObj.SRT_Hours_Percentage__c)){
System.debug('second SRT_Hours_Percentage__c>:'+srtObj.SRT_Hours_Percentage__c);
percentRequestedFlag = true;
break;
}
}else*/ if(firstValue != srtObj.SRT_Warrantable__c){ //need to check 99Time type here?
    System.debug('second SRT_Warrantable__c>:'+srtObj.SRT_Warrantable__c);
    percentRequestedFlag = true;
    break;
}
                        }
                        i++;
                    }
                }

                if(isClaim !=null && isClaim){
                    String percentReq;
                    for(CSS_SRT__c srtObj: tempList){
                        System.debug('11 %Requested Claim SRT_ID__c>:'+srtObj.SRT_ID__c+' Step_Id__c>:'+srtObj.Step_Id__c+' Type>:'+srtObj.Type__c+' Hours_Percentage>:'+String.valueOf(srtObj.SRT_Warrantable__c)+' Warrantable>:'+srtObj.SRT_Warrantable__c);
                        /*percentReq = '';
if(srtObj.Type__c !=null && (srtObj.Type__c.trim()=='99Time' || srtObj.Type__c.trim()=='Field Action' || srtObj.Type__c.trim()=='Field Action Access'))
percentReq = String.valueOf(srtObj.SRT_Hours_Percentage__c); //is not needed?
else*/
                        percentReq = srtObj.SRT_Warrantable__c;
                        if(i==0){
                            firstValue = percentReq;
                            System.debug('first percentReq>:'+firstValue);
                        }else{
                            if(firstValue != percentReq){
                                System.debug('second percentReq>:'+percentReq);
                                percentRequestedFlag = true;
                                break;
                            }
                        }
                        i++;
                    }
                }

                if(accessCodeFlag || percentRequestedFlag){
                    String srtCode = '';
                    for(CSS_SRT__c srtObj: tempList){
                        srtCode = srtObj.SRT_ID__c;
                        if(accessCodeFlag){
                            srtObj.Access_Code_Flag__c = true;
                        }
                        if(percentRequestedFlag){
                            srtObj.SRT_Warrantable_Flag__c = true;
                        }
                        updateList.add(srtObj);
                    }
                    //errorMsgSet.add('Access Code and % Requested should be same for '+srtCode);
                    if(errorMsgs==null || errorMsgs=='')
                        errorMsgs = Label.CG_Access_Code_and_Requested_should_be_the_same_for_each_entry_of+' '+srtCode;
                    //errorMsgs = 'Access Code and % Requested should be the same for each entry of '+srtCode;
                    else
                        errorMsgs = errorMsgs+'\\n'+Label.CG_Access_Code_and_Requested_should_be_the_same_for_each_entry_of+' '+srtCode;
                    //errorMsgs = errorMsgs+'\\n'+ 'Access Code and % Requested should be the same for each entry of '+srtCode;
                }

            }//end main map loop
            system.debug('Parts Warranty Account codes errorMsgs>>>:'+errorMsgs);
            //Part2 End

            if(updateList !=null && updateList.size()>0){
                update updateList;
            }

        }catch (exception ex){
            system.debug('catch exception in buildDuplicateAccessCodesLogic from CG_UtilityForSRT class at line number>:'+ex.getLineNumber()+' with error message '+ex.getMessage());
        }
        return errorMsgs;
    }


    //Admin SRT 00-902-00 error message logic below - GSSC-143
    public static void executeAdminSRT902LogicForJob(ID Wid, css_job_order__c workJob){
        system.debug('in executeAdminSRT902LogicForJob Wid>>>:'+Wid);
        try{
            //fetch Existing Admin SRT
            Boolean srt902NOTExistFlag = false;
            Boolean travelExistFlag = false;
            if(Wid != null && workJob !=null && workJob.Repair_Location__c == 'Mobile'){
                system.debug('22 in executeAdminSRT902LogicForJob Wid>>>:'+Wid);
                List<CSS_SRT__c> existingAdminSRT = new List<CSS_SRT__c>([select Id,step_id__c,AccountCode_Formula__c, SRT_Warrantable__c, Assignment__c FROM CSS_SRT__c 
                                                                          where Job_Order__c =:Wid AND Type__c = 'Admin' AND SRT_Type__c = 'Admin' AND srt_id__c = '00-902-00'
                                                                          Limit 1]);
                if(existingAdminSRT !=null && existingAdminSRT.size()>0 && existingAdminSRT.get(0).AccountCode_Formula__c !=null 
                   && existingAdminSRT.get(0).AccountCode_Formula__c.trim() !='' && existingAdminSRT.get(0).AccountCode_Formula__c !='Select One'){
                    system.debug('33 in executeAdminSRT902LogicForJob srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                    CSS_SRT__c srtRec = existingAdminSRT.get(0);
                    Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                    List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
                    //Check here 902 account code formats of SRT & Parts
                    lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                FROM CSS_Parts_Options__c WHERE Service_Job__c =: Wid AND Account_Code__c != null AND Account_Code__c != '' 
                                AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                AND RecordTypeId =: recTypeIdOC AND Item__c='COMMERCIAL TRAVEL' AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                    if(lstParts !=null && lstParts.size()>0){
                        travelExistFlag = true;
                    }
                    if(!travelExistFlag){
                        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                        lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                    FROM CSS_Parts_Options__c WHERE Service_Job__c =: Wid AND Account_Code__c != null AND Account_Code__c != '' 
                                    AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                    AND RecordTypeId =: recTypeIdTTML AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                        if(lstParts !=null && lstParts.size()>0){
                            travelExistFlag = true;
                        }
                    }
                }else{
                    srt902NOTExistFlag = true;
                }
            }else{
                srt902NOTExistFlag = true;
            }
            system.debug('44 in executeAdminSRT902LogicForJob srt902NOTExistFlag>>>:'+srt902NOTExistFlag);

            //update Job with Admin SRT 00-902-00 error message
            //Checking whether 902 SRT exist along with Repair_Location__c='Mobile' or not 
            if(srt902NOTExistFlag){
                system.debug('55 in executeAdminSRT902LogicForJob srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                if(workJob !=null && workJob.SRT_902_Error_Message__c !=null && workJob.SRT_902_Error_Message__c.trim() !=''){
                    workJob.SRT_902_Error_Message__c = '';
                    update workJob;
                }
            }else{
                system.debug('66 in executeAdminSRT902LogicForJob travelExistFlag>>>:'+travelExistFlag);
                //Checking here TTML/OC Travel present or not
                if(travelExistFlag){
                    system.debug('77 in executeAdminSRT902LogicForJob travelExistFlag>>>:'+travelExistFlag);
                    //Need to nullify SRT error message if exists
                    if(workJob !=null && workJob.SRT_902_Error_Message__c !=null && workJob.SRT_902_Error_Message__c.trim() !=''){
                        workJob.SRT_902_Error_Message__c = '';
                        update workJob;
                    }
                }else{
                    system.debug('88 in executeAdminSRT902LogicForJob travelExistFlag>>>:'+travelExistFlag);
                    if(workJob !=null && (workJob.SRT_902_Error_Message__c ==null || workJob.SRT_902_Error_Message__c.trim() =='')){
                        workJob.SRT_902_Error_Message__c = Label.SRT_00_902_is_present_and_travel_is_not_entered; //'SRT 00-902 is present and travel is not entered';
                        update workJob;
                    }
                }
            }

        }catch(Exception ex){
            System.debug('in catch of executeAdminSRT902LogicForJob of CG_UtilityForSRT >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    //Admin SRT 00-902-00 error message logic below - GSSC-143
    public static void executeAdminSRT902LogicForClaims(Id cId, CSS_Claims__c claimsRec){
        system.debug('in executeAdminSRT902LogicForClaims cId>>>:'+cId);
        try{
            //fetch Existing Admin SRT
            Boolean srt902NOTExistFlag = false;
            Boolean travelExistFlag = false;
            if(cId != null && claimsRec !=null && claimsRec.Repair_Location__c == 'Mobile'){
                system.debug('22 in executeAdminSRT902LogicForClaims cId>>>:'+cId);
                List<CSS_SRT__c> existingAdminSRT = new List<CSS_SRT__c>([select Id,step_id__c,AccountCode_Formula__c, SRT_Warrantable__c, Assignment__c FROM CSS_SRT__c 
                                                                          where CSS_Claims__c =:cId AND Type__c = 'Admin' AND SRT_Type__c = 'Admin' AND srt_id__c = '00-902-00'
                                                                          Limit 1]);
                if(existingAdminSRT !=null && existingAdminSRT.size()>0 && existingAdminSRT.get(0).AccountCode_Formula__c !=null 
                   && existingAdminSRT.get(0).AccountCode_Formula__c.trim() !='' && existingAdminSRT.get(0).AccountCode_Formula__c !='Select One'){
                    system.debug('33 in executeAdminSRT902LogicForClaims cId>>>:'+cId);
                    CSS_SRT__c srtRec = existingAdminSRT.get(0);
                    Id recTypeIdOC = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'OtherClaimables');
                    List<CSS_Parts_Options__c> lstParts = new List<CSS_Parts_Options__c>();
                    //Check here 902 account code formats of SRT & Parts
                    lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: cId AND Account_Code__c != null AND Account_Code__c != '' 
                                AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                AND RecordTypeId =: recTypeIdOC AND Item__c='COMMERCIAL TRAVEL' AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                    if(lstParts !=null && lstParts.size()>0){
                        travelExistFlag = true;
                    }
                    if(!travelExistFlag){
                        Id recTypeIdTTML = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'TTML');
                        lstParts = [SELECT Id, Item__c, Account_Code__c, Get_Fail_Code_Formula__c, Fail_Code__c, RecordTypeId, Parts_Type__c 
                                    FROM CSS_Parts_Options__c WHERE CSS_Claims__c =: cId AND Account_Code__c != null AND Account_Code__c != '' 
                                    AND Account_Code__c != 'Select One' and Account_Code__c =:srtRec.AccountCode_Formula__c 
                                    AND RecordTypeId =: recTypeIdTTML AND Parts_Type__c != 'Custom' AND selected_part__c = true];
                        if(lstParts !=null && lstParts.size()>0){
                            travelExistFlag = true;
                        }
                    }
                }else{
                    srt902NOTExistFlag = true;
                }
            }else{
                srt902NOTExistFlag = true;
            }
            system.debug('44 in executeAdminSRT902LogicForClaims srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
            //update Job with Admin SRT 00-902-00 error message
            //Checking whether 902 SRT exist along with Repair_Location__c='Mobile' or not 
            if(srt902NOTExistFlag){
                system.debug('55 in executeAdminSRT902LogicForClaims srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                if(claimsRec !=null && claimsRec.SRT_902_Error_Message__c !=null && claimsRec.SRT_902_Error_Message__c.trim() !=''){
                    claimsRec.SRT_902_Error_Message__c = '';
                    update claimsRec;
                }
            }else{
                system.debug('66 in executeAdminSRT902LogicForClaims srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                //Checking here TTML/OC Travel present or not
                if(travelExistFlag){
                    system.debug('77 in executeAdminSRT902LogicForClaims srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                    //Need to nullify SRT error message if exists
                    if(claimsRec !=null && claimsRec.SRT_902_Error_Message__c !=null && claimsRec.SRT_902_Error_Message__c.trim() !=''){
                        claimsRec.SRT_902_Error_Message__c = '';
                        update claimsRec;
                    }
                }else{
                    system.debug('88 in executeAdminSRT902LogicForClaims srt902NOTExistFlag>>>:'+srt902NOTExistFlag);
                    if(claimsRec !=null && (claimsRec.SRT_902_Error_Message__c ==null || claimsRec.SRT_902_Error_Message__c.trim() =='')){
                        claimsRec.SRT_902_Error_Message__c = Label.SRT_00_902_is_present_and_travel_is_not_entered; //'SRT 00-902 is present and travel is not entered';
                        update claimsRec;
                    }
                }
            }

        }catch(Exception ex){
            System.debug('in catch of executeAdminSRT902LogicForClaims of CG_UtilityForSRT >>>>>>>>>>>>>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }


    //Calibration fields error message logic below - GSSC-30
    public static void checkCalibFieldsForSRT(List<CSS_SRT__c> newList){
        system.debug('in checkCalibFieldsForSRT...');
        Id cId;
        try{
            for(CSS_SRT__c srtNew : newList){
                if(!string.isBlank(srtNew.CSS_Claims__c)){
                    cId = srtNew.CSS_Claims__c;
                }
            }

            updateCalibFieldsError(cId);
            
        }catch(Exception ex){
            System.debug('in catch of checkCalibFieldsForSRT of CG_UtilityForSRT >>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }
    
	//Calibration fields error message logic below - GSSC-30
    public static void checkCalibFieldsForClaim(List<CSS_PSN__c> newList){
        system.debug('in checkCalibFieldsForClaim...');
        Id cId;
        try{
            for(CSS_PSN__c psnNew : newList){
                if(!string.isBlank(psnNew.CSS_Claims__c)){
                    cId = psnNew.CSS_Claims__c;
                }
            }

            updateCalibFieldsError(cId);
            
        }catch(Exception ex){
            System.debug('in catch of checkCalibFieldsForClaim of CG_UtilityForSRT >>>is :: '+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

    
    //Calibration fields error message logic below - GSSC-30
    public static void updateCalibFieldsError(Id cId){
        system.debug('in updateCalibFieldsError...');
        CSS_Claims__c claimsRec;
        CSS_PSN__c psnRec;
        try{
            Boolean isCalibrationFieldsBlank = false;
            if(cId != null){
                //List<CSS_PSN__c> psnPrimaryList = new List<CSS_PSN__c>([Select Id,Name,PSN__c,Primary__c,Calibration_Before__c,Calibration_After__c,Revision_Before__c,Revision_After__c from CSS_PSN__c where Primary__c=true and CSS_Claims__c=:cId Limit 1]);
                List<CSS_Claims__c> claimsList = new List<CSS_Claims__c>([select Id,Name,Multi_PSN_Claim__c,(Select Id,Name,PSN__c,Primary__c,Calibration_Before__c,Calibration_After__c,Revision_Before__c,Revision_After__c from CSS_PSNs__r where Primary__c=true Limit 1) FROM CSS_Claims__c where Id =:cId]);
                if(claimsList !=null && claimsList.size()>0){
                    claimsRec = claimsList.get(0);
                    if(claimsRec.CSS_PSNs__r !=null && claimsRec.CSS_PSNs__r.size()>0)
                        psnRec = claimsRec.CSS_PSNs__r.get(0);
                }

                if(claimsRec !=null && psnRec !=null){
                    if(psnRec.Revision_Before__c == null || psnRec.Revision_Before__c.trim() == '' || psnRec.Revision_After__c == null || psnRec.Revision_After__c.trim() == ''
                       || psnRec.Calibration_Before__c == null || psnRec.Calibration_Before__c.trim() == '' || psnRec.Calibration_After__c == null || psnRec.Calibration_After__c.trim() == ''){
                        //fetch ECM_Flag__c SRT
                        List<CSS_SRT__c> ecmFlagSRTList = new List<CSS_SRT__c>([select Id, ECM_Flag__c, isPerformed__c, SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =:cId and ECM_Flag__c = true and (isPerformed__c=true or SRT_AccessiblityCheck__c=true) Limit 1]);
                        if(ecmFlagSRTList !=null && ecmFlagSRTList.size()>0){
                            isCalibrationFieldsBlank = true;
                        }
                    }else if(claimsRec.Multi_PSN_Claim__c){
                        List<CSS_PSN__c> psnList = new List<CSS_PSN__c>([select Id,Primary__c,Calibration_Before__c,Calibration_After__c,Revision_Before__c,Revision_After__c FROM CSS_PSN__c where CSS_Claims__c =:cId AND Primary__c != true]);
                        if(psnList !=null && psnList.size()>0){
                            Boolean isMultiCalibFieldsBlank = false;
                            for(CSS_PSN__c psnObj :psnList){
                                if(psnObj.Revision_Before__c == null || psnObj.Revision_Before__c.trim() == '' || psnObj.Revision_After__c == null || psnObj.Revision_After__c.trim() == ''
                                   || psnObj.Calibration_Before__c == null || psnObj.Calibration_Before__c.trim() == '' || psnObj.Calibration_After__c == null || psnObj.Calibration_After__c.trim() == ''){
                                    isMultiCalibFieldsBlank = true;
                                    break;
                                }
                            }
                            //fetch ECM_Flag__c SRT
                            if(isMultiCalibFieldsBlank){
                                List<CSS_SRT__c> ecmFlagSRTList = new List<CSS_SRT__c>([select Id, ECM_Flag__c, isPerformed__c, SRT_AccessiblityCheck__c FROM CSS_SRT__c where CSS_Claims__c =:cId and ECM_Flag__c = true and (isPerformed__c=true or SRT_AccessiblityCheck__c=true) Limit 1]);
                                if(ecmFlagSRTList !=null && ecmFlagSRTList.size()>0){
                                    isCalibrationFieldsBlank = true;
                                }
                            }

                        }
                    }
                    if(isCalibrationFieldsBlank){
                        claimsRec.isCalibrationFieldsBlank__c = true;
                    }else{
                        claimsRec.isCalibrationFieldsBlank__c = false;
                    }
                    update claimsRec;

                }
            }

        }catch(Exception ex){
            System.debug('in catch of updateCalibFieldsError of CG_UtilityForSRT >>>:'+ex.getLineNumber()+' Exception Message>>>is:'+ex.getMessage());
        }
    }

}