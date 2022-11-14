/**********************************************************************
Name:  OSM_SW_TaxExemptionContactCtrl
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this is to download Contact Form                                  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Nandigam Sasi     20/04/2020         INITIAL DEVELOPMENT          
*****************************************************/
public class OSM_SW_TaxExemptionContactCtrl {
    private account primaryaccount ;
    
    public String renderingService { get; private set; }
    public String renderingServicetext { get; private set; }
    
    public string CustomerNumber {set;get;}
    public string CustomerName {set;get;}
    public string primaryfirstname {set;get;}
    public string secondaryfirstname {set;get;}
    public string primarylastname {set;get;}
    public string secondarylastname {set;get;}
    public string primarycity {set;get;}
    public string secondarycity {set;get;}
    public string primarycountry{set;get;}
    public string secondarycountry {set;get;}
    public string primaryemail{set;get;}
    public string secondaryemail {set;get;}
    public string primaryzip{set;get;}
    public string secondaryzip {set;get;}
    public string primaryphone{set;get;}
    public string secondaryphone {set;get;}
    public string primaryaddress1{set;get;}
    public string secondaryaddress1 {set;get;}
    public string primaryaddress2{set;get;}
    public string secondaryaddress2{set;get;}
    public string primarystate {set;get;}
    public string secondarystate {set;get;}
    
    
    public  OSM_SW_TaxExemptionContactCtrl(){
        Id recid = apexpages.currentpage().getparameters().get('effacid');
        if(recid!=null){
               primaryaccount  = [select id,Customer_BMS_number__c,BOLT_Account_Number__c,IAM_Service_Provider_Code__c,BMS_Customer_ID__c,BMS_Customer_ID_Junction__c from account where id=:recid limit 1];
           if(primaryaccount.Customer_BMS_number__c!=null){
              CustomerNumber= primaryaccount.Customer_BMS_number__c; 
            }else if(primaryaccount.BOLT_Account_Number__c!=null){
                CustomerNumber= primaryaccount.BOLT_Account_Number__c; 
            }else {
                 CustomerNumber= primaryaccount.IAM_Service_Provider_Code__c;
            }
        }
       String myGeneratedFileName = 'Tax Exemption ContactForm.pdf';
       Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+myGeneratedFilename);
       Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename='+myGeneratedFilename); 
    }
    public void downloadcontactform(){
        
    }
    public PageReference saveToPdf() {
        primarystate = primarystate=='--None--'?'':primarystate;
        secondarystate = secondarystate=='--None--'?'':secondarystate;
        
        renderingService = 'PDF';
        return null;
    }
    
    public String renderedFileName { 
        get; 
        set { renderedFileName = this.SafeFileName(value); }
    }
   
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) || ( ! renderingService.startsWith('PDF')) );
    }
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; 
            
            if( ! this.renderingAsHtml() ) {
               renderedContentType = 'application/pdf';
                
                if(this.renderedFileName != null) {
                    ApexPages.currentPage().getHeaders().put( 'content-disposition', 'attachment; filename=' + this.renderedFileName);
                }
            }
            
            return renderedContentType;
        }
    }
    
    private String SafeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String fileName = unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        return(fileName);
    }
    
    public List<SelectOption> getstates(){
         List<SelectOption> options = new List<SelectOption>(); 
        list<string> states = new list<string>{'--None--','Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana',
                                               'Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania ','Rhode Island','South Carolina','South Dakota',
                                               'Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming'};
           system.debug('states'+states.size());                                        
      for(string str :states){
          options.add(new SelectOption(str,str)); 
      }
      return options; 
                                                   
    }

}