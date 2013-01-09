$(document).ready(function(){
  $("#board").on("gravity_done", function(){
    if(pieces_moved){
      afterRotate();
      return false;
    }else{
      settling = false;
    }
  });
});