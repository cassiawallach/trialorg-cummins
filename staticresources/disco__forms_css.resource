html {
	height: 100%;
	font-size: 16px; 
}

body {
	font-size:16px;
}

body#complete-form {
	background-color: #e7e7e7;
}
#completeFormPage {
	min-width: 360px;	
}

body#complete-form.Theme4d {
	overflow: visible;
}

/* Web's Contact Detail page specific styles */
#contentWrapper #mainForm {
	background-color: #ffffff;
}

#contentWrapper .containerBox{  /* decrease width to allow for padding on right side */
	width:98%;
}
// #contentWrapper select{  /* Remove picklist's selector */
// 	-webkit-appearance: none;
// 	-moz-appearance: none;
// 	-ms-appearance: none;
// 	-o-appearance: none;
// 	appearance: none;
// }
#contentWrapper select::-ms-expand { /* Remove picklist's selector in IE */
	display: none;
}
#contentWrapper .inner-addon .input-calendar { /* Remove calendar icon */
	display: none;
}
#contentWrapper .addPatMedRow{
	display: none;
}
#contentWrapper button.close{
	display: none;
}
#contentWrapper #patientMedsContainer{ /*Fixes weird issue of Pat Meds Table covering the border radius on Form Detail page*/
	width: 97%;
	padding: 0;
}

/* Tool Tip List Styles */
.ui-tooltip.slds-popover_tooltip ol {
	list-style: decimal;
}

.ui-tooltip.slds-popover_tooltip ul {
	list-style: disc;
}

.ui-tooltip.slds-popover_tooltip ol li,
.ui-tooltip.slds-popover_tooltip ul li {
	margin-left: 16px;
}

#contentWrapper select {
	overflow-x: scroll;
	overflow-y: hidden;
}

#contentWrapper select.formInput::-webkit-scrollbar { 
 	height: 5px !important;
 	background-color: red !important;
}

#contentWrapper select::-webkit-scrollbar-track {
    background: #fff;
}
#contentWrapper select::-webkit-scrollbar-thumb {
    background: #d3d3d3;
    border-radius: 5px;
}

#completeFormPage select option {
	overflow-x: scroll;
	max-width: 250px;
}

#completeFormPage select.hide-scroll option {
	overflow-x: visible;
}

#completeFormPage select.hide-scroll option::-webkit-scrollbar {
	height: 0;
}

#completeFormPage .controls select.hide-scroll {
	overflow-x: hidden;
}

.slds-scope .slds-form-element__control .ms-pl-separator {
	margin-top: 6px;
	margin-bottom: 6px;	
}

.slds-scope .slds-form-element__control .slds-checkbox .slds-form-element__label,
.slds-scope .slds-form-element__control .radio-list .slds-form-element__label {
	font-weight: normal;
}

/* Override checkbox color of check for form detail, to match complete form */
#completeFormPage .slds-checkbox [type=checkbox][disabled]+.slds-checkbox__label .slds-checkbox_faux:after, 
#completeFormPage .slds-checkbox [type=checkbox][disabled]+.slds-checkbox_faux:after, 
#completeFormPage .slds-checkbox [type=checkbox][disabled]~.slds-checkbox_faux:after {
	border-color: #0070d2;
}

.slds-scope .slds-checkbox .slds-checkbox_faux {
	min-width: 16px;
}

#contentWrapper .currentPageContainer {
	background-color: transparent;
}
/********************************************/
span.glyphicon.large {
	font-size:19px;
	padding-left:5px;
	margin-right:10px;
}
span.glyphicon.small {
	font-size:10px;
	line-height: 10px;
}
.contactSearchBox {
	margin: 10px 0;
}
.badge {
	font-size:13px;
	margin-right: 5px;
}
button.btn.prevBtn, button.btn.nextBtn {
	line-height: 10px;
	margin: 0 5px;
	width:45px;
	background-color: #fff;
	border: 1px solid #ccc;
	padding-bottom: 8px;
}
.backButton {
	height:30px;
	background-color:#f5f5f5;
	width:120px;
	margin-top:20px;
}
#mainForm .sf-save-error {
	color:red;
	white-space:pre-wrap;
}
/* error summary section
div .errorSummary {
	border: 1px solid red;
	margin-top: 5px;
}
div .errorSummary-mobile {
	border: 1px solid red;
	margin: 45px 20px 0 20px;
	border-radius:10px;
	padding:2px 0;
}*/
/* all errors*/
.error {
	color: #c23934;
	font-weight: bold;
}

input.error, select.error, textarea.error {
	border: 1px solid #c23934 !important;
}

.btnError {
	border-color: #c23934 !important;
}

/* override popover styles */
.popover .popover-inner {
	color: #16325c;
}
.popover {
	z-index: 10000;
}

/* text that appears when user clicks icon to copy URL */
#copyBtnContainer .copied-text {
	position: absolute;
	top: 10px;
	right: 10px;
	background-color:white;
}

#public-url-modal .hosting-site-label {
	display:block;
}

#public-url-modal .hosting-site-wrapper {
	display:inline-block;
	width:80%;
}
#public-url-modal .hosting-site-btn {
	display:inline-block;
	margin-top:0;
	margin-bottom:0;
}

#delete-modal .slds-notify {
	border-radius: 4px;
}

#delete-modal .slds-notify.delete-modal_flex {
	flex-direction: column;
}

#delete-modal .slds-notify .delete-notice {
	display: flex;
	flex-direction: row;
	align-items: center;
}

#delete-modal .slds-notify .slds-text-body_regular {
	font-weight: normal;
}

/*body.formDisplayApp #savingStatus {
	position:fixed;
	background-color: rgba(161,166,169,0.8);
	z-index:888;
	text-align: center;
	top:0%;
 	left:50%;
 	margin-left:-50%;
 	padding-top:50%;
 	width:100%;
 	height:100%;
 	display:none;
}*/
/*.loader {
  position: absolute;
  top: 100px;
  left: 49%;
  z-index: 100;
  font-size: 20px;
  margin: 5em auto;
  width: 1em;
  height: 1em;
  border-radius: 50%;
  text-indent: -9999em;
  -webkit-animation: load4 1.3s infinite linear;
  animation: load4 1.3s infinite linear;
}
@-webkit-keyframes load4 {
  0%,
  100% {box-shadow: 0em -3em 0em 0.2em #ffffff, 2em -2em 0 0em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 0em #ffffff;}
  12.5% {box-shadow: 0em -3em 0em 0em #ffffff, 2em -2em 0 0.2em #ffffff, 3em 0em 0 0em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  25% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 0em #ffffff, 3em 0em 0 0.2em #ffffff, 2em 2em 0 0em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  37.5% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 0em #ffffff, 2em 2em 0 0.2em #ffffff, 0em 3em 0 0em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  50% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 0em #ffffff, 0em 3em 0 0.2em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  62.5% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 0em #ffffff, -2em 2em 0 0.2em #ffffff, -3em 0em 0 0em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  75% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 0.2em #ffffff, -2em -2em 0 0em #ffffff;}
  87.5% {box-shadow: 0em -3em 0em 0em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 0em #ffffff, -2em -2em 0 0.2em #ffffff;}
}
@keyframes load4 {
  0%,
  100% {box-shadow: 0em -3em 0em 0.2em #ffffff, 2em -2em 0 0em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 0em #ffffff;}
  12.5% {box-shadow: 0em -3em 0em 0em #ffffff, 2em -2em 0 0.2em #ffffff, 3em 0em 0 0em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  25% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 0em #ffffff, 3em 0em 0 0.2em #ffffff, 2em 2em 0 0em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  37.5% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 0em #ffffff, 2em 2em 0 0.2em #ffffff, 0em 3em 0 0em #ffffff, -2em 2em 0 -0.5em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  50% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 0em #ffffff, 0em 3em 0 0.2em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 -0.5em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  62.5% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 0em #ffffff, -2em 2em 0 0.2em #ffffff, -3em 0em 0 0em #ffffff, -2em -2em 0 -0.5em #ffffff;}
  75% {box-shadow: 0em -3em 0em -0.5em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 0.2em #ffffff, -2em -2em 0 0em #ffffff;}
  87.5% {box-shadow: 0em -3em 0em 0em #ffffff, 2em -2em 0 -0.5em #ffffff, 3em 0em 0 -0.5em #ffffff, 2em 2em 0 -0.5em #ffffff, 0em 3em 0 -0.5em #ffffff, -2em 2em 0 0em #ffffff, -3em 0em 0 0em #ffffff, -2em -2em 0 0.2em #ffffff;}
}*/
/*.saveText{
	color: #fff;
	font-weight: bold;
	font-size: 22px;
}*/
/* overriding BS style with older BS style*/
.form-horizontal .control-label {
	float:left;
	padding-top:5px;
	margin-right: 10px;
}
.form-horizontal .controls .table-checkbox,
.form-horizontal .controls .table-radio {
	margin-top: 4px;
}
#formContent .control-group fieldset.table-radio[disabled],
#formContent .control-group fieldset.table-radio[disabled] span.slds-radio,
#formContent .control-group fieldset.table-radio[disabled] label {
	pointer-events: none;
}
#formContent .control-group fieldset.table-radio[disabled] input:not([checked]) + label .slds-radio__label {
	color: #e0e5ee;
	cursor: error;
}
#formContent .control-group fieldset.table-radio[disabled] [type="radio"]:checked + label .slds-button__icon {
	fill: #444;
}
.form-horizontal .controls .table-checkbox .boolean-checkbox {
	margin-top: 2px;
}

.form-horizontal .controls{
	margin-top: 5px; /* align inputs with label */
	text-align:left;
}

.linked-section-icon-container {
	position: absolute;
	left: 20px;
}

.blank_space {
	height:25px;
	width:100%;
}

body.overflow-is-visible {
	overflow: visible !important;
}

#formContent.pdf-view .form-section .mspl-value,
#formContent.pdf-view .form-section .form-detail-link__email {
	display: block;
}

#formContent.pdf-view .form-section .answerColumn {
	width: 100%;
}

.sigWrapper {
	width: 100%;
	margin:0px;
	background-color: #fff;
	color: #16325c;
	border: 1px solid rgb(216, 221, 230);
	border-radius: 4px;
}

.sigWrapper canvas {
	width: 100%;
	border-radius: 4px;
}

.sigNav{
	list-style-type:none;
	display: none;
	margin:0px;
	height:0px;
}
.sigPad{
	display: inline-block;
	width: 100%;
	max-width: 250px;
	position: relative; /* allows for absolute positioning of button */
}
.disabled-sig-pad {
	pointer-events: none;
}
.clearButton{
	position: absolute;
	top: 3px;
	right: 3px;
}
li.clearButton .btn-primary:focus, li.clearButton .btn-primary:hover{
	color: #333 	
}
.slds-scope .slds-form-element__control .input-btn {
	position: absolute;
	top: 0px;
}

.slds-scope .slds-form-element__control label.slds-checkbox + .input-btn {
	right: -40px;	
}

.slds-scope .slds-form-element__control .is-url-formula + input + .input-btn,
.slds-scope .slds-form-element__control input + .input-btn {
	right: -16px;
}

.slds-scope .slds-form-element__control .is-url-formula + input {
	display: none;
}

.slds-scope .slds-form-element__control .is-url-formula,
.slds-scope .slds-form-element__control.formula-field input.slds-input,
.slds-scope .slds-form-element__control.geolocation-field input.slds-input {
	width: calc(100% - 18px);
}

.slds-scope .slds-form-element__control.date-formula.formula-field.inner-addon {
	width: 100%;
}

.slds-scope.Theme4t .containerBox div.slds-form-element__control.formula-field input {
	max-width: 92%;
}

.slds-scope .table-checkbox .slds-form-element__control.formula-field .input-btn {
	right: -28px;
}

.slds-scope.Theme4t .table-checkbox .slds-form-element__control.formula-field .input-btn {
	top: -4px;
}

.slds-scope .slds-form-element__control.date-formula.formula-field.right-addon .input-calendar {
    right: 10%;
}

.slds-scope.Theme4t .slds-form-element__control.formula-field .input-btn {
	right: -10px;
}

.slds-scope.Theme4t .goToPage {
	display:flex;
	flex-wrap: wrap;
}

.requiredBorder{
	border-left: 3px solid red;
}
@media (max-width: 560px) {
	.form-horizontal .control-label {
		float:none;
	}
}
button.navbar-toggle{
	position:absolute;
	left: 5px;
	top:0px;
}
.nav-title{
	position: absolute;
	margin-top:10px;
	width:175px;
	display: none;
	text-align: center;
}
.navmenu-nav > li {
	color: #777;
	margin:10px 0 0 15px;
}
.label-online, .label-offline{
	margin:15px 10px 0 0;
	display: none;
	position: absolute;
}
.text-offline{
	color:#f2f2f2;
}
.btn-circle{
	border-radius: 50%;
	width:50px;
	height:50px;
	padding:0;
	margin-top: 5px;
	border:none;
	background-color: #7f8c8d;
	margin-right:50px;
}
.btn-circle-glyph-with-plus{
	font-size: 1.6em;
	top:5px;
}
.btn-circle-glyph-plus{
	position: absolute;
	font-size: .6em;
	top:15px;
}
.btn-circle-glyph{
	font-size: 1.7em;
}
.btn-deactivated{
	background-color: #f2f2f2;
}
.glyphicon-pre-text{
	margin-right:8px;
}
@media (min-width: 768px) {
	/* Overide bootstrap default of not displaying toggle button at larger widths (needed for tablets) */
	.navbar-default button.navbar-toggle{
		display:initial;
	}
}
.row{
	margin-left: initial; 	/* Overwrite Bootstrap styles, was causing horizontal scroll on iPad home screen */
	margin-right: initial; 	/* Overwrite Bootstrap styles, was causing horizontal scroll on iPad home screen */
}
.title-home{
	margin-left:-15px;
}
.buttons{
	border-top:none;
}
.button-row-home{
	margin-top: 20px;
	padding-right:0px;
}
.button-row-form-mobile{ /* Web version does not have app title bar, so only mobile needs this adjustment. On mobile, all other containers get the 50px padding from 'mobile-container', this is need because the element is fixed */
	top:50px;
	background-color: rgba(242,242,242,.9);
	padding: 10px 0;
}
.form-background-color{
	background-color: transparent;
}
.buttons-fixed{
	position: fixed;
    background-color: rgba(22, 50, 92,.95);
    width: 100%;
    left: 0;
	top: 0;
	padding: 15px 0;
	display: flex;
	flex-direction: column;
	z-index: 100;
	min-width: 360px;
}

.currentPageContainer{
	padding-top:70px;
}
.with-pagination{
	padding-top:120px;
}
.paginationBlock{
	margin: 0;
	color: white;
}
/*.paginationBlock-mobile{
	margin: 40px auto 0 auto;
}*/
select.goToPage{
	width: 9em;
}
span.goToPage{
	padding-left: 20px;
}
.footer-center-1{
	position: absolute;
	left: calc(50% - 25px);
}
.footer-center-2{
	position: absolute;
	left: calc(50% - 75px); /* Move left edge of div 50% then subtract (50 * [(n)+(n-1)])where n = # of buttons (if button width and right margin is 50px) */
}
/* COLORS */
div.navbar-default{
	background-color: rgba(39, 174, 96,1.0);
}
.nav-title{
	color:#f2f2f2;
}
.navbar-default .navbar-toggle{
	border-color: #f2f2f2;
}
.navbar-default .navbar-toggle:hover, .navbar-default .navbar-toggle:focus{
	background-color: rgba(46, 204, 113,1.0);
}
.navbar-default .navbar-toggle .icon-bar{
	background-color:#f2f2f2;
}
#contactSearchName{
	margin-left: 5px;
}
.navmenu, .navbar-offcanvas {
	width: 200px;
}
.containerBox h2{
	border-top:none;
}
.title-padding{
	padding: 40px 0 10px 0;
}
#sync-fail{
	background-color: red;
}
.childQuestion{
	display: none;
}
.modal-content{ /* Move the modal search box just under the app title */ 
	margin-top:50px;
}
button.close{ /* Make modal close button larger */
font-size: 2.2em;
}
.containerBox{
	border-bottom: none;
}
.containerBox td > input{
	height: 15px !important; /* important needed to overwrite !important in another file... */
	vertical-align: top;
}
.containerBox td > label{
	padding-left: 10px;
	font-weight: normal;
	width: 90%;
}
.answerColumn td.checkbox-list > label{
	width: 85%; /* checkbox list labels width needs to be slightly less than 90% for other label widths (works with triple indented, required checkboxes) */
}
.answerColumn td.radio-list > label{
	width: 88%; /* radio list labels width needs to be slightly less than 90% for other label widths (works with triple indented, required checkboxes) */
}
.containerBox textarea{
	width: 250px;
}
.table-radio td, .table-checkbox td{
	text-align: left;
}
.table-radio .slds-radio_faux {
	min-width: 16px;
}
.controls-table{
	display: table;
}
.controls-table-cell{
	display: table-cell;
	width: 3px;
}
.controls-table-cell-margin{
	margin-left:10px
}
.input-group-btn{
	border-radius: 0px;
}
.input-group-btn button{
	padding: 10px 10px 12px 10px;
	border-radius: 0px;
}
div.input-group{
	margin-top: -1px;
}
.mobile-container{ /* Pad all mobile elements to accomodate the app nav/title bar */
	padding: 50px 0 40px 0;
}
.button-row-listview{
	padding: 10px 0;
	width: 720px;
	background-color: rgba(242,242,242,.9);
	z-index:100;
	position: fixed;
}
.button-row-margin{
	margin-top:10px;
}
.btn-top-row{
	margin: 0 5px;
}
.btn-top-row-right{
	margin: 0 0 0 5px;
}
.btn-right{
	margin-right:10px;
}
form.form-default-background{
	background-color: #f2f2f2;
}
#formContent img{
	display: block;
	margin: 0px auto;
}
p.list-group-item{
	text-align: left;
}
.containerBox h2.non-form-title{
	font-size: 30px;
	text-align: left;
	padding-top: 60px;
}
#detailContent .button-row-form{
	width:100%
}
.border-settings{
	border-bottom: 1px solid #d9d9d9;
	width: 80%;
}
.clear-float{
	clear: both;
}
.containerBox textarea{
	min-width:250px;
	max-width:100%;
}
.containerBox form{
	width: 100%;
}
.btn-camera{
	padding-bottom: 7px;
	margin-right: 10px;
}
input[type=datetime-local], input[type=date]{
	-webkit-appearance: none;
}
input:disabled{
	color: rgb(84, 84, 84);
}
.ui-selectable-disabled{
	background-color: #f2f2f2;
}
.inner-addon { 
    position: relative; 
    display:inline-block;
    width:250px;
}
.answerColumn .inner-addon { 
    width: 98%;
}
.answerColumn .inner-addon.date-formula { 
    width: 92%;
}
/* style icon */
.inner-addon .input-calendar {
  position: absolute;
  pointer-events: none;
  top: 9px;
}

/* align icon */
.left-addon .input-calendar  { left:  0px;}
.right-addon .input-calendar { right: 8px;}

/* add padding  */
.left-addon input  { padding-left:  30px; }
.right-addon input { padding-right: 30px; }

.inline-text{
	display: inline;
}
.savePhotos{
	display: none;
}
div.savePhotos{
	margin-right:15px;
}
#logout-link{
	display: none;
}

ul#thisContactsForms, ul#div_sfdc_soup_entry_list, ul#formsList{
	padding-left: 0px;
}
.localupdate{
	margin-right: 5px;
}
.hidden{
	display: none;
}

#patientMedsContainer, #patientMedsContainer input, #patientMedsContainer select{
	width: 100%;
	max-width: 100%
}
#patientMedsContainer{
	padding-left: 0px;
}
#patientMedsContainer input{
	height: 25px !important;
}
#patientMedsContainer .removeColumn{
	width: 40px;
}
#patientMedsContainer button.close{
	line-height: .7;
	position: relative;
	bottom: 4px;
}
#patientMedsContainer .mobileTooltip{
	color: #d3d3d3;
	font-size: 20px;
	padding-right: 0px;
}
button.addPatMedRow{
	margin-bottom: 20px;
	margin-left: 10px;	
}


/*!
 * jQuery UI CSS Framework 1.11.4 FOR AUTOCOMPLETE
 */

/* Layout helpers
----------------------------------*/
.ui-helper-hidden {
	display: none;
}
.ui-helper-hidden-accessible {
	border: 0;
	clip: rect(0 0 0 0);
	height: 1px;
	margin: -1px;
	overflow: hidden;
	padding: 0;
	position: absolute;
	width: 1px;
}
.ui-helper-reset {
	margin: 0;
	padding: 0;
	border: 0;
	outline: 0;
	line-height: 1.3;
	text-decoration: none;
	font-size: 100%;
	list-style: none;
}
.ui-helper-clearfix:before,
.ui-helper-clearfix:after {
	content: "";
	display: table;
	border-collapse: collapse;
}
.ui-helper-clearfix:after {
	clear: both;
}
.ui-helper-clearfix {
	min-height: 0; /* support: IE7 */
}
.ui-helper-zfix {
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	position: absolute;
	opacity: 0;
	filter:Alpha(Opacity=0); /* support: IE8 */
}

.ui-front {
	z-index: 100;
}


/* Interaction Cues
----------------------------------*/
.ui-state-disabled {
	cursor: default !important;
}


/* Icons
----------------------------------*/

/* states and images */
.ui-icon {
	display: block;
	text-indent: -99999px;
	overflow: hidden;
	background-repeat: no-repeat;
}


/* Misc visuals
----------------------------------*/

/* Overlays */
.ui-widget-overlay {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
}
.ui-autocomplete {
	position: absolute;
	top: 0;
	left: 0;
	cursor: default;
}
.ui-menu {
	list-style: none;
	padding: 0;
	margin: 0;
	display: block;
	outline: none;
	background-color: #fff;
	border: 1px solid #333;
}
.ui-menu .ui-menu {
	position: absolute;
}
.ui-menu .ui-menu-item {
	position: relative;
	margin: 0;
	padding: 3px 1em 3px .4em;
	cursor: pointer;
	min-height: 0; /* support: IE7 */
	/* support: IE10, see #8844 */
	list-style-image: url("data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");
}
.ui-menu .ui-menu-divider {
	margin: 5px 0;
	height: 0;
	font-size: 0;
	line-height: 0;
	border-width: 1px 0 0 0;
}
.ui-menu .ui-state-focus,
.ui-menu .ui-state-active {
	margin: -1px;
	background-color:rgb(244, 246, 249) !important;
	border:1px solid black;
}
.ui-autocomplete .ui-state-focus,
.ui-autocomplete .ui-state-active {
	margin: 0;
	border: none;
}

/* icon support */
.ui-menu-icons {
	position: relative;
}
.ui-menu-icons .ui-menu-item {
	padding-left: 2em;
}

/* left-aligned */
.ui-menu .ui-icon {
	position: absolute;
	top: 0;
	bottom: 0;
	left: .2em;
	margin: auto 0;
}

/* right-aligned */
.ui-menu .ui-menu-icon {
	left: auto;
	right: 0;
}
.contactDisplay {
	height: 44px;
}
.fsText {
	float: left;
	width: 610px; /* Works for tablet, when updated locally is not present */
  	white-space: nowrap;
  	overflow: hidden;
  	text-overflow: ellipsis;
}
div.updatedLocallyOn{
	width: 500px; /* Works for tablet*/
}
/* Adjust width of text on search modal */
div.contactData{
	width: 500px;
}

@media (max-width: 1052px) {
  .table-responsive {
    width: 100%;
    margin-bottom: 15px;
    overflow-x: scroll;
    overflow-y: hidden;
    -webkit-overflow-scrolling: touch;
    -ms-overflow-style: -ms-autohiding-scrollbar;
    border: 1px solid #ddd;
  }
}
table tbody tr td.removeBtn{
	border-left: 1px solid #ddd;
	vertical-align: middle;
	font-weight: bold;
}
.noItems{
	padding-top: 15px;
	padding-left: 10px;
}

/* Overwrite Bootstrap Tooltip stylings*/
.tooltip{
	/* !important needed to overwrite dynamic Bootstrap JS */
	right: 10px !important;
	opacity:100;
	z-index:1;
}

@media (max-width: 899px){
	/* tablets in portrait should use smaller left margin */
	.tooltip{
		/* !important needed to overwrite dynamic Bootstrap JS */
		right: 10px !important;
		opacity:100;
		z-index:1;
	}
}
.tooltip.top .tooltip-arrow{
	/* !important needed to overwrite dynamic Bootstrap JS */
	left: 20px !important;
    border-top-color: rgba(51,51,51,.9);
}
.tooltip-inner {
    max-width: 900px;
    font-size: 20px;
    background-color: #333;
}
#ourPage select, #complete-form select {
	overflow: scroll;
}
div.selectContainer{
	min-width:250px;
	max-width:100%;
}
div.selectContainer select.formInput.answerValue{
	width: auto;
	max-width: none;
}
/*.saveText{
	color: #fff;
	font-weight: bold;
	font-size: 22px;
	position: absolute;
	top: 250px;
	left: 42%;
}*/
#discoPanel {
	text-align: left;
}
#discoPanel .panel-heading {
	background-color: #5FB4E6;
	color: #fff;
	font-weight: bold;
}

/***** SLDS OVERRIDES ******/
.slds-scope .slds-card.ls-card-header,
.slds-scope #formContent .slds-card.form-section {
	background-color: rgb(244, 246, 249);
}

.slds-scope .form-section.hiddenByDep.ls-group-changed-input,
.slds-scope .ls-card-header.ls-group-changed-input, 
.slds-scope .ls-card-add-container.ls-group-changed-input {
	display: block !important; /* override dep logic hiding if the value has been changed. */
}

#formContent div.form-section.slds-card.ls-group-changed-input.js-section-delete,
#formContent div.form-section.slds-card.js-uses-ls-card.ls-modal.js-section-delete,
#formContent div.form-section.slds-card.uses-ls-card.ls-group-changed-input.hiddenByDep.js-section-delete {
	display: none !important;
}

.slds-scope #formContent div.form-section.slds-card.ls-group-changed-input:not(.js-section-delete):not(.uses-ls-card),
.slds-scope #formContent div.form-section.slds-card.js-uses-ls-card.ls-modal:not(.js-section-delete):not(.uses-ls-card),
.slds-scope #formContent div.form-section.slds-card.ls-group-changed-input:not(.js-section-delete):not(.uses-ls-card) {
	display: block !important;
}

.slds-scope .slds-card.form-section .section-required-msg,
.slds-scope .slds-card.ls-card-header .section-required-msg {
	position: absolute;
	top: -28px;
	width: 100%;
	text-align: center;
	left: 0;
}

.slds-scope #formContent .ls-card-add-container.slds-has-error.OR-has-error {
	border-color: #c23934;
}

/* make the card body background white and have a border at top and bottom */
.slds-scope .slds-card__body.OR-card__body {
	background-color:#fff;
	border-top:2px solid rgb(216, 221, 230);
	border-bottom:2px solid rgb(216, 221, 230);
	padding-top: 8px;
	margin-bottom: 0;
}

/* Over ride SLDS default that hides empty div in card body */
.slds-scope .slds-card__body.OR-card__body:empty {
	display: block;
}

/* fix card header and footer */
.slds-scope .slds-card__header.OR-card__header {
	margin-bottom: 4px;
}

.slds-scope .slds-card__header.OR-card__header h2 {
	margin: 0;
	padding: 0;
	font-size: 18px;
	font-weight: 300;
}

.slds-scope .slds-card__footer.OR-card__footer {
	border-top: none;
	padding: 8px 16px 4px 8px;
	margin-top: 0;
}

/* There is a bug in chrome 53 on mac where the preview crashes if the widow height is not scrollable
	and the user clicks on a radio button or picklist. Setting a min height forces it to scroll, this class is only used/needed if there is only 1 section on the page, and will be set regardless of browser */
.chrome-preview-fix {
	min-height: 190px;
}

/* format the size of the goToPage select input */
.goToPage .slds-form-element {
	display: inline-block;
	width: 100px;
	margin-left: 20px;
}

/* add border-radius to save modal content */
.slds-scope .slds-modal__content.OR-modal__content {
	border-radius: 4px;
	min-height: 178px;
}

/* Center the spinner in the modal */
.slds-scope .slds-spinner_large.OR-spinner-align_center {
	margin-left: auto;
	margin-right: auto;
}

/* Set width for form display question inputs */
.slds-scope .slds-form-element.OR-form-element_width {
	width: 250px;
	max-width: 100%;
}

/* Set width for form display radio button and checkbox list question inputs */
.slds-scope .slds-form-element.OR-form-element_width.table-checkbox,
.slds-scope .slds-form-element.OR-form-element_width.table-radio {
	width: auto;
	max-width:100%;
}

.slds-scope .form-horizontal .slds-form-element__control .slds-select_container {
	max-width: 250px;
}

.slds-scope .sf-file .slds-m-top_small {
	margin-top: 0;
}

.slds-scope .sf-file .file-uploader:first-of-type{
	margin-top: 0;
}

.slds-scope .sf-file .file-uploader{
	margin-top: 10px;
}
.slds-scope .sf-file a{
	color: inherit;
}
.slds-scope .sf-file a:hover{
	text-decoration: none;
}

/* inline spinner while awaiting data */
.slds-scope .sf-file .slds-spinner {
	position:inherit;
	margin-top:15px;
}

#formContent .sf-file img {
	display:inline;
	margin: 0 5px;
}

.slds-scope .OR-file-selector_width {
	max-width: 100%;
}

.slds-scope .slds-file-selector__button.OR-upload-button_nowrap {
	white-space: nowrap;
}

.slds-scope .slds-file-selector__dropzone.OR-dropzone {
	display: flex;
	max-width: 100%
}

.slds-scope .slds-file-selector__dropzone.OR-dropzone span.slds-badge {
	align-self: center;
	margin-left: 10px;
}

.slds-scope .slds-file-selector__dropzone.OR-dropzone_border {
	border: none;
}

/* background color for Youreka's body element 
html body.sfdcBody.brandQuaternaryBgr{
	background: none;
	background-color: #e7e7e7;
}*/

/* Match font styling for validation errors that do not use SLDS styling (esig, ms-picklist) */
.controls label.error {
	font-weight: normal;
	font-size: 12px;
}

/* add margin to e-sig error message */
.controls .sigPad label.error {
	margin-left: 5px;
}

/* container for save buttons and pagination */
.nav-container {
	display: flex;
	justify-content: center;
}

.nav-container .sidemenu-icon-container {
	flex-basis: 30%;
	display: flex;
	padding-left: 40px;
	justify-content: flex-start;
}

.nav-container .save-button-container {
	flex-basis: 40%;
	display: flex;
	justify-content: center;
}

.nav-container .save-button-container .slds-button + .slds-button {
	margin-left: 10px;
}

.nav-container .pagination-container {
	flex-basis: 30%;
	display: flex;
	padding-right: 40px;
	justify-content: flex-end;
}

.flex-center {
	display: flex;
	justify-content: center;
	align-items: center;
}

.remove-option-button {
	display: flex;
	align-items: start;
	justify-content: center;
	margin-top: 10px;
}

.file-uploader {
	max-width: 400px;
	width: 100%;
}

.file-uploader .file-name-align {
	display: flex;
	align-items: center;
}

.file-uploader .file-preview {
	border:1px solid rgb(216, 221, 230);
	border-radius:4px;height:40px;
}

.file-uploader .file-preview.file-preview_unsaved {
	color: #16325c;
	background-color: #ecebea;
}

.file-uploader .file-error {
	border-color: rgb(194, 57, 52);
}

.file-uploader .file-error svg{
	fill: rgb(194, 57, 52);
}

/* Override SLDS style when fileuploader button is near disabled input (1 file already attached) **/
.slds-scope .file-uploader .slds-file-selector__input[disabled]~.slds-file-selector__body>.slds-file-selector__button.slds-button_neutral {
	background-color: rgb(255,255,255);
	color: rgb(0, 112, 210);
	border: 1px solid rgb(221, 219, 218);
	border-radius: 4px;
}

.slds-scope .file-uploader .slds-file-selector__input[disabled]~.slds-file-selector__body>.slds-file-selector__button.slds-button_neutral:hover {
	color: #005fb2;
	background-color: #f4f6f9;
}


.slds-scope div.card-background_dark {
    background-color: #39597d;
    color: #fff;
}

.containerBox .text-left-align {
	text-align: left;
}

label.cursor-pointer {
	cursor: pointer;
}


/****** PREVIEW FORM OVERRIDE STYLES *****/
.tb-modal {
	position:fixed;
	top:8%;
	left:50%;
	transform: translateX(-50%);
	height:auto;
	border: 4px solid black;
	background-color: #e7e7e7;
	display:none;
	border-radius:5px;
	z-index: 888;	
	text-align:center;
	box-sizing: border-box;
	max-height: 450px;
}
.tb-modal #completeFormPage.containerBox {
	max-height: 430px;
	overflow-y: scroll;
}
#fade {
	z-index: 100; /*must be greater than stickyjs index of 10 */
	position: fixed;
	width: 100%;
	height: 100%;
	background-color: rgba(0,0,0,.4);
	top: 0%;
	display: none;
}

.button-row-form {
	background-color: transparent;
}
h1.formName {
	font-size: 30px;
	margin-bottom: 10px;
}
h2.title-form-section {
	font-size: 24px;
	margin: 10px 0;
}

.form-section .slds-media__body h2 {
	white-space: initial;
}

/* adjust modal container to use margin instead of padding so that the spinner fits over just the visible element */
.slds-scope .slds-modal__container.OR-modal-margin {
	padding-top: 0;
	padding-bottom: 0;
	margin-top: 48px;
	margin-bottom: 48px;
}

/* Present autocomplete (typeahead) on top of preview modal-content
	preview modal has z-index of 888 */
.ui-autocomplete {
	z-index: 1001;
}

#previewStatus #completeFormPage .pagination-container {
	flex-basis: 100%;
	justify-content: center;
	padding: 0;
}

#previewStatus.tb-modal form .buttons-fixed {
	position: absolute;
}

/***** SF1 specific styles (CPG Demo) *****/
.slds-scope.Theme4t .buttons-fixed {
    background-color: transparent;
}
.slds-scope.Theme4t #completeFormPage {
	min-height: calc(100vh - 48px);	// full viewport minus the footer height, so footer is placed at bottom of page, even if page is short
}
.slds-scope.Theme4t .goToPage .slds-badge.js-page-numbering {
	padding: 0px 12px;
	border-radius: 4px;
	min-height: 1em;
	margin-top: 0.5em;
}

.slds-scope.Theme4t .nav-container {
	display: flex;
	flex-direction: row;
	justify-content: space-between;
}
.slds-scope.Theme4t .template-name, .slds-scope.Theme4t .section-name {
	text-align: left;
	color: #fff;
}
.slds-scope.Theme4t span.goToPage {
	padding: 0px;
	margin-top: 2px;
}
.slds-scope.Theme4t .buttons-fixed {
	padding: 5px 15px;
}
.slds-scope.Theme4t div.errorSummary {
	margin: 12px -15px -6px -15px;
}
.slds-scope.Theme4t .icon-container {
	display: flex;
	align-items: center;
}

.slds-scope.Theme4t .icon-container-camera {
	width: 40px;
}

.slds-scope.Theme4t .photo-input-offscreen {
	position: absolute;
	right: 2000px;
}

.slds-scope.Theme4t .footer {
	width: 100%;
	bottom: 0;
	height: 48px;
	padding: 2px 15px;
}
.slds-scope.Theme4t .footer-pagination-container{
	display: flex;
	justify-content: space-between;
}
.slds-scope.Theme4t .footer-pagination {
	width: 100%;
}
.slds-scope.Theme4t .scroll-message {
	min-height: 36px;
	display: flex;
	justify-content: center;
	align-items: center;
	color: #fff;
	font-size: 14px;
}
.slds-scope.Theme4t .scroll-down-icon {
	padding: 0 5px;
}
.slds-scope.Theme4t .sf1-footer-margin {
    margin-bottom: 47px;
}
.slds-scope.Theme4t .footer-camera-container {
	width: 38px;
	height: 38px;
}
.slds-scope.Theme4t .footer-camera-icon {
	position: absolute;
	top: 3px;
	left: 3px;
}
.slds-scope.Theme4t .footer-icons-left {
    margin-top: 4px;
    display: flex;
    flex-direction: row;
}

.slds-scope.Theme4t .footer-icons-left .goToPage {
	width: 55%;
	margin-left: 15px;
}

.slds-scope.Theme4t .footer-icons-right {
    margin-top: 2px;
}
.slds-scope.Theme4t button.button-large, .slds-scope.Theme4t button.button-large {
	height: 40px;
	width: 40px;
}

.slds-scope.Theme4t .button-marging-large {
	margin-right: 15px;
}
.slds-scope.Theme4t span.control-label, .slds-scope.Theme4t .template-name, .slds-scope.Theme4t .section-name {
	font-size: 18px;
}
.slds-scope.Theme4t .pagination-container {
	text-align: left;
	display: flex;
	flex-direction: column;
}
.slds-scope.Theme4t .footer-pagination .OR-footer-buttons-width{
	width: 140px;
}
.slds-scope.Theme4t span#normalSaver {
	border-radius: 6px;
	height: 38px;
	padding-right: 12px;
	padding-left: 12px;
}

.slds-scope.Theme4t button.button-finish {
	width: 72px;
}

.slds-scope.Theme4t #normalSaver p {
	margin-top: 6px;
	font-weight: bold;
}

.slds-scope.Theme4t .slds-card__header {
    padding: 0px;
}

.slds-scope.Theme4t .slds-card.sf1-section {
    background-color: transparent;
    margin: 10px;
    border: 0px;
    box-shadow: none;
}

.slds-scope.Theme4t .slds-form-element__control label.slds-checkbox + .input-btn,
.slds-scope.Theme4t .slds-form-element__control input + .input-btn {
	right: -16px;
}

.slds-scope.Theme4t .slds-card__body.OR-card__body.sf1-section-body {
    background-color: transparent;
    border: 0px;
}

.slds-scope.Theme4t .slds-card__body.OR-card__body.sf1-section-linked-body {
    border-bottom: 1px solid #39597d;
    border-radius: 0px;
}

.slds-scope.Theme4t .slds-card .slds-card__body.OR-card__body.sf1-section-linked-body {
	margin-top: 16px;
}

.slds-scope.Theme4t .slds-card .slds-card__header .remove-linked-section-container {
	position: absolute;
	right: 0;
	top: 0;
}

.slds-scope.Theme4t .slds-card .slds-card__header .remove-linked-section-container .remove-linked-section {
	width: 2.5rem;
	height: 2.5rem;
	padding: .75rem;
}

.slds-scope.Theme4t .slds-card.js-uses-ls-card.ls-modal .slds-form-element__control.formula-field .input-btn {
	right: 0px;
}

.slds-scope.Theme4t #formContent div.form-section.slds-card.js-uses-ls-card.ls-modal .slds-card__body {
	margin-right: 12px;
	margin-top: 36px;
	border-top: 1px solid #39597d;
}

.slds-scope.Theme4t .form-horizontal .control-group {
    padding-bottom: 0px;
}

.slds-scope .always-hidden {
    display: none !important;
}

/* separate multi-column layout on tablet */
@media (min-width: 480px) {
	.slds-scope.Theme4t .sf1-section-body .answerColumn:first-child {
		padding-right: 15px;
	}

	.slds-scope.Theme4t .sf1-section-body .answerColumn:last-child {
		padding-left: 15px;
	}
}

/* Make inputs full width */
.slds-scope.Theme4t .controls {
	width: 100%;
	margin: 0;
}

.slds-scope.Theme4t .containerBox div.slds-form-element__control input,
.slds-scope.Theme4t .form-horizontal .slds-form-element__control .slds-select_container,
.slds-scope.Theme4t .containerBox select{
	max-width: 100%;
}

.slds-scope.Theme4t .slds-form-element.OR-form-element_width {
	width: 100%;
}
.slds-scope.Theme4t span.control-label {
	width: 100%;
	max-width: 100%;
	margin: 3px 0;
	text-align: left;
}
.slds-scope.Theme4t span.slds-form-element__label {
	font-size: 18px;
	font-weight: normal;
}
.slds-scope.Theme4t .pagination-container h1 {
	display: block;
	line-height: 1.3;
}
@media (max-width: 900px) {
	.slds-scope.Theme4t .pagination-container {
		max-width: 740px;
	}
}
@media (max-width: 768px) {
	.slds-scope.Theme4t .pagination-container {
		max-width: 630px;
	}
}
@media (max-width: 480px) {
	.slds-scope.Theme4t .form-horizontal .control-label {
		float: left;
	}
	.slds-scope.Theme4t .pagination-container {
		max-width: 310px;
	}
}
/* add more specificity to make sure slds-hide is hiding items it is placed on */
.slds-scope.Theme4t .slds-hide {
	display: none;
}
/*************************/

/***** Public Site opened on Mobile ******/
.slds-scope.Theme4t-public-site .nav-container .save-button-container button#quickSaver.slds-button {
	line-height: 14px;
}

/* hide next/prev navigation (just using Go To dropdown due to space) */
.slds-scope.Theme4t-public-site .nav-container .prevBtn,
.slds-scope.Theme4t-public-site .nav-container .nextBtn {
	display: none !important;
}

/* add space between buttons and go to dropdown */
.slds-scope.Theme4t-public-site .nav-container .paginationBlock {
	margin: 10px 0 0 0;
}

#complete-form.is-lwc .nav-container .save-button-container  {
	flex: auto;
}

@media (max-width: 708px) {
	#complete-form.is-lwc .nav-container .save-button-container button {
		line-height: 18px;
	}
}

@media (max-width: 480px) {
	.slds-scope.Theme4t-public-site .nav-container {
		flex-wrap: wrap;
	}

	.slds-scope.Theme4t-public-site .nav-container .paginationBlock,
	.slds-scope.Theme4t-public-site .nav-container .current-page-text {
		margin: 0 auto;
		height: 10px;
	}

	.slds-scope.Theme4t-public-site .nav-container .pagination-container {
		padding: 0;
		min-width: 100%;
	}

	.slds-scope.Theme4t-public-site .nav-container .sidemenu-icon-container {
		flex: 0 1;
	}

	.slds-scope.Theme4t-public-site .nav-container .save-button-container {
		flex: 1 2;
	}
}

#sigModal .sig-align {
	position: relative;
	padding: 5px;
}

#sigModal .sig-parent-wrapper {
	max-width: 575px;
	margin: 5% auto;
	position: relative;
}
@media (max-width: 1052px) {
	#sigModal .sig-parent-wrapper {
		min-width: 400px;
	}
}
@media (max-width: 480px) {
	#sigModal .sig-parent-wrapper {
		min-width: 320px; 
	}
	.sig-answer-container {
		margin: 0 auto;
	}
}

#sigModal .sig-parent-wrapper:after {
	padding-top: 31%;
	display: block;
	content: '';
}

#sigModal .sig-parent-wrapper .sig-wrapper {
	top: 0;
	bottom: 0;
	right: 0;
	left: 0;
	background-color: #fff;
	color: #16325c;
	border-radius: 6px 6px 0 0;
}

#sigModal .sig-parent-wrapper .sig-wrapper .sig-modal-pad {
	max-width: 100%;
}

#sigModal .sig-cancel {
	margin: 0 15px 0 0;
}

#sigModal .sig-clear {
	position: absolute;
	right: 5px;
	top: 5px;
}

.sig-element {
	width: 100%;	
}

.sig-answer-container {
	border: 1px solid rgb(216, 221, 230);
	border-radius: 4px;
	max-width: 250px;
}

.sig-answer-container.sig-empty {
	height: 60px;
}

.sig-answer-container.slds-has-error, .ms-selectable.slds-has-error > .selectable-multiselect , .sigPad.slds-has-error {
	border: 2px solid #c23934;
}

.slds-scope.Theme4t .sig-answer-container {
	background-color: #fff;
}

img + .tooltip-container {
	position: absolute;
}

.tooltip-container {
	margin-left: 5px;
	display: inline-block;
}

.tooltip-container svg.OR-tooltip {
	fill: rgb(159, 170, 181);
}

.slds-popover.slds-popover_tooltip .ui-tooltip-content {
	font-size: 12px;
	color: #fff;
	padding: 8px;
}

/* Keep tooltip position from bouncing during hover */
div.ui-tooltip.ui-widget {
	position: absolute;
}

.slds-scope .form-detail-link__container {
	height: 39px;		
}

.slds-scope .form-detail-link__url {
	position: absolute;
	top: 8px;
    left: 10px;
    max-width: 230px;
    display: block;
    text-overflow: ellipsis;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;	
}

/**** SLIDEOUT MENU ****/
body {
	width: 100%;
	height: 100%;
}

.slideout-menu {
	position: fixed;
	top: 0;
	bottom: 0;
	width: 270px;
	min-height: 100vh;
	overflow-y: auto;
	-webkit-overflow-scrolling: touch;
	z-index: 0;
	display: none;
}

.slideout-menu-left {
	left: 0;
}

.slideout-menu-right {
	right: 0;
}

.slideout-panel {
	position: relative;
	z-index: 1;
	will-change: transform;
	background-color: #FFF; /* A background-color is required */
	min-height: 100vh;
}

.slideout-open,
.slideout-open body,
.slideout-open .slideout-panel {
	overflow: hidden;
}

.slideout-open .slideout-menu {
	display: block;
}

nav.slideout-menu {
	background-color: rgb(112, 110, 107);
	border-right: rgba(0,0,0,0.7);
}

.nav-header-box {
	height: 66px;
	display: flex;
    justify-content: center;
    align-items: center;
    color: #fff;
    position: fixed;
    width: 270px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    box-shadow: 5px 0 5px rgba(0, 0, 0, 0.07);
    background-color: rgb(112, 110, 107);
    border-right: 1px solid rgba(0,0,0,0.3);
}

li.page.selected {
	background-color: rgba(0,0,0,0.1);
}

.pages.header-padding li.page:last-of-type {
	margin-bottom: 90px;
}

li.page.selected .page-border-offset:hover,
li.page.selected li.section:hover {
	background-color:rgba(0,0,0,0.3);
	-webkit-transition: -webkit-transform 0.1s ease-in-out, background-color 0.1s linear;
          transition: transform 0.1s ease-in-out, background-color 0.1s linear;
}

.page-border-offset {
	padding: 0 0 0 10px;
	cursor: pointer;
}

.page-border-offset:hover {
	background-color: rgba(0,0,0,0.3);
	color: rgb(233, 234, 236);
	-webkit-transition: -webkit-transform 0.1s ease-in-out, background-color 0.1s linear;
          transition: transform 0.1s ease-in-out, background-color 0.1s linear;
}

.slds-scope div.page-label {
	height: 45px;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    width: 100%;
    cursor: pointer;
    color: #fff;
    border-bottom: 1px solid rgba(255,255,255,0.1);
    padding-right: 5px;
}

.slds-scope li.section {
	height: 45px;
    display: flex;
    justify-content: flex-start;
    align-items: center;
    padding: 0 5px 0 10px;
    cursor: pointer;
    color: #fff;
}

.slds-scope li.section:hover {
	background-color: rgba(0,0,0,0.3);
	color: rgb(233, 234, 236);
	-webkit-transition: -webkit-transform 0.1s ease-in-out, background-color 0.1s linear;
          transition: transform 0.1s ease-in-out, background-color 0.1s linear;
}

li.section .section-dot {
	border-radius: 50%;
	min-width: 5px;
	min-height: 5px; 
	background-color: #fff;
	margin: 0 10px;
}

ul.pages.header-padding {
	padding-top: 66px; 
}

html body#complete-form {
	padding: 0;
}

main#panel {
	background-color: #e7e7e7;
}

/******************************/


/***** Form Detail Insights Styles ******/
.einstein-loader {
    width: 100%;
    margin-bottom:30px;
}
.slds-scope .einstein-loader img {
    max-width: 200px;
}
.insights-cards .slds-list_horizontal.card-list {
    display:flex;
    flex-wrap:wrap;
    justify-content: space-evenly;
}
.slds-scope .insights-cards .slds-list__item.card-item {
    width: 310px;
    min-height: 143px;
    max-height: 250px;
    position: relative;
    padding: 0;
    align-self: flex-start;
    margin-top: 16px;
    background-color: #fff;
}

.slds-scope .card-img-thumb {
    max-width: 180px;
    max-height: 150px;
}
.card-icon {
    min-width:40px;
    max-width: 40px;
}
.card-text {
    display:flex;
    flex-direction:column;
    justify-content: flex-start;
    align-items: flex-start;
    padding: 0 0 0 16px;
    overflow: hidden; /* hide overflow on really long discovery names that don't have spaces */
}
.slds-scope .insight-header {
    padding: 0px;
}

.slds-scope .insight-content {
    display: flex;
    padding: 8px;
}

.slds-scope .insights-cards .slds-section-title_divider {
    padding: 3px 16px;
    border-radius: 4px 4px 0 0;
}

.truncate-3 {
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.slds-scope .insights-cards .approve {
    background-color: #00c6b7;
    color: #fff;
}

.slds-scope ..insights-cards reject {
    background-color: #ef6e64;
    color: #fff;
}

.slds-scope .insights-cards .neutral {
    background-color: #33bce7;
    color: #fff;
}

.slds-scope .insights-cards .insight-badge {
    max-width: 240px;
}

.slds-scope .insights-cards .youreka-disco-text {
    font-weight: 700;
}

.slds-scope .insights-cards .slds-has-cards_space .slds-list__item + .slds-list__item.card-item {
    margin-top: 16px;
}

/******************************/

/* Overwrite SLDS default so that readonly inputs have a border */
.slds-scope input.slds-input[readonly] {
	border-color: #c9c7c5;
	padding-left: 10px;
	background-color: #ecebea;
}

/* Prevent numbers inputs from having up and down buttons on FireFox */
.slds-scope .form-section input[number] {
	-moz-appearance: textfield;
}

/* Prevent numbers inputs from having up and down buttons on Others */
.slds-scope .form-section input[type="number"]::-webkit-outer-spin-button, 
.slds-scope .form-section input[type="number"]::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
}


/* Public URL input on Public Form URL modal on Form Detail should not have a background color (even though it is readonly) */
#generatedURL.slds-input {
	background-color: #fff;
}

.slds-scope.Theme4t div.footer .slds-icon_container.slds-icon_container_circle {
	padding: .4rem;
}

/* Form Detail Progress Bar */
.slds-scope .slds-progress__item button {
	cursor: default;
}
.slds-scope .slds-progress__item button:after {
    position: absolute;
    color: #706e6b;
    top: 7px;
}
.slds-scope .slds-progress__item button.slds-button_icon:after {
    top: 18px;
}
.slds-scope .slds-progress__item button.new-stage:after {
    content: 'New';
    left: -6px;
}
.slds-scope .slds-progress__item button.in-progress-stage:after {
    content: 'In Progress';
    left: -33px;
    display: inline-block;
    width: 68px;
}
.slds-scope .slds-progress__item button.save-error-stage:after {
    content: 'Save Error';
    left: -33px;
    display: inline-block;
    width: 68px;
}
.slds-scope .slds-progress__item button.submitted-stage:after {
    content: 'Submitted';
    left: -22px;
}
.slds-scope .slds-progress__item button.locked-stage:after {
    content: 'Locked';
    left: -11px;
}
.slds-scope .slds-progress__item button.archived-stage:after {
    content: 'Archived';
    left: -18px;
}

.slds-scope .progress-new {
    width: 0%;
}
.slds-scope .progress-in-progress {
    width: 25%;
}
.slds-scope .progress-submitted {
    width: 50%;
}
.slds-scope .progress-locked {
    width: 75%;
}
.slds-scope .progress-archived {
    width: 100%;
}
.slds-scope .OR-checkbox-flex,
.slds-scope .OR-radio-flex {
	display: flex;
}

.slds-scope .OR-checkbox-flex .slds-checkbox_faux,
.slds-scope .OR-radio-flex .slds-radio_faux {
	margin-top: 2px;
}

#formContent .control-group .slds-radio.radio-list .slds-radio_icon svg {
	fill: rgba(112,110,107,0.25);
}

#formContent .control-group .slds-radio [type="radio"]:checked + .slds-radio__label svg {
	fill: #0070d2;
}

#formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio_icon {
	padding: 2px;
}

#formContent .control-group .slds-radio.radio-list .slds-radio_icon {
	width: 30px;
	height: 30px;
	padding: 2px;
	vertical-align: middle;
	border: 1px solid #dddbda;
	border-radius: 50%;
	margin-right: 4px;
}

#formContent .control-group .controls-table .slds-radio.radio-list .slds-form-element__label.slds-radio__label.slds-radio__label_target:active,
#formContent .control-group .controls-table .slds-radio.radio-list .slds-form-element__label.slds-radio__label.slds-radio__label_target:focus,
#formContent .control-group .controls-table .slds-radio.radio-list .slds-form-element__label.slds-radio__label.slds-radio__label_target:hover {
	  text-decoration: none;
	  color: #706e6b;
	  cursor: default;
}

#formContent .control-group .controls-table:not(.compact-layout) .slds-radio.radio-list .slds-form-element__label {
	margin-top: 6px;
}

#formContent .control-group .slds-radio .slds-radio__label svg.inverted-rb-icon {
	border-radius: 50%;
	padding: 4px;
	background-color: rgba(112,110,107,0.25);
	fill: #fff;
	width: 22px;
	height: 22px;
	margin: 1px;
}

#formContent .control-group .slds-radio .slds-radio__label svg.warning-rb-icon {
    padding: 0 8% 14%;
}

#formContent .control-group .slds-radio [type="radio"]:checked + .slds-radio__label svg.inverted-rb-icon {
	background-color: #0070d2;
	fill: #fff;
}

#formContent .control-group .controls-table .slds-radio .slds-radio__label svg.dot-rb-icon {	
	width: 32px;
	height: 32px;
	margin: -4px;
}

@media screen and (min-width: 768px) {
	#formContent .control-group .controls-table.compact-layout .slds-form-element__label {
		margin-top: 4px;
	}

	#formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio__label.OR-radio-flex { 
		display:flex;
	}

	#formContent .control-group .controls.controls-table.compact-layout .table-radio {
	    width: 100%;
	    max-width: 100%;
	}

	#formContent .control-group .controls-table .compact-layout .slds-radio .slds-radio_icon {
		margin: 0 4px 0 0;
	}

	#formContent .control-group .controls-table .compact-layout .slds-radio .slds-radio__label {
		margin: 6px;
	  	display: flex;
	  	margin-top: 2px;
	}

	#formContent .control-group .controls.controls-table.compact-layout .slds-form-element__control {
		display: flex;
		flex-wrap: wrap;
		justify-content: flex-start;
	}
}

#previewStatus.tb-modal.phone-size #formContent .control-group .slds-radio.radio-list .slds-radio__label.OR-radio-flex { 
	text-align: left;
}

/* The below block should be the exact same thing as the subsequent block. The above is for displaying as mobile in preview. */
#previewStatus.tb-modal.phone-size #formContent .control-group .compact-layout .slds-form-element.OR-form-element_width.table-radio {
	width: 100%;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio__label .slds-radio_icon {
	width: 60px;
	height: 60px;
	display: block;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls-table.compact-layout .slds-radio.radio-list {
	max-width: 60px;
	margin-right: 4px;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls-table.compact-layout .slds-radio .slds-radio_icon {
	margin: 0;
}

#previewStatus.tb-modal.phone-size #formContent  .control-group .compact-layout .slds-radio .slds-form-element__label {
	width: 100%;
	text-align: center;
	display: block;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls.controls-table.compact-layout .slds-form-element__control {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-around;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio__label.OR-radio-flex { 
	display: block;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls.controls-table.compact-layout .slds-radio .slds-radio__label svg {
  	width: 50px;
	height: 50px;
	margin: 2px;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls.controls-table.compact-layout .slds-radio .slds-radio__label svg.inverted-rb-icon {
	width: 48px;
	height: 48px;
	margin: 3px;
	padding: 10px;
}

#previewStatus.tb-modal.phone-size #formContent .control-group .controls-table.compact-layout .slds-radio .slds-radio__label svg.dot-rb-icon {	
	width: 68px;
	height: 68px;
	margin: -7px;
}

/* The above block should be the exact same thing as the below block. The above is for displaying as mobile in preview. */
@media screen and (max-width: 768px) {
	#formContent .control-group .compact-layout .slds-form-element.OR-form-element_width.table-radio {
		width: 100%;
	}

	#formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio__label .slds-radio_icon {
		width: 60px;
		height: 60px;
		display: block;
	}

	#formContent .control-group .controls-table.compact-layout .slds-radio.radio-list {
		max-width: 60px;
		margin-right: 4px;
	}

	#formContent .control-group .controls-table.compact-layout .slds-radio .slds-radio_icon {
		margin: 0;
	}

	#formContent  .control-group .compact-layout .slds-radio .slds-form-element__label {
		width: 100%;
		text-align: center;
		display: block;
	}

	#formContent .control-group .controls.controls-table.compact-layout .slds-form-element__control {
		display: flex;
		flex-wrap: wrap;
		justify-content: space-around;
	}

	#formContent .control-group .compact-layout .slds-radio.radio-list .slds-radio__label.OR-radio-flex { 
		display: block;
	}

  	#formContent .control-group .controls.controls-table.compact-layout .slds-radio .slds-radio__label svg {
	  	width: 50px;
		height: 50px;
		margin: 2px;
  	}
	
	#formContent .control-group .controls.controls-table.compact-layout .slds-radio .slds-radio__label svg.inverted-rb-icon {
    	width: 48px;
		height: 48px;
		margin: 3px;
		padding: 10px;
	}

	#formContent .control-group .controls-table.compact-layout .slds-radio .slds-radio__label svg.dot-rb-icon {	
		width: 68px;
		height: 68px;
		margin: -7px;
	}
}