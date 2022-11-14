public class FSL_CL_MarineJSA
{
    Public String UserName {get;set;}
    Public String WWID {get;set;}
    Public Id pgId {get;set;}
    Public WorkOrder workJob {get;set;}
    Public String currentDateTime{get;set;}
    public Datetime formLoadTime{get;set;}
    public CSS_JobForms__c MarineForm {get;set;}
    public Id formRecTypeId;
    public string MarineformId;
    public CSS_JobForms__c jobMarineForm;
    public string Copy {get;set;}

    public FSL_CL_MarineJSA()
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
            formRecTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('MarineJSA').getRecordTypeId();
            system.debug('formRecTypeId' + ' ' + formRecTypeId);
            MarineformId=ApexPages.CurrentPage().getParameters().get('jformId');
            Copy = ApexPages.CurrentPage().getParameters().get('copybtn');
            system.debug('MarineformId>>>>>' + MarineformId);
            if(MarineformId!=null){
                MarineForm = [Select id,createddate,CreatedBy.Name,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c,Co_Worker_Name__c,Task_Description__c,Task_Category__c,
                                Job_Location__c,PowerGenPrepare1__c,MarinePrepare1__c,MarinePrepare2__c,MarinePrepare3__c,PowerGenPrepare2__c,PowerGenPrepare7__c,PREPARE2__c,PREPARE3__c,
                                LiftingAccess1__c,LiftingAccess2__c,MarineLiftingAccess1__c,MarineLiftingAccess2__c,MarineLiftingAccess3__c,MarineTE1__c,MarineTE2__c,ToolingEquipment1__c,ToolingEquipment2__c,
                                PPE1__c,PPE2__c,LoneWorking__c,LoneWorkingTextArea__c, MOVING_MACHINERY__c,MOVING_MACHINERY_Controls__c,MOVING_MACHINERY_What_Is_Strange__c,
                                MarineAdverseWeatherSIH__c,MarineAdverseWeatherControls__c, MarineAdverseWeatherStrange__c, MarineAscendingSIH__c, MarineAscendingControls__c,MarineAscendingStrange__c,
                                MarineVentilationControls__c,MarineVentilationSIH__c,MarineVentilationStrange__c,
                                MarineRestrictedWorkAreaStrange__c,MarineRestrictedWorkAreaSIH__c,MarineRestrictedWorkAreaControls__c,FIRE_EXPLOSION_OR_ARC_FLASH__c,FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c,
                                FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c,OTHER1__c,OTHER1_Controls__c,OTHER1_What_Is_Strange__c,OTHER2__c,OTHER2_Controls__c,OTHER2_What_Is_Strange__c, 
                                Paint_Burn_Off__c,Animals_or_Insects__c , Tidal_Conditions__c,High_Noise_Level__c,Exhaust_Gases__c, Hot_Work__c, Restricted_Work_Spaces__c,Confined_Space_Entry__c, Battery_Safety__c,
                                Flammable_Gas_Liquid__c, Ladder_or_Step_Ladder__c, Static_Access_Platform__c, Mobile_Work_Platform__c, Step_Stool__c,Set_to_Order__c,Dispose_Scrap__c,Cleanliness__c,
                                Struck_by_or_Against__c,Caught_or_Trapped_By__c,Hazardous_Energy__c,Dust_or_Dirt__c,Projectile_Hazard__c, Wet_or_Oily_Floor__c,Trailing_Cables__c, Lack_of_Walkway__c,
                                Obstructed_Work_Area__c,Working_Outside_Railing__c, Snow_Mud_or_Ice__c,Work_with_Contractors__c,General_Public__c,Customer_Employees__c,Leaks_or_Spills__c,Fumes_or_Smoke__c,
                                Waste_Disposal__c ,Use_of_Chemicals__c, Excessive__c, Repetitive_Work__c,Stressful_Posure__c,Contact_Stress__c,Kneeling_Crawling__c, Heavy_Lifting__c,Vibration__c,
                                Extreme_Heat__c,Extreme_Cold__c,High_Winds__c, Storm_Conditions__c,Rain__c,Snow_Ice__c,IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c,Manager_Name__c,
                                Manager_Contact_Tel_No__c,Understand_the_equipment__c,Inform_Affected_Employees__c,Shut_Down_and_De_Energize__c,Isolate_the_Machine_from_All_Energy_Sour__c,Lockout_the_Energy__c,
                                Control_Stored_or_Secondary_Energy__c,Verify_the_Lackout__c,Maintain_the_Lackout__c,Make_sure_the_area_is_Clear_of_personal__c,Remove_locks__c,Notifiy_the_affected_Employees_that_the__c,
                                Test_the_Machine__c,Notify_the_affected_Employees_that_the_M__c,Form_Start_Time__c, Form_Initiate_Time__c from CSS_JobForms__c where Id=:MarineformId and ServiceJob__c = :pgId limit 1 ];
                system.debug('MarineForm>>>>>' + MarineForm);
                UserName = MarineForm.CreatedBy.Name;
                WWID = [Select id, FederationIdentifier from User where id=:MarineForm.CreatedById][0].FederationIdentifier;
            	currentDateTime = MarineForm.Form_Initiate_Time__c.format('dd MMM YYYY hh:mm a z'); //PHOEN-148, added by Naveen Goud
            }
            else{
                MarineForm = new CSS_JobForms__c();
                // InShopForm.Service_Job__c = workJob.Id;
            }
        }
        catch(Exception e){
            system.debug('Catch block of FSL_CL_MarineJSA constructor' + e.getMessage() +  'Line Num >>>' + e.getLineNumber());
        }
    }

    public List<SelectOption> getTaskCategory()
    {
        String  RecTypeID= string.valueOf(formRecTypeId);
        system.debug('RecTypeID>>>>' +RecTypeID);
        Map<String,String> tempResult =  getValues('CSS_JobForms__c',RecTypeID,'Task_Category__c');
        List<SelectOption> resultVar = new List<SelectOption>();
        for(String mapKeySetVar : tempResult.keySet()){
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


    public void insertMarineJSARecord(){

        system.debug('inside insertMarineJSARecord');
        jobMarineForm = new CSS_JobForms__c();
        jobMarineForm.ServiceJob__c = pgId;
        if(MarineForm.Id != null )
            jobMarineForm.Id =MarineForm.Id;
        jobMarineForm.RecordTypeId = formRecTypeId;
        jobMarineForm.JSA_File_Name__c = UserInfo.getFirstName()+UserInfo.getLastName()+'-'+ System.now().format('dd MMM YYYY hh:mm a z');
        jobMarineForm.JSA_CreatorName__c = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
        jobMarineForm.JSA_TimeZone__c = System.now().format('hh:mma z') + '-' + System.now().format('MM/dd/YYYY');

        jobMarineForm.Co_Worker_Name__c = MarineForm.Co_Worker_Name__c;
        jobMarineForm.Task_Description__c = MarineForm.Task_Description__c;
        jobMarineForm.Task_Category__c = MarineForm.Task_Category__c;
        jobMarineForm.Job_Location__c = MarineForm.Job_Location__c;
       
        jobMarineForm.PowerGenPrepare1__c = MarineForm.PowerGenPrepare1__c;
        jobMarineForm.MarinePrepare1__c = MarineForm.MarinePrepare1__c;
        jobMarineForm.MarinePrepare2__c = MarineForm.MarinePrepare2__c;
        jobMarineForm.MarinePrepare3__c = MarineForm.MarinePrepare3__c;
        jobMarineForm.PREPARE3__c = MarineForm.PREPARE3__c;
        jobMarineForm.PREPARE2__c = MarineForm.PREPARE2__c;
        jobMarineForm.PowerGenPrepare7__c = MarineForm.PowerGenPrepare7__c;

        jobMarineForm.ToolingEquipment1__c = MarineForm.ToolingEquipment1__c;
        jobMarineForm.ToolingEquipment2__c = MarineForm.ToolingEquipment2__c;
        jobMarineForm.MarineTE1__c = MarineForm.MarineTE1__c;
        jobMarineForm.MarineTE2__c = MarineForm.MarineTE2__c;
        
        jobMarineForm.LiftingAccess1__c = MarineForm.LiftingAccess1__c;
        jobMarineForm.LiftingAccess2__c = MarineForm.LiftingAccess2__c;
        jobMarineForm.MarineLiftingAccess1__c = MarineForm.MarineLiftingAccess1__c;
        jobMarineForm.MarineLiftingAccess2__c = MarineForm.MarineLiftingAccess2__c;
        jobMarineForm.MarineLiftingAccess3__c = MarineForm.MarineLiftingAccess3__c;

        jobMarineForm.PPE1__c = MarineForm.PPE1__c;
        jobMarineForm.PPE2__c = MarineForm.PPE2__c;
        
        jobMarineForm.LoneWorking__c = MarineForm.LoneWorking__c;
        jobMarineForm.LoneWorkingTextArea__c = MarineForm.LoneWorkingTextArea__c;
        if(MarineForm.Form_Start_Time__c == null) {
            jobMarineForm.Form_Start_Time__c = currentDateTime;
            jobMarineForm.Form_Initiate_Time__c = formLoadTime;
        } 

        jobMarineForm.MarineAdverseWeatherSIH__c = MarineForm.MarineAdverseWeatherSIH__c;
        jobMarineForm.MarineAdverseWeatherControls__c = MarineForm.MarineAdverseWeatherControls__c;
        jobMarineForm.MarineAdverseWeatherStrange__c = MarineForm.MarineAdverseWeatherStrange__c;
        jobMarineForm.MarineAscendingSIH__c = MarineForm.MarineAscendingSIH__c;
        jobMarineForm.MarineAscendingControls__c = MarineForm.MarineAscendingControls__c;
        jobMarineForm.MarineAscendingStrange__c = MarineForm.MarineAscendingStrange__c;
        jobMarineForm.MOVING_MACHINERY__c = MarineForm.MOVING_MACHINERY__c;
        jobMarineForm.MOVING_MACHINERY_Controls__c = MarineForm.MOVING_MACHINERY_Controls__c;
        jobMarineForm.MOVING_MACHINERY_What_Is_Strange__c = MarineForm.MOVING_MACHINERY_What_Is_Strange__c;
        jobMarineForm.MarineVentilationSIH__c = MarineForm.MarineVentilationSIH__c;
        jobMarineForm.MarineVentilationControls__c = MarineForm.MarineVentilationControls__c;
        jobMarineForm.MarineVentilationStrange__c = MarineForm.MarineVentilationStrange__c;
        jobMarineForm.MarineRestrictedWorkAreaSIH__c = MarineForm.MarineRestrictedWorkAreaSIH__c;
        jobMarineForm.MarineRestrictedWorkAreaControls__c = MarineForm.MarineRestrictedWorkAreaControls__c;
        jobMarineForm.MarineRestrictedWorkAreaStrange__c = MarineForm.MarineRestrictedWorkAreaStrange__c;
        jobMarineForm.FIRE_EXPLOSION_OR_ARC_FLASH__c = MarineForm.FIRE_EXPLOSION_OR_ARC_FLASH__c;
        jobMarineForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c = MarineForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c;
        jobMarineForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c = MarineForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c;
        jobMarineForm.OTHER1__c = MarineForm.OTHER1__c;
        jobMarineForm.OTHER1_Controls__c = MarineForm.OTHER1_Controls__c;
        jobMarineForm.OTHER1_What_Is_Strange__c = MarineForm.OTHER1_What_Is_Strange__c;
        jobMarineForm.OTHER2__c = MarineForm.OTHER2__c;
        jobMarineForm.OTHER2_Controls__c = MarineForm.OTHER2_Controls__c;
        jobMarineForm.OTHER2_What_Is_Strange__c = MarineForm.OTHER2_What_Is_Strange__c;

        jobMarineForm.Paint_Burn_Off__c = MarineForm.Paint_Burn_Off__c;
        jobMarineForm.Animals_or_Insects__c = MarineForm.Animals_or_Insects__c;
        jobMarineForm.Tidal_Conditions__c = MarineForm.Tidal_Conditions__c;
        jobMarineForm.Exhaust_Gases__c = MarineForm.Exhaust_Gases__c;
        jobMarineForm.High_Noise_Level__c = MarineForm.High_Noise_Level__c;
        jobMarineForm.Hot_Work__c = MarineForm.Hot_Work__c;
        jobMarineForm.Restricted_Work_Spaces__c = MarineForm.Restricted_Work_Spaces__c;
        jobMarineForm.Confined_Space_Entry__c = MarineForm.Confined_Space_Entry__c;
        jobMarineForm.Battery_Safety__c = MarineForm.Battery_Safety__c;
        jobMarineForm.Flammable_Gas_Liquid__c = MarineForm.Flammable_Gas_Liquid__c;

        jobMarineForm.Ladder_or_Step_Ladder__c = MarineForm.Ladder_or_Step_Ladder__c;
        jobMarineForm.Static_Access_Platform__c = MarineForm.Static_Access_Platform__c;
        jobMarineForm.Mobile_Work_Platform__c = MarineForm.Mobile_Work_Platform__c;
        jobMarineForm.Step_Stool__c = MarineForm.Step_Stool__c;

        jobMarineForm.Set_to_Order__c = MarineForm.Set_to_Order__c;
        jobMarineForm.Dispose_Scrap__c = MarineForm.Dispose_Scrap__c;
        jobMarineForm.Cleanliness__c = MarineForm.Cleanliness__c;

        jobMarineForm.Struck_by_or_Against__c = MarineForm.Struck_by_or_Against__c;
        jobMarineForm.Caught_or_Trapped_By__c = MarineForm.Caught_or_Trapped_By__c;
        jobMarineForm.Hazardous_Energy__c = MarineForm.Hazardous_Energy__c;
        jobMarineForm.Dust_or_Dirt__c = MarineForm.Dust_or_Dirt__c;
        jobMarineForm.Projectile_Hazard__c = MarineForm.Projectile_Hazard__c;

        jobMarineForm.Wet_or_Oily_Floor__c = MarineForm.Wet_or_Oily_Floor__c;
        jobMarineForm.Trailing_Cables__c = MarineForm.Trailing_Cables__c;
        jobMarineForm.Lack_of_Walkway__c = MarineForm.Lack_of_Walkway__c;
        jobMarineForm.Obstructed_Work_Area__c = MarineForm.Obstructed_Work_Area__c;
        jobMarineForm.Working_Outside_Railing__c = MarineForm.Working_Outside_Railing__c;
        jobMarineForm.Snow_Mud_or_Ice__c = MarineForm.Snow_Mud_or_Ice__c;
        
        jobMarineForm.Work_with_Contractors__c = MarineForm.Work_with_Contractors__c;
        jobMarineForm.General_Public__c = MarineForm.General_Public__c;
        jobMarineForm.Customer_Employees__c = MarineForm.Customer_Employees__c;

        jobMarineForm.Leaks_or_Spills__c = MarineForm.Leaks_or_Spills__c;
        jobMarineForm.Fumes_or_Smoke__c = MarineForm.Fumes_or_Smoke__c;
        jobMarineForm.Waste_Disposal__c = MarineForm.Waste_Disposal__c;
        jobMarineForm.Use_of_Chemicals__c = MarineForm.Use_of_Chemicals__c;

        jobMarineForm.Excessive__c = MarineForm.Excessive__c;
        jobMarineForm.Repetitive_Work__c = MarineForm.Repetitive_Work__c;
        jobMarineForm.Stressful_Posure__c = MarineForm.Stressful_Posure__c;
        jobMarineForm.Contact_Stress__c = MarineForm.Contact_Stress__c;
        jobMarineForm.Kneeling_Crawling__c = MarineForm.Kneeling_Crawling__c;
        jobMarineForm.Heavy_Lifting__c = MarineForm.Heavy_Lifting__c;
        jobMarineForm.Vibration__c = MarineForm.Vibration__c;

        jobMarineForm.Extreme_Heat__c = MarineForm.Extreme_Heat__c;
        jobMarineForm.Extreme_Cold__c = MarineForm.Extreme_Cold__c;
        jobMarineForm.High_Winds__c = MarineForm.High_Winds__c;
        jobMarineForm.Storm_Conditions__c = MarineForm.Storm_Conditions__c;
        jobMarineForm.Rain__c = MarineForm.Rain__c;
        jobMarineForm.Snow_Ice__c = MarineForm.Snow_Ice__c;
        jobMarineForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c = MarineForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c;
        jobMarineForm.Manager_Name__c = MarineForm.Manager_Name__c;
        jobMarineForm.Manager_Contact_Tel_No__c = MarineForm.Manager_Contact_Tel_No__c;

        jobMarineForm.Understand_the_equipment__c = MarineForm.Understand_the_equipment__c;
        jobMarineForm.Inform_Affected_Employees__c = MarineForm.Inform_Affected_Employees__c;
        jobMarineForm.Shut_Down_and_De_Energize__c = MarineForm.Shut_Down_and_De_Energize__c;
        jobMarineForm.Isolate_the_Machine_from_All_Energy_Sour__c = MarineForm.Isolate_the_Machine_from_All_Energy_Sour__c;
        jobMarineForm.Lockout_the_Energy__c = MarineForm.Lockout_the_Energy__c;
        jobMarineForm.Control_Stored_or_Secondary_Energy__c = MarineForm.Control_Stored_or_Secondary_Energy__c;
        jobMarineForm.Verify_the_Lackout__c = MarineForm.Verify_the_Lackout__c;
        jobMarineForm.Maintain_the_Lackout__c = MarineForm.Maintain_the_Lackout__c;
        jobMarineForm.Make_sure_the_area_is_Clear_of_personal__c = MarineForm.Make_sure_the_area_is_Clear_of_personal__c;
        jobMarineForm.Remove_locks__c = MarineForm.Remove_locks__c;
        jobMarineForm.Notifiy_the_affected_Employees_that_the__c = MarineForm.Notifiy_the_affected_Employees_that_the__c;
        jobMarineForm.Test_the_Machine__c = MarineForm.Test_the_Machine__c;
        jobMarineForm.Notify_the_affected_Employees_that_the_M__c = MarineForm.Notify_the_affected_Employees_that_the_M__c;

        upsert jobMarineForm;

    }

    public PageReference MarinePgSave(){
        try{
            insertMarineJSARecord();
            system.debug('jobMarineForm>>>>>>' + jobMarineForm );
            PageReference pageRef = Page.FSL_MarineJSA;
            pageRef.getParameters().put('id', pgId);
            pageRef.getParameters().put('jformId',jobMarineForm.Id);
            pageRef.getParameters().put('copybtn','false');
            pageRef.setRedirect(true);
            return pageRef;
        } catch(exception e){
            system.debug('Entered into Catch Block of formSave Method in CSS_CL_MarineJSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }

    }


    public void FormCancelPopup(){
        system.debug('MarineformId' + MarineformId);
        try{
            if(MarineformId!=null){
                CSS_JobHistory__c jobHistoryList = [Select Id, CSS_JobFormId__c from CSS_JobHistory__c where CSS_JobFormId__c =:MarineformId and CSS_Job_Id__c = :pgId];

                delete jobHistoryList;

                MarineForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c
                                from CSS_JobForms__c where Id=:MarineformId and ServiceJob__c  = :pgId limit 1 ];

                delete MarineForm;
            }
        } 

        catch(exception e){
            system.debug('Entered into Catch Block of FormCancelPopup Method in CSS_CL_MarineJSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
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