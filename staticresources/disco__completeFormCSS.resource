html,body {
	height:auto;
	/*height:100%; removed, doesnt reach bottom of long forms */
	width:auto;
	font-family: 'Salesforce Sans';
}

/* Chrome, Safari, Edge, Opera */
input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
	-webkit-appearance: none;
  	margin: 0;
}

/* Firefox */
input[type=number] {
  	-moz-appearance: textfield;
}

.containerBox input[type=text],[type=number],[type=date],[type=datetime-local],[type=url],[type=phone],[type=email] {
	width: 100%;
	max-width:250px;	
}

.alertErrorContainer {
	display:block;
	margin:0 auto;
	width:500px;
	text-align: center;
}
.page-error-cont {
	text-align: center;
	width: 400px;
	max-width: 90%;
	margin: 40px auto;
	padding: 20px;
	background-color: #353f54;
	color: #fff;
	border-radius: 10px;
}

.page-error-cont .cancelBtn {
	background:none; /* don't show SF background image */
	background-color: #E7E7E7;
	color: #353F54;
	border: 1px solid #E7E7E7;
}
/* .page-error-cont .cancelBtn:hover {
	color: #E7E7E7;
	background-color: #353F54;
} */

/* remove linked section button (X) */
.remove-linked-section {
	cursor:pointer;
}

/*lookup field needs to be smaller due to lookup icon (leave some buffer % for mag glass icon that cant adjust)*/
.lookupInput input[type=text] {
	width:80%;
}
/* lookup mag glass icon*/
.lookupInput a {
	width:12%;
}
/* remove margin right defined for mag glass icon by SF*/
.lookupInput img {
	margin-right:0px;
}

.containerBox textarea {
	max-width:100%;
	min-width: 250px;
}

.containerBox select {
	width: 98%;
	max-width: 250px;
}

.containerBox input, .containerBox select {
	max-height:100px; 
    -moz-box-sizing: border-box;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
/*This was causing issues with select.goToPage.
 I left it commented out incase removing it breaks other things*/
/*.containerBox input, select:not([multiple]) {
	height:28px !important;
}*/

.containerBox {
	height:100%;
	border-bottom: 1px solid black;
}
.containerBox h2 {
	display:block;
	font-size:20px;
	padding-top:10px;
	padding-bottom:10px;	
	margin:0;
	border-top:1px solid black;
}

.answerColumn {
	vertical-align:top;
	display:inline-block;
	width:49%;
}

/* page X of X text*/
.paginationBlock {
	margin:20px auto;
	height:30px;
	line-height:30px;
}
.buttons .paginationBlock .prevPage {
	float:left;
	width:20px;
}
.buttons .paginationBlock .nextPage {
	float:right;
	width:20px;
}

/* fix to make scrollbar on multi-select picklists always display*/
.multiselectList {
    overflow-y: auto;
    border: 1px solid black;
    height: 3em;
    width: 10em;
    line-height: 1em;
}
.multiselectList::-webkit-scrollbar {
    -webkit-appearance: none;
}
.multiselectList::-webkit-scrollbar:vertical {
    width: 11px;
}
.multiselectList::-webkit-scrollbar:horizontal {
    height: 11px;
}
.multiselectList::-webkit-scrollbar-thumb {
    border-radius: 8px;
    border: 2px solid white; /* should match background, can't be transparent */
    background-color: rgba(0, 0, 0, .5);
}

.ms-selectable {
	max-height: 300px;
	overflow-y: scroll;
	width: 100%;
	max-width: 250px;
}

/* Styling for Web MS Picklists */
ol.ui-selectable .ui-selecting { 
	background: #d8edff; 
}

ol.ui-selectable .ui-selected { 
	background: #54698d; 
	color: white; 
}

ol.ui-selectable { 
    list-style-type: none; 
    margin: 0; 
    padding: .25rem;
    width: 60%; 
    border-radius: .25rem;
    background-clip: padding-box;
    border: 1px solid #d8dde6;
    width: 100%;
	max-width: 250px;
 }

ol.ui-selectable li.ui-widget-content { 
    margin: 3px; 
    padding: 0.4em; 
    font-size: 1em; 
    min-height: 18px; 
    padding: 1rem;
	border-radius: .25rem;
	background-clip: padding-box;
	border: 1px solid #d8dde6;
}


/* override standard required style to not wrap */
.requiredInput {
	display:inline-block;
	width:100%;
}	

/* override salesforce input width for date style */
.dateOnlyInput input {
	width:206px;
}

/* helps with aligning form in the center */
.formContent {		
	display:inline-block;
	text-align:left;	
	margin-bottom:20px;
	width:100%;
}

.helperText {
	font-size:12px;
	font-weight:bold;
}


.requiredBlock {
	width:2%;
	max-width:3px;
	display:inline-block;
	vertical-align:top;
	height:28px;
	background-color:red;
}

.buttons {
	text-align:center;
	padding-top:10px;
	padding-bottom:10px;
	border-top: 1px solid black;
}

.indentOnce {
	padding-left:20px;
}
.indentTwice {
	padding-left:40px;
}
.indentThrice {
	padding-left:60px;
}

.question-camera_toucharea,
.question-gallery_toucharea {
	min-height: 40px;
	min-width: 40px;
}

.containerBox form {
	width:80%;
	margin: 0 auto;		
	text-align:center;
	min-height:100%;
}

/* reduce padding */
.slds-scope .free-text-container .ql-editor {
    padding:0;
}

/* don't show SF todays date text */
.dateFormat {
	display:none;
}

/* stop bootstrap from applying width to datepicker modal */
.datePicker select {
	width:auto;
}


       
.lengthError, .blankError, .decimalError, .emailError {
	color:red;
	font-size:12px;
}

/* override standard bootstrap style for disabled input so it stays on the same line */
.uneditable-input {
	display:block !important;
}

.returnLink {
	text-align:left;
	display:block;
	margin-left:5px;
	margin-bottom:5px;
	font-size:16px;
}

/* labels have normal cursors */
label {
	cursor:default;
}

/* proper spacing of long picklist texts */
#completeFormPage label.slds-radio.radio-list ,
#completeFormPage .slds-form-element__control label.slds-checkbox {
    display: flex;
 }

.slds-scope label.slds-radio .slds-form-element__label,
.slds-scope label.slds-checkbox .slds-form-element__label {
    flex: 0 1 auto;
 }

.slds-scope label.slds-radio .slds-radio--faux,
.slds-scope label.slds-checkbox .slds-checkbox--faux {
	margin-top:2px;
	flex: 0 0 auto;
}

/* give color to disabled picklists on form display page by overriding SLDS disabled color*/
#completeFormPage .currentPageContainer .slds-checkbox [type="checkbox"][disabled] + .slds-checkbox--faux:after,
#completeFormPage .currentPageContainer .slds-checkbox [type="checkbox"][disabled] ~ .slds-checkbox--faux:after,
#completeFormPage .currentPageContainer .slds-radio [type="radio"][disabled] + .slds-radio--faux:after,
#completeFormPage .currentPageContainer .slds-radio [type="radio"][disabled] ~ .slds-radio--faux:after {
	border-color: #1589EE;
}

.slds-scope .slds-has-error .slds-input[disabled] {
	background-color: #ecebea;
}

body#complete-form.slds-scope div.errorSummary {
	margin-bottom: -14px;
	text-align: center;
	color: #fff;
	border: 0;
	padding: 10px 0;
	background-color: #c23934;
}

body#complete-form.slds-scope div.errorSummary div {
	margin-top: 10px;
}

body#complete-form.slds-scope div.errorSummary div button.slds-button {
	margin: 0 5px;
}

body#complete-form.slds-scope div.errorSummary div button.slds-button svg {
	margin-top: -1px;
}

body#complete-form.slds-scope.has-errors:not(.cf-error-guided-mode):not(.ls-modal-open) {
	padding-top: 40px;
}

body#complete-form.slds-scope.has-errors.cf-error-guided-mode:not(.ls-modal-open) {
	padding-top: 80px;
}

body#complete-form.slds-scope.ls-modal-open div.error.errorSummary {
	display:none!important;
}

body#complete-form.slds-scope:not(.cf-error-guided-mode) .cf-errors-buttons-message, body#complete-form.slds-scope:not(.cf-error-guided-mode) .cf-errors-buttons  {
	display: none;
}

/* format for printing */
@media print {
	#sidebarCell,
	#bPageTitle,
	#chatterfeedshell,
	#AppBodyHeader,
	#section_header,
	#completeFormPage div.buttons {
		display:none;
	}

	#completeFormPage {
		background-color:#fff;
		font-size:12px;
		width: 100%; 
		margin: 0; 
		float: none; 
	}

	#completeFormPage .nav-container {
		display:none;
	}

	#completeFormPage select[multiple] option:checked {
		border: 1px solid #1589EE;
		border-radius: 2px;
	}

	#completeFormPage .slds-radio [type="radio"]:checked + .slds-radio--faux:after,
	#completeFormPage .slds-radio [type="radio"]:checked ~ .slds-radio--faux:after {
		background-color: #1589EE;
		border: 5px solid #1589EE;
	}
}

/*override bootstrap form elements to be percentage based */
.form-horizontal .control-label {
	width:45%;
}
.form-horizontal .controls {
	margin-left:50%;
	width:45%;
}

/* button styles for SF and bootstrap are conflicting, override them here 
.buttons .btn-primary {
	background:none;
	background-color:#006dcc;
	color:white;
	border-color:rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
	height:30px;
}
.buttons .btn-primary:hover {
	background-color:#0044cc;
}
.buttons .btn-primary {
	background:none;
	background-color:#006dcc;
	color:white;
	border-color:rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
	height:30px;
	width:120px;
	margin: 1px 3px;	
}
.buttons .btn {
	background:none;
	height:30px;
	background-color:#f5f5f5;
	color:#333333;
	width:120px;
	text-shadow:none;
	margin: 1px 3px;
}
.buttons .btn:hover {
	background-color:#e6e6e6;
}
*/
.buttons .btn {
	width: 150px;
	margin: 0 5px;
}

.sigNav{
	display: block;
}

/* For E-Sigs in either 1 Column or 2 Column Layouts */
.slds-scope .form-section .control-group.esig-container {
    min-width: 250px;
    min-height: 80px;
}
.slds-scope .form-section .controls.esig-container {
    min-width: 250px;
    min-height: 80px;
    height: 80px;
}

.slds-scope .edit-linkedsection-buttons .remove-linkedsection-icon {
    background-color: rgb(36,45,59);
    border-color:  rgb(36,45,59);
    color: white;
}
.slds-scope .edit-linkedsection-buttons .remove-linkedsection-icon:hover {
    background-color: black;
    border-color:  black;
}

body div.buttons-backdrop.slds-backdrop {
	height: 104px;
}
.form-content div.ls-card button.slds-card,
#formContent div.ls-card button.slds-card {
	width: 100%;
}
.form-content div.ls-card p,
#formContent div.ls-card p {
	min-height: 1.5em;
}
.form-content div.ls-card,
#formContent div.ls-card,
.form-content div.ls-card-add-container,
#formContent div.ls-card-add-container {
	margin: 0;
	cursor: pointer;
	border-right: 1px solid rgb(221, 219, 218);
	border-left: 1px solid rgb(221, 219, 218);
	background-color: rgb(244, 246, 249);
	padding: 2px;
}
.form-content div.ls-card,
#formContent div.ls-card {
	color: rgb(62, 62, 60);
}
.form-content div.ls-card .slds-card:hover,
#formContent div.ls-card .slds-card:hover {
	background-color: rgb(244, 246, 249);
}
.form-content div.ls-card.error .slds-card,
#formContent div.ls-card.error .slds-card {
	border-color:red;
	color:red !important; /* override any other styling since its an error warning */
}
.form-content div.ls-card.error .ls-icon,
#formContent div.ls-card.error .ls-icon {
	background-color: red !important; /* override any other styling since its an error warning */
}
.form-content div.ls-card.error .slds-card span.ls-card-label,
#formContent div.ls-card.error .slds-card span.ls-card-label{
	color:red !important; /* override any other styling since its an error warning */
}
.form-content div.ls-card-add-container,
#formContent div.ls-card-add-container {
	border-bottom-right-radius: 4px;
	border-bottom-left-radius: 4px;
	border-bottom: 1px solid rgb(221, 219, 218);
}
.form-content .ls-card-header.slds-card,
#formContent .ls-card-header.slds-card  {
	border-bottom-right-radius: 0;
	border-bottom-left-radius: 0;
}
.form-content div.form-section.slds-card.js-uses-ls-card,
#formContent div.form-section.slds-card.js-uses-ls-card {
	display: none !important; /*override the inline declaration */
}

/* moved the deleted icon over if there is a section icon */
.form-content .ls-icon ~ .slds-card__header .linked-section-icon-container,
#formContent .ls-icon ~ .slds-card__header .linked-section-icon-container {
	margin-left: 18px;
}

.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal,
#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal {
	display: block !important; /*override the inline declaration */
	position: fixed;
	top: 104px;
	left: 0;
	right: 0;
	bottom: 0;
	z-index: 1000;
	margin: 0;
	max-height: calc(100% - 104px);
}

.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal.js-section-delete,
#formContent div.form-section.slds-card.ls-group-changed-input.js-section-delete,
#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal.js-section-delete {
	display: none !important;
}

.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal .slds-card__body,
#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal .slds-card__body {
	height: calc(100% - 88px);
	max-height: calc(100% - 88px);
	overflow: scroll;
}
.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal .slds-card__footer,
#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal .slds-card__footer {
	padding: 4px;
}

.form-content div.ls-card .slds-card .edit-linked-section,
#formContent div.ls-card .slds-card .edit-linked-section {
	position: absolute;
	right: 15px;
	top: 15px;
}

.form-content .form-section.slds-card.js-uses-ls-card button.add-linked-section,
#formContent .form-section.slds-card.js-uses-ls-card button.add-linked-section {
	display: none;
}

.form-content .formInput.geolocation-input.slds-input:active,
#formContent .formInput.geolocation-input.slds-input:active,
.form-content .formInput.geolocation-input.slds-input:focus,
#formContent .formInput.geolocation-input.slds-input:focus
{
	box-shadow: none;
}

.form-content .formInput.geolocation-input.error.slds-input:active,
#formContent .formInput.geolocation-input.error.slds-input:active,
.form-content .formInput.geolocation-input.error.slds-input:focus,
#formContent .formInput.geolocation-input.error.slds-input:focus
{
	box-shadow: #c23934 0 0 0 1px inset;
}

.slds-scope .slds-input:active, .slds-scope .slds-input:focus
.form-content button.add-linked-section-card,
#formContent button.add-linked-section-card {
	width: 100%;
}

.form-content .ls-card .ls-icon,
#formContent .ls-card .ls-icon,
.form-content .ls-card-header .ls-icon,
#formContent .ls-card-header .ls-icon,
.form-content .form-section .ls-icon,
#formContent .form-section .ls-icon {
	position: absolute;
	left: 0;
	top: 0;
}
.form-content .ls-card .ls-icon,
#formContent .ls-card .ls-icon,
.form-content .form-section .ls-icon,
#formContent .form-section .ls-icon {
	padding: 3px;
}
.form-content .ls-card .ls-icon,
#formContent .ls-card .ls-icon {
	margin: -6px 4px 0px;
}
.form-content .ls-card-header .ls-icon,
#formContent .ls-card-header .ls-icon {
	padding: 2px;
}

.form-content .ls-card .slds-card .ls-icon,
#formContent .ls-card .slds-card .ls-icon {
	top: 14px;
	left: 4px;
}

.form-content div.form-section .slds-card__footer .close-linked-section,
#formContent div.form-section .slds-card__footer .close-linked-section {
	margin-bottom:0;
}

.autocomplete-title {
	font-weight: bold;
}

.ui-autocomplete .ui-menu-item {
	border-bottom: 1px solid black;
}

.ui-autocomplete .ui-menu-item:last-child {
	border-bottom: none;
}

.ui-autocomplete { 
	max-height: 300px; 
	overflow-y: auto; 
	overflow-x: hidden;
}

@media screen and (max-width: 706px) {
	body div.buttons-backdrop.slds-backdrop {
		height: 92px;
	}
	.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal,
	#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal {
		top: 92px;
	}
}
@media screen and (max-width: 615px) {
	body div.buttons-backdrop.slds-backdrop {
		height: 122px;
	}
	.form-content div.form-section.slds-card.js-uses-ls-card.ls-modal,
	#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal{
		top: 122px;
	}	
}

@media screen and (max-width: 560px) {
	.slds-scope .form-section .answerColumn .control-group.esig-container .control-label {
		float: none;
	}

	.slds-scope .form-section .control-group textarea.slds-textarea {
		min-width: 250px;
	}

	/* For E-Sigs in 1 Column Layouts */
	.slds-scope .form-section .control-group.esig-container .control-label {
		width: 250px;
	    text-align: left;
	    float: none;
	    margin:0 auto;
	}
	.slds-scope .form-section .control-group.esig-container {
	    min-width: 250px;
	    min-height: 80px;
	    margin-left: auto;
	    margin-right: 20px;
	}
	.slds-scope .form-section .controls.esig-container {
	    min-width: 250px;
	    min-height: 80px;
	    height: 80px;
	    margin-left: auto;
	}
}

@media screen and (max-width: 1199px) {
	/* For E-Sigs in 2 Column Layouts */
	.slds-scope .form-section .answerColumn .control-group.esig-container .control-label {
	    text-align: left;
	    width: 250px;
	    margin:0 auto;
	    float: right;
	}
	.slds-scope .form-section .answerColumn .control-group.esig-container {
	    margin-left: auto;
	    margin-right: 20px;
	}
	.slds-scope .form-section .answerColumn .controls.esig-container {
	    margin-left: auto;
	}
}

/* No greater than 1199px, no less than 560px */
@media screen and (max-width: 1199px) and (min-width: 560px) {
	/* For Long Text in 2 Column Layouts */
	.slds-scope .form-section .answerColumn .controls .long-text-container {
	    max-width: 100%;
	    width: 100%;
	}
	.slds-scope .form-section .answerColumn .controls .long-text-container textarea {
	    min-width: 0;
	}
}

@media screen and (min-width: 1200px) {
	/* For Long Text in 2 Column Layouts with indentation */
	.slds-scope .form-section .answerColumn .indentThrice .controls .long-text-container textarea {
	    min-width: 0;
	    max-width: 106%;
	    width: 106%;
	} 

	.slds-scope .form-section .answerColumn .indentTwice .controls .long-text-container textarea {
	    min-width: 0;
	    max-width: 111%;
	    width: 111%;
	} 

	.slds-scope .form-section .answerColumn .indentOnce .controls .long-text-container textarea {
	    min-width: 0;
	    max-width: 115%;
	    width: 115%;
	} 

	.slds-scope .form-section .answerColumn .controls .long-text-container textarea {
	    min-width:248px;
	} 
}

/* media styles ********************************************************/

/* overriding some breakpoint styles */
@media (max-width: 1100px) {

  	
  	.indentOnce {
  		padding-left:10px;
  	}
  	.indentTwice {
  		padding-left:20px;
  	}
  	.indentThrice {
  		padding-left:30px;
  	}

}

@media (max-width: 767px) {
	body {
  		padding:0px !important;
  	}
}

@media (max-width: 680px) {
	.containerBox form, .containerBox {
  		width:100% !important;
  	}  	

  	.slds-scope .form-section textarea.slds-textarea {
		min-width: 120%;
	}
}
       


/* re-asserting the bootstrap style to make labels appear over text fields since we expanded the text field length*/
@media (max-width: 560px) {
  	.form-horizontal .indentOnce, .form-horizontal .indentTwice, .form-horizontal .indentThrice {
  		padding-left:0;
  	}

  	.slds-scope .form-section .answerColumn .control-group.esig-container .control-label {
  		float: none;
  	}

  	.answerColumn {
  		display:block;
  		width:100%;
  	}

  	.form-horizontal .controls {
  		width:95%;
  		justify-content: center;
  	}
  	
  	.containerBox form, .containerBox {
  		width:100% !important;
  	}  	
  	
  	.form-horizontal .form-section .control-label {
  		text-align:left;
  		width:100%;
  	}

  	.form-horizontal .controls {
  		margin-left: 0px !important;
  	}
  	body {
  		padding:0px !important;
  	}
}

/* TB PREVIEW: Mobile Phone */
  	#previewStatus.phone-size .form-horizontal .indentOnce, 
  	#previewStatus.phone-size .form-horizontal .indentTwice, 
  	#previewStatus.phone-size .form-horizontal .indentThrice {
  		padding-left:0;
  	}

  	#previewStatus.phone-size .answerColumn {
  		display:block;
  		width:100%;
  	}

  	.slds-scope #previewStatus.phone-size .control-group .answerValue.phoneNum {
  		width:  100%;
  		max-width:  250px;
  	}

  	.slds-scope #previewStatus.phone-size .form-horizontal .slds-form-element__control .slds-select_container {
  		text-align: center;	
  		margin: auto;
  	}

  	.slds-scope #previewStatus.phone-size .form-horizontal .ms-selectable {
  		margin:  auto;
  	}

  	#previewStatus.phone-size .form-horizontal .controls .slds-form-element.sig-element {
  		max-width:  250px;
  		margin: auto;
  	}

  	#previewStatus.phone-size .form-horizontal .controls {
  		margin-left: 0px !important;
  		text-align: center;
  		width:100%;
  	}
  	body #previewStatus.phone-size {
  		padding:0px !important;
  	}

	.slds-scope #previewStatus.phone-size .slds-form-element,
  	.slds-scope #previewStatus.phone-size .slds-form-element .slds-form-element__control,
  	.slds-scope #previewStatus.phone-size .form-section .control-group .control-label {
		float: none;
		text-align: center;
  		width:100%;
	}

	.slds-scope #previewStatus.phone-size .form-section .control-group textarea.slds-textarea {
		min-width: 250px;
		max-width: 250px;
	}
/* END TB PREVIEW: Mobile Phone */