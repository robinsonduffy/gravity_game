// setup some variables we need
var currentState = "";
var boardSettled = false;

//set up an interval
$(document).ready(function(){
  console.log("Start the machine");
  setInterval(processCurrentState, 1);
});

function processCurrentState(){
  console.log("Process Current State: " + currentState);
  if (typeof states[currentState] === 'function') {
    return states[currentState]();
  }
}

function setState(stateName) {
  currentState = stateName;
}

var states = {
  'initialBoardSetup': function () {
    setState("buildingBoard");
    initBoard();
    setUpPieces();
    setState("triggerGravity");
  },
  'triggerGravity': function () {
    if (level_js_status != 'gameplay' && !gravity_turned_on) {
      setState("waitingForInput");
    } else {
      setState("processStations");
    }
  },
  'processStations': function(){
    setState("processingStations");
    boardSettled = true;
    applyPaint();
    applyGravitySwap();
    applyCoins();
    applyMagnets();
    setState("movePiecesOneSpace");
  },
  'movePiecesOneSpace': function(){
    setState('movingPiecesOneSpace');
    moveAllPiecesByOne();
  },
  'movingPiecesOneSpace': function() {
  	if($("#board .game-piece").filter(":animated").length) {
  		return false;
  	} else {
      if(boardSettled) {
        setState('gravityDone');
      } else {
        setState('processStations');
      }
  	}
  },
  'gravityDone': function(){
    $("#board").trigger("gravity_done");
  },
  'applyGravity': function(){
    setState("runningGravity");
    applyGravity();
    setState("waitingForInput");
  },
  'triggerRotation': function () {
    setState("rotating");
    $("#board").trigger("rotate");
  	$("#board").clone().attr('id','board-clone').appendTo($("#board-wrapper"));
  	$("#board").css('visibility','hidden');
  	rearrangeBoard();
  	$("#board-clone").animate(
  		{
  			rotate: degree
  		},
  		{
  			complete: function(){
  				setState("rotationDone");
  			}
  		}
  	);
  },
  'rotationDone' : function(){
    if($("#board #game-pieces div[_moved='no']").length == 0){
		  $("#board").css('visibility','visible');
		  $("#board-clone").remove();
      setState("triggerGravity");
    }
  }
};