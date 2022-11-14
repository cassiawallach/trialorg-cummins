import {
    LightningElement,
    track
} from 'lwc';
import immediateAssesmentLabel from '@salesforce/label/c.FSL_Immediate_Assessment_Request';
import atACumminsLocLabel from '@salesforce/label/c.FSL_At_a_Cummins_Location';
import fieldServiceAtMyLocLabel from '@salesforce/label/c.FSL_Field_Service_at_My_Location';
import fieldServiceLocMessageLabel from '@salesforce/label/c.FSL_CSSP_FSLLocation_Message';

export default class FSL_CSSP_NewServiceRequest extends LightningElement {
    label = {
        immediateAssesmentLabel,
        atACumminsLocLabel,
        fieldServiceAtMyLocLabel,
        fieldServiceLocMessageLabel
    };
    @track fieldServiceLocation;
    handleFsl() {
        this.fieldServiceLocation = true;
    }
    handleCumminsLoc() {
        let urlString = window.location.origin;
        //alert('urlString<> '+urlString);
        // window.location.href = urlString + "/" + "cssp" + "/s/" + "servicetab";
        window.location.href = urlString + "/" + "cssp" + "/s/" + "location";
        this.fieldServiceLocation = false;
        sessionStorage.clear();

    }
}