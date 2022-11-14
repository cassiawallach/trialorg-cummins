import { LightningElement, api,track,wire } from 'lwc';
import fetchProductById from '@salesforce/apex/dbu_ProductCtrl.fetchProductById';
import getProductRating from '@salesforce/apex/dbu_ProductCtrl.getProductRating';

//labels starts//
import dbu_product_review_customerview from "@salesforce/label/c.dbu_product_review_customerview";
import dbu_product_review_customers_recommended_to_others from "@salesforce/label/c.dbu_product_review_customers_recommended_to_others";
import dbu_product_review_5_star from "@salesforce/label/c.dbu_product_review_5_star";
import dbu_product_review_4_star from "@salesforce/label/c.dbu_product_review_4_star";
import dbu_product_review_0 from "@salesforce/label/c.dbu_product_review_0";
import dbu_product_review_3_star from "@salesforce/label/c.dbu_product_review_3_star";
import dbu_product_review_2_star from "@salesforce/label/c.dbu_product_review_2_star";
import dbu_product_review_1_star from "@salesforce/label/c.dbu_product_review_1_star";
import dbu_product_review_Read_all from "@salesforce/label/c.dbu_product_review_Read_all";
import dbu_product_review_reviews from "@salesforce/label/c.dbu_product_review_reviews";
//labels starts//

export default class Dbu_productDetailsReview extends LightningElement {
    @track productDetails;
    @track product;
    @track numberOfReviewss;
    @track ratingData = [];
    @track mapData = new Map();
    @track percentageOfFive;
    @track percentageOfFour;
    @track percentageOfThree;
    @track percentageOfTwo;
    @track percentageOfOne;

    //labels starts//
  label = {
    dbu_product_review_customerview,
    dbu_product_review_customers_recommended_to_others,
    dbu_product_review_5_star,
    dbu_product_review_4_star,
    dbu_product_review_0,
    dbu_product_review_3_star,
    dbu_product_review_2_star,
    dbu_product_review_1_star,
    dbu_product_review_Read_all,
    dbu_product_review_reviews
  }
  //labels ends//
    
    connectedCallback() {
      for(let i = 0; i<=100; i++){
        this.mapData.set(i+'','bar'+i);
      }
    }
    @wire(fetchProductById,{urlParam:window.location.href})
    wireProduct({ error, data }) {
        console.log('urlParam:window.location.href=>'+window.location.href);
        if (data) {
           console.log("product review data " + data);
            this.productDetails = data;  
            this.product = this.productDetails[0].averageRating;
            this.numberOfReviewss =this.productDetails[0].numberOfReviews;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.productDetails = undefined;
        }
    }     
    get calculatedStarRating(){
       var mapObj = new Map();
       mapObj.set(0,"star-ratingsZero");
       mapObj.set(1.0,"star-ratingsOne");
       mapObj.set(1.1,"star-ratingsOne-POne");
       mapObj.set(1.2,"star-ratingsOne-PTwo");
       mapObj.set(1.3,"star-ratingsOne-PThree");
       mapObj.set(1.4,"star-ratingsOne-PFour");
       mapObj.set(1.5,"star-ratingsOne-PFive");
       mapObj.set(1.6,"star-ratingsOne-PSix");
       mapObj.set(1.7,"star-ratingsOne-PSeven");
       mapObj.set(1.8,"star-ratingsOne-PEight");
       mapObj.set(1.9,"star-ratingsOne-PNine");
       mapObj.set(2.0,"star-ratingsTwo");
       mapObj.set(2.1,"star-ratingsTwo-POne");
       mapObj.set(2.2,"star-ratingsTwo-PTwo");
       mapObj.set(2.3,"star-ratingsTwo-PThree");
       mapObj.set(2.4,"star-ratingsTwo-PFour");
       mapObj.set(2.5,"star-ratingsTwo-PFive");
       mapObj.set(2.6,"star-ratingsTwo-PSix");
       mapObj.set(2.7,"star-ratingsTwo-PSeven");
       mapObj.set(2.8,"star-ratingsTwo-PEight");
       mapObj.set(2.9,"star-ratingsTwo-PNine");
       mapObj.set(3.0,"star-ratingsThree");
       mapObj.set(3.1,"star-ratingsThree-POne");
       mapObj.set(3.2,"star-ratingsThree-PTwo");
       mapObj.set(3.3,"star-ratingsThree-PThree");
       mapObj.set(3.4,"star-ratingsThree-PFour");
       mapObj.set(3.5,"star-ratingsThree-PFive");
       mapObj.set(3.6,"star-ratingsThree-PSix");
       mapObj.set(3.7,"star-ratingsThree-PSeven");
       mapObj.set(3.8,"star-ratingsThree-PEight");
       mapObj.set(3.9,"star-ratingsThree-PNine");
       mapObj.set(4.0,"star-ratingsFour");
       mapObj.set(4.1,"star-ratingsFour-POne");
       mapObj.set(4.2,"star-ratingsFour-PTwo");
       mapObj.set(4.3,"star-ratingsFour-PThree");
       mapObj.set(4.4,"star-ratingsFour-PFour");
       mapObj.set(4.5,"star-ratingsFour-PFive");
       mapObj.set(4.6,"star-ratingsFour-PSix");
       mapObj.set(4.7,"star-ratingsFour-PSeven");
       mapObj.set(4.8,"star-ratingsFour-PEight");
       mapObj.set(4.9,"star-ratingsFour-PNine");
       mapObj.set(5.0,"star-ratingsFive");
       if(mapObj.has(this.product)){
         return mapObj.get(this.product);
       }else{
         return "star-ratingsZero";
       }
     }
     @wire(getProductRating,{urlParam:window.location.href})
    wireRating({ error, data }) {
        console.log('rating url param for pid=>'+window.location.href);
        if (data) {
           console.log("product rating data " + JSON.stringify(data));
           var ratObj = new Map();
           var ratingObj = data;
           var listLength = ratingObj.length;
           
           for(var rate in ratingObj){
             if(ratObj.has(ratingObj[rate])){
               let cnt = ratObj.get(ratingObj[rate]);
               cnt += 1;
               ratObj.set(ratingObj[rate], cnt);
             }else{
               ratObj.set(ratingObj[rate], 1);
             }  
           }
           for(let i = 1; i<=5; i++){
            this.calculatingRate(ratObj,listLength,i);             
           }
           this.error = undefined;
        } else if (error) {
            this.error = error;     
        }
    }
    calculatingRate(ratObj,listLength,i){
      let count = ratObj.get(i);
      if(count == '' || count == undefined || count == null){

      }else{
      var result = (count/listLength)*100;
      let accurateresult = result.toString();
      let percentageOfData = accurateresult.substring(0,accurateresult.indexOf("."));
      if(i == 1){
        if(percentageOfData == '' || percentageOfData == null || percentageOfData == undefined){
          this.percentageOfOne = accurateresult;
        }else{
          this.percentageOfOne = percentageOfData;
        }
      }else if(i == 2){
        if(percentageOfData == '' || percentageOfData == null || percentageOfData == undefined){
          this.percentageOfTwo = accurateresult;
        }else{
          this.percentageOfTwo = percentageOfData;
        }
      }else if(i == 3){
        if(percentageOfData == '' || percentageOfData == null || percentageOfData == undefined){
          this.percentageOfThree = accurateresult;
        }else{
          this.percentageOfThree = percentageOfData;
        }
      }else if(i == 4){
        if(percentageOfData == '' || percentageOfData == null || percentageOfData == undefined){
          this.percentageOfFour = accurateresult;
        }else{
          this.percentageOfFour = percentageOfData;
        }
      }else if(i == 5){
        if(percentageOfData == '' || percentageOfData == null || percentageOfData == undefined){
          this.percentageOfFive = accurateresult;
        }else{
          this.percentageOfFive = percentageOfData;
        }
      }  
    }
      
    }
    get fiveStarRating(){
      if(this.mapData.has(this.percentageOfFive)){
        return this.mapData.get(this.percentageOfFive);
      }else{
        return this.mapData.get('0');
      }
    }
    get fourStarRating(){
      if(this.mapData.has(this.percentageOfFour)){
        return this.mapData.get(this.percentageOfFour);
      }else{
        return this.mapData.get('0');
      }
    }
    get threeStarRating(){
      if(this.mapData.has(this.percentageOfThree)){
        return this.mapData.get(this.percentageOfThree);
      }else{
        return this.mapData.get('0');
      }
    }
    get twoStarRating(){
      if(this.mapData.has(this.percentageOfTwo)){
        return this.mapData.get(this.percentageOfTwo);
      }else{
        return this.mapData.get('0');
      }
    }
    get oneStarRating(){
      if(this.mapData.has(this.percentageOfOne)){
        return this.mapData.get(this.percentageOfOne);
      }else{
        return this.mapData.get('0');
      }
    }    
}