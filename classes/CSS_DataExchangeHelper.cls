public class CSS_DataExchangeHelper {
    public static Id rTypeId_Outbox = [SELECT Id FROM RecordType WHERE Name = 'DE-Outbox'].Id; 
    public void insertDataExchange(CSS_Fault_Code__c[] triggernew){
        system.debug('Inside fault method');
        List<CSS_DataExchange_Parent__c> lstDEParentExisting = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Parent__c> lstDEParent = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Parent__c> lstDEParentupdate = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Child__c> lstDEChild = new List<CSS_DataExchange_Child__c>();
        Map<Id,CSS_Job_Order__c> serviceJobMap = new  Map<Id,CSS_Job_Order__c>();
        Map<Id,Id> serviceJobFaultMap = new  Map<Id,Id>();
        Map<Id,Id> deParentChildMap = new  Map<Id,Id>();
        Set<Id> serviceJobId = new Set<Id>();
        List<CSS_Job_Order__c> serviceJoblist = new List<CSS_Job_Order__c>();
        Boolean Flag =false;
        
        Set<String> cssjobName= new Set<String>();
        for(integer i=0;i<triggernew.size();i++){
            system.debug('shanthi forloop'+triggernew[i].id);
            system.debug('shanthi forloop Job_Order__c'+triggernew[i].Job_Order__c);
            
            serviceJobId.add(triggernew[i].Job_Order__c);
            system.debug('vignesh serviceJobId'+serviceJobId);
            serviceJobFaultMap.put(triggernew[i].Id,triggernew[i].Job_Order__c);
            system.debug('shanthi serviceJobFaultMap'+serviceJobFaultMap);
        }
        
        if(serviceJobId.size()>0){
            system.debug('vignesh inside serviceJobId>0');
            serviceJoblist=[select id,name, ESN__c, Service_Model_N__c,Failure_Point__c, Service_Model__c,CustomerID__c,Make__c, Model__c, Mileage__c,Creator_Location__c,Mileage_Measure__c, Warranty_Start_Date__c, CSS_Hours__c, Failure_Date__c, Before_In_Service__c, Application__c, VIN__c, Customer_Name__c, Unit_Number__c, Customer_Code__c, Contact_Name__c, CSS_State__c, Country__c, Address__c, City__c, Shop_Work_Order__c,Data_Exchange_Enabled__c from CSS_Job_Order__c where Data_Exchange_Enabled__c=true and id in :serviceJobId];
            system.debug('vignesh serviceJoblist'+serviceJoblist);
            for(CSS_Job_Order__c c : serviceJoblist){
                cssjobName.add(c.name);
                serviceJobMap.put(c.Id,c);
                system.debug('shanthi serviceJobMap'+serviceJobMap);
            }
        }
        
        if(cssjobName.size()>0){
            
            lstDEParentExisting =[Select id,CSS_Job_Number__c from CSS_DataExchange_Parent__c where DataExchange_Status__c='UnProcessed' and CSS_Job_Number__c in :cssjobName and CSS_Job_Number__c!=null];
            system.debug('shanthi lstDEParentExisting'+lstDEParentExisting);
        }
        system.debug('vignesh empty check-->'+serviceJobMap);
        system.debug('vignesh empty checck1-->'+serviceJobMap.size());
        if(serviceJobMap.size()>0){
            for(integer i=0;i<triggernew.size();i++){
                system.debug('shanthi lstDEParentExisting'+serviceJobFaultMap.get(triggernew[i].Id));
                system.debug('shanthi lstDEParentExisting1'+(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Data_Exchange_Enabled__c);
                if((serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Data_Exchange_Enabled__c== true){
                    for(CSS_DataExchange_Parent__c deParent1 : lstDEParentExisting){
                        system.debug('shanthi lstDEParentExisting'+lstDEParentExisting);
                        if(deParent1.CSS_Job_Number__c==(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).name){
                            
                            deParent1.Id=deParent1.Id;
                            deParent1.Customer_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Customer_Name__c;
                            deParent1.CustomerID__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CustomerID__c;
                            deParent1.Contact_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Contact_Name__c;
                            deParent1.Address__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Address__c;
                            deParent1.City__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).City__c;
                            deParent1.State__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_State__c;
                            deParent1.Country__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Country__c;
                            deParent1.ESN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).ESN__c;
                            deParent1.Unit_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Unit_Number__c;
                            deParent1.SERVICEMODELNAME__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Service_Model__c;
                            deParent1.Application__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Application__c;
                            deParent1.MAKE__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MAKE__c;
                            deParent1.MODEL__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MODEL__c;
                            deParent1.VIN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).VIN__c;
                            deParent1.Warranty_Start_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Warranty_Start_Date__c;
                            deParent1.Failure_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Date__c;
                            deParent1.Mileage_Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage__c;
                            deParent1.Mileage_Measure__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage_Measure__c;
                            deParent1.Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_Hours__c;
                            deParent1.Failure_Point__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Point__c;
                            lstDEParentupdate.add(deParent1);
                            CSS_DataExchange_Child__c dechildrecord = new   CSS_DataExchange_Child__c();
                            dechildrecord.CSS_DataExchange_Parent__c=deParent1.Id;
                            dechildrecord.Count__c=triggernew[i].Count__c;
                            dechildrecord.Fault_Code__c=triggernew[i].Fault_Code__c;
                            dechildrecord.Fault_Code_Type__c=triggernew[i].Fault_Code_Type__c;
                            dechildrecord.Primary_Fault_Code__c=triggernew[i].Primary_Fault_Code__c;
                            dechildrecord.Related_Fault_Code__c=triggernew[i].Related_Fault_Code__c;
                            dechildrecord.DataExchangeChildType__c='FaultCode';
                            dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                            lstDEChild.add(dechildrecord);
                            flag=true;
                            break;
                        }
                    }
                    if(flag==false){
                        CSS_DataExchange_Parent__c deParent = new CSS_DataExchange_Parent__c();
                        deParent.CSS_Job_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).name;
                        deParent.RecordTypeId = rTypeId_Outbox;
                        deParent.DataExchange_Status__c = 'UnProcessed';
                        deParent.Customer_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Customer_Name__c;
                        deParent.CustomerID__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CustomerID__c;
                        deParent.Contact_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Contact_Name__c;
                        deParent.Address__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Address__c;
                        deParent.City__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).City__c;
                        deParent.State__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_State__c;
                        deParent.Country__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Country__c;
                        deParent.ESN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).ESN__c;
                        deParent.Unit_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Unit_Number__c;
                        deParent.SERVICEMODELNAME__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Service_Model__c;
                        deParent.Application__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Application__c;
                        deParent.MAKE__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MAKE__c;
                        deParent.MODEL__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MODEL__c;
                        deParent.VIN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).VIN__c;
                        deParent.Warranty_Start_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Warranty_Start_Date__c;
                        deParent.Failure_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Date__c;
                        deParent.Mileage_Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage__c;
                        deParent.Mileage_Measure__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage_Measure__c;
                        deParent.Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_Hours__c;
                        deParent.Failure_Point__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Point__c;
                        lstDEParent.add(deParent);
                        flag = true;
                        system.debug('shanthi lstDEParent'+lstDEParent);
                    }
                    
                }        
            }
        } 
        if(lstDEParent.size() > 0){
            insert lstDEParent;             
        }
        if(lstDEParentupdate.size()>0)
        {
            update lstDEParentupdate;
        }
        if(lstDEParent.size()>0){
            for(integer i=0;i<triggernew.size();i++){
                CSS_DataExchange_Child__c dechildrecord = new   CSS_DataExchange_Child__c();
                dechildrecord.CSS_DataExchange_Parent__c=lstDEParent[0].Id;
                dechildrecord.Count__c=triggernew[i].Count__c;
                dechildrecord.Fault_Code__c=triggernew[i].Fault_Code__c;
                dechildrecord.Fault_Code_Type__c=triggernew[i].Fault_Code_Type__c;
                dechildrecord.Primary_Fault_Code__c=triggernew[i].Primary_Fault_Code__c;
                dechildrecord.Related_Fault_Code__c=triggernew[i].Related_Fault_Code__c;
                dechildrecord.DataExchangeChildType__c='FaultCode';
                dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                lstDEChild.add(dechildrecord);
                
            }
        }
        if(lstDEChild.size()>0){
            insert lstDEChild;
        }
        
        
    }
    
    
    public void insertDataExchangeSolution(CSS_Solutions__c[] triggernew,Map<Id,CSS_Solutions__c> oldMap){
        system.debug('Inside fault method');
        List<CSS_DataExchange_Parent__c> lstDEParentExisting = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Parent__c> lstDEParent = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Parent__c> lstDEParentupdate = new List<CSS_DataExchange_Parent__c>();
        List<CSS_DataExchange_Child__c> lstDEChild = new List<CSS_DataExchange_Child__c>();
        List<CSS_DataExchange_Child__c> lstDEChildExisting = new List<CSS_DataExchange_Child__c>();
        Map<Id,CSS_Job_Order__c> serviceJobMap = new  Map<Id,CSS_Job_Order__c>();
        List<CSS_Solution_Component__c> lstsolutionComp = new List<CSS_Solution_Component__c>();
        Map<Id,List<String>> solCompMap = new  Map<Id,List<String>>();
        Map<Id,Id> serviceJobFaultMap = new  Map<Id,Id>();
        Map<Id,Id> deParentChildMap = new  Map<Id,Id>();
        Set<Id> serviceJobId = new Set<Id>();
        List<CSS_Job_Order__c> serviceJoblist = new List<CSS_Job_Order__c>();
        List<string> solRepairJSON = new List<string>();
        Boolean Flag =false;
        Boolean childFlag =false;
        Set<String> cssjobName= new Set<String>();
        List<Id> lstSolutionId = new List<Id>();
        List<Id> lstSolutionsId = new List<Id>();
        List<Id> existingParentId = new List<Id>();
        if(oldMap!=null){
            for(integer i=0;i<triggernew.size();i++){
                if(triggernew[i].Diagnostic_notes__c!=oldMap.get(triggernew[i].id).Diagnostic_notes__c || triggernew[i].Diagnostic_Response__c!=oldMap.get(triggernew[i].id).Diagnostic_Response__c || triggernew[i].Repair_Notes__c!=oldMap.get(triggernew[i].id).Repair_Notes__c || triggernew[i].Repair_Response__c!=oldMap.get(triggernew[i].id).Repair_Response__c){   
                    serviceJobId.add(triggernew[i].Service_Job__c);
                    system.debug('vignesh serviceJobId'+serviceJobId);
                    serviceJobFaultMap.put(triggernew[i].Id,triggernew[i].Service_Job__c);
                    lstSolutionsId.add(triggernew[i].Id);
                    if(triggernew[i].Repair_Notes__c!=oldMap.get(triggernew[i].id).Repair_Notes__c || triggernew[i].Repair_Response__c!=oldMap.get(triggernew[i].id).Repair_Response__c){
                        
                        lstSolutionId.add(triggernew[i].Id);
                    }
                }
            }
            
            if(serviceJobId.size()>0){
                system.debug('vignesh inside serviceJobId>0');
                serviceJoblist=[select id,name, ESN__c, Service_Model_N__c, Failure_Point__c,Service_Model__c,CustomerID__c,Make__c, Model__c, Mileage__c,Creator_Location__c,Mileage_Measure__c, Warranty_Start_Date__c, CSS_Hours__c, Failure_Date__c, Before_In_Service__c, Application__c, VIN__c, Customer_Name__c, Unit_Number__c, Customer_Code__c, Contact_Name__c, CSS_State__c, Country__c, Address__c, City__c, Shop_Work_Order__c,Data_Exchange_Enabled__c from CSS_Job_Order__c where Data_Exchange_Enabled__c=true and id in :serviceJobId];
                system.debug('vignesh serviceJoblist'+serviceJoblist);
                for(CSS_Job_Order__c c : serviceJoblist){
                    cssjobName.add(c.name);
                    serviceJobMap.put(c.Id,c);
                    system.debug('shanthi serviceJobMap'+serviceJobMap);
                }
            }
            
            if(cssjobName.size()>0){
                
                lstDEParentExisting =[Select id,CSS_Job_Number__c from CSS_DataExchange_Parent__c where DataExchange_Status__c='UnProcessed' and CSS_Job_Number__c in :cssjobName and CSS_Job_Number__c!=null];
                system.debug('shanthi lstDEParentExisting'+lstDEParentExisting);
                
                for(CSS_DataExchange_Parent__c p:lstDEParentExisting){
                    existingParentId.add(p.Id);
                    
                }
            }
            
            if(lstSolutionsId.size()>0 && lstDEParentExisting.size()>0){
                lstDEChildExisting =[select id,CSS_DataExchange_Parent__c,DataExchangeChild_Status__c,Selected_Component__c,Repair_Comments__c,Comments__c,Sol_Descriptions__c,Solutions_Descriptions__c,DataExchangeChildType__c,Solution_ID__c from CSS_DataExchange_Child__c where 
                                     Solution_ID__c in:lstSolutionsId and DataExchangeChild_Status__c='UnProcessed' and CSS_DataExchange_Parent__c in:existingParentId ];
                system.debug('shanthi lstDEChildExisting'+lstDEChildExisting);
            }
            if(lstSolutionId.size()>0){
                
                lstsolutionComp =[Select Action__c,Component_Id__c,Name,Solutions__c from CSS_Solution_Component__c where Solutions__c in : lstSolutionId];
                if(lstsolutionComp.size()>0){
                    for(integer i=0;i<lstsolutionComp.size();i++){
                        if(solCompMap.get(lstsolutionComp[i].Solutions__c) ==null)
                            solCompMap.put(lstsolutionComp[i].Solutions__c, new List<String>());
                        
                        //solCompMap.get(lstsolutionComp[i].Solutions__c).add(lstsolutionComp[i]);
                        solCompMap.get(lstsolutionComp[i].Solutions__c).add(JSON.Serialize(new solWrapperClass(lstsolutionComp[i].Component_Id__c,lstsolutionComp[i].Name,lstsolutionComp[i].Action__c)));
                        System.Debug('Shanthi solcomp'+solCompMap);
                        
                    }
                }
            }
            system.debug('vignesh empty check-->'+serviceJobMap);
            system.debug('vignesh empty checck1-->'+serviceJobMap.size());
            if(serviceJobMap.size()>0){
                for(integer i=0;i<triggernew.size();i++){
                    
                    system.debug('shanthi lstDEParentExisting'+serviceJobFaultMap.get(triggernew[i].Id));
                    system.debug('shanthi lstDEParentExisting1'+(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Data_Exchange_Enabled__c);
                    if(triggernew[i].Diagnostic_notes__c!=oldMap.get(triggernew[i].id).Diagnostic_notes__c || triggernew[i].Diagnostic_Response__c!=oldMap.get(triggernew[i].id).Diagnostic_Response__c ||  triggernew[i].Repair_Notes__c!=oldMap.get(triggernew[i].id).Repair_Notes__c || triggernew[i].Repair_Response__c!=oldMap.get(triggernew[i].id).Repair_Response__c){               
                        
                        
                        if((serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Data_Exchange_Enabled__c== true){
                            for(CSS_DataExchange_Parent__c deParent1 : lstDEParentExisting){
                                system.debug('shanthi lstDEParentExisting'+lstDEParentExisting);
                                if(deParent1.CSS_Job_Number__c==(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).name){
                                    
                                    deParent1.Id=deParent1.Id;
                                    deParent1.Customer_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Customer_Name__c;
                                    deParent1.CustomerID__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CustomerID__c;
                                    deParent1.Contact_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Contact_Name__c;
                                    deParent1.Address__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Address__c;
                                    deParent1.City__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).City__c;
                                    deParent1.State__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_State__c;
                                    deParent1.Country__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Country__c;
                                    deParent1.ESN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).ESN__c;
                                    deParent1.Unit_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Unit_Number__c;
                                    deParent1.SERVICEMODELNAME__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Service_Model__c;
                                    deParent1.Application__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Application__c;
                                    deParent1.MAKE__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MAKE__c;
                                    deParent1.MODEL__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MODEL__c;
                                    deParent1.VIN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).VIN__c;
                                    deParent1.Warranty_Start_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Warranty_Start_Date__c;
                                    deParent1.Failure_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Date__c;
                                    deParent1.Mileage_Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage__c;
                                    deParent1.Mileage_Measure__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage_Measure__c;
                                    deParent1.Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_Hours__c;
                                    deParent1.Failure_Point__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Point__c;
                                    lstDEParentupdate.add(deParent1);
                                    
                                    if(triggernew[i].Diagnostic_notes__c!=oldMap.get(triggernew[i].id).Diagnostic_notes__c || triggernew[i].Diagnostic_Response__c!=oldMap.get(triggernew[i].id).Diagnostic_Response__c){
                                        if(lstDEChildExisting.size()>0){
                                            for(CSS_DataExchange_Child__c c: lstDEChildExisting){
                                                if(c.Solution_ID__c==triggernew[i].Id && c.CSS_DataExchange_Parent__c==deParent1.Id && c.DataExchangeChildType__c=='SolutionData'){
                                                    c.Id=c.id;
                                                    c.Comments__c=triggernew[i].Diagnostic_notes__c;
                                                    c.Sol_Descriptions__c=triggernew[i].Diagnostic_Response__c;
                                                    lstDEChild.add(c);
                                                    childFlag=true;
                                                    break;
                                                }
                                            }
                                        }
                                        if( childFlag==false){
                                            CSS_DataExchange_Child__c dechildrecord = new   CSS_DataExchange_Child__c();
                                            dechildrecord.CSS_DataExchange_Parent__c=deParent1.Id;
                                            dechildrecord.Comments__c=triggernew[i].Diagnostic_notes__c;
                                            dechildrecord.Sol_Descriptions__c=triggernew[i].Diagnostic_Response__c;
                                            dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                                            dechildrecord.DataExchangeChildType__c='SolutionData';
                                            dechildrecord.Solution_ID__c=triggernew[i].Id;
                                            lstDEChild.add(dechildrecord);
                                        }
                                    }
                                    if( triggernew[i].Repair_Notes__c!=oldMap.get(triggernew[i].id).Repair_Notes__c || triggernew[i].Repair_Response__c!=oldMap.get(triggernew[i].id).Repair_Response__c){
                                        
                                        if(lstDEChildExisting.size()>0){
                                            for(CSS_DataExchange_Child__c c: lstDEChildExisting){
                                                if(c.Solution_ID__c==triggernew[i].Id && c.CSS_DataExchange_Parent__c==deParent1.Id && c.DataExchangeChildType__c=='RepairData'){
                                                    c.Id=c.id;
                                                    c.Repair_Comments__c=triggernew[i].Repair_Notes__c;
                                                    c.Solutions_Descriptions__c=triggernew[i].Repair_Response__c;
                                                    if(solCompMap.Size()>0){
                                                        string allstring1 = string.join(solCompMap.get(triggernew[i].Id),',');
                                                        c.Selected_Component__c=allstring1;
                                                    }   
                                                    lstDEChild.add(c);
                                                    childFlag=true;
                                                    break;
                                                }
                                            }
                                        }
                                        if(childFlag==false){
                                            CSS_DataExchange_Child__c dechildrecord = new   CSS_DataExchange_Child__c();
                                            dechildrecord.CSS_DataExchange_Parent__c=deParent1.Id;
                                            dechildrecord.Repair_Comments__c=triggernew[i].Repair_Notes__c;
                                            dechildrecord.Solutions_Descriptions__c=triggernew[i].Repair_Response__c;
                                            dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                                            dechildrecord.DataExchangeChildType__c='RepairData'; 
                                            dechildrecord.Solution_ID__c=triggernew[i].Id;
                                            if(solCompMap.Size()>0){
                                                string allstring = string.join(solCompMap.get(triggernew[i].Id),',');
                                                dechildrecord.Selected_Component__c=allstring;
                                            }                          
                                            
                                            lstDEChild.add(dechildrecord);
                                        }
                                    }
                                    flag=true;
                                    break;
                                }
                            }
                            if(flag==false){
                                CSS_DataExchange_Parent__c deParent = new CSS_DataExchange_Parent__c();
                                deParent.CSS_Job_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).name;
                                deParent.RecordTypeId = rTypeId_Outbox;
                                deParent.DataExchange_Status__c = 'UnProcessed';
                                deParent.Customer_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Customer_Name__c;
                                deParent.CustomerID__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CustomerID__c;
                                deParent.Contact_Name__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Contact_Name__c;
                                deParent.Address__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Address__c;
                                deParent.City__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).City__c;
                                deParent.State__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_State__c;
                                deParent.Country__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Country__c;
                                deParent.ESN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).ESN__c;
                                deParent.Unit_Number__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Unit_Number__c;
                                deParent.SERVICEMODELNAME__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Service_Model__c;
                                deParent.Application__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Application__c;
                                deParent.MAKE__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MAKE__c;
                                deParent.MODEL__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).MODEL__c;
                                deParent.VIN__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).VIN__c;
                                deParent.Warranty_Start_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Warranty_Start_Date__c;
                                deParent.Failure_Date__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Date__c;
                                deParent.Mileage_Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage__c;
                                deParent.Mileage_Measure__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Mileage_Measure__c;
                                deParent.Hours__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).CSS_Hours__c;
                                deParent.Failure_Point__c=(serviceJobMap.get(serviceJobFaultMap.get(triggernew[i].Id))).Failure_Point__c;
                                lstDEParent.add(deParent);
                                
                                system.debug('shanthi lstDEParent'+lstDEParent);
                            }
                        }  
                    }        
                }
            } 
            if(lstDEParent.size() > 0){
                insert lstDEParent;             
            }
            if(lstDEParentupdate.size()>0)
            {
                update lstDEParentupdate;
            }
            if(lstDEParent.size()>0){
                for(integer i=0;i<triggernew.size();i++){
                    if(triggernew[i].Diagnostic_notes__c!=oldMap.get(triggernew[i].id).Diagnostic_notes__c || triggernew[i].Diagnostic_Response__c!=oldMap.get(triggernew[i].id).Diagnostic_Response__c){
                        CSS_DataExchange_Child__c dechildrecord = new CSS_DataExchange_Child__c();
                        dechildrecord.CSS_DataExchange_Parent__c=lstDEParent[i].Id;
                        dechildrecord.Comments__c=triggernew[i].Diagnostic_notes__c;
                        dechildrecord.Sol_Descriptions__c=triggernew[i].Diagnostic_Response__c;
                        dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                        dechildrecord.DataExchangeChildType__c='SolutionData';
                        dechildrecord.Solution_ID__c=triggernew[i].Id;
                        lstDEChild.add(dechildrecord);
                    }
                    if(triggernew[i].Repair_Notes__c!=oldMap.get(triggernew[i].id).Repair_Notes__c || triggernew[i].Repair_Response__c!=oldMap.get(triggernew[i].id).Repair_Response__c){
                        CSS_DataExchange_Child__c dechildrecord = new CSS_DataExchange_Child__c();
                        dechildrecord.CSS_DataExchange_Parent__c=lstDEParent[i].Id;
                        dechildrecord.Repair_Comments__c=triggernew[i].Repair_Notes__c;
                        dechildrecord.Solutions_Descriptions__c=triggernew[i].Repair_Response__c;
                        dechildrecord.DataExchangeChild_Status__c='UnProcessed';
                        dechildrecord.DataExchangeChildType__c='RepairData';
                        dechildrecord.Solution_ID__c=triggernew[i].Id;
                        if(solCompMap.Size()>0){
                            
                            string allstring = string.join(solCompMap.get(triggernew[i].Id),',');
                            dechildrecord.Selected_Component__c=allstring;
                            
                        }
                        lstDEChild.add(dechildrecord);
                    }
                }
            }
            if(lstDEChild.size()>0){
                upsert lstDEChild;
            }
        }
    }
    
    
    public void insertDEParent(CSS_Job_Order__c[] triggernew,Map<Id,CSS_Job_Order__c> oldMap){
        system.debug('Inside method');
        List<CSS_DataExchange_Parent__c> lstDEParent = new List<CSS_DataExchange_Parent__c>();
        
        for(integer i=0;i<triggernew.size();i++){
            CSS_DataExchange_Parent__c deParent = new CSS_DataExchange_Parent__c();
            
            if(oldMap!=null){
                
                deParent.CSS_Job_Number__c = triggernew[i].name;
                deParent.Customer_Company_Name__c = triggernew[i].Customer_Name__c;
                deParent.Contact_Name__c = triggernew[i].Contact_Name__c;
                deParent.City__c = triggernew[i].City__c;
                deParent.State__c = triggernew[i].CSS_State__c;
                deParent.Country__c = triggernew[i].Country__c;
                deParent.Address__c = triggernew[i].Address__c;
                deParent.ESN__c=triggernew[i].ESN__c;
                deParent.Unit_Number__c=triggernew[i].Unit_Number__c;
                deParent.SERVICEMODELNAME__c=triggernew[i].Service_Model__c;
                deParent.Application__c=triggernew[i].Application__c;
                deParent.MAKE__c=triggernew[i].MAKE__c;
                deParent.MODEL__c=triggernew[i].MODEL__c;
                deParent.VIN__c=triggernew[i].VIN__c;
                deParent.Warranty_Start_Date__c=triggernew[i].Warranty_Start_Date__c;
                deParent.Failure_Date__c=triggernew[i].Failure_Date__c;
                deParent.Mileage_Hours__c=triggernew[i].Mileage__c;
                deParent.Mileage_Measure__c=triggernew[i].Mileage_Measure__c;
                deParent.Hours__c=triggernew[i].CSS_Hours__c;
                deParent.Failure_Point__c=triggernew[i].Failure_Point__c;
                deParent.RecordTypeId = rTypeId_Outbox;
                deParent.DataExchange_Status__c = 'UnProcessed';
                lstDEParent.add(deParent);
                
            }
        }
        
        if(lstDEParent.size() > 0){
            insert lstDEParent;
        }
    }
    
    public class solWrapperClass{
        public string ComponentID{get;set;}
        public string ComponentName{get;set;}
        public string Action{get;set;}
        public solWrapperClass(string ComponentID,string ComponentName,string Action){
            this.ComponentID = ComponentID;
            this.ComponentName = ComponentName;
            this.Action = Action;
        }
    }
}