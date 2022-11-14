import { LightningElement, wire, track } from 'lwc';
import getAnnouncementDetailsList from '@salesforce/apex/FSL_CL_AnnouncementDetails.getAnnouncements';
import getPSNValue from '@salesforce/apex/FSL_CL_AnnouncementDetails.fetchPSNValue';
import announcmentText from '@salesforce/label/c.FSL_Announcement';
export default class Fsl_Announcements extends LightningElement {

    label = {
        announcmentText
      };

    @track announcementDetails;
    @track error;
    @track psnValue;
    navURL;

    navigateToDetail() {
        let urlString = window.location.origin;
        //alert(urlString);
        window.location.href = urlString + "/" + "evolution" + "/s/announcements";
        this.navURL = urlString + "/" + "evolution" + "/s/announcements";

      }

    @wire(getAnnouncementDetailsList)
    wiredAnnouncementDetails({ error, data }) {
        if (data != null && data != '' && data != 'undefined') {
            this.announcementDetails = data;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }

    connectedCallback(){
        let urlString = window.location.origin;
        this.navURL = urlString + "/" + "evolution" + "/s/announcements";

        getPSNValue()
        .then(result => {
            this.psnValue = result;
            this.error = undefined;
        })
        .catch(error => {
            this.error = error;
            this.psnValue = undefined;
        });
   } 
}