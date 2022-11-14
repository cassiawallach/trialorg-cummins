import { LightningElement,track } from 'lwc';
import pubsub from 'c/pubsub' ;
import headerdisplaybanner from '@salesforce/label/c.dbu_headerdisplaybanner';
import isBannerOpen from '@salesforce/label/c.dbu_isBannerOpen';
import isBarOpen from '@salesforce/label/c.dbu_isBarOpen';
import cookiesExpiresDays from '@salesforce/label/c.dbu_cookiesExpiresDays';
import headerBanner from '@salesforce/label/c.dbu_headerBanner';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';

export default class Dbu_headerDisplayBanner extends LightningElement {
    @track isModalOpen = true;
    @track headerdisplaybannerText = headerdisplaybanner;
    @track isBannerOpen = isBannerOpen;
    @track isBarOpen = isBarOpen;
    @track cookiesExpiresDays = cookiesExpiresDays;
    @track headerBanner = headerBanner;

    closeModal() {
        // to close modal set isModalOpen tarck value as false
        //this.getCookie('headerBanner');
        this.isModalOpen = false;
        invokeGoogleAnalyticsService('CLOSEXMARKBANNER', 'Close X Mark banner'); 

        pubsub.fire(this.isBannerOpen,this.isModalOpen);
        pubsub.fire(this.isBarOpen,this.isModalOpen);
        
        this.createCookie(this.headerBanner, 'true' ,this.cookiesExpiresDays);
        
        console.log('isBannerOpen is fired'+this.isModalOpen);
    }

    createCookie(name, value, days){
        var expires;
        
        if(days){
            var date = new Date();
            date.setTime(date.getTime() + (days * 24* 60 * 60 * 1000));
            expires = "; expires=" + date.toGMTString();
        }
        else {
            expires = "";
        }
        document.cookie = name + "=" + escape(value) + expires + "; path=/";
    }
    getCookie(name){
        var name = name + "=";
      var ca = document.cookie.split(';');
      for(var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
          c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
         this.data = c.substring(name.length, c.length);
        }
      }
    }
    connectedCallback() {
        this.getCookie(this.headerBanner);
       
        if(this.data=='true'){
            this.isModalOpen = false;
        } 
    }    
    printPage (){    
        window.print();
    }

}