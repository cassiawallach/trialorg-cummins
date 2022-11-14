Public class IAM_GL_ReqParser{

    //Wrapper class begins//
     Public static String IAM_GL_ReqParserClass(String billingStreet, string BillingCity, string BillingCountry, string BillingPostalCode){
     String JSONstring;
    AddressInformation lstWapperforPut;
    lstWapperforPut=new AddressInformation(billingStreet,BillingCity,BillingCountry,BillingPostalCode);
        System.debug('Printing list wrapper info'+lstWapperforPut);
        if(lstWapperforPut!=null){
            JSONString = JSON.serialize(lstWapperforPut);
        }
      System.debug('Printing return string '+JSONstring);
        return JSONstring;
    }
    
        Public class AddressInformation{
            Public locationInfo locationInfo{set;get;}
            
            Public AddressInformation(String billingStreet1, string BillingCity1, string BillingCountry1, string BillingPostalCode1){
            this.locationInfo=new locationInfo(billingStreet1,BillingCity1,BillingCountry1,BillingPostalCode1);
            }
        }    
    
        Public Class locationInfo{
            
            Public Location Location{set;get;}
            Public String securityToken1{set;get;}
            Public String securityToken2{set;get;}
            Public String countryId{set;get;}
            Public String countryName{set;get;} 
               
                Public locationInfo(String billingStreet2, string BillingCity2, string BillingCountry2, string BillingPostalCode2){
                    this.Location=new Location(billingStreet2,BillingCity2,BillingCountry2,BillingPostalCode2);
                    this.securityToken1='PnUPLfXBABzjWmOSm5xi2C6AqmVNrDIk';
                    this.securityToken2='bRX33RKfI4YNf7u4DO3kbzXstfq3n+2Q';
                    this.countryId='122';
                    //Hard coding the below value to United states.this values is not used for getting the parent account.
                    this.countryName='United States';
                }
        }
        
       
        
        Public Class Location{
            Public String isEPF{set;get;}
            Public String address{set;get;}
            Public String addressOrLatlngSearch{set;get;}
            Public String countryOrRegionSearch{set;get;}
            
            
                Public Location(String billingStreet3, string BillingCity3, string BillingCountry3, string BillingPostalCode3){
                this.isEPF='E';
                this.address=billingStreet3+','+BillingCity3+','+BillingCountry3+','+BillingPostalCode3;
                //this.address=acn.BillingAddress;
                this.addressOrLatlngSearch='address';
                this.countryOrRegionSearch='country';
                
                }
        } 
        
            

}