/* CSS Document for jquery 

Cointains the CSS for the following jquery components.

1. Show-hide Div
2. Modal Window
3. Calender Control
4. Tab Control
5. DataTable
6.Content rating
7.Tree View
8. Accordian




*/

.clearStyle{width: 100%;clear: both;line-height: 0px;font-size: 0px;}

/*======================Show/Hide Div==============================*/


.showHideTrigger{padding: 12px 0 0 0;color:#000; cursor:pointer;}

.showHideCnt{display: none; padding-top:10px; padding-bottom:9px;margin:0;}

/*======================Accordian==============================*/

.accoHeaderNormal{ min-height: 30px; line-height:30px;background: url('../images/imgAccordion.png')  repeat-x top; background-position:0px -148px !important;	border:1px solid #DCDBDB; padding: 0 10px 0px 10px;}
.accoHeaderSelected{background-position:0px -98px !important; border:1px solid #959393 !important;}
.accoexpCollBtnN{text-decoration:none; cursor:pointer; background:url('../images/imgAccordion.png') no-repeat top; background-position:0px 0px !important; margin-top:3px; width:28px; height:26px; }
.accoExpCollBtnR{ background-position:0px -52px !important; }
.accoContent{border:1px solid #959393;padding: 12px; border-top-width:0px; background-color:#F9F8F8; text-align:left;}
.accoLoading{background:url("../images/processing_circle.gif") no-repeat center center #F9F8F8 !important;}


/*=======================Show/Hide navigation========================*/





/*=======================Modal Window========================*/


#TB_window {font: 12px ;color: #000;}
#TB_secondLine {font: 10px;	color:#000;}
#TB_window a:link {color: #000;}
#TB_window a:visited {color: #000;}
#TB_window a:hover {color: #000;}
#TB_window a:active {color: #000;}
#TB_window a:focus{color: #000;}


/*======Overlay Settings=====*/
#TB_overlay {position: fixed;z-index:100;top: 0px;left: 0px;height:100%;width:100%; }
.TB_overlayMacFFBGHack {background: url(../images/modalbg.png) repeat;}
.TB_overlayBG {	background-color:#000;filter:alpha(opacity=75);-moz-opacity: 0.75;opacity: 0.75;}
* html #TB_overlay { /* ie6 hack */
position: absolute; height: expression(document.body.scrollHeight > document.body.offsetHeight ? document.body.scrollHeight : document.body.offsetHeight + 'px');}
#TB_window {	position: fixed;background: #ffffff;z-index: 102;color:#000000;display:none;border: 1px solid #000;text-align:left;top:50%;left:50%;}

* html #TB_window { /* ie6 hack */
position: absolute;margin-top: expression(0 - parseInt(this.offsetHeight / 2) + (TBWindowMargin = document.documentElement && document.documentElement.scrollTop || document.body.scrollTop) + 'px');}

#TB_window img#TB_Image {
	display:block;
	margin: 15px 0 0 15px;
	border-right: 0px solid #ccc;
	border-bottom: 0px solid #ccc;
	border-top: 0px solid #666;
	border-left: 0px solid #666;
}

#TB_caption{
	height:25px;
	padding:10px 15px 10px 15px;
	float:left; font-size:14px;
}

#TB_closeWindow{
	height:25px;
	padding:5px 15px 10px 0;
	float:right;
}

#TB_closeAjaxWindow{
	padding:10px 10px 0px 0;
	margin-bottom:1px;
	text-align:right;
	float:right; 
}

#TB_ajaxWindowTitle{
	float:left;
	padding:12px 10px 10px 10px;
}

#TB_title{
	background-color:#e8e8e8;
	min-height:40px;
	background:url("/ConnectedSolutions/images/overlay_bg.jpg") repeat-x ; 
}

#TB_ajaxContent{
	clear:both;
	padding:2px 15px 15px 15px;
	overflow:auto;
	text-align:left;
	
}

#TB_ajaxContent.TB_modal{
	padding:15px;
}

#TB_ajaxContent p{
	padding:5px 0px 5px 0px;
}

#TB_load{
	position: fixed;
	display:none;
	height:13px;
	width:208px;
	z-index:103;
	top: 50%;
	left: 50%;
	margin: -6px 0 0 -104px; /* -height/2 0 0 -width/2 */
}

* html #TB_load { /* ie6 hack */
position: absolute;
margin-top: expression(0 - parseInt(this.offsetHeight / 2) + (TBWindowMargin = document.documentElement && document.documentElement.scrollTop || document.body.scrollTop) + 'px');
}

#TB_HideSelect{
	z-index:99;
	position:fixed;
	top: 0;
	left: 0;
	background-color:#fff;
	border:none;
	filter:alpha(opacity=0);
	-moz-opacity: 0;
	opacity: 0;
	height:100%;
	width:100%;
}

* html #TB_HideSelect { /* ie6 hack */
     position: absolute;
     height: expression(document.body.scrollHeight > document.body.offsetHeight ? document.body.scrollHeight : document.body.offsetHeight + 'px');
}

#TB_iframeContent{
	clear:both;
	border:none;
	margin-bottom:-1px;
	margin-top:1px;
	_margin-bottom:1px;
}

.modalContent { padding: 15px 15px 15px 15px;
}
/*====================Overlay Settings End================================*/

/*====================calender control================================*/

/* calendar icon */
img.tcalIcon {
	cursor: pointer;
	margin-left: 1px;
	vertical-align: middle;
}
/* calendar container element */
div#tcal {
	position: absolute;
	visibility: hidden;
	z-index: 100;
	width: 158px;
	padding: 2px 0 0 0;
}
/* all tables in calendar */
div#tcal table {
	width: 100%;
	border: 1px solid silver;
	border-collapse: collapse;
	background-color: white;
}
/* navigation table */
div#tcal table.ctrl {
	border-bottom: 0;
}
/* navigation buttons */
div#tcal table.ctrl td {
	width: 16px;
	height: 15px; text-align:center; vertical-align:middle;
}

div#tcal table.ctrl img {
	vertical-align:middle;
}

/* month year header */
div#tcal table.ctrl th {
	background-color: #fff;
	color: black;
	border: 0;
}
/* week days header */
div#tcal th {
	border: 1px solid silver;
	border-collapse: collapse;
	text-align: center;
	padding: 3px 0;
	font-family: arial;
	font-size: 10px;
	background-color: #000;
	color: white;
}
/* date cells */
div#tcal td {
	border: 0;
	border-collapse: collapse;
	text-align: center;
	padding: 2px 0;
	font-family: arial;
	font-size: 11px;
	width: 22px;
	cursor: pointer; 
}
/* date highlight
   in case of conflicting settings order here determines the priority from least to most important */
div#tcal td.othermonth {
	color: #666666;
}
div#tcal td.weekendSat {
	background-color: #F0F0F0;
}
div#tcal td.weekendSun {
	background-color: #DBD8D8;
}
div#tcal td.today {
	border: 1px solid #A0A0A0;
}
div#tcal td.selected {
	background-color: #A0A0A0;
	border: 1px solid #000;
}

div#tcal .caldate:hover {
	background-color: #BEBBBB;
}

/* iframe element used to suppress windowed controls in IE5/6 */
iframe#tcalIF {
	position: absolute;
	visibility: hidden;
	z-index: 98;
	border: 0;
}
/* transparent shadow */
div#tcalShade {
	position: absolute;
	visibility: hidden;
	z-index: 9;
}
div#tcalShade table {
	border: 0;
	border-collapse: collapse;
	width: 100%;
}
div#tcalShade table td {
	border: 0;
	border-collapse: collapse;
	padding: 0;
}


/*====================calender control end================================*/


/*====================Tab control Start================================*/

.tabs { border-bottom:#d9d9d9 1px solid; padding:0px; list-style-type: none !important; margin: 0px; height: 28px; }
.tabs A {color: #7c7c7c; text-decoration: none; outline:none; padding: 10px 10px 3px 7px;  margin: 0px 0px 0px 3px;  display: block; background: url(/ConnectedSolutions/images/img_tab_rd.png) no-repeat right top; }
.tabs A:hover {	COLOR: #da0000;}

.tabs LI {	margin: 1px 3px 0px 0px; background: url(/ConnectedSolutions/images/img_tab_ld.png) no-repeat left top; float: left; border-bottom-width:: 0px; }
.tabs LI.selectedTab {background: url(/ConnectedSolutions/images/img_tab_ls.png); }

.tabs .selectedTab A {	 margin: 0px 0px 0px 3px;  background: url(/ConnectedSolutions/images/img_tab_rs.png) no-repeat right top; COLOR: #000;}

.containerTabControlContent {	BORDER-BOTTOM: #d9d9d9 1px solid; TEXT-ALIGN: left; BORDER-LEFT: #d9d9d9 1px solid; PADDING-BOTTOM: 10px; BACKGROUND-COLOR: #f0f0f0; MIN-HEIGHT: 100px; PADDING-LEFT: 10px; PADDING-RIGHT: 10px; BORDER-TOP: #d9d9d9 0px solid; BORDER-RIGHT: #d9d9d9 1px solid; PADDING-TOP: 10px}

.containerLoading{background:url("../images/processing_circle.gif") no-repeat center center #F0F0F0 !important;}
/*====================Tab control End================================*/

/*====================DataTable control Start================================*/
.dataTablesProcessing {
	background:url("../images/processing_circle.gif") no-repeat center center; 
	position: absolute;
	top: 50%;
	left: 50%;
	width: 300px;
	height: 30px;
	margin-left: -125px;
	margin-top: -15px;
	border: 0px;
}

.datatableTopBar{ 
	width:100%; vertical-align:bottom; float:none; margin-bottom:5px; line-height:15px
}
table.dataTable {
	border-collapse:collapse;
	border: 1px solid #BABABA !important;
	font-weight:normal;
}
table.dataTable th {
	border: 1px solid #CCCCCC;
	padding: 4px;  
	font-weight:normal;
	background-color: #4f7091;
	color:#FFFFFF;
}
table.dataTable td {
	border: 1px solid #CCCCCC;
	padding: 4px;
	background-color: #ffffff;
	color:#000;
	width:200px;
}

table.dataTable tr.alt td {
	border: 1px solid #CCCCCC;
	padding: 4px;
	background-color: #EFF7FF;
	color:#000;
	width:200px;
}


table.dataTable .textType {
	text-align:left;
}
table.dataTable .dateType {
	text-align:center;
}
table.dataTable .numberType {
	text-align:right;
}
.dataTablesLength {
	width: 230px;
	float: right; text-align:right;
}
.dataTables_filter {
	width: 50%;
	float: right;
	text-align: right;
}

.dataTables_Goto {
	vertical-align:middle; line-height:25px;
}


.dataTablesInfo{ vertical-align:middle; line-height:25px;
}

.custom{float:left; width:130px;}
.bottom{ float:right;width:130px;}

.pagination{
padding: 0px; text-align:center; 
}

.dataTables_Goto{float:right}
.sorting_asc{background:url(/ConnectedSolutions/images/sort_asc.png) no-repeat right center;}
.sorting_desc{background:url(/ConnectedSolutions/images/sort_desc.png) no-repeat right center;}
.sorting{background:url(/ConnectedSolutions/images/sort_both.png) no-repeat right center;}
/*====================pagination================================*/

.paging_full_numbers {
	
	height: 25px;
	line-height: 26px;
}

.paging_full_numbers span.paginate_button,
 	.paging_full_numbers span.paginate_active {
	border: 1px solid #aaa;
	-webkit-border-radius: 2px;
	-moz-border-radius: 2px;
	padding: 2.5px 4.5px;
	margin: 0 3px;
	cursor: pointer;
}

.paging_full_numbers span.paginate_button {
	background-color: #fff;
	border: 1px solid #C1C1C1;
}

.paging_full_numbers span.paginate_button:hover {
	background-color: #F80000;
	color: #000 !important;
}

.paging_full_numbers span.paginate_active {
	background-color: #E1F1FF; 
	color: #000 !important;
	font-weight: bold;
	cursor: default;
}

.pagination .first{
background-color: #fff !important;
	color: #fff;
	border: 0px !important;
	cursor: default;
	background-position:0px 0px;
	background-image:url('/ConnectedSolutions/images/img_pagination_a.png') !important; background-repeat:no-repeat;
}

.pagination .last {
background-color: #fff !important;
	color: #fff;
	border: 0px !important;
	cursor: default;
	background-position:0px -27px !important;
	background-image:url('/ConnectedSolutions/images/img_pagination_a.png') !important; background-repeat:no-repeat;
}
.pagination .previous {
background-color: #fff !important;
	color: #fff;
	border: 0px !important;
	cursor: default;
	background-position:0px -82px !important;
	background-image:url('/ConnectedSolutions/images/img_pagination_a.png') !important; background-repeat:no-repeat;
}
.pagination .next {
background-color: #fff !important;
	color: #fff;
	border: 0px !important;
	cursor: default;
	background-position:0px -55px !important;
	background-image:url('/ConnectedSolutions/images/img_pagination_a.png') !important; background-repeat:no-repeat;
}

.pagination .deactive{
	background-image:url('/ConnectedSolutions/images/img_pagination_r.png')  !important; background-repeat:no-repeat!important;cursor: default !important;
}

/*====================Rating================================*/
.RatingAverage {LEFT: 0px; POSITION: relative; TOP: 0px; HEIGHT: 100%; BACKGROUND-COLOR: #f62929}
.RatingColor {LEFT: 0px; POSITION: relative; TOP: 0px; HEIGHT: 100%; BACKGROUND-COLOR: #f4c239}
.Star, .starLoading, .showTotal {LEFT: 0px; POSITION: relative;}
.ratingInfoDisplay {DISPLAY: none; Z-INDEX: 9999; WIDTH: 55px;  POSITION: absolute; HEIGHT: 19px; TEXT-ALIGN: center}
.ratingBubbleContent{background:url(../images/img_dropdownbg.jpg) repeat-x;border:1px solid #BEBEBE;margin:0px auto;padding:2px;}


/*====================Tree View================================*/


.treeview, .treeview ul { 
	padding: 0;
	margin: 0;
	list-style: none; 
}

.treeview ul {
	margin-top: 4px;cursor: pointer;
}

.treeview .hitarea {
	background: url(../images/treeview-default.gif) -64px -25px no-repeat;
	height: 16px;
	width: 16px;
	margin-left: -16px;
	float: left;
	cursor: pointer;
}
/* fix for IE6 */
.hitarea {
	display: inline;
	float:none;
}

.treeview li { 
	margin: 0;
	padding: 3px 0pt 3px 16px;
}

.treeview a.selected {
	background-color: #eee;
}

#treecontrol { margin: 1em 0; display: none; }

.treeview .hover { color: red; cursor: pointer; }

.treeview li { background: url(../images/treeview-default-line.gif) 0 0 no-repeat; }
.treeview li.collapsable, .treeview li.expandable { background-position: 0 -176px; }

.treeview .expandable-hitarea { background-position: -80px -3px; }

.treeview li.last { background-position: 0 -1766px }
.treeview li.lastCollapsable, .treeview li.lastExpandable { background-image: url(../images/treeview-default.gif); }  
.treeview li.lastCollapsable { background-position: 0 -111px }
.treeview li.lastExpandable { background-position: -32px -67px }

.treeview div.lastCollapsable-hitarea, .treeview div.lastExpandable-hitarea { background-position: 0; }