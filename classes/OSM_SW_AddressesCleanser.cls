public Class OSM_SW_AddressesCleanser
{
    
    
    
    // Method created by Nandigam Sasi that uses IAM code for EDQ
    public static OSM_SW_Addresses getEDQCleansedAddress(OSM_SW_Addresses addressObj, Account acc){
        Http h = new Http();
        HttpResponse res;
        HttpRequest req;
        
        OSM_SW_Addresses newCleanAddress = new OSM_SW_Addresses();
        
        try{
            // get the access token
            String accessToken=IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_EDQ_Mule_oAuth');
            String responseBody='';
            // call the EDQ service
            Address newAddress = new Address();
            
            newAddress.address1 = addressObj.billingAddress.address1;
            newAddress.address2 = addressObj.billingAddress.address2;
            newAddress.address3 = addressObj.billingAddress.address3;
            newAddress.city = addressObj.billingAddress.city;
            newAddress.state = addressObj.billingAddress.state;
            newAddress.country = addressObj.billingAddress.country;
            newAddress.postalCode = addressObj.billingAddress.postalCode;
            
            AddressPayload lstWapperforPut = new AddressPayload(newAddress, acc.ID);
            
            String reqBody = JSON.serialize(lstWapperforPut);
            
            CSS_Integration_Details__c serviceDetails = CSS_Integration_Details__c.getValues('IAM_EDQ_Mule_Address_Validation');
            req = new HttpRequest();
            req.setEndpoint(serviceDetails.End_Point__c);
            req.setMethod(serviceDetails.Method_Type__c);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setHeader('resource',serviceDetails.Resource__c);
            req.setBody(ReqBody);
            req.setTimeout(120000);
            
            if(test.isRunningTest()){
                responseBody='{"AddressCleanse":{"ResponseNotifications":{"Status":"Success","ReturnCodeDescription":""},"Location":[{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"340 WINT LN APT D,29&#124;COLUMBUS IN 47201-6690","AddressLine1txt":"340 WINT LN APT D,29","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"S","AddressType":"R"},"AddressValidation":{"VerificationDescription":"Verified; 4 - Premise; Identified and parsed; Primary postal code verified, secondary added or changed; Score 100","VerificationCode":"V44-I55-P7-100","VerifiedFlag":"N","GeoAccuracyCodeDescription":"Unable to geocode; 0 - None","GeoAccuracyCode":"U0","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"US","CountryName":"US","CountryNameDescription":"UNITED STATES"},"PostalCode":{"PostalCodeNum":"47201-6690"},"City":{"TerritoryID":"IN","CityID":"COLUMBUS"},"County":{"CountyID":"BARTHOLOMEW"},"CountryGroup":{"CountryGroupID":"AMERICAS","SubRegion":"NORTHERN AMERICA"}}},{"Locator":{"LongitudeMeas":"","LatitudeMeas":""},"GeographicalArea":{"GeographicalAreaName":"","StreetAddress":{"FullAddress":"340 WINT LN APT D,29&#124;&#124;&#124;&#124;&#124;&#124;COLUMBUS&#124;&#124;IN&#124;47201-6690","AddressLine1txt":"340 WINT LN APT D,29","AddressLine4txt":"","StreetAddressID":"","AddressLine2txt":"","AddressLine3txt":"","StateProvinceTypeind":"","AddressType":"S"},"AddressValidation":{"VerificationDescription":"","VerificationCode":"","VerifiedFlag":"","GeoAccuracyCodeDescription":"","GeoAccuracyCode":"","GeoDistance":""},"AddressError":{"ErrorDescription":"","ErrorFlag":"N"},"GeographicalAreaSubName":"","Country":{"CountryID":"US","CountryName":"US","CountryNameDescription":"UNITED STATES"},"PostalCode":{"PostalCodeNum":"47201-6690"},"City":{"TerritoryID":"IN","CityID":"COLUMBUS"},"County":{"CountyID":""},"CountryGroup":{"CountryGroupID":"","SubRegion":""}}}]}}';
            }else{
                res = h.send(req);
                responseBody=res.getBody();
            }
           // system.debug('responseBody'+responseBody);
            IAM_EDQ_LocationResParser LocRes = IAM_EDQ_LocationResParser.parse(responseBody);
            
            if(LocRes!=null){
                Boolean verified =false;
                String AddStatus = LocRes.AddressCleanse.ResponseNotifications.Status;
                //String errorflag = LocRes.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorFlag; 
                //String VerifiedFlag = LocRes.AddressCleanse.Location[0].GeographicalArea.AddressValidation.VerifiedFlag;
                
                for(IAM_EDQ_LocationResParser.Location address :LocRes.AddressCleanse.Location){
                            // System.debug('Printing address'+address);
                            if(address.GeographicalArea.AddressValidation.VerifiedFlag=='Y'){
                                newCleanAddress.billingAddress = new OSM_SW_Addresses.Address();
                                newCleanAddress.billingAddress.address1 = address.GeographicalArea.StreetAddress.AddressLine1txt;
                                newCleanAddress.billingAddress.address2 = address.GeographicalArea.StreetAddress.AddressLine2txt;
                                newCleanAddress.billingAddress.address3 = address.GeographicalArea.StreetAddress.AddressLine3txt;
                                newCleanAddress.billingAddress.city = address.GeographicalArea.City.CityID;
                                newCleanAddress.billingAddress.state = addressObj.billingAddress.state;
                                newCleanAddress.billingAddress.country = address.GeographicalArea.Country.CountryName;
                                newCleanAddress.billingAddress.postalCode = address.GeographicalArea.PostalCode.PostalCodeNum;
                                newCleanAddress.isAddressCleanFail = false;
                                verified =true;
                                Break;
                            }  
                            
                        }
                        if(!verified){
                                newCleanAddress.isAddressCleanFail = true;
                                newCleanAddress.errorMsgOfAddressCleane = 'Account did not got updated because the response for EDQ is Not verified';
                        }
            }
        }
        catch(exception e)
        {
           // System.debug('Printing exception message'+e.getMessage());
            newCleanAddress.isAddressCleanFail = true;
            newCleanAddress.errorMsgOfAddressCleane = e.getMessage()+'/n'+e.getLineNumber()+'/n'+e.getStackTraceString();
            
        }  
        
        return newCleanAddress;
    }
    
    
    public static OSM_SW_Addresses getCleanserAddress(OSM_SW_Addresses addressObj,Id accountId)
    {
        OSM_SW_Addresses newCleanAddress = new OSM_SW_Addresses();
        
        
       // System.debug('Printing future login');
        Http h = new Http();
        HttpResponse res;
        HttpRequest req;
        String accessToken = '';//IAM_EDQ_AddressCleanse.getToken();//funtion to get access token
       // System.debug('Printing debug logs '+accessToken);
        
        //calling EDQ  service
        try{
            
            Address newAddress = new Address();
            
            newAddress.address1 = addressObj.billingAddress.address1;
            newAddress.address2 = addressObj.billingAddress.address2;
            newAddress.address3 = addressObj.billingAddress.address3;
            newAddress.city = addressObj.billingAddress.city;
            newAddress.state = addressObj.billingAddress.state;
            newAddress.country = addressObj.billingAddress.country;
            newAddress.postalCode = addressObj.billingAddress.postalCode;
            //calling Location request parser class to get request body
            
            AddressPayload lstWapperforPut = new AddressPayload(newAddress, accountId); 
            String ReqBody;
            if(lstWapperforPut!=null){
                ReqBody = JSON.serialize(lstWapperforPut);
                
               // System.debug('Priniting Request body from the parser class'+ReqBody); 
                
                if(ReqBody!=null&&(accessToken!=null||accessToken!='')){
                    //need to set header parameters and then call the service.
                   // System.debug('Printing entered request body not equal to null');
                    string url=System.Label.IAM_EDQ_Address_Cleanse_Url;
                    
                    req = new HttpRequest();
                    req.setEndpoint('callout:Credential_for_Address_Cleanser');
                    req.setMethod('POST');
                    req.setHeader('Content-Type', 'application/json');
                    req.setHeader('Authorization','Bearer '+accessToken);
                    
                    
                    req.setBody(ReqBody);
                    res = h.send(req);
                   // System.debug('http response code is '+res.getStatusCode());
                   // System.debug('Printing Response Body'+res.getBody());  
                    IAM_EDQ_LocationResParser LocRes=IAM_EDQ_LocationResParser.parse(res.getBody());
                   // System.debug('Printing Idm location response Object'+LocRes);
                    
                    if(LocRes!=null){
                        Boolean verified =false;
                        String AddStatus=LocRes.AddressCleanse.ResponseNotifications.Status;
                        
                        String errorflag=LocRes.AddressCleanse.Location[0].GeographicalArea.AddressError.ErrorFlag; 
                        String VerifiedFlag=LocRes.AddressCleanse.Location[0].GeographicalArea.AddressValidation.VerifiedFlag;
                       
                        for(IAM_EDQ_LocationResParser.Location address :LocRes.AddressCleanse.Location){
                            // System.debug('Printing address'+address);
                            if(address.GeographicalArea.AddressValidation.VerifiedFlag=='Y'){
                                newCleanAddress.billingAddress = new OSM_SW_Addresses.Address();
                                newCleanAddress.billingAddress.address1 = address.GeographicalArea.StreetAddress.AddressLine1txt;
                                newCleanAddress.billingAddress.address2 = address.GeographicalArea.StreetAddress.AddressLine2txt;
                                newCleanAddress.billingAddress.address3 = address.GeographicalArea.StreetAddress.AddressLine3txt;
                                newCleanAddress.billingAddress.city = address.GeographicalArea.City.CityID;
                                newCleanAddress.billingAddress.state = addressObj.billingAddress.state;
                                newCleanAddress.billingAddress.country = address.GeographicalArea.Country.CountryName;
                                newCleanAddress.billingAddress.postalCode = address.GeographicalArea.PostalCode.PostalCodeNum;
                                newCleanAddress.isAddressCleanFail = false;
                                verified =true;
                                Break;
                            }  
                            
                        }
                       // System.debug('verified'+verified);
                        if(!verified){
                                newCleanAddress.isAddressCleanFail = true;
                                newCleanAddress.errorMsgOfAddressCleane = 'Account did not got updated because the response for EDQ is Not verified';
                        }
                    } 
                }
            }
        }catch(exception e){
            //System.debug('Printing exception message'+e.getMessage());
            newCleanAddress.isAddressCleanFail = true;
            newCleanAddress.errorMsgOfAddressCleane = e.getMessage();
        }   
        
        
        
        
        return newCleanAddress;
    }
    
    
    public class Address {
        public String address1;
        public String address2;
        public String address3;
        public String city;
        public String state;
        public String country;
        public String postalCode;
    }
    
    public class AddressPayload{
        Public Header Header{set;get;}
        Public AddressCleanse AddressCleanse{set;get;}
        
        Public AddressPayload(Address objAdd, Id accountId){
            this.Header=new Header(accountId);
            this.AddressCleanse=new AddressCleanse(objAdd);
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
        
        public AddressCleanse(Address objAdd){
            this.Location=new Location(objAdd);
        }
    }
    Public Class Location{
        Public GeographicalArea GeographicalArea{set;get;}
        
        
        Public Location(Address objAdd){
            this.GeographicalArea= new GeographicalArea(objAdd);
            
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
        
        Public GeographicalArea(Address objAdd){
            this.StreetAddress=new StreetAddress(objAdd);
            this.City= new City(objAdd);
            this.County=new County(objAdd);
            this.Province= new Province(objAdd);
            this.StateId=objAdd.state;
            this.PostalCode=new PostalCode(objAdd);
            this.Country=new Country(objAdd);
            this.GeographicalAreaSubtype=new GeographicalAreaSubtype();
            this.AddressValidation=new AddressValidation();
        }
    }
    
    Public Class StreetAddress{
        Public String StreetAddressID{set;get;}
        Public String AddressLine1txt{set;get;}
        Public String AddressLine2txt{set;get;}
        Public String AddressLine3txt{set;get;}
        Public String AddressLine4txt{set;get;}
        Public String StateProvinceTypeind{set;get;}
        
        Public StreetAddress(Address objAdd){
            this.StreetAddressID='';
            this.AddressLine1txt = '';
            this.AddressLine2txt='';
            this.AddressLine3txt='';
            this.AddressLine4txt='';
            this.StateProvinceTypeind='';
            if(objAdd.address1 != null)
                this.AddressLine1txt=objAdd.address1;
            if(objAdd.address2 != null)
                this.AddressLine2txt=objAdd.address2;
            if(objAdd.address3 != null)
                this.AddressLine2txt=objAdd.address3;
        }
    }
    
    Public Class City{
        Public String CityID{set;get;}
        
        
        Public City(Address objAdd){
            this.CityID='';
            if(objAdd.city != null)
                this.CityID=objAdd.city;
        } 
    }
    
    Public Class County{
        
        Public String CountyID{set;get;}
        Public County(Address objAdd){
            if(null != objAdd.country && (objAdd.country.equalsIgnoreCase('ALBANIA')|| objAdd.country.equalsIgnoreCase('BANGLADESH') || objAdd.country.equalsIgnoreCase('ESTONIA') || objAdd.country.equalsIgnoreCase('UNITED KINGDOM') || objAdd.country.equalsIgnoreCase('CROATIA') || objAdd.country.equalsIgnoreCase('HUNGARY') || objAdd.country.equalsIgnoreCase('IRELAND') || objAdd.country.equalsIgnoreCase('LIBERIA') || objAdd.country.equalsIgnoreCase('LITHUANIA') || objAdd.country.equalsIgnoreCase('MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF') || objAdd.country.equalsIgnoreCase('NORWAY') || objAdd.country.equalsIgnoreCase('NEPAL') || objAdd.country.equalsIgnoreCase('ROMANIA') || objAdd.country.equalsIgnoreCase('SWEDENSWEDEN')))
                this.CountyID=objAdd.country;
            else    
                this.CountyID='';
        }   
        
        
    }
    
    Public Class Province{
        Public String ProvinceID{set;get;}
        Public Province(Address objAdd){
            this.ProvinceID='';
        }
    }
    
    Public Class PostalCode{
        Public String PostalCodeNum{set;get;}
        Public PostalCode(Address objAdd){
            this.PostalCodeNum=objAdd.postalCode;
        }
    }
    
    Public Class Country{
        Public String CountryID{set;get;}
        Public Country(Address objAdd){
            this.CountryID=objAdd.country;
        }
    }
    
    
    Public Class GeographicalAreaSubtype{
        Public string DependantLocality{set;get;}
        Public String DoubleDependantLocality{set;get;}
        
        Public GeographicalAreaSubtype(){
            this.DependantLocality='';
            this.DoubleDependantLocality='';
        }
    }
    
    Public Class AddressValidation{
        Public decimal MinimumVerificationMatchScore{set;get;}
        Public decimal MinimumVerificationLevel{set;get;}
        Public String AllowedVerificationResultCodes{set;get;}
        
        Public AddressValidation(){
            this.MinimumVerificationMatchScore=null;
            this.MinimumVerificationLevel=null;
            this.AllowedVerificationResultCodes='';
        }
        
    }      
       
}