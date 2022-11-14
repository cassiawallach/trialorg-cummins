html {
    height: 100%;
}

body {
    height: 100%;
    font-family:Arial;
    font-size:12px;
    margin:0;
}
a {
	color:#2c3e50;
}

h1 {
	font-size: 24px;
	display:block;
}

h2 {
	display:block;
	font-size:20px;
	font-weight: bold;
}

.questionPlaceHolder {
	border:2px dashed #666; 
	color: #666;
	height:30px;
	width:90%;
	text-align: center;
}
.sectionPlaceHolder {
	border:2px dashed #666; 
	color: #666;
	height:75px;
	width:800px;
	text-align: center;
}

.conditionalErrors li{
	text-align:left;
}

.bannerHeader > h2 {
	padding-right: 70px;
	margin-top:0;
}

h3 {
	display:block;
	font-size:18px;
	font-weight: bold;
}

.builderPageIntro {
	text-align:center;
}


.alertErrorContainer {
	display:block;
	margin:0 auto;
	width:500px;
}

/* error on page */
.alertError {
	display: block;
	background-color:#FF6666;
	color:#B20000;
	font-weight:bold;	
	font-size:18px;
	padding:5px;
	border: 1px solid black;
	border-radius:3px;
}

.draggableNewQuestion, .draggableNewSection, .draggableNewSpace, .draggableNewText{
	display:inline-block;
	z-index:1000;
}


.draggableNewQuestion:hover, .draggableNewSection:hover , .draggableNewSpace:hover, .draggableNewText:hover{
	cursor:move;
}

.bannerHeader {
	background-color:#1BB2E0;
	height:auto;
	text-align:center;
}

.label-med-list{
	padding: 15px 0 0 20px;
	font-size: 1.4em;
}
.displayMedsLabel{
	display: block;
}
.hiddenElement{
	display: none;
}

#topContent {
	position:fixed;
	width:100%;
	background-color:white;
	z-index:100;
	border-bottom:1px solid black;
	height:220px;
}

/* used to center button inside container**********/
.btn.centerBtn {
	display:block;
	margin: 20px auto;
}

#allSectionsContainer {
	z-index:105;
	padding-top:250px;
	width:802px;
	margin: 0 auto;
	
}

.dragSection {
	width:802px;
	margin: 20px auto;
}

.picklistValueContainer {
	display:none;
}

.tb-modal {
	position:fixed;
 	top:50%;
 	left:50%;
 	
 	height:auto;
 	border: 4px solid black;
 	background-color:#FFF;
 	display:none;
 	border-radius:5px;
 	z-index: 888;	
 	text-align:center;
 	box-sizing: border-box;
}
#previewStatus {
	right: 2%;
	left: 2%;
	top: 0%
}
.smallModal {
	margin-left:-200px;
 	margin-top:-200px;
 	padding-top:30px;
 	padding-bottom:20px;
 	width:440px;
}
.largeModal {
 	margin-left:-446px;
 	margin-top:-240px;
 	padding-top:30px;
 	padding-bottom:20px;
 	width:892px;
}

.modalForm {
	margin-top:10px;
	height:auto;
	display:inline-block;
	box-sizing: border-box;
}
/* right side of question modal, with viewable info*/
.modalForm .modalColumn {
	width:440px;
	display:inline-block;
	box-sizing:border-box;
	min-height:350px;
	vertical-align: top;
	max-height:350px;
	overflow-y:auto;
	overflow-x:hidden;
	
}
/* on second column*/
.modalForm .modalColumn:nth-child(2) {
	border-left:1px solid black;
} 
/* viewable text in question modal*/
.modalForm .modalColumn h3 {
	margin-top:0;
}

.smallModal .modalTable {
	margin: 0 auto;
	text-align:left;
}

#discoveryTypeModal table {
	display:block;
	max-height:450px;
	overflow-y:auto;
}


.modalForm input, textarea, select, .fieldError {
	width:181px;
	text-align:left;
	display:inline-block;
	margin-right:45px;
	margin-top:10px;
	margin-bottom:10px;
}

.errorMessage label, .errorMessage .fieldError {
	color:red;
	margin-top:0px !important;
	margin-bottom: 0px !important;
}

.modalForm textarea {
	width:170px;
	height:70px;
}

.modalForm input[type="checkbox"] {

}

/* removed , .picklistValueContainer > div from below style */
.modalForm label  {
	display: inline-block;			
	width:156px;
	text-align: right;
	vertical-align:top;
	margin-bottom:10px;
	margin-top:10px;
	margin-right:10px;
}


.questionList .indentOnce {
	left:52%;
}
.questionList .indentTwice {
	left:54%;
}
.questionList .indentThrice {
	left:56%;
}

.closeButton {
	top:5px;
	position:absolute;
	right:5px;
	z-index:4;
	cursor:pointer;
}

.editLink {
	top:3px;
	position:absolute;
	right:30px;
	z-index:4;
	cursor:pointer;
}

.btn { 
	cursor:pointer;
	height:30px;
	border:1px solid black;
	font-size:11px;
	font-weight:bold;
	background-color:#27ae60;
	color:white;
}
.greenBtn {
	background-color:#27ae60;
	margin:20px 0;						
}

.questionColumn {
	vertical-align:top;
	display:inline-block;
	width:399px;
}

.questionColumn.rightBorder {
	border-right: 1px solid black;
}

.questionList {
	min-height:100px;
	list-style-type: none;
	padding: 0px;
	/*padding-bottom:40px;*/
	margin: 0px;
	text-align:left;
}

.questionBox {
	width:163px;
	border:2px solid #E67E22;
	border-radius: 10px;	
	margin-top:5px;
	margin-bottom:5px;
	padding:5px;
	color:#E67E22;
	background-color:#FFF;
	position:relative;
}
.questionBox:hover {
	cursor:move;
}

.questionBoxUsed {
	width:300px;
	border:2px solid #E67E22;
	border-radius: 10px;	
	left:50%;
	margin-left:-150px;
	margin-top:5px;
	margin-bottom:5px;
	padding:5px;
	color:#E67E22;
	background-color:#FFF;
	position:relative;
}
.questionBoxUsed:hover {
	cursor:move;
}

.hoverText{
	text-decoration:underline;
	cursor:pointer;
	color:blue;
}

.questionLabel {
	display:inline-block;
	width:220px;
	margin-left:10px;
}

.freeTextLabel {
	display:inline-block;
	width:500px;
	margin-left:10px;
}

.sectionList {
	list-style-type: none;
	padding: 0px;
	margin: 0px;	
	min-height:200px;
}

.sectionBox {
	width:800px;
	min-height:120px;
	border:1px solid black;
	border-radius: 3px;
	margin:10px 0 10px 0;
	background-color:#FFF;
	position:relative;
}
.sectionBox:hover {
	cursor:move;
}

/*** REMOVED
	#colorPicker {
	position:absolute;
	top:10px;
	right:10px;
}***/

#fade {
    display: none;  /* ensures it�s invisible until it�s called */
    position: fixed;     
    left: 0%; /* makes the div span all the way across the viewing area */
    top: 0%; /* makes the div span all the way across the viewing area */
    background-color: black;
    -moz-opacity: 0.7; /* makes the div transparent for overlay effect */
    opacity: .70;
    filter: alpha(opacity=70);
    width: 100%;
    height: 100%;
    z-index: 777; 
    overflow-y:hidden;
}

table.gridtable {
	font-family: verdana,arial,sans-serif;
	font-size:11px;
	color:#333333;
	border-width: 1px;
	border-color: #666666;
	border-collapse: collapse;
	margin-left:5px;
}
table.gridtable th {
	border-width: 1px;
	border-style: solid;
	border-color: #666666;
	background-color: #dedede;
}
table.gridtable td {
	border-width: 1px;
	border-style: solid;
	border-color: #666666;
	max-width:118px;
}

table.gridtable select{
	width:110px;
	margin-left:5px;
}

table.gridtable input{
	width:100px;
	margin-left:5px;

}

#removeRowLink{
	float:right;
	margin-right:20px;
	cursor:pointer;
}

#addRowLink{
	float:left;
	margin-left:23px;
	cursor:pointer;
}
#conditionalTableContainer {
	display:none;

}
#conditionalTable{
	text-align:center;
	margin: 0 auto;
}

.conditionalLinks{
	margin-top:5px;
}

#displayFormula{
	text-transform:uppercase;
}

.filterLogicWrapper label, input{
	display:inline;
	text-align:left;
	vertical-align:middle;
}

.filterLogicWrapper input{
	width:290px;
}

.icon-share {
	vertical-align:top !important;
}

/* section page break HR */
/*hr.page-break {
    padding: 0;
    border: none;
    border-top: 1px dashed #333;
    color: #333;
    text-align: center;
    margin-top:30px;
}
hr.page-break:after {
    content: "Page Break";
    display: inline-block;
    position: relative; 
    top: -0.7em;  
    font-size: 1.5em;
    padding: 0 0.25em;
    background: white;
}*/

.page-break { 
	width:100%; 
	text-align:center; 
	border-top: 1px dashed #333; 
	line-height:0.1em; 
	margin:30px 0 20px; 
} 
.page-break span { 
	background:#fff; 
	padding:0 10px; 
	font-size:18px;
}


/* Tooltip ***********************************************************/
.tooltip{
	display:inline;
	position:relative;
	color:#E67E22;
	cursor:default;
	vertical-align: top;
}
.tooltip:hover{text-decoration:none}
.tooltip:hover:after{
	background:#111;
	background:rgba(0,0,0,.8);
	border-radius:5px;
	bottom:18px;
	color:#fff;
	content:attr(data-title);
	display:block;
	padding:5px 15px;
	position:absolute;
	white-space:nowrap;
	font-weight:normal;
	z-index:98
}
		  
/* arrow piece of tooltip */
.tooltip:hover:before{
	border:solid;
	border-color:#111 transparent;
	border-width:6px 6px 0 6px;
	bottom:12px;
	content:"";
	display:block;
	left:30%;
	position:absolute;
	z-index:99
}

/* buttons */
.builderPageIntro .btn { 
	cursor:pointer;
	height:30px;
	width:100px;
	border:1px solid black;
	color:white;
	font-size:11px;
	font-weight:bold;
	border-radius: 0px;
}
.builderPageIntro .cancelBtn {
	background:none; /* don't show SF background image */
	background-color:#c0392b;
}
.builderPageIntro .cancelBtn:hover {
	background-color:#e74c3c;
}
.builderPageIntro .saveBtn {
	background:none; /* don't show SF background image */
	background-color:#27ae60;
}
.builderPageIntro .saveBtn:hover {
	background-color:#2ecc71;
}
.builderPageIntro .backBtn {
	background:none; /* don't show SF background image */
	background-color:#2c3e50;
}
.builderPageIntro .backBtn:hover {
	background-color:#95a5a6;
}

/* progress indicator ************************************/

.steps {
	text-align:center;
	margin:10px;
}

.steps a {
    padding: 10px 12px 10px 25px;
    background: #efefef;
    position: relative;
    display: inline-block;
    color:#000;
    text-decoration:none;
}

/* if the elements aren't links at least dont display underlines*/
.steps a:hover {
	text-decoration:none;
	color:inherit;
}
/* not needed if elements arent links
.steps a:hover {
	cursor: pointer; 
	cursor: hand;
	text-decoration:none;
	background: #1BB2E0;
    color: #fff;
}
.steps a:hover:after {
 border-left-color: #1BB2E0;
}*/

.steps a:before {
    width: 0;
    height: 0;
    border-top: 18px inset transparent;
    border-bottom: 17px inset transparent;
    border-left: 18px solid #fff;
    position: absolute;
    content: "";
    top: 0;
    left: 0;
}
.steps a:after {
    width: 0;
    height: 0;
    border-top: 18px inset transparent;
    border-bottom: 17px inset transparent;
    border-left: 18px solid #efefef;
    position: absolute;
    content: "";
    top: 0;
    right: -18px;
    z-index: 2;
}
.steps a:last-child:after,
.steps a:first-child:before {
    border: none;
}
.steps a:first-child {
    padding-left:15px;   
    -webkit-border-radius: 4px 0 0 4px;
       -moz-border-radius: 4px 0 0 4px;
            border-radius: 4px 0 0 4px;
}
.steps a:last-child {
    -webkit-border-radius: 0 4px 4px 0;
       -moz-border-radius: 0 4px 4px 0;
            border-radius: 0 4px 4px 0;
}
.steps .current {
    background: #1BB2E0;
    color: #FFF;
}

/* no color for hover if its not a link */
.steps .current:hover {
    color: #FFF;
}
.steps .current:after {
    border-left-color: #1BB2E0;
}

/* override to not hide scrollbars when not active on OSX Lion */
::-webkit-scrollbar {
    -webkit-appearance: none;
    width: 7px;
}
::-webkit-scrollbar-thumb {
    border-radius: 4px;
    background-color: rgba(0,0,0,.5);
    -webkit-box-shadow: 0 0 1px rgba(255,255,255,.5);
}


/* Preview styles */
div#previewStatus, form#mainForm{
	background-color: rgba(242,242,242,1);
}
div#previewStatus{
	height: 100%;
	overflow: auto;
}
.button-row-form{
	background-color: transparent;
	position: initial;
}
button.btn.nextBtn, button.btn.prevBtn{
	color: #000;
}
#mainForm .currentPageContainer{
	padding-top: 20px;
}
.previewCloseBtn{
	width: 30px;
	height: 30px;
	position: absolute;
	left: 0px;
	background-color: #000;
	border-bottom-right-radius: 5px;
	cursor: pointer;
}
.previewCloseIndicator{
	color: #fff;
	position: absolute;
	top: 3px;
	right: 11px;
	font-size: 1.2em;
}

/* Make Discovery - lookup picklist styling  */
.lookups p{
	display: inline;
}
.lookups p.after-picklist{
	margin-left: 0px;
}
.lookups p.after-form-picklist{
	margin-left: -40px;
}
.lookups p.after-picklist-moved{
	margin-left: 22px;
}
.lookupError{
			border: 2px solid #B20000;
}
.lookupErrorMsg{
	font-size: 14px;
	font-weight: bold;
	color: #B20000;
}
i.icon-disco-tooltip {
	position: absolute;
	top: 10px;
	font-size: 1.5em;
}
i.icon-disco-tooltip-dark{
	color: #000;
}
.disco-tooltip{
	display: none;
}
.discoLookup{
	margin-right: 0px;
}