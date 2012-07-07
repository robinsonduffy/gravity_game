var degree = 0;
var max_x = 0;
var max_y = 0;
var pieces_moved = false;
var settling = false;
var rotations = 0;
var weighted_rotations = 0; //the rotations weighted with the number of locks
var locks = 0;
var coins = 0;
var liveScore = 0;
var possibleCoins = 0;
var possibleLocks = 0;
$(document).ready(function(){
	max_x = parseInt($("#board table tr").length);
	max_y = parseInt($("#board table tr").length);
	possibleCoins = getPossibleCoins();
	possibleLocks = $("#board .lockable").length;
	setUpPieces();
	$("#nav p.rotate").click(function(){
		if(!settling){
			rotate(this.id);
		}
	});
	$("#board .lockable").click(function(){
		if(!settling && !$(this).hasClass('magnetized')){
			$(this).toggleClass("locked");
			afterRotate();
		}
	});
	$("#nav #reload-level a").click(function(){
	  $("#alert-popup-ok").click(function(){
	    window.location = $("#reload-level a").attr('href');
	  });
	  $("#alert-popup h3").html("Are you sure you want to restart this level?")
		$("#popup-content #startup-popup").hide();
    $("#popup-content #alert-popup").show();
    $("#popup-close-button").hide();
    popupLock = true;
    centerPopup(); 
	  loadPopup();
	  return false;
	});
	$("#nav #cancel-level a").click(function(){
	  $("#alert-popup-ok").click(function(){
	    window.location = $("#cancel-level a").attr('href');
	  });
	  $("#alert-popup h3").html("Are you sure you want to quit this level?")
		$("#popup-content #startup-popup").hide();
    $("#popup-content #alert-popup").show();
    $("#popup-close-button").hide();
    popupLock = true;
    centerPopup(); 
	  loadPopup();
	  return false;
	});
	$("#level-popup").click(function(){
	  $("#popup-content #startup-popup").show();
    $("#popup-content #alert-popup").hide();
    $("#popup-close-button").show();
    popupLock = false;
	  centerPopup(); 
	  loadPopup();
	});
	$("#alert-popup-cancel").click(function(){
    popupLock = false;
    disablePopup();
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
	rotations++;
	weighted_rotations = weighted_rotations + 1 + Math.ceil($("#board .locked").length / 2);
	$("#current-rotations .stat-value").html(rotations);
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
	var colors = ['red','green'];
	$("#board .paint").each(function(){
		if($("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").length){
			for(x in colors){
				$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").removeClass(colors[x]);
			}
			$("#board .game-piece[_cell='"+$(this).attr('_cell')+"']").addClass($(this).attr('_paint_color'));
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
			$(this).remove();
			coins = coins + parseInt($(this).attr('_coin_value'),10);
			$("#current-coins .stat-value span").html(coins);
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
			if($("#board ."+$(this).attr("_bomb_color")+".falling[_cell='"+check_cells[x]+"']").length || $("#board ."+$(this).attr("_bomb_color")+".floating[_cell='"+check_cells[x]+"']").length){
				exploded = true;
			}
		}
		if(exploded){
			pieces_moved = true;
			for(x in check_cells){
				$("#board ."+$(this).attr("_bomb_color")+".falling[_cell='"+check_cells[x]+"']").remove();
				$("#board ."+$(this).attr("_bomb_color")+".floating[_cell='"+check_cells[x]+"']").remove();
			}
			$(this).remove();
		}
	});
	checkSuccess();
}

function checkSuccess(){
	if(pieces_moved){
		afterRotate();
		return false;
	}else{
		var goals_reached = 0;
		settling = false;
		locks = $("#board .locked").length;
		tallyLiveScore();
		$("#current-locks .stat-value span").html(locks);
		$('#board .goal').each(function(){
			if($("#board .game-piece."+$(this).attr('_goal_color')+"[_cell='"+$(this).attr('_cell')+"']").length){
				goals_reached++;
			}
		});
		if(goals_reached == $("#board .goal").length){
			setTimeout('triggerSuccess()',1000);
		}
	}
}

function triggerSuccess(){
	$("#nav p").css('visibility', 'hidden');
	$.ajax({
		type: "POST",
		url : '/ajax/complete_level',
		data : {
			r : rotations,
			w : weighted_rotations,
			l : locks,
			c : coins
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

function tallyScore(scoreInfo){
  $("#popup-content #startup-popup").hide();
  $("#popup-content #score-tally-popup").show();
  $("#popup-close-button").hide();
  popupLock = true;
  centerPopup();
  loadPopup();
  $("#tally-detail-rotations .tally-detail-value").html(rotations).fadeIn(1000, function(){
    $("#tally-detail-locks .tally-detail-value").html(locks + ' / ' + possibleLocks).fadeIn(1000, function(){
      $("#tally-detail-coins .tally-detail-value").html(coins + ' / ' + possibleCoins).fadeIn(1000, function(){
        $("#tally-score-value").html(scoreInfo.score).fadeIn(1000, function(){
          if(scoreInfo.score_best == 'true'){
            $("#honors p").html("This is the best score for this level...ever!").addClass("honor-msg");
          }else if(scoreInfo.score_personal_best == 'true'){
            $("#honors p").html("This is your personal best score for this level!").addClass("honor-msg");
          }
        });
      });
    });
  });
}

function tallyLiveScore(){
  if(possibleCoins > 0){
    liveScore = Math.ceil(((1 - (coins / possibleCoins)) * 50) + (weighted_rotations * 2))
  }else{
    liveScore = Math.ceil((weighted_rotations * 2))
  }
  $("#user-current-stats .top-score").html(liveScore);
}

function getPossibleCoins(){
  totalCoinValue = 0;
  $("#board .coin").each(function(){
    totalCoinValue = totalCoinValue + parseInt($(this).attr('_coin_value'),10);
  })
  return totalCoinValue;
}