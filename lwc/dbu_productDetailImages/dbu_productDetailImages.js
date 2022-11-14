import { LightningElement, wire, track, api } from 'lwc';
import myResource from '@salesforce/resourceUrl/cloudMVP';
import pubsub from 'c/pubsub';
import fetchProductById from '@salesforce/apex/dbu_ProductCtrl.fetchProductById';

import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";
import communityName from '@salesforce/label/c.dbu_communityName';

export default class Dbu_productDetailImages extends LightningElement {
    @track productDetails;
    @track queue;
    @track imageArray = [];
    @track videoArray = [];
    @track queueSize = 5;
    // @track queueSize;
    @track productListSize = 0;
    @track myList;
    @track lstProduct;
    @track mediaRec;
    @track isVideo = false;
    @track videoURL;
    @track communityname;
    @track currentLocation;
    @track productId;
    @track productURL;

    label = {
        dbu_DefaultProductImage
    };

    leftArrow = myResource + '/images/dbu_LeftArrow.png';
    rightArrow = myResource + '/images/dbu_RightArrow.png';

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
       
    }


    fetchProduct(){
        fetchProductById({ urlParam: this.productURL })
        .then((data) => {
            if (data) {
                //refreshApex(data);
                console.log('dataProduuctdetailImg>>>>>>>>>>', (data));
                this.productDetails = data;
                if (this.productDetails.length > 0 && this.productDetails[0].EProductMediasS != undefined && this.productDetails[0].EProductMediasS.length > 0) {
                    this.lstProduct = this.productDetails[0].EProductMediasS;
                    for (let i = 0; i < this.lstProduct.length; i++) {
                        if (this.lstProduct[i].mediaType === 'Product Image') {
                            //  this.mediaRec = this.productDetails[0].EProductMediasS[0].URI;
                            this.mediaRec = this.lstProduct[i].URI;
                            break;
                        }
    
                    }
    
                    pubsub.fire('imgSelected', this.mediaRec);
                    this.size = this.lstProduct.length;
                    this.productListSize = this.lstProduct.length;
                    // this.queueSize=this.productListSize;
                    console.log('this.productListSize' + this.productListSize);
                    this.initializeQueue();
    
                } else {
                    this.mediaRec = dbu_DefaultProductImage;
                }
    
    
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

  /*  @wire(fetchProductById, { urlParam: window.location.href })
    wireProduct({ error, data }) {
        console.log('urlParam:window.location.href=>' + window.location.href);
        if (data) {
            //refreshApex(data);
            console.log('dataProduuctdetailImg>>>>>>>>>>', (data));
            this.productDetails = data;
            if (this.productDetails.length > 0 && this.productDetails[0].EProductMediasS != undefined && this.productDetails[0].EProductMediasS.length > 0) {
                this.lstProduct = this.productDetails[0].EProductMediasS;
                for (let i = 0; i < this.lstProduct.length; i++) {
                    if (this.lstProduct[i].mediaType === 'Product Image') {
                        //  this.mediaRec = this.productDetails[0].EProductMediasS[0].URI;
                        this.mediaRec = this.lstProduct[i].URI;
                        break;
                    }

                }

                pubsub.fire('imgSelected', this.mediaRec);
                this.size = this.lstProduct.length;
                this.productListSize = this.lstProduct.length;
                // this.queueSize=this.productListSize;
                console.log('this.productListSize' + this.productListSize);
                this.initializeQueue();

            } else {
                this.mediaRec = dbu_DefaultProductImage;
            }


        } else if (error) {
            this.error = error;
            this.productDetails = undefined;
        }
    }*/

    initializeQueue(){
        let i=0;
        console.log('insise initialise>>>>' +i);
        if(this.size >= 5){
        for(i=0; i<this.queueSize; i++){
            console.log('this.lstProduct[i].mediaType===='+this.lstProduct[i].mediaType);
            if(this.lstProduct[i].mediaType === 'Product Image'){
                this.imageArray.push(this.lstProduct[i]);
            }else if(this.lstProduct[i].mediaType === 'Media'){
                this.videoArray.push(this.lstProduct[i]);
            }
           
            console.log('this.lstProduct[i]>>' +JSON.stringify(this.lstProduct[i]));
        }
    }else{
        for(i=0; i<this.size; i++){
            console.log('this.lstProduct[i].mediaType===='+this.lstProduct[i].mediaType);
            if(this.lstProduct[i].mediaType === 'Product Image'){
                this.imageArray.push(this.lstProduct[i]);
            }else if(this.lstProduct[i].mediaType === 'Media'){
                this.videoArray.push(this.lstProduct[i]);
            }
           
            console.log('this.lstProduct[i]>>' +JSON.stringify(this.lstProduct[i]));
        }
    }
       this.queue = this.imageArray.concat(this.videoArray);
        console.log('Final queue =======' +JSON.stringify(this.queue));
        

    }



    handleClickNext() {
        if (this.queue[this.queueSize - 1] != this.lstProduct[this.productListSize - 1]) {
            var itemIndex = this.lstProduct.indexOf(this.queue[this.queueSize - 1]);
            if (itemIndex != this.lstProduct.length) {
                var itemToPush = this.lstProduct[itemIndex + 1];
                this.queue.splice(0, 1);
                this.queue.splice(this.queueSize - 1, 1, itemToPush);
            }
            else {
                var itemToPush = this.lstProduct[0];
                var itemToPop = this.queue[0];
                this.queue.splice(0, 1);
                this.queue.splice(this.queueSize - 1, 1, itemToPush);
            }

        }
        else {
            var itemToPush = this.lstProduct[0];
            var itemToPop = this.queue[0];
            this.queue.splice(0, 1);
            this.queue.splice(this.queueSize - 1, 1, itemToPush);
        }
        console.log('Next excuted===');
    }


    handleClickPrev() {

        if (this.queue[0] != this.lstProduct[0]) {
            var itemIndex = this.lstProduct.indexOf(this.queue[0]);//commented by shriram
            var itemToPush = this.lstProduct[itemIndex - 1];//added by shriram
            this.queue.splice(this.queueSize - 1, 1);
            this.queue.splice(0, 0, itemToPush);//added by shriram  
        }
        else {
            var itemToPush = this.lstProduct[this.lstProduct.length - 1];
            var itemToPop = this.queue[0];
            this.queue.splice(this.queueSize - 1, 1);//Added by shriram 
            this.queue.splice(0, 0, itemToPush);
        }
    }

    showPrdImg(event) {
        console.log('entering the pubsub method>>>>' + event.currentTarget.dataset.id);

        pubsub.fire('changeSelectedImg', event.currentTarget.dataset.id);
        event.stopImmediatePropagation();

        //pubsub.fire('imageGeneratorEvent',event.currentTarget.dataset.id); 
        var selClass = this.template.querySelectorAll('.selected');

        for (var s = 0; s < selClass.length; s++) {
            selClass[s].classList.remove("selected");
        }
        event.target.classList.add('selected');
    }

    playVideo(event) {
        let autoPlay = '?autoplay=1';
        this.isVideo = true;
        this.videoURL = event.currentTarget.dataset.id + '' + autoPlay;
    }
    handleCloseModal(event) {
        this.isVideo = false;
    }
    //HG0083836 or CECI-575
    hideBoxImg = false;
    hideBoxId;
    hidebox(event) {
        if (this.hideBoxImg) {
            const imgDiv = this.template.querySelector(`[data-id="${event.detail}"]`);
            if(!!imgDiv) imgDiv.parentElement.setAttribute('style', 'display:none;');
        } 
        if(this.hideBoxImg === false){
            this.hideBoxId = event.detail;
        }
        this.hideBoxImg = true;
    }
    firstValidImage = false;
    validImg(event) {
        this.hideBoxImg = true;
        if(!!this.hideBoxId){
            this.template.querySelector(`[data-id="${this.hideBoxId}"]`).parentElement.setAttribute('style', 'display:none;');
        }     
        if(this.firstValidImage === false) pubsub.fire('changeSelectedImg', event.detail);     
        this.firstValidImage = true;
    }
}