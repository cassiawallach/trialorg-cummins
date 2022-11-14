import {
    LightningElement,
    api,
    track
} from 'lwc';
import getFilesList from "@salesforce/apex/FSL_FileUploadController.getFilesList";
import updateWorkOrder from "@salesforce/apex/FSL_FileUploadController.updateWorkOrder";
import deleteSelectedFiles from "@salesforce/apex/FSL_FileUploadController.deleteSelectedFiles";
import DeleteFile from '@salesforce/label/c.Delete_File';
import fileUploadLabel from '@salesforce/label/c.FSL_CSSP_File_Upload_Section';
import multipleFilesLabel from '@salesforce/label/c.FSL_CSSP_multiple_files';
import confirmLabel from '@salesforce/label/c.FSL_CSSP_Please_Confirm';
import existingFilesLabel from '@salesforce/label/c.FSL_Cssp_Existing_Files';// Added for Story#CT4-749
import fileNameLabel from '@salesforce/label/c.FSL_Cssp_File_Name';// Added for Story#CT4-749
import actionLabel from '@salesforce/label/c.FSL_Cssp_Action';// Added for Story#CT4-749
import createdDateLabel from '@salesforce/label/c.FSL_CSSP_Created_Date';// Added for Story#CT4-749
import deleteLabel from '@salesforce/label/c.FSL_Cssp_Delete';// Added for Story#CT4-749
import cancelLabel from '@salesforce/label/c.FSL_Cssp_Cancel';// Added for Story#CT4-749
import {
    ShowToastEvent
} from 'lightning/platformShowToastEvent';

export default class fsl_cssp_fileUpload extends LightningElement {

    //********* Files Upload Logic *********
    @api recordId;
    label = {
        DeleteFile,
        fileUploadLabel,
        multipleFilesLabel,
        confirmLabel,
        existingFilesLabel,
        fileNameLabel,
        actionLabel,
        createdDateLabel,
        deleteLabel,
        cancelLabel


    };
    /*     get acceptedFormats() {
            return ['.png', '.PNG', '.jpg', '.JPG', '.pdf', '.PDF', '.txt', '.TXT', '.docx', '.DOCX', '.xlxs', '.XLXS'];
        } */
     
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        console.log('@@@Load file'+JSON.stringify(uploadedFiles));
        let contentDocIds = [];
        for(let i=0; i< uploadedFiles.length; i++)
        {
            contentDocIds.push(uploadedFiles[i].documentId);
        }
        console.log('contentDocIds===='+contentDocIds);
        this.updateWorkOrderRecords(contentDocIds);
        //this.showNotification(uploadedFiles.length + ' files are Uploaded Successfully', 'success');
        this.onLoad();
    }

    updateWorkOrderRecords(contentDocIds) {
        console.log('contentDocIds==@@@=='+contentDocIds);
        this.isLoading = true;

        updateWorkOrder({
                contentIds : contentDocIds
            })
            .then((res) => {
                this.isLoading = false;
            })
            .catch((err) => {
                console.log('err====='+JSON.stringify(err));
                this.showNotification(err.body.message, 'error');
                this.isLoading = false;
            });
    }
    /* showNotification(message, variant) {
        
        const evt = new ShowToastEvent({
            'message': message,
            'variant': variant
        });
        this.dispatchEvent(evt);
        
        const valueChangeEvent = new CustomEvent("filesave", {
            detail: {
                isAllFilesUploaded: true
            }
        });

        this.dispatchEvent(valueChangeEvent);
    }
    */

    //********* Files List Logic *********
    selectedFile;
    isLoading = false;
    isConfirmOpen = false;
    filesList;
    columns;

    connectedCallback() {
        this.onLoad();
    }

    get showFilesList() {
        let flsLst = this.filesList;
        if (flsLst && flsLst.length > 0) {
            return true;
        }
        return false;
    }

    onLoad() {
        this.getFiles();

        this.columns = [{
                label: this.label.actionLabel,
                type: "button",
                initialWidth: 135,
                typeAttributes: {
                    label: "",
                    title: "Click to delete file",
                    iconName: "action:delete"
                },
                wrapText: true
            },
            {
                label: this.label.fileNameLabel,
                fieldName: "fileName",
                type: "text",
                wrapText: true
            },
            {
                label: this.label.createdDateLabel,
                fieldName: "createdDate",
                type: "date",
                typeAttributes: {
                    year: "numeric",
                    month: "2-digit",
                    day: "2-digit",
                    hour: "2-digit",
                    minute: "2-digit",
                    hour12: true
                },
                wrapText: true
            }
        ];
    }

    getFiles() {
        this.isLoading = true;

        getFilesList({
                linkedEntyIds: [this.recordId],
            })
            .then((res) => {
                let rows = res.contentDocList;
                let values = [];
                //looping through each row of the result
                for (let i = 0; i < rows.length; i++) {
                    let forPush = {
                        contentDocumentId: rows[i].ContentDocumentId,
                        fileName: rows[i].ContentDocument.Title,
                        createdDate: rows[i].ContentDocument.CreatedDate
                    };
                    values.push(forPush);
                }
                this.filesList = values;
                this.isLoading = false;
            })
            .catch((err) => {
                console.log(JSON.stringify(err));
                this.showNotification(err.body.message, 'error');
                this.isLoading = false;
            });
    }

    closeModal() {
        this.isConfirmOpen = false;
    }

    removeItem() {
        this.isConfirmOpen = false;
        this.isLoading = true;
        deleteSelectedFiles({
                contentDocIds: [this.selectedFile]
            })
            .then((data) => {
                this.isLoading = false;
                this.onLoad();
            })
            .catch((err) => {
                console.log(JSON.stringify(err));
                this.showNotification(err.body.message, 'error');
                this.isLoading = false;
            });
    }

    handleRemove(event) {
        this.isConfirmOpen = true;
        this.selectedFile = event.detail.row.contentDocumentId;
    }

    showNotification(message, variant) {
        const evt = new ShowToastEvent({
            'message': message,
            'variant': variant
        });
        this.dispatchEvent(evt);
    }
}