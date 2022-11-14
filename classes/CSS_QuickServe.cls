public class CSS_QuickServe { 
    // public ID Wid; 
    public static css_job_order__c workJob {get;set;}
    // public static CSS_ECM__c qSol = new CSS_ECM__c();
    public static CSS_Job_Order__c qsol = new CSS_Job_Order__c();
    public static CSS_JobEventTemporary__c cjet = new CSS_JobEventTemporary__c();
    public static CSS_CampTsbTrp__c ctt = new CSS_CampTsbTrp__c();
    
    public static List<CSS_CampTsbTrp__c> cctt = new List<CSS_CampTsbTrp__c>();
    public static List<CSS_JobEventTemporary__c> cctt3 = new List<CSS_JobEventTemporary__c>();
    // public static ID Wid;
    
    
    /*public static CSS_JobEventTemporary__c getFaultCodeOverview_Existing(String inputFaultcode,string esnData){
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        CSS_quickserveCumminsComWebservices.FaultCodeInfo fci = new CSS_quickserveCumminsComWebservices.FaultCodeInfo();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        System.debug('The esn is'+esnData);
        string key;
        string esn; 
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                esn = esnData;
            }else{
                key = '1234';
                esn = '79464646';
            }
            CSS_Fault_Code__c cfc = new CSS_Fault_Code__c();
            //string esn = '79462241';
            // cfc =[select id,FaultCode__c,Job_Order__r.ESN__c from CSS_Fault_Code__c where Job_Order__c=:Wid ];
            //fci = qccw.getFaultCodeOverview('1234','79464646','441');
            System.debug('The key is !#!#@!'+key);
            fci = qccw.getFaultCodeOverview(key,esn,inputFaultcode);
            System.debug('The get fault code overview is !!!@@@@'+fci);
            cjet.Name = fci.faultCode;
            cjet.SPN__c = fci.spn;
            cjet.FMI__c = fci.fmi;
            cjet.Lamp__c = fci.lamp;
            cjet.Fault_Code_Description__c = fci.description;
            cjet.Comp_Location__c = fci.compLocation;
            cjet.Circuit_Description__c = fci.circuitDescription;
            cjet.Reason__c = fci.reason;
            cjet.Effect__c = fci.effect;
            cjet.File_Name__c = fci.url;
            cjet.Engine__c = fci.engine;  
            //insert cjet;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            //qsolIntegrationError(e.getMessage());
        }
        return cjet;
    }*/
    
    
    public static CSS_JobEventTemporary__c getFaultCodeOverview(String inputFaultcode,String esnData){
        System.debug('The esn is'+esnData);
        System.debug('The inputFaultcode is'+inputFaultcode);
        //string esn; 
        try{
            // fci = qccw.getFaultCodeOverview(key,esn,inputFaultcode);
           CG_OP_OAGWrapper resWrapper;
                    resWrapper = CG_SL_QSOL.callGetQsolService(esnData,'GetFaultCodeOverviewQsolREST',inputFaultcode,'','','','','');
                    
                    //system.debug('resWrapper**'+resWrapper.response.getBody());
                    CG_OP_GetFaultCodeOverviewRespWrapper fci = new CG_OP_GetFaultCodeOverviewRespWrapper();
                    if(!Test.isRunningTest()){
                        if(resWrapper.response != null){
                            fci = (CG_OP_GetFaultCodeOverviewRespWrapper)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_GetFaultCodeOverviewRespWrapper.class);
                        }
                    }
                    else{
                        string res='{'+'    \"faultCode\": \"2636\",'+'    \"pid\": \"S27\",'+'    \"spn\": \"641\",'+'    \"fmi\": \"9\",'+'    \"lamp\": \"Red\",'+'    \"srt\": \"\",'+'    \"description\": \"VGT Actuator Driver Circuit - Abnormal Update Rate\",'+
                            		'    \"compLocation\": \"The VGT actuator is located on the turbocharger bearing housing.\",'+
                            		'    \"circuitDescription\": \"The variable geometry turbocharger (VGT) is electronically activated by the VGT actuator. The VGT actuator is a smart device and receives information via the J1939 data link from the primary engine control module (ECM). The VGT actuator performs its own diagnostics and reports malfunctions back to the primary engine ECM, using the J1939 data link. The ECM then decodes the error message and converts it to a fault code.\",'+
                            		'    \"reason\": \"VGT Actuator Driver Circuit - Abnormal Update Rate. No communications on the J1939 data link between the engine ECM and the smart VGT controller.\",'+
                            		'    \"effect\": \"Possible reduced engine performance.\",'+
                            		'    \"sysName\": \"\",'+
                            		'    \"url\": \"https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/454/454-fc2636.html\",'+
                            		'    \"engine\": \"454\"'+
                            		'}';
                        fci = (CG_OP_GetFaultCodeOverviewRespWrapper)JSON.deserializeStrict(res, CG_OP_GetFaultCodeOverviewRespWrapper.class);
                    }
            		if(fci != null){
                        //fci = (CG_OP_GetFaultCodeOverviewRespWrapper)JSON.deserializeStrict(resWrapper.response.getBody(), CG_OP_GetFaultCodeOverviewRespWrapper.class);
                        System.debug('The get fault code overview is !!!@@@@'+fci);
                        cjet.Name = fci.faultCode;
                        cjet.SPN__c = fci.spn;
                        cjet.FMI__c = fci.fmi;
                        cjet.Lamp__c = fci.lamp;
                        cjet.Fault_Code_Description__c = fci.description;
                        cjet.Comp_Location__c = fci.compLocation;
                        cjet.Circuit_Description__c = fci.circuitDescription;
                        cjet.Reason__c = fci.reason;
                        cjet.Effect__c = fci.effect;
                        cjet.File_Name__c = fci.url;
                        cjet.Engine__c = fci.engine; 
                        return cjet;
                    }
                    else{
                        return null;
                    }
            //insert cjet;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage()+e.getLineNumber());
            //qsolIntegrationError(e.getMessage());
            return null;
        }
        //return cjet;
    }
    
                /* public static string getTsbsForFaultCode(){
            CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
            CSS_quickserveCumminsComWebservices.ArrayOfTsbdocument tfcr = new CSS_quickserveCumminsComWebservices.ArrayOfTsbdocument();
            CSS_quickserveCumminsComWebservices.TsbDocument item = new CSS_quickserveCumminsComWebservices.TsbDocument();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            string key;
            string esn;
            try{
            //CSS_Fault_Code__c cfc = new CSS_Fault_Code__c();
            //cfc =[select id,FaultCode__c,Job_Order__r.ESN__c from CSS_Fault_Code__c where Job_Order__c=:Wid ];
            //tfcr = qccw.getTsbsForFaultCode('1234',cfc.Job_Order__r.ESN__c,cfc.FaultCode__c,'');
            if(!Test.isRunningTest()){
            conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
            key = conDetails.Key__c;
            esn = '79464646';
            }else{
            key = '1234';
            esn = '79464646';
            }
            tfcr = qccw.getTsbsForFaultCode(key,esn,'441','white smoke');
            
            item = tfcr.item[0];
            System.debug('The get tsbs for fault code is !!!@@@@'+item);
            ctt.Name = 'TSB';
            ctt.Doc_Num__c = item.doc_num;
            ctt.Doc_Title__c = item.doc_title;
            ctt.Group_Name__c = item.group_name;
            ctt.Group_Num__c = item.group_num;
            ctt.URL__c = item.url;
            insert ctt;
            }
            catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
            }
            return item.doc_num;
            }*/
    
    /*@future (callout=true)
    public static void getDataPlateDocSave_Existing(Id jobOrder,string esn){
        //CSS_ECM__c qSol = new CSS_ECM__c();
        System.debug('The id inside getDataPlateDoc save is!@!#!'+jobOrder);
        System.debug('The esn inside getDataPlateDoc save is!#@!#@!'+esn);
        string shopOrder;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        string getsEsn;
        String siebSMN;
        String siebMake;
        String siebModel;
        String siebVIN;
        date siebelWarrantyDate;
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        CSS_quickserveCumminsComWebservices.ModelName mn = new CSS_quickserveCumminsComWebservices.ModelName();
        qccw.timeout_x=100000;
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                getsEsn = esn;
            }else{
                key = '1234';
                getsEsn = '79464646';
            }
            //  CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            //  cjo = [Select id,esn__c from CSS_Job_Order__c where id=:jobOrder];
            //GRP CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
            //GRP CSS_quickserveCumminsComWebservices.ModelName mn = new CSS_quickserveCumminsComWebservices.ModelName();
            //GRP qccw.timeout_x=100000;
            //mn = qccw.getEngineDataplate(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,'79464646');
            //System.debug('The qsol is !!!@@@@'+mn);
            //mn = qccw.getEngineDataplate(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,cjo.ESN__c);
            // mn = qccw.getEngineDataplate(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,esn);
            mn = qccw.getEngineDataplate(key,getsEsn);
            
            //Calling SiebelWS to get data 63173-Start
            
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataResponseJ2A  engineData;
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN=getsEsn;            
            wrapobj.DataArea = jidi;           
            engineData = CSS_WS_SBL.getEngineData(wrapobj);
            system.debug('engineData>>>>'+engineData);

            //Story:183077
               if((mn!=null && mn.ResponseMessage!=null && mn.ResponseMessage.contains('SUCCESS')) || (engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')))
               {
                  qsol.Get_Engine_data_flag__c=false;
               }
               else {
                     CSS_Job_Order__c servJob = [SELECT Id,PSN_Not_Available__c FROM CSS_Job_Order__c WHERE Id =: jobOrder limit 1]; //This query will get invoke only if both QSOL & Siebel webservice failure. Hence either this query wil run or below one at line no 206.
                      qsol.id=jobOrder;
                     IF(servJob.PSN_Not_Available__c!=null && servJob.PSN_Not_Available__c!=true){
                         system.debug('Story#183077 enters>>');
                          qsol.Get_Engine_data_flag__c=false; //qsol.Get_Engine_data_flag__c=true
                          
                     }
                    else{
                        qsol.Get_Engine_data_flag__c=false;
                    }
                    update qsol;
                }
               
               //end
            
            if (engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                
                if ( string.valueOf(engineData.DataArea.ServiceModelName)!=''  )
                    siebSMN = engineData.DataArea.ServiceModelName;
                
                if (string.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
                    siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                
                //if ( string.valueOf(engineData.DataArea.Manufacturer)!=''){
                    //siebMake= engineData.DataArea.Manufacturer;
                    //Chking if Make exists in CSS
                    //siebMake = css_utility.getMake(siebMake);
                //}
                
                //if (string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){
                    //siebModel= engineData.DataArea.Model;
                    //chking if Model exists
                   // siebModel = css_utility.getModel(siebMake,siebModel);
                //}
                if (string.valueOf(engineData.DataArea.vin)!='' ){
                    siebVIN = engineData.DataArea.vin;
                }
            }
            
            
            if(mn.ResponseMessage!= null) {  // Sai:0926:Added the outer If logic.          
                if (mn.ResponseMessage.toUpperCase() == 'SUCCESS'){
                    System.debug('The qsol is !!!@@@@'+mn);
                    
                    //qSol.Name = 'QSOL';
                    //qSol.Type__c = 'QSOL';
                    //qsol.Job_Order__c=jobOrder;
                    //qsol.Job_Order__c=cjo.id;
                    System.debug('jobOrder!@@@@'+jobOrder);
                    //cjo.id = jobOrder;
                    //cjo.Service_Model__c = mn.serviceModel;
                    qsol.id = jobOrder;
                    if(mn.serviceModel!= '' || mn.serviceModel!= null){
                        qSol.Service_Model__c = mn.serviceModel;}
                    if ((mn.serviceModel == '' || mn.serviceModel == null) &&(siebSMN!='')){
                        qSol.Service_Model__c =siebSMN;
                    }
                    //if ( siebMake !='' || siebMake != null){
                        //qSol.Make__c = siebMake;                  
                    //}
                    //if ( siebModel != '' || siebModel!= null){
                        //qSol.Model__c=siebModel;
                    //}
                    CSS_Job_Order__c servJob = [SELECT Id, VIN__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: jobOrder limit 1];
                    if(servJob.Warranty_Start_Date__c == null){
                    if (string.valueof(siebelWarrantyDate) != null && string.valueof(siebelWarrantyDate) != ''){
                        qSol.Warranty_Start_Date__c=siebelWarrantyDate;
                    }else if (mn.warrantyStart!= null && mn.warrantyStart != '') {
                        qSol.Warranty_Start_Date__c  = date.valueOf(mn.warrantyStart);
                    }
                    }
                    //qSol.VIN__c ='';
                    system.debug('mn.vin > ' + mn.vin + ' siebVIN ' + siebVIN);
                    if(mn.vin!= '' && mn.vin!=null){
                        //system.debug('A');
                        qSol.VIN__c = mn.vin;
                        qSol.VIN_Flag__c = false;
                    }
                    //system.debug('qSol.VIN__c > ' + qSol.VIN__c);
                    if((mn.vin == '' ||mn.vin == null) && ( siebVIN!='' && siebVIN!=null)){
                        //system.debug('A1');
                        qSol.VIN__c = siebVIN;
                        qSol.VIN_Flag__c = false;
                    }
                    //system.debug('qSol.VIN__c > ' + qSol.VIN__c);
                    if((mn.vin == '' || mn.vin == null) && (siebVIN == null || siebVIN == '')){
                        //system.debug('A2');
                    qSol.VIN_Flag__c = true;
                        //qSol.VIN__c = '';
                    }
                    qSol.Qsol_Marketing_Model__c = mn.marketingModel;
                    qSol.Qsol_Build_Date__c = mn.buildDate;
                    qSol.Qsol_Warranty_Start__c = mn.warrantyStart;
                    qSol.Qsol_EPA_Model_Name__c = mn.epaModelName;
                    qSol.Qsol_Shop_Order__c = mn.shopOrder;
                    qSol.Qsol_Build_Plant__c = mn.buildPlant;
                    qSol.Qsol_ECM_Code__c = mn.ecmCode;
                    qSol.Qsol_Fuel_Pump_Part_Number__c = mn.fuelPumpPartNumber;
                    qSol.Qsol_Fuel_Pump_Calibration__c = mn.fuelPumpCalibration;
                    qSol.Qsol_Marketing_Config__c = mn.marketingConfig;
                    qSol.Qsol_Technical_Config__c = mn.technicalConfig;
                    qSol.Qsol_CPL_Number__c= mn.cplNumber;
                    qSOL.Qsol_ESN_Customer_Number__c = mn.customerNumber;
                    qSol.Qsol_Business_Unit__c = mn.businessUnit;
                    qsol.Get_Engine_data_flag__c=false;//story#183077
                    shopOrder = mn.shopOrder;
                    string eFC = string.valueOf(mn.technicalConfig);
                    system.debug('eFCcccc'+eFC);
                    string engineFamilyCode = efc.substring(1,3);
                    system.debug('engineFamilyCode***'+engineFamilyCode);
                    qsol.Qsol_Engine_Family_Code__c = engineFamilyCode;
                    update qSol;
                    
                }
                else{
                    css_utility.LogOutIntError('Request : By = ' + UserInfo.getUserId() + '/' + + UserInfo.getName() + '/ Job Id = ' + jobOrder + '/ ESN = ' + esn + ' ***Response: MN = ' + JSON.serialize(mn), mn.ResponseMessage, 'QSOL Data Error', 'QSOLDP');
                }
            }
            else { // Sai:0926:Added the outer else logic.
                css_utility.LogOutIntError('Request : By = ' + UserInfo.getUserId() + '/' + + UserInfo.getName() + '/ Job Id = ' + jobOrder + '/ ESN = ' + esn + ' ***Response: MN = ' + JSON.serialize(mn), mn.ResponseMessage, 'QSOL Dataplate Not Available', 'QSOLDP');
            }
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
    }*/
    
    
    
     @future (callout=true)
    public static void getDataPlateDocSave(Id jobOrder,string esn, string make, string model, Boolean psnNotAvailable){
        //CSS_ECM__c qSol = new CSS_ECM__c();
        System.debug('The id inside getDataPlateDoc save is!@!#!'+jobOrder);
        System.debug('The esn inside getDataPlateDoc save is!#@!#@!'+esn);
        string shopOrder;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        string getsEsn;
        String siebSMN;
        String siebMake;
        String siebModel;
        String siebVIN;
        string engineFamilyCode;
        date siebelWarrantyDate;
        Boolean recconFlag;
        try{
            CSS_getEngineDataResponseJ2A rDataPlate = new CSS_getEngineDataResponseJ2A(); //GSSC_97, ROD:Qsol changes
            rDataPlate = CG_BL_Intake.GetEngineDataPlateQSOL(esn); //GSSC_97, ROD:Qsol changes
            System.debug(rDataPlate);
            
            //Calling SiebelWS to get data 63173-Start
            
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataResponseJ2A  engineData;
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN=esn;            
            wrapobj.DataArea = jidi;           
            engineData = CSS_WS_SBL.getEngineData(wrapobj);
            system.debug('engineData>>>>'+engineData);
           //ROD Changes GSSC_97, As per latest update, QSOL Service call is stopped and data is retrieved from Asset
           
           //system.debug('rDataPlate'+rDataPlate+'engineData'+engineData+'engineData.Header.Status'+engineData.Header.Status);
           if(rDataPlate != null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                system.debug('First block>>>>>>>');
                qsol.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
        
                system.debug('engineData.DataArea.AutomotiveAppFlag'+engineData.DataArea.AutomotiveAppFlag);
                qsol.Automotive_App_Flag__c = engineData.DataArea.AutomotiveAppFlag;
                system.debug('qsol.Automotive_App_Flag__c'+qsol.Automotive_App_Flag__c);
        
                system.debug('engineData.DataArea.EngineAppCode)'+engineData.DataArea.EngineAppCode);
                if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                    List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();//As per defect 152086 by vamshi                       
                    for(Integer i = 0; i < ListOfValues.size() ; i++){
                        if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode && ListOfValues[i].Type__c == 'Application Code'){ // As per defect 175482 by Rajesh N
                            qsol.Application_Desc__c = ListOfValues[i].Picklist_Values_1__c;
                            break;
                        } 
                        else{
                            qsol.Application_Desc__c = '';
                        }
                    }                                                     
           		}
                if (engineData.DataArea.ServiceModelName !=null && string.valueOf(engineData.DataArea.ServiceModelName).trim() !=''  )
                        qsol.Service_Model__c = engineData.DataArea.ServiceModelName;
        
                if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='')               
                    siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                if (string.valueof(siebelWarrantyDate) !=''  && string.valueof(siebelWarrantyDate) != null){
                    qsol.Warranty_Start_Date__c=siebelWarrantyDate;
                        system.debug('Checking siebel warranty'+qsol.Warranty_Start_Date__c+siebelWarrantyDate);
                    qsol.Before_In_Service__c = false;
                }else if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                    qsol.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                    system.debug('Checking dataplate warranty'+qsol.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.DataArea.warrantyStartDate));
                    qsol.Before_In_Service__c =  false;
                }else{
                    system.debug('Checking before in service');
                    qsol.Warranty_Start_Date__c = null;
                }
        
                qsol.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702 --QsolKal--
                if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                    qsol.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                }else{  
                    if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                        qsol.VIN__c = siebVIN;
                        qsol.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                }
                if((qsol.ESN__c !='' && qsol.ESN__c!= null) && (qsol.VIN__c == '' || qsol.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                    qsol.VIN_Flag__c = true;
        
                if(engineData.DataArea.EngineFamilyCode != null ){
                    qsol.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;                        
                }else{
                    qsol.Qsol_Engine_Family_Code__c = rDataPlate.DataArea.EngineFamilyCode;
                }
        
                //Make SOT1=SBL  
                if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                    if (string.valueOf(engineData.DataArea.Manufacturer)!=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        qsol.Make__c = engineData.DataArea.Manufacturer;
                        qsol.Make__c = css_utility.getMake(qsol.Make__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{   
                        qsol.Make__c = '';
                    }
                    //Model SOT1=SBL 
                    system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                    if (string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        qsol.Model__c = engineData.DataArea.Model;
                        qsol.Model__c = css_utility.getModel(qsol.Make__c,qsol.Model__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                    }else{
                        qsol.Model__c = '';
                    }
                }
                //Unit Configuration
                system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration)); 
                if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                if(string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                    if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !=''){
                        qsol.Unit_Type__c = engineData.DataArea.EquipmentConfiguration;
                        system.debug('Assign Unit Cinfig--->'+qsol.Unit_Type__c);
                        if(qsol.Unit_Type__c != null && qsol.Unit_Type__c != ''){
                            qsol.Unit_Type__c = css_utility.getUnitype(qsol.Make__c, qsol.Model__c, qsol.Unit_Type__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                            system.debug('SRT Web Unit Cinfig--->'+qsol.Unit_Type__c);
                        }
                        if(qsol.Unit_Type__c == null || qsol.Unit_Type__c == ''){
                            qsol.Unit_Type__c = css_utility.getUnitype(qsol.Make__c, qsol.Model__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                            system.debug('SRT Web Unit Cinfig--->'+qsol.Unit_Type__c);
                        }                        
                    }else
                        qsol.Unit_Type__c = '';
                    system.debug('CSS_UTILITY----->' +qsol.Unit_Type__c);
                }else{
                    qsol.Unit_Type__c = '';
                }
             }
                if(qsol.Service_Model__c == null || qsol.Service_Model__c == ''){
                    system.debug('qsol.Service_Model__c1'+qsol.Service_Model__c);
                }
        
                //add new engine data new fields
                qsol.BillToCode__c = engineData.DataArea.EngineBillToCode;
                if(engineData.DataArea.BuildDate != null && engineData.DataArea.BuildDate !=''){
                    qsol.BuildDate__c = Date.valueOf(engineData.DataArea.BuildDate);}
                qsol.DesignPhaseCode__c = engineData.DataArea.DesignPhaseCode;
                qsol.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                system.debug('engineData.DataArea.EtoConversionDate**'+engineData.DataArea.EtoConversionDate);
                
                if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !=''){
                    qsol.EtoConversionDate__c = Date.valueOf(engineData.DataArea.EtoConversionDate);
        
                    if(engineData.DataArea.ETOOldESN.isNumeric())
                        recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                    System.debug('** ReconFlag'+recconFlag);
                    if(recconFlag == true){
                        qsol.ReconEngineFlag__c = 'Y';
                    }
                    else{
                        qsol.ReconEngineFlag__c = 'N';
                    }
                }
                else{
                    if(qsol != null && qsol.ESN__c != null && qsol.ESN__c != '' && qsol.ESN__c.isNumeric())
                        recconFlag = css_utility.getReconEngine(decimal.valueof(qsol.ESN__c));
                    System.debug('** ReconFlag'+recconFlag);
                    if(recconFlag == true){
                        qsol.ReconEngineFlag__c = 'Y';
                    }
                    else{
                        qsol.ReconEngineFlag__c = 'N';
                    }
                }
        
                qsol.MarineFlag__c = engineData.DataArea.MarineAppFlag;
                qsol.OemCode__c = engineData.DataArea.OEMSPCode;
                //qsol.ProductApplicationDesp__c = engineData.DataArea.ProdAppCode; //As per defect 152086
                qsol.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                qsol.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                system.debug('Vamshi test>>>>'+qsol.ProductApplicationDesp__c);
                qsol.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'N' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'Y' : '')) ;   
        
                //Story# 153520
                system.debug('***EngineFamilyName**'+engineData.DataArea.EngineFamilyName);
                system.debug('***ShipDate**'+engineData.DataArea.ShipDate);
                system.debug('***ETOOldESN**'+engineData.DataArea.ETOOldESN);
                qsol.EngineFamilyName__c = engineData.DataArea.EngineFamilyName;
                if(engineData.DataArea.ShipDate != null && engineData.DataArea.ShipDate !='')
                    qsol.ShipDate__c = Date.valueOf(engineData.DataArea.ShipDate);
                qsol.ETOOldESN__c = engineData.DataArea.ETOOldESN;
                system.debug('engineData.DataArea.ProdAppDesc'+ engineData.DataArea.ProdAppDesc);
        
                system.debug('engineData.DataArea.ProdAppCode'+ engineData.DataArea.ProdAppCode);

                }else if(rDataPlate != null && (engineData == null || engineData.DataArea == null || !engineData.Header.Status.contains('Success'))){

                    system.debug('second block>>>>>>>');
                    qsol.Service_Model__c = rDataPlate.DataArea.ServiceModelName;

                    if (rDataPlate.DataArea.warrantyStartDate != null && rDataPlate.DataArea.warrantyStartDate != '') {
                        qsol.Warranty_Start_Date__c  = parseQSOLDate(rDataPlate.DataArea.warrantyStartDate);
                        system.debug('Checking dataplate warranty'+qsol.Warranty_Start_Date__c+parseQSOLDate(rDataPlate.DataArea.warrantyStartDate));
                        qsol.Before_In_Service__c =  false;
                    }else{
                        system.debug('Checking before in service');
                        qsol.Warranty_Start_Date__c = null;
                    }

                    qsol.VIN__c = rDataPlate.DataArea.vin; // Sai: 4/11/2017 Added for CUBS defect # 78702 --QsolKal--
                    if(rDataPlate.DataArea.vin != '' && rDataPlate.DataArea.vin !=null){ // code added by roopa
                        qsol.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((qsol.ESN__c !='' && qsol.ESN__c!= null) && (qsol.VIN__c == '' || qsol.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        qsol.VIN_Flag__c = true;

                   if(rDataPlate.DataArea.EngineFamilyCode != null ){
                        qsol.Qsol_Engine_Family_Code__c = rDataPlate.DataArea.EngineFamilyCode;
                        //qsol.Qsol_Engine_Family_Code__c=sEngineFamilyCode;
                   }
                    
                    if(qsol.ESN__c.isNumeric())
                        recconFlag = css_utility.getReconEngine(decimal.valueof(qsol.ESN__c));
                    System.debug('** ReconFlag'+recconFlag);
                    if(recconFlag == true){
                        qsol.ReconEngineFlag__c = 'Y';
                    }
                    else{
                        qsol.ReconEngineFlag__c = 'N';
                    }

                }
                else if(rDataPlate == null && engineData != null && engineData.DataArea != null && engineData.Header.Status.contains('Success') ){
                    system.debug('third block>>>>>>>');
                    qsol.PSN_PACCAR_Flag__c = engineData.DataArea.PACCARFlag;
					
                    if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                        List<CSS_List_Of_Values__c> ListOfValues = CSS_List_Of_Values__c.getall().values();//As per defect 152086 by vamshi                       
                        for(Integer i = 0; i < ListOfValues.size() ; i++){
                            if(ListOfValues[i].Code__c == engineData.DataArea.EngineAppCode && ListOfValues[i].Type__c == 'Application Code'){ // As per defect 175482 by Rajesh N
                                qsol.Application_Desc__c = ListOfValues[i].Picklist_Values_1__c;
                                break;
                            } 
                            else{
                                qsol.Application_Desc__c = '';
                            }
                        }  
                    }
                    qsol.Service_Model__c = engineData.DataArea.ServiceModelName;

                    if (string.valueOf(engineData.DataArea.WarrantyStartDate) !='') {              
                        qsol.Warranty_Start_Date__c = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));
                        qsol.Before_In_Service__c = false;
                    }else{
                        system.debug('Checking before in service');
                        qsol.Warranty_Start_Date__c = null;
                    }

                    if (string.valueOf(engineData.DataArea.vin) !='' && string.valueOf(engineData.DataArea.vin) !='' ){
                        siebVIN = string.valueOf(engineData.DataArea.vin);
                        qsol.VIN__c = siebVIN;
                        qsol.VIN_Flag__c = false; // Sai:4/11/2017: Added this for CUBS Story # 88616
                    }
                    if((qsol.ESN__c !='' && qsol.ESN__c!= null) && (qsol.VIN__c == '' || qsol.VIN__c == null)) // Sai:4/11/2017: Added this for CUBS Story # 88616
                        qsol.VIN_Flag__c = true;

                    qsol.Qsol_Engine_Family_Code__c=engineData.DataArea.EngineFamilyCode;
					
                    if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                        if (string.valueOf(engineData.DataArea.Manufacturer)!=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                            qsol.Make__c= engineData.DataArea.Manufacturer;
                            qsol.Make__c = css_utility.getMake(qsol.Make__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                        }else{   
                            qsol.Make__c = '';
                        }
    
                        system.debug('Model--->'+string.valueOf(engineData.DataArea.Model));
                        if (string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !='' ){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                            qsol.Model__c= engineData.DataArea.Model;
                            qsol.Model__c = css_utility.getModel(qsol.Make__c, qsol.Model__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                        }else{
                            qsol.Model__c = '';
                        }
                    }
                    system.debug('Unit Configuration'+string.valueOf(engineData.DataArea.EquipmentConfiguration));
                    if(psnNotAvailable == true && make == 'UNLISTED' && model == 'ALL'){
                    if(string.valueOf(engineData.DataArea.Manufacturer)!='' && string.valueOf(engineData.DataArea.Model) !=''){ // Rajesh: 178700 callStartRequestFromBMSPopup == false to autopopulate it from SRT Web
                        if(engineData.DataArea.EquipmentConfiguration !=null && engineData.DataArea.EquipmentConfiguration !=''){
                            qsol.Unit_Type__c = engineData.DataArea.EquipmentConfiguration;
                            //chking if Make, Model, EquipmentConfiguration exists in CSS SRT WEB
                            if(qsol.Unit_Type__c != null && qsol.Unit_Type__c != ''){
                                qsol.Unit_Type__c = css_utility.getUnitype(qsol.Make__c, qsol.Model__c, qsol.Unit_Type__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+qsol.Unit_Type__c);
                            }
                            if(qsol.Unit_Type__c == null || qsol.Unit_Type__c == ''){
                                qsol.Unit_Type__c = css_utility.getUnitype(qsol.Make__c, qsol.Model__c, engineData.DataArea.EngineFamilyCode, engineData.DataArea.EquipmentId);
                                system.debug('SRT Web Unit Cinfig--->'+qsol.Unit_Type__c);
                            }

                        }else
                            qsol.Unit_Type__c = '';
                            
                        system.debug('CSS_UTILITY----->' +qsol.Unit_Type__c);
                    }else{
                        qsol.Unit_Type__c = '';
                    }
                 }
                    if(qsol.Service_Model__c == null || qsol.Service_Model__c == ''){
                        system.debug('qsol.Service_Model__c3'+qsol.Service_Model__c);
                        system.debug('qsol.Service_Model__c'+qsol.Service_Model__c);
                    }

                    qsol.BillToCode__c = engineData.DataArea.EngineBillToCode;
                    if(engineData.DataArea.BuildDate != null && engineData.DataArea.BuildDate !=''){
                        qsol.BuildDate__c = Date.valueOf(engineData.DataArea.BuildDate);}
                    qsol.DesignPhaseCode__c = engineData.DataArea.DesignPhaseCode;
                    qsol.EngineFamilyCode__c = engineData.DataArea.EngineFamilyCode;
                    if(engineData.DataArea.EtoConversionDate != null && engineData.DataArea.EtoConversionDate !='')  // Kalpana Added null check
                    {
                        qsol.EtoConversionDate__c = Date.valueOf(engineData.DataArea.EtoConversionDate);

                        if(engineData.DataArea.ETOOldESN.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(engineData.DataArea.ETOOldESN));
                        System.debug('** ReconFlag'+recconFlag);
                        if(recconFlag == true){
                            qsol.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            qsol.ReconEngineFlag__c = 'N';
                        }
                    }
                    else{
                        if(esn.isNumeric())
                            recconFlag = css_utility.getReconEngine(decimal.valueof(esn));
                        System.debug('** ReconFlag'+recconFlag);
                        if(recconFlag == true){
                            qsol.ReconEngineFlag__c = 'Y';
                        }
                        else{
                            qsol.ReconEngineFlag__c = 'N';
                        }
                    }
                    qsol.MarineFlag__c = engineData.DataArea.MarineAppFlag;
                    qsol.OemCode__c = engineData.DataArea.OEMSPCode;
                    qsol.ProductApplicationDesp__c = engineData.DataArea.ProdAppDesc;
                    qsol.ProductApplicationCode__c = engineData.DataArea.ProdAppCode;
                    qsol.warrantyIndicatorFlag__c = (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'Y' ? 'N' : (engineData.DataArea.NoWarranty != null && engineData.DataArea.NoWarranty == 'N' ? 'Y' : '')) ;   

                    //Story# 153520
                    system.debug('***EngineFamilyName**'+engineData.DataArea.EngineFamilyName);
                    system.debug('***ShipDate**'+engineData.DataArea.ShipDate);
                    system.debug('***ETOOldESN**'+engineData.DataArea.ETOOldESN);
                    qsol.EngineFamilyName__c = engineData.DataArea.EngineFamilyName;
                    if(engineData.DataArea.ShipDate != null && engineData.DataArea.ShipDate !='')
                        qsol.ShipDate__c = Date.valueOf(engineData.DataArea.ShipDate);
                    qsol.ETOOldESN__c = engineData.DataArea.ETOOldESN;

                }else{

                    /*if((callStartRequestFromBMSPopup != true || callStartRequestFromBMSPopup == true)){
                        qsol.Make__c = '';
                        qsol.Model__c = '';
                    }*/
                }
           
           
           
           // Commented old logic start
            /*if( (mn==null || mn.DataArea == null) &&  (engineData== null || engineData.DataArea == null || !engineData.Header.Status.contains('Success')))
            {
                qsol.Get_Engine_data_flag__c=true;
                
            }
            else{
                        qsol.Get_Engine_data_flag__c=false;
                    }
             //Story:183077

            if (engineData.DataArea != null && engineData.Header.Status.contains('Success')){
                
                if ( string.valueOf(engineData.DataArea.ServiceModelName)!=''  )
                    siebSMN = engineData.DataArea.ServiceModelName;
                
                if (string.valueOf(engineData.DataArea.WarrantyStartDate)!='')               
                    siebelWarrantyDate = date.valueOf(string.valueOf(engineData.DataArea.WarrantyStartDate));

                if (string.valueOf(engineData.DataArea.vin)!='' ){
                    siebVIN = engineData.DataArea.vin;
                }
                
                if(engineData.DataArea.EngineFamilyCode != null){
                     engineFamilyCode = engineData.DataArea.EngineFamilyCode;
                 }
                
                // Added below code to fix defect GSSC-714 start
                qsol.id = jobOrder;
                
                if (siebSMN != ''){
                	qSol.Service_Model__c = siebSMN;
                }
                					
                if(siebVIN != null && siebVIN != ''){
                	qSol.VIN__c = siebVIN;
                	qSol.VIN_Flag__c = false;
                }
                if(siebVIN == null || siebVIN == ''){
                    qSol.VIN_Flag__c = true;
                }
                // Added below code to fix defect GSSC-714 end
            }
            
            
            if(mn!= null && mn.DataArea != null) {  // Sai:0926:Added the outer If logic.          
               // if (mn.DataArea.responseMsg.toUpperCase() == 'SUCCESS'){
                    System.debug('The qsol is !!!@@@@'+mn);
                    
                    //qSol.Name = 'QSOL';
                    //qSol.Type__c = 'QSOL';
                    //qsol.Job_Order__c=jobOrder;
                    //qsol.Job_Order__c=cjo.id;
                    System.debug('jobOrder!@@@@'+jobOrder);
                    //cjo.id = jobOrder;
                    //cjo.Service_Model__c = mn.serviceModel;
                    qsol.id = jobOrder;
                    if(mn.DataArea.ServiceModelName!= '' || mn.DataArea.ServiceModelName!= null){
                        qSol.Service_Model__c = mn.DataArea.ServiceModelName;}
                    if ((mn.DataArea.ServiceModelName == '' || mn.DataArea.ServiceModelName == null) &&(siebSMN!='')){
                        qSol.Service_Model__c =siebSMN;
                    }

                    CSS_Job_Order__c servJob = [SELECT Id, VIN__c, Warranty_Start_Date__c FROM CSS_Job_Order__c WHERE Id =: jobOrder limit 1];
                    if(servJob.Warranty_Start_Date__c == null){
                    if (string.valueof(siebelWarrantyDate) != null && string.valueof(siebelWarrantyDate) != ''){
                        qSol.Warranty_Start_Date__c=siebelWarrantyDate;
                    }else if (mn.DataArea.warrantyStartDate!= null && mn.DataArea.warrantyStartDate != '') {
                        qSol.Warranty_Start_Date__c  = date.valueOf(mn.DataArea.warrantyStartDate);
                    }
                    }
                    //qSol.VIN__c ='';
                    system.debug('mn.vin > ' + mn.DataArea.vin + ' siebVIN ' + siebVIN);
                    if(mn.DataArea.vin!= '' && mn.DataArea.vin!=null){
                        //system.debug('A');
                        qSol.VIN__c = mn.DataArea.vin;
                        qSol.VIN_Flag__c = false;
                    }
                    qSol.PSN_PACCAR_Flag__c = mn.DataArea.PACCARFlag;//Added a part of GSSC-278
                    //system.debug('qSol.VIN__c > ' + qSol.VIN__c);
                    if((mn.DataArea.vin == '' ||mn.DataArea.vin == null) && ( siebVIN!='' && siebVIN!=null)){
                        //system.debug('A1');
                        qSol.VIN__c = siebVIN;
                        qSol.VIN_Flag__c = false;
                    }
                    //system.debug('qSol.VIN__c > ' + qSol.VIN__c);
                    if((mn.DataArea.vin == '' || mn.DataArea.vin == null) && (siebVIN == null || siebVIN == '')){
                        //system.debug('A2');
                    qSol.VIN_Flag__c = true;
                        //qSol.VIN__c = '';
                    }
                    //qSol.Qsol_Marketing_Model__c = mn.DataArea.marketingEngineModel;
                    qSol.Qsol_Marketing_Model__c = mn.DataArea.Model;
                    qSol.Qsol_Build_Date__c = mn.DataArea.BuildDate;
                    qSol.Qsol_Warranty_Start__c = mn.DataArea.warrantyStartDate;

                    qSol.Qsol_Technical_Config__c = mn.DataArea.EquipmentConfiguration;
                    qSol.Qsol_CPL_Number__c= mn.DataArea.CriticalPartsListNumber;
                    //qSOL.Qsol_ESN_Customer_Number__c = mn.DataArea.customerNumber;
                    //qSol.Qsol_Business_Unit__c = mn.DataArea.businessUnit;
                    qsol.Get_Engine_data_flag__c=false;//story#183077
                    //shopOrder = mn.DataArea.shopOrder;
                    //string eFC = string.valueOf(mn.DataArea.EquipmentConfiguration);
                    //system.debug('eFCcccc'+eFC);
                    
                    if(engineFamilyCode == null){
                         engineFamilyCode = mn.DataArea.EngineFamilyCode;
                    }
                    
                    system.debug('engineFamilyCode***'+engineFamilyCode);
                    qsol.Qsol_Engine_Family_Code__c = engineFamilyCode;
            }
            else { // Sai:0926:Added the outer else logic.
                //css_utility.LogOutIntError('Request : By = ' + UserInfo.getUserId() + '/' + + UserInfo.getName() + '/ Job Id = ' + jobOrder + '/ ESN = ' + esn + ' ***Response: MN = ' + JSON.serialize(mn), mn.DataArea.responseMsg, 'QSOL Dataplate Not Available', 'QSOLDP');
             css_utility.LogOutIntError('Request : By = ' + UserInfo.getUserId() + '/' + + UserInfo.getName() + '/ Job Id = ' + jobOrder + '/ ESN = ' + esn + ' ***Response: MN = ' + JSON.serialize(mn), 'Failure', 'QSOL Dataplate Not Available', 'QSOLDP'); //Kalpana: if mn == null , then treating the responseMsg as Failure
                
            }*/
            // Commented old logic end
            qsol.id = jobOrder; 
            system.debug('qSol--'+qSol);
            update qSol;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage() +' '+e.getLineNumber());
            qsolIntegrationError(e.getMessage());
        }
    }
    public static void qsolIntegrationError(String msg){
        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c(); 
        errObj.Source__c='QSOL';
        errObj.Error_Description__c = msg;
        insert errObj;
    }
    @future (callout=true)
    public static void getQsolDocSave_Existing(Id jobOrder,string esn, string lang){
        System.debug('The id is!@!#!'+jobOrder);
        System.debug('The esn is!#@!#@!'+esn);
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc mn = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        List<CSS_quickserveCumminsComWebservices.WarrantyDoc> warrDoc = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>(); 
        List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        string getsEsn;
        //types = [select Type__c from CSS_CampTsbTrp__c];
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                getsEsn = esn;
                
            }else{
               // conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = '1234';
                getsEsn ='79464646';
            }
            //CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            //cjo = [Select id,esn__c from CSS_Job_Order__c where id=:WId];
            qccw.timeout_x=100000;
            //mn = qccw.getWarrantyDocs(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,cjo.esn__c,'TSB','en');
            for(integer j=0;j<types.size();j++){
                System.debug('The type is@#@#@$ TEST'+types[j]);
                //  mn = qccw.getWarrantyDocs(key,getsEsn,types[j],'en');
                mn = qccw.getWarrantyDocs(key,getsEsn,types[j],lang);
                if(mn!=null){
                    System.debug('The mn is#!@#!#!@'+mn);
                    //if(isRunningTest())
                     //mn.item = 'testItem';
                        warrDoc = mn.item;
                    
                    if(warrDoc!=null){
                        System.debug('The item is#!@#!#!@'+warrDoc);
                        for(integer i=0;i<warrDoc.size();i++){
                            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                            ctt1.Name = types[j] ;
                            ctt1.Type__c = types[j] ;
                            ctt1.Job_Order__c = jobOrder;
                            ctt1.ESN__c = esn;
                            ctt1.Doc_Num__c = warrDoc[i].docNumber;
                            ctt1.Doc_Title__c = warrDoc[i].docTitle;
                            ctt1.URL__c = warrDoc[i].url;  
                            ctt1.Cu_Language__c = lang;
                            cctt.add(ctt1);
                            
                            CSS_JobEventTemporary__c ctt2 = new CSS_JobEventTemporary__c();
                            ctt2.Name = 'QSOL';
                            ctt2.source__c = 'QSOL' ;
                            ctt2.Attribute1__c = types[j] ;
                            ctt2.Attribute2__c = types[j] ;
                            ctt2.Key__c = esn;
                            ctt2.JobOrder__c = jobOrder;
                            ctt2.Attribute7__c = warrDoc[i].docNumber;
                            ctt2.Attribute8__c = warrDoc[i].docTitle;
                            ctt2.Attribute9__c= warrDoc[i].url;  
                            ctt2.Attribute3__c = lang;
                            cctt3.add(ctt2);
                            
                          }
                     
                       }
                }
            }
            system.debug('inside future QSOL'+cctt);
            insert cctt; 
            insert cctt3;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        
    }  
    @future (callout=true)
    public static void getQsolDocSave(Id jobOrder,string esn, string lang){
        try{
            for(List<CSS_CampTsbTrp__c> warrdocs :CG_SL_QSOL.getQSOLWarrantyDocs(jobOrder,null,esn,lang,new list<string>{'CAMPAIGN','TSB','ATC','TRP'})){
                cctt.addall(warrdocs);
                for(CSS_CampTsbTrp__c duc:warrdocs)cctt3.add(new CSS_JobEventTemporary__c(Name = 'QSOL',source__c = 'QSOL',Attribute1__c = duc.Type__c,Attribute2__c = duc.Type__c,Key__c = esn,JobOrder__c = jobOrder,Attribute7__c = duc.Doc_Num__c,Attribute8__c = duc.Doc_Title__c,Attribute9__c= duc.URL__c,Attribute3__c = lang));  
            }
            if(!cctt.isEmpty())insert cctt; 
            if(!cctt3.isEmpty())insert cctt3;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        
    }  
     @future (callout=true)
    public static void getQsolDocSaveforClaims_Existing(Id ClaimId,string esn, string lang){
        System.debug('The id is!@!#!'+ClaimId);
        System.debug('The esn is!#@!#@!'+esn);
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc mn = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        List<CSS_quickserveCumminsComWebservices.WarrantyDoc> warrDoc = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>(); 
        List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        string getsEsn;
        //types = [select Type__c from CSS_CampTsbTrp__c];
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                getsEsn = esn;
                
            }else{
               // conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = '1234';
                getsEsn ='79464646';
            }
            //CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            //cjo = [Select id,esn__c from CSS_Job_Order__c where id=:WId];
            qccw.timeout_x=100000;
            //mn = qccw.getWarrantyDocs(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,cjo.esn__c,'TSB','en');
            for(integer j=0;j<types.size();j++){
                System.debug('The type is@#@#@$ TEST'+types[j]);
                //  mn = qccw.getWarrantyDocs(key,getsEsn,types[j],'en');
                mn = qccw.getWarrantyDocs(key,getsEsn,types[j],lang);
                if(mn!=null){
                    System.debug('The mn is#!@#!#!@'+mn);
                    //if(isRunningTest())
                     //mn.item = 'testItem';
                        warrDoc = mn.item;
                    
                    if(warrDoc!=null){
                        System.debug('The item is#!@#!#!@'+warrDoc);
                        for(integer i=0;i<warrDoc.size();i++){
                            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                            ctt1.Name = types[j] ;
                            ctt1.Type__c = types[j] ;
                            ctt1.CSS_Claims__c = ClaimId;
                            ctt1.ESN__c = esn;
                            ctt1.Doc_Num__c = warrDoc[i].docNumber;
                            ctt1.Doc_Title__c = warrDoc[i].docTitle;
                            ctt1.URL__c = warrDoc[i].url;  
                            ctt1.Cu_Language__c = lang;
                            cctt.add(ctt1);
                            
                            /*CSS_JobEventTemporary__c ctt2 = new CSS_JobEventTemporary__c();
                            ctt2.Name = 'QSOL';
                            ctt2.source__c = 'QSOL' ;
                            ctt2.Attribute1__c = types[j] ;
                            ctt2.Attribute2__c = types[j] ;
                            ctt2.Key__c = esn;
                            //ctt2.CSS_Claims__c = ClaimId;
                            ctt2.Attribute7__c = warrDoc[i].docNumber;
                            ctt2.Attribute8__c = warrDoc[i].docTitle;
                            ctt2.Attribute9__c= warrDoc[i].url;  
                            ctt2.Attribute3__c = lang;
                            cctt3.add(ctt2);*/
                            
                          }
                     
                       }
                }
            }
            system.debug('inside future QSOLClaims'+cctt);
            insert cctt; 
            //insert cctt3;
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        
    }  
     @future (callout=true)
    public static void getQsolDocSaveforClaims(Id ClaimId,string esn, string lang){
        try{
             for(List<CSS_CampTsbTrp__c> warrdocs :CG_SL_QSOL.getQSOLWarrantyDocs(null,ClaimId,esn,lang,new list<string>{'CAMPAIGN','TSB','ATC','TRP'}))cctt.addall(warrdocs);
             system.debug('cctt recs-------'+cctt);
            if(!cctt.isEmpty())insert cctt;
        }catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        
    }
    public static String linkMgmt_Existing(String lang,String docType,String DocId,string Wid){
        string linkMgmtUrl ;
        string procUrl;
        string url;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                
            }else{
                key = '1234';
            }
            //system.debug('Wid--->'+Wid.substring(0,18));
            if(Wid != null && Wid != ''){
            Wid = Wid.substring(0,18);
            }
            workJob=[Select Id,Name,DSID__c,Customer_Name__c,Failure_Point__c,Make__c,Model__c,Equipment_ID__c,Application__c,Application_Desc__c,Unit_Number__c,Service_Model__c,
                     Failure_Point_Measure__c,ESN__c from CSS_Job_Order__c where id= :Wid];
            
            CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();            
            linkMgmtUrl = qccw.linkMgmt(key,workJob.ESN__c,lang,docType,DocId);
            System.debug('The url inside if is'+linkMgmtUrl);
            //linkMgmtUrl = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-mixar5.html|https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-vqxg5na.html';
            //linkMgmtUrl = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-vqxg5na.html';
            if(linkMgmtUrl.contains('|')){
                System.debug('The service model is'+workJob.Service_Model__c);
                string code = css_utility.getCodes('Effectivity',workJob.Service_Model__c,null,null);
                System.debug('The code is'+code);
                string link1 = linkMgmtUrl.substring(0,(linkMgmtUrl.indexOf('|')));
                //Defect Fix -  69121
                string link2 = linkMgmtUrl.substring((linkMgmtUrl.indexOf('|')+1),linkMgmtUrl.length());
                if(link1.contains(code)){
                    procUrl = link1;
                }
                else if(link2.contains(code)){
                    procUrl = link2;
                }
                else{
                    procUrl = linkMgmtUrl;
                }
            }
            else{
                procUrl = linkMgmtUrl;
            }
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage()+' '+e.getLineNumber());
            qsolIntegrationError(e.getMessage());
        }
        System.debug('The url is'+procUrl);
        return procUrl;
    }
    public static String linkMgmt(String lang,String docType,String DocId,string Wid){
        string linkMgmtUrl ;
        string procUrl;
        string url;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('GetLinkMgmtQsolREST');
                key = conDetails.Key__c; 
                
            }else{
                key = '1234';
            }
            system.debug('Wid--->'+Wid.substring(0,18));
            if(Wid != null && Wid != ''){
            Wid = Wid.substring(0,18);
            }
            workJob=[Select Id,Name,DSID__c,Customer_Name__c,Failure_Point__c,Make__c,Model__c,Equipment_ID__c,Application__c,Application_Desc__c,Unit_Number__c,Service_Model__c,
                     Failure_Point_Measure__c,ESN__c,Qsol_Business_Unit__c  from CSS_Job_Order__c where id= :Wid];
            
            
            CG_OP_LinkMgmtRespWrapper linkMgmtResp = new CG_OP_LinkMgmtRespWrapper();
            CG_OP_OAGWrapper Resp = new CG_OP_OAGWrapper();
            Resp = CG_SL_QSOL.callGetQsolService(workJob.ESN__c,'GetLinkMgmtQsolREST','','',lang,workJob.Qsol_Business_Unit__c,docType,DocId);
            string strResp='';
            if(Resp != null)
                strResp = Resp.response.getBody().replace('[',''); // removing square bracket from the response
                
            strResp = strResp.replace(']',''); // removing square bracket from the response
            System.debug('Resp in QuickServe>:'+Resp.response.getBody());
            System.debug('Resp in QuickServe After Replace>:'+strResp);
            linkMgmtResp = (CG_OP_LinkMgmtRespWrapper)JSON.deserializeStrict(strResp, CG_OP_LinkMgmtRespWrapper.class);
            system.debug('linkMgmtResp**'+linkMgmtResp);            
            linkMgmtUrl = linkMgmtResp.qsolLink;
            //linkMgmtUrl = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/procedures/155/155-019-019-tr-isb13.html'; // hardcoded url
            System.debug('The url inside if is'+linkMgmtUrl);
            //linkMgmtUrl = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-mixar5.html|https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-vqxg5na.html';
            //linkMgmtUrl = 'https://qsolpilot.cummins.com/qs3/pubsys2/xml/en/procedures/132/132-019-019-tr-vqxg5na.html';
            if(linkMgmtUrl.contains('|')){
                System.debug('The service model is'+workJob.Service_Model__c);
                string code = css_utility.getCodes('Effectivity',workJob.Service_Model__c,null,null);
                System.debug('The code is'+code);
                string link1 = linkMgmtUrl.substring(0,(linkMgmtUrl.indexOf('|')));
                //Defect Fix -  69121
                string link2 = linkMgmtUrl.substring((linkMgmtUrl.indexOf('|')+1),linkMgmtUrl.length());
                if(link1.contains(code)){
                    procUrl = link1;
                }
                else if(link2.contains(code)){
                    procUrl = link2;
                }
                else{
                    procUrl = linkMgmtUrl;
                }
            }
            else{
                procUrl = linkMgmtUrl;
            }
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage()+' '+e.getLineNumber());
            qsolIntegrationError(e.getMessage());
        }
        System.debug('The url is'+procUrl);
        return procUrl;
    }
    
    // qsol language - start
    public static list<CSS_CampTsbTrp__c> getQsolDocSaveLang_Existing(Id jobOrder,string esn, string lang){
        System.debug('The id is!@!#!'+jobOrder);
        System.debug('The esn is!#@!#@!'+esn);
        CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
        CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc mn = new CSS_quickserveCumminsComWebservices.ArrayOfWarrantyDoc();
        List<CSS_quickserveCumminsComWebservices.WarrantyDoc> warrDoc = new List<CSS_quickserveCumminsComWebservices.WarrantyDoc>(); 
        List<STRING> types = new List<STRING>{'CAM','TRP','TSB','ATC'};
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        string key;
        string getsEsn;
        //types = [select Type__c from CSS_CampTsbTrp__c];
        try{
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                getsEsn = esn;
                
            }else{
                key = '1234';
                getsEsn ='79464646';
            }
            //CSS_Job_Order__c cjo = new CSS_Job_Order__c();
            //cjo = [Select id,esn__c from CSS_Job_Order__c where id=:WId];
            qccw.timeout_x=100000;
            //mn = qccw.getWarrantyDocs(CSS_getConnnectionDetails.getConnection('QSOL').Key__c,cjo.esn__c,'TSB','en');
            for(integer j=0;j<types.size();j++){
                System.debug('The type is@#@#@$'+types[j]);
                //  mn = qccw.getWarrantyDocs(key,getsEsn,types[j],'en');
                mn = qccw.getWarrantyDocs(key,getsEsn,types[j],lang);
                if(mn!=null){
                    System.debug('The mn is#!@#!#!@'+mn);
                    warrDoc = mn.item;
                    if(warrDoc!=null){
                        System.debug('The item is#!@#!#!@'+warrDoc);
                        for(integer i=0;i<warrDoc.size();i++){
                            CSS_CampTsbTrp__c ctt1 = new CSS_CampTsbTrp__c();
                            ctt1.Name = types[j] ;
                            ctt1.Type__c = types[j] ;
                            ctt1.Job_Order__c = jobOrder;
                            ctt1.ESN__c = esn;
                            ctt1.Doc_Num__c = warrDoc[i].docNumber;
                            ctt1.Doc_Title__c = warrDoc[i].docTitle;
                            ctt1.URL__c = warrDoc[i].url;  
                            ctt1.Cu_Language__c = lang;
                            cctt.add(ctt1);
                        }
                    }
                }
            }
            system.debug('inside language QSOL'+cctt);
            //insert cctt; 
            
        }
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        return cctt;
    }
    // qsol language - end
    public static list<CSS_CampTsbTrp__c> getQsolDocSaveLang(Id jobOrder,string esn, string lang){
        try{
            for(List<CSS_CampTsbTrp__c> warrdocs :CG_SL_QSOL.getQSOLWarrantyDocs(jobOrder,null,esn,lang,new list<string>{'CAMPAIGN','TSB','ATC','TRP'})) cctt.addall(warrdocs);
        }catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }
        return cctt;
    }
    //Story 68615-Qsol Options--Start
    /*@future (callout=true)
    public static void getJobOptions_Existing(map<Id,String> mJobIds, boolean isClaim){
        try{
            list<CSS_Claims__c> ClaimsList = new list<CSS_Claims__c>();
            Map<Id, CSS_Claims__c> claimsMap = new Map<Id, CSS_Claims__c>();
            
            if(isClaim && mJobIds.size() > 0) {
                ClaimsList = [select Id, CSS_Job__c from CSS_Claims__c where Id IN : mJobIds.keyset()];
                for(CSS_Claims__c claims : ClaimsList)
                    claimsMap.put(claims.Id, claims);
            }
            //get RecordsTypeId for Options
            Id recTypeId = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
            
            //list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c From CSS_Job_Order__c WHERE Id in: lstJobIds];
            System.debug('MSNHAHAHAmJobIds is' +mJobIds);
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            List<CSS_Parts_Options__c> LstOptions = new List<CSS_Parts_Options__c>();
            string key;
            
            String strGrpname;
            String strOptNum;
            String strRepGrp;
            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('QSOL');
                key = conDetails.Key__c; 
                
                
            }else{
                key = '1234';
                String Esn ='79464646';
            }            
            for (Id jId:mJobIds.keySet()){
                
                CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11 qccw = new  CSS_quickserveCumminsComWebservices.QSOLServicePortSoap11();
                CSS_quickserveCumminsComWebservices.ArrayOfOptions Opts = new CSS_quickserveCumminsComWebservices.ArrayOfOptions();
                List<CSS_quickserveCumminsComWebservices.Options> optionsLst  = new List<CSS_quickserveCumminsComWebservices.Options>(); 
                
                List<String> optNumlst = new List<String>();
                List<String> repGrplst = new List<String>();
                List<String> grpNamelst = new List<String>();
                
                
                System.debug('MSN@@@'+mJobIds);
                System.debug('MSN1@@@'+mJobIds.get(jId));
                System.debug('MSN2@@@'+mJobIds.keySet());
                System.debug('MSN3@@@'+jId);
                
                               
                qccw.timeout_x=100000;
                Opts = qccw.getOptions(key,mJobIds.get(jId));
                if(Opts!=null){
                    System.debug('The Opts is#!@#!#!@'+Opts);
                    optionsLst = Opts.item;
                    if(optionsLst!=null){
                        System.debug('The optionsLstitem is#!@#!#!@'+optionsLst);
                        
                        for(integer i=0;i<optionsLst.size();i++){
                            optNumlst.add(optionsLst[i].optionNumber);
                            grpNamelst.add(optionsLst[i].groupName);
                            repGrplst.add(optionsLst[i].repairGroup);                                    
                        }
                        
                    }
                    
                    System.debug('The optNumlst is#!@#!#!@'+optNumlst);
                    System.debug('The grpNamelst is#!@#!#!@'+grpNamelst);
                    System.debug('The repGrplst is#!@#!#!@'+repGrplst);
                    
                    strOptNum = JSON.serialize(optNumlst);
                    strGrpname = JSON.serialize(grpNamelst);
                    strRepGrp = JSON.serialize(repGrplst);
                    
                    CSS_Parts_Options__c objOpt = new CSS_Parts_Options__c();
                    
                    if( strGrpname!=''){
                        objOpt.Group_Name__c = strGrpname;              
                    }
                    if( strOptNum!=''){
                        objOpt.Option_Number__c = strOptNum;                
                    }
                    if( strRepGrp!=''){
                        objOpt.Repair_Group__c = strRepGrp;             
                    }
                    if(strGrpname!='' || strOptNum!='' || strRepGrp!='' ){
                        objOpt.Option_ESN__c = mJobIds.get(jId);
                        if(!isClaim)
                            objOpt.Service_job__c = jId;
                        else {
                            //Claims
                            CSS_Claims__c claims = claimsMap.get(jId);
                            if(claims != null && claims.CSS_Job__c == null) //Manual Claim
                               objOpt.CSS_Claims__c = jId;
                        }
                        objOpt.recordTypeId = recTypeId;
                    }
                    
                    System.debug('strGrpname is '+strGrpname);
                    System.debug('strOptNum is '+strOptNum);
                    System.debug('strRepGrp is '+strRepGrp);
                    
                    LstOptions.add(objOpt);
                    System.debug('LstOptions is '+LstOptions);
                }
            }
            
            if(LstOptions.size()>0){
                insert LstOptions;
            }
        }
        
        catch (Exception e){
            System.debug('The exception is'+e.getMessage());
            qsolIntegrationError(e.getMessage());
        }           
        
    }*/
    //Story 68615-Qsol Options--End
    
     @future (callout=true)
    public static void getJobOptions(map<Id,String> mJobIds, boolean isClaim){
        try{
            list<CSS_Claims__c> ClaimsList = new list<CSS_Claims__c>();
            Map<Id, CSS_Claims__c> claimsMap = new Map<Id, CSS_Claims__c>();
            
            if(isClaim && mJobIds.size() > 0) {
                ClaimsList = [select Id, CSS_Job__c from CSS_Claims__c where Id IN : mJobIds.keyset()];
                for(CSS_Claims__c claims : ClaimsList)
                    claimsMap.put(claims.Id, claims);
            }
            //get RecordsTypeId for Options
            Id recTypeId = css_utility.getRecordTypeId(CSS_Parts_Options__c.sObjectType, 'Options');
            
            //list<CSS_Job_Order__c> lstJobOrder = [SELECT Id, Name, ESN__c From CSS_Job_Order__c WHERE Id in: lstJobIds];
            System.debug('MSNHAHAHAmJobIds is' +mJobIds);
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            List<CSS_Parts_Options__c> LstOptions = new List<CSS_Parts_Options__c>();
            string key;
            
            String strGrpname;
            String strOptNum;
            String strRepGrp;
            
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('GetOptionsforQsolREST');
                key = conDetails.Key__c; 
                
                
            }else{
                key = '1234';
                String Esn ='79464646';
            }            
            for (Id jId:mJobIds.keySet()){
                
                List<String> optNumlst = new List<String>();
                List<String> repGrplst = new List<String>();
                List<String> grpNamelst = new List<String>();
                
                
                System.debug('MSN@@@'+mJobIds);
                System.debug('MSN1@@@'+mJobIds.get(jId));
                System.debug('MSN2@@@'+mJobIds.keySet());
                System.debug('MSN3@@@'+jId);
                
                               
                    List<CG_OP_GetOptionsRespWrapper> optionsLst = new List<CG_OP_GetOptionsRespWrapper>();
                    CG_OP_OAGWrapper resWrapper;
                
                    resWrapper = CG_SL_QSOL.callGetQsolService(mJobIds.get(jId),'GetOptionsforQsolREST','','','','','','');
                    //system.debug('resWrapper**'+resWrapper.response.getBody());
                    if(!Test.isRunningTest()){
                        optionsLst = (List<CG_OP_GetOptionsRespWrapper>)JSON.deserializeStrict(resWrapper.response.getBody(), List<CG_OP_GetOptionsRespWrapper>.class);
                    }
                    else{
                        string res='['+'{'+'\"optionNumber\":\"PE1027-05\",'+'\"optionDescription\":\"AftertreatmentDevice\",'+'\"repairGroup\":\"11.01.1\"'+'},'+'{'+'\"optionNumber\":\"PE1715-03\",'+'\"optionDescription\":\"DOSER,FLUID\",'+'\"repairGroup\":\"11.01.1\"'+'},'+'{'+'\"optionNumber\":\"PE1715-01\",'+'\"optionDescription\":\"FluidDoser\",'+'\"repairGroup\":\"11.01\"'+'},'+'{'+'\"optionNumber\":\"CP1183-03\",'+'\"optionDescription\":\"AirCompressor\",'+'\"repairGroup\":\"12.01\"'+'},'+'{'+'\"optionNumber\":\"ER1014-07\",'+'\"optionDescription\":\"ExhaustRecirculation\",'+'\"repairGroup\":\"11.01.1\"'+'},'+'{'+'\"optionNumber\":\"IC1112-01\",'+'\"optionDescription\":\"CONNECTION,AIRINTAKE\",'+'\"repairGroup\":\"10.01.2\"'+'},'+'{'+'\"optionNumber\":\"IM1837\",'+'\"optionDescription\":\"AirIntakeManifold\",'+'\"repairGroup\":\"10.01\"'+'},'+'{'+'\"optionNumber\":\"IT1033-01\",'+'\"optionDescription\":\"AirTransferConnection\",'+'\"repairGroup\":\"10.01.2\"'+'},'+'{'+'\"optionNumber\":\"PP10321\",'+'\"optionDescription\":\"Turbocharger\",'+'\"repairGroup\":\"10.05\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"NOZZLE,PISTONCOOLING\",'+'\"repairGroup\":\"01.01.2\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"PISTON,CONNRODAND\",'+'\"repairGroup\":\"01.04\"'+'},'+'{'+'\"optionNumber\":\"PP10359\",'+'\"optionDescription\":\"CylinderHead\",'+'\"repairGroup\":\"02.01\"'+'},'+'{'+'\"optionNumber\":\"PP10360\",'+'\"optionDescription\":\"Injector\",'+'\"repairGroup\":\"06.01\"'+'},'+'{'+'\"optionNumber\":\"TB1469-02\",'+'\"optionDescription\":\"ARRANGEMENT,TURBOCHARGER\",'+'\"repairGroup\":\"10.06.1\"'+'},'+'{'+'\"optionNumber\":\"TP1813-02\",'+'\"optionDescription\":\"PLUMBING,TURBOCHARGER\",'+'\"repairGroup\":\"10.06.2\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"BLOCK,CYLINDER\",'+'\"repairGroup\":\"01.01\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"Crankshaft\",'+'\"repairGroup\":\"01.02\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"CusAccessoryBrace\",'+'\"repairGroup\":\"16.04.2\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"CylinderLinerKit\",'+'\"repairGroup\":\"01.01.1\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"GearHousingBrace\",'+'\"repairGroup\":\"01.09.2\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"GearHousingSensorAdapter\",'+'\"repairGroup\":\"01.09.1\"'+'},'+'{'+'\"optionNumber\":\"BB1909\",'+'\"optionDescription\":\"GearHousing/IdlerGears\",'+'\"repairGroup\":\"01.09\"'+'},'+'{'+'\"optionNumber\":\"EB1207\",'+'\"optionDescription\":\"EngineBrake\",'+'\"repairGroup\":\"03.04\"'+'},'+'{'+'\"optionNumber\":\"HC1004\",'+'\"optionDescription\":\"CabinHeaterPlumbing\",'+'\"repairGroup\":\"08.13.1\"'+'},'+'{'+'\"optionNumber\":\"PP10321\",'+'\"optionDescription\":\"Turbocharger\",'+'\"repairGroup\":\"10.05\"'+'},'+'{'+'\"optionNumber\":\"PP10342\",'+'\"optionDescription\":\"CAMSHAFT\",'+'\"repairGroup\":\"01.07\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"NOZZLE,PISTONCOOLING\",'+'\"repairGroup\":\"01.01.2\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"PISTON,CONNRODAND\",'+'\"repairGroup\":\"01.04\"'+'},'+'{'+'\"optionNumber\":\"PP10359\",'+'\"optionDescription\":\"CylinderHead\",'+'\"repairGroup\":\"02.01\"'+'},'+'{'+'\"optionNumber\":\"PP10360\",'+'\"optionDescription\":\"Injector\",'+'\"repairGroup\":\"06.01\"'+'},'+'{'+'\"optionNumber\":\"RL1754-03\",'+'\"optionDescription\":\"LEVER,ROCKER\",'+'\"repairGroup\":\"03.01\"'+'},'+'{'+'\"optionNumber\":\"VC1088\",'+'\"optionDescription\":\"ARRANGEMENT,VALVECOVER\",'+'\"repairGroup\":\"03.01.1\"'+'},'+'{'+'\"optionNumber\":\"CI1725-01\",'+'\"optionDescription\":\"AirCprInletArrangement\",'+'\"repairGroup\":\"12.01.1\"'+'},'+'{'+'\"optionNumber\":\"CP1183-03\",'+'\"optionDescription\":\"AirCompressor\",'+'\"repairGroup\":\"12.01\"'+'},'+'{'+'\"optionNumber\":\"WP1744-03\",'+'\"optionDescription\":\"PUMP,WATER\",'+'\"repairGroup\":\"08.01\"'+'},'+'{'+'\"optionNumber\":\"FH11059-12\",'+'\"optionDescription\":\"FlywheelHousing\",'+'\"repairGroup\":\"16.01\"'+'},'+'{'+'\"optionNumber\":\"WR1717-01\",'+'\"optionDescription\":\"WiringAccessories\",'+'\"repairGroup\":\"21.02\"'+'},'+'{'+'\"optionNumber\":\"CH1021-02\",'+'\"optionDescription\":\"AID,COOHEATERSTARTING\",'+'\"repairGroup\":\"10.02\"'+'},'+'{'+'\"optionNumber\":\"CP1183-03\",'+'\"optionDescription\":\"AirCompressor\",'+'\"repairGroup\":\"12.01\"'+'},'+'{'+'\"optionNumber\":\"EC1726-04\",'+'\"optionDescription\":\"THERMOSTAT\",'+'\"repairGroup\":\"08.07\"'+'},'+'{'+'\"optionNumber\":\"HC1004\",'+'\"optionDescription\":\"CabinHeaterPlumbing\",'+'\"repairGroup\":\"08.13.1\"'+'},'+'{'+'\"optionNumber\":\"IM1837\",'+'\"optionDescription\":\"AirIntakeManifold\",'+'\"repairGroup\":\"10.01\"'+'},'+'{'+'\"optionNumber\":\"TH1217\",'+'\"optionDescription\":\"ARRANGEMENT,THMHOUSING\",'+'\"repairGroup\":\"08.07\"'+'},'+'{'+'\"optionNumber\":\"TH1711\",'+'\"optionDescription\":\"HOUSING,THERMOSTAT\",'+'\"repairGroup\":\"08.07\"'+'},'+'{'+'\"optionNumber\":\"TP1813-02\",'+'\"optionDescription\":\"PLUMBING,TURBOCHARGER\",'+'\"repairGroup\":\"10.06.2\"'+'},'+'{'+'\"optionNumber\":\"WF1242-02\",'+'\"optionDescription\":\"RESISTOR,CORROSION\",'+'\"repairGroup\":\"08.08\"'+'},'+'{'+'\"optionNumber\":\"WI1118\",'+'\"optionDescription\":\"CONNECTION,WATERINLET\",'+'\"repairGroup\":\"08.07.1\"'+'},'+'{'+'\"optionNumber\":\"WO1126-02\",'+'\"optionDescription\":\"CONNECTION,WATEROUTLET\",'+'\"repairGroup\":\"08.07.1\"'+'},'+'{'+'\"optionNumber\":\"WP1744-03\",'+'\"optionDescription\":\"PUMP,WATER\",'+'\"repairGroup\":\"08.01\"'+'},'+'{'+'\"optionNumber\":\"CF1072\",'+'\"optionDescription\":\"RefCompressorMounting\",'+'\"repairGroup\":\"12.01\"'+'},'+'{'+'\"optionNumber\":\"DA1237-03\",'+'\"optionDescription\":\"VibrationDamper\",'+'\"repairGroup\":\"01.02.2\"'+'},'+'{'+'\"optionNumber\":\"EH1120-02\",'+'\"optionDescription\":\"AlternatorMounting\",'+'\"repairGroup\":\"13.02.3\"'+'},'+'{'+'\"optionNumber\":\"EM1355-01\",'+'\"optionDescription\":\"FrontEngineSupport\",'+'\"repairGroup\":\"16.03\"'+'},'+'{'+'\"optionNumber\":\"FA1511-01\",'+'\"optionDescription\":\"DRIVE,FAN\",'+'\"repairGroup\":\"08.03\"'+'},'+'{'+'\"optionNumber\":\"FH11059-12\",'+'\"optionDescription\":\"FlywheelHousing\",'+'\"repairGroup\":\"16.01\"'+'},'+'{'+'\"optionNumber\":\"FW1020-06\",'+'\"optionDescription\":\"Flywheel\",'+'\"repairGroup\":\"16.02\"'+'},'+'{'+'\"optionNumber\":\"FW1701\",'+'\"optionDescription\":\"MOUNTING,FLYWHEEL\",'+'\"repairGroup\":\"16.02.1\"'+'},'+'{'+'\"optionNumber\":\"GG1749-01\",'+'\"optionDescription\":\"COVER,FRONTGEAR\",'+'\"repairGroup\":\"01.06\"'+'},'+'{'+'\"optionNumber\":\"LA1718-02\",'+'\"optionDescription\":\"LiftingBracketMounting\",'+'\"repairGroup\":\"17.06\"'+'},'+'{'+'\"optionNumber\":\"PP10321\",'+'\"optionDescription\":\"Turbocharger\",'+'\"repairGroup\":\"10.05\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"NOZZLE,PISTONCOOLING\",'+'\"repairGroup\":\"01.01.2\"'+'},'+'{'+'\"optionNumber\":\"PP10357\",'+'\"optionDescription\":\"PISTON,CONNRODAND\",'+'\"repairGroup\":\"01.04\"'+'},'+'{'+'\"optionNumber\":\"PP10359\",'+'\"optionDescription\":\"CylinderHead\",'+'\"repairGroup\":\"02.01\"'+'},'+'{'+'\"optionNumber\":\"PP10360\",'+'\"optionDescription\":\"Injector\",'+'\"repairGroup\":\"06.01\"'+'},'+'{'+'\"optionNumber\":\"SM1732-02\",'+'\"optionDescription\":\"MOUNTING,STARTINGMOTOR\",'+'\"repairGroup\":\"13.05.1\"'+'},'+'{'+'\"optionNumber\":\"WR1717-01\",'+'\"optionDescription\":\"WiringAccessories\",'+'\"repairGroup\":\"21.02\"'+'},'+'{'+'\"optionNumber\":\"CH1021-02\",'+'\"optionDescription\":\"AID,COOHEATERSTARTING\",'+'\"repairGroup\":\"10.02\"'+'},'+'{'+'\"optionNumber\":\"PH1818-09\",'+'\"optionDescription\":\"EngineControlModule\",'+'\"repairGroup\":\"05.06.1\"'+'},'+'{'+'\"optionNumber\":\"PH1826-01\",'+'\"optionDescription\":\"EngCntModulePlumbing\",'+'\"repairGroup\":\"05.06.1\"'+'},'+'{'+'\"optionNumber\":\"SV1001\",'+'\"optionDescription\":\"EngineOperatingVoltage\",'+'\"repairGroup\":\"13.01\"'+'},'+'{'+'\"optionNumber\":\"WR1717-01\",'+'\"optionDescription\":\"WiringAccessories\",'+'\"repairGroup\":\"21.02\"'+'},'+'{'+'\"optionNumber\":\"DL1068\",'+'\"optionDescription\":\"LOCATION,DRAIN\",'+'\"repairGroup\":\"06.07\"'+'},'+'{'+'\"optionNumber\":\"FD1706\",'+'\"optionDescription\":\"FuelDrainPlumbing\",'+'\"repairGroup\":\"17.05\"'+'},'+'{'+'\"optionNumber\":\"FF1308\",'+'\"optionDescription\":\"FILTER,FUEL\",'+'\"repairGroup\":\"06.04\"'+'},'+'{'+'\"optionNumber\":\"FP10278\",'+'\"optionDescription\":\"PUMP,FUEL\",'+'\"repairGroup\":\"05.01\"'+'},'+'{'+'\"optionNumber\":\"FS1732\",'+'\"optionDescription\":\"FuelSystemPrimer\",'+'\"repairGroup\":\"05.19\"'+'},'+'{'+'\"optionNumber\":\"PP10323-03\",'+'\"optionDescription\":\"PLUMBING,INJECTOR\",'+'\"repairGroup\":\"06.01.2\"'+'},'+'{'+'\"optionNumber\":\"BR1296\",'+'\"optionDescription\":\"BREATHER,CRANKCASE\",'+'\"repairGroup\":\"03.02\"'+'},'+'{'+'\"optionNumber\":\"LC1751-01\",'+'\"optionDescription\":\"COOLER,ENGINEOIL\",'+'\"repairGroup\":\"07.05\"'+'},'+'{'+'\"optionNumber\":\"LF1232-03\",'+'\"optionDescription\":\"FILTER,FULLFLOWOIL\",'+'\"repairGroup\":\"07.03\"'+'},'+'{'+'\"optionNumber\":\"LG1148-04\",'+'\"optionDescription\":\"GAUGE,OILLEVEL\",'+'\"repairGroup\":\"07.02\"'+'},'+'{'+'\"optionNumber\":\"LP1729-03\",'+'\"optionDescription\":\"PUMP,LUBRICATINGOIL\",'+'\"repairGroup\":\"07.06\"'+'},'+'{'+'\"optionNumber\":\"OB1443-02\",'+'\"optionDescription\":\"ARRANGEMENT,OILFILL\",'+'\"repairGroup\":\"07.02\"'+'},'+'{'+'\"optionNumber\":\"TP1813-02\",'+'\"optionDescription\":\"PLUMBING,TURBOCHARGER\",'+'\"repairGroup\":\"10.06.2\"'+'},'+'{'+'\"optionNumber\":\"DO1813\",'+'\"optionDescription\":\"SOFTWARE,CUSINTERFACE\",'+'\"repairGroup\":\"99.01\"'+'},'+'{'+'\"optionNumber\":\"FCP846\",'+'\"optionDescription\":\"CALIBRATION,FUELPUMP\",'+'\"repairGroup\":\"99.01\"'+'},'+'{'+'\"optionNumber\":\"FR10993\",'+'\"optionDescription\":\"RATING,FUEL\",'+'\"repairGroup\":\"99.01\"'+'},'+'{'+'\"optionNumber\":\"NN1735\",'+'\"optionDescription\":\"Nameplate\",'+'\"repairGroup\":\"01.06.1\"'+'},'+'{'+'\"optionNumber\":\"SC12085\",'+'\"optionDescription\":\"SOFTWARE,CALIBRATION\",'+'\"repairGroup\":\"99.01\"'+'},'+'{'+'\"optionNumber\":\"EB1207\",'+'\"optionDescription\":\"EngineBrake\",'+'\"repairGroup\":\"03.04\"'+'},'+'{'+'\"optionNumber\":\"AP8122\",'+'\"optionDescription\":\"AgencyApproval\",'+'\"repairGroup\":\"01.06.1\"'+'},'+'{'+'\"optionNumber\":\"FA1511-01\",'+'\"optionDescription\":\"FanDrive\",'+'\"repairGroup\":\"08.03\"'+'},'+'{'+'\"optionNumber\":\"FW1701\",'+'\"optionDescription\":\"FLYWHEELMOUNTING\",'+'\"repairGroup\":\"16.02.1\"'+'},'+'{'+'\"optionNumber\":\"LA1112\",'+'\"optionDescription\":\"ARRANGEMENT,LIFTING\",'+'\"repairGroup\":\"17.06\"'+'},'+'{'+'\"optionNumber\":\"OP1230\",'+'\"optionDescription\":\"OilPan\",'+'\"repairGroup\":\"07.01\"'+'},'+'{'+'\"optionNumber\":\"SS1097-01\",'+'\"optionDescription\":\"PAINT\",'+'\"repairGroup\":\"03.01\"'+'}'+
                ']';
                        optionsLst = (List<CG_OP_GetOptionsRespWrapper>)JSON.deserializeStrict(res, List<CG_OP_GetOptionsRespWrapper>.class);
                    }
                    //optionsLst = 
                    System.debug('The optionsLstitem is#!@#!#!@'+optionsLst);
                    if(optionsLst!=null){
                        
                        List<string> optionNumberWithoutVersion;//GSSC-360 changes to remove version from options.
                        for(integer i=0;i<optionsLst.size();i++){
                            if(optionsLst[i].optionNumber != null && optionsLst[i].optionNumber != ''){//GSSC-360 changes to remove version from options.
                            optionNumberWithoutVersion = optionsLst[i].optionNumber.split('-');//GSSC-360 changes to remove version from options.
                            optNumlst.add(optionNumberWithoutVersion[0]);//GSSC-360 changes to remove version from options.
                            }
                            grpNamelst.add(optionsLst[i].optionDescription); // we were referring GroupName, which is not present in current response
                            repGrplst.add(optionsLst[i].repairGroup);                                    
                        }
                        
                    }
                    
                    System.debug('The optNumlst is#!@#!#!@'+optNumlst);
                    System.debug('The grpNamelst is#!@#!#!@'+grpNamelst);
                    System.debug('The repGrplst is#!@#!#!@'+repGrplst);
                    
                    strOptNum = JSON.serialize(optNumlst); 
                    strGrpname = JSON.serialize(grpNamelst);
                    strRepGrp = JSON.serialize(repGrplst);
                    
                    CSS_Parts_Options__c objOpt = new CSS_Parts_Options__c();
                    
                    if( strGrpname!=''){
                        objOpt.Group_Name__c = strGrpname;              
                    }
                    if( strOptNum!=''){
                        objOpt.Option_Number__c = strOptNum;                
                    }
                    if( strRepGrp!=''){
                        objOpt.Repair_Group__c = strRepGrp;             
                    }
                    if(strGrpname!='' || strOptNum!='' || strRepGrp!='' ){
                        objOpt.Option_ESN__c = mJobIds.get(jId);
                        if(!isClaim)
                            objOpt.Service_job__c = jId;
                        else {
                            //Claims
                            CSS_Claims__c claims = claimsMap.get(jId);
                            if(claims != null && claims.CSS_Job__c == null) //Manual Claim
                               objOpt.CSS_Claims__c = jId;
                        }
                        objOpt.recordTypeId = recTypeId;
                    }
                    
                    System.debug('strGrpname is '+strGrpname);
                    System.debug('strOptNum is '+strOptNum);
                    System.debug('strRepGrp is '+strRepGrp);
                    
                    LstOptions.add(objOpt);
                    System.debug('LstOptions is '+LstOptions);
               // }
            }
            
            if(LstOptions.size()>0){
                insert LstOptions;
            }
        }
        
        catch (Exception e){
            System.debug('The exception is'+e.getMessage() + ' LineNumber>>:' + e.getLineNumber() + ' Rootcause>>:' +e.getCause());
            qsolIntegrationError(e.getMessage());
        }           
        
    }
    
    
    @testvisible
    private static Date parseQSOLDate(String myDate) {
        String[] myDateOnly = myDate.split('-');
        String sMonth = (myDateOnly.size()>0 && myDateOnly != null)?myDateOnly[1]:'';
        String sMM='0';
        if (sMonth == 'Jan') { sMM = '1' ;}
        else if (sMonth == 'Feb') { sMM = '2' ;}
        else if (sMonth == 'Mar') { sMM = '3' ;}
        else if (sMonth == 'Apr') { sMM = '4' ;}
        else if (sMonth == 'May') { sMM = '5' ;}
        else if (sMonth == 'Jun') { sMM = '6' ;}
        else if (sMonth == 'Jul') { sMM = '7' ;}
        else if (sMonth == 'Aug') { sMM = '8' ;}
        else if (sMonth == 'Sep') { sMM = '9' ;}
        else if (sMonth == 'Oct') { sMM = '10' ;}
        else if (sMonth == 'Nov') { sMM = '11' ;}
        else { sMM = '12' ;}

        Integer myIntDate = integer.valueOf(myDateOnly[2]);
        Integer myIntMonth = integer.valueOf(sMonth);
        Integer myIntYear = integer.valueOf(myDateOnly[0]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        system.debug('date'+d);
        return d;
        

    }
    
}