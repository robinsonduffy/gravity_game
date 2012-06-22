/***************************/
//@Author: Adrian "yEnS" Mato Gondelle
//@website: www.yensdesign.com
//@email: yensamg@gmail.com
//@license: Feel free to use it, but keep this credits please!					
/***************************/

//SETTING UP OUR POPUP
//0 means disabled; 1 means enabled;
var popupStatus = 0;

//loading popup with jQuery magic!
function loadPopup(){
	//loads popup only if it is disabled
	if(popupStatus==0){
		$("#popup-background").css({
			"opacity": "0.7"
		});
		$("#popup-background").fadeIn("slow");
		$("#popup-window").fadeIn("slow");
		popupStatus = 1;
	}
}

//disabling popup with jQuery magic!
function disablePopup(){
	//disables popup only if it is enabled
	if(popupStatus==1){
		$("#popup-background").fadeOut("slow");
		$("#popup-window").fadeOut("slow");
		popupStatus = 0;
	}
}

//centering popup
function centerPopup(){
	//request data for centering
	var windowWidth = document.documentElement.clientWidth;
	var windowHeight = document.documentElement.clientHeight;
	var popupHeight = $("#popup-window").height();
	var popupWidth = $("#popup-window").width();
	//centering
	$("#popup-window").css({
		"position": "absolute",
		"top": '100px',
		"left": windowWidth/2-popupWidth/2
	});
	//only need force for IE6
	
	$("#popup-background").css({
		"height": windowHeight
	});
	
}


//CONTROLLING EVENTS IN jQuery
$(document).ready(function(){
	//CLOSING POPUP
	//Click the x event!
	$("#popup-close-button").click(function(){
		disablePopup();
	});
	//Click out event!
	$("#popup-background").click(function(){
		disablePopup();
	});
});