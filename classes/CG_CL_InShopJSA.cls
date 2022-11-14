public class CG_CL_InShopJSA
{

    Public String UserName {get;set;}
    Public String WWID {get;set;}
    Public Id pgId {get;set;}
    Public CSS_Job_Order__c workJob {get;set;}
    Public String currentDateTime{get;set;}
    public CSS_JobForms__c InShopForm {get;set;}
    public Id formRecTypeId;
    public string inShopJobformId;
    public CSS_JobForms__c jobInShopForm;
    public string Copy {get;set;}

    public CG_CL_InShopJSA() //Constructor
    {
        getDetails();
    }

    public void getDetails(){
        try{
            system.debug('@@ getDetails() @@');
            //UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName()); 
             //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
            currentDateTime = system.now().format('dd MMM yyyy hh:mm a z');
            String UserID = UserInfo.getUserId();
            //User UserData = [Select id, FederationIdentifier from User where id=:UserID];
            //WWID = UserData.FederationIdentifier;

            pgId = ApexPages.currentPage().getParameters().get('id');
            workJob = [Select id,name from CSS_Job_Order__c where id=:pgId]; 
            formRecTypeId = Schema.SObjectType.CSS_JobForms__c.getRecordTypeInfosByName().get('InShopJSA').getRecordTypeId();
            system.debug('formRecTypeId' + ' ' + formRecTypeId);
            inShopJobformId=ApexPages.CurrentPage().getParameters().get('jformId');
            Copy = ApexPages.CurrentPage().getParameters().get('copybtn');
            system.debug('inShopJobformId>>>>>' + inShopJobformId);
            if(inShopJobformId!=null){
                InShopForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c,Co_Worker_Name__c,Task_Description__c,Task_Category__c,createdBy.FirstName,createdBy.LastName,
                              Job_Location__c,PREPARE1__c,PREPARE2__c,PREPARE3__c,LiftingAccess1__c,LiftingAccess2__c,LiftingAccess3__c,ToolingEquipment1__c,ToolingEquipment2__c,
                              PPE1__c,PPE2__c,LoneWorking__c,LoneWorkingTextArea__c,MOVING_MACHINERY__c,MOVING_MACHINERY_Controls__c,MOVING_MACHINERY_What_Is_Strange__c,
                              LIFTING_OPERATOIONS__c,LIFTING_OPERATOIONS_Controls__c, LIFTING_OPERATOIONS_What_Is_Strange__c, MOVING_VEHICLES__c, MOVING_VEHICLES_Controls__c,
                              MOVING_VEHICLES_What_Is_Strange__c, WORK_WITH_ELECTRICITY__c,WORK_WITH_ELECTRICITY_Control__c,WORK_WITH_ELECTRICITY_What_Is_Strange__c,
                              WORK_AT_HEIGHT__c,WORK_AT_HEIGHT_Controls__c,WORK_AT_HEIGHT_What_Is_Strange__c,FIRE_EXPLOSION_OR_ARC_FLASH__c,FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c,
                              FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c,OTHER1__c,OTHER1_Controls__c,OTHER1_What_Is_Strange__c,OTHER2__c,OTHER2_Controls__c,OTHER2_What_Is_Strange__c, 
                              Natural_Gas_CNG_LNG__c,Animals_or_Insects__c ,High_Noise_Level__c,Exhaust_Gases__c, Hot_Work__c, Restricted_Work_Spaces__c,Confined_Space_Entry__c, Hygiene_Hazards__c,
                              Flammable_Gas_Liquid__c,Compressed_Air__c, Battery_Safety__c, Ladder_or_Step_Ladder__c, Static_Access_Platform__c, Mobile_Work_Platform__c, Step_Stool__c,
                              Spray_Painting__c,Engine_Test_Cell__c,Chassiss_Dyno__c,Wash_Bay__c,Chemical_Bath__c, Cleaning__c,Inspection_Pits__c,Set_to_Order__c,Dispose_Scrap__c,Cleanliness__c,
                              Struck_by_or_Against__c,Caught_or_Trapped_By__c,Hazardous_Energy__c,Dust_or_Dirt__c,Projectile_Hazard__c, Wet_or_Oily_Floor__c,Trailing_Cables__c, Uneven_Ground_Gravel__c,
                              Elevated_Area_Mezzanine__c,Roof_Top__c, Snow_Mud_or_Ice__c, Floor_Pit__c,Work_with_Contractors__c,General_Public__c,Customer_Employees__c,Leaks_or_Spills__c,Fumes_or_Smoke__c,
                              Waste_Disposal__c ,Use_of_Chemicals__c, Excessive__c, Repetitive_Work__c,Stressful_Posure__c,Contact_Stress__c,Kneeling_Crawling__c, Heavy_Lifting__c,Vibration__c,
                              Extreme_Heat__c,Extreme_Cold__c,High_Winds__c, Storm_Conditions__c,Rain__c,Snow_Ice__c,High_Altitude__c,IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c,Manager_Name__c,
                              Manager_Contact_Tel_No__c,Understand_the_equipment__c,Inform_Affected_Employees__c,Shut_Down_and_De_Energize__c,Isolate_the_Machine_from_All_Energy_Sour__c,Lockout_the_Energy__c,
                              Control_Stored_or_Secondary_Energy__c,Verify_the_Lackout__c,Maintain_the_Lackout__c,Make_sure_the_area_is_Clear_of_personal__c,Remove_locks__c,Notifiy_the_affected_Employees_that_the__c,
                              Test_the_Machine__c,Notify_the_affected_Employees_that_the_M__c 
                              from CSS_JobForms__c where Id=:inShopJobformId and Service_Job__c = :pgId limit 1 ];
                system.debug('InShopForm>>>>>' + InShopForm);
            }
            else{
                InShopForm = new CSS_JobForms__c();
                // InShopForm.Service_Job__c = workJob.Id;
            }
            
              if(!String.isBlank(Copy) && Copy == 'true'){
              UserName = InShopForm.createdBy.FirstName+' '+ InShopForm.createdBy.LastName;
                User UserData = [Select id, FederationIdentifier from User where id=:InShopForm.CreatedById];
                WWID = UserData.FederationIdentifier;
                
            }else{
                UserName = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName()); 
                User UserData = [Select id, FederationIdentifier from User where id=:UserID];
                WWID = UserData.FederationIdentifier;
            }
        }
        catch(Exception e){
            system.debug('Catch block of CG_CL_InShopJSA constructor' + e.getMessage() +  'Line Num >>>' + e.getLineNumber());
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

    public List<SelectOption> getItemsPrepare1() {
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
        system.debug('options>>>>'+ options);
        return options;
    }

    public void insertInShopJSARecord(){

        system.debug('inside insertInShopJSARecord');
        jobInShopForm = new CSS_JobForms__c();
        jobInShopForm.Service_Job__c = pgId;
        if(InShopForm.Id != null )
            jobInShopForm.Id =InShopForm.Id;
        jobInShopForm.RecordTypeId = formRecTypeId;
         //YYYY is modified by Rajesh Narra on 11-12-2019 due to year val is getting increased by 1 for dec 30 and dec 31
        jobInShopForm.JSA_File_Name__c = UserInfo.getFirstName()+UserInfo.getLastName()+'_'+ System.now().format('MMddyyyy_hh:mma z');
        jobInShopForm.JSA_CreatorName__c = (UserInfo.getFirstName() == null ? '' : UserInfo.getFirstName()) + ' ' + (UserInfo.getLastName() == null ? '' : UserInfo.getLastName());
        
        jobInShopForm.JSA_TimeZone__c = System.now().format('hh:mma z') + '-' + System.now().format('MM/dd/yyyy');

        jobInShopForm.Co_Worker_Name__c = InShopForm.Co_Worker_Name__c;
        jobInShopForm.Task_Description__c = InShopForm.Task_Description__c;
        jobInShopForm.Task_Category__c = InShopForm.Task_Category__c;
        jobInShopForm.Job_Location__c = InShopForm.Job_Location__c;
        jobInShopForm.PREPARE1__c = InShopForm.PREPARE1__c;
        jobInShopForm.PREPARE2__c = InShopForm.PREPARE2__c;
        jobInShopForm.PREPARE3__c = InShopForm.PREPARE3__c;
        jobInShopForm.ToolingEquipment1__c = InShopForm.ToolingEquipment1__c;
        jobInShopForm.ToolingEquipment2__c = InShopForm.ToolingEquipment2__c;
        jobInShopForm.LiftingAccess1__c = InShopForm.LiftingAccess1__c;
        jobInShopForm.LiftingAccess2__c = InShopForm.LiftingAccess2__c;
        jobInShopForm.LiftingAccess3__c = InShopForm.LiftingAccess3__c;
        jobInShopForm.PPE1__c = InShopForm.PPE1__c;
        jobInShopForm.PPE2__c = InShopForm.PPE2__c;
        jobInShopForm.LoneWorking__c = InShopForm.LoneWorking__c;
        jobInShopForm.LoneWorkingTextArea__c = InShopForm.LoneWorkingTextArea__c;

        jobInShopForm.MOVING_VEHICLES__c = InShopForm.MOVING_VEHICLES__c;
        jobInShopForm.MOVING_VEHICLES_Controls__c = InShopForm.MOVING_VEHICLES_Controls__c;
        jobInShopForm.MOVING_VEHICLES_What_Is_Strange__c = InShopForm.MOVING_VEHICLES_What_Is_Strange__c;
        jobInShopForm.WORK_WITH_ELECTRICITY__c = InShopForm.WORK_WITH_ELECTRICITY__c;
        jobInShopForm.WORK_WITH_ELECTRICITY_Control__c = InShopForm.WORK_WITH_ELECTRICITY_Control__c;
        jobInShopForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c = InShopForm.WORK_WITH_ELECTRICITY_What_Is_Strange__c;
        jobInShopForm.MOVING_MACHINERY__c = InShopForm.MOVING_MACHINERY__c;
        jobInShopForm.MOVING_MACHINERY_Controls__c = InShopForm.MOVING_MACHINERY_Controls__c;
        jobInShopForm.MOVING_MACHINERY_What_Is_Strange__c = InShopForm.MOVING_MACHINERY_What_Is_Strange__c;
        jobInShopForm.LIFTING_OPERATOIONS__c = InShopForm.LIFTING_OPERATOIONS__c;
        jobInShopForm.LIFTING_OPERATOIONS_Controls__c = InShopForm.LIFTING_OPERATOIONS_Controls__c;
        jobInShopForm.LIFTING_OPERATOIONS_What_Is_Strange__c = InShopForm.LIFTING_OPERATOIONS_What_Is_Strange__c;
        jobInShopForm.WORK_AT_HEIGHT__c = InShopForm.WORK_AT_HEIGHT__c;
        jobInShopForm.WORK_AT_HEIGHT_Controls__c = InShopForm.WORK_AT_HEIGHT_Controls__c;
        jobInShopForm.WORK_AT_HEIGHT_What_Is_Strange__c = InShopForm.WORK_AT_HEIGHT_What_Is_Strange__c;
        jobInShopForm.FIRE_EXPLOSION_OR_ARC_FLASH__c = InShopForm.FIRE_EXPLOSION_OR_ARC_FLASH__c;
        jobInShopForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c = InShopForm.FIRE_EXPLOSION_OR_ARC_FLASH_Controls__c;
        jobInShopForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c = InShopForm.FIRE_EXPLOSION_OR_ARC_FLASH_What_IS_Stra__c;
        jobInShopForm.OTHER1__c = InShopForm.OTHER1__c;
        jobInShopForm.OTHER1_Controls__c = InShopForm.OTHER1_Controls__c;
        jobInShopForm.OTHER1_What_Is_Strange__c = InShopForm.OTHER1_What_Is_Strange__c;
        jobInShopForm.OTHER2__c = InShopForm.OTHER2__c;
        jobInShopForm.OTHER2_Controls__c = InShopForm.OTHER2_Controls__c;
        jobInShopForm.OTHER2_What_Is_Strange__c = InShopForm.OTHER2_What_Is_Strange__c;

        jobInShopForm.Natural_Gas_CNG_LNG__c = InShopForm.Natural_Gas_CNG_LNG__c;
        jobInShopForm.Animals_or_Insects__c = InShopForm.Animals_or_Insects__c;
        jobInShopForm.Exhaust_Gases__c = InShopForm.Exhaust_Gases__c;
        jobInShopForm.High_Noise_Level__c = InShopForm.High_Noise_Level__c;
        jobInShopForm.Hot_Work__c = InShopForm.Hot_Work__c;
        jobInShopForm.Restricted_Work_Spaces__c = InShopForm.Restricted_Work_Spaces__c;
        jobInShopForm.Confined_Space_Entry__c = InShopForm.Confined_Space_Entry__c;
        jobInShopForm.Hygiene_Hazards__c = InShopForm.Hygiene_Hazards__c;
        jobInShopForm.Flammable_Gas_Liquid__c = InShopForm.Flammable_Gas_Liquid__c;
        jobInShopForm.Compressed_Air__c = InShopForm.Compressed_Air__c;
        jobInShopForm.Battery_Safety__c = InShopForm.Battery_Safety__c;

        jobInShopForm.Ladder_or_Step_Ladder__c = InShopForm.Ladder_or_Step_Ladder__c;
        jobInShopForm.Static_Access_Platform__c = InShopForm.Static_Access_Platform__c;
        jobInShopForm.Mobile_Work_Platform__c = InShopForm.Mobile_Work_Platform__c;
        jobInShopForm.Step_Stool__c = InShopForm.Step_Stool__c;

        jobInShopForm.Spray_Painting__c = InShopForm.Spray_Painting__c;
        jobInShopForm.Engine_Test_Cell__c = InShopForm.Engine_Test_Cell__c;
        jobInShopForm.Chassiss_Dyno__c = InShopForm.Chassiss_Dyno__c;
        jobInShopForm.Wash_Bay__c = InShopForm.Wash_Bay__c;
        jobInShopForm.Chemical_Bath__c = InShopForm.Chemical_Bath__c;
        jobInShopForm.Cleaning__c = InShopForm.Cleaning__c;
        jobInShopForm.Inspection_Pits__c = InShopForm.Inspection_Pits__c;

        jobInShopForm.Set_to_Order__c = InShopForm.Set_to_Order__c;
        jobInShopForm.Dispose_Scrap__c = InShopForm.Dispose_Scrap__c;
        jobInShopForm.Cleanliness__c = InShopForm.Cleanliness__c;

        jobInShopForm.Struck_by_or_Against__c = InShopForm.Struck_by_or_Against__c;
        jobInShopForm.Caught_or_Trapped_By__c = InShopForm.Caught_or_Trapped_By__c;
        jobInShopForm.Hazardous_Energy__c = InShopForm.Hazardous_Energy__c;
        jobInShopForm.Dust_or_Dirt__c = InShopForm.Dust_or_Dirt__c;
        jobInShopForm.Projectile_Hazard__c = InShopForm.Projectile_Hazard__c;

        jobInShopForm.Wet_or_Oily_Floor__c = InShopForm.Wet_or_Oily_Floor__c;
        jobInShopForm.Trailing_Cables__c = InShopForm.Trailing_Cables__c;
        jobInShopForm.Uneven_Ground_Gravel__c = InShopForm.Uneven_Ground_Gravel__c;
        jobInShopForm.Elevated_Area_Mezzanine__c = InShopForm.Elevated_Area_Mezzanine__c;
        jobInShopForm.Roof_Top__c = InShopForm.Roof_Top__c;
        jobInShopForm.Snow_Mud_or_Ice__c = InShopForm.Snow_Mud_or_Ice__c;
        jobInShopForm.Floor_Pit__c = InShopForm.Floor_Pit__c;

        jobInShopForm.Work_with_Contractors__c = InShopForm.Work_with_Contractors__c;
        jobInShopForm.General_Public__c = InShopForm.General_Public__c;
        jobInShopForm.Customer_Employees__c = InShopForm.Customer_Employees__c;

        jobInShopForm.Leaks_or_Spills__c = InShopForm.Leaks_or_Spills__c;
        jobInShopForm.Fumes_or_Smoke__c = InShopForm.Fumes_or_Smoke__c;
        jobInShopForm.Waste_Disposal__c = InShopForm.Waste_Disposal__c;
        jobInShopForm.Use_of_Chemicals__c = InShopForm.Use_of_Chemicals__c;

        jobInShopForm.Excessive__c = InShopForm.Excessive__c;
        jobInShopForm.Repetitive_Work__c = InShopForm.Repetitive_Work__c;
        jobInShopForm.Stressful_Posure__c = InShopForm.Stressful_Posure__c;
        jobInShopForm.Contact_Stress__c = InShopForm.Contact_Stress__c;
        jobInShopForm.Kneeling_Crawling__c = InShopForm.Kneeling_Crawling__c;
        jobInShopForm.Heavy_Lifting__c = InShopForm.Heavy_Lifting__c;
        jobInShopForm.Vibration__c = InShopForm.Vibration__c;

        jobInShopForm.Extreme_Heat__c = InShopForm.Extreme_Heat__c;
        jobInShopForm.Extreme_Cold__c = InShopForm.Extreme_Cold__c;
        jobInShopForm.High_Winds__c = InShopForm.High_Winds__c;
        jobInShopForm.Storm_Conditions__c = InShopForm.Storm_Conditions__c;
        jobInShopForm.Rain__c = InShopForm.Rain__c;
        jobInShopForm.Snow_Ice__c = InShopForm.Snow_Ice__c;
        jobInShopForm.High_Altitude__c = InShopForm.High_Altitude__c;
        jobInShopForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c = InShopForm.IDENTIFY_ANY_SPECIAL_CONTROL_MEASURES_RE__c;
        jobInShopForm.Manager_Name__c = InShopForm.Manager_Name__c;
        jobInShopForm.Manager_Contact_Tel_No__c = InShopForm.Manager_Contact_Tel_No__c;

        jobInShopForm.Understand_the_equipment__c = InShopForm.Understand_the_equipment__c;
        jobInShopForm.Inform_Affected_Employees__c = InShopForm.Inform_Affected_Employees__c;
        jobInShopForm.Shut_Down_and_De_Energize__c = InShopForm.Shut_Down_and_De_Energize__c;
        jobInShopForm.Isolate_the_Machine_from_All_Energy_Sour__c = InShopForm.Isolate_the_Machine_from_All_Energy_Sour__c;
        jobInShopForm.Lockout_the_Energy__c = InShopForm.Lockout_the_Energy__c;
        jobInShopForm.Control_Stored_or_Secondary_Energy__c = InShopForm.Control_Stored_or_Secondary_Energy__c;
        jobInShopForm.Verify_the_Lackout__c = InShopForm.Verify_the_Lackout__c;
        jobInShopForm.Maintain_the_Lackout__c = InShopForm.Maintain_the_Lackout__c;
        jobInShopForm.Make_sure_the_area_is_Clear_of_personal__c = InShopForm.Make_sure_the_area_is_Clear_of_personal__c;
        jobInShopForm.Remove_locks__c = InShopForm.Remove_locks__c;
        jobInShopForm.Notifiy_the_affected_Employees_that_the__c = InShopForm.Notifiy_the_affected_Employees_that_the__c;
        jobInShopForm.Test_the_Machine__c = InShopForm.Test_the_Machine__c;
        jobInShopForm.Notify_the_affected_Employees_that_the_M__c = InShopForm.Notify_the_affected_Employees_that_the_M__c;

        upsert jobInShopForm;

    }

    public PageReference InshopPgSave(){
        try{
            insertInShopJSARecord();
            system.debug('jobInShopForm>>>>>>' + jobInShopForm );
            PageReference pageRef = Page.CG_InShopJSA;
            pageRef.getParameters().put('id', pgId);
            pageRef.getParameters().put('jformId',jobInShopForm.Id);
            pageRef.getParameters().put('copybtn','false');
            pageRef.setRedirect(true);
            return pageRef;
        } catch(exception e){
            system.debug('Entered into Catch Block of formSave Method in CSS_JSA Controller' +e.getLineNumber() + ' ' + e.getMessage());
            return null;
        }

    }


    public void FormCancelPopup(){
        system.debug('inShopJobformId' + inShopJobformId);
        try{
        if(inShopJobformId!=null){

           CSS_JobHistory__c jobHistoryList = [Select Id, CSS_JobFormId__c from CSS_JobHistory__c where CSS_JobFormId__c =:inShopJobformId and CSS_Job_Id__c = :pgId];

            delete jobHistoryList;

            InShopForm = [Select id,createddate,createdBy.UserName,CreatedById,JSA_File_Name__c,JSA_CreatorName__c,JSA_TimeZone__c
                          from CSS_JobForms__c where Id=:inShopJobformId and Service_Job__c = :pgId limit 1 ];

            delete InShopForm;
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