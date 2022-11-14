/*
 * Block comments with details of changes
 */
public class CG_CL_ClaimsAuthorizations
{
    public CG_CL_ClaimsIntake mainContr{set; get;}
    public Boolean isFactory {set; get;}
    //public string ERPSystemValue{set; get;}
    public String modifyDT{get;set;}
    public String paccarokbtn{get;set;}
    public string paccarcontacttext{get;set;}
    public CSS_Claims__c claimRecord = new CSS_Claims__c();

    //public string createdDT{get;set;}
    //Public String RejectionTimeStamp {get;set;}
    //Public DateTime RejectionTimeStamp1 {get;set;}
    public CSS_Claims__c claimsRec{get;  
                                   set
                                   {    
                                       claimsRec = value;
                                       system.debug('Claim Record1:'+value);
                                       if(claimsRec != null && claimsRec.Id != null )  
                                       {


                                           system.debug('Claim Record2:'+claimsRec);
                                           if(claimsRec.Rejection_Timestamp__c!=null){
                                               //createdDT = css_utility.getFormattedDate(claimsRec.Rejection_Timestamp__c); 
                                               //=createdDT.touppercase();
                                               modifyDT = css_utility.getFormattedDate(claimsRec.Rejection_Timestamp__c);
                                               modifyDT=modifyDT.touppercase();
                                               system.debug('modifyDT'+modifyDT);
                                           }
                                           //RejectionTimeStamp = css_utility.getFormattedDate(mainContr.claimsRec.Rejection_Timestamp__c);
                                           //RejectionTimeStamp = RejectionTimeStamp.touppercase();
                                           //RejectionTimeStamp1=Datetime.valueOf(RejectionTimeStamp);
                                       }
                                   }
                                  }

    Public Id cId;
    public CG_CL_ClaimsAuthorizations()
    {
         
        cId=ApexPages.CurrentPage().getParameters().get('id');
       // claimRecord = [Select id, CSS_Paccar_Authorization_contact_text__c,Css_paccar_approve_reject_flag__c,Parts_Warranty_Claim_Only__c,PACCAR_Flag__c,PACCAR_Auth_Required__c from CSS_Claims__c where Id =: cId];
       // paccarcontacttext = claimsRec.CSS_Paccar_Authorization_contact_text__c;
        isFactory=false;
        UserRole urRole = new UserRole();
        if(UserInfo.getUserRoleId() != null && UserInfo.getUserRoleId() != '') {
            urRole = [Select name from UserRole where id=:UserInfo.getUserRoleId()];
            if(urRole != null && urRole.name == 'Factory'){
                isFactory=true;
            }
            else
            {
                isFactory=false;
            }
        }

    }
    Public void saveCatastrophicCheck(){

        claimsRec.Catastrophic__c=true;

    }
    public boolean paccarbool{get;set;}
    Public pageReference Approvedrejectfrompopup(){
        paccarbool = false;
        system.debug('paccarokbtn'+paccarokbtn);
        CSS_Claims__c claimRec1 = new CSS_Claims__c();
        claimRec1.Id = cId;
        if(paccarokbtn == 'Approve'){
            claimRec1.Css_paccar_approve_reject_flag__c = 'Approved';
            claimRec1.CSS_Paccar_Authorization_contact_text__c = claimsRec.CSS_Paccar_Authorization_contact_text__c;
        paccarbool = true;
        }
        else if(paccarokbtn == 'Reject'){
            claimRec1.Css_paccar_approve_reject_flag__c = 'Rejected';
           claimRec1.CSS_Paccar_Authorization_contact_text__c = claimsRec.CSS_Paccar_Authorization_contact_text__c;
        paccarbool = true;
        claimRec1.Status__c= 'Not Authorized';
        }
        update claimRec1;
        pageReference pageRef;
        pageRef = new pageReference('/apex/CG_ClaimsIntake?id='+cId); 
        pageRef.setRedirect(true);
        return pageRef;
        
    }

}