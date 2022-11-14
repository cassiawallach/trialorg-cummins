({
    handleEvent : function(component, event, helper) {
        var retrivedMessage =event.getParam('message');
        
        // getting the value of event attribute
        
        console.log('retrivedMessage ::: '+JSON.stringify(retrivedMessage));
        component.set('v.ParentAttribute',retrivedMessage); 
      


        try {
            //window.dataLayer = window.dataLayer || [];
            //function gtag(){dataLayer.push(arguments);}  
            var parsedRetrivedMessage = JSON.parse(retrivedMessage); 
            
            if(parsedRetrivedMessage.eventSource == 'ESN SEARCH'){
                console.log('inside the ESN SEARCH--');
            	helper.esnSearch(component,retrivedMessage);
            }
            
            if(parsedRetrivedMessage.eventSource == 'CLOSEXMARKBANNER'){
                helper.closeXmarkBanner(component,retrivedMessage); 
            }

            if(parsedRetrivedMessage.eventSource == 'ACCEPT COOKIES'){
                helper.acceptCookies(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'WARRANTY INFORMATION FOOTER LINK CLICK'){
                helper.navigateToWarantyInformationPage(component,retrivedMessage);
            } 

            if(parsedRetrivedMessage.eventSource == 'CONTACT US FOOTER LINK CLICK'){
                helper.navigateToContactUsPage(component,retrivedMessage);
            } 

            if(parsedRetrivedMessage.eventSource == 'SEND US YOUR QUESTIONS'){
                helper.navigateToContactUsPage(component,retrivedMessage);
            }             
            
            if(parsedRetrivedMessage.eventSource == 'LOCATIONS FOOTER LINK CLICK'){
                helper.navigateTolocationsPage(component,retrivedMessage);
            } 
            
            if(parsedRetrivedMessage.eventSource == 'FAQ FOOTER LINK CLICK'){
                helper.navigateToFAQPage(component,retrivedMessage);
            } 
            
            if(parsedRetrivedMessage.eventSource == 'RETURNREFUND FOOTER LINK CLICK'){
                helper.navigateToReturnRefundPage(component,retrivedMessage);
            } 
            
            if(parsedRetrivedMessage.eventSource == 'SHIPPING POLICY FOOTER LINK CLICK'){
                helper.navigateToShippingPolicyPage(component,retrivedMessage);
            }  
            
            if(parsedRetrivedMessage.eventSource == 'CORE POLICY FOOTER LINK CLICK'){
                helper.navigateToCorePolicyPage(component,retrivedMessage);
            }             
                                    
            if(parsedRetrivedMessage.eventSource == 'STORE TOGGLE'){
                helper.storeToggle(component,retrivedMessage);
            }
            
            if(parsedRetrivedMessage.eventSource == 'SIGN UP LINK CLICK'){
                helper.signUpLinkClick(component,retrivedMessage);
            }        
            
            if(parsedRetrivedMessage.eventSource == 'CHAT LINK CLICK'){
                helper.chatLinkClick(component,retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'SIGNIN LINK CLICK'){
                helper.signInLinkClick(component,retrivedMessage);
            }            
            
            if(parsedRetrivedMessage.eventSource == 'LAND ON PRODUCT DETAIL PAGE'){
                helper.PdpPagePrimaryProductData(component,retrivedMessage);
            } 

            if(parsedRetrivedMessage.eventSource == 'FREQUENTLY BOUGHT PRODUCTS SELECTION'){
                helper.frequentlyBgtProdClick(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'NOTIFY ME WHEN IN STOCK'){
                helper.notifyMeProducts(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'SEARCH PAGE PRODUCT CLICKED'){
                helper.SearchProductsOnClicked(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'ON PRODUCT CLICK EVENT'){
                helper.OnProductsClickedevent(component,retrivedMessage);
            }                               
            
            if(parsedRetrivedMessage.eventSource == 'USER CLICKED ON PRODUCT'){
                helper.UserProductsOnClicked(component,retrivedMessage);
            } 

            if(parsedRetrivedMessage.eventSource == 'SEARCH DATA RETURNED'){
                helper.viewSearchProducts(component,retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'PAGE SORTING'){
                helper.pageSortevent(component,retrivedMessage);
            } 
            
            if(parsedRetrivedMessage.eventSource == 'SUBCATEGORY LINK CLICK'){
                helper.SubcategoryClickevent(component,retrivedMessage);
            }  
            
            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO CURRENT PROMOTION PAGE'){
                helper.currentPromotionClickevent(component,retrivedMessage);
            }  
            
            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO RECENTLY VIEWED PRODUCTS PAGE'){
                helper.recentlyViewedproductsButtonClickevent(component,retrivedMessage);
            }                
            
            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO SHOP BY BRAND PAGE'){
                helper.shopbyBrandButtonClickevent(component,retrivedMessage);
            }            

            if(parsedRetrivedMessage.eventSource == 'BRAND DATA RETURNED'){
                helper.shopbyBrandProductsReturned(component,retrivedMessage);
            }            

            if(parsedRetrivedMessage.eventSource == 'CATEGORY DATA RETURNED'){
                helper.CategoryPageProductsReturned(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'DEALS DATA RETURNED'){
                helper.DealsPageProductsReturned(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'CATEGORY LINK CLICK'){
                helper.SubcategoryClickevent(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'DEALS LINK CLICK'){
                helper.DealsClickevent(component,retrivedMessage);
            }
            
            if(parsedRetrivedMessage.eventSource == 'ADD TO WISHLIST'){
                helper.addToWishlist(component,retrivedMessage);
            }    
            
            if(parsedRetrivedMessage.eventSource == 'CROSSSELL PRODUCTS ON PDP PAGE'){
                helper.crosssellProductsonPDPpage(component,retrivedMessage);
            }     
            
            if(parsedRetrivedMessage.eventSource == 'RELATED PRODUCTS ON PDP PAGE'){
                helper.relatedProductsonPDPpage(component,retrivedMessage);
            }              
            
            if(parsedRetrivedMessage.eventSource == 'ADD TO CART'){
                helper.addToCart(component,retrivedMessage);
            } 
            
            if(parsedRetrivedMessage.eventSource == 'FREQUENTLY BOUGHT ADD TO CART'){
                helper.addMultipleToCartonPDPpage(component,retrivedMessage);
            }  
            
            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO CART PAGE'){
                helper.navigateToCartPageevent(component,retrivedMessage);
            }  
            
            if(parsedRetrivedMessage.eventSource == 'PROCEED TO CHECKOUT BUTTON CLICK'){
                helper.navigateToCheckoutPageevent(component,retrivedMessage);
            }         
            
            if(parsedRetrivedMessage.eventSource == 'REMOVE FROM CART'){
                helper.removefromcartevent(component,retrivedMessage);
            }    
            
            if(parsedRetrivedMessage.eventSource == 'CHANGE PRODUCT QUANTITY'){
                helper.changeProductQunatity(component,retrivedMessage);
            }    

            if(parsedRetrivedMessage.eventSource == 'CANCEL CLICKS'){
                helper.cancelclickevents(component,retrivedMessage);
            }
            
            if(parsedRetrivedMessage.eventSource == 'OPEN MODALS'){
                helper.cancelclickevents(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'CONTINUE SHOPPING CLICKS'){
                helper.continueshoppingclickevents(component,retrivedMessage);
            }
            
            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO PURCHASE POLICY PAGE'){
                helper.purchasepageclickevents(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'NAVIGATE TO URL LINKS'){
                helper.urlclickevents(component,retrivedMessage);
            }

            if(parsedRetrivedMessage.eventSource == 'ADD TO SAVEFORLATER'){
                helper.addToSaveforLaterevent(component,retrivedMessage);
            }       
            
            if(parsedRetrivedMessage.eventSource == 'STATE OF COUNTRY SELECTED FOR PICKUP'){
                helper.stateselectedforpickupevent(component,retrivedMessage);
            }    
            
            if(parsedRetrivedMessage.eventSource == 'BUTTON CLICK'){
                helper.buttonClickevent(component,retrivedMessage);
            }    

            if(parsedRetrivedMessage.eventSource == 'EXTERNAL LINK'){
                helper.externalLinkClickevent(component,retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'ADD ALL TO CART SAVE FOR LATER'){
                helper.addMultipleToCartonPDPpage(component,retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'ADD TO SFL CART PAGE'){
                helper.addToSaveforLaterevent(component,retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'REMOVE FROM SAVEFORLATER'){
                helper.removefromsaveforlaterevent(component,retrivedMessage);
            } 

            if (parsedRetrivedMessage.eventSource == 'ORDER CONFIRMATION') {
                helper.orderConfirmationevent(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'CHECKOUT OPTION') {
                helper.setcheckoutoptions(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'ORDER REVIEW CHECKOUT') {
                helper.orderreviewcheckout(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'NEXT STEP CHECKOUT DETAILS') {
                helper.nextstepcheckoutdetail(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'ORDER RECIEPT CHECKOUT') {
                helper.orderReceiptcheckout(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'TRACK ORDER RESULTS') {
                helper.trackorderpagedata(component, retrivedMessage);
            }

            if (parsedRetrivedMessage.eventSource == 'TRACK ORDER USER INPUT') {
                helper.trackorderUserInput(component, retrivedMessage);
            }
            
            if (parsedRetrivedMessage.eventSource == 'STATE COUNTRY FOR PICKUP REFFUND') {
                helper.stateselectedforpickupevent(component, retrivedMessage);
            }                        

            if (parsedRetrivedMessage.eventSource == 'REFUND ORDER DETAILS') {
                helper.captureRefund(component, retrivedMessage);
            }    
            
            if (parsedRetrivedMessage.eventSource == 'ADD ALL TO CART FROM WISHLIST') {
                helper.addalltocartwishlist(component, retrivedMessage);
            }    

            if (parsedRetrivedMessage.eventSource == 'ADD TO CART WISHLIST') {
                helper.addtocartfromwishlist(component, retrivedMessage);
            }   
            
            if(parsedRetrivedMessage.eventSource == 'REMOVE FROM WISHLIST'){
                helper.removefromwishlistevent(component,retrivedMessage);
            }      

            if(parsedRetrivedMessage.eventSource == 'PRODUCT IMPRESSION'){
                helper.viewSearchProducts(component,retrivedMessage);
            }                  
                   
            

        }catch(err) {
            console.log('ERROR IN GTAG FIRE COMPONENT CONTROLLER > ' + err);            
        }        
        // Setting the value of parent attribute with event attribute value
    }
});