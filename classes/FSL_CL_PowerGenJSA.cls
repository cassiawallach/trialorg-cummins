public class FSL_CL_PowerGenJSA
{
    Public String UserName {get;set;}
    Public String WWID {get;set;}
    Public Id pgId {get;set;}
    Public WorkOrder workJob {get;set;}
    Public String currentDateTime{get;set;}
    public Datetime formLoadTime{get;set;}
    public CSS_JobForms__c PowerGenForm {get;set;}
    public Id formRecTypeId;
    public string powerGenformId;
    public CSS_JobForms__c jobPowerGenForm;
    public string Copy {get;set;}

    public FSL_CL_PowerGenJSA()
    {
        getDetails() ;
    }


    public void getDetails(){
        try{
            UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName()); 
            currentDateTime = system.now().format('dd MMM YYYY hh:mm a z');
            formLoadTime = System.now();
            String UserID = UserInfo.getUserId();
            User UserData = [Select id, FederationIdentifier from User where id=:UserID];
            WWID = UserData.FederationIdentifier;

            pgId = ApexPages.currentPage().getParameters().get('id');
            //workJob = [Select id,name from CSS_Job_Order__c where id=:pgId]; 
            workJob = [Select id,WorkOrderNumber from WorkOrder where id=:pgId]; 
            formRecTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('PowerGenJSA').getRecordTypeId();
            system.debug('formRecTypeId' + ' ' + formRecTypeId);
            powerGenformId=ApexPages.CurrentPage().getParameters().get('jformId');
            Copy = ApexPages.CurrentPage().getParameters().get('copybtn');
            system.debug('powerGenformId>>>>>' + powerGenformId);
            if(powerGenformId!=null){
                PowerGenForm = [Select id,createddate,CreatedBy.Name, createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c,Co_Worker_Name__c,Task_Description__c,Task_Category__c,
                                Job_Location__c,PowerGenVoltageEquipment__c,PowerGenFlashHazardBoundary__c,PowerGenPrepare1__c,PowerGenPPELevel__c,PowerGenPrepare2__c,PowerGenPrepare5__c,PowerGenPrepare6__c,PowerGenPrepare7__c,PREPARE2__c,PREPARE3__c,PowerGenLoadBankTest1__c,PowerGenLoadBankTest2__c,
                                LiftingAccess1__c,LiftingAccess2__c,LiftingAccess3__c,PowerGenTE1__c,ToolingEquipment1__c,ToolingEquipment2__c,PPE1__c,PPE2__c,PowerGenPPE__c,LoneWorking__c,LoneWorkingTextArea__c,
                                MOVING_MACHINERY__c,MOVING_MACHINERY_Controls__c,MOVING_MACHINERY_What_Is_Strange__c,
                                LIFTING_OPERATOIONS__c,LIFTING_OPERATOIONS_Controls__c, LIFTING_OPERATOIONS_What_Is_Strange__c, MOVING_VEHICLES__c, MOVING_VEHICLES_Controls__c,
                                MOVING_VEHICLES_What_Is_Strange__c, WORK_WITH_ELECTRICITY__c,WORK_WITH_ELECTRICITY_Control__c,WORK_WITH_ELECTRICITY_What_Is_Strange__c,
                                WORK_AT_HEIGHT__c,WORK_AT_HEIGHT_Controls__c,WORK_AT_HEIGHT_What_Is_Strange__c,FIRE_EXPLOSION_OR_ARC_FLASH__c,FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c,
                                FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c,OTHER1__c,OTHER1_Controls__c,OTHER1_What_Is_Strange__c,OTHER2__c,OTHER2_Controls__c,OTHER2_What_Is_Strange__c, 
                                Natural_Gas_CNG_LNG__c,Animals_or_Insects__c , Overhead_Power_Lines__c,High_Noise_Level__c,Exhaust_Gases__c, Hot_Work__c, Restricted_Work_Spaces__c,Confined_Work_Spaces__c, Hygiene_Hazards__c,
                                Flammable_Gas_Liquid__c, Ladder_or_Step_Ladder__c, Static_Access_Platform__c, Mobile_Work_Platform__c, Step_Stool__c,Set_to_Order__c,Dispose_Scrap__c,Cleanliness__c,
                                Struck_by_or_Against__c,Caught_or_Trapped_By__c,Hazardous_Energy__c,Dust_or_Dirt__c,Projectile_Hazard__c, Wet_or_Oily_Floor__c,Trailing_Cables__c, Uneven_Ground_Gravel__c,
                                Elevated_Area_Mezzanine__c,Roof_Top__c, Snow_Mud_or_Ice__c, Floor_Pit__c,Work_with_Contractors__c,General_Public__c,Customer_Employees__c,Leaks_or_Spills__c,Fumes_or_Smoke__c,
                                Waste_Disposal__c ,Use_of_Chemicals__c, Excessive__c, Repetitive_Work__c,Stressful_Posure__c,Contact_Stress__c,Kneeling_Crawling__c, Heavy_Lifting__c,Vibration__c,
                                Extreme_Heat__c,Extreme_Cold__c,High_Winds__c, Storm_Conditions__c,Rain__c,Snow_Ice__c,High_Altitude__c,IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c,Manager_Name__c,
                                Manager_Contact_Tel_No__c,Understand_the_equipment__c,Inform_Affected_Employees__c,Shutt_Off_Power__c,Isolate_the_Machine_from_All_Energy_Sour__c,Lockout_the_Energy__c,
                                Control_Stored_or_Secondary_Energy__c,Verify_the_Lackout__c,Maintain_the_Lackout__c,Make_sure_the_area_is_Clear_of_personal__c,Remove_locks__c,Notifiy_the_affected_Employees_that_the__c,
                                Test_the_Machine__c,Notify_the_affected_Employees_that_the_M__c,Form_Start_Time__c, Form_Initiate_Time__c from CSS_JobForms__c where Id=:powerGenformId and ServiceJob__c = :pgId limit 1 ];
                system.debug('PowerGenForm>>>>>' + PowerGenForm);
                UserName = PowerGenForm.CreatedBy.Name;
                WWID = [Select id, FederationIdentifier from User where id=:PowerGenForm.CreatedById][0].FederationIdentifier;
            	currentDateTime = PowerGenForm.Form_Initiate_Time__c.format('dd MMM YYYY hh:mm a z'); //PHOEN-148, added by Naveen Goud
            }
            else{
                PowerGenForm = new CSS_JobForms__c();
                // InShopForm.Service_Job__c = workJob.Id;
            }
        }
        catch(Exception e){
            system.debug('Catch block of FSL_CL_PowerGenJSA constructor' + e.getMessage() +  'Line Num >>>' + e.getLineNumber());
        }
    }
    
    public List<SelectOption> getTaskCategory()
    {
        String  RecTypeID= string.valueOf(formRecTypeId);
        system.debug('RecTypeID>>>>' +RecTypeID);
        Map<String,String> tempResult =  getValues('CSS_JobForms__c',RecTypeID,'Task_Category__c');
        List<SelectOption> resultVar = new List<SelectOption>();
        for(String mapKeySetVar : tempResult.keySet()){
           /* String temp;
            if(mapKeySetVar.contains('-&gt;')){
                mapKeySetVar = mapKeySetVar.replace('-&gt;','->');
                tempResult.put(mapKeySetVar,mapKeySetVar);
            }
            else if(mapKeySetVar.contains('&lt;-')){
                mapKeySetVar = mapKeySetVar.replace('&lt;-','<-');
                tempResult.put(mapKeySetVar,mapKeySetVar);
            }*/
            resultVar.add(new selectOption(mapKeySetVar,tempResult.get(mapKeySetVar)));
        }
        return resultVar;

    } 
    public List<SelectOption> getPowerGenPrepare1() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',system.Label.css_Yes));
        options.add(new SelectOption('No',system.Label.CSS_No));
        options.add(new SelectOption('NA',system.Label.CSS_NA));
        return options;
    }



    public List<SelectOption> getPPE1() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',system.Label.css_Yes));
        options.add(new SelectOption('No',system.Label.CSS_No));
        return options;
    }


    public void insertPowerGenJSARecord(){

        system.debug('inside insertInShopJSARecord');
        jobPowerGenForm = new CSS_JobForms__c();
        jobPowerGenForm.ServiceJob__c = pgId;
        if(PowerGenForm.Id != null )
            jobPowerGenForm.Id =PowerGenForm.Id;
        jobPowerGenForm.RecordTypeId = formRecTypeId;
        jobPowerGenForm.JSA_File_Name__c = UserInfo.getFirstName()+UserInfo.getLastName()+'-'+ System.now().format('dd MMM YYYY hh:mm a z');
        jobPowerGenForm.JSA_CreatorName__c = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
        jobPowerGenForm.JSA_TimeZone__c = System.now().format('hh:mma z') + '-' + System.now().format('MM/dd/YYYY');

        jobPowerGenForm.Co_Worker_Name__c = PowerGenForm.Co_Worker_Name__c;
        jobPowerGenForm.Task_Description__c = PowerGenForm.Task_Description__c;
        jobPowerGenForm.Task_Category__c = PowerGenForm.Task_Category__c;
        jobPowerGenForm.Job_Location__c = PowerGenForm.Job_Location__c;
        jobPowerGenForm.PowerGenVoltageEquipment__c = PowerGenForm.PowerGenVoltageEquipment__c;
        jobPowerGenForm.PowerGenFlashHazardBoundary__c = PowerGenForm.PowerGenFlashHazardBoundary__c;
        jobPowerGenForm.PowerGenPPELevel__c = PowerGenForm.PowerGenPPELevel__c;

        jobPowerGenForm.PowerGenPrepare1__c = PowerGenForm.PowerGenPrepare1__c;
        jobPowerGenForm.PowerGenPrepare2__c = PowerGenForm.PowerGenPrepare2__c;
        jobPowerGenForm.PREPARE3__c = PowerGenForm.PREPARE3__c;
        jobPowerGenForm.PREPARE2__c = PowerGenForm.PREPARE2__c;
        jobPowerGenForm.PowerGenPrepare5__c = PowerGenForm.PowerGenPrepare5__c;
        jobPowerGenForm.PowerGenPrepare6__c = PowerGenForm.PowerGenPrepare6__c;
        jobPowerGenForm.PowerGenPrepare7__c = PowerGenForm.PowerGenPrepare7__c;

        jobPowerGenForm.PowerGenLoadBankTest1__c = PowerGenForm.PowerGenLoadBankTest1__c;
        jobPowerGenForm.PowerGenLoadBankTest2__c = PowerGenForm.PowerGenLoadBankTest2__c;

        jobPowerGenForm.ToolingEquipment1__c = PowerGenForm.ToolingEquipment1__c;
        jobPowerGenForm.ToolingEquipment2__c = PowerGenForm.ToolingEquipment2__c;
        jobPowerGenForm.PowerGenTE1__c = PowerGenForm.PowerGenTE1__c;

        jobPowerGenForm.LiftingAccess1__c = PowerGenForm.LiftingAccess1__c;
        jobPowerGenForm.LiftingAccess2__c = PowerGenForm.LiftingAccess2__c;
        jobPowerGenForm.LiftingAccess3__c = PowerGenForm.LiftingAccess3__c;

        jobPowerGenForm.PPE1__c = PowerGenForm.PPE1__c;
        jobPowerGenForm.PPE2__c = PowerGenForm.PPE2__c;
        jobPowerGenForm.PowerGenPPE__c = PowerGenForm.PowerGenPPE__c;

        jobPowerGenForm.LoneWorking__c = PowerGenForm.LoneWorking__c;
        jobPowerGenForm.LoneWorkingTextArea__c = PowerGenForm.LoneWorkingTextArea__c;
        if(PowerGenForm.Form_Start_Time__c == null) {
            jobPowerGenForm.Form_Start_Time__c = currentDateTime; 
            jobPowerGenForm.Form_Initiate_Time__c = formLoadTime;
        } 

        jobPowerGenForm.MOVING_VEHICLES__c = PowerGenForm.MOVING_VEHICLES__c;
        jobPowerGenForm.MOVING_VEHICLES_Controls__c = PowerGenForm.MOVING_VEHICLES_Controls__c;
        jobPowerGenForm.MOVING_VEHICLES_What_Is_Strange__c = PowerGenForm.MOVING_VEHICLES_What_Is_Strange__c;
        jobPowerGenForm.WORK_WITH_ELECTRICITY__c = PowerGenForm.WORK_WITH_ELECTRICITY__c;
        jobPowerGenForm.WORK_WITH_ELECTRICITY_Control__c = PowerGenForm.WORK_WITH_ELECTRICITY_Control__c;
        jobPowerGenForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c = PowerGenForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c;
        jobPowerGenForm.MOVING_MACHINERY__c = PowerGenForm.MOVING_MACHINERY__c;
        jobPowerGenForm.MOVING_MACHINERY_Controls__c = PowerGenForm.MOVING_MACHINERY_Controls__c;
        jobPowerGenForm.MOVING_MACHINERY_What_Is_Strange__c = PowerGenForm.MOVING_MACHINERY_What_Is_Strange__c;
        jobPowerGenForm.LIFTING_OPERATOIONS__c = PowerGenForm.LIFTING_OPERATOIONS__c;
        jobPowerGenForm.LIFTING_OPERATOIONS_Controls__c = PowerGenForm.LIFTING_OPERATOIONS_Controls__c;
        jobPowerGenForm.LIFTING_OPERATOIONS_What_Is_Strange__c = PowerGenForm.LIFTING_OPERATOIONS_What_Is_Strange__c;
        jobPowerGenForm.WORK_AT_HEIGHT__c = PowerGenForm.WORK_AT_HEIGHT__c;
        jobPowerGenForm.WORK_AT_HEIGHT_Controls__c = PowerGenForm.WORK_AT_HEIGHT_Controls__c;
        jobPowerGenForm.WORK_AT_HEIGHT_What_Is_Strange__c = PowerGenForm.WORK_AT_HEIGHT_What_Is_Strange__c;
        jobPowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH__c = PowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH__c;
        jobPowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c = PowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c;
        jobPowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c = PowerGenForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c;
        jobPowerGenForm.OTHER1__c = PowerGenForm.OTHER1__c;
        jobPowerGenForm.OTHER1_Controls__c = PowerGenForm.OTHER1_Controls__c;
        jobPowerGenForm.OTHER1_What_Is_Strange__c = PowerGenForm.OTHER1_What_Is_Strange__c;
        jobPowerGenForm.OTHER2__c = PowerGenForm.OTHER2__c;
        jobPowerGenForm.OTHER2_Controls__c = PowerGenForm.OTHER2_Controls__c;
        jobPowerGenForm.OTHER2_What_Is_Strange__c = PowerGenForm.OTHER2_What_Is_Strange__c;

        jobPowerGenForm.Natural_Gas_CNG_LNG__c = PowerGenForm.Natural_Gas_CNG_LNG__c;
        jobPowerGenForm.Animals_or_Insects__c = PowerGenForm.Animals_or_Insects__c;
        jobPowerGenForm.Overhead_Power_Lines__c = PowerGenForm.Overhead_Power_Lines__c;
        jobPowerGenForm.Exhaust_Gases__c = PowerGenForm.Exhaust_Gases__c;
        jobPowerGenForm.High_Noise_Level__c = PowerGenForm.High_Noise_Level__c;
        jobPowerGenForm.Hot_Work__c = PowerGenForm.Hot_Work__c;
        jobPowerGenForm.Restricted_Work_Spaces__c = PowerGenForm.Restricted_Work_Spaces__c;
        jobPowerGenForm.Confined_Work_Spaces__c = PowerGenForm.Confined_Work_Spaces__c;
        jobPowerGenForm.Hygiene_Hazards__c = PowerGenForm.Hygiene_Hazards__c;
        jobPowerGenForm.Flammable_Gas_Liquid__c = PowerGenForm.Flammable_Gas_Liquid__c;

        jobPowerGenForm.Ladder_or_Step_Ladder__c = PowerGenForm.Ladder_or_Step_Ladder__c;
        jobPowerGenForm.Static_Access_Platform__c = PowerGenForm.Static_Access_Platform__c;
        jobPowerGenForm.Mobile_Work_Platform__c = PowerGenForm.Mobile_Work_Platform__c;
        jobPowerGenForm.Step_Stool__c = PowerGenForm.Step_Stool__c;

        jobPowerGenForm.Set_to_Order__c = PowerGenForm.Set_to_Order__c;
        jobPowerGenForm.Dispose_Scrap__c = PowerGenForm.Dispose_Scrap__c;
        jobPowerGenForm.Cleanliness__c = PowerGenForm.Cleanliness__c;

        jobPowerGenForm.Struck_by_or_Against__c = PowerGenForm.Struck_by_or_Against__c;
        jobPowerGenForm.Caught_or_Trapped_By__c = PowerGenForm.Caught_or_Trapped_By__c;
        jobPowerGenForm.Hazardous_Energy__c = PowerGenForm.Hazardous_Energy__c;
        jobPowerGenForm.Dust_or_Dirt__c = PowerGenForm.Dust_or_Dirt__c;
        jobPowerGenForm.Projectile_Hazard__c = PowerGenForm.Projectile_Hazard__c;

        jobPowerGenForm.Wet_or_Oily_Floor__c = PowerGenForm.Wet_or_Oily_Floor__c;
        jobPowerGenForm.Trailing_Cables__c = PowerGenForm.Trailing_Cables__c;
        jobPowerGenForm.Uneven_Ground_Gravel__c = PowerGenForm.Uneven_Ground_Gravel__c;
        jobPowerGenForm.Elevated_Area_Mezzanine__c = PowerGenForm.Elevated_Area_Mezzanine__c;
        jobPowerGenForm.Roof_Top__c = PowerGenForm.Roof_Top__c;
        jobPowerGenForm.Snow_Mud_or_Ice__c = PowerGenForm.Snow_Mud_or_Ice__c;
        jobPowerGenForm.Floor_Pit__c = PowerGenForm.Floor_Pit__c;

        jobPowerGenForm.Work_with_Contractors__c = PowerGenForm.Work_with_Contractors__c;
        jobPowerGenForm.General_Public__c = PowerGenForm.General_Public__c;
        jobPowerGenForm.Customer_Employees__c = PowerGenForm.Customer_Employees__c;

        jobPowerGenForm.Leaks_or_Spills__c = PowerGenForm.Leaks_or_Spills__c;
        jobPowerGenForm.Fumes_or_Smoke__c = PowerGenForm.Fumes_or_Smoke__c;
        jobPowerGenForm.Waste_Disposal__c = PowerGenForm.Waste_Disposal__c;
        jobPowerGenForm.Use_of_Chemicals__c = PowerGenForm.Use_of_Chemicals__c;

        jobPowerGenForm.Excessive__c = PowerGenForm.Excessive__c;
        jobPowerGenForm.Repetitive_Work__c = PowerGenForm.Repetitive_Work__c;
        jobPowerGenForm.Stressful_Posure__c = PowerGenForm.Stressful_Posure__c;
        jobPowerGenForm.Contact_Stress__c = PowerGenForm.Contact_Stress__c;
        jobPowerGenForm.Kneeling_Crawling__c = PowerGenForm.Kneeling_Crawling__c;
        jobPowerGenForm.Heavy_Lifting__c = PowerGenForm.Heavy_Lifting__c;
        jobPowerGenForm.Vibration__c = PowerGenForm.Vibration__c;

        jobPowerGenForm.Extreme_Heat__c = PowerGenForm.Extreme_Heat__c;
        jobPowerGenForm.Extreme_Cold__c = PowerGenForm.Extreme_Cold__c;
        jobPowerGenForm.High_Winds__c = PowerGenForm.High_Winds__c;
        jobPowerGenForm.Storm_Conditions__c = PowerGenForm.Storm_Conditions__c;
        jobPowerGenForm.Rain__c = PowerGenForm.Rain__c;
        jobPowerGenForm.Snow_Ice__c = PowerGenForm.Snow_Ice__c;
        jobPowerGenForm.High_Altitude__c = PowerGenForm.High_Altitude__c;
        jobPowerGenForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c = PowerGenForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c;
        jobPowerGenForm.Manager_Name__c = PowerGenForm.Manager_Name__c;
        jobPowerGenForm.Manager_Contact_Tel_No__c = PowerGenForm.Manager_Contact_Tel_No__c;

        jobPowerGenForm.Understand_the_equipment__c = PowerGenForm.Understand_the_equipment__c;
        jobPowerGenForm.Inform_Affected_Employees__c = PowerGenForm.Inform_Affected_Employees__c;
        jobPowerGenForm.Shutt_Off_Power__c = PowerGenForm.Shutt_Off_Power__c;
        jobPowerGenForm.Isolate_the_Machine_from_All_Energy_Sour__c = PowerGenForm.Isolate_the_Machine_from_All_Energy_Sour__c;
        jobPowerGenForm.Lockout_the_Energy__c = PowerGenForm.Lockout_the_Energy__c;
        jobPowerGenForm.Control_Stored_or_Secondary_Energy__c = PowerGenForm.Control_Stored_or_Secondary_Energy__c;
        jobPowerGenForm.Verify_the_Lackout__c = PowerGenForm.Verify_the_Lackout__c;
        jobPowerGenForm.Maintain_the_Lackout__c = PowerGenForm.Maintain_the_Lackout__c;
        jobPowerGenForm.Make_sure_the_area_is_Clear_of_personal__c = PowerGenForm.Make_sure_the_area_is_Clear_of_personal__c;
        jobPowerGenForm.Remove_locks__c = PowerGenForm.Remove_locks__c;
        jobPowerGenForm.Notifiy_the_affected_Employees_that_the__c = PowerGenForm.Notifiy_the_affected_Employees_that_the__c;
        jobPowerGenForm.Test_the_Machine__c = PowerGenForm.Test_the_Machine__c;
        jobPowerGenForm.Notify_the_affected_Employees_that_the_M__c = PowerGenForm.Notify_the_affected_Employees_that_the_M__c;

        upsert jobPowerGenForm;
        
    }

    public PageReference powerGenPgSave(){
        try{
            insertPowerGenJSARecord();
            system.debug('jobPowerGenForm>>>>>>' + jobPowerGenForm );
            PageReference pageRef = Page.FSL_PowerGenJSA;
            pageRef.getParameters().put('id', pgId);
            pageRef.getParameters().put('jformId',jobPowerGenForm.Id);
            pageRef.getParameters().put('copybtn','false');
            pageRef.setRedirect(true);
            return pageRef;
        } catch(exception e){
            system.debug('Entered into Catch Block of formSave Method in CSS_CL_PowerGenJSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }

    }


    public void FormCancelPopup(){
        system.debug('powerGenformId' + powerGenformId);
        try{
            if(powerGenformId!=null){
                CSS_JobHistory__c jobHistoryList = [Select Id, CSS_JobFormId__c from CSS_JobHistory__c where CSS_JobFormId__c =:powerGenformId and CSS_Job_Id__c = :pgId];

                delete jobHistoryList;

                PowerGenForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c
                                from CSS_JobForms__c where Id=:powerGenformId and ServiceJob__c  = :pgId limit 1 ];

                delete PowerGenForm;
            }
        } 

        catch(exception e){
            system.debug('Entered into Catch Block of FormCancelPopup Method in CSS_CL_PowerGenJSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
        }
    }


    public static Map<String, String> getValues(String objectType, String recordTypeId, String fieldName) {
        //Endpoint

        //   if(!Test.isRunningTest()){
        String endpoint = URL.getSalesforceBaseUrl().toExternalForm();
        endpoint += '/services/data/v41.0';
        endpoint += '/ui-api/object-info/{0}/picklist-values/{1}/{2}';
        endpoint = String.format(endpoint, new String[]{ objectType, recordTypeId, fieldName });
        EncodingUtil.urlEncode(endpoint,'UTF-8');
        // }
        //else{
        //  String endpoint = 'https://cumminscss--cssdev--c.visualforce.com';
        //}


        //HTTP Request send
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId()); 
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res;
        Map<String,Object> root = new Map<String,Object>();
        if(Test.isRunningTest()) {
            root = (Map<String,Object>) JSON.deserializeUntyped(FSL_TestDataUtility.getPickListOptions());
        } else {
            res = http.send(req);
            root = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        }

        //Parse response
        Map<String,String> result = new Map<String,String>();
        if(!root.containsKey('values')){ 
            return result; 
        }
        List<Object> pValues = (List<Object>)root.get('values');
        for(Object pValue : pValues){
            Map<String,Object> pValueMap = (Map<String,Object>)pValue;
            result.put((String)pValueMap.get('value'), (String)pValueMap.get('label'));
            System.debug(result);
        }
        return result;
    }


}