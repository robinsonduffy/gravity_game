$(document).ready(function(){
  $("#board").on("gravity_done", function(){
    if(pieces_moved){
      afterRotate();
      return false;
    }else{
      settling = false;
    }
  });

  $("#grid-size").change(function(){
    new_grid_size = $(this).val();
    $("#board").css('visibility', 'hidden');
    rebuild_grid(new_grid_size);
    adjust_game_pieces_to_fit_grid(new_grid_size);
    $("#table-grid-size-css").attr("href", "/stylesheets/table-"+new_grid_size+".css");
    $("#board").css('visibility', 'visible');
    if(max_x > new_grid_size){
      //we are making the grid smaller
    }else if(max_x < new_grid_size){
      //we are making the grid bigger

    }else{
      //the grid is staying the same size?  for some reason
    }

  });
});

function rebuild_grid(grid_size){
  $("#board table#squares").empty();
  for(var i=0; i < grid_size; i++){
    tr = $("<tr></tr>");
    for(var j=0; j < grid_size; j++){
      td = $("<td></td>");
      td.addClass("square").attr("id", "row-"+(i+1)+"-square-"+(j+1)).attr("_cell", (i+1)+","+(j+1));
      td.appendTo(tr);
    }
    tr.appendTo("#board table#squares");
  }
}

function adjust_game_pieces_to_fit_grid(grid_size){
  $("#board .game-piece").addClass("adjust-grid-delete");
  //mark the pieces we are going to keep...
  for(var i=0; i < grid_size; i++){
    for(var j=0; j < grid_size; j++){
      $("#board .game-piece[_cell='"+i+","+j+"']").removeClass("adjust-grid-delete");
    }
  }
  //get rid of the rest...
  $("#board .game-piece.adjust-grid-delete").remove();
}