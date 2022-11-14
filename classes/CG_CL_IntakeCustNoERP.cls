/**********************************************************************
Name:CG_CL_IntakeCustNoERP
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this component Controller when the user has no ERP.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      12/19/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_CL_IntakeCustNoERP {
    
    //Global Veriables
    public CG_CL_IntakeCustomer mainContr{set; get;}
    public CG_CL_IntakeVH mainContrVH{set; get;}
    public CG_CL_IntakeRJ mainContrRJ{set; get;}
    public CG_CL_IntakeWarranty mainContrWR{set; get;}
    public string AppointmentName{get;set;}
    public string datebyLocaleValue {get;set;}
    public string cacheSL { get; set; }
    public string selectedLocation {get;set;}
    public String PageName {get;set;}
    public Boolean isDealer {get;set;}
    
    List<SelectOption> options;
    public list<CSS_UserLocation__c> lstUserLocations;
    
    public CG_BL_Intake CG_BL_IntakeObj = new CG_BL_Intake();
    //Global Veriables


    //Constructor.
    public CG_CL_IntakeCustNoERP() {
        System.debug('IN CG_CL_IntakeCustNoERP constructor...' + Cache.Session.get('UserERPSystem'));
        system.debug('Cache.Session.get(selectedLocation) ' +  Cache.Session.get('selectedLocation'));
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        } 
        try {
            if(Cache.Session.get('UserERPSystem') == 'No ERP System'){
                lstUserLocations = new list<CSS_UserLocation__c>();
                //query to get the user locations 
                lstUserLocations = CG_BL_Intake.fetchMultiLocation();
                System.debug('lstUserLocations >>> ' + lstUserLocations);
                cacheSL = (String) Cache.Session.get('selectedLocation');
                if(cacheSL == null || cacheSL == '')
                    selectedLocation = CG_BL_Intake.selectedLocation(lstUserLocations);
                else
                    selectedLocation = cacheSL;
                datebyLocaleValue = css_utility.getFormattedDate();
                AppointmentName = 'No';
            }
        }catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustNoERP constructor >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustNoERP constructor...');
    }
	//Constructor.


    //method to fecth all the locations based on the logged in user 
    public List<SelectOption> getLocationsName() {
        options = new List<SelectOption>(); 
        try {
            options = CG_BL_IntakeObj.fetchLocationName(lstUserLocations);
            //options = mainContr.options;
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustNoERP - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustNoERP - getLocationsName Method ...');
        return options;
    }
    
    //Method for getting Repair locations
    public List<SelectOption> getRepairLocation(){
        List<SelectOption> repairLocList = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = CSS_Claims__c.Repair_Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            repairLocList.add(new SelectOption(pickListVal.getLabel(),pickListVal.getLabel()));
        }
        //CG_CL_ClaimsFC.upsertAdminSRT();
        return repairLocList;
    }
	
    //Changing Location Values.
    public pagereference changeLocation() {
        PageReference pageRef;
        try {
            mainContr.selectedLocationName = getLocationLabel(selectedLocation);
            //Cache.Session.put('UserERPSystem', 'BMS Legacy');
            Cache.Session.put('selectedLocation', selectedLocation);
            System.debug('selectedLocation>>>:'+selectedLocation);
            css_utility.setSessionVariables(selectedLocation);
            //CG_BL_Intake.fetchUserLocation(null, selectedLocation); 
            if(mainContr.Wid== null) 
                pageRef= new pageReference('/apex/CG_IntakeCustomer'); 
            else
                pageRef= new pageReference('/apex/CG_IntakeCustomer?id=' + mainContr.Wid); 
            pageRef.setRedirect(true);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - changeLocation Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return pageRef;
    }
	
    //Get Location Values.
    public string getLocationLabel(string selectedLocation) {
        string selectedLocationName;
        try {
            if(options !=null && options.size()>0){
                //for loop to set the location name selected on the user screen based on the location code .
                for(SelectOption s : options){
                    if(s.getValue() == selectedLocation){
                        selectedLocationName = s.getLabel();
                    }
                    system.debug('selectedLocationName--->'+selectedLocationName);
                }
            }
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationLabel Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        return selectedLocationName;
    }
}