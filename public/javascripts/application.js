function float_coin_message(msg){
  $("#coin-float-message").html(msg).css({left : '300px', top: '200px', opacity: 0}).show().animate({top : 50}, {duration: 5000, easing : 'linear'}).animate({opacity : 1}, {duration:1000, queue : false, complete : function(){$("#coin-float-message").animate({opacity: 0},{duration: 4000, queue: false})}})
}

function change_coins_live(amount){
  if(amount > 0){
   float_coin_message("+"+amount); 
  }else{
    float_coin_message(amount);
  }
  new_coin_amount = parseInt($("#user-coins-current").html(),10) + parseInt(amount, 10)
  $("#user-coins-current").html(new_coin_amount)
}

var alert_dialog;
$(document).ready(function(){
  alert_dialog = $("<div></div>");
  alert_dialog.dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    dialogClass: "dialog-no-close dialog-no-title",
    buttons: {
      OK: function(){
        alert_dialog.dialog("close");
      }
    }
  })
});