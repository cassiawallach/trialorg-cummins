//Rama Patchigolla ROAD 510
import { LightningElement } from 'lwc';
import Hover_Text from '@salesforce/contentAssetUrl/unknown_content_asset'; //Getting FTR icon from files
import FtrHoverText from '@salesforce/label/c.FSL_FTR_HoverText'; //Label for hover text

export default class AssetFileExample extends LightningElement {
    // Expose URL of assets included inside an archive file
    HoverTexturl = Hover_Text;
    label={FtrHoverText};
}