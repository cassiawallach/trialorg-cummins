import { LightningElement,track,wire } from 'lwc';
import pubsub from 'c/pubsub'; 
import communityName from'@salesforce/label/c.dbu_communityName';
import dbu_footerLocation from '@salesforce/label/c.dbu_footerLocation'; 
import dbu_home_footer_contactUs from '@salesforce/label/c.dbu_home_footer_contactUs';
import dbu_home_footer_locations from '@salesforce/label/c.dbu_home_footer_locations';
import dbu_home_footer_FAQ from '@salesforce/label/c.dbu_home_footer_FAQ';
import dbu_home_footer_returnAndRefundPolicy from '@salesforce/label/c.dbu_home_footer_returnAndRefundPolicy';
import dbu_home_footer_shoppingPolicy from '@salesforce/label/c.dbu_home_footer_shoppingPolicy';
import dbu_home_footer_corePolicy from '@salesforce/label/c.dbu_home_footer_corePolicy';
import dbu_home_footer_warrantyInformation from '@salesforce/label/c.dbu_home_footer_warrantyInformation';

import dbu_home_footer_transparencySupplyChains from '@salesforce/label/c.dbu_home_footer_transparencySupplyChains';
import dbu_home_footer_privacyPolicy from '@salesforce/label/c.dbu_home_footer_privacyPolicy';
import dbu_AccessbilityStatement from '@salesforce/label/c.dbu_AccessbilityStatement';
import dbu_home_footer_termsOfUse from '@salesforce/label/c.dbu_home_footer_termsOfUse';
import getUserDetails from '@salesforce/apex/dbu_currentLoggedInUser.getUserDetails';
import Id from '@salesforce/user/Id';
import fetchSitMmapPageSubCategoryDetails from '@salesforce/apex/dbu_siteMapController.fetchSitMmapPageSubCategoryDetails';
import { NavigationMixin } from 'lightning/navigation';


export default class Dbu_siteMap extends NavigationMixin(LightningElement) 
{
    @track sitemap;
    @track productCategories;
    @track cummins;
    @track onan;
    @track fleetguard;
    @track customerService;
    @track contactUsURL;
    @track locationURL;
    @track FAQURL;
    @track returnAndRefumdURL;
    @track shippingPolicyURL;
    @track corePolicyURL;
    @track warantyInformationURL;
    @track PurchaseAgreementsURL; 
    @track footerLocation; 
    @track storeLocation;

    @track productLine;
    @track currentPromotions;
    @track allPromotions;
    @track mostPopularParts;
    @track allmostPopularParts;
    @track myAccount;
    @track viewOrders;
     
    @track contactUs = dbu_home_footer_contactUs;
    @track dbu_location = dbu_home_footer_locations;
    @track FAQ = dbu_home_footer_FAQ;
    @track returnAndRefundPolicy = dbu_home_footer_returnAndRefundPolicy;
    @track shoppingPolicy = dbu_home_footer_shoppingPolicy;
    @track corePolicy = dbu_home_footer_corePolicy;
    @track warrantyInformation = dbu_home_footer_warrantyInformation;

    @track transfermsg;
    @track privacymsg;
    @track accessbilitymsg;
    @track termsofusemsg;
    @track termOfUseURL;
    @track privacyPolicyURL;
    @track storeLocation;
    showUSPrivacyPlcy = true;
    showCAPrivacyPlcy = false;
    showTermAndCondition = true;
    @track usefulLinks;
    
    userId = Id;
    @track user;
    @track error;
    @track subCategoryCumminsArray = [];
    @track subCategoryOnanArray = [];
    @track subCategoryFleetgaurdArray = [];
    @track subCategoryValvolineArray = [];
    @track subCategoryWebastoArray = [];
    @track subCategoryPowerServiceArray = [];
    @track subCategoryYamhaArray = [];
    @track allSubCategoryArray = [];
    @track subcategoryId;
    @track isYamaha = false;
    @track rediredctMyAccount;
    @track baseURL;
 
    connectedCallback()
    {
        this.regiser();
        let locationURL = window.location.href;
        var url = new URL(locationURL);
        this.storeLocation = url.searchParams.get("store");
        
        console.log('storeLocation>>' +this.storeLocation);

        if(this.storeLocation == null){
            this.storeLocation = 'US';    
        }else if(this.storeLocation == 'EN'){
            this.storeLocation = 'CA';
            //this.currentLanguage = 'EN';
        }else if(this.storeLocation == 'FR'){
            this.storeLocation = 'CA';
            //this.currentLanguage = 'FR';
        }
        console.log('storeLocation after Change Store > ' + JSON.stringify(this.storeLocation));
        //console.log('connected callback homesub category prods after > ' + JSON.stringify(this.currentLanguage));

        this.sitemap = 'Site Map';
        this.productCategories = 'Product Categories';
        this.cummins = 'Cummins';
        this.onan = 'Onan';
        this.fleetguard = 'Fleetguard';
        this.valvoline = 'Valvoline';
        this.webasto = 'Webasto';
        this.powerService = 'Power Service';
        this.yamaha = 'Yamaha';


        this.productLine = 'Product Line'
        this.currentPromotions = 'Current Promotions';
        this.allPromotions = 'All Promotions';
        this.mostPopularParts = 'Most Popula Parts';
        this.allmostPopularParts =  'All Most Popular Parts';
        this.myAccount = 'My Account';
        this.viewOrders = 'View Orders';
        this.viewOrders = 'View Orders';
        this.customerService =  'Customer Services';
        this.usefulLinks= 'Useful Links';

        this.baseURL = window.location.origin+communityName;
        this.contactUsURL = this.baseURL + 'contact-us?store=' + this.storeLocation;
        this.locationURL = this.baseURL + 'locations?store=' + this.storeLocation;
        this.FAQURL = this.baseURL + 'faq?store=' + this.storeLocation;
        this.returnAndRefumdURL = this.baseURL + 'refund-policy?store=' + this.storeLocation;
        this.shippingPolicyURL = this.baseURL + 'shipping-policy?store=' + this.storeLocation;
        this.corePolicyURL = this.baseURL + 'core-policy?store=' + this.storeLocation;
        this.warantyInformationURL = this.baseURL + 'warranty?store=' + this.storeLocation;
        this.PurchaseAgreementsURL = this.baseURL + 'purchaseagreements?store=' + this.storeLocation;
        this.footerLocation = dbu_footerLocation;

        this.transfermsg = dbu_home_footer_transparencySupplyChains;
        this.privacymsg = dbu_home_footer_privacyPolicy;
        this.accessbilitymsg= dbu_AccessbilityStatement;
        this.termsofusemsg = dbu_home_footer_termsOfUse;

        this.termOfUseURL = this.baseURL + 'termofuse?store=' + this.storeLocation;
        this.privacyPolicyURL = this.baseURL + 'privacy-policy?store=' + this.storeLocation;  
        this.getSubCategory(); 
        console.log('userId>>' + this.userId);
        if(this.userId == undefined)
        {
            console.log('InsideuserId>>+++' + this.userId);
            this.baseURL = window.location.origin+communityName;
            this.rediredctMyAccount = this.baseURL + 'track-order?'+'&store=' + this.storeLocation;
            console.log('Guest User this.rediredctMyAccount>>> ' + this.rediredctMyAccount);
            return;
        }
    }
    getSubCategory() 
    {
        fetchSitMmapPageSubCategoryDetails({
            country: this.storeLocation 
        })
        .then(result => 
        {
            console.log('result length153>>>> ' + JSON.stringify(result.length));
            console.log('result154>>>> ' + JSON.stringify(result.subCategoryList.length));
            console.log('result>>>> ' + JSON.stringify(result));

            // Display SubCategory Name
            if (result.subCategoryList.length > 0) 
            {
                for (let i = 0; i < result.subCategoryList.length; i++) 
                {
                    let subCategoryeObject = {};
                    subCategoryeObject['Id'] = result.subCategoryList[i].Id;
                    subCategoryeObject['Name'] = result.subCategoryList[i].Name;

                    if (result.subCategoryList[i].Name.startsWith('Cummins'))
                    {
                        this.subCategoryCumminsArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Onan'))
                    {
                        this.subCategoryOnanArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Fleetguard'))
                    {
                        this.subCategoryFleetgaurdArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Valvoline'))
                    {
                        this.subCategoryValvolineArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Webasto'))
                    {
                        this.subCategoryWebastoArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Power'))
                    {
                        this.subCategoryPowerServiceArray.push(subCategoryeObject);
                    }
                    if(result.subCategoryList[i].Name.startsWith('Yamaha'))
                    {
                        this.isYamaha = true;
                        this.subCategoryYamhaArray.push(subCategoryeObject);
                    }
                    //this.subCategoryCumminsArray.push(subCategoryeObject);
                }
            }
            console.log('this.subCategoryCumminsArray>> ' + JSON.stringify(this.subCategoryCumminsArray));
            console.log('this.subCategoryOnanArray>> ' + JSON.stringify(this.subCategoryOnanArray));
            console.log('this.subCategoryFleetgaurdArray>> ' + JSON.stringify(this.subCategoryFleetgaurdArray));
            console.log('this.subCategoryValvolineArray>> ' + JSON.stringify(this.subCategoryValvolineArray));
            console.log('this.subCategoryWebastoArray>> ' + JSON.stringify(this.subCategoryWebastoArray));
            console.log('this.subCategoryPowerServiceArray>> ' + JSON.stringify(this.subCategoryPowerServiceArray));
            console.log('this.subCategoryYamhaArray>> ' + JSON.stringify(this.subCategoryYamhaArray));
            
            if (result.subCategoryList.length > 0) 
            {
                for (let i = 0; i < result.subCategoryList.length; i++) 
                {
                    let subCategoryeObject = {};
                    subCategoryeObject['Id'] = result.subCategoryList[i].Id;
                    subCategoryeObject['Name'] = result.subCategoryList[i].Name;
                    if(this.storeLocation == 'CA')
                    {
                        console.log('Inside IF CA');
                        this.isYamaha = true;
                        this.allSubCategoryArray.push(subCategoryeObject);
                        console.log('IF this.allSubCategoryArray>> ' + JSON.stringify(this.allSubCategoryArray));
                    }
                    else{
                        console.log('Inside ELSE US');
                        this.allSubCategoryArray.push(subCategoryeObject);
                        console.log('ELSE this.allSubCategoryArray>> ' + JSON.stringify(this.allSubCategoryArray));
                    }
                } 

            }

		})
        .catch(error => 
        {
			console.log(error)
			this.screenLoaded = false;
		});

    }
    @track isOrder = true;
    @wire(getUserDetails, 
    {
        recId: '$userId'
    })
    wiredUser({error,data}) 
    {
        if (data) 
        {
            this.user = data;
            console.log('this.user>>>+ ' + JSON.stringify(this.user));
            
            if(this.user != undefined || this.user != '')
            {
                //https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/my-account?orders=true&store=US 
                this.baseURL = window.location.origin+communityName;
                this.rediredctMyAccount = this.baseURL + 'my-account?orders=' + this.isOrder + '&store=' + this.storeLocation;
                console.log('Logged in User this.rediredctMyAccount>>> ' + this.rediredctMyAccount);
            }
            else if(this.user == undefined || this.user == '')
            {
                //https://csodev-cumminscss.cs90.force.com/CSSNAStore/s/track-order?store=US
                this.baseURL = window.location.origin+communityName;
                this.rediredctMyAccount = this.baseURL + 'track-order?'+'&store=' + this.storeLocation;
                console.log('Guest User this.rediredctMyAccount>>> ' + this.rediredctMyAccount);
            }
        } 
        else if (error) 
        {
            this.error = error;
        }
    }
     
    handleSelectedSubCategory(event) 
    {
        console.log('Inside handleSelectedSubCategory');
        console.log('Sub Category ID===' + event.target.dataset.targetId); 
        // let subCategoryId = event.target.dataset.id;
        this.subcategoryId = event.target.dataset.targetId;
        let urlString = window.location.origin;
        let redirectURL = urlString + communityName + 'categories?id=' + this.subcategoryId + '&store=' + this.storeLocation;
        console.log('redirectURL===' + redirectURL);
        this[NavigationMixin.Navigate]({
            "type": "standard__webPage",
            "attributes": {
                "url": redirectURL
            }
        });
    }
    
    // connectedCallback()
    // {
    //     this.regiser();
    //     let locationURL = window.location.href;
    //     var url = new URL(locationURL);
    //     this.storeLocation = url.searchParams.get("store");
        
    //     console.log('storeLocation>>' +this.storeLocation);

    //     this.customerService =  'Customer Services';
    //     this.usefulLinks= 'Useful Links';
    //     this.spcloffermsg = dbu_home_footer_specialOffers;
        
    //     this.baseURL = window.location.origin+communityName;
    //     this.contactUsURL = this.baseURL + 'contact-us?store=' + this.storeLocation;
    //     this.locationURL = this.baseURL + 'locations?store=' + this.storeLocation;
    //     this.FAQURL = this.baseURL + 'faq?store=' + this.storeLocation;
    //     this.returnAndRefumdURL = this.baseURL + 'refund-policy?store=' + this.storeLocation;
    //     this.shippingPolicyURL = this.baseURL + 'shipping-policy?store=' + this.storeLocation;
    //     this.corePolicyURL = this.baseURL + 'core-policy?store=' + this.storeLocation;
    //     this.warantyInformationURL = this.baseURL + 'warranty?store=' + this.storeLocation;
    //     this.PurchaseAgreementsURL = this.baseURL + 'purchaseagreements?store=' + this.storeLocation;
    //     this.footerLocation = dbu_footerLocation; 

    //     this.transfermsg = dbu_home_footer_transparencySupplyChains;
    //     this.privacymsg = dbu_home_footer_privacyPolicy;
    //     this.accessbilitymsg= dbu_AccessbilityStatement;
    //     this.termsofusemsg = dbu_home_footer_termsOfUse;

    //     this.termOfUseURL = this.baseURL + 'termofuse?store=' + this.storeLocation;
    //     this.privacyPolicyURL = this.baseURL + 'privacy-policy?store=' + this.storeLocation; 
    // }
    regiser()
    {
        window.console.log('event registered ');
        pubsub.register('displayPrvtPlcy', this.handledisplayPrvtPlcy.bind(this));
        pubsub.register('locationSelected', this.handleLocationSelected.bind(this));    
    }
    handledisplayPrvtPlcy(location) 
    {
        if(location == 'US')
        {
            this.showUSPrivacyPlcy = true;
            this.showCAPrivacyPlcy = false;
        } 
        if(location == 'CA' || location == 'CAF')
        {
            this.showUSPrivacyPlcy = false;
            this.showCAPrivacyPlcy = true;
        }  
    }
    handleLocationSelected(location)
    {
        console.log('location value ' + location);
        if(location == 'US'){
            this.showTermAndCondition = true;
        }
        else if(location == 'CA' || location == 'CAF')
        {
            this.showTermAndCondition = false;
        }
    }

}