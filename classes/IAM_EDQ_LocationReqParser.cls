Public class IAM_EDQ_LocationReqParser{

    //Wrapper class begins//
    Public static String IAM_LocationEDQReqParser(account accnt){
     String JSONstring;
    AddressPayload lstWapperforPut;
    lstWapperforPut=new AddressPayload(accnt);
        if(lstWapperforPut!=null){
            JSONString = JSON.serialize(lstWapperforPut);
        }
      System.debug('Printing return string '+JSONstring);
        return JSONstring;
    }
    
        Public Class AddressPayload{
            Public Header Header{set;get;}
            Public AddressCleanse AddressCleanse{set;get;}
                
                Public AddressPayload(Account acc){
                    this.Header=new Header(acc.id);
                    this.AddressCleanse=new AddressCleanse(acc);
                }
        }
        
        Public class Header{
            Public Sender Sender{set;get;}
                Public Header(id acnId){
                    This.Sender=new Sender(acnId);
                }
        }
        
        Public Class Sender{
            Public String ServiceName{set;get;}
            Public String SenderID{set;get;}
            Public String MessageID{set;get;}
                Public Sender(id aid){
                    this.ServiceName='AddressCleanse';
                    this.SenderID='IAM';
                    this.MessageID=aid;
                }
        }
     
        public class AddressCleanse{
          Public Location Location{set;get;}
           
            public AddressCleanse(Account accn){
                this.Location=new Location(accn);
           }
        }
        Public Class Location{
            Public GeographicalArea GeographicalArea{set;get;}
            
            
                Public Location(Account acn){
                this.GeographicalArea= new GeographicalArea(acn);
                
                }
        } 
        
        Public Class GeographicalArea{
            Public StreetAddress StreetAddress{set;get;}
            Public City City{set;get;}
            Public County County{set;get;}
            Public Province Province{set;get;}
            Public string StateId{set;get;}
            Public PostalCode PostalCode{set;get;}
            Public Country Country{set;get;}
            Public GeographicalAreaSubtype GeographicalAreaSubtype{set;get;}
            Public AddressValidation AddressValidation{set;get;}
            
                Public GeographicalArea(Account Aga){
                    this.StreetAddress=new StreetAddress(Aga);
                    this.City= new City(Aga);
                    this.County=new County(Aga);
                    this.Province= new Province(Aga);
                    this.StateId=Aga.BillingStateCode    ;
                    this.PostalCode=new PostalCode(Aga);
                    this.Country=new Country(Aga);
                    this.GeographicalAreaSubtype=new GeographicalAreaSubtype(Aga);
                    this.AddressValidation=new AddressValidation(Aga);
                }
        }
        
        Public Class StreetAddress{
            Public String StreetAddressID{set;get;}
            Public String AddressLine1txt{set;get;}
            Public String AddressLine2txt{set;get;}
            Public String AddressLine3txt{set;get;}
            Public String AddressLine4txt{set;get;}
            Public String StateProvinceTypeind{set;get;}
                
                Public StreetAddress(Account asa){
                    this.StreetAddressID='';
                    this.AddressLine1txt=asa.BillingStreet;
                    //String Comparision changed by Karthik for correct address.
                    //if((asa.CMI_Address2__c!=null||asa.CMI_Address2__c!=null)){
                    if(!String.isEmpty(asa.CMI_Address2__c)){
                    System.debug('Address 2 case');
                    this.AddressLine1txt=asa.BillingStreet+','+asa.CMI_Address2__c;
                    }
                    //this.AddressLine2txt=asa.BillingCity;
                    this.AddressLine2txt='';
                    //this.AddressLine3txt=asa.BillingState;
                    this.AddressLine3txt='';
                    
                    this.AddressLine4txt='';
                    this.StateProvinceTypeind='';
                }
        }
        
        Public Class City{
            Public String CityID{set;get;}
                
                Public City(Account acity){
                    this.CityID=acity.BillingCity;
                } 
        }
        
        Public Class County{
            
            Public String CountyID{set;get;}
                Public County(Account Acounty){
                    if(null != Acounty.BillingCountry && (Acounty.BillingCountry.equals('ALBANIA')|| Acounty.BillingCountry.equals('BANGLADESH') || Acounty.BillingCountry.equals('ESTONIA') || Acounty.BillingCountry.equals('UNITED KINGDOM') || Acounty.BillingCountry.equals('CROATIA') || Acounty.BillingCountry.equals('HUNGARY') || Acounty.BillingCountry.equals('IRELAND') || Acounty.BillingCountry.equals('LIBERIA') || Acounty.BillingCountry.equals('LITHUANIA') || Acounty.BillingCountry.equals('MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF') || Acounty.BillingCountry.equals('NORWAY') || Acounty.BillingCountry.equals('NEPAL') || Acounty.BillingCountry.equals('ROMANIA') || Acounty.BillingCountry.equals('SWEDENSWEDEN')))
                        this.CountyID=Acounty.BillingState;
                    else    
                        this.CountyID='';
                }
        }
        
        Public Class Province{
            Public String ProvinceID{set;get;}
                Public Province(Account ap){
                    this.ProvinceID='';
                }
        }
        
        Public Class PostalCode{
            Public String PostalCodeNum{set;get;}
                Public PostalCode(Account ap){
                    this.PostalCodeNum=ap.BillingPostalCode;
                }
        }
        
        Public Class Country{
            Public String CountryID{set;get;}
                Public Country(Account aCountry){
                    this.CountryID=aCountry.BillingCountryCode;
                }
        }
        
        
        Public Class GeographicalAreaSubtype{
               Public string DependantLocality{set;get;}
               Public String DoubleDependantLocality{set;get;}
                    
                   Public GeographicalAreaSubtype(Account Ag){
                       this.DependantLocality='';
                       this.DoubleDependantLocality='';
                   }
           }
       
         Public Class AddressValidation{
               Public decimal MinimumVerificationMatchScore{set;get;}
               Public decimal MinimumVerificationLevel{set;get;}
               Public String AllowedVerificationResultCodes{set;get;}
                   
                   Public AddressValidation(Account aav){
                       this.MinimumVerificationMatchScore=null;
                       this.MinimumVerificationLevel=null;
                       this.AllowedVerificationResultCodes='';
                   }
                       
           }      

}