import {
    LightningElement,
    wire,
    track
} from 'lwc';
import pubsub from 'c/pubsub';
import fetchWishlistItems from '@salesforce/apex/dbu_SaveForLatetGeneric.fetchLoggedInUserWishlistItemswithInventoryCheck';
import deleteWishlistItems from '@salesforce/apex/dbu_SaveForLatetGeneric.deleteDefaultWishlist_WishListItem_OR_SaveforLaterItem';
import AddProductToCart from '@salesforce/apex/dbu_SaveForLatetGeneric.AddProductToCart_From_WishList';
import fetchLstCartItemsAfterDelete from '@salesforce/apex/dbu_CartCtrl.fetchLstCartItemsByCartId';
import communityName from '@salesforce/label/c.dbu_communityName';

import fetchCartId from '@salesforce/apex/dbu_CartCtrl.fetchCartId';
//Added by Malhar - 17/12/2020
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import storeCanada from '@salesforce/label/c.dbu_home_store_Canada_CA'; //custom label refres to'CA'
import currencyCodeUSA from '@salesforce/label/c.dbu_home_store_country_currency_code_USA'; //custom label refres to'USD'
import currencyCodeCanada from '@salesforce/label/c.dbu_home_store_country_currency_code_Canada'; //custom label refres to'CAD'

import dbu_myAccount_yourWishList from '@salesforce/label/c.dbu_myAccount_yourWishList';
import dbu_myAccount_addAllItemsToCart from '@salesforce/label/c.dbu_myAccount_addAllItemsToCart';
import dbu_myAccount_product from '@salesforce/label/c.dbu_myAccount_product';
import dbu_myAccount_quantity from '@salesforce/label/c.dbu_myAccount_quantity';
import dbu_myAccount_unitPrice from '@salesforce/label/c.dbu_myAccount_unitPrice';
import dbu_myAccount_outOfStock from '@salesforce/label/c.dbu_myAccount_outOfStock';
import dbu_myAccount_inStock from '@salesforce/label/c.dbu_myAccount_inStock';
import dbu_myAccount_addToCart from '@salesforce/label/c.dbu_myAccount_addToCart';
import dbu_myAccount_saveForLater from '@salesforce/label/c.dbu_myAccount_saveForLater';
import dbu_noitemsWishlist from '@salesforce/label/c.dbu_noitemsWishlist';
import dbu_done from '@salesforce/label/c.dbu_done';

import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';
import clearanceIcon from '@salesforce/resourceUrl/dbu_icons';
export default class Dbu_myAccountWishlist extends LightningElement {
    @track showWishListItems;
    @track wishlistItems;
    @track noOfItems;
    @track prodID;
    @track items;
    @track addressLoaded = false;
    @track isLoading=true;
    @track successfullyAddedTocart = false;
    @track alreadyExistsInCart = false;
    @track displayMessage;
    @track quantity;
    @track isModalOpen = false;
    @track recordUpdate;
    @track ProdURL;
    @track productNameInUrl;
    //Added by Malhar for store toggling of wishlist - 17/12/2020
    @track sendLocBackToChangeLocTile;
    @track countryCurrencyCode;
    @track currentStorelocation;
    
    //labels
    @track dbu_myAccount_yourWishList = dbu_myAccount_yourWishList;
    @track dbu_myAccount_addAllItemsToCart = dbu_myAccount_addAllItemsToCart;
    @track dbu_myAccount_product = dbu_myAccount_product;
    @track dbu_myAccount_quantity = dbu_myAccount_quantity;
    @track dbu_myAccount_unitPrice = dbu_myAccount_unitPrice;
    @track dbu_myAccount_outOfStock = dbu_myAccount_outOfStock;
    @track dbu_myAccount_inStock = dbu_myAccount_inStock;
    @track dbu_myAccount_addToCart = dbu_myAccount_addToCart;
    @track dbu_myAccount_saveForLater = dbu_myAccount_saveForLater;
    @track dbu_noitemsWishlist = dbu_noitemsWishlist;
    @track dbu_done = dbu_done;
    @track clearanceImg = clearanceIcon+'/dbu_icons/dbu_saletag.svg';
    @track initialQty;
    //end
    get ScreenLoaded() {
        return this.isLoading;
    }

    get dataLoadedSuccess() {
        return this.showWishListItems;
    }

    navigateToProductPage(event){
        console.log(event.target.getAttribute('data-id'));   
        this.ProdURL = event.target.getAttribute('data-id');
        let prodname =  event.target.getAttribute('data-productname').toLowerCase();
        if(prodName.includes('/')){
            prodName = prodName.replaceAll('/','-');//.replace('/','-'); //INC3260754//CHG0089244
        }
        this.productNameInUrl = prodname;          
    }

    get productURL(){        
        let urlString = window.location.origin;
        return urlString+communityName+'product/'+this.ProdURL+'/'+this.productNameInUrl+'/?store='+this.sendLocBackToChangeLocTile;
        //return urlString+communityName+'product?name='+ this.productNameInUrl +'&pId='+this.ProdURL + '&store=' + this.sendLocBackToChangeLocTile;
    }

    connectedCallback() {
        //Added by Malhar for store toggling - 17/12/2020
        /*added by mounika t to navigation through nav mixin */
        let locationURL = window.location.href;
        console.log('locationURL' + locationURL);
        var url = new URL(locationURL);
        
        //this.sendLocBackToChangeLocTile = url.searchParams.get("store");     
        this.sendLocBackToChangeLocTile = window.sessionStorage.getItem('setCountryCode');

        console.log('store location wishlist -> ' + this.sendLocBackToChangeLocTile);
        /*added by mounika t to navigation through nav mixin */
        if(this.sendLocBackToChangeLocTile == storeUSA || this.sendLocBackToChangeLocTile == null ||
            this.sendLocBackToChangeLocTile == undefined || this.sendLocBackToChangeLocTile == ''){
            this.countryCurrencyCode = currencyCodeUSA;
            this.currentStorelocation = storeUSA;
            this.sendLocBackToChangeLocTile = storeUSA; 
            console.log('storeUSA====='+this.countryCurrencyCode);
        }else if(this.sendLocBackToChangeLocTile == storeCA || this.sendLocBackToChangeLocTile == storeCAF){
            this.countryCurrencyCode = currencyCodeCanada;
            this.currentStorelocation = storeCanada;
            console.log('storeCA====='+this.countryCurrencyCode);
        }
        //Added by Malhar for store toggling - 17/12/2020
        if (!this.addressLoaded) {
            fetchWishlistItems({
                dbu_SFL_OR_WL_Value: 'Wishlist',
                storeCountry : this.currentStorelocation,
                storeLanguage : this.sendLocBackToChangeLocTile
            }).then(
                data => {
                    if (data) {
                        console.log('data from apex cls' + JSON.stringify(data));
                        console.log('data length' + data.length);
                        this.noOfItems = data.length;
                        this.wishlistItems = data;
                        if(this.wishlistItems.length > 0){
                            this.wishlistItems.forEach(element => {
                                // element['saleTag'] = element['saleTag'] != undefined ? element['saleTag']:'Clearance Sale';
                                if(element.stockstatus){
                                    let quantityArray = [];
                                    for (let index = 1; index <= element.inventoryQuantity; index++) {
                                        quantityArray.push({
                                            label: index.toString(),
                                            value: index.toString()
                                        });
                                    }
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else if(quantityArray.length >= 10){
                                        element['quantityThresholdExceeded'] = true;                                        
                                    } 
                                    element['quantityOptions'] = quantityArray; 
                                    element['selectedQuantity'] = 0;
                                    element['quantityVisible'] = true;
                                }else{
                                    let quantityArray = [];
                                    element['quantityOptions'] = quantityArray.push(0,0); 
                                    element['selectedQuantity'] = 0;  
                                    element['quantityVisible'] = true;                                                                     
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else{
                                        element['quantityThresholdExceeded'] = true;
                                    }                                                                        
                                }                              
                                console.log('element > ' + JSON.stringify(element));
                                // Added productprice check for en-US
                                if(element.ProductPrice != undefined || element.ProductPrice != null){
                                    element['modifiedPrice'] = element.ProductPrice.toLocaleString('en-US', {
                                        style: 'currency',
                                        currency: this.countryCurrencyCode,
                                        minimumFractionDigits: 2,
                                        maximumFractionDigits: 2
                                    });
                                }
                            });
                        }
                        if (this.noOfItems !== 0) {
                            this.showWishListItems = true;
                        } else if (this.noOfItems === 0) {
                            this.isLoading = false;
                            this.showWishListItems = false;
                        }
                        if (this.noOfItems > 1) {
                            this.items = 'items';
                            this.isLoading = false;
                        } else if (this.noOfItems === 1) {
                            this.items = 'item';
                            this.isLoading = false;
                        }
                    }
                    console.log('this.wishlistItems >  ' + JSON.stringify(this.wishlistItems));
                }
            ).catch(error => {
                this.error = error.message;
                console.log('result from wishlist apex cls error ', JSON.stringify(this.error));
            });
            this.addressLoaded = true;
        }
    }

    handleChangeQnty(event){
        this.isLoading = true;
        console.log('value >> ' +event.target.value);
        console.log('ProductID >> ' + event.target.getAttribute('data-id'));
        let selectedProductId = event.target.getAttribute('data-id');
        let selectedquantityvalue = event.target.value;
        this.initialQty = event.target.dataset.quantity;
        if(selectedquantityvalue !== '9+'){
            console.log('IN NOT 9+ LOOP');
            for(let i = 0; i < this.wishlistItems.length ; i++){
                if(this.wishlistItems[i].ProductID == selectedProductId){
                    console.log('inside the within loop');
                    console.log('ll > ' + typeof this.wishlistItems[i].selectedQuantity);
                    console.log('DL > ' + typeof selectedquantityvalue);
                    this.wishlistItems[i].selectedQuantity = selectedquantityvalue;

                }

            }
            /*
            this.wishlistItems.forEach(element => {
                if(selectedProductId == element.ProductID){
                    
                    element.selectedQuantity = selectedquantityvalue;
                }
            });*/
        }
        else if(selectedquantityvalue == '9+'){
            for(let i = 0; i < this.wishlistItems.length ; i++){
                if(this.wishlistItems[i].ProductID == selectedProductId){
                    console.log('inside the within loop');
                    //console.log('Ching value > ' + JSON.stringify(document.body.getElementsByClassName('wishlisttextboxinput')));
                    //this.template.querySelector('.wishlisttextboxinput')                                      
                    this.wishlistItems[i].quantityVisible = false;
                    this.wishlistItems[i].selectedQuantity = 10;
                    this.enteredval = 10;
                    let v = this.template.querySelectorAll("lightning-input");
                    console.log('V > ' + v);
                    //this.template.querySelector('[data-my-id="wishlisttextboxinput"]').focus();  
                   

                }   
            }            
            /*
            this.wishlistItems.forEach(element => {
                console.log('IN  9+ LOOP');
                if(selectedProductId == element.ProductID){
                    element.quantityVisible = false;
                    //element.selectedQuantity = selectedquantityvalue;
                }
            }); */           
        }



        console.log('this.wishlistItems in handle change qty > ' + JSON.stringify(this.wishlistItems));

        //this.quantity = event.target.value;
        //console.log(quantity);
        this.isLoading = false;
    }

   /* }*/

    handleAddallItemsToCart(event){
        this.isLoading = true;
        console.log('WishlistItems > ' + JSON.stringify(this.wishlistItems));
        let WishlistItms = this.wishlistItems;
        let ProductQtyMap = [];

        if(WishlistItms.length > 0){
            console.log('WishlistItms lenght >> ' + WishlistItms.length);
            for(let i=0 ; i<WishlistItms.length ; i++){
                if(WishlistItms[i].stockstatus){
                    if(WishlistItms[i].selectedQuantity == 0){
                        console.log('productID > ' + WishlistItms[i].ProductID + ' ProductQTy > ' + WishlistItms[i].ProductQuantity + ' selectedqty >  ' +  WishlistItms[i].selectedQuantity);
                        ProductQtyMap.push({id : WishlistItms[i].ProductID, Quantity : WishlistItms[i].ProductQuantity});                    
                    }else{
                        let prodQuantity = parseInt(WishlistItms[i].selectedQuantity);
                        console.log('productID > ' + WishlistItms[i].ProductID + ' ProductQTy > ' + WishlistItms[i].ProductQuantity + ' selectedqty >  ' +  WishlistItms[i].selectedQuantity);
                        ProductQtyMap.push({id : WishlistItms[i].ProductID, Quantity : WishlistItms[i].selectedQuantity});                                            
                    }

                }
            }
            console.log('stringified productQTY > ' + JSON.stringify(ProductQtyMap));
        }
        
        if(ProductQtyMap.length > 0){

            AddProductToCart({
                dbu_SFL_OR_WL_Value: 'WishList',
                productqty : JSON.stringify(ProductQtyMap),
                storeCountry : this.currentStorelocation,
                storeLanguage : this.sendLocBackToChangeLocTile
            })
            .then(result => {
                console.log('all items to cart result > ' + JSON.stringify(result));
                
                if(result.PAddedToC.length > 0){
                    console.log('PAddedToC > ' + JSON.stringify(result.PAddedToC));
                    this.successfullyAddedTocart = true;
                    for(let i=0 ; i< result.PAddedToC.length ; i++) {
                        if (result.PAddedToC[i].IsCrateProductCheck == true ) 
                            this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Crate Engine', unitPrice : JSON.stringify(result.PAddedToC[i].ProductPrice), quantity : result.PAddedToC[i].ProductQuantity, Name : result.PAddedToC[i].ProductName, id : result.PAddedToC[i].ProductSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: result.PAddedToC[i].Brandname, Category: result.PAddedToC[i].Categoryname}); /*CECI-958 GTM Events*/                       
                        else if (result.PAddedToC[i].IsCrateProductCheck == false) 
                            this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Normal', unitPrice : JSON.stringify(result.PAddedToC[i].ProductPrice), quantity : result.PAddedToC[i].ProductQuantity, Name : result.PAddedToC[i].ProductName, id : result.PAddedToC[i].ProductSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: result.PAddedToC[i].Brandname, Category: result.PAddedToC[i].Categoryname}); /*CECI-958 GTM Events*/
                    }
                    fetchCartId({
                        storeCountry : this.currentStorelocation 
                    }).then(cartresult => {
                        console.log('cartresult wishlist -> ' + cartresult);
    
                        fetchLstCartItemsAfterDelete({
                            cartId : cartresult,
                            cart : 'cart'
                        }).then(resultone => {
                            console.log('Fetch cart result' + JSON.stringify(resultone));
                            pubsub.fire('fetchcartevt', resultone);
                        }).catch(error => {
                            this.error = error.message;
                            console.log(this.error);
                        });
    
                    })

                    
                    console.log('Products Added to cart Successfully' +this.successfullyAddedTocart);                     
                }
                if(result.PExisting.length > 0){
                    console.log('PExisting > ' + JSON.stringify(result.PExisting));
                    this.alreadyExistsInCart = true;
                    
                    
                                      
                    console.log('Products not added to Cart as they already exist in the cart' +this.alreadyExistsInCart);                        
                }

                if(this.successfullyAddedTocart == true && this.alreadyExistsInCart == false){
                    console.log('this.successfullyAddedTocart >> ' + this.successfullyAddedTocart  );
                    console.log('this.alreadyExistsInCart >> ' + this.alreadyExistsInCart);
                    this.displayMessage = 'Products added to cart successfully. Only in stock products are added to cart.';
                    this.isModalOpen = true; 
                    this.recordUpdate = this.displayMessage; 
                    this.successfullyAddedTocart = false;
                    this.alreadyExistsInCart = false;

                }else if(this.successfullyAddedTocart == false && this.alreadyExistsInCart == true){
                    console.log('this.successfullyAddedTocart >> ' + this.successfullyAddedTocart  );
                    console.log('this.alreadyExistsInCart >> ' + this.alreadyExistsInCart);
                    this.displayMessage = 'Products already exist in the cart.';
                    this.isModalOpen = true; 
                    this.recordUpdate = this.displayMessage;  
                    this.successfullyAddedTocart = false;
                    this.alreadyExistsInCart = false;

                }else if(this.successfullyAddedTocart == true && this.alreadyExistsInCart == true){
                    console.log('this.successfullyAddedTocart >> ' + this.successfullyAddedTocart  );
                    console.log('this.alreadyExistsInCart >> ' + this.alreadyExistsInCart);
                    this.displayMessage = 'Products added to cart. Existing cart products, crate engine products and out of products are not added to cart.';
                    this.isModalOpen = true; 
                    this.recordUpdate = this.displayMessage; 
                    this.successfullyAddedTocart = false;
                    this.alreadyExistsInCart = false; 
                }


                fetchWishlistItems({
                    dbu_SFL_OR_WL_Value: 'Wishlist',
                    storeCountry : this.currentStorelocation,
                    storeLanguage : this.sendLocBackToChangeLocTile
                }).then(result1 => {
                    if (result1) {
                        this.isLoading = false;
                        
                        console.log('data from apex cls imperative' + JSON.stringify(result1));
                        console.log('data length' + result1.length);
                        this.noOfItems = result1.length;
                        this.wishlistItems = result1;
                        if(this.wishlistItems.length > 0){                            
                            this.wishlistItems.forEach(element => {
                                if(element.stockstatus){
                                    let quantityArray = [];
                                    for (let index = 1; index <= element.inventoryQuantity; index++) {
                                        quantityArray.push({
                                            label: index.toString(),
                                            value: index.toString()
                                        });
                                    }
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else if(quantityArray.length >= 10){
                                        element['quantityThresholdExceeded'] = true;                                        
                                    } 
                                    element['quantityOptions'] = quantityArray; 
                                    element['selectedQuantity'] = 0;
                                    element['quantityVisible'] = true;
                                }else{
                                    let quantityArray = [];
                                    element['quantityOptions'] = quantityArray.push(0,0); 
                                    element['selectedQuantity'] = 0;  
                                    element['quantityVisible'] = true;                                                                     
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else{
                                        element['quantityThresholdExceeded'] = true;
                                    }                                                                        
                                }                              
                                console.log('element > ' + JSON.stringify(element));                           

                                element['modifiedPrice'] = element.ProductPrice.toLocaleString('en-US', {
                                    style: 'currency',
                                    currency: this.countryCurrencyCode,
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                });
                            });
                        }                  
                        console.log('wishlistItems' +JSON.stringify(this.wishlistItems));
                        if (this.noOfItems > 0) {
                            console.log('coming to if>>' +this.showWishListItems);
                        } else {
                            console.log('coming to else if>>' +this.noOfItems);
                            this.showWishListItems = false;
                            console.log('coming to else>>' +this.showWishListItems);
                        }
                        
                    }
                }).catch(error => {
                    this.error = error.message;
                    console.log('result from addressbook error ', JSON.stringify(this.error));
                });
                this.isLoading = false;

            }).catch(error => {
                this.error = error.message;
                console.log('error occured in pushing all items to cart > ' + this.error);
            })

            //this.wishlistItems
            //ProductQtyMap            
            invokeGoogleAnalyticsService('ADD ALL TO CART FROM WISHLIST', {productstoadd : ProductQtyMap, wishlistitems : this.wishlistItems, currencycode : this.countryCurrencyCode});

        }else{
            this.isLoading = false;
            this.displayMessage = 'Only instock products are added to cart.';
            this.isModalOpen = true; 
            this.recordUpdate = this.displayMessage; 
        }
        
    }

    handleAddToCart(event){
        this.isLoading = true;
        let ProductId = event.target.getAttribute('data-prodid');
        let ProductPricing = event.target.getAttribute('data-proprice');
        console.log('ProductPricing > ' + ProductPricing);
        let ProductName = event.target.getAttribute('data-proname');
        let myWishListItem = {};
        console.log('ProductName > ' + ProductName);
        console.log('ProductID > ' + ProductId);
        invokeGoogleAnalyticsService('ADD TO CART WISHLIST', {producttoadd : ProductName, pricing : ProductPricing, productid : ProductId, currencycode : this.countryCurrencyCode});
        //if(typeof this.quantity == "undefined"){
            //this.quantity = event.target.getAttribute('data-quantity');
        //}
        let prodquantity; 
        console.log('this.wishlistItems in wishlist page',JSON.parse(JSON.stringify(this.wishlistItems)));
        //console.log('this.quantity > ' + this.quantity);
        this.wishlistItems.forEach(element => {
            if(ProductId == element.ProductID){
                if(element.selectedQuantity == 0){
                    console.log('add to cart inside 1st loop > ');
                    prodquantity = parseInt(element.ProductQuantity);
                    myWishListItem = element;
                    
                }else{
                    console.log('add to cart inside 2nd loop > ');
                    prodquantity = parseInt(element.selectedQuantity);
                    myWishListItem = element;
                }
            }
        });
        console.log('product qty > ' + prodquantity);
        let ProductQtyMap = JSON.stringify([{id:ProductId,Quantity:prodquantity}]);
        console.log(ProductQtyMap);            
        AddProductToCart({
            dbu_SFL_OR_WL_Value: 'WishList',
            productqty : ProductQtyMap,
            storeCountry : this.currentStorelocation,
            storeLanguage : this.sendLocBackToChangeLocTile
        }).then(addresult => {
            console.log('result from, AddProductToCart apex class' , JSON.stringify(addresult));
        
            if(addresult.PAddedToC.length > 0){
                this.successfullyAddedTocart = true;
                if (myWishListItem.IsCrateProductCheck == true)
                    this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Crate Engine', unitPrice : JSON.stringify(myWishListItem.ProductPrice), quantity : prodquantity, Name : ProductName, id : myWishListItem.ProductSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: myWishListItem.Brandname, Category: myWishListItem.Categoryname}); /*CECI-958 GTM Events*/                       
                else if (myWishListItem.IsCrateProductCheck == false) 
                    this.googleAnalyticsCartOperations('AddToCart', {ProductType : 'Normal', unitPrice : JSON.stringify(myWishListItem.ProductPrice), quantity : prodquantity, Name : ProductName, id : myWishListItem.ProductSKU, storeLanguage : this.sendLocBackToChangeLocTile, storeCountry : this.currentStorelocation, cartOperation : 'AddToCart', originalProductPrice : null,cartId : this.cartId, Brand: myWishListItem.Brandname, Category: myWishListItem.Categoryname}); /*CECI-958 GTM Events*/
                fetchCartId({
                    storeCountry : this.currentStorelocation 
                }).then(cartresult => {
                    console.log('cartresult wishlist -> ' + cartresult);

                    fetchLstCartItemsAfterDelete({
                        cartId : cartresult,
                        cart : 'cart'
                    }).then(resultone => {
                        console.log('Fetch cart result' + JSON.stringify(resultone));
                        pubsub.fire('fetchcartevt', resultone);
                    }).catch(error => {
                        this.error = error.message;
                        console.log(this.error);
                    });

                })

                
                console.log('Products Added to cart Successfully' +this.successfullyAddedTocart);   
            }
            
            if(addresult.PExisting.length > 0){
                this.alreadyExistsInCart = true;               
                console.log('Products not added to Cart as they already exist in the cart' +this.alreadyExistsInCart);    
            }

            if(this.successfullyAddedTocart == true && this.alreadyExistsInCart == false){
                console.log('this.successfullyAddedTocart >> ' + this.successfullyAddedTocart  );
                console.log('this.alreadyExistsInCart >> ' + this.alreadyExistsInCart);
                this.displayMessage = 'Product is Added to Cart Successfully';
                this.isModalOpen = true; 
                this.recordUpdate = this.displayMessage; 
                this.successfullyAddedTocart = false;
                this.alreadyExistsInCart = false;

            }else if(this.successfullyAddedTocart == false && this.alreadyExistsInCart == true){
                console.log('this.successfullyAddedTocart >> ' + this.successfullyAddedTocart  );
                console.log('this.alreadyExistsInCart >> ' + this.alreadyExistsInCart);
                this.displayMessage = 'Product is not added to Cart. Existing cart products and crate engine products are not added to cart.';
                this.isModalOpen = true; 
                this.recordUpdate = this.displayMessage;  
                this.successfullyAddedTocart = false;
                this.alreadyExistsInCart = false;

            }



            fetchWishlistItems({
                dbu_SFL_OR_WL_Value: 'Wishlist',
                storeCountry : this.currentStorelocation,
                storeLanguage : this.sendLocBackToChangeLocTile
            }).then(result1 => {
                if (result1) {
                    this.isLoading = false;
                    
                    console.log('data from apex cls imperative' + JSON.stringify(result1));
                    console.log('data length' + result1.length);
                    this.noOfItems = result1.length;
                    this.wishlistItems = result1;
                    if(this.wishlistItems.length > 0){                            
                        this.wishlistItems.forEach(element => {
                            if(element.stockstatus){
                                let quantityArray = [];
                                for (let index = 1; index <= element.inventoryQuantity; index++) {
                                    quantityArray.push({
                                        label: index.toString(),
                                        value: index.toString()
                                    });
                                }
                                if(quantityArray.length < 10){
                                    element['quantityThresholdExceeded'] = false;    
                                }else if(quantityArray.length >= 10){
                                    element['quantityThresholdExceeded'] = true;                                        
                                } 
                                element['quantityOptions'] = quantityArray; 
                                element['selectedQuantity'] = 0;
                                element['quantityVisible'] = true;
                            }else{
                                let quantityArray = [];
                                element['quantityOptions'] = quantityArray.push(0,0); 
                                element['selectedQuantity'] = 0;  
                                element['quantityVisible'] = true;                                                                     
                                if(quantityArray.length < 10){
                                    element['quantityThresholdExceeded'] = false;    
                                }else{
                                    element['quantityThresholdExceeded'] = true;
                                }                                                                        
                            }                              
                            console.log('element > ' + JSON.stringify(element));                            

                            element['modifiedPrice'] = element.ProductPrice.toLocaleString('en-US', {
                                style: 'currency',
                                currency: this.countryCurrencyCode,
                                minimumFractionDigits: 2,
                                maximumFractionDigits: 2
                            });
                        });
                    }                  
                    console.log('wishlistItems' +JSON.stringify(this.wishlistItems));
                    if (this.noOfItems > 0) {
                        //this.showWishListItems = true;
                        console.log('coming to if>>' +this.showWishListItems);
                    } else {
                        console.log('coming to else if>>' +this.noOfItems);
                        this.showWishListItems = false;
                        console.log('coming to else>>' +this.showWishListItems);
                    }
                }
            }).catch(error => {
                this.error = error.message;
                console.log('result from addressbook error ', JSON.stringify(this.error));
            });
            this.isLoading = false;
            
        }).catch(error => {
            this.error = error.message;
            console.log('result from AddProductToCart error ', JSON.stringify(this.error));
        });   
        
    }

    googleAnalyticsCartOperations(source, informationData){
            /*CECI-958 GTM Events removed googleAnalyticsCartFeed*/     
          invokeGoogleAnalyticsService('ADD TO CART', informationData);
        /*CECI-958 GTM Events removed removefromcart trigger*/
    }   
    onWishlistDelete(event) {
        this.isLoading = true;
        console.log('data id of clicked product' + event.target.getAttribute('data-prodid'));
        let ProductPricing = event.target.getAttribute('data-proprice');
        console.log('ProductPricing > ' + ProductPricing);
        let ProductName = event.target.getAttribute('data-proname');
        console.log('ProductName > ' + ProductName);
        let prodSKU = event.target.getAttribute('data-prodsku');
        let myWishListItem = {};
        let prodquantity; 
        if (event.target.getAttribute('data-prodid') !== '') {
            this.prodID = event.target.getAttribute('data-prodid');
            console.log('data id of clicked product id' + this.prodID);
            invokeGoogleAnalyticsService('REMOVE FROM WISHLIST', {producttoremove : ProductName, pricing : ProductPricing, productid : this.prodID , currencycode : this.countryCurrencyCode});
        }
        deleteWishlistItems({
            ProductId: this.prodID,
            SFL_OR_WL_Value : 'WishList',
            storeCountry : this.currentStorelocation
        }).then(result => {
            console.log('result from, apex cls in delete method>>>' + JSON.stringify(result));
             let productDeleteCheck = result;
            if (result === true) {
                fetchWishlistItems({
                    dbu_SFL_OR_WL_Value: 'Wishlist',
                    storeCountry : this.currentStorelocation,
                    storeLanguage : this.sendLocBackToChangeLocTile
                }).then(result1 => {
                    if (result1) {
                        this.isLoading = false;
                        console.log('data from apex cls imperative' + JSON.stringify(result1));
                        console.log('data length' + result1.length);
                        this.noOfItems = result1.length;
                        this.wishlistItems = result1;
                        if(this.wishlistItems.length > 0){                            
                            this.wishlistItems.forEach(element => {
                                if(element.stockstatus){
                                    let quantityArray = [];
                                    for (let index = 1; index <= element.inventoryQuantity; index++) {
                                        quantityArray.push({
                                            label: index.toString(),
                                            value: index.toString()
                                        });
                                    }
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else if(quantityArray.length >= 10){
                                        element['quantityThresholdExceeded'] = true;                                        
                                    } 
                                    element['quantityOptions'] = quantityArray; 
                                    element['selectedQuantity'] = 0;
                                    element['quantityVisible'] = true;
                                }else{
                                    let quantityArray = [];
                                    element['quantityOptions'] = quantityArray.push(0,0); 
                                    element['selectedQuantity'] = 0;  
                                    element['quantityVisible'] = true;                                                                     
                                    if(quantityArray.length < 10){
                                        element['quantityThresholdExceeded'] = false;    
                                    }else{
                                        element['quantityThresholdExceeded'] = true;
                                    }                                                                        
                                }                              
                                console.log('element > ' + JSON.stringify(element));                              

                                element['modifiedPrice'] = element.ProductPrice.toLocaleString('en-US', {
                                    style: 'currency',
                                    currency: this.countryCurrencyCode,
                                    minimumFractionDigits: 2,
                                    maximumFractionDigits: 2
                                });
                            });
                        }                    
                        console.log('wishlistItems' +JSON.stringify(this.wishlistItems));
                        if (this.noOfItems > 0) {
                            //this.showWishListItems = true;
                            console.log('coming to if>>' +this.showWishListItems);
                        } else {
                            console.log('coming to else if>>' +this.noOfItems);
                            this.showWishListItems = false;
                            console.log('coming to else>>' +this.showWishListItems);
                        }
                    }
                }).catch(error => {
                    this.error = error.message;
                    console.log('result from addressbook error ', JSON.stringify(this.error));
                });
                if(productDeleteCheck === true){
                    this.wishlistItems.forEach(element => {
                        if(prodSKU == element.ProductSKU){
                                prodquantity = parseInt(element.ProductQuantity);
                                myWishListItem = element;
                        }
                    });
                    /*CECI-958 GTM Events removed removefromcart triggers*/
                }
            }
        }).catch(error => {
            this.error = error.message;
            console.log('error from delete method ', JSON.stringify(this.error));
        });
    }

    get options() {
            return [{
                    label: '1',
                    value: '1'
                },
                {
                    label: '2',
                    value: '2'
                },
                {
                    label: '3',
                    value: '3'
                },
                {
                    label: '4',
                    value: '4'
                },
                {
                    label: '5',
                    value: '5'
                },
                {
                    label: '6',
                    value: '6'
                },
                {
                    label: '7',
                    value: '7'
                },
                {
                    label: '8',
                    value: '8'
                },
                {
                    label: '9+',
                    value: '9+'
                },
            ];

        

    }
    closeModal () {
        this.isModalOpen = false; 
    }
}