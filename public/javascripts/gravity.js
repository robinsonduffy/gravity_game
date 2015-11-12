var degree = 0;
var max_x = 0;
var max_y = 0;
var pieces_moved = false;
var settling = false;
var table_settling = false;

$(document).ready(function(){
	max_x = parseInt($("#board table tr").length);
	max_y = parseInt($("#board table tr").length);
	setUpPieces();
	$("#level-rotate-buttons p.rotate").click(function(){
    console.log("Table Settling: " + table_settling);
    console.log("Settling: " + settling);
		if(!settling){
      settling = true;
			rotate(this.id);
		}
	});
  $("#board").on("click","div.lockable", function(){
		if(!settling && !$(this).hasClass('magnetized')){
			$(this).toggleClass("locked");
			afterRotate();
		}
	});
});

function afterRotate(){
	//CHECK TO SEE IF THE BOARD IS DONE BEING REARRANGED
	if($("#board #game-pieces div[_moved='no']").length > 0){
		setTimeout('afterRotate()',100);
		return false;
	}else{
		settling = true;
		$("#board").css('visibility','visible');
		$("#board-clone").remove();
		pieces_moved = false;
		applyGravity();
	}
}

function rotate(direction){
  $("#board").trigger("rotate");
	switch(direction){
		case 'counter-clock-wise':
			degree = -90;
			rotate_degree = -90;
			break;
		case 'clock-wise':
			degree = 90;
			rotate_degree = 90;
			break;
	}
	$("#board").clone().attr('id','board-clone').appendTo($("#board-wrapper"));
	$("#board").css('visibility','hidden');
	rearrangeBoard();
	$("#board-clone").animate(
		{
			rotate: rotate_degree
		},
		{
			complete: function(){
				afterRotate();
			}
		}
	);
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
	afterRotate();
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
	if($("#board .game-piece").filter(":animated").length){
		setTimeout('moveAllPiecesByOne()',10);
		return false;
	}
  table_settling = false;
  $("#board #game-pieces div").removeClass('already-moved');
  for(i=1; i<=max_y; i++){
    column_settling = true;
    while(column_settling){
      column_settling = false;
      //go through each cell in the column
      for(j=1; j<=max_x; j++){
        
        var cell = [j,i]
        console.log(cell);
        
        //check for falling block
        if($("#board #game-pieces .falling[_cell='"+cell+"']").length){
          var this_game_piece = $("#board #game-pieces .falling[_cell='"+cell+"']").eq(0);
          if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized') && !this_game_piece.hasClass('already-moved')){
            if(isCellAvailable([j+1,i])){
              this_game_piece.attr('_cell', [j+1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
	              left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
		            top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
	            }, {
                duration : 100,
                easing : "linear"
	            });
              column_settling = true;
              table_settling = true;
            }
          }
        }
        
        //check for floating block
        if($("#board #game-pieces .floating[_cell='"+cell+"']").length){
          var this_game_piece = $("#board #game-pieces .floating[_cell='"+cell+"']").eq(0);
          if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized') && !this_game_piece.hasClass('already-moved')){
            //if the space above is available, put it there
            if(isCellAvailable([j-1,i])){
              this_game_piece.attr('_cell', [j-1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
	              left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
		            top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
	            }, {
                duration : 100,
                easing : "linear"
	            });
              column_settling = true;
              table_settling = true;
            }else{
              //go up through the pieces until you find a space that doesn't have a falling piece
              console.log("I got here: "+ cell);
              current_cell_x = j + 0;
              found_nonfalling_cell = false;
              while(current_cell_x > 1 && !found_nonfalling_cell){
                current_cell_x--;
                current_cell = [current_cell_x,i]
                console.log("Check for non_falling: " + current_cell);
                if(isCellAvailable(current_cell)){
                  console.log("isCellAvaialable: " + current_cell);
                  found_nonfalling_cell = true;
                }else{
                  console.log("Here I am: " + current_cell);
                  found_nonfalling_cell = ($("#board #game-pieces .game-piece[_cell='"+current_cell+"']").not(".falling").length || $("#board #game-pieces .locked[_cell='"+current_cell+"']").length || $("#board #game-pieces .magnetized[_cell='"+current_cell+"']").length)
                }
                
              }
              if(current_cell_x > 0){
                //go down moving pieces up into available cells
                while(current_cell_x < j){
                  current_cell_x++;
                  current_cell = [current_cell_x,i];
                  console.log("Hello");
                  var this_game_piece = $("#board #game-pieces .floating[_cell='"+current_cell+"'], #board #game-pieces .falling[_cell='"+current_cell+"']").eq(0);
                  if(!this_game_piece.hasClass('locked') && !this_game_piece.hasClass('magnetized')){
                    //if the space above is available, put it there
                    if(isCellAvailable([current_cell_x-1,i])){
                      this_game_piece.attr('_cell', [current_cell_x-1,i]).attr('_just_teleported','false').addClass('already-moved').animate({
      		              left: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().left+'px',
      			            top: $(".square[_cell='"+this_game_piece.attr('_cell')+"']").position().top+'px'
      		            }, {
                        duration : 100,
                        easing : "linear"
      		            });
                      column_settling = true;
                      table_settling = true;
                    }
                  }
                }
              }
            }
          }
        }

      }
    }
    $(":animated").promise().done(function() {
      applyTeleports();
      applyCoins();
      if(table_settling){
        moveAllPiecesByOne();
      }
    });
  }
}

function applyGravity(){
  if (level_js_status != 'gameplay' && !gravity_turned_on) {
    return false;
  }
  
  var next_queue_num = 1;
  moveAllPiecesByOne();
  console.log("Table settled");
  settling = false;
}

function applyTeleports(){
	var teleported = false;
	$('#board .station.teleport').each(function(){
		if(!teleported){
			var teleport_entrance_cell = $(this).attr('_cell');
			var teleport_exit_cell = $(this).attr('_teleport_exit_cell');
			if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
				//CHECK TO SEE IF THE PIECE HAS ALREAY BEEN TELEPORTED
				if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").attr('_just_teleported') != "true"){
					//TODO: CHECK TO SEE IF THE EXIT IS FREE
					if($("#board .game-piece[_cell='"+teleport_exit_cell+"']").length == 0){
						//TELEPORT
						teleported = true;
						$("#board .game-piece[_cell='"+teleport_entrance_cell+"']").fadeOut(function(){
							$("#board .game-piece[_cell='"+teleport_entrance_cell+"']").css({
								left: $("#board .square[_cell='" + teleport_exit_cell + "']").position().left+'px',
								top: $("#board .square[_cell='"+ teleport_exit_cell + "']").position().top+'px'
							}).attr('_cell', teleport_exit_cell).attr('_just_teleported','true').fadeIn(function(){
								afterRotate();
							});
						});
					}
				}
			}
		}
	});
	if(!teleported){
		//applyPaint();
	}
}

function applyPaint(){
	$("#board .paint").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").removeClass($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").eq(0).attr("_color")).addClass($(this).attr('_color'));
			$(this).remove();
		}
	});
	//applyGravitySwap();
}

function applyGravitySwap(){
	$("#board .gravity-swap").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").toggleClass('falling').toggleClass('floating');
			pieces_moved = true;
			$(this).remove();
		}
	});
	//applyCoins();
}

function applyCoins(){
	$("#board .coin").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			if($(this).hasClass("destructive")){
				$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").remove();
			}
      $(this).trigger("capture_coins")
      $(this).remove();
      pieces_moved = true;
		}
	});
	//applyMagnets();
}

function applyMagnets(){
	$("#board .magnet").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").addClass('magnetized').removeClass('lockable');
			$(this).remove();
		}
	});
	//applyBombs();
}

function applyBombs(){
	if(pieces_moved){
		afterRotate();
		return false;
	}
	if($("#board .game-piece").filter(":animated").length){
		setTimeout('applyTeleport()',200);
		return false;
	}
	$("#board .bomb").each(function(){
		var exploded = false;
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
				exploded = true;
			}
		}
		if(exploded){
			pieces_moved = true;
			for(x in check_cells){
				$("#board ."+$(this).attr("_color")+".falling[_cell='"+check_cells[x]+"']").remove();
				$("#board ."+$(this).attr("_color")+".floating[_cell='"+check_cells[x]+"']").remove();
			}
			$(this).remove();
		}
	});
  //$("#board").trigger("gravity_done");
}
