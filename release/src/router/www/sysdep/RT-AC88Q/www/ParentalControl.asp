﻿<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<html xmlns:v>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta HTTP-EQUIV="Expires" CONTENT="-1">
<title id="web_title"><#Web_Title#> - <#Parental_Control#></title>
<link rel="shortcut icon" href="images/favicon.png">
<link rel="icon" href="images/favicon.png">
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="index_style.css"> 
<link rel="stylesheet" type="text/css" href="form_style.css">
<link rel="stylesheet" type="text/css" href="usp_style.css">
<link rel="stylesheet" type="text/css" href="/calendar/fullcalendar.css">
<link rel="stylesheet" type="text/css" href="/device-map/device-map.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/calendar/jquery-ui.js"></script> 
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script type="text/javascript" src="/js/httpApi.js"></script>
<style>
  #selectable .ui-selecting { background: #FECA40; }
  #selectable .ui-selected { background: #F39814; color: white; }
  #selectable .ui-unselected { background: gray; color: green; }
  #selectable .ui-unselecting { background: green; color: black; }
  #selectable { border-spacing:0px; margin-left:0px;margin-top:0px; padding: 0px; width:100%;}
  #selectable td { height: 22px; }
  
.parental_th{
	color:white;
	background:#2F3A3E;
	cursor: pointer;
	width:160px;
	height:22px;
	border-bottom:solid 1px black;
	border-right:solid 1px black;
} 
.parental_th:hover{
	background:rgb(94, 116, 124);
	cursor: pointer;
}

.checked{
	background-color:#9CB2BA;
	width:82px;
	border-bottom:solid 1px black;
	border-right:solid 1px black;
}

.disabled{
	width:82px;
	border-bottom:solid 1px black;
	border-right:solid 1px black;
}

#switch_menu{
	text-align:right
}
#switch_menu span{
	/*border:1px solid #222;*/
	
	border-radius:4px;
	font-size:16px;
	padding:3px;
}
/*#switch_menu span:hover{
	box-shadow:0px 0px 5px 3px white;
	background-color:#97CBFF;
}*/
.click:hover{
	box-shadow:0px 0px 5px 3px white;
	background-color:#97CBFF;
}
.clicked{
	background-color:#2894FF;
	box-shadow:0px 0px 5px 3px white;

}
.click{
	background:#8E8E8E;
}
</style>
<script>


var MULTIFILTER_ENABLE = '<% nvram_get("MULTIFILTER_ENABLE"); %>'.replace(/&#62/g, ">");
var MULTIFILTER_MAC = '<% nvram_get("MULTIFILTER_MAC"); %>'.replace(/&#62/g, ">");
var MULTIFILTER_DEVICENAME = decodeURIComponent('<% nvram_char_to_ascii("","MULTIFILTER_DEVICENAME"); %>').replace(/&#62/g, ">");
var MULTIFILTER_MACFILTER_DAYTIME = '<% nvram_get("MULTIFILTER_MACFILTER_DAYTIME"); %>'.replace(/&#62/g, ">").replace(/&#60/g, "<");

var MULTIFILTER_ENABLE_row = MULTIFILTER_ENABLE.split('>');
var MULTIFILTER_DEVICENAME_row = MULTIFILTER_DEVICENAME.split('>');
var MULTIFILTER_MAC_row = MULTIFILTER_MAC.split('>');
var MULTIFILTER_MACFILTER_DAYTIME_row = MULTIFILTER_MACFILTER_DAYTIME.split('>');
var _client;
var clock_type = "";

function init_cookie(){
	if(document.cookie.indexOf('clock_type') == -1)		//initialize
		document.cookie = "clock_type=1";		
			
	x = document.cookie.split(';');
	for(i=0;i<x.length;i++){
		if(x[i].indexOf('clock_type') != -1){
			clock_type = x[i].substring(x[i].length-1, x[i].length);			
		}	
	}
}

var array = new Array(7);
function init_array(arr){
	for(i=0;i<7;i++){
		arr[i] = new Array(24);

		for(j=0;j<24;j++){
			arr[i][j] = 0;
		}
	}
}

function register_event(){
	var array_temp = new Array(7);
	var checked = 0
	var unchecked = 0;
	init_array(array_temp);

  $(function() {
    $( "#selectable" ).selectable({
		filter:'td',
		selecting: function(event, ui){
					
		},
		unselecting: function(event, ui){
			
		},
		selected: function(event, ui){	
			id = ui.selected.getAttribute('id');
			column = parseInt(id.substring(0,1), 10);
			row = parseInt(id.substring(1,3), 10);	

			array_temp[column][row] = 1;
			if(array[column][row] == 1){
				checked = 1;
			}
			else if(array[column][row] == 0){
				unchecked = 1;
			}
		},
		unselected: function(event, ui){

		},		
		stop: function(event, ui){
			if((checked == 1 && unchecked == 1) || (checked == 0 && unchecked == 1)){
				for(i=0;i<7;i++){
					for(j=0;j<24;j++){
						if(array_temp[i][j] == 1){
						array[i][j] = array_temp[i][j];					
						array_temp[i][j] = 0;		//initialize
						if(j < 10){
							j = "0" + j;						
						}		
							id = i.toString() + j.toString();					
							document.getElementById(id).className = "checked";					
						}
					}
				}									
			}
			else if(checked == 1 && unchecked == 0){
				for(i=0;i<7;i++){
					for(j=0;j<24;j++){
						if(array_temp[i][j] == 1){
						array[i][j] = 0;					
						array_temp[i][j] = 0;
						
						if(j < 10){
							j = "0" + j;						
						}
							id = i.toString() + j.toString();											
							document.getElementById(id).className = "disabled";												
						}
					}
				}			
			}
		
			checked = 0;
			unchecked = 0;
		}		
	});		
  });

 }

var device_list = <% pms_device_info(); %>;
var group_list = <% pms_devgroup_info(); %>;
var device_option_array = [
["0", ""],["1", "Windows device"], ["2", "Router"], ["3", ""], ["4", "NAS/Server"], ["5", "IP Cam"], ["6", "MacBook"], ["7", "Game Console"], ["8", ""], ["9", "Android Phone"],
["10", "iPhone"], ["11", "Apple TV"], ["12", "Set-Top Box"], ["13", ""], ["14", "iMac"], ["15", "ROG"], ["16", ""], ["17", ""], ["18", "Printer"], ["19", "Windows Phone"], ["20", "Android Tablet"],
["21", "iPad"], ["22", "Linux Device"], ["23", "Smart TV"], ["24", "Repeater"], ["25", "Kindle"], ["26", "Scanner"], ["27", "Chromecast"], ["28", "ASUS Smartphone"], 
["29", "ASUS Pad"], ["30", "Windows"], ["31", "Android"], ["32", "Mac OS"]
];

var device_type_array = new Array();
for(i=0;i<device_option_array.length;i++){
	device_type_array.push(device_option_array[i][0]);
	device_type_array[device_option_array[i][0]] = {
		number: device_option_array[i][0],
		name: device_option_array[i][1]	
	}
}
var info = new Object();
info.device = new Array();
info.group = new Array();

function initial(){
	show_menu();
	if(hnd_support || based_modelid == "RT-AC1200" || based_modelid == "RT-AC1200_V2" || based_modelid == "RT-AC1200GU" || based_modelid == "RT-N19"){
		$("#nat_desc").hide();
	}
	if(bwdpi_support){
		//show_inner_tab();
		document.getElementById('guest_image').style.background = "url(images/New_ui/TimeLimits.png)";
		document.getElementById('content_title').innerHTML = "<#Access_Control_title#> - <#Time_Scheduling#>";
		document.getElementById('desc_title').innerHTML = "<#ParentalCtrl_Desc_TS#>";
		document.getElementById('web_title').innerHTML = "<#Web_Title#> - <#Time_Scheduling#>";
		document.getElementById('PC_enable').innerHTML = "<#ParentalCtrl_Enable_TS#>";
		//document.getElementById('switch_menu').style.display = "";
	}
	document.getElementById('disable_NAT').href = "Advanced_SwitchCtrl_Content.asp?af=ctf_disable_force";	//this id is include in string : #ParentalCtrl_disable_NAT#

	show_footer();
	init_array(array);
	init_cookie();	
	if(downsize_4m_support || downsize_8m_support){
			document.getElementById("guest_image").parentNode.style.display = "none";
	}

	if(!yadns_support){
		document.getElementById('FormTitle').style.webkitBorderRadius = "3px";
		document.getElementById('FormTitle').style.MozBorderRadius = "3px";
		document.getElementById('FormTitle').style.BorderRadius = "3px";	
	}

	gen_mainTable();
	collect_info();
	generate_group_list();
	//showDropdownClientList('setClientIP', 'mac', 'all', 'ClientList_Block_PC', 'pull_arrow', 'all');
	if(<% nvram_get("MULTIFILTER_ALL"); %>)
		showhide("list_table",1);
	else
		showhide("list_table",0);
		
	count_time();

	//When redirect page from index.asp, auto display edit time scheduling
	var mac = cookie.get("time_scheduling_mac");
	if(mac != "" && mac != null) {
		var idx = MULTIFILTER_MAC_row.indexOf(mac);
		if(idx != -1){
			gen_lantowanTable(idx);
			window.location.hash = "edit_time_anchor";
		}
		cookie.unset("time_scheduling_mac");
	}
	if(isSupport("PC_SCHED_V3") == "2")
		$("#block_all_device").show();
}

function device_object(name, mac, type, type_name, description, group_array){
	this.name = name;
	this.mac = mac;
	this.type = type;
	this.type_name = type_name;
	this.description = description;
	this.group = group_array;
}

function device_group_object(active, name, description, device_array){
	this.active = (active == 1) ? true : false;
	this.name = name;
	this.description = description;
	this.members = device_array;
}

function collect_info(){
	info.group = [];
	info.device = [];
	
	//collect group info
	for(i=0;i<group_list.length;i++){
		var object = group_list[i];
		var group_index = "_" + object.name;
		var group_active  = object.active;
		var group_name = object.name;
		var group_description = object.desc;
		var device_array = new Array();
		device_array = object.owned_device;

		info.group.push(group_index);
		info.group[group_index] = new device_group_object(group_active, group_name, group_description, device_array);
	}
	
	//colletc device info
	for(i=0;i<device_list.length;i++){
		var object = device_list[i];
		var device_index = object.mac;
		var device_name = object.name;
		var device_mac = object.mac;
		var device_type = object.devtype;
		var device_type_name = device_type_array[device_type].name;
		var device_description = object.desc;
		var group_array = new Array();
		group_array = object.device_group;

		info.device.push(device_index);
		info.device[device_index] = new device_object(device_name, device_mac, device_type, device_type_name, device_description, group_array);
	}
}

/*------------ Mouse event of fake LAN IP select menu {-----------------*/
function setClientIP(macaddr){
	document.form.PC_mac.value = macaddr;
	hideClients_Block();
}

function pullLANIPList(obj){	
	var element = document.getElementById('ClientList_Block_PC');
	var isMenuopen = element.offsetWidth > 0 || element.offsetHeight > 0;
	if(isMenuopen == 0){		
		obj.src = "/images/arrow-top.gif"
		element.style.display = 'block';		
		document.form.PC_mac.focus();		
	}
	else
		hideClients_Block();
}

function hideClients_Block(){
	document.getElementById("pull_arrow").src = "/images/arrow-down.gif";
	document.getElementById('ClientList_Block_PC').style.display='none';
}
/*----------} Mouse event of fake LAN IP select menu-----------------*/

function gen_mainTable(){
	var code = "";
	var clientListEventData = [];
	code +='<table width="100%" border="1" cellspacing="0" cellpadding="4" align="center" class="FormTable_table" id="mainTable_table">';
	//code +='<thead><tr><td colspan="4"><#ConnectedClient#>&nbsp;(<#List_limit#>&nbsp;16)</td></tr></thead>';
	code +='<thead><tr><td colspan="4"><#PM_Rule_List#>&nbsp;(<#List_limit#>&nbsp;16)</td></tr></thead>';
	code += '<tr><th width="15%" height="30px" title="<#select_all#>">';
	code += '<select id="selAll" class="input_option" onchange="selectAll();">';
	code += '<option value=""><#select_all#></option>';
	code += '<option value="0"><#btn_disable#></option>';
	code += '<option value="1"><#diskUtility_time#></option>';
	code += '<option value="2"><#Block#></option>';
	code += '</select>';
	code += '</th>';
	code += "<th width='45%'><#ParentalCtrl_Device_Group_Name#></th>";
	code +='<th width="20%"><#ParentalCtrl_time#></th>';
	code +='<th width="20%"><#list_add_delete#></th></tr>';

	code += '<tr><td style="border-bottom:2px solid #000;">';
	code += '<select id="newrule_Enable" class="input_option">';
	code += '<option value="0"><#btn_disable#></option>';
	code += '<option value="1" selected><#diskUtility_time#></option>';
	code += '<option value="2"><#Block#></option>';
	code += '</select>';
	code += '</td>';
	code +='<td style="border-bottom:2px solid #000;"><input type="text" maxlength="17" style="margin-left:0px;width:255px;" class="input_20_table" name="PC_mac" onKeyPress="return validator.isHWAddr(this,event)" onClick="hideClients_Block();" autocorrect="off" autocapitalize="off" placeholder="select the Device Group Name" disabled>';
	code +='<img id="pull_arrow" height="14px;" src="/images/arrow-down.gif" style="position:absolute;" onclick="pullLANIPList(this);" title="<#select_client#>">';
	code +='<div id="ClientList_Block_PC" style="margin:0 0 0 32px" class="clientlist_dropdown"></div></td>';
	code +='<td style="border-bottom:2px solid #000;">--</td>';
	code +='<td style="border-bottom:2px solid #000;"><input class="add_btn" type="button" onClick="addRow_main(16)" value=""></td></tr>';
	if(MULTIFILTER_DEVICENAME == "" && MULTIFILTER_MAC == "")
		code += '<tr><td style="color:#FFCC00;" colspan="4"><#IPConnection_VSList_Norule#></td></tr>';
	else{
		//user icon
		var userIconBase64 = "NoIcon";
		var clientName, deviceType, deviceVender; 
		for(var i=0; i<MULTIFILTER_DEVICENAME_row.length; i++){
			var clientIconID = "clientIcon_" + MULTIFILTER_DEVICENAME_row[i].replace(/\:/g, "");
			if(clientList[MULTIFILTER_DEVICENAME_row[i]]) {
				clientName = (clientList[MULTIFILTER_DEVICENAME_row[i]].nickName == "") ? clientList[MULTIFILTER_DEVICENAME_row[i]].name : clientList[MULTIFILTER_DEVICENAME_row[i]].nickName;
				deviceType = clientList[MULTIFILTER_DEVICENAME_row[i]].type;
				deviceVender = clientList[MULTIFILTER_DEVICENAME_row[i]].vendor;
			}
			else {
				clientName = MULTIFILTER_DEVICENAME_row[i];
				deviceType = 0;
				deviceVender = "";
			}

			var group_name = clientName.split("@")[1];
			code += '<tr id="row'+i+'">';
			code += '<td>';
			code += '<select class="input_option eachrule" onchange="genEnableArray_main('+i+',this);">';
			code += '<option value="0" ' + ((MULTIFILTER_ENABLE_row[i] == 0) ? "selected" : "") + '><#btn_disable#></option>';
			code += '<option value="1" ' + ((MULTIFILTER_ENABLE_row[i] == 1) ? "selected" : "") + '><#diskUtility_time#></option>';
			code += '<option value="2" ' + ((MULTIFILTER_ENABLE_row[i] == 2) ? "selected" : "") + '><#Block#></option>';
			code += '</select>';
			code += '</td>';
			code += '<td title="'+clientName+'">';
		
			code += '<table width="100%"><tr><td style="width:35%;border:0;float:right;padding-right:30px;">';
			if(clientList[MULTIFILTER_DEVICENAME_row[i]] == undefined) {
				code += '<div id="' + clientIconID + '" class="clientIcon type0"></div>';
			}
			else {
				if(usericon_support) {
					userIconBase64 = getUploadIcon(MULTIFILTER_DEVICENAME_row[i].replace(/\:/g, ""));
				}
				if(userIconBase64 != "NoIcon") {
					code += '<div id="' + clientIconID + '" style="text-align:center;"><img class="imgUserIcon_card" src="' + userIconBase64 + '"></div>';
				}
				else if(deviceType != "0" || deviceVender == "") {
					code += '<div id="' + clientIconID + '" class="clientIcon type' + deviceType + '"></div>';
				}
				else if(deviceVender != "" ) {
					var venderIconClassName = getVenderIconClassName(deviceVender.toLowerCase());
					if(venderIconClassName != "" && !downsize_4m_support) {
						code += '<div id="' + clientIconID + '" class="venderIcon ' + venderIconClassName + '"></div>';
					}
					else {
						code += '<div id="' + clientIconID + '" class="clientIcon type' + deviceType + '"></div>';
					}
				}
			}
			code += '</td><td id="client_info_'+i+'" style="width:65%;text-align:left;border:0;">';
			code += '<div>' + group_name + '</div>';
			//code += '<div>' + MULTIFILTER_MAC_row[i] + '</div>';
			code += '</td></tr></table>';
			code += '</td>';

			code += '<td><input class=\"edit_btn\" type=\"button\" onclick=\"gen_lantowanTable('+i+');" value=\"\"/></td>';
			code += '<td><input class=\"remove_btn\" type=\"button\" onclick=\"deleteRow_main(this, \''+ MULTIFILTER_DEVICENAME_row[i] +'\');\" value=\"\"/></td></tr>';
			if(validator.mac_addr(MULTIFILTER_DEVICENAME_row[i]))
				clientListEventData.push({"mac" : MULTIFILTER_DEVICENAME_row[i], "name" : clientName, "ip" : "", "callBack" : "ParentalControl"});
		}
	}
	code += '</table>';

	document.getElementById("mainTable").style.display = "";
	document.getElementById("mainTable").innerHTML = code;
	for(var i = 0; i < clientListEventData.length; i += 1) {
		var clientIconID = "clientIcon_" + clientListEventData[i].mac.replace(/\:/g, "");
		var clientIconObj = $("#mainTable").children("#mainTable_table").find("#" + clientIconID + "")[0];
		var paramData = JSON.parse(JSON.stringify(clientListEventData[i]));
		paramData["obj"] = clientIconObj;
		$("#mainTable").children("#mainTable_table").find("#" + clientIconID + "").click(paramData, popClientListEditTable);
	}
	$("#mainTable").fadeIn();
	document.getElementById("ctrlBtn").innerHTML = '<input class="button_gen" type="button" onClick="applyRule(1);" value="<#CTL_apply#>">';

	generate_group_list();
	//showDropdownClientList('setClientIP', 'mac', 'all', 'ClientList_Block_PC', 'pull_arrow', 'all');
	showclock();
}

function selectAll(){
	$(".eachrule").val($("#selAll").val());
	MULTIFILTER_ENABLE = MULTIFILTER_ENABLE.replace(/[012]/g, $("#selAll").val());
	$("#selAll").val("");
}


function applyRule(_on){
	document.form.MULTIFILTER_ENABLE.value = MULTIFILTER_ENABLE;
	document.form.MULTIFILTER_MAC.value = MULTIFILTER_MAC;

	//update MULTIFILTER_DEVICENAME from custom_clientlist
	var MULTIFILTER_DEVICENAME_array = MULTIFILTER_DEVICENAME.split(">");
	var MULTIFILTER_MAC_array = MULTIFILTER_MAC.split(">");
	MULTIFILTER_DEVICENAME = "";
	for(var i = 0; i < MULTIFILTER_DEVICENAME_array.length; i += 1) {
		var clientName = "";
		if(clientList[MULTIFILTER_DEVICENAME_array[i]]) {
			clientName = (clientList[MULTIFILTER_DEVICENAME_array[i]].nickName == "") ? clientList[MULTIFILTER_DEVICENAME_array[i]].name : clientList[MULTIFILTER_DEVICENAME_array[i]].nickName;
		}
		else {
			clientName = MULTIFILTER_DEVICENAME_array[i];
		}
		MULTIFILTER_DEVICENAME += clientName;
		if(i != (MULTIFILTER_DEVICENAME_array.length - 1))
			MULTIFILTER_DEVICENAME += ">";
	}

	document.form.MULTIFILTER_DEVICENAME.value = MULTIFILTER_DEVICENAME;
	document.form.MULTIFILTER_MACFILTER_DAYTIME.value = MULTIFILTER_MACFILTER_DAYTIME;

	showLoading();	
	document.form.submit();
}

function count_time(){		// To count system time
	systime_millsec += 1000;
	setTimeout("count_time()", 1000);
}

function showclock(){
	JS_timeObj.setTime(systime_millsec);
	JS_timeObj2 = JS_timeObj.toString();	
	JS_timeObj2 = JS_timeObj2.substring(0,3) + ", " +
	              JS_timeObj2.substring(4,10) + "  " +
				  checkTime(JS_timeObj.getHours()) + ":" +
				  checkTime(JS_timeObj.getMinutes()) + ":" +
				  checkTime(JS_timeObj.getSeconds()) + "  " +
				  JS_timeObj.getFullYear();
	document.getElementById("system_time").value = JS_timeObj2;
	setTimeout("showclock()", 1000);
	
	if(svc_ready == "0")
		document.getElementById('svc_hint_div').style.display = "";
	corrected_timezone();
}

function check_macaddr(obj,flag){ //control hint of input mac address
	if(flag == 1){
		var childsel=document.createElement("div");
		childsel.setAttribute("id","check_mac");
		childsel.style.color="#FFCC00";
		obj.parentNode.appendChild(childsel);
		document.getElementById("check_mac").innerHTML="<#LANHostConfig_ManualDHCPMacaddr_itemdesc#>";		
		document.getElementById("check_mac").style.display = "";
		return false;
	}else if(flag ==2){
		var childsel=document.createElement("div");
		childsel.setAttribute("id","check_mac");
		childsel.style.color="#FFCC00";
		obj.parentNode.appendChild(childsel);
		document.getElementById("check_mac").innerHTML="<#IPConnection_x_illegal_mac#>";		
		document.getElementById("check_mac").style.display = "";
		return false;		
	}else{	
		document.getElementById("check_mac") ? document.getElementById("check_mac").style.display="none" : true;
		return true;
	}	
}


function gen_lantowanTable(client){
	_client = client;
	var array_date = ["Select All", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
	var array_time_id = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"];
	if(clock_type == "1")
		var array_time = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"];
	else
		var array_time = ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am", "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm", "12am"];
	
	var code = "";
	var MULTIFILTER_MACFILTER_DAYTIME_col = "";
	MULTIFILTER_MACFILTER_DAYTIME_col = MULTIFILTER_MACFILTER_DAYTIME_row[_client].split('<');

	code +='<div style="margin-bottom:10px;color: #003399;font-family: Verdana;" align="left">';
	code +='<table width="100%" border="1" cellspacing="0" cellpadding="4" align="center" class="FormTable">';
	code +='<thead><tr><td colspan="6" id="LWFilterList"><#ParentalCtrl_Act_schedule#></td></tr></thead>';
	code +='<tr><th style="width:40%;height:20px;" align="right"><#PM_Group_Name#></th>';
	if(MULTIFILTER_DEVICENAME_row[client] != "") {
		var clientName = "";
		/*if(clientList[MULTIFILTER_MAC_row[client]]) {
			clientName = (clientList[MULTIFILTER_MAC_row[client]].nickName == "") ? clientList[MULTIFILTER_MAC_row[client]].name : clientList[MULTIFILTER_MAC_row[client]].nickName;
		}
		else {
			clientName = MULTIFILTER_MAC_row[client];
		}*/

		clientName = MULTIFILTER_DEVICENAME_row[client];
		if(clientName.indexOf("@") != -1){
			clientName = clientName.split("@")[1];
		}

		code +='<td align="left" style="color:#FFF">'+ clientName + '</td></tr>';
	}
	else
		code +='<td align="left" style="color:#FFF">'+ MULTIFILTER_MAC_row[client] + '</td></tr>';
	
	code +='</table><table id="main_select_table">';
	code +='<table  id="selectable" class="table_form" >';
	code += "<tr>";
	for(i=0;i<8;i++){
		if(i == 0)
			code +="<th class='parental_th' onclick='select_all();'>"+array_date[i]+"</th>";	
		else
			code +="<th id=col_"+(i-1)+" class='parental_th' onclick='select_all_day(this.id);'>"+array_date[i]+"</th>";			
	}
	
	code += "</tr>";
	for(i=0;i<24;i++){
		code += "<tr>";
		code +="<th id="+i+" class='parental_th' onclick='select_all_time(this.id)'>"+ array_time[i] + " ~ " + array_time[i+1] +"</th>";
		for(j=0;j<7;j++){
			code += "<td id="+ j + array_time_id[i] +" class='disabled' ></td>";		
		}
		
		code += "</tr>";			
	}
	
	code +='</table></table></div>';
	document.getElementById("mainTable").innerHTML = code;

	register_event();
	redraw_selected_time(MULTIFILTER_MACFILTER_DAYTIME_col);
	
	var code_temp = "";
	code_temp = '<table style="width:350px;margin-left:-200px;"><tr>';
	code_temp += "<td><div style=\"width:95px;font-family:Arial,sans-serif,Helvetica;font-size:18px;\"><#Clock_Format#></div></td>";
	code_temp += '<td><div>';
	code_temp += '<select id="clock_type_select" class="input_option" onchange="change_clock_type(this.value);">';
	code_temp += '<option value="0" >12-hour</option>';
	code_temp += '<option value="1" >24-hour</option>';
	code_temp += '</select>';
	code_temp += '</div></td>';
	code_temp += '<td><div align="left" style="font-family:Arial,sans-serif,Helvetica;font-size:18px;margin:0px 5px 0px 30px;"><#ParentalCtrl_allow#></div></td>';
	code_temp += '<td><div style="width:90px;height:20px;background:#9CB2BA;"></div></td>';
	code_temp += '<td><div align="left" style="font-family:Arial,sans-serif,Helvetica;font-size:18px;margin:0px 5px 0px 30px;"><#ParentalCtrl_deny#></div></td>';
	code_temp += '<td><div style="width:90px;height:20px;border: 1px solid #000000;background:#475A5F;"></div></td>';
	code_temp += '</tr></table>';
	document.getElementById('hintBlock').innerHTML = code_temp;
	document.getElementById('hintBlock').style.marginTop = "10px";
	document.getElementById('hintBlock').style.display = "";
	document.getElementById("ctrlBtn").innerHTML = '<input class="button_gen" type="button" onClick="cancel_lantowan('+client+');" value="<#CTL_Cancel#>" style="margin:0 10px;">';
	document.getElementById("ctrlBtn").innerHTML += '<input class="button_gen" type="button" onClick="saveto_lantowan('+client+');applyRule();" value="<#CTL_ok#>" style="margin:0 10px;">';  
	document.getElementById('clock_type_select')[clock_type].selected = true;		// set clock type by cookie
	
	document.getElementById("mainTable").style.display = "";
	$("#mainTable").fadeIn();
}

//draw time slot at first time
function redraw_selected_time(obj){
	var start_day = 0;
	var end_day = 0;
	var start_time = "";
	var end_time = "";
	var time_temp = "";
	var duration = "";
	var id = "";

	for(i=0;i<obj.length/2;i++){
		time_temp = obj[(2*i)+1];
		start_day = parseInt(time_temp.substring(0,1), 10);
		end_day =  parseInt(time_temp.substring(1,2), 10);
		start_time =  parseInt(time_temp.substring(2,4), 10);
		end_time =  parseInt(time_temp.substring(4,6), 10);
		if((start_day == end_day) && (end_time - start_time) < 0)	//for Sat 23 cross to Sun 00
			end_day = 7;

		if(start_day == end_day){			// non cross day
			duration = end_time - start_time;
			if(duration == 0)	//for whole selected
				duration = 7*24;
			
			while(duration >0){
				array[start_day][start_time] = 1;
				if(start_time < 10)
					start_time = "0" + start_time;
								
				id = start_day.toString() + start_time.toString();
				document.getElementById(id).className = "checked";
				start_time++;
				if(start_time == 24){
					start_time = 0;
					start_day++;
					if(start_day == 7)
						start_day = 0;
				}
	
				duration--;
				id = "";		
			}	
		}else{			// cross day
			var duration_day = 0;
			if(end_day - start_day < 0)
				duration_day = 7 - start_day;
			else
				duration_day = end_day - start_day;
		
			duration = (24 - start_time) + (duration_day - 1)*24 + end_time;
			while(duration > 0){
				array[start_day][start_time] = 1;
				if(start_time < 10)
					start_time = "0" + start_time;
				
				id = start_day.toString() + start_time.toString();
				document.getElementById(id).className = "checked";
				start_time++;
				if(start_time == 24){
					start_time = 0;
					start_day++;
					if(start_day == 7)
						start_day = 0;		
				}
				
				duration--;
				id = "";	
			}		
		}	
	}
}

function select_all(){
	var full_flag = 1;
	for(i=0;i<7;i++){
		for(j=0;j<24;j++){
			if(array[i][j] ==0){ 
				full_flag = 0;
				break;
			}
		}
		
		if(full_flag == 0){
			break;
		}
	}

	if(full_flag == 1){
		for(i=0;i<7;i++){
			for(j=0;j<24;j++){
				array[i][j] = 0;
				if(j<10){
					j = "0"+j;
				}
		
				id = i.toString() + j.toString();
				document.getElementById(id).className = "disabled";
			}
		}	
	}
	else{
		for(i=0;i<7;i++){
			for(j=0;j<24;j++){
				if(array[i][j] == 1)
					continue;
				else{	
					array[i][j] = 1;
					if(j<10){
						j = "0"+j;
					}
			
					id = i.toString() + j.toString();
					document.getElementById(id).className = "checked";
				}
			}
		}
	}
}

function select_all_day(day){
	var check_flag = 0
	day = day.substring(4,5);
	for(i=0;i<24;i++){
		if(array[day][i] == 0){
			check_flag = 1;			
		}			
	}
	
	if(check_flag == 1){
		for(j=0;j<24;j++){
			array[day][j] = 1;
			if(j<10){
				j = "0"+j;
			}
		
			id = day + j;
			document.getElementById(id).className = "checked";	
		}
	}
	else{
		for(j=0;j<24;j++){
			array[day][j] = 0;
			if(j<10){
				j = "0"+j;
			}
		
			id = day + j;
			document.getElementById(id).className = "disabled";	
		}
	}
}

function select_all_time(time){
	var check_flag = 0;
	time_int = parseInt(time, 10);	
	for(i=0;i<7;i++){
		if(array[i][time] == 0){
			check_flag = 1;			
		}			
	}
	
	if(time<10){
		time = "0"+time;
	}

	if(check_flag == 1){
		for(i=0;i<7;i++){
			array[i][time_int] = 1;
			
		id = i + time;
		document.getElementById(id).className = "checked";
		}
	}
	else{
		for(i=0;i<7;i++){
			array[i][time_int] = 0;

		id = i + time;
		document.getElementById(id).className = "disabled";
		}
	}
}

function change_clock_type(type){
	document.cookie = "clock_type="+type;
	if(type == 1)
		var array_time = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"];
	else
		var array_time = ["12", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"];

	for(i=0;i<24;i++){
		if(type == 1)
			document.getElementById(i).innerHTML = array_time[i] +" ~ "+ array_time[i+1];
		else{
			if(i<11 || i == 23)
				document.getElementById(i).innerHTML = array_time[i] +" ~ "+ array_time[i+1] + " AM";
			else
				document.getElementById(i).innerHTML = array_time[i] +" ~ "+ array_time[i+1] + " PM";
		}	
	}
}

function addRow_main(upper){
	var invalid_char = "";
	if(<% nvram_get("MULTIFILTER_ALL"); %> != "1")
		document.form.MULTIFILTER_ALL.value = 1;
	
	var rule_num = document.getElementById('mainTable_table').rows.length - 3; // remove tbody
	if(rule_num >= upper){
		alert("<#JS_itemlimit1#> " + upper + " <#JS_itemlimit2#>");
		return false;	
	}				
	
	if(document.form.PC_mac.value == ""){
		alert("<#JS_fieldblank#>");
		document.form.PC_mac.focus();
		return false;
	}
	
	if(MULTIFILTER_DEVICENAME.search(document.form.PC_mac.value) > -1){
		alert("<#JS_duplicate#>");
		document.form.PC_mac.focus();
		return false;
	}
	
	/*if(!check_macaddr(document.form.PC_mac, check_hwaddr_flag(document.form.PC_mac))){
		document.form.PC_mac.focus();
		document.form.PC_mac.select();
		return false;	
	}	*/

	if(MULTIFILTER_DEVICENAME != "" || MULTIFILTER_MAC != ""){
		MULTIFILTER_ENABLE += ">";
		MULTIFILTER_DEVICENAME += ">";
		//MULTIFILTER_MAC += ">";
	}

	MULTIFILTER_ENABLE += $("#newrule_Enable").val();

	var clientObj = clientList[document.form.PC_mac.value];
	var clientName = document.form.PC_mac.value;
	if(clientObj) {
		clientName = (clientObj.nickName == "") ? clientObj.name : clientObj.nickName;
	}
	//MULTIFILTER_DEVICENAME += "@" + clientName;
	//MULTIFILTER_MAC += "@" + clientName;
	MULTIFILTER_DEVICENAME += "@" + clientName;
	//MULTIFILTER_MAC += document.form.PC_mac.value;

	if(MULTIFILTER_MACFILTER_DAYTIME != "")
		MULTIFILTER_MACFILTER_DAYTIME += ">";

	MULTIFILTER_MACFILTER_DAYTIME += "<";

	MULTIFILTER_ENABLE_row = MULTIFILTER_ENABLE.split('>');
	MULTIFILTER_DEVICENAME_row = MULTIFILTER_DEVICENAME.split('>');
	MULTIFILTER_MAC_row = MULTIFILTER_MAC.split('>');

	MULTIFILTER_MACFILTER_DAYTIME_row = MULTIFILTER_MACFILTER_DAYTIME.split('>');
	document.form.PC_mac.value = "";
	gen_mainTable();
}

function deleteRow_main(r, delMac){
	var j=r.parentNode.parentNode.rowIndex;
	document.getElementById(r.parentNode.parentNode.parentNode.parentNode.id).deleteRow(j);

	var MULTIFILTER_ENABLE_tmp = "";
	var MULTIFILTER_MAC_tmp = "";
	var MULTIFILTER_DEVICENAME_tmp = "";
	var MULTIFILTER_ENABLE_array = MULTIFILTER_ENABLE.split(">");
	var MULTIFILTER_MAC_array = MULTIFILTER_MAC.split(">");
	var MULTIFILTER_DEVICENAME_array = MULTIFILTER_DEVICENAME.split(">");

	for(var idx = 0; idx < MULTIFILTER_DEVICENAME_array.length; idx += 1) {
		if(MULTIFILTER_DEVICENAME_array[idx] != delMac) {
			if(MULTIFILTER_MAC_tmp != "") {
				MULTIFILTER_MAC_tmp += ">";
				MULTIFILTER_ENABLE_tmp += ">";
				MULTIFILTER_DEVICENAME_tmp += ">";
			}
			MULTIFILTER_MAC_tmp += MULTIFILTER_MAC_array[idx];
			MULTIFILTER_ENABLE_tmp += MULTIFILTER_ENABLE_array[idx];
			MULTIFILTER_DEVICENAME_tmp += MULTIFILTER_DEVICENAME_array[idx];
		}
	}

	MULTIFILTER_ENABLE = MULTIFILTER_ENABLE_tmp;
	//MULTIFILTER_MAC = MULTIFILTER_MAC_tmp;
	MULTIFILTER_DEVICENAME = MULTIFILTER_DEVICENAME_tmp;
	
	MULTIFILTER_ENABLE_row = MULTIFILTER_ENABLE.split('>');
	//MULTIFILTER_MAC_row = MULTIFILTER_MAC.split('>');
	MULTIFILTER_DEVICENAME_row = MULTIFILTER_DEVICENAME.split('>');
	
	MULTIFILTER_MACFILTER_DAYTIME_row.splice(j-3,1);
	regen_lantowan();	
	gen_mainTable();
}

function saveto_lantowan(client){
	var flag = 0;
	var start_day = 0;
	var end_day = 0;
	var start_time = 0;
	var end_time = 0;
	var time_temp = "";
	
	for(i=0;i<7;i++){
		for(j=0;j<24;j++){
			if(array[i][j] == 1){
				if(flag == 0){
					flag =1;
					start_day = i;
					if(j<10)
						j = "0" + j;
						
					start_time = j;				
				}
			}
			else{
				if(flag == 1){
					flag =0;
					end_day = i;
					if(j<10)
						j = "0" + j;
					
					end_time = j;		
					if(time_temp != "")
						time_temp += "<";
					
					//T< : T for editable time slot name	
					time_temp += "T<" + start_day.toString() + end_day.toString() + start_time.toString() + end_time.toString();
				}
			}
		}	
	}
	
	if(flag == 1){
		if(time_temp != "")
			time_temp += "<";
		
		//T< : T for editable time slot name							
		time_temp += "T<" + start_day.toString() + "0" + start_time.toString() + "00";	
	}
	
	if(time_temp == "")
		time_temp = "<";
	
	MULTIFILTER_MACFILTER_DAYTIME_row[client] = time_temp;
	regen_lantowan();
	gen_mainTable();
}

function cancel_lantowan(client){
	init_array(array);
	gen_mainTable();
	document.getElementById('hintBlock').style.display = "none";
}

function regen_lantowan(){
	MULTIFILTER_MACFILTER_DAYTIME = "";
	for(i=0;i<MULTIFILTER_MACFILTER_DAYTIME_row.length;i++){
		MULTIFILTER_MACFILTER_DAYTIME += MULTIFILTER_MACFILTER_DAYTIME_row[i];
		if(i<MULTIFILTER_MACFILTER_DAYTIME_row.length-1){
			MULTIFILTER_MACFILTER_DAYTIME += ">";
		}
	}
}

function genEnableArray_main(j, obj){
	MULTIFILTER_ENABLE_row = MULTIFILTER_ENABLE.split('>');

	MULTIFILTER_ENABLE_row[j] = obj.value;

	MULTIFILTER_ENABLE = "";
	for(i=0; i<MULTIFILTER_ENABLE_row.length; i++){
		MULTIFILTER_ENABLE += MULTIFILTER_ENABLE_row[i];
		if(i<MULTIFILTER_ENABLE_row.length-1)
			MULTIFILTER_ENABLE += ">";
	}
}

function show_inner_tab(){
	var code = "";
	if(document.form.current_page.value == "ParentalControl.asp"){		
		code += "<span class=\"clicked\"><#Time_Scheduling#></span>";
		code += '<a href="AiProtection_WebProtector.asp">';
		code += "<span style=\"margin-left:10px\" class=\"click\"><#AiProtection_filter#></span>";
		code += '</a>';
	}
	else{
		code += '<a href="AiProtection_WebProtector.asp">';
		code += "<span class=\"click\"><#Time_Scheduling#></span>";
		code += '</a>';		
		code += "<span style=\"margin-left:10px\" class=\"clicked\"><#AiProtection_filter#></span>";	
	}
	
	//document.getElementById('switch_menu').innerHTML = code;
}

function generate_group_list(){
	var code = '';
	for(i=0;i<info.group.length;i++){
		var group_index = info.group[i];
		var group_obj = info.group[group_index];
		var group_name = group_obj.name;
		var group_description = group_obj.description;
		code += '<a id="'+ group_index +'" title="'+ group_description +'"><div onclick="setGroup(\''+ group_name +'\');"><strong>'+ group_name +'</strong></div></a>';
	}

	code += '<a><div onclick="" style="text-align:right;text-decoration:underline;color:#A0A0A0;"><strong style="cursor:pointer;" onclick="location.href=\'PermissionManagement_DeviceGroups.asp\'">Generate Device Group</strong></div></a>';

	$("#ClientList_Block_PC").html(code);
}

function setGroup(name){
	document.form.PC_mac.value = name;
	hideClients_Block();
}
</script></head>

<body onload="initial();" onunload="unload_body();" onselectstart="return false;">
<div id="TopBanner"></div>
<div id="Loading" class="popup_bg"></div>

<iframe name="hidden_frame" id="hidden_frame" width="0" height="0" frameborder="0"></iframe>
<form method="post" name="form" action="/start_apply.htm" target="hidden_frame">
<input type="hidden" name="productid" value="<% nvram_get("productid"); %>">
<input type="hidden" name="current_page" value="ParentalControl.asp">
<input type="hidden" name="next_page" value="">
<input type="hidden" name="modified" value="0">
<input type="hidden" name="action_wait" value="5">
<input type="hidden" name="action_mode" value="apply">
<input type="hidden" name="action_script" value="restart_firewall">
<input type="hidden" name="preferred_lang" id="preferred_lang" value="<% nvram_get("preferred_lang"); %>" disabled>
<input type="hidden" name="firmver" value="<% nvram_get("firmver"); %>">
<input type="hidden" name="MULTIFILTER_ALL" value="<% nvram_get("MULTIFILTER_ALL"); %>">
<input type="hidden" name="MULTIFILTER_ENABLE" value="<% nvram_get("MULTIFILTER_ENABLE"); %>">
<input type="hidden" name="MULTIFILTER_MAC" value="<% nvram_get("MULTIFILTER_MAC"); %>">
<input type="hidden" name="MULTIFILTER_DEVICENAME" value="<% nvram_get("MULTIFILTER_DEVICENAME"); %>">
<input type="hidden" name="MULTIFILTER_MACFILTER_DAYTIME" value="<% nvram_get("MULTIFILTER_MACFILTER_DAYTIME"); %>">

<table class="content" align="center" cellpadding="0" cellspacing="0" >
	<tr>
		<td width="17">&nbsp;</td>		
		<td valign="top" width="202">				
		<div  id="mainMenu"></div>	
		<div  id="subMenu"></div>		
	</td>				
		
    <td valign="top">
	<div id="tabMenu" class="submenuBlock"></div>
	
		<!--===================================Beginning of Main Content===========================================-->		
<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0" >
	<tr>
		<td valign="top" >
		
<table width="730px" border="0" cellpadding="4" cellspacing="0" class="FormTitle" id="FormTitle">
	<tbody>
	<tr>
		<td bgcolor="#4D595D" valign="top">
		<div>&nbsp;</div>
		<div style="margin-top:-5px;">
			<table width="730px">
				<tr>
					<td align="left" >
						<div id="content_title" class="formfonttitle" style="width:400px"><#Parental_Control#></div>
					</td>				
				</tr>
			</table>
			<div style="margin: 0 0 10px 5px" class="splitLine"></div>
			<div id="block_all_device" style="margin-bottom:6px;display:none;">
				<div style="font-size:14px;margin-left:6px;margin-bottom:6px;"><#Block_All_Device_Desc#></div>
				<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable">
					<tr>
						<th><#Block_All_Device#></th>
						<td>
							<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_block_all"></div>
							<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
								<script type="text/javascript">
									$('#radio_block_all').iphoneSwitch('<% nvram_get("MULTIFILTER_BLOCK_ALL"); %>',
										function(){
											httpApi.nvramSet({
												"action_mode": "apply",
												"rc_service": "restart_firewall",
												"MULTIFILTER_BLOCK_ALL": "1"
											}, function(){
												showLoading(3);
											});
										},
										function(){
											httpApi.nvramSet({
												"action_mode": "apply",
												"rc_service": "restart_firewall",
												"MULTIFILTER_BLOCK_ALL": "0"
											}, function(){
												showLoading(3);
											});
										}
									);
								</script>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div id="PC_desc">
			<table width="700px" style="margin-left:25px;">
				<tr>
					<td>
						<div id="guest_image" style="background: url(images/New_ui/parental-control.png);width: 130px;height: 87px;"></div>
					</td>
					<td>&nbsp;&nbsp;</td>
					<td style="font-size: 14px;">
						<span id="desc_title"><#ParentalCtrl_Desc#></span>
						<ol>	
							<li><#ParentalCtrl_Desc1#></li>
							<li><#ParentalCtrl_Desc2#></li>
							<li><#ParentalCtrl_Desc3#></li>
							<li><#ParentalCtrl_Desc4#></li>
							<li><#ParentalCtrl_Desc5#></li>							
						</ol>
						<span id="desc_note" style="color:#FC0;"><#ADSL_FW_note#></span>
						<ol style="color:#FC0;margin:-5px 0px 3px -18px;*margin-left:18px;">
							<li><#ParentalCtrl_default#></li>
							<li id="nat_desc"><#ParentalCtrl_disable_NAT#></li>
						</ol>	
					</td>
				</tr>
			</table>
		</div>
			<!--=====Beginning of Main Content=====-->
			<div id="edit_time_anchor"></div>
			<table width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3"  class="FormTable">
				<tr>
					<th id="PC_enable"><#ParentalCtrl_Enable#></th>
					<td>
						<div align="center" class="left" style="width:94px; float:left; cursor:pointer;" id="radio_ParentControl_enable"></div>
						<div class="iphone_switch_container" style="height:32px; width:74px; position: relative; overflow: hidden">
							<script type="text/javascript">
								$('#radio_ParentControl_enable').iphoneSwitch('<% nvram_get("MULTIFILTER_ALL"); %>',
									function(){
											document.form.MULTIFILTER_ALL.value = 1;
											showhide("list_table",1);	
									},
									function(){
										document.form.MULTIFILTER_ALL.value = 0;
										showhide("list_table",0);
										if(document.form.MULTIFILTER_ALL.value == '<% nvram_get("MULTIFILTER_ALL"); %>')
											return false;
																					
											applyRule(1);
									}
								);
							</script>			
						</div>
					</td>			
				</tr>				
			</table>				
			<table id="list_table" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="display:none">
				<tr>
					<td valign="top" align="center">
						<!-- client info -->
						<div id="VSList_Block"></div>
						<!-- Content -->
						<div id="SystemTime">
							<table width="100%" border="1" cellspacing="0" cellpadding="4" class="FormTable">
								<tr>
									<th width="20%"><#General_x_SystemTime_itemname#></th>
									<td align="left"><input type="text" id="system_time" name="system_time" class="devicepin" value="" readonly="1" style="font-size:12px;width:200px;" autocorrect="off" autocapitalize="off">
										<div id="svc_hint_div" style="display:none;"><span onClick="location.href='Advanced_System_Content.asp?af=ntp_server0'" style="color:#FFCC00;text-decoration:underline;cursor:pointer;"><#General_x_SystemTime_syncNTP#></span></div>
		  								<div id="timezone_hint_div" style="display:none;"><span id="timezone_hint" onclick="location.href='Advanced_System_Content.asp?af=time_zone_select'" style="color:#FFCC00;text-decoration:underline;cursor:pointer;"></span></div>
									</td>
								</tr>
							</table>
						</div>
						<div id="hintBlock" style="width:650px;display:none;"></div>
						<div id="mainTable" style="margin-top:10px;"></div>
						<br>
						<div id="ctrlBtn" style="text-align:center;"></div>
						<!-- Content -->						
					</td>	
				</tr>
			</table>
		</td>
	</tr>
	</tbody>	
	</table>
</td>         
        </tr>
      </table>				
		<!--===================================Ending of Main Content===========================================-->		
	</td>
		
    <td width="10" align="center" valign="top">&nbsp;</td>
	</tr>
</table>

<div id="footer"></div>
</form>
</body>
</html>
