/*
================================================================================
  Copyright © 2010 Infosys Technologies Limited 
  main.css <version_1.00> <release_19-Jan-11> 
  All rights Reserved. 
================================================================================

 *FileName        : main.css
 *Created Date    : 10-Jan-11
 *Version         : 1.00
 *Author          : Infosys
 *Description     : This file cointain all the required css classes and ids to be used for cummins portals.
 *********************************************************************************/


/*====================General CSS================================*/

*{margin: 0;padding: 0;font-family: 'proxima-nova',sans-serif !important;   font-weight: normal !important;  font-style: normal !important;}

html { overflow-y: scroll}

html, body {height: 100%;background-color: #FFF; line-height:20px}

table{padding:0px;border-spacing:0px;border-collapse:collapse;width:100%;font-size:1em;}

img{border: none; vertical-align:top;}

br{clear:both;}

.fontbold{font-weight:bold;}

.clearStyle{width: 100%;clear: both;line-height: 0px;font-size: 0px;}

.alignTop{vertical-align:top;}

.displayNone{ display:none;}

.textUl { padding: 0 0 0 0; margin: 0px; border: 0; list-style-type:none !important; }

ul.normalList{list-style-type: disc;list-style-image: url(../images/img_ico_bullet.gif);margin:  6px 0 10px 30px;padding: 0px;}

#middleBOX ul img{margin: 0px;padding:0px;}

ul.normalList li{padding:0 0 6px 4px; margin:0 0 0 8px; line-height:20px}

ul.normalList-short{list-style-type: disc;list-style-image: url(../images/img_ico_bullet.gif);margin:  6px 0 10px 30px;padding: 0px;}

ul.normalList-short li{padding:0 0 6px 4px; margin:0 0 0 -4px; line-height:15px}

ol.normalList{margin:  0px 0px 0px 15px;padding: 0px;}

#middleBOX ul img{margin: 0px;padding:0px;}

ol.normalList li{padding:0 0 6px 4px; margin:0 0 0 8px; line-height:15px}

.showLoading{background:url("../images/processing_circle.gif") no-repeat center center transparent  !important; min-height:100%;}

.pointer{cursor:pointer; }

hr{background-color:#CCCCCC;color:#CCCCCC;height:1px;border:0 none;}

.decorationNone{ text-decoration:none;}

.hideControl {position: relative;text-align: right;filter: alpha(opacity=00); opacity: 0.0; -moz-opacity:0.0;cursor:pointer  !important; min-height:23px}

.shadow{background: url(../images/impgDivShadow.png) bottom right no-repeat;padding: 0 6px 6px 0; }

.imageDisplay {padding: 4px; border:0;
	background-color:#cdcccd; margin:0px; margin-right:15px}
/*====================Page Control================================*/

#loading {width: 200px;height: 80px;position: absolute;left: 50%;top: 50%;margin-top: -80px;margin-left: -100px;text-align: center; z-index:10;
	border:1px solid #D9D9D9;background-color:#fff;	padding-top: 12px;padding-right: 12px;padding-bottom: 12px;padding-left: 12px; font-size:0.7512em;}

.siteDiv {background-color: #4b4747;width: 100%;min-height:100%;position:relative; display:table;text-align:center;}
.pageDiv{width:1001px;background:#fff;padding:0px;margin-left: auto;margin-right: auto;min-height:100%;min-width:1001px;display: table; text-align:left;}

/*==================== Header Control ================================*/

#headerHolder {
	width:100%;
	background:#000;
	padding:0px;
	margin-left: auto; 
	margin-right: auto;
	display:table;
	min-height:137px;
}

#headerHolder-thin {
	width:100%;
	background:#000;
	padding:0px;
	margin-left: auto; 
	margin-right: auto;
	display:table;
	min-height:85px;
}

.topLinkDiv{
	text-align:right;
	font-size:0.75em;
	color:#fff;
	text-align:right;
	padding:0 15px 0 0;
	clear:both;
	background-color:#000;
	height:27px;
	line-height:27px;
	border:#7C7C7C solid 1px;
	border-top-width:0px;
}

.topLinkDiv .headerDevider{
	padding:0 7px 0 7px;
	width:1px; 
	height:10px; 
	color:#7E7E7E;
}

.topLinkDiv A {
	color: #fff; text-decoration:none
}
.topLinkDiv A:active,hover,link,visited {
	color: #fff; 
	text-decoration: none;
}

.topLinkDiv-thin{
	position:relative;
	text-align:right;
	font-size:0.75em;
	color:#fff;
	text-align:right;
	padding:0px 15px 0 0;
	clear:both;
	background-color:#000;
	height:27px;
	line-height:27px;
	border-bottom:#fda8a8 solid 1px;
	border-top-width:0px;
	margin:0 0 0 840px;
	top:-31px;
	z-index:2;
}

.topLinkDiv-thin .headerDevider{
	padding:0 7px 0 7px;
	width:1px; 
	height:10px; 
	color:#7E7E7E;
}

.topLinkDiv-thin A {
	color: #fff; text-decoration:none
}
.topLinkDiv-thin A:active,hover,link,visited {
	color: #fff; 
	text-decoration: none;
}

#toplinkswoop-thin{
	width:160px;
	height:25px;
	float:right;
	background: url('../images/utility_swoop.png') no-repeat right top;
	margin:-27px 161px 0 0;
	position:relative;
}

#headerDiv{
	width:100%;
	height:110px;
	background-color:#EE2E24;
	background-image:url('../images/img_header-bg.gif');
	background-repeat:repeat-x;
}


#headerDiv-thin{
	width:100%;
	height:76px;
	background-color:#EE2E24;
	background-image:url('../images/img_header-bg.gif');
	background-repeat:repeat-x;
}

#globeDiv{
	width:275px;
	height:85px;
	float:right;
	background: url('../images/img_globe.png') no-repeat right top;
}

#globeDiv-thin{
	width:275px;
	height:82px;
	float:right;
	background: url('../images/img_globe.png') no-repeat right top;
	z-index:-1;
}

#headerMescHolder{
	float:left;
 	position:relative; 
	top:-25px; 
	clear:both; 
	width:100%;
}

#headerMescHolder-thin{
	float:left;
 	position:relative; 
	top:-59px; 
	clear:both; 
	width:100%;
	margin-bottom:-50px;
}

#logoDiv{
	height:77px;
	width:81px;
	vertical-align:middle; 
	float:left;
	background-image:url('../images/img_logo.png');
	background-repeat:no-repeat;
}

#logoDiv-thin{
	height:77px;
	width:81px;
	vertical-align:middle; 
	float:left;
	background-image:url('../images/img_logo_thin.png');
	background-repeat:no-repeat;
}

#titleDiv{
	float:left;
	padding-left:32px;
	height:100%;
	top:30px;
	line-height:2.2656em; 
	color:#fff; 
	font-size:1.5024em; 
	font-weight:bold; vertical-align:top;
}
#searchDiv{
	float:right;
	padding-top:30px;
	padding-right:15px; 
	text-align:right; 
	white-space:nowrap;
}

#searchDiv-thin{
	float:right;
	padding-top:43px;
	padding-right:15px; 
	text-align:right; 
	white-space:nowrap;
}

#utility-thin{
	float:right;
	padding-top:0;
	padding-right:15px; 
	text-align:right; 
	white-space:nowrap;
}

#navDiv{
	float:left;
	position:relative;
	z-index:4;
	top:85px; left:0;
	width:100%;
	text-align:left; 
	vertical-align:bottom;
	clear:both;
	background: url('../images/img_globe_tab.png') no-repeat right bottom; min-height:25px;
}

#navDiv-thin{
	float:left;
	position:relative;
	z-index:4;
	top:60px; left:0;
	width:100%;
	text-align:left; 
	vertical-align:bottom;
	clear:both;
}

/*====================Top Tab Navigation Control================================*/

#linkWrapperLeft{height:25px; float:left; padding:0 0 0 15px ; white-space:nowrap;}
#linkWrapperRight{
height:25px; float:right;  padding:0 15px 0 0 ;width:70px; text-align:right
}

.menuLevel1 { padding:0 0 0 0; margin:0; border:0; list-style-type:none !important; height:25px; }
.menuLevel1 li { float: left; background: url(../images/tab_left_off.gif) left top no-repeat;margin:0; height:25px; border-bottom: 0px;}
.menuLevel1 a,.menuLevel1 a:hover{ display: block; background: url(../images/tab_right_off.gif) right top no-repeat; color: #fff; text-decoration: none; margin:0 0 0 3px; padding: 0px 18px 0 15px; line-height:25px; }
.menuLevel1 .selectedTab { float: left; background: url(../images/tab_left_on.gif) left top no-repeat;margin:0; height:25px; border-bottom: 0px;}
.menuLevel1 .selectedTab a{ display: block; background: url(../images/tab_right_on.gif) right top no-repeat; color: #000; text-decoration: none; margin:0 0 0 3px; padding: 0px 18px 0 15px; line-height:25px; }

/*====================Second Level Navigation Control================================*/

.menuLevel2{ 
	width:100%; 
	float:left;
	line-height:normal; 
	font-weight:bold; 
	vertical-align:middle; height:25px;
	background: url('../images/img_navLvl2_bg.gif');

}

.menuLevel2 ul.SubMenu{
	margin:0;
	padding:0px 10px 0 15px;
	list-style:none;
	height:25px;
}

.menuLevel2 ul li{
	display:inline;
	margin:0;
	padding:0;	
}

.menuLevel2 ul li A{
	display:inline;
	margin:0; 
	padding-left:15px;	
	padding-right:15px; 
	margin-top:6px; 
	float:left; line-height:1.252em; 
	color:#000; 
	border-right:#B6B6B6 1px solid; 
	text-decoration:none;	
}

.menuLevel2 ul li A:hover {
	color:#CC0000; 
	text-decoration:none;
}

.menuLevel2 A.lastLink{
	border-right:0px; 
}

.menuLevel2 A.selectedLink{
	color:#DA0000;
}

.navSpacer{
	padding:0 5px 0 5px;
	color: #555;
}
/*====================Left Navigation Control================================*/
.navLeftMenu a{ color:#000; text-decoration:none;
}
.navLeftMenuBg{
background: url('../images/imp_LeftNavBg.jpg') repeat-x bottom; 
/*min-height:expression(200px);*/
min-height: 300px; float:none; 
}
.navLeftMenuHeader{ 
min-height:28px; padding:0 0px 0 12px; line-height:28px; background-color:#323232; border-bottom:#FFF 1px solid; vertical-align:top;
}

/*====================Level 1 ==================*/
.navLeftMenuOpenLevel1{ 
background:url(../images/navArrowDown.png) no-repeat center left; background-position: 12px 10px;
min-height:28px; padding:0 12px 0 24px; line-height:28px; background-color:#afafaf; border-bottom:#FFF 1px solid; cursor:pointer;
}

.navLeftMenuCloseLevel1{ 
background:url(../images/navArrowRight.png) no-repeat center left; background-position: 12px 10px;background-color:#838282;
min-height:28px; padding:0 12px 0 24px; line-height:28px; border-bottom:#FFF 1px solid; cursor:pointer;
}
.navLeftMenuLinkLevel1 a{ 

background-color:#838282; border-bottom:#FFF 1px solid; 
line-height: 28px; 	float:none; height: 28px; padding: 0 12px 0 24px;
display: block; 
}

.navLeftMenuLinkLevel1Sel{background-color:#ooo; 
	
}
.navLeftMenuLinkLevel1 .hasLink{
background:url(../images/navArrowLink.png) no-repeat center left; background-position: 12px 10px; background-color:#838282;
}
.navLeftMenuLevel1Body a{
background:url(../images/navArrowLink.png) no-repeat center left; background-position: 24px 10px;
background-color:#efefef; border-bottom:#FFF 1px solid; 
line-height: 28px; 	float:none; height: 28px; padding: 0 12px 0 36px;
display: block; 
}
.navLeftMenuLevel1Body a.rowSelected{background-color:#ee2e24; color:#FFF}
/*====================Level 2 ==================*/

.navLeftMenuOpenLevel2{ 
background:url(../images/navArrowDown.png) no-repeat center left; background-position: 24px 10px;
min-height:28px; padding:0 12px 0 36px; line-height:28px; background-color:#a29e9e; border-bottom:#FFF 1px solid; cursor:pointer;
}

.navLeftMenuCloseLevel2{ 
background:url(../images/navArrowRight.png) no-repeat center left; background-position: 24px 10px;background-color:#a29e9e;
min-height:28px; padding:0 12px 0 36px; line-height:28px; border-bottom:#FFF 1px solid; cursor:pointer;
}

.navLeftMenuLinkLevel2{ 
background:url(../images/navArrowLink.png) no-repeat center left; background-position: 12px 10px;
min-height:28px; padding:0 12px 0 24px; line-height:28px; background-color:#838282; border-bottom:#FFF 1px solid; cursor:pointer;
}

.navLeftMenuLevel2Body a{
background:url(../images/navArrowLink.png) no-repeat center left; background-position: 36px 10px;
background-color:#bbbaba; border-bottom:#FFF 1px solid; 
line-height: 28px; 	float:none; height: 28px; padding: 0 12px 0 48px;
display: block; 
}

.navLeftMenuLevel2Body a.rowSelected{background-color:#eaeaea;}
/*====================Form Steps Control================================*/
.stepsControl{
	height:42px; width:100%;
	background: url('../images/img_stepsCentre.png');
}

.stepsLeft{
	background-image:url("../images/img_stepsLeft.jpg");
	background-repeat:no-repeat;
	width:7px;
	padding-left:7px;
}

.stepsRight{
	background-image:url("../images/img_stepsRight.jpg");
	background-repeat:no-repeat;
	width:7px;
	
}
.stepsDone{
	background:url("../images/img_stepsDoneArrow.jpg") no-repeat center center;
	width:30px;
}

.stepsDoneLeft{
	background:url("../images/img_stepsDoneLeft.jpg") no-repeat center center;
	width:6px;
}
.stepsDoneCenter {
	background:url("../images/img_stepsDoneCenter.jpg") repeat-x ;
	cursor:pointer; 
	color:#fff; 
	white-space:nowrap; 
	padding: 0 15px 0 15px; width:90px;
	text-align:center;
}
.stepsDoneRight{
	background:url("../images/img_stepsDoneRight.jpg") no-repeat center center;
	width:6px;
}


.stepsCurrentLeft{
	background:url("../images/img_stepsCurrentLeft.jpg") no-repeat center center;
	width:6px;
}
.stepsCurrentCenter {
	background:url("../images/img_stepsCurrentCenter.jpg") repeat-x ;
	cursor:pointer; 
	color:#fff; 
	text-align:center;
	white-space:nowrap; 
	padding: 0 15px 0 15px; width:90px;
}
.stepsCurrentRight{
	background:url("../images/img_stepsCurrentRight.jpg") no-repeat center center;
	width:6px;
}


.stepsToDoLeft{
	background:url("../images/img_stepsToDoLeft.jpg") no-repeat center center;
	width:6px;
}
.stepsToDoCenter {
	background:url("../images/img_stepsToDoCenter.jpg") repeat-x ;
	cursor:pointer; 
	color:#000; 
	text-align:center;
	white-space:nowrap; 
	padding: 0 15px 0 15px; width:90px;
}
.stepsToDoRight{
	background:url("../images/img_stepsToDoRight.jpg") no-repeat center center;
	width:6px;
}

.stepsCurrent{
	background:url("../images/img_stepsCurrentArrow.jpg") no-repeat center center;
	width:30px;
}



/*==Top Gradient==*/

#tabGradient{
	position: relative;
	width: 100%;
	height: 9px;
	background:#FFF repeat-x url('../images/img_tab_gar1.gif') top;
	clear: both;
	float:left;overflow:hidden;
}


/*====================Body Content ================================*/

.contentDiv {
	width:100%;
	padding-top:0px;
	margin:0 auto;
	background: #FFF ; 
	clear: both;
}


.mainDiv{
 height:100%;
	margin:0px 15px 15px 15px;
}

#breadcrumb{
	height:25px;
	text-align:left;
	vertical-align:top; 
	float:none; font-size:0.75em; line-height:25px; color:#000;
}

#breadcrumb .locDef{
	color:#8F8F8F;
}

#breadcrumb a{
	color:#000; text-decoration:underline
}
	
.pageHeader{

}

#END{
	position: relative;
	width: 100%;
	height: 1px;
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #CCCCCC;
	clear: both; margin-top:5px; margin-bottom:5px;
	overflow:hidden;
}

#dottedDevider{
	position: relative;
	width: 100%;
	height: 1px;
	border-top-width: 1px;
	border-top-style: dotted;
	border-top-color: #CCCCCC;
	clear: both; margin-top:5px; margin-bottom:5px;overflow:hidden;
}
/*====================Footer Content ================================*/

#footer {
   width:100%;
   background:#313131;
}
#footerContent{
	min-height:100px;
	padding-top: 10px;
	padding-bottom: 10px;
	padding-left: 100px;
	padding-right: 100px;
	position: relative;
}


#footerColumns {
	margin: 0;
	padding: 0;
	
}

#footerColumns li
{	margin: 0;
	padding: 0;
	list-style: none;
	float: left; 
	color: #fff;
	font-weight:bold; line-height:20px; 
}

#footerColumn1
{	margin: 0;
	padding: 0;
	list-style: none;
	float: left; 
	width:29%;
	color: #fff;
	font-weight:bold; line-height:20px; 
}

#footerColumn2
{	margin: 0;
	padding: 0;
	list-style: none;
	float: left; 
	width:29%;
	color: #fff;
	font-weight:bold; line-height:20px; 
}

#footerColumn3
{	margin: 0;
	padding: 0;
	list-style: none;
	float: left; 
	width:31%;
	color: #fff;
	font-weight:bold; line-height:20px; 
}

#footerColumn4
{	margin: 0;
	padding: 0;
	list-style: none;
	float: left; 
	width:10%;
	color: #fff;
	font-weight:bold; line-height:20px; 
}

#footerColumns li a
{	display: block;
	margin: 0 1px 0 0;
	width: 100%;
	color: #FFF;
	text-align:left; 
	font-weight:normal;
}

.copyrightDiv{
	width:100%;
	background-color:#000;
	color:#fff;	
	height:25px;
	line-height:20px;
	float: left;

}

.copyrightDiv .leftCopyRightLinks {
	line-height: 25px;
	float: left;
	padding-left: 15px; color:#C0C0C0; white-space:nowrap;
}
.copyrightDiv .rightCopyRightLinks {
	line-height: 25px; 
	padding-right: 15px; 
	float: right; 
	white-space:nowrap;
}

.copyrightDiv .rightCopyRightLinks a {
	color:#fff; text-decoration:none;
}
.copyrightDiv .footerDevider{
	padding:0 7px 0 7px;
	color: #555;
}


/*====================Tables ================================*/











/* DataTable */


/*====================Form Elements ================================*/




/* Header Search content */
input.txtBoxSearch{
	border:0px solid #CCC;
	height:27px;
	vertical-align:middle;
	line-height:27px;
	width:210px;
	background: url('../images/form_search_bg.gif');
	margin-top:3px;
	padding-left:5px;
}
input.buttonSearch{
	background-image:url('../images/btn_search.gif')  ;
	width:26px;
	height:27px;	
	border:0px #fff;
	vertical-align:middle;
	margin-top:3px; cursor:pointer;
}

label.error, .error { margin:0; color:#FF0000; font-size:12px }
input.error { border: 1px solid red; }

/* Holds Browse Buttons */


#inputFile{ margin:0px; width:203px; background:url(../images/icon_holder.png) no-repeat 100% -537px !important; height:23px; vertical-align:top; }
#inputFile #fdFileUpload { filter: alpha(opacity=00); opacity: 0.0; -moz-opacity:0.0;cursor:pointer  !important; }
#fakeInputFile{ margin-top: -22px;cursor:pointer  !important; }
#fakeInputFile input{width: 150px;}
.buttonUl { padding: 0 0 0 0; margin: 0px; border: 0; list-style-type:none !important; height:22px; }
.buttonUl .SingleBtn,.SingleBtn{ border:0px; float:none; background: url(../images/img_btnlc_active.png) left top no-repeat; margin:0 3px 0 0; padding: 0 0 0 3px; height:22px;}
.buttonUl li { border:0px; float:left; background: url(../images/img_btnlc_active.png) left top no-repeat; margin:0 3px 0 0; padding: 0 0 0 3px; height:22px;}
.buttonUl input.button{border:0px; margin:0px; border-collapse:collapse;vertical-align:middle;font-weight:bold;	
background:transparent;cursor:pointer; height:22px; line-height:22px;background: url(../images/img_btnrc_active.png) right top no-repeat;display: block; padding: 0 6px 0 3px; color:#fff;}
.buttonUl .disabled { border:0px;  background: url(../images/img_btnlc_disabled.png) left top no-repeat; margin:0 3px 0 0; padding: 0 0 0 3px; height:22px;}
.buttonUl input.button[disabled=true], .buttonUl input.button[disabled=disabled], .disabledBtn {border:0px; margin:0px; border-collapse:collapse;vertical-align:middle;font-weight:bold;background:transparent;cursor:auto; height:22px; line-height:22px;background: url(../images/img_btnrc_disabled.png) right top no-repeat;display: block; color:#666666;}


/* Holds Buttons */
.buttonHolder{
	float:none; border:0px; border-collapse:collapse;
	vertical-align:middle; text-align:right;
	background:transparent; margin-top:5px; margin-bottom:5px;
}

/* Holds Buttons Cols */
.containerForm1Cols{clear:both; float:none; width:100%; border:0px; }
.containerForm2Cols{float:left; width:49%; border:0px; }
.containerForm3Cols{float:left; width:32.2%; border:0px;}

.requiredFild{padding:0 0px 0 4px;width:1px;color:#cc0000; vertical-align:top;}
.formtable DT{ clear:both; width:45%;color:#000;text-align:right;font-weight:bold;float:left;margin: 0 0 8px 5px; vertical-align:top;} 
.formtable DD{ color:#000; float:left;width:50%; margin: 0 0 8px 5px; vertical-align:top; } 
.containerForm1Cols .formtable DT{ width:22%;}
.containerForm1Cols .formtable DD{ width:75%;}
.checkBoxDisplay { height:150px; overflow:auto;border:1px solid #7F9DB9; line-height:25px; background:#fff; padding:5px;}
.checkBoxHolder {width:208px;}

table.formtable { border-collapse:collapse;	border:0px;}
table.formtable td {border: 0px; padding-bottom:3px;padding-top:3px; color:#000; vertical-align:middle;}
table.formtable .FormLbl {text-align:right;font-weight:bold; padding-right: 4px; vertical-align:middle;}
table.formtable .FormLbl2 {text-align:right;font-weight:bold; padding-right: 4px; vertical-align:top;}








input.buttonS, input.buttonM, input.buttonL, input.buttonXL{	
	height:22px;
	color:#fff;
	border:0px #fff;
	vertical-align:top;
	font-size:12px;
	font-weight:bold;
	background:transparent;
	cursor : pointer;	
}

input.buttonS[disabled=true], input.buttonM[disabled=true], input.buttonL[disabled=true], input.buttonXL[disabled=true]{	
	color:#f0f0f0;
}

input.buttonS{
	background-image:url('../images/btn_wS.gif');
	width:63px;
}
input.buttonS[disabled=true], input.buttonSDisabled {
	background-image:url('../images/btn_wS_disabled.gif');
	width:63px; color:#666666;
}

input.buttonM{
	background-image:url('../images/btn_wM.gif');
	width:69px;
}
input.buttonM[disabled=true]{
	background-image:url('../images/btn_wM_disabled.gif');
	width:69px;color:#666666;
}
input.buttonL{
	background-image:url('../images/btn_wL.gif');
	width:95px;
}
input.buttonL[disabled=true]{
	background-image:url('../images/btn_wL_disabled.gif');
	width:95px;color:#666666;
}
input.buttonXL{
	background-image:url('../images/btn_wXL.gif');
	width:160px;
}
input.buttonXL[disabled=true]{
	background-image:url('../images/btn_wXL_disabled.gif');
	width:160px;color:#666666;
}

.textbox{border:1px solid #7F9DB9;background-color:#fff;	text-align: left;padding-left: 3px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px; width:200px;resize: none;}

.phone{border:1px solid #7F9DB9;background-color:#fff;	text-align: left;padding-left: 3px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px; width:100px;resize: none;}

.datepickertextbox{	border:1px solid #7F9DB9;background-color:#fff;margin-right: 5px;padding-left: 3px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px;text-align: left; width:70px;}

.numberTextbox{border:1px solid #7F9DB9;background-color:#fff;text-align: left;padding-left: 3px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px;}

.stringTextbox{border:1px solid #7F9DB9;background-color:#fff;text-align: left;padding-left: 3px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px;}

.textboxSearchContent{	border:1px solid #7F9DB9;background-color:#fff;padding-left: 6px;padding-right: 3px;padding-top: 1px;padding-bottom: 1px; line-height:18px; height:17px;width:200px;}

.textbox[disabled="disabled"], .textbox[disabled="true"], .textbox[readonly="true"], .textboxDisabled{border:1px solid #CED7DF;background-color:#F5F5F5;}

.formFocused{border:1px solid #173554; text-align:left !important}

.formError{border:1px solid #CC6600;}

input[type="checkbox"], input[type="radio"]{ background: transparent; border: 0; margin:0;vertical-align:middle;} 

input[type=checkboxlist] {	padding-right: 35px;padding-left: 15px;margin-left: 20px;vertical-align:middle;}

.selectBox{border:1px solid #7F9DB9;background-color:#fff; width:210px;resize: none; line-height:17px}


/*====================Font Classes ================================*/
.t10b{	font-size:0.626em;	color: #000; }
.t11b{	font-size:0.6886em;	color: #000; }
.t12b{	font-size:0.7512em;	color: #000; }
.t13b{	font-size:0.812em;	color: #000; }
.t14b{	font-size:0.8764em;	color: #000; }
.t15b{	font-size:0.939em;	color: #000; }
.t16b{	font-size:1.0016em;	color: #000; }
.t17b{	font-size:1.0642em;	color: #000; }
.t18b{	font-size:1.1268em;	color: #000; }
.t20b{	font-size:1.25em;	color: #000; }

.t10w{	font-size:0.626em;	color: #fff !important; }
.t11w{	font-size:0.6886em;	color: #fff !important; }
.t12w{	font-size:0.7512em;	color: #fff !important; }
.t14w{	font-size:0.8764em;	color: #fff !important; }
.t15w{	font-size:0.939em;	color: #fff; }
.t16w{	font-size:1.0016em;	color: #fff; }
.t17w{	font-size:1.0642em;	color: #fff; }
.t18w{	font-size:1.1268em;	color: #fff; }
.t20w{	font-size:1.25em;	color: #fff; }

.t11r{	font-size:0.6886em;	color: #cc0000 !important; }
.t12r{	font-size:0.7512em;	color: #cc0000 !important; }
.t13r{	font-size:0.8138em;	color: #cc0000 !important; }
.t14r{	font-size:0.8764em;	color: #cc0000 !important; }
.t15r{	font-size:0.939em;	color: #cc0000 !important; }
.t16r{	font-size:1.0016em;	color: #cc0000 !important; }
.t17r{	font-size:1.0642em;	color: #cc0000 !important; }
.t18r{	font-size:1.1268em;	color: #cc0000 !important; }

.t9b-b{	font-size:0.563em;	color: #000; 	font-weight:bold;	}

.t12g{	font-size:0.7512em;	color: #b3b1b1; }

.t10cg-b{	font-size:0.625em;	color: #525252;		font-weight:bold;	}
.t14cg{	font-size:0.8764em;	color: #525252; 	font-style:italic;	margin:0 0 7px;}

.linkb{ color:#000; text-decoration:none}

.blackTxt {	color: #000000; }
.gratTxt {	color: #666666; }
.chargratTxt {	color: #525252; }
.redTxt {	color: #cc0000; }
.fullGray{background-color:#d3cfcf}


/*====================Icons Classes ================================*/
.iconHolder { padding: 0 0 0 0; margin: 0px; border: 0; list-style-type:none !important; height:22px; }
.iconHolder li { border:0px; float:left;  margin:0 3px 0 0; padding: 0 0 0 3px; height:22px;}

.downloadHolder { padding: 0; margin: 0px; border: 0; list-style-type:none !important; height:22px; }
.downloadHolder li { border:0px; float:none;  margin:5px 30px 0 30px; padding: 0 0 0 3px; height:22px;}

.print { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px 0px !important;
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left; cursor:pointer;
}

.mail { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -709px !important;
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
	cursor:pointer;
}


.feedback { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -733px !important;
	padding:0 0px 0 5px; 
	width:16px; 
	height:19px; 
	float:left;
	cursor:pointer;
}

.excel { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -24px !important;
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}

.ppt { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -50px !important;
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}

.pdf { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -75px !important; 
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}

.visio { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -797px !important; 
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}
.doc { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -100px !important; 
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}

.zip { 
	text-decoration:none;  cursor:pointer;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -760px !important; 
	padding:0 0px 0 5px; 
	width:16px; 
	height:16px; 
	float:left;
}
.alertImg { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -133px !important; 
	padding:0 0px 0 5px; 
	width:32px; 
	height:32px; 
	float:left; 
}

.help { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -278px !important; 
	width:16px; 
	height:16px; 
	float:none; padding:8px;
}




.save { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -508px !important; 
	width:16px; 
	height:16px; 
	float:left;
}

.errorImg { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -247px !important; 
	padding:0 0px 0 5px; 
	width:32px; 
	height:32px; 
	float:left; 
}

.confirmationImg { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -214px !important; 
	padding:0 0px 0 5px; 
	width:32px; 
	height:32px; 
	float:left; 
}

.infoImg { 
	text-decoration:none; 
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -174px !important; 
	padding:0 0px 0 5px; 
	width:32px; 
	height:32px; 
	float:left; 
}


.navigationShowDown {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -429px !important;
	float:left; padding:0; cursor:pointer;
	width:19px; 
	height:19px; margin: 6px 10px 0 0;
}

.navigationShowUp {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -404px !important;
	float:left; padding:0; cursor:pointer;
	width:19px; 
	height:19px; margin: 6px 10px 0 0;
}

.navigationShowRight {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -480px !important;
	float:left; padding:0; cursor:pointer;
	width:19px; 
	height:19px; margin: 6px 10px 0 0;
}

.navigationShowLeft {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -454px !important;
	float:left; padding:0; cursor:pointer;
	width:19px; 
	height:19px; margin: 6px 10px 0 0;
}

.modalClose {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -374px !important; 
	float:left; padding:0; cursor:pointer;
	width:21px; 
	height:21px; 
}

.filterRight {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -312px !important; 
	float:right; padding:0; cursor:pointer;
	width:21px; 
	height:21px; margin: 5px 10px 0 10px;
}

.filterDown {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -342px !important; 
	float:right; padding:0; cursor:pointer;
	width:21px; 
	height:21px; margin: 5px 10px 0 10px;
}

.borwse {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -536px !important; 
	float:right; padding:0; cursor:pointer;
	width:28px; 
	height:28px; margin: 5px 10px 0 10px;
}


.edit {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -664px !important; 
	float:right; padding:0; cursor:pointer;
	width:18px; 
	height:18px; margin:  0 2px 0 2px;
}

.copy {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -574px !important; 
	float:right; padding:0; cursor:pointer;
	width:18px; 
	height:18px; margin:  0 2px 0 2px;
}
.clock {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -633px !important; 
	float:right; padding:0; cursor:pointer;
	width:18px; 
	height:18px; margin: 0 2px 0 2px;
}

.cross {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat center top; 
	background-position:0px -603px !important; 
	float:right; padding:0; cursor:pointer;
	width:18px; 
	height:18px; margin:  0 2px 0 2px;
}

.view {
	text-decoration:none;
	background:url(../images/icon_holder.png) no-repeat top; 
	background-position:0px -688px !important; 
	float:right; padding:0; cursor:pointer;
	width:18px; 
	height:18px; margin: 0 2px 0 2px;
}


.previous {
	border: 0px !important; margin:5px;
	cursor: pointer; 
	background-position:0px -82px !important; 
	background-image:url('../images/img_pagination_a.png'); background-repeat:no-repeat;
}
.next {border: 0px !important;cursor: pointer;margin:5px;background-position:0px -55px !important;background-image:url('../images/img_pagination_a.png'); background-repeat:no-repeat;}
.previousAll{background-position:0px 0px !important;}
.nextAll{background-position:0px -25px !important;}

.hideMenu{border: 0px !important;cursor: pointer; width:18px; height:18px; margin:5px;background-position:0px 0px !important;background-image:url('../images/img_pagination_a.png'); background-repeat:no-repeat;}

.showMenu{border: 0px !important;cursor: pointer; width:18px; height:18px; margin:5px;background-position:0px -27px !important;background-image:url('../images/img_pagination_a.png'); background-repeat:no-repeat;}


/*====================Container Classes ================================*/

.contentExpander{ 
	float:none; 
	height:5px;
	overflow:hidden !important;
}

.horizontalExpander{ 
	width:1px; padding: 0 0 0 15px;
	height:5px;
}
.containerGrayBorder{
	border:1px solid #D9D9D9;
	background-color:#fff;
	text-align:left;
	padding: 12px 12px 12px 12px;zoom: 1
}

.containerGrayBorderFill{
	/*border:1px solid #D9D9D9;
	border-bottom:0px;
	border-left:0px;
	border-top:0px;
	background:#F0F0F0; */
	text-align:left;
	padding: 0px 12px 0px 0px;zoom: 1

}

.formbg {border:1px solid #D9D9D9;

	background:#F0F0F0;text-align:left;
	padding:12px;zoom: 1}

.formbg-contact {border:1px solid #D9D9D9;

	background:#F0F0F0;text-align:left;
	padding:12px;zoom: 1}

.formbg-profile {border:1px solid #D9D9D9;

	background:#F0F0F0;text-align:left;
	width:250px;
	margin:0 0 0 171px;
	padding:12px;zoom: 1}

.formbg-file {border:1px solid #D9D9D9;

	background:#F0F0F0;text-align:left;
	padding:8px 14px 0;zoom: 1}
	
.containerGrayBorderFillRight{
	/*border:1px solid #D9D9D9;
	border-bottom:0px;
	border-left:0px;
	border-top:0px;
	background:#F0F0F0; */
	text-align:left;
	zoom: 1; 

}

.containerThumbnailHolder{
	padding-top: 12px;
	padding-right: 12px;
	padding-bottom: 12px;
	padding-left: 12px; 
	border:1px solid #D9D9D9;
	background-color:#F0F0F0; margin:10px;text-decoration:none; vertical-align:top;
}
.containerThumbnailHolder img{
	cursor:pointer; 
}
.containerThumbnailHolder .imgholder{
	background-color:#666666;
	border: 0; text-align:center; 
	padding-bottom: 5px;
	padding-top: 5px;

}





.containerThumbnailLink  {
	border:1px solid #BDBABA;background-color:#4B4747;text-decoration:none; padding: 5px 5px 5px 5px ;
	text-align:center; margin:0 0 0 0 ; background: right center url('../images/imgViewBtn.png') #4B4747;
}


.containerTable{
	height:100%; 
	min-height:100%;

}

.containerLeftNav {
	width:225px;
	vertical-align:top; 
	padding-right:15px;
}

.containerMiddleNav {min-height:100%;padding-top:5px;vertical-align:top; display:table-cell;}

.containerRightNav {width:200px;vertical-align:top; padding-left:15px;}

.containerRightNavGrayBorder{border:1px solid #D9D9D9;background-color:#fff;text-align:left;padding: 5px 10px 5px 10px;}

.containerTopBar{ min-height: 32px; line-height:32px;background: url('../images/img_topnav_bg.jpg');	border:1px solid #DCDBDB; border-bottom-width:0px; padding: 0 0 0 10px;}

.cointainerMessage{	text-decoration:none; padding:10px  0 0px 0 ;  text-align:left;}

.containerRightFloat{float:right; }
.containerLeftFloat{float:left;}

.containerNavShowHide{float:right; }

.borderbelow{border-bottom-width:1px;}

.containerFilter{background:url(../images/img_filter_bg_off.jpg) repeat-x center center; height:30px;border:1px solid #ADC658; vertical-align:middle; line-height: 30px;padding: 0 0 0 12px;}

.containerFilterContent{border:1px solid #ADC658;padding: 0 0 0 12px; border-top-width:0px;background-color:#FAFEED; text-align:left; padding-top: 12px;padding-right: 12px;padding-bottom: 12px; padding-left: 12px; }



.calloutBubble {background: url(../images/impgDivShadow.png) bottom right no-repeat;padding: 0 6px 6px 0;width:250px;position:absolute; display:none; z-index:15;}
.calloutBubbleContent{background:url(../images/img_dropdownbg.jpg) repeat-x #fff;border:1px solid #BEBEBE;margin:0px auto;padding:10px;}
.calloutBubbleMain{border-style: solid; border-width: 10px;  height:0;  width:0;  position:absolute;}
.calloutBubbleArrowBorder {	border-color: transparent #BEBEBE transparent  transparent; top:10px;left:-20px;}
.calloutBubbleArrow 	  {	border-color: transparent #E3E3E3 transparent  transparent; top:10px;left:-18px;}
.calloutBubbleClose {text-decoration:none;background:url(../images/icon_holder.png) no-repeat top; background-position:0px -374px !important; position:absolute; top:-8px;float:left; padding:0; cursor:pointer;width:21px;height:21px;} 

/*====================Column Classes ================================*/
.containerDevide2{width:49%; border:0px; margin:0px; zoom:1}
.containerDevide3{width:33.3%; border:0px; margin:0px; zoom:1}
.containerDevide4{width:25%; border:0px; margin:0px; zoom:1}
.containerDevide2-3{width:66%; border:0px; margin:0px; zoom:1}
.containerDevide2-4{width:49.8%; border:0px; margin:0px; zoom:1}
.containerDevide3-4{width:74.8%; border:0px; margin:0px; zoom:1}

/*====================Dashboard Classes ================================*/

.containerDashboardRightMargine{ margin-right:7px;}

.containerDashboardLeftMargine{ margin-left:7px;}

.containerDashboard2Cols{ float:left; width:49%; border:0px;}

.containerDashboard3Cols{ float:left; width:32.2%; border:0px;}

.containerDashboardHeader{ border-bottom:1px solid #BEBEBE; background:url(../images/imp_dashbordhead.png) repeat-x top; line-height:29px; padding: 0 0 0 12px; margin:0 1px 0 1px}

#containerDashboardTopBtn{float:right; top:0px; left:3px;}



#DashboardBtn{	margin: 0;padding: 0; }

#DashboardBtn li{float: left;list-style: none; border:0px }

#DashboardBtn li .header {	display: block;background:url(../images/imp_dashbordheadBg.png) repeat-x ;padding:0; border-right: 0px solid #BEBEBE; border-left: 1px solid #939393;}

#DashboardBtn li a {display: block;padding:0;text-decoration: none;width:30px;white-space: nowrap}

#DashboardBtn li .header:hover{background:url(../images/imp_dashbordheadBg_r.png) repeat-x ;}

#DashboardBtn li .headerOver{background:url(../images/imp_dashbordheadBg_r.png) repeat-x ;}

#DashboardBtn li .DashboardLevel2 {margin:0; padding:0; position:absolute; display:none; background:url(../images/img_dropdownbg.jpg) repeat-x #fff;float:none; border: 1px solid #AEAEAE; width:150px; z-index:10; }

#DashboardBtn li .DashboardLevel2 a{ width:138px;color: #000; padding:0 0 0 10px; border-bottom: 1px #697C00;border-bottom-style: dotted;}

#DashboardBtn li .DashboardLevel2 a:hover{color:#FF0000}

#DashboardBtn li .DashboardLevel2 .lastLink{border-bottom: 0px }

#DashboardBtn li .DashboardLevel2 .leftBottom{background:url(../images/img_dd_lb.png) no-repeat ; width: 5px; height:5px; position:relative; z-index:1; float:left; left:-1px; top:1px;}

#DashboardBtn li .DashboardLevel2 .rightBottom{background:url(../images/img_dd_rb.png) no-repeat ; width: 5px; height:5px; position:relative; z-index:1; float:right; left:1px; top:1px;}
		
.containerDashboardContent{border:0px;text-align:left; padding: 6px 6px 6px 6px ; min-height:150px;	margin:0 1px 0 1px; background:url(../images/pic_dashboardBg.jpg) repeat-x ;}

.containerDashboardt {background: url(../images/dott.gif) 0 0 repeat-x;}
.containerDashboardb {background: url(../images/dott.gif) 0 100% repeat-x}
.containerDashboardl {background: url(../images/dott.gif) 0 0 repeat-y}
.containerDashboardr {background: url(../images/dott.gif) 100% 0 repeat-y}
.containerDashboardCurvebl {background: url(../images/imgCurve_lb.gif) 0 100% no-repeat}
.containerDashboardCurvebr {background: url(../images/imgCurve_rb.gif) 100% 100% no-repeat}
.containerDashboardCurvetl {background: url(../images/imgCurve_lt.gif) 0 0 no-repeat}
.containerDashboardCurvetr {background: url(../images/imgCurve_rt.gif) 100% 0 no-repeat; padding:0px} 
.containerDashboardShadow{background: url(../images/impgDivShadow.png) bottom right no-repeat;padding: 0 6px 6px 0; }

.loginDiv {width:400px; padding:0px !important; padding-left:8px  !important; min-width:400px !important; vertical-align:top}

fieldset {
-webkit-border-radius: 8px;
-moz-border-radius: 8px;
border-radius: 8px; padding:0px 5px 12px 15px;
border: 1px solid #e5e5e5;
}
legend{ padding:0px 5px 12px 5px}

.wizardHolder ul{margin: 0;padding: 0; }
.wizardHolder li{float: left;list-style: none; padding-right:30px; border:0px; line-height:38px; min-height:35px;  background:url(../images/wizardbg.png) repeat-x center; }

.wizardHolder li .finished{background:url(../images/wizard1.png) no-repeat center; width:31px; text-align:center; cursor:pointer;}
.wizardHolder li .selected{background:url(../images/wizard2.png) no-repeat center; width:31px; text-align:center; cursor:pointer;}
.wizardHolder li .desel{background:url(../images/wizard3.png) no-repeat center; width:31px; text-align:center; cursor:pointer;}
.final {padding-right:0px !important}