#mainBody {
    padding-top:220px;
    min-height:600px;
    height:100%;
}
#leftColumn {
    width:20%;
    border-right:1px solid black;
    height:100%;
    position:fixed;
    text-align: center;
    overflow-y:auto;
}
#leftColumn .questionList {
    margin-bottom:200px; /* works with overflow-y on leftColumn to show scrollbar when needed */
}
#rightColumn {
    width:80%;
    height:100%;
    margin-left:20%; /* 20% to account for fixed left column */     
    text-align:center;  
}   
.drFooter {
    background-color:#1BB2E0;
    font-weight:bold;
    font-size:14px;;
}
.drFooter input, select {
    margin-left:10px;
    font-size:14px;
}       
/* style of question while being dragged */
.draggingQuestion {
    width:300px !important;
    text-align: center;
    list-style-type: none;
}       
.selectedQuestions {
    min-height:100px;
    width:100%;
    list-style-type: none;
}
.placeholderText {
    font-size:14px;
    font-weight:bold;
}
.notDraggable {
    cursor:default !important;
}
.thresholdInput {
    width:50px;
}
.discoveryTypeInput {
    width:200px;
}
.operatorInput {
    width:120px;
    margin-right:0px;
}
.discoveryRuleNameInput {
    font-size:18px;
    width:350px;
    text-align:center;
}
.errorBorder {
    border: 2px solid red;
}
.errorText {
    font-size:12px;
    color:white;
    background-color:red;
}       

.cloneBtn {
    top:4px;
    position:absolute;
    right:40px;
    z-index:4;
    cursor:pointer;
    font-weight:bold;
    text-decoration: underline;
}

/* overrides of general styles ********************/
.questionBox {
    left:0;
    margin:5px auto;
    width:80%; /* cant have 100 since it has padding */
}
.sectionBox {
    margin: 0 auto 40px auto;
}
.sectionBox:hover {
    cursor:default;
}
.questionList {
    text-align: center;         
}
.selectedQuestions {
    padding-left:0;
}
.questionLabel {
    width:80%;
}


/* for discovery rule groups *************/

.DRGcheckbox {
    position:absolute;
    top:4px;
    left:4px;
    font-size:13px;
    font-weight:bold;
}