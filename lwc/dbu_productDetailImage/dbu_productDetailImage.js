import { LightningElement, wire,track,api } from 'lwc';
import fetchProductById from '@salesforce/apex/dbu_ProductCtrl.fetchProductById';
import pubsub from 'c/pubsub' ; 
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import imageMagnify from '@salesforce/resourceUrl/dbu_magnify_image_hover';
import communityName from '@salesforce/label/c.dbu_communityName';


export default class Dbu_productDetailImage extends LightningElement {
    @track productDetails;
    @track queue ;
    @track queueSize = 5;
    @track productListSize = 0;
    @track myList;
    @track lstProduct;
    @track prdImage ;
    @track displaySelectedImg;
    @track communityname;
    @track currentLocation;
    @track productId;
    @track productURL;
    //@api displaySelectedImage;
   
    connectedCallback(){
        
        this.communityname = communityName;
        let urlString = window.location.origin;
        this.currentLocation = window.sessionStorage.getItem('setCountryCode');
        let url = window.location.pathname;
        let splitpath = url.split('/'); 
        this.productId = splitpath[4];
        this.productURL = urlString + communityName + 'product?name=Name&pId=' + this.productId + '&store='+this.currentLocation;
        console.log('this.productURL from similer ' ,this.productURL);
        if(this.productURL !== undefined){
            this.fetchProduct();
        }
        this.regiser();
       
    }

    fetchProduct(){
        fetchProductById({ urlParam: this.productURL })
        .then((data) => {
            if (data) {
                //refreshApex(data);
                console.log('dataProduuctdetailImg>>>>>>>>>>',(data));
                this.productDetails = data[0]; 
                
            } else if (error) {
                this.error = error;
                this.productDetails = undefined;
            }
        })
        .catch((error) => {
        this.error = error;
        console.log('this.error ' ,this.error);
        });
        }

  /*  @wire(fetchProductById,{urlParam:window.location.href})
    wireProduct({ error, data }) {
        console.log('urlParam:window.location.href=>'+window.location.href);
        if (data) {
            //refreshApex(data);
            console.log('dataProduuctdetailImg>>>>>>>>>>',(data));
            this.productDetails = data[0]; 
        } else if (error) {
            this.error = error;
            this.productDetails = undefined;
        }
    }*/

//     connectedCallback() {
//     this.regiser();
//    // this.displaySelectedImg = this.defaultSelectedImage;
//     }


    regiser(){
        window.console.log('event registered ');
        pubsub.register('imgSelected', this.handleImgSelected.bind(this));
        pubsub.register('changeSelectedImg', this.handleImgSelected.bind(this));
    }

    handleImgSelected(event){
        //console.log('enetring the handling method>>>>' +event);
        this.displaySelectedImg = event;
        //pubsub.fire('imageGeneratorEvent',event); 
        
        let childComponents = this.template.querySelectorAll('c-dbu_image-Generator')
            if (childComponents != undefined) {
                let childComponent = this.template.querySelectorAll('c-dbu_image-Generator')[0];
                //.processMyData(this.parentArray);
                if (childComponent != undefined)
                {
                    childComponent.imageurl = event;
                    childComponent.renderImage();
                }
            }
        console.log('displaySelectedImg', this.displaySelectedImg);
    }
    


 /*   renderedCallback() {
        Promise.all([
            loadScript(this, imageMagnify + '/js/jquery-1.12.4.min.js'),
            loadScript(this, imageMagnify + '/js/jquery.jqZoom.js'),
            loadStyle(this, imageMagnify + '/css/jquery.jqZoom.css')
        ])
            .then(() => {
                this.initializeImageMagnify();
            })
            .catch(error => {

            });
    }

    initializeImageMagnify() {
        this.template.querySelector(".prodImage").jqZoom({
            selectorWidth: 100,
            selectorHeight: 100,
            viewerWidth: 400,
            viewerHeight: 300
        });
    }*/
    
}