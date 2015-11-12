
var currentState = "";
//set up an interval
$(document).ready(function(){
  console.log("Start the machine");
  setInterval(processCurrentState, 100);
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