import { LightningElement,api, track, wire } from 'lwc';
import getRelatedFilesByRecordId from '@salesforce/apex/FSL_CL_AnnouncementDetails.getRelatedFilesByRecordId'
import associatedFile from '@salesforce/label/c.FSL_AssociatedFile';


export default class EVL_GetAnnouncementFiles extends LightningElement {
    label = {
        associatedFile
    }

    @api recordId
    filesList =[]
    @wire(getRelatedFilesByRecordId, {recordId: '$recordId'})
    wiredResult({data, error}){ 
        if(data){ 
            console.log(data)
            this.filesList = Object.keys(data).map(item=>({"label":data[item],
            "value": item,
            "url":`/sfc/servlet.shepherd/document/download/${item}`
            }))
            console.log(this.filesList)
        }
        if(error){ 
            console.log(error)
        }
    }
}