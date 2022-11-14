import { LightningElement, wire, track, api } from 'lwc';
//import getAnnouncementDetailsList from '@salesforce/apex/FSL_CL_AnnouncementDetails.getAnnouncementDetails';
import getAllAnnouncements from '@salesforce/apex/FSL_CL_AnnouncementDetails.getAllAnnouncements';
import getRelatedFilesByRecordId from '@salesforce/apex/FSL_CL_AnnouncementDetails.getRelatedFilesByRecordId';
import userProfile from '@salesforce/apex/FSL_CL_AnnouncementDetails.fetchUserRole';

import releaseNotesLink from '@salesforce/label/c.FSL_CSSP_Customer_Clickhere';
import announcementHeader from '@salesforce/label/c.FSL_Announcement_Header';
import updateAnnouncements from '@salesforce/label/c.FSL_UpdateAnnouncementDetails';


export default class FSL_Announcements_DetailView extends LightningElement {

    label = {
        releaseNotesLink,
        announcementHeader,
        updateAnnouncements
      };

    @track announcementDetails;
    @track adminUser;
    @track error;
    recIDs = []
    @wire(getAllAnnouncements)
    wiredAnnouncementDetails({ error, data }) {
        if (data) {
            console.log(data)
            this.announcementDetails = data;

            console.log(data.Id)

            this.announcementDetails.forEach(rec =>{
                console.log(rec.Id)
                this.recIDs.push(rec.Id)
                
            })
            console.log(this.recIDs)
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }


    navURL;
    navigateToUpdate() {
        let urlString = window.location.origin;
        //alert(urlString);
        window.location.href = urlString + "/" + "evolution" + "/s/announcementsupdate";
        this.navURL = urlString + "/" + "evolution" + "/s/announcementsupdate";

    }

    @wire(userProfile)
    wiredUserProfile({ error, data }) {
        if (data) {
            console.log(data)
            this.adminUser = data;
        } else if (error) {
            console.log(error);
            this.error = error;
        }
    }
    
    
    connectedCallback(){
        //userProfile;
        console.log(userProfile);
        let urlString = window.location.origin;
        this.navURL = urlString + "/" + "evolution" + "/s/announcementsupdate";
    } 

}