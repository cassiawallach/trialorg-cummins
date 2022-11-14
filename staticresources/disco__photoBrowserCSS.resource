#mainContent {
	display: flex;
	flex-wrap: nowrap;
	flex-direction: row;
}
#mainContent .select-question, #mainContent .no-results, #mainContent .unable-to-complete {
	font-size: 20px;
}
#mainContent .select-question, #mainContent .photo-results {
	font-size: 20px;
}
#filterSection {
	width:435px;
	font-size:11px;
}
#filterSection .label-wrapper {
	display: block;
	height: 32px;
	padding: 8px;
	background-color: #d8edff;
}
#filterSection .label-wrapper .show-filter, #filterSection .label-wrapper .enable-filter{
	height: 28px;
}
#filterSection .filter-actions {
	position: absolute;
	top: 2px;
	right: 2px;
}
#filterSection .slds-form-element {
	border: 1px solid #dddbda;
	border-radius: 4px;
}
#filterSection .slds-form-element__control {
	padding: 5px;
}
#filterSection .label-wrapper .slds-form-element__label {
	color: #3e3e3c;
}
#filterSection .additional-filters {
	display: none;
}
#filterSection .additional-filters-disabled {
	font-size: 12px;
}
#filterSection .clear-additional-filters {
	font: 400 12px system-ui;
	height: 28px;
	position: absolute;
	top: 6px;
	right: 10px;
}

#lightgallery {
	width:100%;
}
#lightgallery .no-results, #lightgallery .unable-to-complete {
	display: none;
}
.gallery-scroll-view {
	display: flex;
	flex-direction: row;
	flex-wrap: wrap;
	justify-content: flex-start;
}
.gallery-scroll-view a {
	display: block;
}
.gallery-scroll-view .thumbnail-details {
	font-size:12px;
	padding: 0 4px;
	font-weight: 700;
	text-align: left;
	width: 100%;
	overflow: hidden;
	text-overflow: ellipsis;
}
.gallery-scroll-view .thumbnail-details .thumbnail-label{
	font-weight: 400;
}
.photo-element {
	width: 200px;
	margin: 10px;
	height: fit-content;
	height: -moz-fit-content;
	text-align: center;
	border: 1px solid #dddbda;
	border-radius: 4px;
}
.photo-info .save-btn {
	margin: auto;
	display: block;
}
.photo-form {
	width:100%;
	margin:0 auto;
	height: calc(100% - 100px);
	padding: 0 10px 10px 10px;
	overflow-y: scroll;
}
.photo-form .slds-form-element__label {
	color:#CCC;
}
.photo-form .slds-form-element__control {
	font-weight: 900;
}
.slds-scope .photo-form .slds-input {
	background-color:black;
}

.photo-form .tokenfield {
	background-color: black;
	color:#CCC;
}
.photo-form .tokenfield input {
	background-color: black;
}
.photo-form .tokenfield .tokenfield-set > ul > li {
	background:black;
	color:#CCC;
	border:1px solid #CCC;
}
.photo-form .tokenfield .tokenfield-set > ul > li .item-remove {
	color: #0070d2;
}
.photo-form .tokenfield-suggest {
	background:black;
	color:#CCC;
	border:1px solid white;
}
.slds-text-heading_medium {
	background-color: #5679C0;
	color: white;
	padding: 8px 8px;
	position: relative;
}
.lg-outer .lg-item.lg-complete.lg-zoomable .lg-img-wrap {
	padding-right: 400px;
}
.lg-outer .lg-actions {
	padding-right: 420px;
}
.lg-outer .lg-actions .lg-next {
	right: 420px;
}
.lg .photo-info-wrapper {
	position: static
}
.lg .photo-info {
	background-color:black;
	z-index:1080;
	width:370px;
	height:calc(100% - 190px);
	position:absolute;
	right:20px;
	top:50px;
	color:#CCC;
	border:1px solid gray;
	border-radius: 4px
}

/* lookup input filters */
.slds-scope a.slds-input {
	position: absolute;
	right: 7px;
	width: 20px;
	padding: 0;
	border: 0;
	min-height: 0;
	top: 40px;
}
/* date format for filters should wrap */
.slds-scope .dateFormat {
	display: block;
}
.slds-scope .picklistArrowRight, .slds-scope .picklistArrowLeft {
	min-height: 0;
	height: 20px;
	border: 0;
}

#initLoader {
	display: none;
}
#initLoader .OR-modal_loading {
	width: 600px;
	margin-left: 20px;
	border-radius: 4px;
}
#initLoader .OR-spinner {
	margin: auto;
}
#initLoader h3 {
	background-color: white;
}
.modal-title {
	color: gray;
}
.slds-scope button.clear-all-filters {
	position: absolute;
	top: 25px;
	right: 30px;
}
/* overrides for jquery UI tooltip */
.ui-tooltip {
	padding: 8px;
	position: absolute;
	z-index: 99999;
	max-width: 300px;
	-webkit-box-shadow: 0 0 5px #aaa;
	box-shadow: 0 0 5px #aaa;
	font: 100% / 1.5 "Salesforce Sans", Arial, sans-serif;
	background-color: white;
}
/* suppress extra helper text created by jquery UI tooltip */
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

.slds-scope .intro-steps {
	margin-top: 15px;
}

.slds-scope .intro-steps ol {
	font-size: 13px;
	counter-reset: item;
}
.slds-scope .intro-steps ol li {
	position: relative;
	line-height: 15px;      
	padding-left: 30px;
	margin-bottom: 10px;
}

.slds-scope .intro-steps ol li:before {
	content: counter(item);
	counter-increment: item;
	color: #fff;
	position: absolute;
	top: 0;
	left: 0;
	width: 18px;
	height: 18px;
	background: #5679C0;
	border-radius: 50%;
	-webkit-border-radius: 50%;
	-moz-border-radius: 50%;                
	text-align: center;
	font-size: 12px;
}
.slds-scope select[multiple] option {
	width: 100%;
	overflow: hidden;
	text-overflow: ellipsis;
}
/* remove MS picklist custom arrows */
.slds-scope .slds-select_container:after, .slds-scope .slds-select_container:before {
	border: 0;
}
.slds-scope .slds-select_container .slds-select {
	padding-right: 0;
}
/* IE11 only */
@media all and (-ms-high-contrast:none) {
	.slds-scope .gallery-scroll-view {
		width: 1000px;
	}
}