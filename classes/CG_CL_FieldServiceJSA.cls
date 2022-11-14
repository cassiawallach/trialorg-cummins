/*
 * Block comments with details of changes
 */
public class CG_CL_FieldServiceJSA
{
    Public String UserName {get;set;}
    Public String WWID {get;set;}
    Public Id pgId {get;set;}
    Public CSS_Job_Order__c workJob {get;set;}
    Public String currentDateTime{get;set;}
    public CSS_JobForms__c FieldServiceForm {get;set;}
    public Id formRecTypeId;
    public string fieldServiceformId;
    public CSS_JobForms__c jobFieldServiceForm;
    public string Copy {get;set;}

    public CG_CL_FieldServiceJSA()
    {
        getDetails() ;
    }


    public void getDetails(){
        try{
            
            
            //UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName()); 
             //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
            currentDateTime = system.now().format('dd MMM yyyy hh:mm a z');
            String UserID = UserInfo.getUserId();
            //User UserData = [Select id, FederationIdentifier from User where id=:UserID];
            //WWID = UserData.FederationIdentifier;

            pgId = ApexPages.currentPage().getParameters().get('id');
            workJob = [Select id,name from CSS_Job_Order__c where id=:pgId]; 
            formRecTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('FieldServiceJSA').getRecordTypeId();
            system.debug('formRecTypeId' + ' ' + formRecTypeId);
            fieldServiceformId=ApexPages.CurrentPage().getParameters().get('jformId');
            Copy = ApexPages.CurrentPage().getParameters().get('copybtn');
            
                        system.debug('fieldServiceformId>>>>>' + fieldServiceformId);
            if(fieldServiceformId!=null){
                FieldServiceForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c,Co_Worker_Name__c,Task_Description__c,Task_Category__c,createdBy.FirstName,createdBy.LastName,
                                    Job_Location__c,PREPARE4__c,PREPARE2__c,PREPARE3__c,LiftingAccess1__c,LiftingAccess2__c,LiftingAccess3__c,ToolingEquipment1__c,ToolingEquipment2__c,
                                    PPE1__c,PPE2__c,LoneWorking__c,LoneWorkingTextArea__c,MOVING_MACHINERY__c,MOVING_MACHINERY_Controls__c,MOVING_MACHINERY_What_Is_Strange__c,
                                    LIFTING_OPERATOIONS__c,LIFTING_OPERATOIONS_Controls__c, LIFTING_OPERATOIONS_What_Is_Strange__c, MOVING_VEHICLES__c, MOVING_VEHICLES_Controls__c,
                                    MOVING_VEHICLES_What_Is_Strange__c, WORK_WITH_ELECTRICITY__c,WORK_WITH_ELECTRICITY_Control__c,WORK_WITH_ELECTRICITY_What_Is_Strange__c,
                                    WORK_AT_HEIGHT__c,WORK_AT_HEIGHT_Controls__c,WORK_AT_HEIGHT_What_Is_Strange__c,FIRE_EXPLOSION_OR_ARC_FLASH__c,FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c,
                                    FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c,OTHER1__c,OTHER1_Controls__c,OTHER1_What_Is_Strange__c,OTHER2__c,OTHER2_Controls__c,OTHER2_What_Is_Strange__c, 
                                    Natural_Gas_CNG_LNG__c,Animals_or_Insects__c ,Overhead_Power_Lines__c,High_Noise_Level__c,Exhaust_Gases__c, Hot_Work__c, Restricted_Work_Spaces__c,Confined_Space_Entry__c, Hygiene_Hazards__c,
                                    Flammable_Gas_Liquid__c,Compressed_Air__c, Battery_Safety__c, Ladder_or_Step_Ladder__c, Static_Access_Platform__c, Mobile_Work_Platform__c, Step_Stool__c,
                                    Spray_Painting__c,Engine_Test_Cell__c,Chassiss_Dyno__c,Wash_Bay__c,Chemical_Bath__c, Cleaning__c,Inspection_Pits__c,Set_to_Order__c,Dispose_Scrap__c,Cleanliness__c,
                                    Struck_by_or_Against__c,Caught_or_Trapped_By__c,Hazardous_Energy__c,Dust_or_Dirt__c,Projectile_Hazard__c, Wet_or_Oily_Floor__c,Trailing_Cables__c, Uneven_Ground_Gravel__c,
                                    Elevated_Area_Mezzanine__c,Roof_Top__c, Snow_Mud_or_Ice__c, Floor_Pit__c,Work_with_Contractors__c,General_Public__c,Customer_Employees__c,Leaks_or_Spills__c,Fumes_or_Smoke__c,
                                    Waste_Disposal__c ,Use_of_Chemicals__c, Excessive__c, Repetitive_Work__c,Stressful_Posure__c,Contact_Stress__c,Kneeling_Crawling__c, Heavy_Lifting__c,Vibration__c,
                                    Extreme_Heat__c,Extreme_Cold__c,High_Winds__c, Storm_Conditions__c,Rain__c,Snow_Ice__c,High_Altitude__c,IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c,Manager_Name__c,
                                    Manager_Contact_Tel_No__c,Understand_the_equipment__c,Inform_Affected_Employees__c,Shutt_Off_Power__c,Isolate_the_Machine_from_All_Energy_Sour__c,Lockout_the_Energy__c,
                                    Control_Stored_or_Secondary_Energy__c,Verify_the_Lackout__c,Maintain_the_Lackout__c,Make_sure_the_area_is_Clear_of_personal__c,Remove_locks__c,Notifiy_the_affected_Employees_that_the__c,
                                    Test_the_Machine__c,Notify_the_affected_Employees_that_the_M__c
                                    from CSS_JobForms__c where Id=:fieldServiceformId and Service_Job__c = :pgId limit 1 ];
            }
            else{
                FieldServiceForm = new CSS_JobForms__c();
            }
            
            if(!String.isBlank(Copy) && Copy == 'true'){
                UserName = FieldServiceForm.createdBy.FirstName+' '+ FieldServiceForm.createdBy.LastName;
                User UserData = [Select id, FederationIdentifier from User where id=:FieldServiceForm.CreatedById];
                WWID = UserData.FederationIdentifier;
                
            }else{
                UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName()); 
                User UserData = [Select id, FederationIdentifier from User where id=:UserID];
                WWID = UserData.FederationIdentifier;
            }
            
        }
        catch(Exception e){
            system.debug('Catch block of CG_CL_FieldServiceJSA constructor' + e.getMessage() +  'Line Num >>>' + e.getLineNumber());
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

    public List<SelectOption> getItemsPrepare() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',system.Label.css_Yes));
        options.add(new SelectOption('No',system.Label.CSS_No));
        options.add(new SelectOption('NA',system.Label.CSS_NA));
        return options;
    }

    public List<SelectOption> getPPE() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',system.Label.css_Yes));
        options.add(new SelectOption('No',system.Label.CSS_No));
        return options;
    }
    
    
    public List<SelectOption> getPPE1() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',system.Label.css_Yes));
        options.add(new SelectOption('No',system.Label.CSS_No));
        return options;
    }


    public void insertFieldServiceJSARecord(){
        system.debug('inside insertFieldServiceJSARecord');
        jobFieldServiceForm = new CSS_JobForms__c();
        jobFieldServiceForm.Service_Job__c = pgId;
        if(FieldServiceForm.Id != null )
            jobFieldServiceForm.Id =FieldServiceForm.Id;
        jobFieldServiceForm.RecordTypeId = formRecTypeId;
         //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
        jobFieldServiceForm.JSA_File_Name__c = UserInfo.getFirstName()+UserInfo.getLastName()+'_'+ System.now().format('MMddyyyy_hh:mma z');
        jobFieldServiceForm.JSA_CreatorName__c = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
         //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
        jobFieldServiceForm.JSA_TimeZone__c = System.now().format('hh:mma z') + '-' + System.now().format('MM/dd/yyyy');

        jobFieldServiceForm.Co_Worker_Name__c = FieldServiceForm.Co_Worker_Name__c;
        jobFieldServiceForm.Task_Description__c = FieldServiceForm.Task_Description__c;
        jobFieldServiceForm.Task_Category__c = FieldServiceForm.Task_Category__c;
        jobFieldServiceForm.Job_Location__c = FieldServiceForm.Job_Location__c;
        jobFieldServiceForm.PREPARE4__c = FieldServiceForm.PREPARE4__c;
        jobFieldServiceForm.PREPARE2__c = FieldServiceForm.PREPARE2__c;
        jobFieldServiceForm.PREPARE3__c = FieldServiceForm.PREPARE3__c;
        jobFieldServiceForm.ToolingEquipment1__c = FieldServiceForm.ToolingEquipment1__c;
        jobFieldServiceForm.ToolingEquipment2__c = FieldServiceForm.ToolingEquipment2__c;
        jobFieldServiceForm.LiftingAccess1__c = FieldServiceForm.LiftingAccess1__c;
        jobFieldServiceForm.LiftingAccess2__c = FieldServiceForm.LiftingAccess2__c;
        jobFieldServiceForm.LiftingAccess3__c = FieldServiceForm.LiftingAccess3__c;
        jobFieldServiceForm.PPE1__c = FieldServiceForm.PPE1__c;
        jobFieldServiceForm.PPE2__c = FieldServiceForm.PPE2__c;
        jobFieldServiceForm.LoneWorking__c = FieldServiceForm.LoneWorking__c;
        jobFieldServiceForm.LoneWorkingTextArea__c = FieldServiceForm.LoneWorkingTextArea__c;

        jobFieldServiceForm.MOVING_VEHICLES__c = FieldServiceForm.MOVING_VEHICLES__c;
        jobFieldServiceForm.MOVING_VEHICLES_Controls__c = FieldServiceForm.MOVING_VEHICLES_Controls__c;
        jobFieldServiceForm.MOVING_VEHICLES_What_Is_Strange__c = FieldServiceForm.MOVING_VEHICLES_What_Is_Strange__c;
        jobFieldServiceForm.WORK_WITH_ELECTRICITY__c = FieldServiceForm.WORK_WITH_ELECTRICITY__c;
        jobFieldServiceForm.WORK_WITH_ELECTRICITY_Control__c = FieldServiceForm.WORK_WITH_ELECTRICITY_Control__c;
        jobFieldServiceForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c = FieldServiceForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c;
        jobFieldServiceForm.MOVING_MACHINERY__c = FieldServiceForm.MOVING_MACHINERY__c;
        jobFieldServiceForm.MOVING_MACHINERY_Controls__c = FieldServiceForm.MOVING_MACHINERY_Controls__c;
        jobFieldServiceForm.MOVING_MACHINERY_What_Is_Strange__c = FieldServiceForm.MOVING_MACHINERY_What_Is_Strange__c;
        jobFieldServiceForm.LIFTING_OPERATOIONS__c = FieldServiceForm.LIFTING_OPERATOIONS__c;
        jobFieldServiceForm.LIFTING_OPERATOIONS_Controls__c = FieldServiceForm.LIFTING_OPERATOIONS_Controls__c;
        jobFieldServiceForm.LIFTING_OPERATOIONS_What_Is_Strange__c = FieldServiceForm.LIFTING_OPERATOIONS_What_Is_Strange__c;
        jobFieldServiceForm.WORK_AT_HEIGHT__c = FieldServiceForm.WORK_AT_HEIGHT__c;
        jobFieldServiceForm.WORK_AT_HEIGHT_Controls__c = FieldServiceForm.WORK_AT_HEIGHT_Controls__c;
        jobFieldServiceForm.WORK_AT_HEIGHT_What_Is_Strange__c = FieldServiceForm.WORK_AT_HEIGHT_What_Is_Strange__c;
        jobFieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH__c = FieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH__c;
        jobFieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c = FieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c;
        jobFieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c = FieldServiceForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c;
        jobFieldServiceForm.OTHER1__c = FieldServiceForm.OTHER1__c;
        jobFieldServiceForm.OTHER1_Controls__c = FieldServiceForm.OTHER1_Controls__c;
        jobFieldServiceForm.OTHER1_What_Is_Strange__c = FieldServiceForm.OTHER1_What_Is_Strange__c;
        jobFieldServiceForm.OTHER2__c = FieldServiceForm.OTHER2__c;
        jobFieldServiceForm.OTHER2_Controls__c = FieldServiceForm.OTHER2_Controls__c;
        jobFieldServiceForm.OTHER2_What_Is_Strange__c = FieldServiceForm.OTHER2_What_Is_Strange__c;

        jobFieldServiceForm.Natural_Gas_CNG_LNG__c = FieldServiceForm.Natural_Gas_CNG_LNG__c;
        jobFieldServiceForm.Animals_or_Insects__c = FieldServiceForm.Animals_or_Insects__c;
        jobFieldServiceForm.Overhead_Power_Lines__c = FieldServiceForm.Overhead_Power_Lines__c;      
        jobFieldServiceForm.Exhaust_Gases__c = FieldServiceForm.Exhaust_Gases__c;
        jobFieldServiceForm.High_Noise_Level__c = FieldServiceForm.High_Noise_Level__c;
        jobFieldServiceForm.Hot_Work__c = FieldServiceForm.Hot_Work__c;
        jobFieldServiceForm.Restricted_Work_Spaces__c = FieldServiceForm.Restricted_Work_Spaces__c;
        jobFieldServiceForm.Confined_Space_Entry__c = FieldServiceForm.Confined_Space_Entry__c;
        jobFieldServiceForm.Hygiene_Hazards__c = FieldServiceForm.Hygiene_Hazards__c;
        jobFieldServiceForm.Flammable_Gas_Liquid__c = FieldServiceForm.Flammable_Gas_Liquid__c;
        jobFieldServiceForm.Compressed_Air__c = FieldServiceForm.Compressed_Air__c;
        jobFieldServiceForm.Battery_Safety__c = FieldServiceForm.Battery_Safety__c;

        jobFieldServiceForm.Ladder_or_Step_Ladder__c = FieldServiceForm.Ladder_or_Step_Ladder__c;
        jobFieldServiceForm.Static_Access_Platform__c = FieldServiceForm.Static_Access_Platform__c;
        jobFieldServiceForm.Mobile_Work_Platform__c = FieldServiceForm.Mobile_Work_Platform__c;
        jobFieldServiceForm.Step_Stool__c = FieldServiceForm.Step_Stool__c;

        jobFieldServiceForm.Set_to_Order__c = FieldServiceForm.Set_to_Order__c;
        jobFieldServiceForm.Dispose_Scrap__c = FieldServiceForm.Dispose_Scrap__c;
        jobFieldServiceForm.Cleanliness__c = FieldServiceForm.Cleanliness__c;

        jobFieldServiceForm.Struck_by_or_Against__c = FieldServiceForm.Struck_by_or_Against__c;
        jobFieldServiceForm.Caught_or_Trapped_By__c = FieldServiceForm.Caught_or_Trapped_By__c;
        jobFieldServiceForm.Hazardous_Energy__c = FieldServiceForm.Hazardous_Energy__c;
        jobFieldServiceForm.Dust_or_Dirt__c = FieldServiceForm.Dust_or_Dirt__c;
        jobFieldServiceForm.Projectile_Hazard__c = FieldServiceForm.Projectile_Hazard__c;

        jobFieldServiceForm.Wet_or_Oily_Floor__c = FieldServiceForm.Wet_or_Oily_Floor__c;
        jobFieldServiceForm.Trailing_Cables__c = FieldServiceForm.Trailing_Cables__c;
        jobFieldServiceForm.Uneven_Ground_Gravel__c = FieldServiceForm.Uneven_Ground_Gravel__c;
        jobFieldServiceForm.Elevated_Area_Mezzanine__c = FieldServiceForm.Elevated_Area_Mezzanine__c;
        jobFieldServiceForm.Roof_Top__c = FieldServiceForm.Roof_Top__c;
        jobFieldServiceForm.Snow_Mud_or_Ice__c = FieldServiceForm.Snow_Mud_or_Ice__c;
        jobFieldServiceForm.Floor_Pit__c = FieldServiceForm.Floor_Pit__c;

        jobFieldServiceForm.Work_with_Contractors__c = FieldServiceForm.Work_with_Contractors__c;
        jobFieldServiceForm.General_Public__c = FieldServiceForm.General_Public__c;
        jobFieldServiceForm.Customer_Employees__c = FieldServiceForm.Customer_Employees__c;

        jobFieldServiceForm.Leaks_or_Spills__c = FieldServiceForm.Leaks_or_Spills__c;
        jobFieldServiceForm.Fumes_or_Smoke__c = FieldServiceForm.Fumes_or_Smoke__c;
        jobFieldServiceForm.Waste_Disposal__c = FieldServiceForm.Waste_Disposal__c;
        jobFieldServiceForm.Use_of_Chemicals__c = FieldServiceForm.Use_of_Chemicals__c;

        jobFieldServiceForm.Excessive__c = FieldServiceForm.Excessive__c;
        jobFieldServiceForm.Repetitive_Work__c = FieldServiceForm.Repetitive_Work__c;
        jobFieldServiceForm.Stressful_Posure__c = FieldServiceForm.Stressful_Posure__c;
        jobFieldServiceForm.Contact_Stress__c = FieldServiceForm.Contact_Stress__c;
        jobFieldServiceForm.Kneeling_Crawling__c = FieldServiceForm.Kneeling_Crawling__c;
        jobFieldServiceForm.Heavy_Lifting__c = FieldServiceForm.Heavy_Lifting__c;
        jobFieldServiceForm.Vibration__c = FieldServiceForm.Vibration__c;

        jobFieldServiceForm.Extreme_Heat__c = FieldServiceForm.Extreme_Heat__c;
        jobFieldServiceForm.Extreme_Cold__c = FieldServiceForm.Extreme_Cold__c;
        jobFieldServiceForm.High_Winds__c = FieldServiceForm.High_Winds__c;
        jobFieldServiceForm.Storm_Conditions__c = FieldServiceForm.Storm_Conditions__c;
        jobFieldServiceForm.Rain__c = FieldServiceForm.Rain__c;
        jobFieldServiceForm.Snow_Ice__c = FieldServiceForm.Snow_Ice__c;
        jobFieldServiceForm.High_Altitude__c = FieldServiceForm.High_Altitude__c;
        jobFieldServiceForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c = FieldServiceForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c;
        jobFieldServiceForm.Manager_Name__c = FieldServiceForm.Manager_Name__c;
        jobFieldServiceForm.Manager_Contact_Tel_No__c = FieldServiceForm.Manager_Contact_Tel_No__c;

        jobFieldServiceForm.Understand_the_equipment__c = FieldServiceForm.Understand_the_equipment__c;
        jobFieldServiceForm.Inform_Affected_Employees__c = FieldServiceForm.Inform_Affected_Employees__c;
        jobFieldServiceForm.Shutt_Off_Power__c = FieldServiceForm.Shutt_Off_Power__c;
        jobFieldServiceForm.Isolate_the_Machine_from_All_Energy_Sour__c = FieldServiceForm.Isolate_the_Machine_from_All_Energy_Sour__c;
        jobFieldServiceForm.Lockout_the_Energy__c = FieldServiceForm.Lockout_the_Energy__c;
        jobFieldServiceForm.Control_Stored_or_Secondary_Energy__c = FieldServiceForm.Control_Stored_or_Secondary_Energy__c;
        jobFieldServiceForm.Verify_the_Lackout__c = FieldServiceForm.Verify_the_Lackout__c;
        jobFieldServiceForm.Maintain_the_Lackout__c = FieldServiceForm.Maintain_the_Lackout__c;
        jobFieldServiceForm.Make_sure_the_area_is_Clear_of_personal__c = FieldServiceForm.Make_sure_the_area_is_Clear_of_personal__c;
        jobFieldServiceForm.Remove_locks__c = FieldServiceForm.Remove_locks__c;
        jobFieldServiceForm.Notifiy_the_affected_Employees_that_the__c = FieldServiceForm.Notifiy_the_affected_Employees_that_the__c;
        jobFieldServiceForm.Test_the_Machine__c = FieldServiceForm.Test_the_Machine__c;
        jobFieldServiceForm.Notify_the_affected_Employees_that_the_M__c = FieldServiceForm.Notify_the_affected_Employees_that_the_M__c;

        upsert  jobFieldServiceForm;

    }

    public PageReference FieldServicePgSave(){
        try{
            insertFieldServiceJSARecord();
            system.debug('jobFieldServiceForm>>>>>>' + jobFieldServiceForm );
            PageReference pageRef = Page.CG_FieldServiceJSA;
            pageRef.getParameters().put('id', pgId);
            pageRef.getParameters().put('jformId',jobFieldServiceForm.Id);
            pageRef.getParameters().put('copybtn','false');
            pageRef.setRedirect(true);
            return pageRef;
        } catch(exception e){
            system.debug('Entered into Catch Block of formSave Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }

    }


    public void FormCancelPopup(){
        system.debug('fieldServiceformId' + fieldServiceformId);
        try{
        if(fieldServiceformId!=null){

            CSS_JobHistory__c jobHistoryList = [Select Id, CSS_JobFormId__c from CSS_JobHistory__c where CSS_JobFormId__c =:fieldServiceformId and CSS_Job_Id__c = :pgId];

            delete jobHistoryList;

            FieldServiceForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c
                                from CSS_JobForms__c where Id=:fieldServiceformId and Service_Job__c = :pgId limit 1 ];

            delete FieldServiceForm;
        }
        }
        
         catch(exception e){
            system.debug('Entered into Catch Block of FormCancelPopup Method in  Controller' +e.getLineNumber() + ' ' + e.getMessage());
         }

    }

    public static Map<String, String> getValues(String objectType, String recordTypeId, String fieldName) {
        //Endpoint

        String endpoint = URL.getSalesforceBaseUrl().toExternalForm();
        endpoint += '/services/data/v41.0';
        endpoint += '/ui-api/object-info/{0}/picklist-values/{1}/{2}';
        endpoint = String.format(endpoint, new String[]{ objectType, recordTypeId, fieldName });
        EncodingUtil.urlEncode(endpoint,'UTF-8');

        //HTTP Request send
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId()); 
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        Http http = new Http();
        HTTPResponse res = http.send(req);

        //Parse response
        Map<String,String> result = new Map<String,String>();
        Map<String,Object> root = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
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