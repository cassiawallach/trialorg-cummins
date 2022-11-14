import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import FooterInsta from '@salesforce/resourceUrl/FooterInstaIcon';
import FooterFacebook from '@salesforce/resourceUrl/FooterFbIcon';
import FooterLinkedin from '@salesforce/resourceUrl/FooterLinkedinIcon';
import FooterYoutube from '@salesforce/resourceUrl/FooterYoutubeIcon';
import FooterTwitter from '@salesforce/resourceUrl/FooterTwitterIcon';
import { invokeGoogleAnalyticsService } from 'c/dbu_GoogleAnalyticsServiceComponent';


export default class Dbu_ftrImages extends NavigationMixin (LightningElement) {
    facebookIcon = FooterFacebook+ '#facebook';
    linkedinIcon =FooterLinkedin+'#linkedin';
    twitterIcon=FooterTwitter+'#twitter';
    instaIcon =FooterInsta+'#insta';
    youtubeIcon=FooterYoutube+'#youtube';

    @track youtubeUrl = 'https://www.youtube.com/user/CumminsInc';
    @track facebookUrl = 'https://www.facebook.com/Cummins/';
    @track twitrUrl = 'https://twitter.com/cummins';
    @track instagramURL = 'https://www.instagram.com/cummins/?hl=en';

    handleYoutube(){
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Youtube Icon click', eventCategory : 'External Link', eventLabel : this.youtubeUrl});                 
    }

    get gotoyoutubeurl(){
        return this.youtubeUrl;
    }

    handlefbUrl(){
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Facebook Icon click', eventCategory : 'External Link', eventLabel : this.facebookUrl});                 
    }

    get gotoFbURL(){
        return this.facebookUrl;
    }

    handletwitrUrl(){
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Twitter Icon click', eventCategory : 'External Link', eventLabel : this.twitrUrl});                         
    }

    get gototwitrurl(){
        return this.twitrUrl;
    }

    handleinstagrm(){
        invokeGoogleAnalyticsService('EXTERNAL LINK', {eventAction : 'Instagram Icon click', eventCategory : 'External Link', eventLabel : this.instagramURL});                                 
    }

    get gotoinstagrm(){
        return this.instagramURL;
    }
}