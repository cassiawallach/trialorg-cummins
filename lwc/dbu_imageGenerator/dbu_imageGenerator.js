import { LightningElement,api,track } from 'lwc';
import getProductImage from '@salesforce/apex/dbu_Integration_ProductImages.getProductImages';
import getCloudfrontProductImageAccessToken from '@salesforce/apex/dbu_Integration_ProductCloudfrontImages.getAccessToken';
import getCloudfrontProductImageURL from '@salesforce/apex/dbu_Integration_ProductCloudfrontImages.getProductImages';
import imageDomain from '@salesforce/label/c.dbu_imageDomain';
import akamaiImageDomain from '@salesforce/label/c.dbu_akamaiimageDomain'; // Added by Harish, CSSN-3095,Replacing PCC with Akamai URL Image Changes
import partsImageDomain from '@salesforce/label/c.dbu_PartsImageDomain';
import pubsub from 'c/pubsub' ; 
import imageLoader from '@salesforce/resourceUrl/dbu_imageLoader';
import imagealttext from '@salesforce/label/c.dbu_imageAltTextVerbiage';

import dbu_DefaultProductImage from "@salesforce/label/c.dbu_DefaultProductImage";

export default class Dbu_imageGenerator extends LightningElement {
    @api imageurl;
    @track imgLoader = imageLoader;
    //imageDomain => https://api-ue-devnf4-aw-ex.cummins.com/pcc/v1/catalogs/graphics
    //partsImageDomain => https://cssna-parts.gdc-rad.com/
    
    connectedCallback() {
        this.regiser(); 
        }
    renderedCallback(){
        this.renderImage();
    }

    @api
    renderImage()
    {
        console.log('imageurl'+this.imageurl)
        var image = new Image();
        let imageDiv = this.template.querySelector('.image-container');
        console.log('imageDiv' + imageDiv);
        console.log('imageDomain=>' + imageDomain);
        console.log('partsImageDomain=>' +partsImageDomain);
        //console.log('this.imageurl.includes(partsImageDomain)=>' +this.imageurl.includes(partsImageDomain));
        //console.log('this.imageurl.includes(imageDomain)=>' +this.imageurl.includes(imageDomain));
        image.src = this.imgLoader;
        imageDiv.innerHTML = image.outerHTML;
        if (this.imageurl == undefined || this.imageurl.length == 0)
        {
            console.log('inside imageURL 0')
            console.log('condition-1', dbu_DefaultProductImage)
            image.src = dbu_DefaultProductImage;
            image.alt = imagealttext;
            imageDiv.innerHTML = image.outerHTML;
            this.dispatchEvent(new CustomEvent('hidebox', {detail:  this.imageurl}));//CHG0083836 or CECI-575
        }
        else if (this.imageurl.includes(partsImageDomain))
        {
            console.log('inside imageURL include part domain')
            console.log('condition-2', this.imageurl)
            image.src = this.imageurl;
            image.alt = imagealttext;
            imageDiv.innerHTML = image.outerHTML;
            this.dispatchEvent(new CustomEvent('validimg', {detail:  this.imageurl}));//CHG0083836 or CECI-575
        }
        //Added this.imageurl.includes(akamaiImageDomain) by Harish, CSSN-3095,Replacing PCC with Akamai URL Image Changes
        else if (this.imageurl.includes(imageDomain) || this.imageurl.includes(akamaiImageDomain))
        {
            console.log('inside if condition imagegenerator ')
            getProductImage({ imageURL: this.imageurl })
                .then(result => {
                   console.log('Result=========='+result);
                   if(result !== null){
                    if(result.includes('/servlet/servlet.ImageServer')){
                        image.src = result;
                    }
                    else{
                        image.src = 'data:image/png;base64,' + result;
                    }
                    this.dispatchEvent(new CustomEvent('validimg', {detail:  this.imageurl}));//CHG0083836 or CECI-575
                }else{
                    image.src = dbu_DefaultProductImage;
                    this.dispatchEvent(new CustomEvent('hidebox', {detail:  this.imageurl}));//CHG0083836 or CECI-575
                }
                image.alt = imagealttext;
                imageDiv.innerHTML = image.outerHTML;
                   // console.log('img.data=>' + result);
                    console.log('condition-3', result)

                    this.error = undefined;
                })
                .catch(error => {
                    this.error = error.message;
                });
        }
        
        else if (this.imageurl.includes('http'))
        {
            console.log('inside imageURL 0')
            console.log('condition-4', this.imageurl)
            image.src = this.imageurl;
            image.alt = imagealttext;
            imageDiv.innerHTML = image.outerHTML;
            this.dispatchEvent(new CustomEvent('validimg', {detail:  this.imageurl}));//CHG0083836 or CECI-575
        }
        else {
            console.log('inside if condition imagegenerator ')
            getCloudfrontProductImageAccessToken()
                .then(result => {
                    let accessToken = result;
                    this.error = undefined;
                    getCloudfrontProductImageURL({ imageURL: this.imageurl,accessToken: accessToken})
                    .then(result1 => {
                        let awsImageURL = result1;
                        image.src =  awsImageURL.replaceAll('"','');
                        image.alt = imagealttext;
                        imageDiv.innerHTML = image.outerHTML;
                        this.dispatchEvent(new CustomEvent('validimg', {detail:  this.imageurl}));//CHG0083836 or CECI-575
                        console.log('image.outerHTML=>' + image.outerHTML);
                        console.log('imageDiv.innerHTML=>' + imageDiv.innerHTML);
                        console.log('imgage URL=>' + result1);
                        this.error = undefined;
                    })
                    .catch(error1 => {
                        this.error = error1.message;
                    });

                })
                .catch(error => {
                    this.error = error.message;
                });
        }
    }

    
    regiser(){
        window.console.log('event registered ');
        pubsub.register('imageGeneratorEvent', this.handleImgSelected.bind(this));
        
    }

    handleImgSelected(event){
        console.log('enetring handleImgSelected method>>>>' +event);
        this.imageurl = event;
        this.renderImage();

        console.log('imageurl', this.imageurl);
    }

}