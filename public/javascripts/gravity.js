var degree = 0;
var max_x = 0;
var max_y = 0;
var pieces_moved = false;
var settling = false;

$(document).ready(function(){
	max_x = parseInt($("#board table tr").length);
	max_y = parseInt($("#board table tr").length);
	setUpPieces();
	$("#level-rotate-buttons p.rotate").click(function(){
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

function applyGravity(){
  if (level_js_status != 'gameplay' && !gravity_turned_on) {
    return false;
  }
	var cell = [0,0];
	var bottom_cell = [0,0];
	var change_row = [0,0];
	var change_col = [0,0];
	var empty_cell = [0,0];
	cell = [max_x,1];
	change_row = [-1,0];
	change_col = [0,1];
	$("#pos").val(getPosition())
	var i = 0;
	var cell_order = '';
	for(i=0;i<max_y;i++){
		//iterate through each column
		bottom_cell = cell.slice(0);
		empty_cell = [0,0];
		var j = 0;
		for(j=0;j<max_x;j++){
			cell_order = cell_order + cell + ' | ';
			//iterate through each row in the column
			//check to see if this cell is empty
			if($("#board .game-piece[_cell='"+cell+"']").length < 1 && $("#board .station[_cell='"+cell+"']").length < 1){
				//this cell is empty
				if(empty_cell == '0,0'){
					//set the new empty cell
					empty_cell = cell.slice(0);
				}
			}else{
				//check for fixed
				if($("#board #game-pieces .fixed[_cell='"+cell+"']").length){
					empty_cell = [0,0];
				}
				//check for locked
				if($("#board #game-pieces .locked[_cell='"+cell+"']").length){
					empty_cell = [0,0];
				}
				//check for floating
				if($("#board #game-pieces .floating[_cell='"+cell+"']").length){
					empty_cell = [0,0];
				}
				//check for station
				if($("#board #game-pieces .station[_cell='"+cell+"']").length){
					if(!$("#board #game-pieces .game-piece[_cell='"+cell+"']").length){
						empty_cell = cell.slice(0);
					}
				}
				//check for bomb
				if($("#board #game-pieces .bomb[_cell='"+cell+"']").length){
					empty_cell = [0,0];
				}
				//check for magnetized
				if($("#board #game-pieces .magnetized[_cell='"+cell+"']").length){
					empty_cell = [0,0];
				}
				//falling blocks
				if($("#board #game-pieces .falling[_cell='"+cell+"']").length){
					if(empty_cell != '0,0'){
						$("#board #game-pieces .falling[_cell='"+cell+"']").each(function(){
							if(!$(this).hasClass('locked') && !$(this).hasClass('magnetized')){
								$(this).animate({
									left: $(".square[_cell='"+empty_cell+"']").position().left+'px',
									top: $(".square[_cell='"+empty_cell+"']").position().top+'px'
								}).attr('_cell', empty_cell).attr('_just_teleported','false');
								pieces_moved = true;
								cell[0] = empty_cell[0] + 1;
								j = max_x - cell[0];
								empty_cell = [0,0];
							}
						});
						$('#empty-cell').val(empty_cell);
						//empty_cell = cell.slice(0);
					}
				}
			}
			//move onto the next cell
			cell[0] = cell[0] + change_row[0];
			cell[1] = cell[1] + change_row[1];
		}
		//move onto the next column
		cell[0] = bottom_cell[0] + change_col[0];
		cell[1] = bottom_cell[1] + change_col[1];
	}
	//alert(cell_order);
	applyAntiGravity();
}

function applyAntiGravity(){
	if($("#board .game-piece").filter(":animated").length){
		//setTimeout('applyAntiGravity()',200);
		//return false;
	}
	var cell = [1,1];
	var change_row = [1,0];
	var change_col = [0,1];
	var top_cell = [0,0]
	var i = 0;
	var cell_order = '';
	var empty_cell = [0,0]
	for(i=0;i<max_y;i++){
		//iterate through each column
		top_cell = cell.slice(0);
		empty_cell = [0,0];
		var pieces_to_lift = [];
		var j = 0;
		for(j=0;j<max_x;j++){
			cell_order = cell_order + cell + ' | ';
			//iterate through each row in the column
			//check to see if this cell is empty
			if($("#board .game-piece[_cell='"+cell+"']").length < 1 && $("#board .station[_cell='"+cell+"']").length < 1){
				//this cell is empty
				if(empty_cell == '0,0'){
					//set the new empty cell
					empty_cell = cell.slice(0);
				}
			}else{
				//check for fixed
				if($("#board #game-pieces .fixed[_cell='"+cell+"']").length){
					empty_cell = [0,0];
					pieces_to_lift = [];
				}
				//check for locked
				if($("#board #game-pieces .locked[_cell='"+cell+"']").length){
					empty_cell = [0,0];
					pieces_to_lift = [];
				}
				//check for falling
				if($("#board #game-pieces .falling[_cell='"+cell+"']").length){
					if(!$("#board #game-pieces .falling[_cell='"+cell+"']").eq(0).hasClass('locked')){
						if(empty_cell != '0,0'){
							pieces_to_lift.push(cell.slice(0));
						}
					}
				}
				//check for station
				if($("#board #game-pieces .station[_cell='"+cell+"']").length){
					if(!$("#board #game-pieces .game-piece[_cell='"+cell+"']").length){
						empty_cell = cell.slice(0);
					}
				}
				//check for bomb
				if($("#board #game-pieces .bomb[_cell='"+cell+"']").length){
					empty_cell = [0,0];
					pieces_to_lift = [];
				}
				//check for magnetized
				if($("#board #game-pieces .magnetized[_cell='"+cell+"']").length){
					empty_cell = [0,0];
					pieces_to_lift = [];
				}
				//floating blocks
				if($("#board #game-pieces .floating[_cell='"+cell+"']").length){
					if(empty_cell != '0,0'){
						$("#board #game-pieces .floating[_cell='"+cell+"']").each(function(){
							if(!$(this).hasClass('locked') && !$(this).hasClass('magnetized')){
								//lift each of the pieces above
								for(x in pieces_to_lift){
									$("#board #game-pieces .falling[_cell='"+pieces_to_lift[x]+"']").animate({
										left: $(".square[_cell='"+empty_cell+"']").position().left+'px',
										top: $(".square[_cell='"+empty_cell+"']").position().top+'px'
									}).attr('_cell', empty_cell);
									empty_cell[0] = empty_cell[0] + change_row[0];
									empty_cell[1] = empty_cell[1] + change_row[1];
								}
								//pieces_to_lift = [];
								$(this).animate({
									left: $(".square[_cell='"+empty_cell+"']").position().left+'px',
									top: $(".square[_cell='"+empty_cell+"']").position().top+'px'
								}).attr('_cell', empty_cell).attr('_just_teleported','false');
								pieces_moved = true;
								empty_cell = cell.slice(0);
							}
						});
						$('#empty-cell').val(empty_cell);
						//empty_cell = cell.slice(0);
						//empty_cell = [0,0];
						//cell[0] = 0;
						//j = -1;
					}
				}
			}
			//move onto the next cell
			cell[0] = cell[0] + change_row[0];
			cell[1] = cell[1] + change_row[1];
		}
		//move onto the next column
		cell[0] = top_cell[0] + change_col[0];
		cell[1] = top_cell[1] + change_col[1];
	}
	//alert(cell_order);
	applyTeleport();
	
}

function applyTeleport(){
	if($("#board .game-piece").filter(":animated").length){
		setTimeout('applyTeleport()',200);
		return false;
	}
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
		applyPaint();
	}
}

function applyPaint(){
	$("#board .paint").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").removeClass($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").eq(0).attr("_color")).addClass($(this).attr('_color'));
			$(this).remove();
		}
	});
	applyGravitySwap();
}

function applyGravitySwap(){
	$("#board .gravity-swap").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").toggleClass('falling').toggleClass('floating');
			pieces_moved = true;
			$(this).remove();
		}
	});
	applyCoins();
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
	applyMagnets();
}

function applyMagnets(){
	$("#board .magnet").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").addClass('magnetized').removeClass('lockable');
			$(this).remove();
		}
	});
	applyBombs();
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
  $("#board").trigger("gravity_done");
}
