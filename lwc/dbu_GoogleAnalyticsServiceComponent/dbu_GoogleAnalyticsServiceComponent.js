import { publish, MessageContext,createMessageContext,releaseMessageContext } from 'lightning/messageService';
import AnalyticsChannel from '@salesforce/messageChannel/dbuAnalyticsMessageChannel__c';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //US
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //EN
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //FR
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //CA
import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA';
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada';
import guestUserId from '@salesforce/label/c.dbu_GuestUserIdforGoogleAnalytics';
import isGuest from '@salesforce/user/isGuest';
import currentUserId from '@salesforce/user/Id';
//import ForecastCategoryName from '@salesforce/schema/Opportunity.ForecastCategoryName';

function callPublishMethod(messageContext, AnalyticsChannel, messagectx){
    try{
        publish(messageContext, AnalyticsChannel, messagectx);
        //releaseMessageContext(messageContext);
        console.log('Message context Released');            
    }catch(errr){
        console.log('GoogleAnalytics Publish ERROR > ' + JSON.stringify(errr));
    }     
}


function getUserID() {
    let finalvalue;
    if (!isGuest) {
        let userid = currentUserId;
        console.log('currentUserId > ' + currentUserId);
        finalvalue = userid;
    } else if (isGuest) {
        finalvalue = guestUserId;
    }

    return finalvalue;
}

function storeCountryDeterMine(PreviousStoreLocation, NewStoreLocation){
    if(PreviousStoreLocation == storeUSA){
        PreviousStoreLocation = 'UnitedStates';
    }else if(PreviousStoreLocation == storeCA){
        PreviousStoreLocation = 'Canada English';
    }else if(PreviousStoreLocation == storeCAF){
        PreviousStoreLocation = 'Canada French';
    } 

    if(NewStoreLocation == storeUSA){
        NewStoreLocation = 'UnitedStates';
    }else if(NewStoreLocation == storeCA){
        NewStoreLocation = 'Canada English';
    }else if(NewStoreLocation == storeCAF){
        NewStoreLocation = 'Canada French';
    }

    return {PreviousStoreLocation,NewStoreLocation};   
}

function storeCurrencyLocate(storeLanguage){
    let storeCurrency = currencyCodeUSA;
    if(storeLanguage == storeUSA){
        storeCurrency = currencyCodeUSA;
    }
    if(storeLanguage == storeCA || storeLanguage == storeCAF){
        storeCurrency = currencyCodeCanada;
    }

    return storeCurrency;
}

function invokeGoogleAnalyticsService(requestSource, requestData){
    console.log('Service Component called noew');

    //CLose Covid banner
    if(requestSource == 'CLOSEXMARKBANNER'){
        let messageContext = createMessageContext();
        console.log(' << Inside close X mark Banner event >> ');
        let currUserId = getUserID();
        let messagectx = {
            eventName: "Close Click",
            message: "INTENDING TO CLOSE THE X MARK BANNER HEADER",
            eventSource: 'CLOSEXMARKBANNER',
            eventData: { EventCategory : "Close X mark banner" , userId : currUserId}
        };  
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
       
     
    }

    //Accept Cookies
    if(requestSource == 'ACCEPT COOKIES'){
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        console.log(' << Inside Accept Cookies event >> ');
        let messagectx = {
            eventName: "Accept Click",
            message: "INTENDING TO ACCEPT COOKIES",
            eventSource: "ACCEPT COOKIES",
            eventData: { EventCategory : "Accept Cookies" , userId : currUserId}
        };  
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
     
    }

    //ESN Search
    if(requestSource == 'ESN SEARCH'){
        console.log(' << Inside Esn Search Event >>');
        if(requestData != ''){
            let messageContext = createMessageContext();
            console.log('ESN requestData > ' + requestData);

            let currUserId = getUserID();

            let messagectx = {
                eventName: 'search',
                message: "INTENDING TO CAPTURE ESN SEARCH QUERY",
                eventSource: requestSource,
                eventData: { ESNSearchQuery: JSON.stringify(requestData) , userId : currUserId}
            }; 
            console.log('messagectx esn  > ' + JSON.stringify(messagectx));    
       

            callPublishMethod(messageContext, AnalyticsChannel, messagectx);
                    
        }
    }

    //Waranty Information Footer link click
    if(requestSource == 'WARRANTY INFORMATION FOOTER LINK CLICK'){
        console.log(' << Inside Waranty information footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "warranty information page",
            message: "INTENDING TO NAVIGATE TO WARANTY INFORMATION PAGE",
            eventSource: "WARRANTY INFORMATION FOOTER LINK CLICK",
            eventData: { EventCategory : requestData ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    }

    //contact us Footer link click
    if(requestSource == 'CONTACT US FOOTER LINK CLICK'){
        console.log(' << Inside contact us footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "Contact Us page",
            message: "INTENDING TO NAVIGATE TO CONTACT US PAGE",
            eventSource: "CONTACT US FOOTER LINK CLICK",
            eventData: { EventCategory : requestData ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);              
    }

    //contact us send us your questions link click
    if(requestSource == 'SEND US YOUR QUESTIONS'){
        console.log(' << Inside send questions footer link click event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        let messagectx = {
            eventName: "send us your questions click",
            message: "INTENDING TO NAVIGATE TO CONTACT US PAGE",
            eventSource: "SEND US YOUR QUESTIONS",
            eventData: { EventCategory : requestData ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);              
    }

    //Locations Footer link click
    if(requestSource == 'LOCATIONS FOOTER LINK CLICK'){
        console.log(' << Inside locations footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "Locations page",
            message: "INTENDING TO NAVIGATE TO LOCATIONS PAGE",
            eventSource: "LOCATIONS FOOTER LINK CLICK",
            eventData: { EventCategory : requestData ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    }    

    //FAQ Footer link click
    if(requestSource == 'FAQ FOOTER LINK CLICK'){
        console.log(' << Inside FAQ footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "FAQ page",
            message: "INTENDING TO NAVIGATE TO FAQ PAGE",
            eventSource: "FAQ FOOTER LINK CLICK",
            eventData: { EventCategory : requestData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    }  

    //Return & Refund Footer link click
    if(requestSource == 'RETURNREFUND FOOTER LINK CLICK'){
        console.log(' << Inside Return & Refund footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "Return & Refund page",
            message: "INTENDING TO NAVIGATE TO RETURN REFUND PAGE",
            eventSource: "RETURNREFUND FOOTER LINK CLICK",
            eventData: { EventCategory : requestData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    } 
    
    //shipping policy Footer link click
    if(requestSource == 'SHIPPING POLICY FOOTER LINK CLICK'){
        console.log(' << Inside shipping policy footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "shipping policy page",
            message: "INTENDING TO NAVIGATE TO SHIPPING POLICY PAGE",
            eventSource: "SHIPPING POLICY FOOTER LINK CLICK",
            eventData: { EventCategory : requestData ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    }   
    
    //core policy Footer link click
    if(requestSource == 'CORE POLICY FOOTER LINK CLICK'){
        console.log(' << Inside core policy footer link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "core policy page",
            message: "INTENDING TO NAVIGATE TO CORE POLICY PAGE",
            eventSource: "CORE POLICY FOOTER LINK CLICK",
            eventData: { EventCategory : requestData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);      
        
    }      

    //Capture store toggling
    if(requestSource == 'STORE TOGGLE'){
        console.log(' << Inside store toggle click event >> ');
        let messageContext = createMessageContext();  
        let requestEventName;
        if(requestData.previousStore != null && requestData.previousStore != undefined && 
            requestData.previousStore != '' &&  requestData.NewStore != null && 
            requestData.NewStore != undefined && requestData.NewStore != ''){
                let returnModifiedStoreData = storeCountryDeterMine(requestData.previousStore , requestData.NewStore);
                console.log('returnModifiedStoreData > ' + returnModifiedStoreData);
                requestEventName = returnModifiedStoreData.PreviousStoreLocation + ' To ' + returnModifiedStoreData.NewStoreLocation; 
                console.log('requestEventName > ' + requestEventName);
                let currUserId = getUserID();
                let messagectx = {
                    eventName: requestEventName,
                    message: "INTENDING TO NAVIGATE TO ANOTHER STORE",
                    eventSource: "STORE TOGGLE",
                    eventData: { EventCategory : "Store Toggle", userId : currUserId}
                }; 
                console.log('messagectx in store tog > ' + JSON.stringify(messagectx));
                callPublishMethod(messageContext, AnalyticsChannel, messagectx);             
            }
            
              
                    
    }   

    //Capture Sign up link click event
    if(requestSource == 'SIGN UP LINK CLICK'){
        console.log(' << Inside Sign Up link click event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        let messagectx = {
            eventName: "Sign Up link click",
            message: "INTENDING TO CATURE SIGN UP CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : requestData.category, EventLabel : requestData.email , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);          
    } 
    
    //Capture chat link click event
    if(requestSource == 'CHAT LINK CLICK'){
        console.log(' << Inside Chat link click event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        let messagectx = {
            eventName: "Chat link click",
            message: "INTENDING TO CAPTURE CHAT CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : requestData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);              
    }    

    //capture SignIn link click event
    if(requestSource == 'SIGNIN LINK CLICK'){
        console.log(' << Inside signin link click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: "login",
            message: "INTENDING TO CAPTURE SIGN-IN LINK CLICK EVENT",
            eventSource: requestSource,
            eventData: { method : requestData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);     
    } 
    
    //Capture Product details when arrive on PDP Page
    if(requestSource == 'LAND ON PRODUCT DETAIL PAGE'){
        console.log(' << Inside pdp page landing event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();

        if(requestData.currenctproductdetails != null && requestData.currenctproductdetails != undefined && requestData.currenctproductdetails != ''){
            let productid, productName;
            let inventorystatus = 'Out of Stock';
            let inventoryqty = 0;
            let ProductPrice;
            productid = requestData.currenctproductdetails[0].sfid;
            productName = requestData.currenctproductdetails[0].sfdcName;
            let  galistnaming = requestData.galistname;
            if(requestData.currenctproductinventory != null & requestData.currenctproductinventory != undefined){
                inventorystatus = requestData.currenctproductinventory[0].invStockData;
                inventoryqty = requestData.currenctproductinventory[0].quantityInInv;

            }else{
                inventoryqty = '0';
                inventorystatus = 'unknown';
            }

            if(requestData.currencyproductprice != null && requestData.currencyproductprice != undefined && requestData.currencyproductprice != ''){
                ProductPrice = requestData.currencyproductprice;
            }else{
                ProductPrice = '0';
            }

            let currenctProdData = {productIdData : requestData.currenctproductdetails[0].SKU, /*CECI-958 GTM Events*/
                                    productPriceData : ProductPrice, 
                                    productInventoryStatus : inventorystatus, 
                                    productInventoryQuantity : inventoryqty,
                                    galistname: galistnaming, 
                                    currproductName : productName,
                                    productBrand : requestData.currenctproductdetails[0].brandName,/*CECI-958 GTM Events*/
                                    productCategory : requestData.currenctproductdetails[0].categoryName/*CECI-958 GTM Events*/
                                };

            let messagectx = {
                eventName: "Pdp page Product Data",
                message: "INTENDING TO CAPTURE PRODUCT DATA ON PDP PAGE AFTER LANDING",
                eventSource: requestSource,
                eventData: { productData : currenctProdData , userId : currUserId}
            };
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);
            
        }
    }

    //capture product clicks on checkboxes in FBPs
    if(requestSource == 'FREQUENTLY BOUGHT PRODUCTS SELECTION'){
        console.log(' << Inside FGP products select deselect event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        let currentEventoperation = requestData.FGPoperation;
        let currentProductName = requestData.FGPproductName;
        let currentProductPrice = requestData.FGPProductPrice;

        let feedData = {eventCategory : 'Frequently bought together - Product click' ,
                        eventProductName  : currentProductName,
                        eventProductPrice : currentProductPrice,
                        };

        let messagectx = {
            eventName: "Frequently bought together - Product " + currentEventoperation,
            message: "INTENDING TO SELECT/DESELECT FGP PRODUCTS",
            eventSource: requestSource,
            eventData: { FGPFeed : feedData , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
    }

    //capture Notify Me product & email
    if(requestSource == 'NOTIFY ME WHEN IN STOCK'){
        console.log(' << Inside notify me click event >> ');
        let messageContext = createMessageContext();
        let currUserId = getUserID();
        let feed = {userEmail : requestData.Email, 
                    eventCategory : 'Notify Me when back in stock'};
        
        let messagectx = {
            eventName: requestData.ProductName,
            message: "INTENDING TO NOTIGY ME PRODUCT & EMAIL",
            eventSource: requestSource,
            eventData: { dataFeed : feed , userId : currUserId}
        }; 

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);    

    }

    //Add to Wishlist
    if(requestSource == 'ADD TO WISHLIST'){
        console.log(' << Inside add to wishlist event >> ');
        let messageContext = createMessageContext();        
        let currUserId = getUserID();

        if(requestData.currenctproductdetails != null && requestData.currenctproductdetails != undefined && requestData.currenctproductdetails != ''){
            let productid;
            let inventorystatus = 'Out of Stock';
            let inventoryqty = 0;
            let ProductPrice;
            productid = requestData.currenctproductdetails[0].sfid;
            let productName = requestData.currenctproductdetails[0].sfdcName;

            if(requestData.currenctproductinventory != null & requestData.currenctproductinventory != undefined){
                inventorystatus = requestData.currenctproductinventory[0].invStockData;
                inventoryqty = requestData.currenctproductinventory[0].quantityInInv;

            }else{
                inventoryqty = 'unknown';
                inventorystatus = 'unknown';
            }

            if(requestData.currencyproductprice != null && requestData.currencyproductprice != undefined && requestData.currencyproductprice != ''){
                ProductPrice = requestData.currencyproductprice;
            }else{
                ProductPrice = 'unknown';
            }

            let currenctProdData = {productIdData : productName, 
                                    productPriceData : ProductPrice, 
                                    productInventoryStatus : inventorystatus, 
                                    productInventoryQuantity : inventoryqty, 
                                    currproductName : productName};

            let messagectx = {
                eventName: "add_to_wishlist",
                message: "INTENDING ADD PRODUCT TO WISHLIST",
                eventSource: requestSource,
                eventData: { dataFeed : currenctProdData, userId : currUserId }
            };
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);
            
        }
 
    }

    //product clicked on search page
    if(requestSource == 'SEARCH PAGE PRODUCT CLICKED'){
        console.log(' << Inside search page product click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: 'select_content',
            message: "INTENDING TO CAPTURE SEARCH PRODUCT CLICK",
            eventSource: requestSource,
            eventData: { dataFeed : requestData , userId : currUserId}
        }; 

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);         
    }

    if(requestSource == 'ON PRODUCT CLICK EVENT'){
        console.log(' << Inside search page product click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: 'select_content',
            message: "INTENDING TO CAPTURE SEARCH PRODUCT CLICK",
            eventSource: requestSource,
            eventData: { dataFeed : requestData , userId : currUserId}
        }; 

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);         
    }

    

    //User clicked on product
    if(requestSource == 'USER CLICKED ON PRODUCT'){
        console.log(' << Inside user product click event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let messagectx = {
            eventName: 'select_content',
            message: "INTENDING TO USER PRODUCT CLICK",
            eventSource: requestSource,
            eventData: { dataFeed : requestData, userId : currUserId}
        }; 
        console.log('JI > ' + JSON.stringify(messagectx));
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);         
    }    

    //search data returned for search string
    if(requestSource == 'SEARCH DATA RETURNED'){
        console.log(' << Inside search data returned on search page event >> ');
        let messageContext = createMessageContext();

        let currUserId = getUserID();

        let currentsearchKey = requestData.searchKey;
        let productdata = requestData.dataReturned;
        let currencycode = requestData.currencycode
        let combinedItems = [];
        if(productdata != null && productdata != '' && productdata != undefined){
            if(productdata.length > 0){
                let counter = 1;
                productdata.forEach(productelement => {
                    let eachItem = { 
                        "name": productelement.sfdcName,
                        "id": productelement.SKU,/*CECI-958 GTM Events*/
                        "price": productelement.gtmPrice,/*CECI-958 GTM Events*/
                        "list": "Search key - " + currentsearchKey,
                        "brand": productelement.ProductBrand,                        
                        "category": productelement.ProductCategory,
                        "variant" :  productelement.ProductCategory,
                        "position": counter,                                                                 
                    }
                    counter += 1;
                    combinedItems.push(eachItem);
                });
    
                console.log('combinedItems > ' + combinedItems);
                console.log('combinedItems size > ' + combinedItems.length);
    
                let messagectx = {
                    eventName: 'search data product impression',
                    message: "INTENDING TO CAPTURE SEARCH PRODUCT DATA LIST",
                    eventSource: requestSource,
                    eventData: { dataFeed : combinedItems ,currency : currencycode,userId : currUserId}
                };         
                
                callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    
            }
        }
    }    
    
    //search page sorting
    if(requestSource == 'PAGE SORTING'){
        console.log(' << Inside search data returned on search page event >> ');
        let messageContext = createMessageContext();
        
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.sortType,
            message: "INTENDING TO CAPTURE SEARCH PAGE SORTING CLICKS",
            eventSource: requestSource,
            eventData: { eventCategory : 'SortFilter' , eventLabel :  requestData.page, userId : currUserId}
        }; 

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    }

    //subcategory link click
    if(requestSource == 'SUBCATEGORY LINK CLICK'){
        console.log(' << Inside subcategory link click event >> ');
        let messageContext = createMessageContext();  

        let currUserId = getUserID();
        
        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE SUBCATEGORY CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', EventLabel : 'subcategory click event' ,userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
        

    }

    //currentPromotions page link click
    if(requestSource == 'NAVIGATE TO CURRENT PROMOTION PAGE'){
        console.log(' << Inside current Promotion link click event >> ');
        let messageContext = createMessageContext();  
                
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE CURRENT PROMOTION CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);             
    }

    //Purchase page navigation link click
    if(requestSource == 'NAVIGATE TO PURCHASE POLICY PAGE'){
        console.log(' << Inside Purchase page link click event >> ');
        let messageContext = createMessageContext();  
                
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE NAVIGATION TO PURCHASE PAGE CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);             
    }

    //shop all recently viewed products button click
    if(requestSource == 'NAVIGATE TO RECENTLY VIEWED PRODUCTS PAGE'){
        console.log(' << Inside recently view page click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE BUTTON CLICK EVENT FOR RECENTY VIEWED PAGE",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);             
    }    

    //navigate to shopBybrand page
    if(requestSource == 'NAVIGATE TO SHOP BY BRAND PAGE'){
        console.log(' << Inside nav shopby brand page click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData + ' brand',
            message: "INTENDING TO CAPTURE BUTTON CLICK EVENT FOR NAVIGATING TO SHOP BY BRAND PAGE",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation' , EventLabel : 'Shopby Brand page', userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
    }

    //capture products on the shopby brand page
    if(requestSource == 'BRAND DATA RETURNED'){
        console.log(' << Inside nav shopby brand product capture click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let currency = requestData.currency;
        let currenctData = requestData.ProductFeed;
        console.log('DDDD >' + JSON.stringify(requestData));
        let productdata = [];
        if (currenctData.length > 0) {
            let counter = 1;
            currenctData.forEach(element => {
                let eachItem = {
                    "id": element.SKU, /* Sasikanth CECI - 958 GTM Events */
                    "name": element.sfdcName, /* Sasikanth CECI - 958 GTM Events */
                    "list": requestData.categoryName + ' Brand Page',
                    "brand": requestData.categoryName,
                    "category": '',
                    "variant": '',
                    "position": counter,                    
                    "price": element.price.slice(element.price.indexOf("$")+1, element.price.length) /* Sasikanth CECI - 958 GTM Events */
                }
                counter += 1;
                productdata.push(eachItem);
            });

            console.log('productdata > ' + JSON.stringify(productdata));

            let messagectx = {
                eventName: 'branddata',
                message: "INTENDING TO CAPTURE SHOPBY BRAND PRODUCT DATA LIST",
                eventSource: requestSource,
                eventData: { dataFeed: productdata , currencycd : currency ,userId : currUserId}
            };

            callPublishMethod(messageContext, AnalyticsChannel, messagectx);
        }
    }

    //capture the products in the categories page
    if(requestSource == 'CATEGORY DATA RETURNED'){
        console.log(' << Inside nav category page product capture click event >> ');
        let messageContext = createMessageContext();   
        let currUserId = getUserID();

        console.log('parent category > ' + requestData.parentCategory);
        console.log('data > ' + JSON.stringify(requestData.dataReturned));
        let parentCategory = requestData.parentCategory;
        let currency = requestData.currency;
        let data = requestData.dataReturned;
        let productfeed = [];

        if(data.length > 0){
            let counter = 1;
            data.forEach(element => {

                let inventoryStus = 'Out of Stock';
                if(element.inventoryQuantity > 0){
                    inventoryStus = 'In Stock';
                }

                let eachItem = {
                    "name": element.sfdcName,
                    "id": element.SKU,                       /* Sasikanth CECI - 958 GTM Events */
                    "price": JSON.stringify(element.price),  /* Sasikanth CECI - 958 GTM Events */                  
                    "list": parentCategory + ' Category Page',
                    "variant": parentCategory,
                    "position": counter,                    
                    "brand": "",
                    "category": parentCategory,                                                         
                }
                counter += 1;
                productfeed.push(eachItem);
            });

            console.log('productfeed > ' + productfeed);
            console.log('productfeed size > ' + productfeed.length);

            let messagectx = {
                eventName: 'category data',
                message: "INTENDING TO CAPTURE CATEGORY PAGE PRODUCT DATA LIST",
                eventSource: requestSource,
                eventData: { dataFeed : productfeed ,currencycd : currency, userId : currUserId}
            };         
            
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);            

        }
    }

    //deals data returned CECI-990
    if(requestSource == 'DEALS DATA RETURNED'){
        console.log(' << Inside nav category page product capture click event >> ');
        let messageContext = createMessageContext();   
        let currUserId = getUserID();

        console.log('parent category > ' + requestData.parentCategory);
        console.log('data > ' + JSON.stringify(requestData.dataReturned));
        let parentCategory = requestData.parentCategory;
        let currency = requestData.currency;
        let data = requestData.dataReturned;
        let productfeed = [];

        if(data.length > 0){
            let counter = 1;
            data.forEach(element => {

                let inventoryStus = 'Out of Stock';
                if(element.inventoryQuantity > 0){
                    inventoryStus = 'In Stock';
                }

                let eachItem = {
                    "name": element.productName,
                    "id": element.SKU,                       /* Sasikanth CECI - 958 GTM Events */
                    "price": JSON.stringify(element.price),  /* Sasikanth CECI - 958 GTM Events */                   
                    "list": parentCategory + ' Category Page',
                    "variant": parentCategory,
                    "position": counter,                    
                    "brand": "",
                    "category": parentCategory,                                                         
                }
                counter += 1;
                productfeed.push(eachItem);
            });

            console.log('productfeed > ' + productfeed);
            console.log('productfeed size > ' + productfeed.length);

            let messagectx = {
                eventName: 'category data',
                message: "INTENDING TO CAPTURE CATEGORY PAGE PRODUCT DATA LIST",
                eventSource: requestSource,
                eventData: { dataFeed : productfeed ,currencycd : currency, userId : currUserId}
            };         
            
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);            

        }
    }

    //category link click
    if(requestSource == 'CATEGORY LINK CLICK'){
        console.log(' << Inside category link click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE CATEGORY CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', EventLabel : 'category click event' , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
        

    }  

    //deals link click CECI-990
    if(requestSource == 'DEALS LINK CLICK'){
        console.log(' << Inside deals link click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE DEALS CLICK EVENT",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation', EventLabel : 'deals click event' , userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
        

    }  
    
    //crossell products for currenct product on PDP page
    if(requestSource == 'CROSSSELL PRODUCTS ON PDP PAGE'){
        console.log(' << Inside crossell products click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let loc = requestData.locationd;
        if(loc == 'US'){
            loc = 'USD';
        }else if(loc == 'EN' || loc == 'FR' || loc == 'CA'){
            loc = 'CAD';
        }        

        let incomingData = requestData.crossellFeed;
        let mainpro = requestData.mainProduct;
        if(incomingData != null && incomingData != undefined && incomingData != ''){
            
            if(incomingData.length > 0){                
                let crossellProductFeed = [];
                let counter = 1;
                incomingData.forEach(element => {
                    console.log('element > ' + JSON.stringify(element));
                    if(element.productType == 'CrossSell'){
                        let eachItem = {
                            "id": element.Name,
                            "name": element.Name,
                            "list": "CrossSell Product list",
                            "position": counter,
                            "price": element.price                    
                        } 
                        crossellProductFeed.push(eachItem);      
                        counter += 1;                  
                    }
                                       
                });
                
                let messagectx = {
                    eventName: 'CrossSell Product list',
                    message: "INTENDING TO CAPTURE CATEGORY CLICK EVENT",
                    eventSource: requestSource,
                    eventData: {datafeed : crossellProductFeed, location : loc, userId : currUserId}
                };
                
                callPublishMethod(messageContext, AnalyticsChannel, messagectx);                    
                
            }

        }
        /*
        else{
            let crossellProductFeeder = [];

            let messagectx = {
                eventName: 'CrossSell Product list',
                message: "INTENDING TO CAPTURE CATEGORY CLICK EVENT",
                eventSource: requestSource,
                eventData: {datafeed : crossellProductFeeder, userId : currUserId}
            };
            
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);               

        }*/

    }

    //Related products for currenct product on PDP page
    if(requestSource == 'RELATED PRODUCTS ON PDP PAGE'){
        console.log(' << Inside related products click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let incomingData = requestData.relatedFeed;
        let mainpro = requestData.mainProduct;
        let loc = requestData.locationd;

        if(incomingData != null && incomingData != undefined && incomingData != ''){
            
            if(incomingData.length > 0){                
                let relatedProductFeed = [];
                let counter = 1;
                incomingData.forEach(element => {
                    console.log('element > ' + JSON.stringify(element));
                    if(element.productType == 'Related'){
                        let eachItem = {
                            "id": element.Name,
                            "name": element.Name,
                            "list": "Related Product list",
                            "position": counter,                   
                            "price": element.price                    
                        } 
                        relatedProductFeed.push(eachItem);      
                        counter += 1;                  
                    }
                                       
                });
                
                let messagectx = {
                    eventName: 'Related Product list',
                    message: "INTENDING TO CAPTURE CATEGORY CLICK EVENT",
                    eventSource: requestSource,
                    eventData: {datafeed : relatedProductFeed, location : loc ,userId : currUserId}
                };
                
                callPublishMethod(messageContext, AnalyticsChannel, messagectx);                    
                
            }

        }else{
            let relatedProductFeeder = [];

            let messagectx = {
                eventName: 'Related Product list',
                message: "INTENDING TO CAPTURE CATEGORY CLICK EVENT",
                eventSource: requestSource,
                eventData:  {datafeed : relatedProductFeeder, userId : currUserId}
            };
            
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);               

        }

    }    
    
    //Add to cart PDP page
    if(requestSource == 'ADD TO CART'){
        console.log(' << Inside add to cart click event >> ');
        let messageContext = createMessageContext(); 
        let currUserId = getUserID();        
        
        let storeCurrency = storeCurrencyLocate(requestData.storeLanguage);
        let requestFeed = {
            ProductType : requestData.ProductType, 
            unitPrice : requestData.unitPrice, 
            quantity : requestData.quantity, 
            Name : requestData.Name, 
            id : requestData.id, 
            storeLanguage : requestData.storeLanguage,
            storeCountry : requestData.storeCountry, 
            storeCurrency : storeCurrency,
            cartOperation : requestData.cartOperation,
            originalPrice : requestData.originalProductPrice, 
            cartId : requestData.cartId,
            Brand : requestData.Brand,/*CECI-958 GTM Events*/
            Category : requestData.Category,/*CECI-958 GTM Events*/
        };
        console.log('actual price > ' + requestData.originalProductPrice);
        if((requestData.originalProductPrice) != null && (requestData.originalProductPrice)!= '' && (requestData.originalProductPrice) != undefined){
            requestFeed.ProductType = 'Promotional Product';          
        }

        let messagectx = {
            eventName: 'addToCart',
            message: "INTENDING TO ADD TO CART CLICK EVENT",
            eventSource: requestSource,
            eventData: {datafeed : requestFeed , userId : currUserId}
        };
        
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);    

    }

    //Add to carT frequently bgt products
    if(requestSource == 'FREQUENTLY BOUGHT ADD TO CART'){
        console.log(' << Inside add to cart click event >> ');
        let messageContext = createMessageContext(); 
        let currUserId = getUserID();         

        console.log('kac > ' + JSON.stringify(requestData));
        let productIDmap = requestData.proIdMap;
        console.log('productIDmap > ' + productIDmap);
        let productpricemap = requestData.proPriceMap;
        console.log('productpricemap > ' + productpricemap);
        let freqBgtprodtoadd =  Array.from(productpricemap.keys());;
        console.log('freqBgtprodtoadd > ' + JSON.stringify(freqBgtprodtoadd));
        let storecrty  = requestData.country;
        console.log('storecrty > ' + storecrty);
        let storelang  = requestData.lang;
        console.log('storelang > ' + storelang);
        let storeCurrency = storeCurrencyLocate(storelang);
        console.log('storeCurrency > ' + storeCurrency);
        console.log('freqBgtprodtoadd > ' + freqBgtprodtoadd.length);
        
        if(freqBgtprodtoadd.length > 0){
            let finalProductList = [];
            freqBgtprodtoadd.forEach(element => {
                let price;
                let name;
                console.log('element > ' + element);
                console.log('productIDmap.has(element) > ' + productIDmap.has(element));
                
                if(productIDmap.has(element)){
                    name = productIDmap.get(element);
                    console.log('name > ' + name);
                    
                }
                console.log('productpricemap.has(element) > ' + productpricemap.has(element));
                if(productpricemap.has(element)){
                    price = productpricemap.get(element);
                    console.log('price > ' + price);
                }
                
                let word = {
                    'id' : name,
                    'price' : price,
                    'name' : name,                   
                    'variant' : 'Frequently Bought Product',
                    'quantity' : 1,
                    'brand': '',
                    'category': ''
                }
                console.log('word > ' + JSON.stringify(word));
                finalProductList.push(word);
            });

            let messagectx = {
                eventName: 'addToCartFrequentlybgtproducts',
                message: "INTENDING TO ADD TO CART FREQ BGT PRODDUCTS CLICK EVENT",
                eventSource: requestSource,
                eventData: {productList : finalProductList, currency : storeCurrency, userId : currUserId}
            };
            console.log('vac > ' + JSON.stringify(finalProductList));
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);                

        }

    }

    //navigate to Cart page
    if(requestSource == 'NAVIGATE TO CART PAGE'){
        console.log(' << Inside nav shopby brand page click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE NAVIGATION TO CART PAGE",
            eventSource: requestSource,
            eventData: { EventCategory : 'Page Navigation' , EventLabel : 'Cart Page', userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);           
    }    
    
    if(requestSource == 'RETURNED CART DETAILS ON CART PAGE'){
        console.log(' << Inside nav shopby brand page click event >> ');
        let messageContext = createMessageContext();        
    }

    if(requestSource == 'PROCEED TO CHECKOUT BUTTON CLICK'){
        console.log(' << Inside nav proceed to check out click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        console.log('requestData > '  + JSON.stringify(requestData));
        if(requestData != null && requestData != undefined && requestData != ''){
            if(requestData.length > 0 ){ 
                console.log('requestData.lstCartItem > '  + JSON.stringify(requestData[0].lstCartItem));           
                   if(requestData[0].lstCartItem != null && requestData[0].lstCartItem != undefined && requestData[0].lstCartItem != ''){
                    let proddet = requestData[0].lstCartItem;    
                    if(proddet.length > 0){
                            let finalproductlist = [];
                                                        
                            proddet.forEach(element => {

                                let prodcat = ''
                                if(element.cartItemProductDetailWrapper.dbuCrateEngine){
                                    prodcat = 'crateengine';
                                }

                                let eachprod = {
                                    'name': element.cartItemProductDetailWrapper.sfdcName,
                                    'id': element.cartItemProductDetailWrapper.sfdcName,
                                    'price': element.cartItem.formatedUnitPrice,
                                    'brand': '',
                                    'category': prodcat,
                                    'variant': '',
                                    'quantity': element.cartItem.ccrz__Quantity__c
                                }
                                finalproductlist.push(eachprod);
                            });
                            console.log('finalproductlist > ' + JSON.stringify(finalproductlist))
                            let messagectx = {
                                eventName: 'checkout',
                                message: "INTENDING TO CAPTURE PROCEED TO CHECKOUT BUTTON CLICK",
                                eventSource: requestSource,
                                eventData: { datafeed : finalproductlist, userId : currUserId}
                            };   
                            callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
                        }
                   }                 
            }
        }

          
    }

    if(requestSource == 'REMOVE FROM CART'){
        console.log(' << Inside nav proceed to check out click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let storeLang  = requestData.storeLanguage;
        let storecurr =  storeCurrencyLocate(storeLang);
        
        let proddeledetail = [];
        let ju = {                          
            'name': requestData.productname,
            'id': requestData.productid,  /* Sasikanth CECI-958 GTM Events */
            'price': requestData.productprice,
            'brand': requestData.Brand,/*CECI-958 GTM Events*/
            'category': requestData.Category,/*CECI-958 GTM Events*/
            'variant': requestData.producttype, /*CECI-958 GTM Events*/
            'quantity': requestData.productqty    /*CECI-958 GTM Events*/     
        }
        proddeledetail.push(ju);

        let messagectx = {
            eventName: 'Remove cart product',
            message: "INTENDING TO ADD TO CART FREQ BGT PRODDUCTS CLICK EVENT",
            eventSource: requestSource,
            eventData: {productList : proddeledetail, currency : storecurr, userId : currUserId}
        };
       
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);

    }
    
    if(requestSource == 'CHANGE PRODUCT QUANTITY'){
        console.log(' << Inside change Quantity click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let data = {
            eventCategory : 'select product quantity',
            eventlabel : requestData.ProductName,
            value : requestData.productQuantity,            
        };

        let messagectx = {
            eventName: requestData.pageName,
            message: "INTENDING TO CAPTURE CHANGE IN PRODUCT QUANTITY CLICK",
            eventSource: requestSource,
            eventData: { datafeed : data , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);            
 
    }

    if(requestSource == 'CANCEL CLICKS'){
        console.log(' << Inside change Quantity click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.eventname,
            message: "INTENDING TO CAPTURE CLICKS ON CANCEL BUTTON",
            eventSource: requestSource,
            eventData: { EventCategory : 'cancel click' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);            
        
    }

    if(requestSource == 'OPEN MODALS'){
        console.log(' << Inside change Quantity click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.eventname,
            message: "INTENDING TO CAPTURE CLICKS ON CANCEL BUTTON",
            eventSource: requestSource,
            eventData: { EventCategory : 'open modal on click' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);            
        
    }

    
    if(requestSource == 'CONTINUE SHOPPING CLICKS'){
        console.log(' << Inside Continue shopping click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.eventname,
            message: "INTENDING TO CAPTURE CLICKS ON CONTINUE SHOPPING BUTTON",
            eventSource: requestSource,
            eventData: { EventCategory : 'continue shopping click' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }

    if(requestSource == 'NAVIGATE TO URL LINKS'){
        console.log(' << Inside navigate url links click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData,
            message: "INTENDING TO CAPTURE URL LINK CLICKS",
            eventSource: requestSource,
            eventData: { EventCategory : 'URL Link Click' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }

    if(requestSource == 'ADD TO SAVEFORLATER'){
        console.log(' << Inside add to save for later click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        if(requestData.datafeed != '' && requestData.datafeed != undefined && requestData.datafeed != null){
            let saveforlaterdata = requestData.datafeed;
            let resppage = requestData.page;
            let productdataList = [];
            saveforlaterdata.forEach(element => {                
                console.log('element > ' + JSON.stringify(element));
                let pKind;
                if(element.cartItemProductDetailWrapper.availableToShip == true && 
                    element.cartItemProductDetailWrapper.pickUpOnly == false
                    ){
                        pKind = 'Ship Only products';         
                }else if(element.cartItemProductDetailWrapper.availableToShip == false && 
                    element.cartItemProductDetailWrapper.pickUpOnly == true
                    ){
                        pKind = 'PickUp products';          
                }else if(element.cartItemProductDetailWrapper.availableToShip == false && 
                    element.cartItemProductDetailWrapper.pickUpOnly == false
                    ){
                        pKind = 'shipable-pickable products';         
                }
                 
                let eachproductData = {
                    "name" : element.cartItemProductDetailWrapper.sfdcName,
                    "id" : element.cartItemProductDetailWrapper.sfdcName,
                    "variant" : pKind,
                    "price" : element.cartItem.ccrz__Price__c
                };                
                productdataList.push(eachproductData);
   
            });

            console.log('productdataList > ' + JSON.stringify(productdataList));

            let messagectx = {
                eventName: 'add to save for later',
                message: "INTENDING TO CAPTURE PRODUCTS ADDED TO SAVE FOR LATER",
                eventSource: requestSource,
                eventData: { dataFeed : productdataList , userId : currUserId, page : resppage}
            };   
    
            callPublishMethod(messageContext, AnalyticsChannel, messagectx);             
        }
        

    }

    if(requestSource == 'STATE OF COUNTRY SELECTED FOR PICKUP'){
        console.log(' << Inside select state for pickup event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.country+ '-' +requestData.state,
            message: "INTENDING TO CAPTURE STATE SELECTED FOR PICKUP",
            eventSource: requestSource,
            eventData: { EventCategory : 'Pickup Country-State selected' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }

    if(requestSource == 'BUTTON CLICK'){
        console.log(' << Inside select ship to or pickup button click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.eventName,
            message: "INTENDING TO CAPTURE BUTTON CLICK",
            eventSource: requestSource,
            eventData: { EventCategory : 'button click' , EventAction : requestData.eventAction, userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }  
    
    if(requestSource == 'EXTERNAL LINK'){
        console.log(' << Inside external link click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: 'Outbound Link click',
            message: "INTENDING TO CAPTURE EXTERNAL LINK CLICK",
            eventSource: requestSource,
            eventData: { EventCategory :  requestData.eventCategory, EventAction : requestData.eventAction, EventLabel : requestData.eventLabel, userId : currUserId}
        };   
        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }    

    if(requestSource == 'ADD ALL TO CART SAVE FOR LATER'){
        console.log(' << Inside add all to cart click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        
        let cartid = requestData.cartid;
        let storeLang = requestData.prostorelang;
        let storecountry = requestData.proStoreCountry;
        let saveforlaterlist = requestData.sfldata;
        let storeCurrency = storeCurrencyLocate(storeLang);
        console.log('storeCurrency > ' + storeCurrency);

        if(saveforlaterlist != '' && saveforlaterlist != null && saveforlaterlist != undefined){
            if(saveforlaterlist.length > 0){
                let finallist =[];
                saveforlaterlist.forEach(element => {                    
                    let eachItem = {
                        'id' : element.ProductName,
                        'price' : element.modifiedPrice,
                        'name' : element.ProductName,                   
                        'variant' : 'add to cart from save for later',
                        'quantity' : 1,
                        'brand': '',
                        'category': ''
                    }
                    finallist.push(eachItem);
                });
                let messagectx = {
                    eventName: 'add all to cart save for later',
                    message: "INTENDING TO CAPTURE EXTERNAL LINK CLICK",
                    eventSource: requestSource,
                    eventData: {productList : finallist, currency : storeCurrency, userId : currUserId}                        
                };  
                callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
            }
        }        
    }   

    if(requestSource == 'ADD TO SFL CART PAGE'){
        console.log(' << Inside add all to cart click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
                
        let saveforlatercartitemlst = requestData.cartitem;
        let saveforlaterproductdetaillst = requestData.proddetail;        
        let resppage = requestData.page;
        let pKind;
        if(saveforlaterproductdetaillst.availableToShip == true && 
            saveforlaterproductdetaillst.pickUpOnly == false
            ){
                pKind = 'Ship Only products';         
        }else if(saveforlaterproductdetaillst.availableToShip == false && 
            saveforlaterproductdetaillst.pickUpOnly == true
            ){
                pKind = 'PickUp products';          
        }else if(saveforlaterproductdetaillst.availableToShip == false && 
            saveforlaterproductdetaillst.pickUpOnly == false
            ){
                pKind = 'shipable-pickable products';         
        }
        let productdataList = [];

        let eachproductData = {
            "name" : saveforlaterproductdetaillst.sfdcName,
            "id" : saveforlaterproductdetaillst.sfdcName,
            "variant" : pKind,
            "price" : saveforlatercartitemlst.ccrz__Price__c
        };  
        productdataList.push(eachproductData);
        console.log('productdataList > ' + JSON.stringify(productdataList));

        let messagectx = {
            eventName: 'add to save for later',
            message: "INTENDING TO CAPTURE PRODUCTS ADDED TO SAVE FOR LATER",
            eventSource: requestSource,
            eventData: { dataFeed : productdataList , userId : currUserId, page : resppage}
        };

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
        

    }
    
    if(requestSource == 'REMOVE FROM SAVEFORLATER'){
        console.log(' << Inside nav proceed to check out click event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let storeLang  = requestData.storeLanguage;
        let storecurr =  storeCurrencyLocate(storeLang);
        
        let proddeledetail = [];
        let ju = {                          
            'name': requestData.name,
            'id': requestData.name,
            'price': requestData.price,         
        }
        proddeledetail.push(ju);

        let messagectx = {
            eventName: 'Remove cart product',
            message: "INTENDING TO ADD TO CART FREQ BGT PRODDUCTS CLICK EVENT",
            eventSource: requestSource,
            eventData: {productList : proddeledetail, currency : storecurr, userId : currUserId}
        };
       
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    }

    if(requestSource == 'ORDER CONFIRMATION'){
        console.log(' << Inside order confirm event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let currencycode = requestData.currencycode;
        let orderdetails = requestData.orderinformation;
        let categorydetails = requestData.categoryinfo;

        let galist = window.localStorage.getItem('CurrentGAlistname');
        if(galist == undefined && galist == null && galist == 'undefined'){
            galist = 'Order Confirm';
        }

        console.log('categorydetails > ' + categorydetails);
        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            if(orderdetails.length > 0){
                let ordername = orderdetails[0].sfdcName;
                let tax = 0;
                let discount = 0;
                let Couponapplied = 'NO';
                console.log('taxing > ' + orderdetails[0].taxAmount);                
                if(orderdetails[0].taxAmount != null && orderdetails[0].taxAmount != undefined){
                    tax = orderdetails[0].taxAmount;
                }     
                if(orderdetails[0].totalDiscount != null && orderdetails[0].totalDiscount != undefined){
                    discount = orderdetails[0].totalDiscount;
                    Couponapplied = 'YES'
                }
                                            
                let shipping =  orderdetails[0].shipAmount;
                let total =  orderdetails[0].totalAmount;
                let finalProductList = [];
                let allitems = orderdetails[0].EOrderItemsS;
                let productlist = orderdetails[0].productlist;               

                if(allitems.length > 0){
                    for(let i=0 ; i<allitems.length ; i++){
                        let pricing = allitems[i].price;
                        let qty = allitems[i].quantity;
                        if(discount > 0){
                            if(allitems[i].quantity > 0){
                                pricing = (allitems[i].subAmount)/qty;
                            }
                        }
                        
                        let productDetail = {
                            "id" : allitems[i].prodId, /*CECI-958 GTM Events*/
                            "name" : '',
                            "price" : JSON.stringify(pricing), /*CECI-958 GTM Events*/
                            "quantity": qty,
                            "variant" : '' ,
                            "brand" : '',
                            "category" : '',
                            "list_name" : galist,
                            "list_position" : i+1                           
                        }

                        finalProductList.push(productDetail);
                    }                    
                }

                if(productlist.length > 0 ){
                    for(let i=0 ; i < productlist.length ; i++){
                        for(let j=0; j < finalProductList.length ; j++){
                            if(productlist[i].sfid === finalProductList[j].id){
                                finalProductList[j].name = productlist[i].sfdcName;
                                finalProductList[j].id = productlist[i].SKU;
                                finalProductList[j].productId = productlist[i].sfid;
                                if(productlist[i].isCoreProduct){
                                    finalProductList[j].variant = 'Core Charge Amount';
                                    finalProductList.splice(j,1);
                                }

                            }
                        }
                    }
                }

                console.log('finalProductList > ' + JSON.stringify(finalProductList));
                if(finalProductList.length > 0 ){
 
                    
                    if(categorydetails.length > 0){
                        for(let i=0 ; i<finalProductList.length ; i++){

                            categorydetails.forEach(element => {
                                if(element.productId === finalProductList[i].productId){
                                    if(element.productBrand != null && element.productBrand != undefined){
                                        finalProductList[i].brand = element.productBrand;                                        
                                    }
                                    if(element.productSubCategory != null && element.productSubCategory != undefined){
                                        finalProductList[i].category = element.productSubCategory;
                                    }
                                }
                            })

                        }
                    }
                    /*CECI-958 GTM Events Removed for loop*/
                    console.log('removed productid = > '  +JSON.stringify(finalProductList));
                    let CombinedOrderDetail = {
                        currorderNumber : ordername,
                        curreordertax : tax,
                        curreordership : shipping,
                        curreordertotal : total,
                        curreorderitems : finalProductList,
                        CurrenctCode : currencycode,
                        curreorderdiscount : Couponapplied
                    };
                    

                    console.log('CombinedOrderDetail > ' + JSON.stringify(CombinedOrderDetail));

                    let messagectx = {
                        eventName: 'purchase',
                        message: "INTENDING TO CAPTURE CONFIRMED ORDER",
                        eventSource: requestSource,
                        eventData: { dataFeed : CombinedOrderDetail , userId : currUserId}
                    };
                    console.log('messagectx > ' + JSON.stringify(messagectx));
                    callPublishMethod(messageContext, AnalyticsChannel, messagectx);                     
                }

            }
        }


    }

    /*
    if(requestSource == 'ORDER CONFIRMATION'){
        console.log(' << Inside order confirm event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let currencycode = requestData.currencycode;
        let orderdetails = requestData.orderinformation;
        //let categorydetails = requestData.categoryinfo;
        console.log('categorydetails > ' + categorydetails);
        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            if(orderdetails.length > 0){
                let ordername = orderdetails[0].sfdcName;
                let tax = '';
                console.log('taxing > ' + orderdetails[0].taxAmount);                
                if(orderdetails[0].taxAmount != null && orderdetails[0].taxAmount != undefined){
                    tax = orderdetails[0].taxAmount;
                }                                 
                let shipping =  orderdetails[0].shipAmount;
                let total =  orderdetails[0].totalAmount;
                let finalProductList = [];
                let allitems = orderdetails[0].EOrderItemsS;
                let productlist = orderdetails[0].productlist;               

                if(allitems.length > 0){
                    for(let i=0 ; i<allitems.length ; i++){
                        let productDetail = {
                            "id" : allitems[i].prodId,
                            "name" : '',
                            "price" : allitems[i].price,
                            "quantity": allitems[i].quantity,
                            "variant" : '' ,
                            "list_name" : 'Order Confirmed',
                            "list_position" : i+1                           
                        }
                        finalProductList.push(productDetail);
                    }                    
                }

                if(productlist.length > 0 ){
                    for(let i=0 ; i < productlist.length ; i++){
                        for(let j=0; j < finalProductList.length ; j++){
                            if(productlist[i].sfid === finalProductList[j].id){
                                finalProductList[j].name = productlist[i].sfdcName;

                                if(productlist[i].isCoreProduct){
                                    finalProductList[j].variant = 'Core Charge Amount';
                                }

                            }
                        }
                    }
                }

                console.log('finalProductList > ' + JSON.stringify(finalProductList));
                if(finalProductList.length > 0 ){

                    for(let i=0 ; i<finalProductList.length ; i++){
                        finalProductList[i].id = finalProductList[i].name;
                    }    
                                                            
                    console.log('removed productid = > '  +JSON.stringify(finalProductList));
                    let CombinedOrderDetail = {
                        currorderNumber : ordername,
                        curreordertax : tax,
                        curreordership : shipping,
                        curreordertotal : total,
                        curreorderitems : finalProductList,
                        CurrenctCode : currencycode
                    };

                    console.log('CombinedOrderDetail > ' + JSON.stringify(CombinedOrderDetail));

                    let messagectx = {
                        eventName: 'purchase',
                        message: "INTENDING TO CAPTURE CONFIRMED ORDER",
                        eventSource: requestSource,
                        eventData: { dataFeed : CombinedOrderDetail , userId : currUserId}
                    };
                    console.log('messagectx > ' + JSON.stringify(messagectx));
                    callPublishMethod(messageContext, AnalyticsChannel, messagectx);                     
                }

            }
        }


    }*/

    if(requestSource == 'CHECKOUT OPTION'){
        console.log(' << Inside nav proceed to check out option event >> ');
        let messageContext = createMessageContext(); 
        let currUserId = getUserID();
        console.log('requestData > ' + JSON.stringify(requestData));

        let actionfield = {
            step : requestData.currenctStep,
            option : requestData.option
        };

        let messagectx = {
            eventName: 'checkoutOption',
            message: "INTENDING TO CAPTURE CHECKOUT OPTION",
            eventSource: requestSource,
            eventData: { datafeed : actionfield, userId : currUserId}
          }; 

          console.log('messagectx > ' + JSON.stringify(messagectx));

          callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    }
    
    if(requestSource == 'ORDER REVIEW CHECKOUT'){
        console.log(' << Inside order review checkout event >> ');
        let messageContext = createMessageContext(); 
        let currUserId = getUserID();
        console.log('requestData > ' + JSON.stringify(requestData));
        if(requestData != null && requestData != undefined && requestData != ''){
          if(requestData.length > 0 ){
            console.log('requestData.lstCartItem > ' + JSON.stringify(requestData[0].lstCartItem));     
              if(requestData[0].lstCartItem != null && requestData[0].lstCartItem != undefined && requestData[0].lstCartItem != ''){
              let proddet = requestData[0].lstCartItem;  
              if(proddet.length > 0){
                  let finalproductlist = [];
                                
                  proddet.forEach(element => {                                    
                    let eachprod = {
                      'name': element.cartItemProductDetailWrapper.sfdcName, 
                      'id': element.cartItemProductDetailWrapper.SKU,        /*CECI-958 GTM Events*/
                      'price': JSON.stringify(element.cartItem.ccrz__Price__c),/*CECI-958 GTM Events*/
                      'brand': element.cartItemProductDetailWrapper.Brandname,/*CECI-958 GTM Events*/
                      'category': element.cartItemProductDetailWrapper.Categoryname,/*CECI-958 GTM Events*/
                      'variant': '',
                      'quantity': element.cartItem.ccrz__Quantity__c
                    }
                    if(element.cartItemProductDetailWrapper.isCoreProduct==false)/*CECI-958 GTM Events*/
                        finalproductlist.push(eachprod);
                  });
                  console.log('finalproductlist > ' + JSON.stringify(finalproductlist))
                  let messagectx = {
                    eventName: 'checkout',
                    message: "INTENDING TO CAPTURE PROCEED TO CHECKOUT BUTTON CLICK",
                    eventSource: requestSource,
                    eventData: { datafeed : finalproductlist, userId : currUserId}
                  }; 
                  callPublishMethod(messageContext, AnalyticsChannel, messagectx);
                }
              }        
          }
        }
         
    }    

    if(requestSource == 'NEXT STEP CHECKOUT DETAILS'){
        console.log(' << Inside nav proceed to check out details click event >> ');
        let messageContext = createMessageContext(); 
        let currUserId = getUserID();
        /*CECI-958 GTM Events start*/
        let currFeedProducts = requestData.dataFeed;
        let finalproductlist = [];
        if(currFeedProducts[0].lstCartItem != null && currFeedProducts[0].lstCartItem != undefined && currFeedProducts[0].lstCartItem != ''){
            let proddet = currFeedProducts[0].lstCartItem;  
            if(proddet.length > 0){                   
                proddet.forEach(element => {                                    
                    let eachprod = {
                      'name': element.cartItemProductDetailWrapper.sfdcName,
                      'id': element.cartItemProductDetailWrapper.SKU,
                      'price': JSON.stringify(element.cartItem.ccrz__Price__c),
                      'brand': element.cartItemProductDetailWrapper.Brandname,
                      'category': element.cartItemProductDetailWrapper.Categoryname,
                      'variant': '',
                      'quantity': element.cartItem.ccrz__Quantity__c
                    }
                    if(element.cartItemProductDetailWrapper.isCoreProduct==false)
                        finalproductlist.push(eachprod);
                });
            }
        }
        /*CECI-958 GTM Events end*/
        let comp = {
            step : requestData.stepnumber,
            option : requestData.optiondata
        }
        let prodData = finalproductlist; /*CECI-958 GTM Events*/

        let messagectx = {
            eventName: 'checkout',
            message: "INTENDING TO CAPTURE CHECKOUTS",
            eventSource: requestSource,
            eventData: { datafeed : comp, userId : currUserId, feed: prodData} /*CECI-958 GTM Events*/
        }; 

        console.log('messagectx > ' + JSON.stringify(messagectx));

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    }

    if(requestSource == 'ORDER RECIEPT CHECKOUT'){
        console.log(' << Inside order recipt checkout event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let currencycode = requestData.currencycode;
        let orderdetails = requestData.orderinformation;
        
        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            if(orderdetails.length > 0){
                let ordername = orderdetails[0].sfdcName;
                let tax =  orderdetails[0].sfdcName;
                let shipping =  orderdetails[0].shipAmount;
                let total =  orderdetails[0].totalAmount;
                let finalProductList = [];
                let allitems = orderdetails[0].EOrderItemsS;
                let productlist = orderdetails[0].productlist;               

                if(allitems.length > 0){
                    for(let i=0 ; i<allitems.length ; i++){
                        let productDetail = {
                            "id" : allitems[i].prodId,
                            "name" : '',
                            "price" : JSON.stringify(allitems[i].price),/*CECI-958 GTM Events*/
                            "quantity" : allitems[i].quantity,
                            "variant" : '' ,                          
                        }
                        finalProductList.push(productDetail);
                    }                    
                }

                if(productlist.length > 0 ){
                    for(let i=0 ; i < productlist.length ; i++){
                        for(let j=0; j < finalProductList.length ; j++){
                            if(productlist[i].sfid === finalProductList[j].id){
                                finalProductList[j].name = productlist[i].sfdcName;
                                finalProductList[j].id = productlist[i].SKU; /*CECI-958 GTM Events*/
                                if(productlist[i].isCoreProduct){
                                    finalProductList[j].variant = 'Core Charge Amount';
                                    finalProductList.splice(j,1); /*CECI-958 GTM Events*/
                                }

                            }
                        }
                    }
                }

                console.log('finalProductList > ' + JSON.stringify(finalProductList));
                if(finalProductList.length > 0 ){
                    /*CECI-958 GTM Events Start*/
                    /*for(let i=0 ; i < finalProductList.length ; i++){
                        finalProductList[0].id = finalProductList[0].SKU;
                    }*/
                    /*CECI-958 GTM Events end*/

                    let CombinedOrderDetail = {
                        currorderNumber : ordername,
                        curreordertax : tax,
                        curreordership : shipping,
                        curreordertotal : total,
                        curreorderitems : finalProductList,
                        CurrenctCode : currencycode
                    };

                    console.log('CombinedOrderDetail > ' + JSON.stringify(CombinedOrderDetail));

                    let messagectx = {
                        eventName: 'checkout',
                        message: "INTENDING TO CAPTURE ORDER RECEIPT CHECKOUT",
                        eventSource: requestSource,
                        eventData: { dataFeed : CombinedOrderDetail , userId : currUserId}
                    };
                    console.log('messagectx > ' + JSON.stringify(messagectx));
                    callPublishMethod(messageContext, AnalyticsChannel, messagectx);                     
                }

            }
        }


    }    

    
    /*if(requestSource == 'TRACK ORDER RESULTS'){
        console.log(' << Inside trackorder event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let currencycode = requestData.currencycode;
        let orderdetails = requestData.orderinformation;
        let orderhistory = requestData.orderhistorydetail;

        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            if(orderdetails.length > 0){
                let ordername = orderdetails[0].sfdcName;
                let tax = '';
                console.log('taxing > ' + orderdetails[0].taxAmount);
                if(orderdetails[0].taxAmount != null && orderdetails[0].taxAmount != undefined){
                    tax = orderdetails[0].taxAmount;
                }                
                let shipping =  orderdetails[0].shipAmount;
                let total =  orderdetails[0].totalAmount;
                let finalProductList = [];
                let allitems = orderdetails[0].EOrderItemsS;
                let productlist = orderdetails[0].productlist;               

                if(allitems.length > 0){
                    for(let i=0 ; i<allitems.length ; i++){
                        let productDetail = {
                            id : allitems[i].prodId,
                            name : '',
                            price : allitems[i].price,
                            quantity : allitems[i].quantity,
                            variant : '',
                            list_name : 'Ordered Product',
                            list_position : i+1                           
                        }
                        if(allitems[i].dbuIsReturned){
                            productDetail.list_name = 'Return product';
                        }
                        finalProductList.push(productDetail);
                    }                    
                }

                if(productlist.length > 0 ){
                    for(let i=0 ; i < productlist.length ; i++){
                        for(let j=0; j < finalProductList.length ; j++){
                            if(productlist[i].sfid === finalProductList[j].id){
                                finalProductList[j].name = productlist[i].sfdcName;

                                if(productlist[i].isCoreProduct){
                                    finalProductList[j].variant = 'Core Charge Amount';
                                }
                            }
                        }
                    }
                }

                console.log('finalProductList > ' + JSON.stringify(finalProductList));
                if(finalProductList.length > 0 ){
                    let CombinedOrderDetail = {
                        currorderNumber : ordername,
                        curreordertax : tax,
                        curreordership : shipping,
                        curreordertotal : total,
                        curreorderitems : finalProductList,
                        CurrenctCode : currencycode,
                        currentorderhistory : orderhistory 
                    };

                    console.log('CombinedOrderDetail > ' + JSON.stringify(CombinedOrderDetail));

                    let messagectx = {
                        eventName: 'purchase',
                        message: "INTENDING TO CAPTURE ORDER HISTORY",
                        eventSource: requestSource,
                        eventData: { dataFeed : CombinedOrderDetail , userId : currUserId}
                    };
                    console.log('messagectx > ' + JSON.stringify(messagectx));
                    callPublishMethod(messageContext, AnalyticsChannel, messagectx);                     
                }

            }
        }

    }*/

    if(requestSource == 'TRACK ORDER RESULTS'){
        console.log(' << Inside trackorder event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let orderdetails = requestData.orderinformation;

        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            if(orderdetails.length > 0){
                let ordername = orderdetails[0].sfdcName;
                                    
                    let messagectx = {
                        eventName: 'Viewed Order',
                        message: "INTENDING TO CAPTURE ORDER HISTORY",
                        eventSource: requestSource,
                        eventData: { dataFeed : ordername , userId : currUserId}
                    };
                    console.log('messagectx > ' + JSON.stringify(messagectx));
                    callPublishMethod(messageContext, AnalyticsChannel, messagectx);                                 
            }
        }        
    }

    if(requestSource == 'TRACK ORDER USER INPUT'){
        console.log(' << Inside trackorder event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let Feed = {
            OrderNumber : requestData.OrderNumber             
        }

        let messagectx = {
            eventName: 'Viewed Order',
            message: "INTENDING TO Order History user input CHECKOUTS",
            eventSource: requestSource,
            eventData: { datafeed : Feed, userId : currUserId}
        }; 

        console.log('messagectx > ' + JSON.stringify(messagectx));

        callPublishMethod(messageContext, AnalyticsChannel, messagectx);        

    }  
    
    if(requestSource == 'STATE COUNTRY FOR PICKUP REFFUND'){
        console.log(' << Inside select state for pickup Refund event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let messagectx = {
            eventName: requestData.country+ '-' +requestData.state,
            message: "INTENDING TO CAPTURE STATE SELECTED FOR PICKUP REFUND",
            eventSource: requestSource,
            eventData: { EventCategory : 'Pickup Country-State selected for refund' , userId : currUserId}
        };   

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
    }    

    if(requestSource == 'REFUND ORDER DETAILS'){
        console.log(' << Inside select state for pickup Refund event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let orderdetails = requestData.orderdata;
        let orderitemdetail = requestData.orderitemdata;
        let Orderrefundamt = requestData.refundamt;
        let ordernumber;
        let currency;
        let ordtotal;
        let Mainorder;
        //console.log('orderdetails > ' + JSON.stringify(orderdetails));
        //console.log('orderitemdetail > ' + JSON.stringify(orderitemdetail));
        if(orderdetails != '' && orderdetails != undefined && orderdetails != null){
            console.log('astrakhan');
            if(orderdetails.length > 0 ){
                console.log('kiro');
                Mainorder = orderdetails[0].sfdcName;
                console.log('Mainorder' + Mainorder);
                //ordernumber = orderdetails[0].cloneOrderAgainstOrgOrderItemMapDetails[0].ClonedorderName;
                //console.log('ordernumber' + ordernumber);
                let cloneorderdetail = orderdetails[0].cloneOrderAgainstOrgOrderItemMap;
                currency = orderdetails[0].currencyISOCode;
                console.log('currency' + currency);
                //ordtotal = orderdetails[0].cloneOrderAgainstOrgOrderItemMapDetails[0].Total;
                ordtotal = Orderrefundamt;
                console.log('inside roman' + ordtotal);
                ordtotal = ordtotal.replace(',','');
                console.log('ordtotal 11> ' + ordtotal);
                ordtotal = ordtotal.replace(/[^.0-9]/g, '');
                console.log('ordtotal 22> ' + ordtotal);
                ordtotal = window.parseFloat(ordtotal);
                console.log('ordtotal 33> ' + ordtotal);                 
                if(orderitemdetail != null && orderitemdetail != undefined && orderitemdetail != ''){
                    if(orderitemdetail.length > 0){
                        let count = 0;
                        let fullList = [];
                        console.log('inside byzantine');
                        orderitemdetail.forEach(element => {
                            let pricing = element.price;
                            pricing = pricing.replace(',','');
                            console.log('pricing > ' + pricing);
                            pricing = pricing.replace(/[^.0-9]/g, '');
                            console.log('pricing 22> ' + pricing);
                            //pricing = window.parseFloat(pricing);
                            console.log('pricing 33> ' + pricing);                            
                            if(element.amtAfterHandlingFee != null && element.amtAfterHandlingFee != undefined){
                                console.log('element.amtAfterHandlingFee > ' + element.amtAfterHandlingFee);
                                pricing = element.amtAfterHandlingFee;
                                pricing = pricing.replace(',','');
                                console.log('pricing 1> ' + pricing);
                                pricing = pricing.replace(/[^.0-9]/g, '');
                                console.log('pricing 2> ' + pricing);
                                //pricing = window.parseFloat(pricing);
                                console.log('pricing 3> ' + pricing);
                            }
                            
                            let detail = {
                                "id": element.sfdcName,
                                "name": element.sku, /*CECI-958 GTM Events*/
                                "list_name": "Return Order",
                                "list_position": count + 1,
                                "quantity": element.quantity,
                                "price": pricing
                            }
                            /*
                            let detail = {
                                "id": element.sfdcName,
                                "quantity": element.quantity,
                            }*/
                            fullList.push(detail);
                            console.log('fullList > ' + JSON.stringify(fullList));
                            if(count === 0){
                                let orderitemid = element.sfid;
                                console.log('orderitemid > ' + orderitemid);
                                console.log('cloneorderdetail > ' + JSON.stringify(cloneorderdetail));
                                ordernumber = cloneorderdetail[orderitemid];
                                console.log('ordernumber' + typeof ordernumber);
                                console.log('ordernumber' + ordernumber);
                            }
                            
                            count += 1;
                        });

                        let datatoSend = {
                            productlisting : fullList,
                            curordername : Mainorder,
                            currcurrency : currency,
                            currTotal : ordtotal
                        };
                        console.log('datatosend ' + JSON.stringify(datatoSend));

                        let messagectx = {
                            eventName: 'refund',
                            message: "INTENDING TO CAPTURE REFUND DATA",
                            eventSource: requestSource,
                            eventData: { dataFeed : datatoSend , userId : currUserId}
                        };                         
                        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
                    }
                }
        }
        }
    }

    if(requestSource == 'ADD ALL TO CART FROM WISHLIST'){
        console.log(' << Inside select state for pickup Refund event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let wishlistitemsdetails = requestData.wishlistitems;
        let productsqtymap = requestData.productstoadd;
        let currencycode = requestData.currencycode;

        if(wishlistitemsdetails != '' && wishlistitemsdetails != undefined && wishlistitemsdetails != null){
            if(wishlistitemsdetails.length > 0){                
                    if(productsqtymap.length > 0){
                        let finalproductlist = [];
                        for(let i=0; i<productsqtymap.length; i++){
                            let productid = productsqtymap[i].id;
                            let productQuantity = productsqtymap[i].Quantity;

                            wishlistitemsdetails.forEach(eachwishlistitem => {

                                if(eachwishlistitem.ProductID === productid){
                                    let eachcartitemtoadd = {
                                        "id" :  eachwishlistitem.ProductName,
                                        "quantity" : productQuantity,
                                        "price" : eachwishlistitem.modifiedPrice,
                                        "name" : eachwishlistitem.ProductName                                        
                                    }
                                    finalproductlist.push(eachcartitemtoadd);
                                }

                            });
                        }

                        let datatosend = {
                            productlist : finalproductlist,
                            currencycode : currencycode
                        }

                        let messagectx = {
                            eventName: 'add all to cart wishlist',
                            message: "INTENDING TO add to cart",
                            eventSource: requestSource,
                            eventData: {dataFeed : datatosend, userId : currUserId}                        
                        };  

                        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 
                    }                            
            }
        }


    }

    if(requestSource == 'ADD TO CART WISHLIST'){
        console.log(' << Inside add to cart from wishlist >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();

        let productid = requestData.productid;
        let productname = requestData.producttoadd;
        let productprice = requestData.pricing;
        let currencycode = requestData.currencycode;
        
        let datatosend = {
            "id" : productname,
            "quantity" : 1,
            "price" : productprice,
            "name" : productname,            
        }
        let finallist = [];
        finallist.push(datatosend);

        let messagectx = {
            eventName: 'add to cart wishlist',
            message: "INTENDING TO add to cart",
            eventSource: requestSource,
            eventData: {dataFeed : finallist, currency : currencycode,userId : currUserId}                        
        };  

        callPublishMethod(messageContext, AnalyticsChannel, messagectx); 

    }

    if(requestSource == 'REMOVE FROM WISHLIST'){
        console.log(' << Inside remove from saveforlater >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();        
        let proddeledetail = [];
        let ju = {                          
            'name': requestData.producttoremove,
            'id': requestData.producttoremove,
            'price': requestData.pricing,         
        }
        proddeledetail.push(ju);

        let messagectx = {
            eventName: 'Remove wishlist product',
            message: "INTENDING TO ADD TO CART FREQ BGT PRODDUCTS CLICK EVENT",
            eventSource: requestSource,
            eventData: {productList : proddeledetail, currency : requestData.currencycode, userId : currUserId}
        };
       
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);
    }

    if(requestSource == 'PRODUCT IMPRESSION'){
        console.log(' << Inside select state for pickup Refund event >> ');
        let messageContext = createMessageContext();  
        let currUserId = getUserID();
        let currencycode = requestData.currlocation;
        if(currencycode == 'US'){
            currencycode = 'USD';
        }else if(currencycode == 'EN' || currencycode == 'FR' || currencycode == 'CA'){
            currencycode = 'CAD';
        }
        let IMPdetails = requestData.impressiondetail;

        let messagectx = {
            eventName: 'PRODUCT IMPRESSION',
            message: "INTENDING TO CAPTURE IMPRESSION DATA",
            eventSource: requestSource,
            eventData: { dataFeed : IMPdetails , currency : currencycode, userId : currUserId}
        };                         
        callPublishMethod(messageContext, AnalyticsChannel, messagectx);         

    }
    
    


}
 

export {invokeGoogleAnalyticsService};