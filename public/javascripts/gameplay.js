var rotations = 0;
var weighted_rotations = 0; //the rotations weighted with the number of locks
var locks = 0;
var coins = 0;
var liveScore = 0;
var possibleCoins = 0;
var possibleLocks = 0;
var timer = 0;
var timerStarted = false;
var timerInterval;
var level_js_status = 'gameplay';

$(document).ready(function(){
  possibleCoins = getPossibleCoins();
  possibleLocks = $("#board .lockable").length;
  
  $("#restart-level-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    closeOnEscape: false,
    title: "Restart Level?",
    position: { my: "center top", at: "center top+110", of: window },
    buttons: {
      OK: function() {
        $(this).dialog( "close" );
        window.location = $("#reload-level a").attr('href');
      },
      Cancel: function() {
        $(this).dialog( "close" );
      }
    }
  });
  
  $("#cancel-level-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    closeOnEscape: false,
    title: "Quit Level?",
    position: { my: "center top", at: "center top+110", of: window },
    buttons: {
      OK: function() {
        $(this).dialog( "close" );
        window.location = $("#cancel-level a").attr('href');
      },
      Cancel: function() {
        $(this).dialog( "close" );
      }
    }
  });
  
  $("#success-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    closeOnEscape: false,
    title: "Success!",
    dialogClass: "dialog-no-close",
    width: 408,
    position: { my: "center top", at: "center top+110", of: window },
    open: function(){
      $('#success-dialog :link').blur();
    }
  });
  
  $("#level-startup-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    closeOnEscape: true,
    title: "Level Info",
    width: 408,
    position: { my: "center top", at: "center top+110", of: window },
  });

  $("#level-icons #reload-level a").click(function(){
    $("#restart-level-dialog").dialog("open");
    return false;
  });

  $("#level-icons #cancel-level a").click(function(){
    $("#cancel-level-dialog").dialog("open");
    return false;
  });

  $("#level-popup").click(function(){
    $("#level-startup-dialog").dialog("open");
  });

  $("#board").on("rotate", function(){
    
    rotations++;
    weighted_rotations = weighted_rotations + 1 + Math.ceil($("#board .locked").length / 2);
    $("#current-rotations .stat-value").html(rotations);
  });
  
  $("#board").on("start_timer_if_needed", function(){
    if(!timerStarted){
      timerInterval = setInterval("recordTime();", 1000);
      timerStarted = true;
      $("#time-bonus-progress").animate({width: "0%"}, {duration: $("#time-bonus-progress").data("bonus_time_limit"), easing:"linear"});
    }
  });

  $("#board").on("capture_coins", ".coin", function(){
    coins = coins + parseInt($(this).attr('_coin_value'),10);
    $("#current-coins .stat-value span").html(coins);
  });

  $("#board").on("gravity_done", function(){
    setState("CheckingForSuccess");
    var goals_reached = 0;
    settling = false;
    locks = $("#board .locked").length;
    tallyLiveScore();
    $("#current-locks .stat-value span").html(locks);
    $('#board .goal').each(function(){
      if($("#board .game-piece."+$(this).attr('_color')+"[_cell='"+$(this).attr('_cell')+"']").length){
        goals_reached++;
      }
    });
    console.log("Goals Reached: " + goals_reached);
    if(goals_reached == $("#board .goal").length){
      settling = true;
      setTimeout('triggerSuccess()',1000);
    } else {
      setState("waitingForInput");
    }
  });
});

function triggerSuccess(){
  clearInterval(timerInterval)
  $("#nav p").css('visibility', 'hidden');
  $.ajax({
    type: "POST",
    url : '/ajax/complete_level',
    data : {
      r : rotations,
      w : weighted_rotations,
      l : locks,
      c : coins,
      t : timer
    }
  }).done(function(msg){
    if(msg.type == 'Error'){
      alert('There was an error (code: '+msg.code+')');
      return false;
    }
    if(msg.type == 'Success'){
      tallyScore(msg);
    }
  });
}

function getPossibleCoins(){
  totalCoinValue = 0;
  $("#board .coin").each(function(){
    totalCoinValue = totalCoinValue + parseInt($(this).attr('_coin_value'),10);
  })
  return totalCoinValue;
}

function tallyScore(scoreInfo){
  $("#tally-detail-rotations .tally-detail-value").html(rotations);
  $("#tally-detail-locks .tally-detail-value").html(locks + ' / ' + possibleLocks);
  $("#tally-detail-coins .tally-detail-value").html(coins + ' / ' + possibleCoins);
  $("#tally-score-value").html(scoreInfo.score);
  $("#tally-detail-time .tally-detail-value").html(scoreInfo.time_bonus);
  if(scoreInfo.score_best == 'true'){
    $("#honors p").html("This is the best score for this level...ever!").addClass("honor-msg");
  }else if(scoreInfo.score_personal_best == 'true'){
    $("#honors p").html("This is your personal best score for this level!").addClass("honor-msg");
  }
  if(scoreInfo.add_coins > 0){
    change_coins_live(scoreInfo.add_coins);
  }
  $("#success-dialog").dialog("open");
}

function tallyLiveScore(){
  if(possibleCoins > 0){
    liveScore = Math.ceil(((1 - (coins / possibleCoins)) * 50) + (weighted_rotations * 2) + (locks * 5))
  }else{
    liveScore = Math.ceil((weighted_rotations * 2) + (locks * 5))
  }
  $("#user-current-stats .top-score").html(liveScore);
}

function recordTime(){
  timer++;
}