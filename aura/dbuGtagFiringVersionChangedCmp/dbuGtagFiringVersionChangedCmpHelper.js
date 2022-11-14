({

  getCookieDetails : function(name){
    let retval;
    name = name + "=";
    let ca = document.cookie.split(';');
    for (let i = 0; i < ca.length; i++) {
        let c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            retval = unescape(c.substring(name.length, c.length));
        }
    }
    let retruningval;
    if(retval != undefined && retval != null && retval != ''){
      let splitedretval = retval.split('.');      
      if(splitedretval[2] != undefined && splitedretval[3] != undefined){
        retruningval = splitedretval[2] + '.' + splitedretval[3];
      }else{
        retruningval = retval;
      }      
    }else{
      retruningval = retval;
    }
    
    return retruningval;    
  },

	esnSearch : function(component,message) {
        console.log('message in ESNSearch helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.ESNSearchQuery);
        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);  

        gtag('event', 'search', {
          search_term: JSON.parse(parsedMessage.eventData.ESNSearchQuery),
          "dimension2" : gaId,
          "dimension7" : salesforceUserId	          
        });        
	},

  navigateToWarantyInformationPage : function(component, message){
        console.log('message in navigateToWarantyInformationPage Helper >>>>>>> ' + JSON.parse(message)); 
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory; 
        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId); 

        gtag('event', eventName, {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId          
        });            
  }, 

  navigateToContactUsPage : function(component, message){
    console.log('message in navigateToContactUsPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });            
  }, 

  navigateTolocationsPage : function(component, message){
    console.log('message in navigateTolocationsPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId           
    });            
  },
  
  SearchProductsOnClicked : function(component, message){
    console.log('message in SearchProductsOnClicked Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;  

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null }); 
    dataLayer.push({
      'event': 'productClick',
      'ecommerce': {
        'click': {
          'actionField': {'list': "Search key - " + Feed.searchKey},      // Optional list property.
          'products': [{
            'name': Feed.productName,                      // Name or ID is required.
            'id': Feed.productName,
            'price': Feed.ProductPrice,
            'brand': '',
            'category': Feed.currenctProductCategory,
            'variant': Feed.currenctProductCategory,
            'position': 1
           }]
         }
       },
       "dimension2" : gaId,
       "dimension7" : salesforceUserId       
    });    
    /*
    gtag('event', 'select_content', {
      "content_type": "product",
      "items": [
        {
          "id": Feed.productName,
          "name": Feed.productName,
          "list_name": "Search key - " + Feed.searchKey,
          "brand": "",
          "category":Feed.currenctProductCategory,
          "variant": "",
          "list_position": 1,
          "quantity": Feed.ProductInventoryStatus,
          "price": Feed.ProductPrice
        }
      ],
      "dimension2" : gaId,
      "dimension7" : salesforceUserId
    });    */
  },

  OnProductsClickedevent : function(component, message){
    console.log('message in SearchProductsOnClicked Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;  

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null }); 
    dataLayer.push({
      'event': 'productClick',
      'ecommerce': {
        'click': {
          'actionField': {'list': Feed.listname},      // Optional list property.
          'products': [{
            'name': Feed.productName,                      // Name or ID is required.
            'id': Feed.ProductID,
            'price': Feed.ProductPrice,
            'brand': Feed.ProductBrand,
            'category': Feed.ProductCategory,
            'variant': Feed.ProductCategory,
            'position': 1
           }]
         }
       },
       "dimension2" : gaId,
       "dimension7" : salesforceUserId       
    });

    /*
    gtag('event', 'select_content', {
      "content_type": "product",
      "items": [
        {
          "id": Feed.ProductID,
          "name": Feed.productName,
          "list_name": Feed.listname,
          "brand": Feed.ProductBrand,
          "category":Feed.ProductCategory,          
          "list_position": 1,
          "quantity": Feed.ProductInventoryStatus,
          "price": Feed.ProductPrice
        }
      ],
      "dimension2" : gaId,
      "dimension7" : salesforceUserId
    });   */ 
  },  
  
  UserProductsOnClicked : function(component, message){
    console.log('message in UserProductsOnClicked Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;  
    console.log('document.cookie > ' + document.cookie);    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);

    gtag('event', 'select_content', {
      "content_type": "product",
      "items": [
        {
          "id": Feed.productName,
          "name": Feed.productName,
          "list_name": 'selected product',
          "brand": "",
          "category":Feed.ProductCategory,
          "variant": "",
          "list_position": 1,
          "quantity": Feed.ProductInventoryStatus,
          "price": Feed.currenctProductPrice,          
        }
      ],
      "dimension2" : gaId,
      "dimension7" : salesforceUserId
    });    
  },

  viewSearchProducts : function(component, message){
    console.log('message in viewSearchProducts Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed; 
    let currencycode = parsedMessage.eventData.currency;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currencycode,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
    });
      /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId
      });*/
  },

  SubcategoryClickevent : function(component, message){
    console.log('message in SubcategoryClickevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + JSON.stringify(parsedMessage.eventData)); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;     
    let eventLabel = parsedMessage.eventData.EventLabel;  
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);      
    
    gtag('event', eventName, {
      'event_label': eventLabel,
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId            
    });      
  },

  DealsClickevent : function(component, message){
    console.log('message in SubcategoryClickevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + JSON.stringify(parsedMessage.eventData)); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;     
    let eventLabel = parsedMessage.eventData.EventLabel;  
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);      
    
    gtag('event', eventName, {
      'event_label': eventLabel,
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId            
    });      
  },

  currentPromotionClickevent : function(component, message){
    console.log('message in currentPromotionClickevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);        

    gtag('event', eventName, {      
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    });      
  },

  pageSortevent : function(component, message){
    console.log('message in SearchpageSortevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let eventName = parsedMessage.eventName;
    let eventCategory = parsedMessage.eventData.eventCategory; 
    let eventLabel = parsedMessage.eventData.eventLabel; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);   

    gtag('event', eventName, {
      'event_category': eventCategory,
      'event_label' : eventLabel,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });
  },
 
/*
    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    window.dataLayer.push({
        'event': eventName,
        'ecommerce': {
          'click': {
            'actionField': {'list': 'Search key - ' + Feed.searchKey},      // Optional list property.
            'products': [{
              'name': productObj.name,                      // Name or ID is required.
              'id': Feed.ProductID,
              'price': Feed.price,
              'brand': Feed.brand,
              'category': Feed.cat,
              'variant': '',
              'position': ''
             }]
           }
         }
      });
*/

  navigateToFAQPage : function(component, message){
    console.log('message in navigateToFAQPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId        
    });            
  }, 

  navigateToReturnRefundPage : function(component, message){
    console.log('message in navigateToReturnRefundPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId        
    });            
  }, 

  navigateToShippingPolicyPage : function(component, message){
    console.log('message in navigateToShippingPolicyPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId              
    });            
  }, 

  navigateToCorePolicyPage : function(component, message){
    console.log('message in navigateToCorePolicyPage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId            
    });            
  }, 

  signInLinkClick : function(component,message){
        console.log('message in SignIn click helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.method);
        let eventName = parsedMessage.eventName;
        let eventMethodValue = parsedMessage.eventData.method; 
        
        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId); 

        gtag('event', eventName, {
          method: eventMethodValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId   
        }); 
  }, 
  
  PdpPagePrimaryProductData : function(component,message){
        console.log('message in PdpPagePrimaryProductData helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + JSON.stringify(parsedMessage.eventData.productData));
        let eventName = parsedMessage.eventName;
        let productName = parsedMessage.eventData.productData.currproductName;    
        let productID = parsedMessage.eventData.productData.productIdData;
        let productPrice = parsedMessage.eventData.productData.productPriceData;  
        let productInventoryqty = parsedMessage.eventData.productData.productInventoryQuantity;  
        let productInventorystatus  = parsedMessage.eventData.productData.productInventoryStatus;
        let galistname = parsedMessage.eventData.productData.galistname;
        let productBrand = parsedMessage.eventData.productData.productBrand;/*CECI-958 GTM Events*/
        let productCategory = parsedMessage.eventData.productData.productCategory;/*CECI-958 GTM Events*/
        console.log('galistname > ' + galistname);

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId); 
        window.dataLayer = window.dataLayer || [];
        dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
        dataLayer.push({
          'ecommerce': {
            'detail': {
              'actionField': {'list': galistname},    // 'detail' actions have an optional list property.
              'products': [{
                'name': productName,         // Name or ID is required.
                'id': productID,/*CECI-958 GTM Events*/
                'price': productPrice,
                'brand': productBrand,/*CECI-958 GTM Events*/
                'category': productCategory,/*CECI-958 GTM Events*/
                'variant': ''
               }]
             }
           },
           "dimension2" : gaId,
           "dimension7" : salesforceUserId, 
        });


        /*
        gtag('event', 'view_item', {
          items: [{
            "id" : productName,
            "name" : productName,
            "brand" : "",
            "category" : "",
            "coupon" : "",
            "list_name" : 'product viewed on detail page',
            "list_position": 1,
            "price": productPrice,
            "quantity" : productInventoryqty,
            "variant" : ""
          }],
          "dimension2" : gaId,
          "dimension7" : salesforceUserId            
        });*/

  },  

  frequentlyBgtProdClick  : function(component,message){
        console.log('message in frequentbgtprods helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        let eventName = parsedMessage.eventName;
        console.log('eventName > ' + eventName);
        let EventCategory = parsedMessage.eventData.FGPFeed.eventCategory;
        console.log('EventCategory > ' + EventCategory);
        let EventProductName = parsedMessage.eventData.FGPFeed.eventProductName;
        console.log('EventProductName > ' + EventProductName);
        let EventProductprice = parsedMessage.eventData.FGPFeed.eventProductPrice;
        console.log('EventProductprice > ' + EventProductprice);

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId); 

        gtag('event', eventName, {
          'event_label': EventProductName,
          'event_category': EventCategory,
          'value': EventProductprice,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId          
        });        
  },

  addToWishlist : function(component, message){
    console.log('message in addToWishlist helper >>>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);  
    console.log('parsed message > ' + JSON.stringify(parsedMessage.eventData.productData));
    let eventName = parsedMessage.eventName;
    let productName = parsedMessage.eventData.dataFeed.currproductName;    
    let productID = parsedMessage.eventData.dataFeed.productIdData;
    let productPrice = parsedMessage.eventData.dataFeed.productPriceData;  
    let productInventoryqty = parsedMessage.eventData.dataFeed.productInventoryQuantity;  
    let productInventorystatus  = parsedMessage.eventData.dataFeed.productInventoryStatus;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);  

    gtag('event', eventName, {
      currency: 'USD',
      items: [{
        "id": productName,
        "name" : productName,
        "brand": "",
        "category" : "",
        "coupon" : "",
        "list_name" : "Products Added to wishlist",
        "list_position" : 1,
        "price" : productPrice,
        "quantity" : 1,
        "variant" : productInventorystatus
      }],
      value: productInventoryqty,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });
  },

  notifyMeProducts : function(component,message){
        console.log('message in notify me prods helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);   

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);  

        gtag('event', parsedMessage.eventName, {
          'event_category': parsedMessage.eventData.dataFeed.eventCategory,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId           
        });        
  },

  chatLinkClick : function(component,message){
        console.log('message in chat click helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory;    

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);  

        //window.dataLayer = window.dataLayer || [];
        //window.dataLayer.push({           
          //  'bookingid': eventName,
            //'event_category' : eventCategoryValue
        //});          
        //window.dataLayer = window.dataLayer || [];
        //function gtag(){dataLayer.push(arguments);}
        
        gtag('event', eventName, {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId             
        });
  },  

  signUpLinkClick : function(component,message){
        console.log('message in SignUp click helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        console.log('parsed message > ' + parsedMessage.eventData.EventLabel);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory;    

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);  

        gtag('event', eventName, {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId                 
        }); 
  },  

  storeToggle : function(component,message){
        console.log('message in storeToggle helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory;    
        
        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId); 

        gtag('event', eventName, {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId             
        });        
  },

  acceptCookies : function(component, message){
        console.log('message in Accept Cookies Helper >>>>>>> ' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory; 
        
        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);         
        
        gtag('event', 'Accept Click', {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId            
        });
  },

  closeXmarkBanner :function(component,message){
        console.log('message in close x mark banner helper >>>>>>>>' + JSON.parse(message));
        let parsedMessage = JSON.parse(message);
        console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
        let eventName = parsedMessage.eventName;
        let eventCategoryValue = parsedMessage.eventData.EventCategory;

        let salesforceUserId = parsedMessage.eventData.userId;
        let gaId = this.getCookieDetails('_ga');
        console.log('salesforceUserId > ' + salesforceUserId);
        console.log('gaId > ' + gaId);     

        gtag('event', 'Close Click', {
          'event_category': eventCategoryValue,
          "dimension2" : gaId,
          "dimension7" : salesforceUserId            
        });        
  },
    
  recentlyViewedproductsButtonClickevent : function(component, message){
    console.log('message in recentlyViewedproductsButtonClickevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory; 
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    gtag('event', eventName, {      
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId             
    }); 
  },

  shopbyBrandButtonClickevent : function(component, message){
    console.log('message in shopbyBrandButtonClickevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;    
    let curreventLabel = parsedMessage.eventData.EventLabel;         

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);     

    gtag('event', eventName, {      
      'event_category': curreventCategory,      
      'event_label' : curreventLabel,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId         
    });     
  },

  shopbyBrandProductsReturned : function(component, message){
    console.log('message in shopbyBrandProductsReturned Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed; 
    let currency = parsedMessage.eventData.currencycd;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);   
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currency,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,       
    });
    /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId              
      });   */  
  },

  CategoryPageProductsReturned : function(component, message){
    console.log('message in CategoryPageProductsReturned Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed; 
    let currency = parsedMessage.eventData.currencycd;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
          
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currency,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
    });
    /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId                 
      }); */    
  },

  DealsPageProductsReturned : function(component, message){
    console.log('message in CategoryPageProductsReturned Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed; 
    let currency = parsedMessage.eventData.currencycd;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
          
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currency,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
    });
    /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId                 
      }); */    
  },

  crosssellProductsonPDPpage : function(component, message){
    console.log('message in crosssellProductsonPDPpage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed; 
    let currency = parsedMessage.eventData.location;
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
    
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currency,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId    
    });

    /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId  
      });    */  
  },

  relatedProductsonPDPpage : function(component, message){
    console.log('message in relatedProductsonPDPpage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed; 
    let currency = parsedMessage.eventData.location;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'currencyCode': currency,                       // Local currency is optional.
        'impressions': Feed
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId    
    });

      /*
      gtag('event', eventName, {
        "items": Feed,
        "dimension2" : gaId,
        "dimension7" : salesforceUserId          
      }); */     
  },

  addToCart  : function(component, message){ /* Sasikanth CECI - 992 */ 
    console.log('message in addToCartonPDPpage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed; 
    console.log('Feed > ' + JSON.stringify(Feed));

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    window.dataLayer.push({
      'event': CurreventName,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,           
      'ecommerce': {
        'currencyCode': Feed.storeCurrency,     
        'add': {                                // 'add' actionFieldObject measures.
          'products': [{                        //  adding a product to a shopping cart.
            'name': Feed.Name,
            'id': Feed.id, /* Sasikanth CECI - 992 */ 
            'price': Feed.unitPrice,
            'brand': Feed.Brand,/*CECI-958 GTM Events*/
            'category': Feed.Category,/*CECI-958 GTM Events*/
            'variant': Feed.ProductType,
            'quantity': Feed.quantity
           }]
        }
      }
    });    
  }, 
  
  addMultipleToCartonPDPpage  : function(component, message){
    console.log('message in addToCartonPDPpage Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let ProdFeed = parsedMessage.eventData.productList; 
    let storeCurrency = parsedMessage.eventData.currency;
    console.log('ProdFeed > ' + JSON.stringify(ProdFeed));

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);      

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    window.dataLayer.push({
      'event': CurreventName,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
      'ecommerce': {
        'currencyCode': storeCurrency,
        'add': {                                // 'add' actionFieldObject measures.
          'products': ProdFeed
        }
      }
    });    
  },
  
  navigateToCartPageevent :  function(component, message){
    console.log('message in navigateToCartPageevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 
    let eventLabel = parsedMessage.eventData.EventLabel;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);      

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      'event_label' : eventLabel,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId  
    });     
  }, 

  navigateToCheckoutPageevent : function(component, message){
    console.log('message in navigateToCheckoutPageevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.datafeed);
    let eventName = parsedMessage.eventName;
    let feed = parsedMessage.eventData.datafeed;     

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    


    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });
    dataLayer.push({
      'event': eventName,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,       
      'ecommerce': {
        'checkout': {  
          'actionField': {'step': 1, 'option': 'Cart Page'},          
          'products': feed 
        }
      }     
    });
    
  },

  removefromcartevent :function(component, message){
    console.log('message in removefromcartevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.productList; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'event': 'removeFromCart',
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,        
      'ecommerce': {
        'remove': {                              
          'products': Feed
        }
      }
    });    

  },

  changeProductQunatity :  function(component, message){
    console.log('message in changeProductQunatity Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.datafeed);
    let eventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);   

    gtag('event', eventName, {
      'event_category': Feed.eventCategory,
      'event_label' : Feed.eventlabel,
      'value' : Feed.value,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });  
    
  },
  
  cancelclickevents :  function(component, message){
    console.log('message in cancelclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });      

  },
   
  continueshoppingclickevents  :  function(component, message){
    console.log('message in continueshoppingclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory);
    let eventName = parsedMessage.eventName;
    let eventCategoryValue = parsedMessage.eventData.EventCategory; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    gtag('event', eventName, {
      'event_category': eventCategoryValue,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId      
    });   
  },

  purchasepageclickevents : function(component, message){
    console.log('message in purchasepageclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);        

    gtag('event', eventName, {      
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    }); 
  },

  urlclickevents : function(component, message){
    console.log('message in urlclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);     
    
    
    gtag('event', eventName, {      
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    });
  },

  addToSaveforLaterevent : function(component, message){
    console.log('message in urlclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.dataFeed); 
    let eventName = parsedMessage.eventName;
    let feed = parsedMessage.eventData.dataFeed;   

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);     
    
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.

    dataLayer.push({
      'event': 'add To Save for later',
      'ecommerce': {
        'detail': {
          'actionField': {'list': 'Add to Save for later ' + parsedMessage.eventData.page},    // 'detail' actions have an optional list property.
          'products': feed
        }
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId   
    });
  },

  stateselectedforpickupevent : function(component, message){
    console.log('message in urlclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);     
    
    
    gtag('event', eventName, {      
      'event_category': curreventCategory,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    });
  },

  buttonClickevent : function(component, message){
    console.log('message in urlclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   
    let curreventAction  = parsedMessage.eventData.EventAction;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);     
    
    
    gtag('event', eventName, {      
      'event_category': curreventCategory,
      'event_action' : curreventAction,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    });
  },

  externalLinkClickevent : function(component, message){
    console.log('message in urlclickevents Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);   
    console.log('parsed message > ' + parsedMessage.eventData.EventCategory); 
    let eventName = parsedMessage.eventName;
    let curreventCategory = parsedMessage.eventData.EventCategory;   
    let curreventAction  = parsedMessage.eventData.EventAction;
    let curreventLabel = parsedMessage.eventData.EventLabel;

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    gtag('event', eventName, {      
      'event_category': curreventCategory,
      'event_action' : curreventAction,
      'event_label' : curreventLabel,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId               
    });

  },
  
  removefromsaveforlaterevent : function(component, message){
    console.log('message in removefromsaveforlaterevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.productList; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'event': 'removefromsaveforlater',
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,        
      'ecommerce': {
        'remove': {                              
          'products': Feed
        }
      }
    }); 
  },

  orderConfirmationevent : function(component, message){
    console.log('message in orderConfirmationevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    
    
    
    gtag('event', 'purchase', {
      "transaction_id": Feed.currorderNumber,
      "affiliation": "Order Placed & Confirmed",
      "value": Feed.curreordertotal,
      "currency": Feed.CurrenctCode,
      "tax": Feed.curreordertax,
      "shipping": Feed.curreordership,
      "items": Feed.curreorderitems,      
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,       
    });

  },
  
  setcheckoutoptions : function(component, message){
    console.log('message in setcheckoutoptions Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed;
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null }); // Clear the previous ecommerce object.
    dataLayer.push({
     'event': 'checkoutOption',
     "dimension2" : gaId,
     "dimension7" : salesforceUserId,    
     'ecommerce': {
      'checkout_option': {
       'actionField': {'step': Feed.step, 'option': Feed.option}
      }
     }
    });
   
  },

  orderreviewcheckout : function(component, message){
    console.log('message in navigateToCheckoutPageevent Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData.datafeed);
    let eventName = parsedMessage.eventName;
    let feed = parsedMessage.eventData.datafeed;
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
    
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });
    dataLayer.push({
     'event': eventName,
     "dimension2" : gaId,
     "dimension7" : salesforceUserId, 
     'ecommerce': {
     'checkout': {
      'actionField': {'step': 2, 'option': 'Order Review'},  
      'products': feed
     }
     } 
    });
    
  },
  
  nextstepcheckoutdetail : function(component, message){
    console.log('message in setcheckoutoptions Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed;
    let productData = parsedMessage.eventData.feed; /* Pratyusha CECI- 958 */
    console.log('Feed > ' + Feed);
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);

    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });
    dataLayer.push({
     'event': 'checkout',
     "dimension2" : gaId,
     "dimension7" : salesforceUserId, 
     'ecommerce': {
      'checkout': {
       'actionField': {
        'step': Feed.step,
        'option': Feed.option
       },                       
       'products': productData  /* Pratyusha CECI- 958 */
      }
     }
    })
  },
  
  orderReceiptcheckout : function(component, message){
    console.log('message in orderConfirmationevent Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });
    dataLayer.push({
     'event': 'checkout',
     "dimension2" : gaId,
     "dimension7" : salesforceUserId, 
     'ecommerce': {
     'checkout': {
      'actionField': {'step': 4, 'option': Feed.currorderNumber + ' Order Confirmed'},  
      'products': Feed.curreorderitems
     }
     } 
    });
  },  

  /*trackorderpagedata : function(component, message){
    console.log('message in orderConfirmationevent Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 
    gtag('event', 'purchase', {
     "transaction_id": Feed.currorderNumber,
     "affiliation": Feed.currentorderhistory + " - Order History",
     "value": Feed.curreordertotal,
     "currency": Feed.CurrenctCode,
     "tax": Feed.curreordertax,
     "shipping": Feed.curreordership,
     "items": Feed.curreorderitems,
     "dimension2" : gaId,
     "dimension7" : salesforceUserId,   
    });
  },*/
  
  trackorderpagedata : function(component, message){
    console.log('message in orderConfirmationevent Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);

    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    gtag('event', CurreventName, {   
      'event_category': 'View Order History',
      'event_label' :Feed,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId       
     });

  },

  trackorderUserInput : function(component, message){
    console.log('message in orderConfirmationevent Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.datafeed;
    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId); 

    gtag('event', CurreventName, {   
     'event_category': 'View Order History',
     'event_label' : Feed.OrderNumber,
     "dimension2" : gaId,
     "dimension7" : salesforceUserId       
    });
  },
  
  captureRefund : function(component, message){
    console.log('message in setcheckoutoptions Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    console.log('Feed > ' + Feed);

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);
    /*
    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'ecommerce': {
        'refund': {
          'actionField': {'id': Feed.curordername},        // Transaction ID.
          'products': Feed.productlisting
         }
      },
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
    });*/

    
    gtag('event', 'refund', {
      "transaction_id": Feed.curordername,
      "affiliation": "Return Order",
      "value": Feed.currTotal,
      "currency": Feed.currcurrency,
      "items": Feed.productlisting,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
    });

  },

  addalltocartwishlist : function(component, message){
    console.log('message in addalltocartwishlist Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    console.log('Feed > ' + Feed);

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    window.dataLayer.push({
      'event': CurreventName,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
      'ecommerce': {
        'currencyCode': Feed.currencycode,
        'add': {                                // 'add' actionFieldObject measures.
          'products': Feed.productlist
        }
      }
    }); 

  },

  addtocartfromwishlist : function(component, message){
    console.log('message in addalltocartwishlist Helper >>>>>>> ' + JSON.parse(message));
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.dataFeed;
    let FeedCurrency = parsedMessage.eventData.currency;

    console.log('Feed > ' + Feed);

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);

    window.dataLayer = window.dataLayer || [];
    window.dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    window.dataLayer.push({
      'event': CurreventName,
      "dimension2" : gaId,
      "dimension7" : salesforceUserId, 
      'ecommerce': {
        'currencyCode': FeedCurrency,
        'add': {                                // 'add' actionFieldObject measures.
          'products': Feed
        }
      }
    }); 
  },

  removefromwishlistevent : function(component, message){
    console.log('message in removefromwishlistevent Helper >>>>>>> ' + JSON.parse(message)); 
    let parsedMessage = JSON.parse(message);
    console.log('parsed message > ' + parsedMessage.eventData);
    let CurreventName = parsedMessage.eventName;
    let Feed = parsedMessage.eventData.productList; 

    let salesforceUserId = parsedMessage.eventData.userId;
    let gaId = this.getCookieDetails('_ga');
    console.log('salesforceUserId > ' + salesforceUserId);
    console.log('gaId > ' + gaId);    

    window.dataLayer = window.dataLayer || [];
    dataLayer.push({ ecommerce: null });  // Clear the previous ecommerce object.
    dataLayer.push({
      'event': 'removefromwishlist',
      "dimension2" : gaId,
      "dimension7" : salesforceUserId,        
      'ecommerce': {
        'remove': {                              
          'products': Feed
        }
      }
    }); 
  },


});