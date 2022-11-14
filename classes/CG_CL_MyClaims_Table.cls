/**********************************************************************
Name:CG_CL_MyClaims_Table
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------   
This class is showing claims based on tabs.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      DEV Team         03/20/2017      Implementation of Automated Campaigns
2.0      Krishnamorthi    11/05/2019      GSSC:223 - [PROD] - Claims > My Claims Search is not limiting results to the selected location
***********************************************************************/
public class CG_CL_MyClaims_Table
{
    public list<CSS_UserLocation__c> lstUserLocations;
    public string selectedLocation {get;set;}
    public ID claimidarp{get;set;}
    public string selectedRejComm{get;set;}
    //public String PageName {get;set;}
    //public string sfid{get;set;}
    public CSS_Claims__c claimsrec{get;set;}
    //public static List<CSS_Claims__c> listClaim {get; set;}
    public static List<CSS_PSN__c> listClaim {get; set;}
    public static List<CSS_Claim_Submission__c> listClaimsub {get; set;}
    // public static List<CSS_Claim_Submission__c> lstClaimSubPRCount {get; set;} // Anvesh Today
    List<SelectOption> options;
    public CG_BL_Claims CG_BL_ClaimsObj = new CG_BL_Claims();
    public static List<CSS_psn__c>  listpsn{get; set;}
    static List < CSS_psn__c > lstjobtest = new List<CSS_psn__c>();
    public String defaultLoc {get; set;}
    public Boolean isDealer {get;set;}
    public CSS_Claims__c cs{get;set;}
    public string NotesBody {get;set;}   
    public static Date DR;
    public static Boolean datesearcherrmsg1{get;set;}
    public static Boolean AutomaticCopyClaim{get;set;}
    public static Boolean datesearcherrmsg2{get;set;}
    public string datebyLocaleValue {get;set;}  //Added for Story 160031
    //public Boolean dealeruser {get;set;}
    //public Boolean copyclaimhide {get;set;}
    public string orgtype{get;set;}//167793 Rupesh


    public CG_CL_MyClaims_Table()
    {
        /* dealeruser=false;
list<CSS_UserLocation__c> usrec=[SELECT Id, OwnerId, UserId__c, AccountId__c, Location_code__c, Location_Name__c, AccountId__r.Type from CSS_UserLocation__c where UserId__c=:userinfo.getUserId()];
for(CSS_UserLocation__c u1:usrec)
{
if(u1.AccountId__r.Type=='Dealer Account'){ 
dealeruser =true;     
} 

else { 
dealeruser=false;
} 

}*/

        //Get the Orgtype information
        orgtype=css_utility.getOrgType(userinfo.getUserId()); 

        /*pgname=ApexPages.currentPage().getUrl();
IF(pgname=='CG_MyClaims')
pgname='MyClaims';*/
        //selectedLocation = '-All-';
        lstUserLocations = new list<CSS_UserLocation__c>();
        //query to get the user locations 
        lstUserLocations = CG_BL_Claims.fetchMultiLocation();

        system.debug('lstUserLocations' + ' ' + lstUserLocations);
        /*for(CSS_UserLocation__c u1:lstUserLocations){
if(u1.AccountId__r.Type=='Dealer Account'){ 
dealeruser =true;     
} 
else { 
dealeruser=false;
}
}*/

        getLocationsName();
        system.debug('After constructor call--'+options);
        datebyLocaleValue = css_utility.getFormattedDate();   //Added for Story 160031
        AutomaticCopyClaim = false;
        isDealer = true;
        string userType = css_Utility.getOrgType(userinfo.getUserId());
        if(userType!=null && userType!= '') {
            if(userType == 'DLR') {
                isDealer = true;
            }else if(userType == 'DISTR') {
                isDealer = false;
            }
        }

    }

    //method to fecth all the locations based on the logged in user 
    public List<SelectOption> getLocationsName() 
    {
        options = new List<SelectOption>();
        try {
            options = CG_BL_ClaimsObj.fetchLocationName(lstUserLocations);
            //  options = CG_BL_ClaimsObj.fetchMultiLocation();
            defaultLoc = CG_BL_ClaimsObj.defaultUserLoc;
            system.debug('options--'+options);
        } catch(Exception e)  {
            system.debug('EXCEPTION of CG_CL_IntakeCustLegacyBMS - getLocationsName Method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
        System.debug('OUT CG_CL_IntakeCustLegacyBMS - getLocationsName Method ...');
        return options;
    }      

    //Deletion of draft claims..Remote Action to be called through Javascript..167793 Rupesh
    @RemoteAction
    public static void deleteselecteddraftclaims(string selclaimid)
    {
        system.debug('Claim is going to be deleted..'+selclaimid);
        //Information_Only_Claim__c
        //Multi_PSN_Claim__c
        //Catastrophic__c
        //CSS_Claims__c clm=new CSS_Claims__c();
        //clm.id=selclaimid;
        /*Boolean infoclaim=clm.Information_Only_Claim__c;
Boolean mpsnclaim=clm.Multi_PSN_Claim__c;
Boolean cataclaim=clm.Catastrophic__c;
string clmstatus=clm.Status__c;
system.debug('****Information only****'+infoclaim);
system.debug('****MPSN Claim****'+mpsnclaim);
system.debug('****Cata claim****'+cataclaim);
system.debug('****Claim Status****'+clmstatus);*/
        //Dealer / Distributor / Factory user can delete normal claim, info only claim, multi-psn claim until claim is submitted to Siebel. 
        //string orgtype=css_utility.getOrgType(userinfo.getUserId()); 
        //if ((orgtype=='DISTR')  || (orgtype=='DLR ') ||infoclaim||mpsnclaim||cataclaim|| (clmstatus!='Submitted'))
        claimDelete(selclaimid);

    }

    //Claim Final Delete Call
    public static void claimdelete(string claimid)
    {

        list<CSS_Claims__c> claimsandrelreclist=[select id, CSS_Job__c,
                                                 (select id from CSS_Parts_Options__r),
                                                 (select id from CSS_SRTs__r),
                                                 (select id from CSS_Solution_Components__r),
                                                 (select id from css_psns__r),(select id from notes) 
                                                 from css_claims__c where id=:claimid];
        Boolean isAutomatedClaim=false;
        list<CSS_Parts_Options__c> claimsparts=new list<CSS_Parts_Options__c>();
        list<CSS_SRT__c> claimssrts=new list<CSS_SRT__c>();
        list<CSS_Solution_Component__c> claimsfanc=new list<CSS_Solution_Component__c>();
        list<css_psn__c> claimsmpsns=new list<css_psn__c>();
        list<note> ClaimNotesList=new list<note>();
        List<CSS_Job_Order__c> sJobToBeUpdated =new List<CSS_Job_Order__c>();
        for(css_claims__c clms:claimsandrelreclist)
        {
            if(clms.CSS_Job__c != null || clms.CSS_Job__c != ''){
                isAutomatedClaim = true;
            }
            claimsparts=(clms.CSS_Parts_Options__r);
            claimssrts=(clms.CSS_SRTs__r);
            claimsfanc=(clms.CSS_Solution_Components__r);
            claimsmpsns=(clms.css_psns__r);
            ClaimNotesList=(clms.notes);
        }
        if(isAutomatedClaim){
            for(CSS_Job_Order__c sJob : [select id, Sub_Status__c from CSS_Job_Order__c where Claim_ID__c =: claimid]){
                sJob.Sub_Status__c = 'Ready for Claim Creation';
                sJobToBeUpdated.add(sJob);
            } 
            //Update the SJob..
            if(sJobToBeUpdated!=null || sJobToBeUpdated.size()!=0)
                try
                {
                    update sJobToBeUpdated;
                }
            catch (EXCEPTION e){
                system.debug(e.getMessage() +' and in the line '+e.getLineNumber());
            }
        } 


        //Deletes the Claim..
        if(claimsandrelreclist!=null||claimsandrelreclist.size()!=0)
            try
            {
                delete claimsandrelreclist;
            }
        catch (EXCEPTION e){}
        //Deletes Parts related to claim
        if(claimsparts!=null||claimsparts.size()!=0)
        {
            try
            {
                delete claimsparts;
            }
            catch (EXCEPTION e){}
        }

        //Deletes SRT related to claim
        if(claimssrts!=null||claimssrts.size()!=0)
        {
            try
            {
                delete claimssrts;
            }
            catch (EXCEPTION e){}

        }
        //Deletes F&C related to claim
        if(claimsfanc!=null||claimsfanc.size()!=0)
        {
            try
            {
                delete claimsfanc;
            }
            catch (EXCEPTION e){}
        }
        //Deletes Multi PSN related to claim
        if(claimsmpsns!=null||claimsmpsns.size()!=0)
        {
            try
            {
                delete claimsmpsns;
            }
            catch (EXCEPTION e){}
        }
        //Deletes Notes related to claim
        if(ClaimNotesList!=null||ClaimNotesList.size()!=0)
        {
            try
            {
                delete ClaimNotesList;
            }
            catch (EXCEPTION e){}
        }

    }


    public static string whClause;//Where Clause part
    public static integer recCount=0;//Record  counter


    @RemoteAction
    public static Boolean CopyIconShowHide() {
        Boolean isPSNTriggered = PSNTriggered();
        system.debug('isPSNTriggered---> '+isPSNTriggered);
        return isPSNTriggered;
    }

    public static List<ClaimsWrap> listWrap = new List<ClaimsWrap>();

    @RemoteAction
    public static string ClaimsSearch(string userLoc, string claimStatus,string claimStatus1, string searchField, string searchValue, string searchValueDropDown,string DMR,Boolean Profile, String searchDatepickerone,String searchDatepickertwo,String tabClickClaimStatus)
    {    
        system.debug('Selected Location ---->' + userLoc);
        system.debug('Selected claimStatus ---->' + claimStatus);
        system.debug('Selected searchField ---->' + searchField);
        system.debug('Selected searchValue ---->' + searchValue);
        system.debug('Profile ---->' + Profile);
        system.debug('searchDatepickerone'+searchDatepickerone);
        system.debug('searchDatepickertwo'+searchDatepickertwo);
        system.debug('tabClickClaimStatus>>>' + tabClickClaimStatus);


        if(claimStatus=='Draft' && tabClickClaimStatus ==null){
            tabClickClaimStatus = claimStatus;
            system.debug('Today cond tabClickClaimStatus ---->' + tabClickClaimStatus);
        }

        if(tabClickClaimStatus!=null && tabClickClaimStatus!=''){
            claimStatus= tabClickClaimStatus;
            system.debug('Not equal2null tabClickClaimStatus ---->' + tabClickClaimStatus);
        }


        //Boolean isPSNTriggered = PSNTriggered();
        //system.debug('isPSNTriggered---> '+isPSNTriggered);
        system.debug('DMR'+DMR);
        listClaim = new List<CSS_PSN__c>();
        date datesearchone;
        date datesearchtwo;
        list<string> str = new list<string>();
        if(searchDatepickerone!=null && searchDatepickerone!=''){
            str = searchDatepickerone.split('/');
            if(str.size()==3){
                searchDatepickerone = str[2]+'-'+str[0]+'-'+str[1];
            }
            datesearchone = date.valueof(searchDatepickerone);
            system.debug('datesearchone'+datesearchone);
        }

        if(searchDatepickertwo!=null && searchDatepickertwo!=''){
            str = new list<string>();
            str = searchDatepickertwo.split('/');
            if(str.size()==3){
                searchDatepickertwo = str[2]+'-'+str[0]+'-'+str[1];
            }
            datesearchtwo = date.valueof(searchDatepickertwo);
            system.debug('datesearchtwo'+datesearchtwo);
        }
        List<CSS_PSN__c>  listClaim1;

        // lstClaimSubPRCount =new List<CSS_Claim_Submission__c>() ; // Anvesh Today

        if(DMR!=null && DMR!='0'){
            DR = system.today()- integer.valueOf(DMR.trim())*30;
            system.debug(' DR' + ' ' +DR); 
        } 
        system.debug(datesearchone+'-'+datesearchtwo);
        system.debug('DMR null DR' + ' ' +DR); 
        listClaimsub = new List<CSS_Claim_Submission__c>();
        String queryStr;
        String searchValueConsolidatedClaim;

        if(searchField == 'selectOne' || searchField == '' || searchField == null){
            system.debug('userLoc ' + userLoc);
            /* Anvesh Commented As part of COCO sprint story 

           if(userLoc == '-All-'){
                List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
                List<CSS_UserLocation__c> allLocation = new List<CSS_UserLocation__c>();
                List<String> allLocationName = new List<String>();
                List<String> claimSubmissionId = new List<String>();
                allLocation = CG_BL_Claims.fetchMultiLocation();
                for(CSS_UserLocation__c Loc : allLocation) {
                    allLocationName.add(loc.Location_Name__c);
                }
                for(CSS_Claim_Submission__c subIDLst : submID) {
                    claimSubmissionId.add(subIDLst.CSS_Claims__c);
                }
                system.debug('allLocationName--'+allLocationName);
                system.debug('claimSubmissionId--'+claimSubmissionId);
                system.debug('claimStatus--'+claimStatus);
                //claimStatus = 'Draft';        //temp for testing purpose.
                if(claimStatus == 'Draft') {    //RESTRUCTURE THE SUBMITTED TAB

                    system.debug('All loc Inside claim status Draft'+allLocationName);
                    listClaim = [SELECT Id, CSS_Claims__r.Rejection_Comments__c,VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,
                                 CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.Multi_PSN_Claim__c
                                 FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c =:claimStatus AND CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true 
                                 AND CSS_Claims__r.CreatedDate > :DR  AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) <=: datesearchtwo ORDER BY LastModifiedDate  desc limit 500];

                    system.debug('All loc listClaim'+listClaim);
                } 
                //RESTRUCTURE THE SUBMITTED TAB
                else if(claimStatus == 'submitted') {
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,Credit_Date__c,  
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];


                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 Primary__c = true AND CSS_Claims__c IN: lstClaimIds AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];

                    //CSS_Claims__r.Location__c IN: allLocationName AND 
                    system.debug('listClaim Submitted' + listClaim);  
                }
                //RESTRUCTURE THE SUBMITTED TAB     
                else if(claimStatus =='In Review' || claimStatus == 'Denied' || claimStatus == 'Paid' || claimStatus == 'Appealed/Resubmitted'){
                    system.debug('All loc Inside claim status other than Draft');


                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];


                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 Primary__c = true AND CSS_Claims__c IN: lstClaimIds AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];

                    //CSS_Claims__r.Location__c IN: allLocationName AND 
                    system.debug('listClaim Submitted' + listClaim);
                     system.debug('***listclaim[0].CSS_Claims__r.Multi_PSN_Claim__c****' + listclaim[0].CSS_Claims__r.Multi_PSN_Claim__c);


                }
                else if(claimStatus == 'Pending Authorization'){

                    system.debug('Pending Authorization');
                    listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c 
                                 FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c ='Draft' AND
                                 CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.Pending_Authorization__c='Authorization Required' 
                                 AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaim'+listClaim);


                }
                else if(claimStatus=='Information Only' && claimStatus1=='Not Authorized')
                {
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, 
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c IN:allLocationName  AND (Status__c =:claimStatus) ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c,LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 (Primary__c = true AND CSS_Claims__c IN: lstClaimIds) OR (CSS_Claims__r.Status__c = 'Not Authorized' and CSS_Claims__r.Location__c IN:allLocationName) 
                                 ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaim'+listClaim);
                }
                else if(claimStatus=='Parts to Return'){

                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.Information_Only_Claim__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c IN:allLocationName  AND (Status__c ='Submitted' OR Status__c = 'In Review') AND PartReturnToCenter__c = 'Y' 
                                    AND CSS_Claims__r.Information_Only_Claim__c = false ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaimsub parts to return' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              
                    system.debug('lstClaimIds -->'+lstClaimIds);
                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.PartReturnToCenter__c, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c,
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 (Primary__c = true AND CSS_Claims__c IN: lstClaimIds) OR (CSS_Claims__r.Status__c = 'Draft' AND CSS_Claims__r.PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false)  
                                 ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaim'+listClaim);
                }
                else {

                    system.debug('VIEW ALL');
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c IN:allLocationName ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaimsub VIEW ALL' + listClaimsub);                                                                                                                                          List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND (CSS_Claims__c IN: (lstClaimIds) OR CSS_Claims__r.Status__c ='Draft')
                                 AND CSS_Claims__r.CreatedDate > :DR  AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaim VIEW ALL' + listClaim); 

                }


            }
            else{
                List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
                List<String> claimSubmissionId = new List<String>();
                for(CSS_Claim_Submission__c subIDLst : submID) {
                    claimSubmissionId.add(subIDLst.CSS_Claims__c);
                }
                String Locname = userLoc.substring(0,userLoc.length()-8); 
                system.debug('Locname' + ' ' + Locname);
                system.debug('claimStatus->'+claimStatus);
                if(claimStatus == 'Draft') {

                    system.debug('userloc Inside claim status Draft');
                    listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,PSN__c, CSS_Claims__r.CSS_Job__r.Name, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c =:claimStatus AND
                                 CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500]; // 
                    system.debug('userloc Inside claim status Draft' + '     ' +listClaim);


                }
                else if(claimStatus == 'submitted') {
                    //RESTRUCTURE THE SUBMITTED TAB
                    //system.debug('userloc Inside claim status submitted');
                    //listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                    //Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                    //CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                    //CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,PSN__c, CSS_Claims__r.CSS_Job__r.Name, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE CSS_Claims__r.isSiebelProcessed__c =:false AND CSS_Claims__r.Status__c =:claimStatus AND
                    //CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500]; // 
                    //system.debug('userloc Inside claim status submitted' + '     ' +listClaim);

                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c =:Locname  AND (Status__c =:claimStatus) ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id, CSS_Claims__r.Rejection_Comments__c,VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 ( Primary__c = true AND CSS_Claims__c IN: lstClaimIds) OR (CSS_Claims__r.Status__c = 'Not Authorized' and CSS_Claims__r.Location__c =:Locname) ORDER BY LastModifiedDate desc limit 500];
                    //  ( Primary__c = true AND CSS_Claims__c IN: lstClaimIds) AND (CSS_Claims__r.Pending_Authorization__c ='Not Authorized' and CSS_Claims__r.Location__c =:Locname) ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaim'+listClaim);


                    //RESTRUCTURE THE SUBMITTED TAB

                }
                else if(claimStatus =='Pending Authorization'){

                    system.debug('userloc Inside claim status Pending Authorization');
                    listClaim = [SELECT Id, VIN__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE CSS_Claims__r.Status__c =: 'Draft' AND
                                 CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.Pending_Authorization__c='Authorization Required' AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo
                                 ORDER BY LastModifiedDate desc limit 500];


                }
                else  if(claimStatus=='Information Only' && claimStatus1=='Not Authorized')
                {


                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c =:Locname  AND (Status__c =:claimStatus) ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id, CSS_Claims__r.Rejection_Comments__c,VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 ( Primary__c = true AND CSS_Claims__c IN: lstClaimIds) OR (CSS_Claims__r.Status__c = 'Not Authorized' and CSS_Claims__r.Location__c =:Locname) ORDER BY LastModifiedDate desc limit 500];
                    //  ( Primary__c = true AND CSS_Claims__c IN: lstClaimIds) AND (CSS_Claims__r.Pending_Authorization__c ='Not Authorized' and CSS_Claims__r.Location__c =:Locname) ORDER BY LastModifiedDate desc limit 500];



                    system.debug('listClaim'+listClaim);
                }



                else if(claimStatus =='In Review' || claimStatus == 'Denied' || claimStatus == 'Paid' || claimStatus == 'Appealed/Resubmitted'){
                    system.debug('userloc Inside claim status other than Draft' + Locname + '------' + claimStatus);
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c =:Locname  AND  status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    system.debug('lstClaimIds' + lstClaimIds);   
                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c 
                                 WHERE  Primary__c = true AND CSS_Claims__c IN: lstClaimIds AND CSS_Claims__r.CreatedDate > :DR  AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];
                    //CSS_Claims__r.Location__c =:Locname AND
                    system.debug('listClaim Submitted' + listClaim); 

                } 

                else if(claimStatus=='Parts to Return'){
                    system.debug('Parts to Return');
                    system.debug('Location--'+Locname);
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  Status__c,Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c = :Locname AND (Status__c ='Submitted' OR Status__c = 'In Review') AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false
                                    ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaimsub Parts to Return' + listClaimsub);                                                                                                                                          
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c,
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND (CSS_Claims__c IN: (lstClaimIds) OR (CSS_Claims__r.Status__c =: 'Draft' AND CSS_Claims__r.PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false)) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaim Parts to Return' + listClaim); 

                }
                else {
                    system.debug('VIEW ALL');
                    listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                    CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  Status__c,Credit_Date__c,
                                    CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                    CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                    FROM CSS_Claim_Submission__c 
                                    WHERE CSS_Claims__r.Location__c = :Locname ORDER BY LastModifiedDate desc limit 500];
                    system.debug('listClaimsub VIEW ALL' + listClaimsub);         
                    List<ID> lstClaimIds = new List<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                        }
                    }                                                                                              

                    listClaim = [SELECT Id,CSS_Claims__r.Rejection_Comments__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, 
                                 Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__c, 
                                 CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                 CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c WHERE 
                                 CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND (CSS_Claims__c IN: (lstClaimIds) OR CSS_Claims__r.Status__c =: 'Draft') AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo ORDER BY LastModifiedDate desc limit 500];

                    system.debug('listClaim VIEW ALL' + listClaim); 
                }
                system.debug('listClaim-->'+listClaim);
            }
            */
        }
        else{
            system.debug('searchField'+searchField);
            system.debug('searchValue'+searchValue);
            system.debug('searchValueDropDown'+searchValueDropDown);
            system.debug('userLoc+164--'+userLoc);
            if(searchValue!=null && searchValue.contains('-')){
                string[] splittedConsolidatedClaim = searchValue.split('\\-');
                searchValueConsolidatedClaim=splittedConsolidatedClaim[0];
                system.debug('searchValueConsolidatedClaim'+searchValueConsolidatedClaim);
            }
            //String queryStr;
            if(userLoc == '-All-'){

                List<CSS_UserLocation__c> allLocation = new List<CSS_UserLocation__c>();
                List<String> allLocationName = new List<String>();
                allLocation = CG_BL_Claims.fetchMultiLocation();
                for(CSS_UserLocation__c Loc : allLocation) {
                    //allLocationName.add(loc.Location_Name__c);  GSSC-223
                    allLocationName.add(loc.Location_code__c);  //GSSC-223
                }
                system.debug('allLocationName--'+allLocationName);
                system.debug('claimStatus--'+claimStatus);
                if(claimStatus == 'Draft' && tabClickClaimStatus =='Draft')
                {
                    if(searchField != 'paymentRefNumber'){
                        //Added code for GSSC-262
                        queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c,CSS_Claims__r.Rejection_Comments__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                        //GSSC-223 - queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location__c =:allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) <=: datesearchtwo';
                        queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location_Code__c =:allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) <=: datesearchtwo';
                        system.debug('inside loc all search !null --'+claimStatus);
                        system.debug('-queryStr-'+queryStr);
                        if(searchField == 'ConsolidatedClaimID'){
                            if(searchValue!=null && searchValue.contains('-'))
                                queryStr = queryStr + ' AND CSS_Claims__r.Name  LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                            else
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'Status'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                        else if(searchField == 'CustomerName'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                        }
                        else if(searchField == 'ShopWorkOrder'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'ProductSerialNumber'){
                            queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'VINAssetSerialNumber'){
                            queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'GuidanzJobnumber'){
                            queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                            //queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name = \'' + searchValue+'\')';
                            system.debug('entered into giidanz'+queryStr);
                        }
                        else if(searchField == 'All'){
                            searchValue= String.escapeSingleQuotes(searchValue) ;
                            queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        }
                    }
                }

                else  if(claimStatus == 'submitted' &&  tabClickClaimStatus == 'submitted') {
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];   GSSC:223

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];   //GSSC:223
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\''; 
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }
                    //RESTRUCTURE THE SUBMITTED TAB
                }

                /////////////////////////////////////
                else  if(claimStatus == 'Pending Authorization' &&  tabClickClaimStatus == 'Pending Authorization') {

                    system.debug('inside search fun for pending authorization');
                    if(searchField != 'paymentRefNumber'){
                        //Added code for GSSC-262
                        queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c,CSS_Claims__r.Pending_Authorization__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c,CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                        //GSSC:223  queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND  CSS_Claims__r.Pending_Authorization__c=\'Authorization Required\' AND CSS_Claims__r.Location__c =:allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                        queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND  CSS_Claims__r.Pending_Authorization__c=\'Authorization Required\' AND CSS_Claims__r.Location_Code__c =:allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';


                        if(searchField == 'ConsolidatedClaimID'){
                            if(searchValue!=null && searchValue.contains('-'))
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                            else
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'Status'){
                            if(searchValueDropDown=='Pending Authorization')
                            {
                                queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'Draft\'';
                                //queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                            }
                            else{
                                queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                            }

                        }
                        else if(searchField == 'CustomerName'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\''; 
                        }
                        else if(searchField == 'ShopWorkOrder'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'ProductSerialNumber'){
                            queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'VINAssetSerialNumber'){
                            queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'GuidanzJobnumber'){
                            queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                            //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                        }
                        else if(searchField == 'All'){
                            searchValue= String.escapeSingleQuotes(searchValue) ;
                            queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        }
                    }
                }

                ////////////////////////////////////

                else  if(claimStatus=='Information Only' && tabClickClaimStatus == 'Information Only'){

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName GSSC:223
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName 
                                        AND (CSS_Claims__r.Information_Only_Claim__c =: TRUE)
                                        ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName AND IMS_Claim_Number__c=: searchValue GSSC:223
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName AND IMS_Claim_Number__c=: searchValue 
                                        AND (CSS_Claims__r.Information_Only_Claim__c =: TRUE)
                                        ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Information Only' + listClaimsub);                                                                                                                                         

                    List<ID> lstClaimIds = new List<Id>();
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    // List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            system.debug('searchValue searchValue searchValue' + searchValue);  
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    string draftstr = 'Draft';
                    string pendstr='Not Authorized';

                    //ADDED OR (CSS_Claims__r.Status__c =\'Not Authorized\') DUE TO PACCAR REJECTION******
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.Pending_Authorization__c, CSS_Claims__r.Information_Only_Claim__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, CSS_Claims__r.Rejection_Comments__c, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND (( Primary__c = true' +query; GSSC:223
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND (( Primary__c = true' +query; 
                    queryStr  = queryStr  + ') OR (CSS_Claims__r.Pending_Authorization__c =\'Not Authorized\') OR (CSS_Claims__r.Status__c =\'Not Authorized\')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                    //queryStr  = queryStr  + ')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';

                    system.debug('allLocationName' + queryStr);  
                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        if(searchValueDropDown == 'Information Only')
                        {
                            queryStr= queryStr;
                        }
                        else
                        {
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }



                }


                else if(claimStatus == 'Parts to Return' &&  tabClickClaimStatus == 'Parts to Return') {

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Parts To Return' + listClaimsub);                                                                                                                                         

                    List<ID> lstClaimIds = new List<Id>();
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    // List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            //  system.debug('searchValue searchValue searchValue' + searchValue);  
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        //query = ' AND CSS_Claims__c IN (' + query + ')'; //Commented and added below line as per story 190053
                        query = ' AND (CSS_Claims__c IN (' + query + ') OR (CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                    } else {    //Adding Else condition for GSSC-220 By Krishna.
                        query = '';
                        //Commented below query as part of defect GSSC 480 since it was throwing System.QueryException
                        //query = ' AND (CSS_Claims__c IN (' + query + ') OR (CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                        query = ' AND ((CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                    }

                    system.debug('loc All query' + query);
                    string draftstr = 'Draft';
                    string pendstr='Not Authorized';
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN:allLocationName AND CSS_Claims__r.PartReturnToCenter__c = \'Y\' AND CSS_Claims__r.Information_Only_Claim__c = false AND(( Primary__c = true' +query; 
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN:allLocationName AND (( Primary__c = true' +query; 
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN:allLocationName AND (( Primary__c = true' +query; 
                    //queryStr  = queryStr  + ') OR (CSS_Claims__r.Status__c = \'Not Authorized\')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                    queryStr  = queryStr  + ')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';

                    system.debug('allLocationName' + queryStr);  
                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        if(searchValueDropDown == 'Information Only')
                        {
                            queryStr= queryStr;
                        }
                        else
                        {
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }


                else if(claimStatus =='Appealed/Resubmitted' && tabClickClaimStatus =='Appealed/Resubmitted'){
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }


                else if(claimStatus =='Denied' && tabClickClaimStatus =='Denied'){
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }


                else if(claimStatus =='In Review' && tabClickClaimStatus =='In Review'){
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c  
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c, CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }


                // Below code as part of story GSSC-151 

                else if(claimStatus =='Pending Response' && tabClickClaimStatus =='Pending Response'){
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c,
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223 - > this one is new code ==> WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c ='In Review' AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c ='In Review' AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,
                                        LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223 - > this one is new code ==> WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c ='In Review' AND IMS_Claim_Number__c=: searchValue AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c ='In Review' AND IMS_Claim_Number__c=: searchValue AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);   

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223 - > this one is new code ==> queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                // End GSSC-151

                else if(claimStatus=='paid' && tabClickClaimStatus == 'paid'){
                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    system.debug('Claim locations'+allLocationName);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 
                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }
                else {
                    system.debug('VIEW ALL');

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name, CSS_Claims__r.Dealer_Service_Job__c,CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c IN:allLocationName AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c IN:allLocationName AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub VIEW ALL' + listClaimsub);                                                                                                                                          List<ID> lstClaimIds = new List<Id>();

                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    // List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            system.debug('searchValue searchValue searchValue' + searchValue);  
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        if(searchField != 'paymentRefNumber'){
                            query = ' AND (CSS_Claims__c IN (' + query + ') OR CSS_Claims__r.Status__c= \'Draft\')';
                        }
                        else{
                            query = ' AND CSS_Claims__c IN (' + query + ')';
                        }
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo'+ query;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c IN: allLocationName AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo'+ query;
                    // 

                    system.debug('allLocationName' + allLocationName);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                    system.debug('VIEW ALL queryStr ' + queryStr);

                }
            }
            else{
                //GSSC:223  String Locname = userLoc.substring(0,userLoc.length()-8); 
                String Locname = userLoc; 
                system.debug('Locname' + ' ' + Locname);
                system.debug('claimStatus->'+claimStatus);
                if(searchValue!=null && searchValue.contains('-')){
                    string[] splittedConsolidatedClaim = searchValue.split('\\-');
                    searchValueConsolidatedClaim=splittedConsolidatedClaim[0];
                    system.debug('searchValueConsolidatedClaim'+searchValueConsolidatedClaim);
                }

                if(claimStatus == 'Draft' && tabClickClaimStatus =='Draft') {

                    if(searchField != 'paymentRefNumber'){
                        queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                        //GSSC:223  queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                        queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location_Code__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                        system.debug('queryStr   '+queryStr);

                        if(searchField == 'ConsolidatedClaimID'){
                            if(searchValue!=null && searchValue.contains('-'))
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                            else
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'Status'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                        else if(searchField == 'CustomerName'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                            system.debug('queryStr CustomerName  '+queryStr);
                        }
                        else if(searchField == 'ShopWorkOrder'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'ProductSerialNumber'){
                            queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'VINAssetSerialNumber'){
                            queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'GuidanzJobnumber'){
                            queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                            //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                        }
                        else if(searchField == 'All'){
                            searchValue= String.escapeSingleQuotes(searchValue) ;
                            queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        }

                        // Anvesh Today

                        /*  lstClaimSubPRCount = [SELECT Id,isPendingResponse__c FROM CSS_Claim_Submission__c 
                                                    WHERE 
                                                    //CSS_Claims__r.Location__c =:Locname  AND THIS SHOULD BE CHANGED ABSED ON OTHER PLACES.
                                                    Status__c ='In Review' AND isPendingResponse__c = true 
                                                    AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND 
                                                    DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo];

                        system.debug(' Today lstClaimSubPRCount >> '+ lstClaimSubPRCount);*/



                    }
                }

                else  if(claimStatus == 'submitted' &&  tabClickClaimStatus == 'submitted') {
                    //RESTRUCTURE THE SUBMITTED TAB
                    /*
queryStr = 'SELECT Id, VIN__c, CSS_Claims__r.Rejection_Comments__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
queryStr = queryStr + ' WHERE CSS_Claims__r.isSiebelProcessed__c = false AND CSS_Claims__r.Status__c = \'submitted\' AND CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
system.debug('queryStr   '+queryStr); 

if(searchField == 'ConsolidatedClaimID'){
if(searchValue!=null && searchValue.contains('-'))
queryStr = queryStr + ' AND CSS_Claims__r.Name = \'' + searchValueConsolidatedClaim + '\'';
else
queryStr = queryStr + ' AND CSS_Claims__r.Name = \'' + searchValue + '\'';
}
else if(searchField == 'Status'){
queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
}
else if(searchField == 'CustomerName'){
queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c = \'' + searchValue + '\'';
system.debug('queryStr CustomerName  '+queryStr);
}
else if(searchField == 'ShopWorkOrder'){
queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c = \'' + searchValue + '\'';
}
else if(searchField == 'ProductSerialNumber'){
queryStr = queryStr + ' AND PSN__c = \'' + searchValue + '\'';
}
else if(searchField == 'VINAssetSerialNumber'){
queryStr = queryStr + ' AND VIN__c = \'' + searchValue + '\'';
}
else if(searchField == 'GuidanzJobnumber'){
queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
//queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
}
else if(searchField == 'All'){
queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
}*/

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus AND  IMS_Claim_Number__c =: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus AND  IMS_Claim_Number__c =: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }

                    system.debug('listClaimsub Submitted' + listClaimsub);    

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                    //RESTRUCTURE THE SUBMITTED TAB
                }

                else  if(claimStatus == 'Pending Authorization' &&  tabClickClaimStatus == 'Pending Authorization') {
                    system.debug('prabhu inside pending auth for primary location');
                    if(searchField != 'paymentRefNumber'){
                        //Added code for GSSC-262
                        queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                        queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location_Code__c =:Locname AND Primary__c = true AND  CSS_Claims__r.Pending_Authorization__c=\'Authorization Required\' AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                        //GSSC:223  queryStr = queryStr + ' WHERE CSS_Claims__r.Status__c = \'Draft\' AND CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND  CSS_Claims__r.Pending_Authorization__c=\'Authorization Required\' AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';


                        if(searchField == 'ConsolidatedClaimID'){
                            if(searchValue!=null && searchValue.contains('-'))
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                            else
                                queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'Status'){
                            if(searchValueDropDown=='Pending Authorization')
                            {
                                queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'Draft\'';
                                //queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                            }
                            else{
                                queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                            }
                            //queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'Draft\'';
                            // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                        else if(searchField == 'CustomerName'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                        }
                        else if(searchField == 'ShopWorkOrder'){
                            queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'ProductSerialNumber'){
                            queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'VINAssetSerialNumber'){
                            queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                        }
                        else if(searchField == 'GuidanzJobnumber'){
                            queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                            //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                        }
                        else if(searchField == 'All'){
                            searchValue= String.escapeSingleQuotes(searchValue) ;
                            queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        }
                    }
                }

                else  if(claimStatus=='Information Only' && tabClickClaimStatus == 'Information Only'){

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname
                                        //AND (Status__c =:claimStatus) 
                                        AND (CSS_Claims__r.Information_Only_Claim__c =: TRUE)
                                        ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname 
                                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname 
                                        //AND (Status__c =:claimStatus) 
                                        AND IMS_Claim_Number__c=: searchValue 
                                        AND (CSS_Claims__r.Information_Only_Claim__c =: TRUE)
                                        ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Information Only' + listClaimsub);                                                                                                                                         

                    List<ID> lstClaimIds = new List<Id>();
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    // List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            //  system.debug('searchValue searchValue searchValue' + searchValue);  
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);
                    string draftstr = 'Draft';
                    string pendstr='Not Authorized';

                    //ADDED OR (CSS_Claims__r.Status__c =\'Not Authorized\') DUE TO PACCAR REJECTION******
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c,CSS_Claims__r.Pending_Authorization__c, CSS_Claims__r.Information_Only_Claim__c, VIN__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate, CSS_Claims__r.Rejection_Comments__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c = :Locname AND CSS_Claims__r.PartReturnToCenter__c = \'Y\' AND CSS_Claims__r.Information_Only_Claim__c = false AND (( Primary__c = true' +query; 
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c = :Locname AND (( Primary__c = true' +query; 
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c = :Locname AND (( Primary__c = true' +query; 
                    //queryStr  = queryStr  + ') OR (CSS_Claims__r.Pending_Authorization__c = \'Not Authorized\')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                    queryStr  = queryStr  + ') OR (CSS_Claims__r.Pending_Authorization__c = \'Not Authorized\') OR (CSS_Claims__r.Status__c =\'Not Authorized\')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                    //queryStr  = queryStr  + ')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';

                    system.debug('allLocationName' + queryStr);  
                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        if(searchValueDropDown == 'Information Only')
                        {
                            queryStr= queryStr;
                        }
                        else
                        {
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }



                }

                else if(claimStatus == 'Parts to Return' && tabClickClaimStatus == 'Parts to Return') {

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname AND PartReturnToCenter__c = 'Y' AND CSS_Claims__r.Information_Only_Claim__c = false AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Parts To Return' + listClaimsub);                                                                                                                                         

                    List<ID> lstClaimIds = new List<Id>();
                    system.debug('listClaimsub Submitted' + listClaimsub);    
                    // List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            //  system.debug('searchValue searchValue searchValue' + searchValue);  
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        system.debug('query***'+query);
                        query = query.substring(0, query.length()-1);
                        //query = ' AND CSS_Claims__c IN (' + query + ')'; //Commented and added below line as per story 190053
                        query = ' AND (CSS_Claims__c IN (' + query + ') OR (CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                    } else {    //Adding Else condition for GSSC-220 By Krishna.
                        query = '';
                        //Commented below query as part of defect GSSC 480 since it was throwing System.QueryException
                        //query = ' AND (CSS_Claims__c IN (' + query + ') OR (CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                        query = ' AND ((CSS_Claims__r.Status__c= \'Draft\' AND CSS_Claims__r.PartReturnToCenter__c = \'Y\'))';
                    }

                    /*if(searchField == 'paymentRefNumber' && (query =='' || query == null)){
                        String ClaimID='';
                        query= ' AND CSS_Claims__c =: ClaimID';
                    }*/
                    system.debug('loc All query' + query);
                    string draftstr = 'Draft';
                    string pendstr='Not Authorized';
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.PolicyClaim__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c = :Locname AND CSS_Claims__r.PartReturnToCenter__c = \'Y\' AND CSS_Claims__r.Information_Only_Claim__c = false AND(( Primary__c = true' +query; 
                    //queryStr  = queryStr  + ') OR (CSS_Claims__r.Status__c = \'Not Authorized\')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c = :Locname AND (( Primary__c = true' +query; 
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c = :Locname AND (( Primary__c = true' +query; 
                    queryStr  = queryStr  + ')) AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo';

                    system.debug('allLocationName' + queryStr);  
                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        if(searchValueDropDown == 'Information Only')
                        {
                            queryStr= queryStr;
                        }
                        else
                        {
                            queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                        }
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                else if(claimStatus == 'In Review' && tabClickClaimStatus =='In Review'){

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    //GSSC:223  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                //Below code added as part of GSSC -151 

                else if(claimStatus == 'Pending Response' && tabClickClaimStatus =='Pending Response'){

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c,
                                        CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223 - > this one is new code ==>  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c ='In Review' AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c ='In Review' AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c, IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name,
                                        LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c,isPendingResponse__c 
                                        FROM CSS_Claim_Submission__c 
                                        //GSSC:223 - > this one is new code ==>  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c ='In Review' AND IMS_Claim_Number__c=: searchValue AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c ='In Review' AND IMS_Claim_Number__c=: searchValue AND isPendingResponse__c = true ORDER BY LastModifiedDate asc limit 500];
                    }

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c ,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    //GSSC:223 - > this one is new code ==>  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                // End GSSC-151

                else if(claimStatus == 'Denied' && tabClickClaimStatus =='Denied'){

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c,IMS_Claim_Number__c, 
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c, Credit_Date__c,IMS_Claim_Number__c, 
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    //GSSC:223  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                else if(claimStatus == 'Appealed/Resubmitted' && tabClickClaimStatus =='Appealed/Resubmitted'){

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }

                    system.debug('listClaimsub Submitted' + listClaimsub);    

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c, CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    //GSSC:223  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        //searchValue=searchValue.replaceAll('(?!^\\+)[^\\d]','');
                        //searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }

                else if(claimStatus == 'Paid' && tabClickClaimStatus == 'paid'){

                    system.debug('for search Inside Claim status other than Draft' + claimStatus);
                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus ORDER BY LastModifiedDate desc limit 500];

                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c, Individual_Claim_Id__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, Status__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname  AND Status__c =: claimStatus AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    system.debug('listClaimsub Submitted' + listClaimsub);    

                    List<ID> lstClaimIds = new List<Id>();
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        query = ' AND CSS_Claims__c IN (' + query + ')';
                    }

                    system.debug('loc All query' + query);  
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c, CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c,CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c, CSS_Claims__r.Rejection_Comments__c, CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location_Code__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;
                    //GSSC:223  queryStr =  queryStr+ ' WHERE CSS_Claims__r.Location__c =: Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query ;

                    system.debug('after query listclaimsids' + lstClaimIds);
                    system.debug('Locname' + Locname);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        // queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';

                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }


                else {
                    system.debug('VIEW ALL');

                    if(searchField != 'paymentRefNumber'){
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname ORDER BY LastModifiedDate desc limit 500];
                    }
                    else{
                        listClaimsub = [SELECT Id, CSS_Claims__r.CSS_Job__r.Status__c, CreatedDate,CSS_Claims__r.LastModifiedDate, CSS_Claims__r.LastModifiedBy.Name, CSS_Claims__c, Individual_Claim_Id__c, 
                                        CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  Credit_Date__c,IMS_Claim_Number__c,
                                        CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, 
                                        CSS_Claims__r.Shop_Work_Order__c, CSS_Claims__r.CSS_Job__r.Name,CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, LastModifiedDate,Status__c, LastModifiedBy.Name,Siebel_Claim_Number__c,SiebelPaymentReceived__c 
                                        FROM CSS_Claim_Submission__c 
                                        WHERE CSS_Claims__r.Location_Code__c =:Locname AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                        //GSSC:223  WHERE CSS_Claims__r.Location__c =:Locname AND IMS_Claim_Number__c=: searchValue ORDER BY LastModifiedDate desc limit 500];
                    }
                    set<ID> lstClaimIds1 = new set<Id>();
                    if(listClaimsub != null && listClaimsub.size() >0){
                        for(CSS_Claim_Submission__c cs : listClaimsub){
                            //  lstClaimIds.add(cs.CSS_Claims__c);
                            lstClaimIds1.add(cs.CSS_Claims__c);
                        }
                    }
                    system.debug('listClaimsub****'+listClaimsub);
                    string query = '';
                    if(lstClaimIds1 != null && lstClaimIds1.size() > 0) {
                        for(Id Ids : lstClaimIds1) {
                            query += '\'' + Ids + '\'' + ',';
                        }
                        query = query.substring(0, query.length()-1);
                        if(searchField != 'paymentRefNumber'){
                            query = ' AND (CSS_Claims__c IN (' + query + ') OR CSS_Claims__r.Status__c= \'Draft\')';
                        }
                        else{
                            query = ' AND CSS_Claims__c IN (' + query + ')';
                        }
                    }

                    system.debug('loc All query' + query);
                    //Added code for GSSC-262
                    queryStr = 'SELECT Id, VIN__c,CSS_Claims__r.LastSavedDate__c,CSS_Claims__r.Last_saved_by__c, CSS_Claims__r.SiebelClaimNumber__c,CSS_Claims__r.CSS_Job__r.Status__c, CSS_Claims__r.LastModifiedDate,CSS_Claims__r.PolicyClaim__c,CSS_Claims__r.Catastrophic__c,CSS_Claims__r.LastModifiedBy.Name, Primary__c, CSS_Claims__r.Location__c, CSS_Claims__r.Location_Code__c, CSS_Claims__r.Claim_Submitted__c,  CSS_Claims__r.Status__c, CSS_Claims__r.Name, CSS_Claims__r.Payment_Details__c, CSS_Claims__r.Customer_Name__c, CSS_Claims__r.Shop_Work_Order__c, PSN__c, CSS_Claims__r.Dealer_Service_Job__c, CSS_Claims__r.Dealer_Service_Job__r.Name, CSS_Claims__r.CSS_Job__r.Name, CSS_Claims__r.Rejection_Comments__c, LastModifiedDate, LastModifiedBy.Name,CSS_Claims__r.Multi_PSN_Claim__c FROM CSS_PSN__c' ;
                    queryStr =  queryStr + ' WHERE CSS_Claims__r.Location_Code__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    //GSSC:223  queryStr =  queryStr + ' WHERE CSS_Claims__r.Location__c =:Locname AND Primary__c = true AND CSS_Claims__r.CreatedDate > :DR AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate)) >=: datesearchone AND DAY_ONLY(convertTimezone(CSS_Claims__r.CreatedDate))<=: datesearchtwo' + query;
                    // 

                    system.debug('queryStr' + queryStr);

                    if(searchField == 'ConsolidatedClaimID'){
                        if(searchValue!=null && searchValue.contains('-'))
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValueConsolidatedClaim + '%\'';
                        else
                            queryStr = queryStr + ' AND CSS_Claims__r.Name LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'Status'){
                        //Commented because of fetching the status records from claim header level instead of  submission level
                        //  queryStr = queryStr + ' AND CSS_Claims__r.Status__c = \'' + searchValueDropDown + '\'';
                    }
                    else if(searchField == 'CustomerName'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Customer_Name__c LIKE \'%' + String.escapeSingleQuotes(searchValue) + '%\'';
                    }
                    else if(searchField == 'ShopWorkOrder'){
                        queryStr = queryStr + ' AND CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'ProductSerialNumber'){
                        queryStr = queryStr + ' AND PSN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'VINAssetSerialNumber'){
                        queryStr = queryStr + ' AND VIN__c LIKE \'%' + searchValue + '%\'';
                    }
                    else if(searchField == 'GuidanzJobnumber'){
                        queryStr = queryStr + ' AND (CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                        //queryStr = queryStr + ' AND CSS_Claims__r.CSS_Job__r.Name = \'' + searchValue + '\'';
                    }
                    else if(searchField == 'All'){
                        searchValue= String.escapeSingleQuotes(searchValue) ;
                        queryStr = queryStr + ' AND (CSS_Claims__r.Name LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Status__c LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Customer_Name__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.Shop_Work_Order__c LIKE \'%' + searchValue + '%\' OR PSN__c LIKE \'%' + searchValue + '%\' OR VIN__c LIKE \'%' + searchValue + '%\' OR CSS_Claims__r.CSS_Job__r.Name LIKE \'%' + searchValue +'%\' OR CSS_Claims__r.Dealer_Service_Job__r.Name LIKE \'%' + searchValue +'%\')';
                    }

                }
            }
            system.debug('searchValue' + searchValue);
            system.debug('Primary__c >>>>>'+CSS_PSN__c.Primary__c);
            if(queryStr!=null)
                queryStr = queryStr + ' ORDER BY CSS_Claims__r.LastSavedDate__c desc limit 500'; //krishna
            system.debug('queryStr**'+queryStr);
            //queryStr = queryStr + ' ORDER BY LastModifiedDate desc limit 500';
            listClaim = new List<CSS_PSN__c>();
            //  listClaimsub = new list<CSS_Claim_Submission__c>();
            system.debug('Final QUery-->'+queryStr);
            if(queryStr!=null){
                listClaim = Database.query(queryStr);
                system.debug('listClaim-->'+listClaim);
                system.debug('listClaimsub-->'+listClaimsub);
            }

        }
        // for(CSS_PSN__c claim : listClaim){system.debug('listClaim KAL-->'+listClaim);} // Testing kal
        // for(int i=listClaim.size()-1;i>0;i--){system.debug('listClaim KAL2-->'+listClaim);} // Testing kal
        system.debug('Limits--'+(Limits.getLimitQueryRows()-Limits.getQueryRows()));
        if(claimStatus == 'Draft') {    ////RESTRUCTURE THE SUBMITTED TAB
            for(CSS_PSN__c claim : listClaim){
                String locStr;
                ClaimsWrap claimWrap = new ClaimsWrap();
                claimWrap.Id = claim.CSS_Claims__c;
                //claimWrap.isPSNTriggered = isPSNTriggered;
                //claimWrap.claimSubmitted = '';
                claimWrap.claimID = claim.CSS_Claims__r.Name;
                claimWrap.claimSubmisionRecordId='';
                claimWrap.MultiPSNFlag=claim.CSS_Claims__r.Multi_PSN_Claim__c;
                if(claim.CSS_Claims__r.PolicyClaim__c && Profile)
                    claimWrap.policyClaim = true;
                else
                    claimWrap.policyClaim = false; 

                system.debug('claimWrap.policyClaim' + ' ' + claimWrap.policyClaim);

                claimWrap.jobStatus = claim.CSS_Claims__r.CSS_Job__r.Status__c;
                claimWrap.status = claim.CSS_Claims__r.Status__c;
                claimWrap.paymentDetails = claim.CSS_Claims__r.Payment_Details__c;
                claimWrap.customerName = claim.CSS_Claims__r.Customer_Name__c;
                claimWrap.shopWO = claim.CSS_Claims__r.Shop_Work_Order__c;
                claimWrap.prodSerialNum = claim.PSN__c;
                claimWrap.cataClaim=claim.CSS_Claims__r.Catastrophic__c;//167793 Rupesh
                if(claim.CSS_Claims__r.CSS_Job__r.Name != null && claim.CSS_Claims__r.CSS_Job__r.Name != ''){
                    claimWrap.serviceJob = claim.CSS_Claims__r.CSS_Job__r.Name;
                    claimWrap.serviceJobId = claim.CSS_Claims__r.CSS_Job__c;
                }
                else if(claim.CSS_Claims__r.Dealer_Service_Job__r.Name != null && claim.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                    claimWrap.serviceJob = claim.CSS_Claims__r.Dealer_Service_Job__r.Name;
                    claimWrap.serviceJobId = claim.CSS_Claims__r.Dealer_Service_Job__c;
                }
                //claimWrap.serviceJobId = claim.CSS_Claims__r.CSS_Job__c;
                claimWrap.warrClaimId = '';
                claimWrap.paymentRefNumber = '';
                claimWrap.warrCopyClaimId=claim.CSS_Claims__r.SiebelClaimNumber__c;
                if(claim.CSS_Claims__r.Location_Code__c != '' && claim.CSS_Claims__r.Location_Code__c != null){
                    locStr = (claim.CSS_Claims__r.Location_Code__c).right(5);
                } else{
                    locStr = '';    
                }
                if(locStr != null && claim.CSS_Claims__r.Location__c != null)
                    claimWrap.location = locStr+' '+claim.CSS_Claims__r.Location__c;
                else if(claim.CSS_Claims__r.Location__c == null)
                    claimWrap.location = locStr;
                else
                    claimWrap.location = '';
                // if(string.valueof(claim.LastModifiedDate) != null){
                //     claimWrap.LastSaved = string.valueof(claim.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                // }
                //Added code for GSSC-262

                if(claim.CSS_Claims__r.LastSavedDate__c !=null) {
                    claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                    if(string.valueof(claimWrap.LastSaved) != null)
                        claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                    //claimWrap.lastSaved_sort = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z')); //kalpana
                    system.debug('claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                    system.debug('claim.CSS_Claims__r.LastSavedDate__c.formatyyyy MM dd HH:mm a z**'+claim.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                    claimWrap.lastSaved_sort = claim.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z');
                    if(string.valueof(claimWrap.lastSaved_sort) != null)
                        claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                    system.debug('lastSaved_sort**'+claimWrap.lastSaved_sort);
                }
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                    claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;
                //Added code for GSSC-262

                /*if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                    */
                //claimWrap.LastSaved= claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'); //kal
                //if(claim.CSS_Claims__r.Last_Saved__c != null && claim.CSS_Claims__r.Last_Saved__c != '')
                //claimWrap.LastSaved= claim.CSS_Claims__r.Last_Saved__c.toUppercase();
                //claimWrap.lastSavedBy = claim.LastModifiedBy.Name;

                system.debug('**claimWrap.lastSavedBy**'+claimWrap.lastSavedBy);
                listWrap.add(claimWrap);
                system.debug('listWrap1--'+listWrap);
            }
        } 
        //RESTRUCTURE THE SUBMITTED TAB
        //IT COVERS FINAL ELSE.
        //RESTRUCTURE THE SUBMITTED TAB
        ///////////////////////
        else if(claimStatus == 'Pending Authorization') {
            for(CSS_PSN__c claim : listClaim){
                String locStr;
                ClaimsWrap claimWrap = new ClaimsWrap();
                claimWrap.Id = claim.CSS_Claims__c;
                //claimWrap.isPSNTriggered = isPSNTriggered;
                //claimWrap.claimSubmitted = '';
                claimWrap.claimID = claim.CSS_Claims__r.Name;

                if(claim.CSS_Claims__r.PolicyClaim__c && Profile)
                    claimWrap.policyClaim = true;
                else
                    claimWrap.policyClaim = false; 

                system.debug('claimWrap.policyClaim' + ' ' + claimWrap.policyClaim);

                claimWrap.claimSubmisionRecordId='';
                claimWrap.jobStatus = claim.CSS_Claims__r.CSS_Job__r.Status__c;
                claimWrap.status = claim.CSS_Claims__r.Status__c;
                claimWrap.paymentDetails = claim.CSS_Claims__r.Payment_Details__c;
                claimWrap.customerName = claim.CSS_Claims__r.Customer_Name__c;
                claimWrap.MultiPSNFlag=claim.CSS_Claims__r.Multi_PSN_Claim__c;
                claimWrap.shopWO = claim.CSS_Claims__r.Shop_Work_Order__c;
                claimWrap.prodSerialNum = claim.PSN__c;
                if(claim.CSS_Claims__r.CSS_Job__r.Name != null && claim.CSS_Claims__r.CSS_Job__r.Name != ''){
                    claimWrap.serviceJob = claim.CSS_Claims__r.CSS_Job__r.Name;
                    claimWrap.serviceJobId = claim.CSS_Claims__r.CSS_Job__c;
                }
                else if(claim.CSS_Claims__r.Dealer_Service_Job__r.Name != null && claim.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                    claimWrap.serviceJob = claim.CSS_Claims__r.Dealer_Service_Job__r.Name;
                    claimWrap.serviceJobId = claim.CSS_Claims__r.Dealer_Service_Job__c;
                }
                //claimWrap.serviceJobId = claim.CSS_Claims__r.CSS_Job__c;
                claimWrap.warrClaimId = '';
                claimWrap.warrCopyClaimId=claim.CSS_Claims__r.SiebelClaimNumber__c;
                if(claim.CSS_Claims__r.Location_Code__c != '' && claim.CSS_Claims__r.Location_Code__c != null){
                    locStr = (claim.CSS_Claims__r.Location_Code__c).right(5);
                } else{
                    locStr = '';    
                }
                if(locStr != null && claim.CSS_Claims__r.Location__c != null)
                    claimWrap.location = locStr+' '+claim.CSS_Claims__r.Location__c;
                else if(claim.CSS_Claims__r.Location__c == null)
                    claimWrap.location = locStr;
                else
                    claimWrap.location = '';

                // if(string.valueof(claim.LastModifiedDate) != null){
                //     claimWrap.LastSaved = string.valueof(claim.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                // }
                //Added code for GSSC-262

                if(claim.CSS_Claims__r.LastSavedDate__c !=null) {
                    claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                    if(string.valueof(claimWrap.LastSaved) != null)
                        claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                    claimWrap.lastSaved_sort = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                    if(string.valueof(claimWrap.lastSaved_sort) != null)
                        claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                }
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                    claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;
                //Added code for GSSC-262
                /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                //if(claim.CSS_Claims__r.Last_Saved__c!='' && claim.CSS_Claims__r.Last_Saved__c!=null)
                //claimWrap.LastSaved= claim.CSS_Claims__r.Last_Saved__c.toUppercase();
                // claimWrap.lastSavedBy = claim.LastModifiedBy.Name;
                //claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;
                listWrap.add(claimWrap);
                system.debug('listWrap1--'+listWrap);
            }
        } 
        /////////////////
        else if(claimStatus == 'Information Only') {
            system.debug('wrapper assign inside Information Only');
            for (CSS_PSN__c PSN : listClaim){

                if((PSN.CSS_Claims__r.Pending_Authorization__c != null && PSN.CSS_Claims__r.Pending_Authorization__c == 'Not Authorized') || PSN.CSS_Claims__r.Status__c == 'Not Authorized') {
                    // if(PSN.CSS_Claims__r.Pending_Authorization__c == 'Not Authorized') {
                    String locStr;
                    ClaimsWrap claimWrap = new ClaimsWrap();
                    claimWrap.Id = PSN.CSS_Claims__c;
                    //claimWrap.isPSNTriggered = isPSNTriggered;
                    //claimWrap.claimSubmitted = '';
                    claimWrap.claimID = PSN.CSS_Claims__r.Name;
                    claimWrap.MultiPSNFlag=PSN.CSS_Claims__r.Multi_PSN_Claim__c;
                    if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                        claimWrap.policyClaim = true;
                    else
                        claimWrap.policyClaim = false; 

                    system.debug('claimWrap.policyClaim' + ' ' + claimWrap.policyClaim);
                    claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                    claimWrap.status = 'Not Authorized';
                    //claimWrap.status = psn.CSS_Claims__r.Rejection_Comments__c;
                    // claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                    claimWrap.paymentDetails = psn.CSS_Claims__r.Rejection_Comments__c;
                    claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                    claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                    claimWrap.prodSerialNum = PSN.PSN__c;
                    if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    }
                    else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                    }
                    //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                        locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                    } else{
                        locStr = '';    
                    }
                    if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                        claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                    else if(PSN.CSS_Claims__r.Location__c == null)
                        claimWrap.location = locStr;
                    else
                        claimWrap.location = '';

                    if(string.valueof(PSN.LastModifiedDate) != null){
                        claimWrap.LastSaved = string.valueof(PSN.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                        claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                    }
                    claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
                    system.debug('listWrap.size() ' + listWrap.size());
                    if(listWrap.size()<500)//<100
                        listWrap.add(claimWrap);
                    system.debug(' VIEWALL listwrap' + ' ' + listwrap);
                }
                else{
                    for(CSS_Claim_Submission__c cs : listClaimsub){
                        if(cs.CSS_Claims__c == PSN.CSS_Claims__c) {
                            String locStr;
                            ClaimsWrap claimWrap = new ClaimsWrap();
                            claimWrap.Id = cs.CSS_Claims__c;
                            //claimWrap.isPSNTriggered = isPSNTriggered;
                            if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                claimWrap.policyClaim = true;
                            else
                                claimWrap.policyClaim = false; 
                            claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                            claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                            if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                            claimWrap.claimSubmisionRecordId=cs.Id;
                            claimWrap.claimID = cs.Individual_Claim_Id__c;
                            claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                            claimWrap.status = 'Information Only';
                            claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                            claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                            claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                            claimWrap.prodSerialNum = PSN.PSN__c;
                            if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            }
                            else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                            }
                            //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                            claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                            claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
                            claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                            if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                                locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                            } else{
                                locStr = '';    
                            }
                            if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                                claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                            else if(PSN.CSS_Claims__r.Location__c == null)
                                claimWrap.location = locStr;
                            else
                                claimWrap.location = '';

                            // if(string.valueof(cs.LastModifiedDate) != null){
                            //     claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                            //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                            // }
                            //Added code for GSSC-262

                            if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                if(string.valueof(claimWrap.LastSaved) != null)
                                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                if(string.valueof(claimWrap.lastSaved_sort) != null)
                                    claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                            }
                            if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            //Added code for GSSC-262
                            /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                            //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                            //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                            // claimWrap.lastSavedBy = cs.LastModifiedBy.Name;
                            //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            system.debug('listWrap.size() ' + listWrap.size());
                            if(listWrap.size()<=500)//<=100
                                listWrap.add(claimWrap);
                            system.debug('view all listwrap' + ' ' + listwrap);


                        } 



                    }}


            }
        }        
        else if(claimStatus == 'Parts to Return') {
            system.debug('wrapper assign inside Parts to Return');
            for (CSS_PSN__c PSN : listClaim){
                //Uncommented below IF condition to show the parts under Parts to Return Tab for Draft status claims as per story 190053
                if(PSN.CSS_Claims__r.Status__c == 'Draft') {
                    // if(PSN.CSS_Claims__r.Pending_Authorization__c == 'Not Authorized') {
                    String locStr;
                    ClaimsWrap claimWrap = new ClaimsWrap();
                    claimWrap.Id = PSN.CSS_Claims__c;
                    //claimWrap.isPSNTriggered = isPSNTriggered;
                    if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                        claimWrap.policyClaim = true;
                    else
                        claimWrap.policyClaim = false; 
                    //claimWrap.claimSubmitted = '';
                    claimWrap.claimID = PSN.CSS_Claims__r.Name;
                    claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                    claimWrap.MultiPSNFlag=PSN.CSS_Claims__r.Multi_PSN_Claim__c;
                    claimWrap.status = 'Draft';
                    //claimWrap.status = psn.CSS_Claims__r.Rejection_Comments__c;
                    // claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                    claimWrap.paymentDetails = psn.CSS_Claims__r.Rejection_Comments__c;
                    claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                    claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                    claimWrap.prodSerialNum = PSN.PSN__c;
                    if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    }
                    else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                    }
                    //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                        locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                    } else{
                        locStr = '';    
                    }
                    if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                        claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                    else if(PSN.CSS_Claims__r.Location__c == null)
                        claimWrap.location = locStr;
                    else
                        claimWrap.location = '';

                    // if(string.valueof(PSN.LastModifiedDate) != null){
                    //     claimWrap.LastSaved = string.valueof(PSN.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                    //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                    // }
                    //Added code for GSSC-262

                    if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                        claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                        if(string.valueof(claimWrap.LastSaved) != null)
                            claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                        claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                        if(string.valueof(claimWrap.lastSaved_sort) != null)
                            claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                    }
                    if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                        claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                    //Added code for GSSC-262
                    /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                    //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                    //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                    // claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
                    //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                    system.debug('listWrap.size() ' + listWrap.size());
                    if(listWrap.size()<500)//<100
                        listWrap.add(claimWrap);
                    system.debug(' Parts to Return listwrap' + ' ' + listwrap);
                }
                //Uncommented below Else condition (only line#2587) to show the parts under Parts to Return Tab for Draft status claims as per story 190053
                else{
                    system.debug('Inside Else--'+listClaimsub);
                    for(CSS_Claim_Submission__c cs : listClaimsub){
                        system.debug('ClaimID--'+cs.CSS_Claims__c+' '+PSN.CSS_Claims__c);
                        if(cs.CSS_Claims__c == PSN.CSS_Claims__c) {
                            String locStr;
                            ClaimsWrap claimWrap = new ClaimsWrap();
                            claimWrap.Id = cs.CSS_Claims__c;
                            //claimWrap.isPSNTriggered = isPSNTriggered;
                            if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                claimWrap.policyClaim = true;
                            else
                                claimWrap.policyClaim = false; 
                            claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                            claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                            if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                            claimWrap.claimSubmisionRecordId=cs.Id;
                            claimWrap.claimID = cs.Individual_Claim_Id__c;
                            claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                            claimWrap.status = cs.Status__c;//'Parts to Return'; //What value to assign?
                            claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                            claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                            claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                            claimWrap.prodSerialNum = PSN.PSN__c;
                            if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            }
                            else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                            }
                            //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                            claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                            claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
                            claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                            if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                                locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                            } else{
                                locStr = '';    
                            }
                            if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                                claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                            else if(PSN.CSS_Claims__r.Location__c == null)
                                claimWrap.location = locStr;
                            else
                                claimWrap.location = '';

                            // if(string.valueof(cs.LastModifiedDate) != null){
                            //     claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                            //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                            // }
                            //Added code for GSSC-262

                            if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                if(string.valueof(claimWrap.LastSaved) != null)
                                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                if(string.valueof(claimWrap.lastSaved_sort) != null)
                                    claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                            }
                            if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            //Added code for GSSC-262
                            /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                            //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                            //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                            // claimWrap.lastSavedBy = cs.LastModifiedBy.Name;
                            //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            system.debug('listWrap.size() ' + listWrap.size());
                            if(listWrap.size()<=500)//<=100
                                listWrap.add(claimWrap);
                            system.debug('parts to return listwrap' + ' ' + listwrap);
                        } 
                    }
                }
            }
        }
        else if(claimStatus == 'view all') {
            system.debug('wrapper assign inside view all');

            for (CSS_PSN__c PSN : listClaim){
                system.debug('CSS_Claims__r.Status__c ' + ' ' + PSN.CSS_Claims__r.Status__c ) ;
                if(PSN.CSS_Claims__r.Status__c == 'Draft') {
                    String locStr;
                    ClaimsWrap claimWrap = new ClaimsWrap();
                    claimWrap.Id = PSN.CSS_Claims__c;
                    //claimWrap.isPSNTriggered = isPSNTriggered;
                    if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                        claimWrap.policyClaim = true;
                    else
                        claimWrap.policyClaim = false; 
                    //claimWrap.claimSubmitted = '';
                    claimWrap.claimID = PSN.CSS_Claims__r.Name;
                    claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                    claimWrap.status = PSN.CSS_Claims__r.Status__c;
                    claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                    claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                    claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                    claimWrap.MultiPSNFlag=PSN.CSS_Claims__r.Multi_PSN_Claim__c;
                    claimWrap.prodSerialNum = PSN.PSN__c;
                    if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    }
                    else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                        claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                        claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                    }
                    //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                    if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                        locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                    } else{
                        locStr = '';    
                    }
                    if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                        claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                    else if(PSN.CSS_Claims__r.Location__c == null)
                        claimWrap.location = locStr;
                    else
                        claimWrap.location = '';

                    // if(string.valueof(PSN.LastModifiedDate) != null){
                    //     claimWrap.LastSaved = string.valueof(PSN.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                    //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                    // }
                    //Added code for GSSC-262

                    if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                        claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                        if(string.valueof(claimWrap.LastSaved) != null)
                            claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                        claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                        if(string.valueof(claimWrap.lastSaved_sort) != null)
                            claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                    }
                    if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                        claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                    //Added code for GSSC-262
                    /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                    //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                    //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                    // claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
                    //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                    system.debug('listWrap.size() ' + listWrap.size());
                    if(listWrap.size()<500)//<100
                        listWrap.add(claimWrap);
                    system.debug(' VIEWALL listwrap' + ' ' + listwrap);
                }

                for(CSS_Claim_Submission__c cs : listClaimsub){
                    if(searchValue!=null && searchValue.contains('-')){
                        if(searchValue==cs.Individual_Claim_Id__c || searchValue.contains('CSS')){
                            if(cs.CSS_Claims__c == PSN.CSS_Claims__c) {
                                String locStr;
                                ClaimsWrap claimWrap = new ClaimsWrap();
                                claimWrap.Id = cs.CSS_Claims__c;
                                //claimWrap.isPSNTriggered = isPSNTriggered;
                                if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                    claimWrap.policyClaim = true;
                                else
                                    claimWrap.policyClaim = false; 
                                if(cs.Credit_Date__c != null){
                                    // DateTime DateformValue = cs.Credit_Date__c;
                                    // claimWrap.claimSubmitted = DateformValue.format('dd MMM YYYY hh:mm a z');
                                    claimWrap.claimSubmitted =dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('dd MMM YYYY hh:mm a z');  
                                    claimWrap.claimSubmitted_sort = dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('yyyy MM dd HH:mm a z'); //Added as part of story GSSC-154
                                    if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                        claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                }
                                else{
                                    if(!cs.Status__c.containsIgnoreCase('Paid')){
                                        claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                                        claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                                        if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                            claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                    }
                                }
                                claimWrap.claimSubmisionRecordId=cs.Id;
                                claimWrap.claimID = cs.Individual_Claim_Id__c;
                                claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                                claimWrap.status = cs.Status__c;
                                claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                                claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                                claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                                claimWrap.prodSerialNum = PSN.PSN__c;
                                if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                                    claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                                    claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                                }
                                else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                    claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                    claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                                }
                                claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                                claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                                claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
                                claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                                if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                                    locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                                } else{
                                    locStr = '';    
                                }
                                if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                                    claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                                else if(PSN.CSS_Claims__r.Location__c == null)
                                    claimWrap.location = locStr;
                                else
                                    claimWrap.location = '';

                                // if(string.valueof(cs.LastModifiedDate) != null){
                                //     claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                                //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                                // }
                                //Added code for GSSC-262

                                if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                    claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                    if(string.valueof(claimWrap.LastSaved) != null)
                                        claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                    claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                    if(string.valueof(claimWrap.lastSaved_sort) != null)
                                        claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                                }
                                if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                    claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                                //Added code for GSSC-262
                                /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                                //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                                //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                                // claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
                                //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                                system.debug('listWrap.size() ' + listWrap.size());
                                if(listWrap.size()<=500)//<=100
                                    listWrap.add(claimWrap);
                                system.debug('view all listwrap' + ' ' + listwrap);


                            }
                        }
                        //
                        /* else if(searchValue!=null && searchValue.contains('CSS')){
system.debug('insidesearchValue'+searchValue);
if(cs.CSS_Claims__c == PSN.CSS_Claims__c) {
String locStr;
ClaimsWrap claimWrap = new ClaimsWrap();
claimWrap.Id = cs.CSS_Claims__c;
//claimWrap.isPSNTriggered = isPSNTriggered;
if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
claimWrap.policyClaim = true;
else
claimWrap.policyClaim = false; 
claimWrap.claimSubmitted = string.valueof(cs.CreatedDate.format('dd MMM YYYY hh:mm a z'));
claimWrap.claimSubmisionRecordId=cs.Id;
claimWrap.claimID = cs.Individual_Claim_Id__c;
claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
claimWrap.status = cs.Status__c;
claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
claimWrap.prodSerialNum = PSN.PSN__c;
if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != '')
claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != '')
claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
} else{
locStr = '';    
}
if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
else if(PSN.CSS_Claims__r.Location__c == null)
claimWrap.location = locStr;
else
claimWrap.location = '';

if(string.valueof(cs.LastModifiedDate) != null){
claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
}
claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
system.debug('listWrap.size() ' + listWrap.size());
if(listWrap.size()<=100)
listWrap.add(claimWrap);
system.debug('view all listwrap' + ' ' + listwrap);


}
}*/

                        //
                    }
                    else{
                        if(cs.CSS_Claims__c == PSN.CSS_Claims__c) {
                            String locStr;
                            ClaimsWrap claimWrap = new ClaimsWrap();
                            claimWrap.Id = cs.CSS_Claims__c;
                            //claimWrap.isPSNTriggered = isPSNTriggered;
                            if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                claimWrap.policyClaim = true;
                            else
                                claimWrap.policyClaim = false; 
                            if(cs.Credit_Date__c != null){
                                // DateTime DateformValue = cs.Credit_Date__c;
                                // claimWrap.claimSubmitted = DateformValue.format('dd MMM YYYY hh:mm a z');
                                claimWrap.claimSubmitted =dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('dd MMM YYYY hh:mm a z');
                                claimWrap.claimSubmitted_sort = dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('yyyy MM dd HH:mm a z'); //Added as part of story GSSC-154
                                if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                    claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                            }
                            else{
                                if(!cs.Status__c.containsIgnoreCase('Paid')){
                                    claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                                    claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                                    if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                        claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                }
                            }
                            claimWrap.claimSubmisionRecordId=cs.Id;
                            claimWrap.claimID = cs.Individual_Claim_Id__c;
                            claimWrap.jobStatus = PSN.CSS_Claims__r.CSS_Job__r.Status__c;
                            claimWrap.status = cs.Status__c;
                            claimWrap.paymentDetails = PSN.CSS_Claims__r.Payment_Details__c;
                            claimWrap.customerName = PSN.CSS_Claims__r.Customer_Name__c;
                            claimWrap.shopWO = PSN.CSS_Claims__r.Shop_Work_Order__c;
                            claimWrap.prodSerialNum = PSN.PSN__c;
                            if(PSN.CSS_Claims__r.CSS_Job__r.Name != null && PSN.CSS_Claims__r.CSS_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.CSS_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            }
                            else if(PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != null && PSN.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                claimWrap.serviceJob = PSN.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                claimWrap.serviceJobId = PSN.CSS_Claims__r.Dealer_Service_Job__c;
                            }
                            //claimWrap.serviceJobId = PSN.CSS_Claims__r.CSS_Job__c;
                            claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                            claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                            claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
                            claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                            if(PSN.CSS_Claims__r.Location_Code__c != '' && PSN.CSS_Claims__r.Location_Code__c != null){
                                locStr = (PSN.CSS_Claims__r.Location_Code__c).right(5);
                            } else{
                                locStr = '';    
                            }
                            if(locStr != null && PSN.CSS_Claims__r.Location__c != null)
                                claimWrap.location = locStr+' '+PSN.CSS_Claims__r.Location__c;
                            else if(PSN.CSS_Claims__r.Location__c == null)
                                claimWrap.location = locStr;
                            else
                                claimWrap.location = '';

                            // if(string.valueof(cs.LastModifiedDate) != null){
                            //     claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                            //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                            // }
                            //Added code for GSSC-262

                            if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                if(string.valueof(claimWrap.LastSaved) != null)
                                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                if(string.valueof(claimWrap.lastSaved_sort) != null)
                                    claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                            }
                            if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            //Added code for GSSC-262
                            /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                            //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                            //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                            // claimWrap.lastSavedBy = PSN.LastModifiedBy.Name;
                            //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            system.debug('listWrap.size() ' + listWrap.size());
                            if(listWrap.size()<=500)//<=100
                                listWrap.add(claimWrap);
                            system.debug('view all listwrap' + ' ' + listwrap);


                        } 
                    }


                }


            }
        } 
        else {

            for(CSS_Claim_Submission__c cs : listClaimsub){

                if(searchValue!=null && searchValue.contains('-') ){
                    if(searchValue==cs.Individual_Claim_Id__c || searchValue.contains('CSS')){

                        for (CSS_PSN__c psn : listClaim){
                            if(cs.CSS_Claims__c == psn.CSS_Claims__c) {
                                String locStr;
                                ClaimsWrap claimWrap = new ClaimsWrap();
                                claimWrap.Id = cs.CSS_Claims__c;
                                //claimWrap.isPSNTriggered = isPSNTriggered;
                                if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                    claimWrap.policyClaim = true;
                                else
                                    claimWrap.policyClaim = false; 
                                if(cs.Credit_Date__c != null){
                                    // DateTime DateformValue = cs.Credit_Date__c;
                                    //claimWrap.claimSubmitted = DateformValue.format('dd MMM YYYY hh:mm a z');
                                    claimWrap.claimSubmitted =dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('dd MMM YYYY hh:mm a z');
                                    claimWrap.claimSubmitted_sort = dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('yyyy MM dd HH:mm a z'); //Added as part of story GSSC-154
                                    if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                        claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                }
                                else{
                                    if(!cs.Status__c.containsIgnoreCase('Paid')){
                                        claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                                        claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                                        if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                            claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                    }
                                }
                                claimWrap.claimSubmisionRecordId=cs.Id;
                                claimWrap.MultiPSNFlag=psn.CSS_Claims__r.Multi_PSN_Claim__c;
                                claimWrap.claimID = cs.Individual_Claim_Id__c;
                                claimWrap.jobStatus = psn.CSS_Claims__r.CSS_Job__r.Status__c;
                                claimWrap.status = cs.Status__c;
                                claimWrap.paymentDetails = psn.CSS_Claims__r.Payment_Details__c;
                                claimWrap.customerName = psn.CSS_Claims__r.Customer_Name__c;
                                claimWrap.shopWO = psn.CSS_Claims__r.Shop_Work_Order__c;
                                claimWrap.prodSerialNum = psn.PSN__c;
                                if(psn.CSS_Claims__r.CSS_Job__r.Name != null && psn.CSS_Claims__r.CSS_Job__r.Name != ''){
                                    claimWrap.serviceJob = psn.CSS_Claims__r.CSS_Job__r.Name;
                                    claimWrap.serviceJobId = psn.CSS_Claims__r.CSS_Job__c;
                                }
                                else if(psn.CSS_Claims__r.Dealer_Service_Job__r.Name != null && psn.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                    claimWrap.serviceJob = psn.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                    claimWrap.serviceJobId = psn.CSS_Claims__r.Dealer_Service_Job__c;
                                }
                                //claimWrap.serviceJobId = psn.CSS_Claims__r.CSS_Job__c;
                                claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                                claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                                claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
                                claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                                if(claimStatus == 'Pending Response')
                                    claimWrap.pendingResponseSP = cs.isPendingResponse__c; //GSSC-151
                                else
                                    claimWrap.pendingResponseSP = false; //GSSC-151
                                if(psn.CSS_Claims__r.Location_Code__c != '' && psn.CSS_Claims__r.Location_Code__c != null){
                                    locStr = (psn.CSS_Claims__r.Location_Code__c).right(5);
                                } else{
                                    locStr = '';    
                                }
                                if(locStr != null && psn.CSS_Claims__r.Location__c != null)
                                    claimWrap.location = locStr+' '+psn.CSS_Claims__r.Location__c;
                                else if(psn.CSS_Claims__r.Location__c == null)
                                    claimWrap.location = locStr;
                                else
                                    claimWrap.location = '';

                                // if(string.valueof(cs.LastModifiedDate) != null){
                                //     claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                                //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                                // }
                                //Added code for GSSC-262

                                if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                    claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                    if(string.valueof(claimWrap.LastSaved) != null)
                                        claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                    claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                    if(string.valueof(claimWrap.lastSaved_sort) != null)
                                        claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                                }
                                if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                    claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                                //Added code for GSSC-262
                                /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                                //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                                //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                                // claimWrap.lastSavedBy = psn.LastModifiedBy.Name;
                                //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                                if(listWrap.size()<=500)//<=100
                                    listWrap.add(claimWrap);
                                system.debug('listWrap1--'+listWrap);


                            }

                        }
                    }
                    //
                    /* else if(searchValue!=null && searchValue.contains('CSS')){
system.debug('entered into CSSJOB');
for (CSS_PSN__c psn : listClaim){
if(cs.CSS_Claims__c == psn.CSS_Claims__c) {
String locStr;
ClaimsWrap claimWrap = new ClaimsWrap();
claimWrap.Id = cs.CSS_Claims__c;
//claimWrap.isPSNTriggered = isPSNTriggered;
if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
claimWrap.policyClaim = true;
else
claimWrap.policyClaim = false; 
claimWrap.claimSubmitted = string.valueof(cs.CreatedDate.format('dd MMM YYYY hh:mm a z'));
claimWrap.claimSubmisionRecordId=cs.Id;
claimWrap.claimID = cs.Individual_Claim_Id__c;
claimWrap.jobStatus = psn.CSS_Claims__r.CSS_Job__r.Status__c;
claimWrap.status = cs.Status__c;
claimWrap.paymentDetails = psn.CSS_Claims__r.Payment_Details__c;
claimWrap.customerName = psn.CSS_Claims__r.Customer_Name__c;
claimWrap.shopWO = psn.CSS_Claims__r.Shop_Work_Order__c;
claimWrap.prodSerialNum = psn.PSN__c;
if(psn.CSS_Claims__r.CSS_Job__r.Name != null && psn.CSS_Claims__r.CSS_Job__r.Name != '')
claimWrap.serviceJob = psn.CSS_Claims__r.CSS_Job__r.Name;
else if(psn.CSS_Claims__r.Dealer_Service_Job__r.Name != null && psn.CSS_Claims__r.Dealer_Service_Job__r.Name != '')
claimWrap.serviceJob = psn.CSS_Claims__r.Dealer_Service_Job__r.Name;
claimWrap.serviceJobId = psn.CSS_Claims__r.CSS_Job__c;
claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c;
claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
if(psn.CSS_Claims__r.Location_Code__c != '' && psn.CSS_Claims__r.Location_Code__c != null){
locStr = (psn.CSS_Claims__r.Location_Code__c).right(5);
} else{
locStr = '';    
}
if(locStr != null && psn.CSS_Claims__r.Location__c != null)
claimWrap.location = locStr+' '+psn.CSS_Claims__r.Location__c;
else if(psn.CSS_Claims__r.Location__c == null)
claimWrap.location = locStr;
else
claimWrap.location = '';

if(string.valueof(cs.LastModifiedDate) != null){
claimWrap.LastSaved = string.valueof(cs.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
}
claimWrap.lastSavedBy = psn.LastModifiedBy.Name;
if(listWrap.size()<=100)
listWrap.add(claimWrap);
system.debug('listWrap1--'+listWrap);


}

}

}*/
                    //
                }
                else{
                    for (CSS_PSN__c psn : listClaim){
                        if(cs.CSS_Claims__c == psn.CSS_Claims__c) {
                            String locStr;
                            ClaimsWrap claimWrap = new ClaimsWrap();
                            claimWrap.Id = cs.CSS_Claims__c;
                            //claimWrap.isPSNTriggered = isPSNTriggered;
                            if(PSN.CSS_Claims__r.PolicyClaim__c && Profile)
                                claimWrap.policyClaim = true;
                            else
                                claimWrap.policyClaim = false; 
                            if(cs.Credit_Date__c != null){ 
                                // DateTime DateformValue = cs.Credit_Date__c;
                                // claimWrap.claimSubmitted = DateformValue.format('dd MMM YYYY hh:mm a z');
                                claimWrap.claimSubmitted =dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('dd MMM YYYY hh:mm a z');
                                claimWrap.claimSubmitted_sort = dateTime.newInstance(cs.Credit_Date__c.year(),cs.Credit_Date__c.month(),cs.Credit_Date__c.day()).format('yyyy MM dd HH:mm a z'); //Added as part of story GSSC-154
                                if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                    claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                            }
                            else{
                                if(!cs.Status__c.containsIgnoreCase('Paid')){
                                    claimWrap.claimSubmitted = cs.CreatedDate.format('dd MMM YYYY hh:mm a z');
                                    claimWrap.claimSubmitted_sort = string.valueof(cs.CreatedDate.format('yyyy MM dd HH:mm a z')); //Added as part of story GSSC-154
                                    if(string.valueof(claimWrap.claimSubmitted_sort) != null)
                                        claimWrap.claimSubmitted_sort= claimWrap.claimSubmitted_sort.toUppercase();
                                }
                            }
                            claimWrap.claimSubmisionRecordId=cs.Id;
                            claimWrap.claimID = cs.Individual_Claim_Id__c;
                            claimWrap.jobStatus = psn.CSS_Claims__r.CSS_Job__r.Status__c;
                            claimWrap.MultiPSNFlag=PSN.CSS_Claims__r.Multi_PSN_Claim__c;
                            claimWrap.status = cs.Status__c;
                            claimWrap.paymentDetails = psn.CSS_Claims__r.Payment_Details__c;
                            claimWrap.customerName = psn.CSS_Claims__r.Customer_Name__c;
                            claimWrap.shopWO = psn.CSS_Claims__r.Shop_Work_Order__c;
                            claimWrap.prodSerialNum = psn.PSN__c;
                            if(psn.CSS_Claims__r.CSS_Job__r.Name != null && psn.CSS_Claims__r.CSS_Job__r.Name != ''){
                                claimWrap.serviceJob = psn.CSS_Claims__r.CSS_Job__r.Name;
                                claimWrap.serviceJobId = psn.CSS_Claims__r.CSS_Job__c;
                            }
                            else if(psn.CSS_Claims__r.Dealer_Service_Job__r.Name != null && psn.CSS_Claims__r.Dealer_Service_Job__r.Name != ''){
                                claimWrap.serviceJob = psn.CSS_Claims__r.Dealer_Service_Job__r.Name;
                                claimWrap.serviceJobId = psn.CSS_Claims__r.Dealer_Service_Job__c;
                            }
                            //claimWrap.serviceJobId = psn.CSS_Claims__r.CSS_Job__c;
                            claimWrap.warrClaimId = cs.Siebel_Claim_Number__c;
                            claimWrap.paymentRefNumber=cs.IMS_Claim_Number__c;
                            claimWrap.warrCopyClaimId = PSN.CSS_Claims__r.SiebelClaimNumber__c; 
                            claimWrap.SiebelPaymentReceived = cs.SiebelPaymentReceived__c;
                            if(claimStatus == 'Pending Response')
                                claimWrap.pendingResponseSP = cs.isPendingResponse__c; //GSSC-151
                            else
                                claimWrap.pendingResponseSP = false; //GSSC-151
                            if(psn.CSS_Claims__r.Location_Code__c != '' && psn.CSS_Claims__r.Location_Code__c != null){
                                locStr = (psn.CSS_Claims__r.Location_Code__c).right(5);
                            } else{
                                locStr = '';    
                            }
                            if(locStr != null && psn.CSS_Claims__r.Location__c != null)
                                claimWrap.location = locStr+' '+psn.CSS_Claims__r.Location__c;
                            else if(psn.CSS_Claims__r.Location__c == null)
                                claimWrap.location = locStr;
                            else
                                claimWrap.location = '';

                            // if(string.valueof(psn.LastModifiedDate) != null){
                            //     claimWrap.LastSaved = string.valueof(psn.LastModifiedDate.format('dd MMM YYYY hh:mm a z'));
                            //     claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                            // }
                            //Added code for GSSC-262

                            if(PSN.CSS_Claims__r.LastSavedDate__c !=null) {
                                claimWrap.LastSaved = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z'));
                                if(string.valueof(claimWrap.LastSaved) != null)
                                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();

                                claimWrap.lastSaved_sort = string.valueof(PSN.CSS_Claims__r.LastSavedDate__c.format('yyyy MM dd HH:mm a z'));
                                if(string.valueof(claimWrap.lastSaved_sort) != null)
                                    claimWrap.lastSaved_sort= claimWrap.lastSaved_sort.toUppercase();
                            }
                            if(PSN.CSS_Claims__r.Last_saved_by__c!='' && PSN.CSS_Claims__r.Last_saved_by__c!=null)
                                claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            //Added code for GSSC-262
                            /*
                if(claim.CSS_Claims__r.LastSavedDate__c !=null)
                claimWrap.LastSaved = string.valueof(claim.CSS_Claims__r.LastSavedDate__c.format('dd MMM YYYY hh:mm a z')); //kal1
                system.debug('**claim.CSS_Claims__r.LastSavedDate__c**'+claim.CSS_Claims__r.LastSavedDate__c);
                if(string.valueof(claimWrap.LastSaved) != null)
                    claimWrap.LastSaved= claimWrap.LastSaved.toUppercase();
                if(claim.CSS_Claims__r.Last_saved_by__c!='' && claim.CSS_Claims__r.Last_saved_by__c!=null)
                claimWrap.lastSavedBy = claim.CSS_Claims__r.Last_saved_by__c;*/
                            //if(PSN.CSS_Claims__r.Last_Saved__c!='' && PSN.CSS_Claims__r.Last_Saved__c!=null)
                            //claimWrap.LastSaved= PSN.CSS_Claims__r.Last_Saved__c.toUppercase();
                            // claimWrap.lastSavedBy = psn.LastModifiedBy.Name;
                            //claimWrap.lastSavedBy = PSN.CSS_Claims__r.Last_saved_by__c;
                            if(listWrap.size()<=500)//<=100
                                listWrap.add(claimWrap);
                            system.debug('listWrap1--'+listWrap);


                        }

                    }
                }


            }

        }           



        system.debug('listWrap2--'+listWrap);
        String sClaims = JSON.serialize(listWrap);
        system.debug('output--'+listWrap);
        //String sJobs = getlstServiceJob();
        string cnt = string.valueof(listWrap.size());
        system.debug('cnt --->>>>>'+cnt); 

        //  string PRcnt = string.valueOf(lstClaimSubPRCount.size());  // Anvesh Today
        //  system.debug(' Today PRcnt >> '+ PRcnt);

        return sClaims+'rccnt-'+cnt; 
    }
    @RemoteAction
    public static void onchangeAuthorize(string sid){
        system.debug('inside onchange method'+sid);
        try{
            CSS_Claims__c cs = new CSS_Claims__c();
            cs.id = sid;
            cs.Pending_Authorization__c = 'Authorized';
            cs.CaptureUserwhoapprovedAuthorized__c = UserInfo.getFirstName() +' '+UserInfo.getLastName();
            cs.AuthorizationTimeStamp__c = SYSTEM.NOW();
            update cs;
            system.debug('update'+cs);
        }
        catch(exception err){
            system.debug('In catch block of onchangeAuthorize with the error '+err.getMessage() +' and in the line '+err.getLineNumber());
        }


    }
    public static string rejClaimId;
    public Static String body;

    public static boolean PSNTriggered() {
        boolean isTriggered = false;
        list<CSS_PSN__c> PSNList = [Select Id from CSS_PSN__c where isNonValidated__c =: true];
        if(PSNList != null && PSNList.size() >0)
            isTriggered = true;
        return isTriggered;
    }

    @RemoteAction
    public static string onChangeReject(string claId){

        system.debug('inside onChangeReject method'+claId);
        rejClaimId = claId;
        system.debug('Reject --Id-->'+rejClaimId);
        /*S_Claims__c cs = new CSS_Claims__c();
cs.Id =claId;
cs.Rejection_Comments__c = body;
update cs;*/
        system.debug('inside onChangeReject method'+rejClaimId);
        return claId;
    }


    @RemoteAction
    public static void saveRejectCom(string ClaimRecId,string Notesbody){
        system.debug('enter rejection');
        system.debug('Claims ID-->'+ClaimRecId);
        system.debug('Note Body'+Notesbody);
        CSS_Claims__c cs = new CSS_Claims__c();
        cs.Id = ClaimRecId;
        cs.Rejection_Comments__c = NotesBody;
        cs.Pending_Authorization__c = 'Not Authorized';
        cs.Status__c = 'Not Authorized';

        cs.Rejection_Timestamp__c = SYSTEM.NOW();
        cs.RejectedByUser__c = UserInfo.getFirstName() +' '+UserInfo.getLastName();
        update cs;
        system.debug('cs' + ' '  +cs );
    } 
    @RemoteAction
    public static string copysiebelclaims(string warrantynum, string claimsid)
    {
        string clmid;
        try{

            CSS_GetClaimDetailsResponse reswrapper = css_fn_siebel.CallGetClaimDetails(warrantynum);  
            //  CSS_GetClaimDetailsResponse reswrapper = css_fn_siebel.CallGetClaimDetails('13444808');  
            if(reswrapper!=null && reswrapper.Header!=null && reswrapper.Header.Status=='Success')
            {
                //resheader = reswrapper.Header;

                system.debug('reswrapper>>>'+reswrapper);
                //getting the complaintcodelist
                string sh ;
                CSS_JobEventTemporary__c[] Categories;
                CSS_WPR_SBL_CatComplaintsListResJSON  resCatCompJSON;

                Categories = [select Reason__c from CSS_JobEventTemporary__c where attribute1__c = 'CategoryComplaintCodes'];
                system.debug('Categories>>>'+Categories);

                string jsonResponse = Categories[0].Reason__c;

                CSS_Claims__c claimsRec = new CSS_Claims__c();
                claimsRec = [SELECT Id, Name,Location_Code__c, Location__c, Account__c FROM CSS_Claims__c WHERE Id =: Id.valueOf(claimsid)];

                resCatCompJSON = (CSS_WPR_SBL_CatComplaintsListResJSON )JSON.deserialize(jsonResponse ,CSS_WPR_SBL_CatComplaintsListResJSON .class);
                system.debug('resCatCompJSON>>>'+resCatCompJSON);
                set<string> dealerCodeSet = new set<string>();
                if(reswrapper.DataArea!=null && resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null)
                {
                    for(CSS_GetClaimDetailsResponse.DataArea d:reswrapper.DataArea)
                    {
                        dealerCodeSet.add(d.ServiceProviderCode);
                    }

                }

                list<account> accountlist = [select id, Name,  location__c, IAM_Service_Provider_Code__c from account where IAM_Service_Provider_Code__c=:dealerCodeSet];
                system.debug('accountlist ' + accountlist);

                map<string, account> dealerAcountlocationMap = new map<string, account>();
                for(account acc : accountlist)
                    dealerAcountlocationMap.put(acc.IAM_Service_Provider_Code__c, acc);


                if(reswrapper.DataArea!=null && resCatCompJSON  != null && resCatCompJSON.DataArea != null && resCatCompJSON.DataArea.Details != null)
                {
                    for(CSS_GetClaimDetailsResponse.DataArea d:reswrapper.DataArea)
                    {
                        system.debug('dataarea starts>>>');
                        CSS_Claims__c newclaim = new CSS_Claims__c();
                        string complaintdesc ='';

                        newclaim.IsCopyclaim__c = true;

                        newclaim.Copied_from_Claim__c = claimsRec.Name;

                        newclaim.Status__c='draft';

                        if(claimsRec != null) {
                            newclaim.Location_Code__c = claimsRec.Location_Code__c;
                            newclaim.Location__c = claimsRec.Location__c;
                            newclaim.Account__c = claimsRec.Account__c;
                        } else if(dealerAcountlocationMap != null && dealerAcountlocationMap.size() >0) {
                            Account acc = dealerAcountlocationMap.get(d.ServiceProviderCode);
                            newclaim.Location_Code__c = acc.location__c;
                            newclaim.Location__c = acc.Name;
                            newclaim.Account__c = acc.Id;    
                        }


                        // if(d.DistributorCode!=null && d.ServiceProviderCode!=null)
                        //newclaim.Location_Code__c   = d.DistributorCode +'-'+d.ServiceProviderCode;

                        if(d.psn!=null && string.isNotBlank(d.psn))
                            newclaim.ESN__c  =d.psn;

                        if(d.WorkOrderNumber!=null && string.isNotBlank(d.WorkOrderNumber))
                            newclaim.Shop_Work_Order__c  =d.WorkOrderNumber;

                        if(d.CustomerName!=null && string.isNotBlank(d.CustomerName))
                            newclaim.Customer_Name__c =d.CustomerName;

                        if(d.ComplaintCodes!=null)
                        {

                            if(d.complaintcodes.size()<6)
                            {
                                integer m=0;
                                if(d.complaintcodes.size()>0)
                                {
                                    m= d.complaintcodes.size()-1;
                                }
                                for( integer i=0;i<d.ComplaintCodes.size();i++)
                                {
                                    if(i==0)
                                    {
                                        //Fetching complain Category value
                                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                                            if(det.ComplaintCode == d.ComplaintCodes[i].ComplaintCode){
                                                newclaim.Claims_Category_Desc__c = det.Category;
                                                newclaim.Complaint_Type_Desc__c = det.Description;
                                                system.debug('Claims_Category_Desc__c>>>'+newclaim.Claims_Category_Desc__c);
                                                break;
                                            }
                                        }
                                        //Populating the default value to category 
                                        if( newclaim.Claims_Category_Desc__c==null)
                                            newclaim.Claims_Category_Desc__c='none';


                                        complaintdesc += d.ComplaintCodes[i].ComplaintText;
                                        complaintdesc +='.';
                                        system.debug('Complaint_Type_Desc__c>>>'+newclaim.Complaint_Type_Desc__c);
                                        system.debug('complaintdesc>>>'+complaintdesc);

                                        if(i==m)
                                            break;
                                    }
                                    else if(i==1)
                                    {
                                        //Fetching complain Category value
                                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                                            if(det.ComplaintCode == d.ComplaintCodes[i].ComplaintCode){
                                                newclaim.Claims_Category2_Desc__c = det.Category;
                                                newclaim.Complaint_Type2_Desc__c = det.Description;
                                                system.debug('Claims_Category2_Desc__c>>>'+newclaim.Claims_Category2_Desc__c);
                                                break;
                                            }
                                        }
                                        //Populating the default value to category 
                                        if( newclaim.Claims_Category2_Desc__c==null)
                                            newclaim.Claims_Category2_Desc__c='none';


                                        complaintdesc += d.ComplaintCodes[i].ComplaintText;
                                        complaintdesc +='.';
                                        system.debug('Complaint_Type2_Desc__c>>>'+newclaim.Complaint_Type2_Desc__c);
                                        system.debug('complaintdesc>>>'+complaintdesc);
                                        if(i==m)
                                            break;
                                    }

                                    else if(i==2)
                                    {
                                        //Fetching complain Category value
                                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                                            if(det.ComplaintCode == d.ComplaintCodes[i].ComplaintCode){
                                                newclaim.Claims_Category3_Desc__c = det.Category;
                                                newclaim.Complaint_Type3_Desc__c = det.Description;
                                                system.debug('Claims_Category3_Desc__c>>>'+newclaim.Claims_Category3_Desc__c);
                                                break;
                                            }
                                        }
                                        //Populating the default value to category 
                                        if( newclaim.Claims_Category3_Desc__c==null)
                                            newclaim.Claims_Category3_Desc__c='none';


                                        complaintdesc += d.ComplaintCodes[i].ComplaintText;
                                        complaintdesc +='.';
                                        system.debug('Complaint_Type3_Desc__c>>>'+newclaim.Complaint_Type3_Desc__c);
                                        system.debug('complaintdesc>>>'+complaintdesc);

                                        if(i==m)
                                            break;
                                    }
                                    else if(i==3)
                                    {
                                        //Fetching complain Category value
                                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                                            if(det.ComplaintCode == d.ComplaintCodes[i].ComplaintCode){
                                                newclaim.Claims_Category4_Desc__c = det.Category;
                                                newclaim.Complaint_Type4_Desc__c = det.Description;
                                                system.debug('Claims_Category4_Desc__c>>>'+ newclaim.Claims_Category4_Desc__c);
                                                break;
                                            }
                                        }
                                        //Populating the default value to category 
                                        if( newclaim.Claims_Category4_Desc__c==null)
                                            newclaim.Claims_Category4_Desc__c='none';


                                        complaintdesc += d.ComplaintCodes[i].ComplaintText;
                                        complaintdesc +='.';
                                        system.debug('Claims_Category4_Desc__c>>>'+newclaim.Claims_Category4_Desc__c);
                                        system.debug('complaintdesc>>>'+complaintdesc);
                                        if(i==m)
                                            break;
                                    }
                                    else if(i==4)
                                    {
                                        //Fetching complain Category value
                                        for(CSS_WPR_SBL_CatComplaintsListResJSON.Details det : resCatCompJSON.DataArea.Details ){
                                            if(det.ComplaintCode == d.ComplaintCodes[i].ComplaintCode){
                                                newclaim.Claims_Category5_Desc__c = det.Category;
                                                newclaim.Complaint_Type5_Desc__c = det.Description;
                                                system.debug('Claims_Category5_Desc__c>>>'+newclaim.Claims_Category5_Desc__c);
                                                break;
                                            }
                                        }
                                        //Populating the default value to category 
                                        if( newclaim.Claims_Category5_Desc__c==null)
                                            newclaim.Claims_Category5_Desc__c='none';


                                        complaintdesc += d.ComplaintCodes[i].ComplaintText;
                                        complaintdesc +='.';
                                        system.debug('Complaint_Type5_Desc__c>>>'+newclaim.Complaint_Type5_Desc__c);
                                        system.debug('complaintdesc>>>'+complaintdesc); 
                                        if(i==m)
                                            break;
                                    }

                                }

                                if(!string.isBlank(complaintdesc))
                                    newclaim.Claims_General_Symptoms__c=complaintdesc;
                                system.debug('Claims_General_Symptoms__c>>>'+ newclaim.Claims_General_Symptoms__c); 

                            }

                        }

                        //Application codes.#190012
                        CSS_WPR_SBL_ApplicationResJSON resJSON;
                        resJSON = CG_BL_Intake.getApplicationCodesWrapper();

                        map<string,string> lstApplications = new map<string,string>();
                        if(resJSON  != null && resJSON.DataArea != null && resJSON.DataArea.Details != null ){
                            for(CSS_WPR_SBL_ApplicationResJSON.Details det : resJSON.DataArea.Details ){
                                if(det.ActiveFlag == 'Y'){
                                    //lstApplications.add(new SelectOption(det.Description,det.ApplicationCode+' - '+det.Description));
                                    lstApplications.put(det.ApplicationCode, det.Description);
                                }
                            }
                        }
                        //Application codes.#190012

                        if(newclaim!=null)
                        {
                            system.debug('insert starts>>>'+newclaim);

                            insert newclaim;

                            system.debug('insert ends>>>');

                            clmid = string.valueOf(newclaim.id);

                            CSS_PSN__c psn1 = new CSS_PSN__c();
                            list<CSS_PSN__c> psnList = new list<CSS_PSN__c>();

                            psn1.css_claims__c=newclaim.id;

                            psn1.Primary__c=true;//Added primary field to avoid argument null exception during BISvalidation in Intake page.

                            if(d.psn!=null && string.isNotBlank(d.psn) && d.psn.length()==8)
                                psn1.PSN__c   = d.psn;

                            if(d.Manufacturer!=null && string.isNotBlank(d.Manufacturer))
                                psn1.Make__c   = d.Manufacturer;

                            if(d.ModelSeries!=null && string.isNotBlank(d.ModelSeries))
                                psn1.Model__c   = d.ModelSeries;

                            if(d.BISFlag!=null)
                                psn1.Before_In_Service__c   =Boolean.valueOf(d.BISFlag);

                            if(d.FailureDate!=null)
                                psn1.Failure_Date__c   = Date.parse(d.FailureDate);

                            if(d.FailurePoint!=null)
                                psn1.Failure_Point__c   = string.valueOf(d.FailurePoint);

                            if(d.FailureMeasure!=null)
                                psn1.Mileage_Measure__c   = string.valueOf(d.FailureMeasure);

                            if(d.WarrantyStartDate!=null){
                                // psn1.Warranty_Start_Date__c = Date.valueOf(d.WarrantyStartDate);
                                String[] myDateOnly = d.WarrantyStartDate.split(' ');
                                String[] strDate = myDateOnly[0].split('/');
                                Integer myIntDate = integer.valueOf(strDate[1]);
                                Integer myIntMonth = integer.valueOf(strDate[0]);
                                Integer myIntYear = integer.valueOf(strDate[2]);
                                psn1.Warranty_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate); 

                            }

                            if(d.EngineApplicationCode!=null && string.isNotBlank(d.EngineApplicationCode)) {
                                psn1.ApplicationCode__c = d.EngineApplicationCode;
                                //#190012
                                if(lstApplications != null && lstApplications.size() > 0)
                                    psn1.Application__c = lstApplications.get(d.EngineApplicationCode);
                                //#190012
                            }

                            psnList.add(psn1);

                            list<CSS_GetClaimDetailsResponse.AdditionalESNs> AdditionalESNList = new list<CSS_GetClaimDetailsResponse.AdditionalESNs>();
                            system.debug('d.AdditionalESNs' + d.AdditionalESNs);
                            if(d.AdditionalESNs != null) {
                                AdditionalESNList = d.AdditionalESNs;
                                for(CSS_GetClaimDetailsResponse.AdditionalESNs AddESN: AdditionalESNList) {
                                    CSS_PSN__c psnM = new CSS_PSN__c();
                                    psnM.css_claims__c=newclaim.id;
                                    psnM.Primary__c=false;
                                    psnM.PSN__c   = AddESN.psn;

                                    if(AddESN.BISFlag != null)
                                        psnM.Before_In_Service__c = Boolean.valueOf(AddESN.BISFlag);
                                    if(AddESN.FailurePoint != null)    
                                        psnM.Failure_Point__c   = string.valueOf(AddESN.FailurePoint);
                                    if(AddESN.FailureMeasure!=null)
                                        psnM.Mileage_Measure__c   = string.valueOf(d.FailureMeasure);

                                    if(AddESN.WarrantyStartDate != null){
                                        String[] myDateOnly = AddESN.WarrantyStartDate.split(' ');
                                        String[] strDate = myDateOnly[0].split('/');
                                        Integer myIntDate = integer.valueOf(strDate[1]);
                                        Integer myIntMonth = integer.valueOf(strDate[0]);
                                        Integer myIntYear = integer.valueOf(strDate[2]);
                                        psnM.Warranty_Start_Date__c = Date.newInstance(myIntYear, myIntMonth, myIntDate); 
                                    }
                                    psnM.isNonValidated__c = true;
                                    psnList.add(psnM);
                                }
                            }
                            //Inserting Primary PSN and Non Primary PSN's
                            system.debug('psnList BEFORE>>>'+psnList);
                            if(psnList !=null && psnList.size() >0)
                                insert psnList;
                            system.debug('psnList starts>>>'+psnList);

                            string primaryPSNId;
                            //Take the list of NonPrimary PSN's respective to Claims. 
                            list<CSS_PSN__c> psnNonPrimaryList = new list<CSS_PSN__c>();
                            if(psnList != null && psnList.size() >1) {
                                for(CSS_PSN__c psnNP : psnList) {
                                    if(!psnNP.Primary__c)
                                        psnNonPrimaryList.add(psnNP);
                                    if(psnNP.Primary__c)    
                                        primaryPSNId = psnNP.Id;

                                }
                            }

                            //Async Call for PSN 3 Services.
                            PSNWebserviceTrigger(psnNonPrimaryList, primaryPSNId);   

                            //Insert Failures.
                            /*list<CSS_Solution_Component__c> solList = new list<CSS_Solution_Component__c>();
list<CSS_GetClaimDetailsResponse.FailureList> SiebelFailureList = new list<CSS_GetClaimDetailsResponse.FailureList>();
SiebelFailureList = d.FailureList;
for(CSS_GetClaimDetailsResponse.FailureList Failure: SiebelFailureList) {
CSS_Solution_Component__c sol = new CSS_Solution_Component__c();
sol.Fault_Code__c = Failure.FaultCode;
sol.System_Code__c = Failure.SystemCode;
sol.Component_Code__c = Failure.ComponentCode;
sol.Failure_Mode__c = Failure.FailMode;
sol.Name = Failure.Failurename;
sol.CertificateNumber__c = Failure.CampaignNumber;
sol.AccountCode__c = Failure.AccountCode;
sol.Pay_Code__c = Failure.PayCode;
solList.add(sol);
}

if(solList != null && solList.size() >0)
insert solList;
*/    
                        }
                    }
                }

            }
        } catch(exception e) {
            system.debug('siebel claims copy exception message'+e.getMessage());
        }
        system.debug('ends>>>');
        return clmid;
    }

    @RemoteAction
    public static string copyclaimsGuidz(string claimsid,string warrantyid,string serjobid)
    {
        string clmid;
        CSS_PSN__c psnrec1;
        AutomaticCopyClaim = false;
        list<CSS_PSN__c> psnList = new list<CSS_PSN__c>();
        system.debug('!!Guidanz copy method is invoking starts here....>>>');
        CSS_Claims__c claimsRec =[Select Id,
                                  CSS_Travel_Rate__c,ReconEngineFlag__c,CSS_Channel_Of_Distribution__c,CSS_Job__r.CreatedDate,Account__r.ERP_System__c,CSS_Job__r.Date_in_Shop__c,CSS_Job__r.Date_in__c,CSS_Job__r.Repeat_Or_Recent_Calc__c,CSS_Job__r.RecentVisit__c,CreatedDate,LastModifiedDate,Name,Address__c,Authorization_Comments__c,Catastrophic__c,Contact_First_Name__c,Contact_Id__c,
                                  Contact_Last_Name__c,ProductApplicationCode__c,Account__c,Country__c,Customer_Code__c,Customer_Contact_Phone__c,Customer_Name__c,Actual_Technician_Time__c,Actual_Time_for_Diagnostics__c,Actual_Time_for_Repair__c,Customer_Phone__c,
                                  TSR1__c, TSR2__c, Automotive_App_Flag__c,TSR3__c,Dealer_Service_Job__c, TSR4__c, TSR5__c, TSR6__c, TSR7__c, TSR8__c, TSR9__c, TSR10__c,RejectedByUser__c,Rejection_Timestamp__c,Rejection_Comments__c,Claims_city__c, CSS_Channel_Code__c, 
                                  Distributor_Authorization_FN__c,Multi_PSN_Claim__c,CSS_Job__r.Status__c,Information_Only_Claim__c,Distributor_Authorization_LN__c,Distributor_Authorization_WWID__c,
                                  Email_Address__c,ESN__c,Account__r.RSS_RESP_BRANCH_CODE__c,SP_Country__c,Location__c,SP_PrimaryOEMCode__c,Location_Code__c,PACCAR_Authorization_FN__c,PACCAR_Authorization_LN__c,DesignPhaseCode__c , EngineFamilyCode__c, ShipDate__c, ETOOldESN__c, EngineFamilyName__c,EtoConversionDate__c, MarineFlag__c, OemCode__c, ProductApplicationDesp__c, warrantyIndicatorFlag__c,
                                  PACCAR_Authorization_WWID__c,Repair_Completion__c,Repair_Location__c,Service_Date__c,Service_Model__c,Mutual_Exclusive_Message__c,SRT_Olap_Reason_Msg__c,SRT_902_Error_Message__c,DupAccessCodePercentReqMsg__c,Overlap_Service_Failure_Msg__c,isCalibrationFieldsBlank__c,
                                  State__c,Status__c,ZipCode__c,isAutomatedCopyClaim__c,css_job__c,CSS_Job__r.Name,CSS_Job__r.LastUpdateSubStatus__c, BillToCode__c ,BuildDate__c ,
                                  SP_CHANNEL_OF_DISTRIBUTION__c,PolicyClaim__c,SP_WarrantyCertificationEndDate__c,SP_CLAIM_ALLOWED_DAYS__c,SP_CMI_SP_EXPIRATION__c,SP_LTA_FLAG__c,SP_OUTFILE_ALL_CLAIMS__c,Pending_Authorization__c,
                                  SP_PACCAR__c,SP_REGION__c,SP_SCMDollarAmt__c,SP_WarrantyTrainingStatus__c,SP_State__c,SP_SCMDeductiblePercentage__c,bmsCreateAccount__c,
                                  SP_ACCOUNT_STATUS__c,SP_TERRITORY_CODE__c,SP_Group_Name__c,SP_TERRITORY__c,SP_REGIONCODE__c,Territory_Class__c,Territory_Class_Name__c,SP_PromotionId__c, ODM_Status__c , account__r.name,account__r.IAM_Service_Provider_Code__c,
                                  CSS_Job__r.General_Symptoms__c,CSS_Job__r.Preventive_Maintenance__c,CSS_Job__r.Expedited_Service__c,CSS_Job__r.Category__c,CSS_Job__r.Category2__c,CSS_Job__r.Category3__c,CSS_Job__r.Category4__c,CSS_Job__r.Category5__c,CSS_Job__r.Category_Desc__c,CSS_Job__r.Category2_Desc__c,CSS_Job__r.Category3_Desc__c,CSS_Job__r.Category4_Desc__c,CSS_Job__r.Category5_Desc__c,CSS_Job__r.Complaint_Type__c,CSS_Job__r.Complaint_Type2__c,CSS_Job__r.Complaint_Type3__c,CSS_Job__r.Complaint_Type4__c,CSS_Job__r.Complaint_Type5__c,CSS_Job__r.Complaint_Type_Desc__c,CSS_Job__r.Complaint_Type2_Desc__c,CSS_Job__r.Complaint_Type3_Desc__c,CSS_Job__r.Complaint_Type4_Desc__c,CSS_Job__r.Complaint_Type5_Desc__c,Shop_Work_Order__c, Region__c,Territory__c,CoverageResponse__c,Claims_Additional_Comments__c,Claims_Category__c,Claims_Category_Desc__c,Claims_Category2__c,Claims_Category2_Desc__c,Claims_Category3__c,Claims_Category3_Desc__c,Claims_Category4__c,Claims_Category4_Desc__c,Claims_Category5__c,Claims_Category5_Desc__c,Claims_Complaint_Type__c,Claims_Complaint_Type2__c,Claims_Complaint_Type3__c,Claims_Complaint_Type4__c,Claims_Complaint_Type5__c,Claims_Expedited_Service__c,Claims_General_Symptoms__c,Claims_Preventive_Maintenance__c,Complaint_Type_Desc__c,Complaint_Type2_Desc__c,Complaint_Type3_Desc__c,Complaint_Type4_Desc__c,Complaint_Type5_Desc__c,
                                  (Select Id,Name,PSN__c,Location_Certification__c,Warranty_Authorization_Flag__c,Application__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
                                   Make__c,Mileage__c,CoverageFlag__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Qsol_Technical_Config__c,
                                   Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c,ProductAppcodeErrorflag__c from CSS_PSNs__r where Primary__c=true Limit 1) 
                                  from CSS_Claims__c where id=:claimsid];

        if(claimsRec!=null)
        {


            /*if(claimsRec[0].Multi_PSN_Claim__c==true)
            {
                copyclaimhide=true;
            }*/
            if(claimsRec.CSS_Job__c!=null || claimsRec.Dealer_Service_Job__c!=null)
                AutomaticCopyClaim = true;
            CSS_Claims__c newClaim = claimsRec.clone(false,true,false,false);
            newClaim.CSS_Job__c = null; // Story GSSC- 513
            newClaim.Dealer_Service_Job__c = null; // Story GSSC- 513
            if(AutomaticCopyClaim == true)
                newClaim.isAutomatedCopyClaim__c = true;
            else{
                newClaim.isAutomatedCopyClaim__c = false;  
            }
            /* CSS_Claims__c newClaim = claimsRec.clone(false,true,false,false);
            newclaim.IsCopyclaim__c = true;
            newclaim.Copied_from_Claim__c = claimsRec.Name;
            newclaim.Status__c ='draft';
            insert newClaim;*/
            // system.debug('New claim'+newClaim.id);
            // clmid = string.valueOf(newClaim.id);
            CSS_PSN__c[] psnrec =[Select Id,Name,PSN__c,Location_Certification__c,Warranty_Authorization_Flag__c,Application__c,Before_In_Service__c,Calibration_After__c,Calibration_Before__c,Revision_After__c,Revision_Before__c,Failure_Date__c,Justification__c,License_Plate_State__c,
                                  Make__c,Mileage__c,CoverageFlag__c,Mileage_Measure__c,Mission_Disabling__c,Model__c,Primary__c,Product_Hours__c,Qsol_Engine_Family_Code__c,Equipment_ID__c,Qsol_Technical_Config__c, isNonValidated__c,
                                  Qsol_Warranty_Start__c,Service_Model__c,Unit_Number__c,Unit_Type__c,VIN__c,Warranty_Start_Date__c,CSS_Claims__c,ProductAppcodeErrorflag__c, CSS_Claims__r.PolicyClaim__c 
                                  from CSS_PSN__c 
                                  where CSS_Claims__c=:claimsid 
                                  //and Primary__c=true 
                                  //Limit 1
                                 ];

            String failureDateStr = DateTime.newInstance(psnrec[0].Failure_Date__c.year(),psnrec[0].Failure_Date__c.month(),psnrec[0].Failure_Date__c.day()).format('dd-MMM-YY');
            String selectedLocation;
            selectedLocation = claimsRec.Location_Code__c;
            String spCode = selectedLocation.trim().right(5); //take last 5 digits here
            system.debug('first spCode>:'+spCode);
            spCode = spCode.trim();
            System.debug('failureDateStr>>>:'+failureDateStr+' spCode>>:'+spCode);
            system.debug('ClaimsRec.Name>:'+ClaimsRec.Name);
            CSS_GetServiceProviderResponse outputRes = CSS_FN_SIEBEL.getServiceProviderDataWrapper(spCode.trim(), '', failureDateStr,ClaimsRec.Name);
            if(outputRes!=null){
                newClaim.SP_INSHOP_LABOR_RATE__c = outputRes.DataArea.InShopLaborRate;
            }
            // system.debug('outputRes.DataArea.InShopLaborRate:'+outputRes.DataArea.InShopLaborRate);

            newclaim.IsCopyclaim__c = true;
            newclaim.Copied_from_Claim__c = claimsRec.Name;
            newclaim.Status__c ='draft';
            insert newClaim;
            clmid = string.valueOf(newClaim.id);
            system.debug('update:'+newClaim);
            if(psnrec != null && psnrec.size() >0) {
                for(CSS_PSN__c psn : psnrec) {
                    CSS_PSN__c psnNew = psn.clone();
                    psnNew.CSS_Claims__c = newClaim.id;
                    if(!psnNew.Primary__c)
                        psnNew.isNonValidated__c = true;
                    psnList.add(psnNew);
                }
            }

            //Inserting Primary PSN and Non Primary PSN's
            if(psnList != null && psnList.size() >0)
                insert psnList;
            system.debug('New claim'+newClaim.id);

            string primaryPSNId;
            //Take the list of NonPrimary PSN's respective to Claims. 
            list<CSS_PSN__c> psnNonPrimaryList = new list<CSS_PSN__c>();
            system.debug('snehapsnlist'+psnList);
            system.debug('snehapsnlist1'+psnList.size());
            if(psnList != null && psnList.size() >1) {
                for(CSS_PSN__c psnNP : psnList) {
                    if(!psnNP.Primary__c)
                        psnNonPrimaryList.add(psnNP);
                    if(psnNP.Primary__c)    
                        primaryPSNId = psnNP.Id;
                }
            }

            PSNWebserviceTrigger(psnNonPrimaryList, primaryPSNId);
             //Insert Child Records.
            //Insert Failures.
            /*List<Css_solution_Component__c> solCompCloneList = new List<Css_solution_Component__c>();
List<Css_solution_Component__c> solCompList = [select Name,AccountCode__c,AccountCode_Call_Status__c,AccountCodeEdit__c,AccountCodeType__c,Action__c,Approval_Code__c,Selected_Claim_Type__c,Claim_Type__c,Fault_Code__c,
Authorization_Number__c,Business_Unit__c,Campaign_Description__c,Campaign_End_Date__c,CampaignLaborPercentage__c,CampaignOCPercentage__c,CampaignPartsPercentage__c,
Campaign_Start_Date__c,CampaignTowingPercentage__c,CampaignTravelPercentage__c,CertificateNumber__c,Charlength__c,Complete_Indicator__c,Component_Code__c,Component_Id__c,
CoveredLaborHrs__c,CoveredMealsLodgingAmt__c,CoveredOCAmount__c,CoveredPartsQty__c,CoveredPartsQty_Percentage__c,CoveredTowingMiles__c,CoveredTravelBaseFareAmt__c,
CoveredTravelLabor__c,CoveredTravelMiles__c,CSS_Account_Formula__c,CSS_CoverageType__c,Solutions__c,DeductibleAmount__c,Customer_Take_Possession__c,Engine_Family_Code__c,
Equip_ID__c,Fail_Code__c,Fail_Code_Editable__c,FailCode_Formula__c,Failure_Date__c,Failure_Measure__c,Failure_Mode__c,Failure_Point__c,In_Shop_SRT_Limit_Flag__c,
Multiple_Times__c,Notes__c,Parts_Warranty__c,RoadRelay_Warranty__c,Part_Warranty_Start_Date__c,Pay_Code__c,Performed__c,Performed_Review__c,Quantity__c,Reviewed__c,Selected_Component__c,
Service_Model__c,FailMode_Desc__c,ComponentCode_Desc__c,SystemCode_Desc__c,SRT_Fetched__c,SRT_Total__c,Status__c,System_Code__c,Type__c,Unique_Component__c,URL__c,
WarrantyId__c,Claims_Failure_Select__c,ODM_Status__c,ODM_Status_Message__c
from CSS_Solution_Component__c 
where  CSS_Claims__c = : claimsid];

if(solCompList != null && solCompList.size() >0) {
for(Css_solution_Component__c solcomp : solCompList) {
Css_solution_Component__c solcompClone = solcomp.clone();
solcompClone.CSS_Claims__c = newClaim.id;
solCompCloneList.add(solcompClone);
}
}

if(solCompCloneList != null && solCompCloneList.size() >0)
insert solCompCloneList;
*/   
            
        }

        return clmid;
    }

    public static void PSNWebserviceTrigger(list<CSS_PSN__c> psnNonPrimaryList, string primaryPSNId) {
        //Async Call for PSN 3 Services.
        if(psnNonPrimaryList != null && psnNonPrimaryList.size() >0) {
            Integer num=0;
            List<Id> psnIds = new List<Id>();
            for(CSS_PSN__c PSN : psnNonPrimaryList) {
                num++;
                if(num==3){
                    String temp = JSON.serialize(psnIds);
                    PSN3Validations(temp, primaryPSNId);
                    psnIds = new List<Id>();
                    num=0;
                }
                psnIds.add(PSN.Id);
            }

            if(num<10){
                String temp = JSON.serialize(psnIds);
                PSN3Validations(temp, primaryPSNId);
                psnIds = new List<Id>();
                num=0;
            }
        }
    }


    @Future(callout=true)
    public static void PSN3Validations(string selectedPSNId, string PrimaryPSNId) {

        CSS_PSN__c psnRec = [SELECT Id, Service_Model__c FROM CSS_PSN__c where Id =: PrimaryPSNId LIMIT 1];
        List<Id> NonPrimaryPSN = new List<Id>();
        NonPrimaryPSN = (List<Id>)JSON.deserializeStrict(selectedPSNId,List<Id>.class); 
        CSS_PSN__c[] NonPpsnList = [SELECT Id, isNonValidated__c, PSN__c, Validation_Message__c FROM CSS_PSN__c where Id IN : NonPrimaryPSN];
        for(CSS_PSN__c PSN : NonPpsnList) {
            PSN.Validation_Message__c = '';
            //a.GetEngineData – To validate the PSN. 
            //Step: GetEnginaData WS execution
            CSS_getEngineDataReqJ2A wrapobj = new CSS_getEngineDataReqJ2A();
            CSS_getEngineDataReqJ2A.DataArea jidi = new CSS_getEngineDataReqJ2A.DataArea();
            jidi.ESN = PSN.PSN__c;
            System.debug('engineData+jidi'+jidi);
            wrapobj.DataArea = jidi;
            CSS_getEngineDataResponseJ2A engineData = CSS_WS_SBL.getEngineData(wrapobj); 

            //Validation Errors.
            System.debug('after getEngineData...');
            if(engineData == null){
                PSN.Validation_Message__c = Label.CG_Web_Service_failure_Please_try_again_later;
                System.debug('in engine data failure...---> '+ PSN.Validation_Message__c);
            }

            if(psnRec.Service_Model__c.touppercase() != engineData.DataArea.ServiceModelName.touppercase()){
                PSN.Validation_Message__c = Label.CG_Service_Model_must_be_same_as_primary_PSN;
                System.debug('before returning from SMN...errorMsg: ---> '+PSN.Validation_Message__c);
            }

            if(engineData.DataArea.WarrantyStartDate !=null && engineData.DataArea.WarrantyStartDate.trim() !='' 
               && engineData.DataArea.BuildDate !=null && engineData.DataArea.BuildDate.trim() !=''){ 
                Date wsd = css_utility.formatedDateOfSiebelDate(engineData.DataArea.WarrantyStartDate);
                Date bDate = css_utility.formatedDateOfSiebelDate(engineData.DataArea.BuildDate);
                System.debug('wsd>>>:'+wsd);
                System.debug('bDate>>:'+bDate);
                if(wsd !=null && bDate !=null && bDate>wsd ){
                    PSN.Validation_Message__c = Label.CG_Warranty_Start_Date_must_be_later_than_Engine_Build_Date;
                    System.debug('before CG_Warranty_Start_Date_...errorMsg: ---> '+PSN.Validation_Message__c);
                }
            }
            if(engineData.DataArea.PACCARFlag == 'Y'){
                PSN.Validation_Message__c = Label.CG_PACCAR_Multi_PSN_Flag_Error;
                System.debug('before returning PACCAR FLAG...errorMsg: ---> '+PSN.Validation_Message__c);
            }

            //b.GetCampaignData – To validate PSN’s coverage on the field action. 
            //c.GetDetailCoverage – To validate PSN’s coverage on the failure. 
            PSN.isNonValidated__c = false;
        }
        system.debug('NonPpsnList BEFORE>>>'+NonPpsnList);
        update NonPpsnList;

    }

    /*Wrapper class to store the Claims Info */
    public class ClaimsWrap {

        //varibale for showing Bold
        public String claimSubmitted;
        public String claimSubmitted_sort; //Added as part of story GSSC-154
        public String Id;
        public String claimID;
        public String status;
        public String paymentDetails;
        public String customerName;
        public String shopWO;

        public String prodSerialNum;
        public String serviceJob;

        public String location;
        public String lastSaved;
        public String lastSaved_sort;   //GSSC:262 Krishna
        public String lastSavedBy;
        public string cvin;
        public String jobStatus;
        public string serviceJobId;  
        public string warrClaimId;
        public string paymentRefNumber;
        public string warrCopyClaimId;
        public string claimSubmisionRecordId; 
        public boolean SiebelPaymentReceived;
        public boolean policyClaim;
        public boolean cataClaim;//Rupesh 167793
        public boolean MultiPSNFlag;
        public Boolean PendingResponseSP;
        //public boolean isPSNTriggered;
        /*Wrapper class Constructor to initialize the value to members */
        ClaimsWrap () {
            //claimSubmitted = '';
            claimSubmitted_sort = ''; ////Added as part of story GSSC-154
            Id = '';
            claimID = '';
            status='';
            // Location story start
            paymentDetails='';
            customerName='';
            lastSaved_sort = '';    //GSSC:262 Krishna

            shopWO='';
            prodSerialNum='';
            serviceJob='';
            location='';
            lastSaved='';
            lastSavedBy=''; 
            cvin='';
            jobStatus = '';
            serviceJobId = '';
            ///Commented as part of defect of 191280 --Start--------------------
            //warrClaimId = '';
            //paymentRefNumber='';
            // --------------END------------------
            warrCopyClaimId = '';
            claimSubmisionRecordId = '';
            SiebelPaymentReceived = false;
            policyClaim = false;
            cataClaim=false;
            MultiPSNFlag=false;
            PendingResponseSP = false;
            //isPSNTriggered = false;
        }
    }  

}