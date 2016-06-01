var degree = 0;
var max_x = 0;
var max_y = 0;
var pieces_moved = false;
var settling = false;

$(document).ready(function(){
  setState("initialBoardSetup");
});

function initBoard(){
  max_x = parseInt($("#board table tr").length);
  max_y = parseInt($("#board table tr").length);
  $("#level-rotate-buttons p.rotate").click(function(){
    if(isState("waitingForInput")){
      switch(this.id){
        case 'counter-clock-wise':
          degree = -90;
          break;
        case 'clock-wise':
          degree = 90;
          break;
      }
      setState("triggerRotation");
    }
  });
  $("#board").on("click","div.lockable", function(){
    if(isState("waitingForInput") && !$(this).hasClass('magnetized')){
      $(this).toggleClass("locked");
      $("#board").trigger("start_timer_if_needed");
      setState("triggerGravity");
    }
  });
  $("#board").on("click","div.gate", function(){
    if(isState("waitingForInput")){
      //pass the click event down to any "lockable" game pieces on the same cell
      $("#board div.lockable[_cell='"+$(this).attr("_cell")+"']").click();
    }
  });
}

function getPosition(){
  return ((((degree / 90) / 4) - Math.floor((degree / 90) / 4)) + 1);
}

function rearrangeBoard(){
  $('#board #game-pieces div').attr('_moved','no');
  $('#board #game-pieces div').each(function(){
    if($(this).attr('_moved') == 'no'){
      move_to_cell = getNewCell($(this).attr('_cell'));
      $(this).css({
        left: $("#board .square[_cell='" + move_to_cell + "']").position().left+'px',
        top: $("#board .square[_cell='"+ move_to_cell + "']").position().top+'px'
      }).attr('_moved', 'yes').attr('_cell', move_to_cell);
      if($(this).hasClass('teleport')){
        $(this).attr('_teleport_exit_cell',getNewCell($(this).attr('_teleport_exit_cell')));
      }
    }
  })
  
}

function setUpPieces(){
  $('#board #game-pieces div').each(function(){
    $(this).css({
      left: $("#board .square[_cell='"+$(this).attr('_cell')+"']").position().left+'px',
      top: $("#board .square[_cell='"+$(this).attr('_cell')+"']").position().top+'px'
    }).attr('_moved', 'yes');
  });
}

function getNewCell(current_cell){
  current_cell_array = current_cell.split(',');
  switch(degree){
    case 90:
      new_cell = [current_cell_array[1], (max_x + 1) - current_cell_array[0]];
      break;
    case -90:
      new_cell = [(max_y + 1) - current_cell_array[1], current_cell_array[0]]
      break;
  } 
  return new_cell;
}

function canGamePieceMoveToCell(game_piece, cell){
  return (isCellAvailable(cell) && doesCellHaveOpenGate(cell, $(game_piece).attr("_color")));
}

function isCellAvailable(cell){
  //check if the cell is actually a cell
  if (!isCellActuallyACell(cell)) {
    return false;
  }
  //check to see if this cell doesn't have a game piece on it
  if($("#board .game-piece[_cell='"+cell+"']").length < 1){
    return true;
  }
  return false;
}

function doesCellHaveOpenGate(cell, color){
  if ($("#board .gate[_cell='"+cell+"']").length == 0){
    //return true if there is no gate
    return true;
  }
  
  foundOpenGate = false;
  $("#board .gate[_cell='"+cell+"']").each(function(){
    if ($(this).attr("_color") == color){
      // return true if the gate's color matches
      foundOpenGate = true;
      return false; //this breaks us out of the .each loop
    }
  });
  
  return foundOpenGate;
}

function isCellActuallyACell(cell){
  if (cell[0] > max_x || cell[1] > max_y || cell[0] < 1 || cell[1] < 1){
    return false;
  }
  return true;
}

function doesCellHaveMovablePiece(cell){
  console.log("doesCellHaveMovablePiece: " + cell);
  //check if the cell is actually a cell
  if (!isCellActuallyACell(cell)) {
    return false;
  }
  
  if($("#board .floating[_cell='"+cell+"']").not(".locked, .magnetized").length >= 1 || $("#board .falling[_cell='"+cell+"']").not(".locked, .magnetized").length >= 1){
    console.log("Movable");
    return true;
  }
  console.log("UnMovable");
  return false;
}

function moveAllPiecesByOne(){
  $("#board #game-pieces div").removeClass('already-moved');
  for(i=1; i<=max_y; i++){
    column_settling = true;
    while(column_settling){
      column_settling = false;
      //go through each cell in the column
      for(j=1; j<=max_x; j++){
        
        var cell = [j,i]
        
        //check for falling block
        if($("#board #game-pieces .falling[_cell='"+cell+"']").length){
          var this_game_piece = $("#board #game-pieces .falling[_cell='"+cell+"']").eq(0);
          if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized') && !this_game_piece.hasClass('already-moved')){
            if(canGamePieceMoveToCell(this_game_piece, [j+1,i])){
              boardSettled = false;
              this_game_piece.attr('_cell', [j+1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
                left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
                top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
              }, {
                duration : 100,
                easing : "linear"
              });
              column_settling = true;
            }
          }
        }
        
        //check for floating block
        if($("#board #game-pieces .floating[_cell='"+cell+"']").length){
          var this_game_piece = $("#board #game-pieces .floating[_cell='"+cell+"']").eq(0);
          if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized') && !this_game_piece.hasClass('already-moved')){
            //if the space above is available, put it there
            if(canGamePieceMoveToCell(this_game_piece, [j-1,i])){
              boardSettled = false;
              this_game_piece.attr('_cell', [j-1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
                left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
                top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
              }, {
                duration : 100,
                easing : "linear"
              });
              column_settling = true;
            }else{
              //go up through the pieces until you find a space that doesn't have a falling piece or a closed gate
              current_cell_x = j + 0;
              keep_moving_up = true;
              found_nonfalling_cell = false;
              current_cell = [current_cell_x,i];
              while(current_cell_x > 1 && keep_moving_up){
                current_game_piece = $("#board #game-pieces .game-piece[_cell='"+current_cell+"']").eq(0);
                current_cell_x--;
                current_cell = [current_cell_x,i];
                if(canGamePieceMoveToCell(current_game_piece, current_cell)){
                  keep_moving_up = false;
                } else {
                  // why did it fail?  
                  if (!doesCellHaveOpenGate(current_cell, current_game_piece.attr("_color"))){
                    // Is it because there is a closed gate?
                    current_cell_x++;
                    keep_moving_up = false;
                  } else {
                    // does it have a non-falling piece?
                    if ($("#board #game-pieces .game-piece[_cell='"+current_cell+"']").not(".falling").length || $("#board #game-pieces .locked[_cell='"+current_cell+"']").length || $("#board #game-pieces .magnetized[_cell='"+current_cell+"']").length){
                      keep_moving_up = false;
                    }
                  }
                }
              }
              if(current_cell_x > 0){
                //go down moving pieces up into available cells
                while(current_cell_x < j){
                  current_cell_x++;
                  current_cell = [current_cell_x,i];
                  var this_game_piece = $("#board #game-pieces .floating[_cell='"+current_cell+"'], #board #game-pieces .falling[_cell='"+current_cell+"']").eq(0);
                  if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized')){
                    //if the space above is available, put it there
                    if(canGamePieceMoveToCell(this_game_piece, [current_cell_x-1,i])){
                      boardSettled = false;
                      this_game_piece.attr('_cell', [current_cell_x-1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
                        left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
                        top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
                      }, {
                        duration : 100,
                        easing : "linear"
                      });
                      column_settling = true;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

function applyTeleports(){
  piecesTeleporting = 0;
  $('#board .station.teleport').each(function(){
    var teleport_entrance_cell = $(this).attr('_cell');
    var teleport_exit_cell = $(this).attr('_teleport_exit_cell');
    if(doesCellHaveMovablePiece(teleport_entrance_cell)){
      //CHECK TO SEE IF THE PIECE HAS ALREAY BEEN TELEPORTED
      if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").attr('_just_teleported') != "true"){
        //CHECK TO SEE IF THE EXIT IS FREE
        if($("#board .game-piece[_cell='"+teleport_exit_cell+"']").length == 0){
          //TELEPORT
          piecesTeleporting++;
          $("#board .game-piece[_cell='"+teleport_entrance_cell+"']").fadeOut(function(){
            $("#board .game-piece[_cell='"+teleport_entrance_cell+"']").css({
              left: $("#board .square[_cell='" + teleport_exit_cell + "']").position().left+'px',
              top: $("#board .square[_cell='"+ teleport_exit_cell + "']").position().top+'px'
            }).attr('_cell', teleport_exit_cell).attr('_just_teleported','true').fadeIn(function(){
              piecesTeleporting--;
            });
          });
        }
      }
    }
  });
}

function applyPaint(){
  $("#board .paint").each(function(){
    if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
      THE PAINT NEEDS TO SET THE _COLOR ATTR AS WELL...
      $("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").removeClass($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").eq(0).attr("_color")).addClass($(this).attr('_color'));
      $(this).remove();
    }
  });
}

function applyGravitySwap(){
  $("#board .gravity-swap").each(function(){
    if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
      $("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").toggleClass('falling').toggleClass('floating');
      pieces_moved = true;
      $(this).remove();
    }
  });
}

function applyCoins(){
  $("#board .coin").each(function(){
    if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
      if($(this).hasClass("destructive")){
        $("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").remove();
      }
      $(this).trigger("capture_coins")
      $(this).remove();
    }
  });
}

function applyMagnets(){
  $("#board .magnet").each(function(){
    if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
      $("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").addClass('magnetized').removeClass('lockable');
      $(this).remove();
    }
  });
}

function applyBombs(){
  $("#board .bomb").each(function(){
    var explodeBomb = false;
    var bomb_cell = $(this).attr('_cell').split(',');
    //check each of the adjacent squares
    bomb_cell[0] = parseInt(bomb_cell[0]);
    bomb_cell[1] = parseInt(bomb_cell[1]);
    check_cells = [
      [(bomb_cell[0] - 1),(bomb_cell[1])],
      [(bomb_cell[0]),(bomb_cell[1] + 1)],
      [(bomb_cell[0] + 1),(bomb_cell[1])],
      [(bomb_cell[0]),(bomb_cell[1] - 1)]
    ];
    for(x in check_cells){
      if($("#board ."+$(this).attr("_color")+".falling[_cell='"+check_cells[x]+"']").length || $("#board ."+$(this).attr("_color")+".floating[_cell='"+check_cells[x]+"']").length){
        explodeBomb = true;
      }
    }
    if(explodeBomb){
      bombsExploding++;
      //flash the bomb several times
      $(this).switchClass("notflashing","flashing",200,"linear",function(){
        $(this).switchClass("flashing","notflashing",200,"linear", function(){
          $(this).switchClass("notflashing","flashing",200,"linear", function(){
            $(this).switchClass("flashing","notflashing",200,"linear", function(){
              $(this).switchClass("notflashing","flashing",200,"linear", function(){
                $(this).switchClass("flashing","notflashing",200,"linear", function(){
                  $(this).switchClass("notflashing","flashing",200,"linear", function(){
                    $(this).switchClass("flashing","notflashing",200,"linear", function(){
                      //remove the bomb and any adjacent cells
                      var bomb_cell_to_explode = $(this).attr('_cell').split(',');
                      bomb_cell_to_explode[0] = parseInt(bomb_cell[0]);
                      bomb_cell_to_explode[1] = parseInt(bomb_cell[1]);
                      check_cells_to_explode = [
                        [(bomb_cell_to_explode[0] - 1),(bomb_cell_to_explode[1])],
                        [(bomb_cell_to_explode[0]),(bomb_cell_to_explode[1] + 1)],
                        [(bomb_cell_to_explode[0] + 1),(bomb_cell_to_explode[1])],
                        [(bomb_cell_to_explode[0]),(bomb_cell_to_explode[1] - 1)]
                      ];
                      for(x in check_cells_to_explode){
                        $("#board .game-piece[_cell='"+check_cells_to_explode[x]+"']").fadeOut();
                      }
                      $(this).fadeOut(function(){
                        bombsExploding--;
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    }
  });
}
