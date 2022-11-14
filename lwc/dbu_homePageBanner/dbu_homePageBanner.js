import {
    LightningElement, track
} from 'lwc';
import pubsub from 'c/pubsub';
import storeUSA from '@salesforce/label/c.dbu_home_store_U_S_A'; //custom label refres to'US'
import storeCA from '@salesforce/label/c.dbu_home_store_Canada'; //custom label refres to'EN'
import storeCAF from '@salesforce/label/c.dbu_home_store_Canada_French'; //custom label refres to'FR'
import headerBanner from '@salesforce/label/c.dbu_headerBanner';
import isBarOpen from '@salesforce/label/c.dbu_isBarOpen';
import dbu_slider_scroll_duration from '@salesforce/label/c.dbu_slider_scroll_duration';
import getHomePageBannersData from '@salesforce/apex/dbu_CustomsettingCntrl.getHomePageBannersData';
import getBannerImages from '@salesforce/apex/dbu_Integration_ProductCloudfrontImages.getProductImages';
import { loadStyle, loadScript } from 'lightning/platformResourceLoader';
import glideCarousel from '@salesforce/resourceUrl/GlideCarousel'
import communityName from '@salesforce/label/c.dbu_communityName';
import homeBannerDuration from '@salesforce/label/c.dbu_homeBannerDuration';

export default class Dbu_homePageBanner extends LightningElement {
    IsDisplayBannerShown = true;
    data = false;
    storeLocation;
    isUsLoacation = true;
    @track banners = [];
    bannerDataReady = false;
    slider_scroll_duration = dbu_slider_scroll_duration;
    @track baseURL;

    getCookie(val) {
        let name = val + "=";
        let ca = document.cookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) === ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) === 0) {
                this.data = c.substring(name.length, c.length);
            }
        }
    }
    renderedCallback() {
        Promise.all([
            loadScript(this, glideCarousel + '/glide.js'),
            loadStyle(this, glideCarousel + '/glide.core.css'),
            loadStyle(this, glideCarousel + '/glide.theme.css'),
        ]).then(() => {
            console.log("From Glide Load Successful");
            this.initializeGlide();
        });
    }

    connectedCallback() {
        this.baseURL = window.location.origin + communityName;
        this.storeLocation = window.sessionStorage.getItem('setCountryCode');
        if (this.storeLocation === '' || this.storeLocation === null || this.storeLocation === storeUSA) {
            this.isUsLoacation = true;
            this.storeLocation = storeUSA;
        }
        if (this.storeLocation === storeCA || this.storeLocation === storeCAF) {
            this.isUsLoacation = false;
        }
        this.getCookie(headerBanner);
        if (this.data === 'true') {
            this.IsDisplayBannerShown = false;
        }
        getHomePageBannersData({}).then(results => {
            let resultsData = JSON.parse(results);
            let bannerNum = 0;
            for (let recCount = 0; recCount < resultsData.length; recCount++) {
                if (resultsData[recCount].dbu_store__c.toUpperCase().includes(this.storeLocation)) {
                    getBannerImages({
                        imageURL: resultsData[recCount].dbu_src_img__c,
                        accessToken: ''
                    }).then(s3Img => s3Img).then(res => {
                        if (!!res) {
                            console.log("From Connected");
                            this.banners.push({
                                src: res.replaceAll('"', ''),
                                //src: resultsData[recCount].dbu_src_img__c,
                                header: resultsData[recCount].dbu_header_message__c,
                                description: resultsData[recCount].dbu_description__c,
                                //href: resultsData[recCount].dbu_href_url__c + this.storeLocation,
                                srNo: resultsData[recCount].dbu_banner_serial_number__c,
                                bulletKey: "="+bannerNum++,
                                subtitle: resultsData[recCount].dbu_sub_title__c,
                                bannerTitle: resultsData[recCount].dbu_Banner_Title__c,
                                //bannerPosition: resultsData[recCount].dbu_Banner_Position__c,
                                //buttonBgColor: resultsData[recCount].dbu_Button_bg_color__c,
                                //buttonTextColor: resultsData[recCount].dbu_Button_Text_color__c,
                                buttonText: resultsData[recCount].dbu_Button_text__c,
                                glideContentsClass: "glide-contents "+resultsData[recCount].dbu_Banner_Position__c,
                                glideButtonClass: "glide_button banner-button "+resultsData[recCount].dbu_Button_bg_color__c+"Bg "+resultsData[recCount].dbu_Button_Text_color__c+"Txt fSize"+resultsData[recCount].dbu_Button_font_size__c,
                                href: resultsData[recCount].dbu_Link_Type__c == "URL" ? resultsData[recCount].dbu_href_url__c + this.storeLocation : this.baseURL + (resultsData[recCount].dbu_Link_Type__c == "Category" ? "categories/" + resultsData[recCount].dbu_Category_Link__c : "product/" + resultsData[recCount].dbu_Product_Link__c) + "/?store=" + this.storeLocation,
                                target: resultsData[recCount].dbu_New_Window__c == true ? "_blank" : "_self"
                            });
                        }
                    }).catch(error => {
                        console.log('error:', error);
                    }).finally(() => {
                        this.bannerDataReady = true;
                        if (this.banners.length > 0) {
                            this.banners.sort((a, b) => {
                                if (a.srNo > b.srNo) return 1;
                                if (b.srNo > a.srNo) return -1;
                                return 0;
                            });
                        }
                    });
                }
            }
        });
        this.regiser();
    }
    initializeGlide() {
        const carousel = this.template.querySelector('div[class="glide"]');
        //window.$(carousel).glide().mount();
        const glideOpts = new Glide(carousel, {
            type: 'carousel',
            startAt: 0,
            perView: 1,
            focusAt: 'center',
            gap: 0,
            autoplay: parseInt(homeBannerDuration),
            hoverpause: true,
            keyboard: true
        });
        if(this.banners.length <= 1) {
            this.template.querySelector('div[class="glide__bullets"]').style.display = "none";
            return;
        }
        else{
            this.template.querySelector('div[class="glide__bullets"]').style.display = "inline-flex";
        }
        if(this.bannerDataReady){
            glideOpts.mount();
        }

    }
    regiser() {
        pubsub.register(isBarOpen, this.handleIsModelClosed.bind(this));
    }

    handleIsModelClosed(event) {
        this.IsDisplayBannerShown = event;
    }

    get mainCss() {
        return this.IsDisplayBannerShown ? 'banner_width-with-displaybanner' : 'banner_width-without-displaybanner';
    }
}