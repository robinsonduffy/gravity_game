$(document).ready(function(){
  $("#board").on("gravity_done", function(){
    if(pieces_moved){
      afterRotate();
      return false;
    }else{
      settling = false;
    }
  });

  $("#board").on("change",function(){
    disable_or_enable_teleport_drag();
    recolor_teleports();
  });

  $("#board").on("resize", function(){
    initialize_drop();
  });

  $("#grid-size").change(function(){
    new_grid_size = $(this).val();
    $("#board").css('visibility', 'hidden');
    rebuild_grid(new_grid_size);
    adjust_game_pieces_to_fit_grid(new_grid_size);
    $('#board-wrapper').removeClass().addClass('grid-size-'+new_grid_size);
    setUpPieces();
    $("#board").css('visibility', 'visible');
    $("#board").trigger("change");
  });

  $("#add-game-pieces").on("click","p.disabled",function(){
    //TODO:Allow users to purchase access to disabled level elements

  });

  $("input[name='mode']").change(function(){
    if($("input[name='mode']:checked").val() == 'play'){
      $("p.rotate").css('visibility','');
      $("#game-pieces div.lockable-disabled").removeClass("lockable-disabled").addClass("lockable");
      $("#factory-edit-controls").css('visibility','hidden');
      $("#game-pieces div").addClass('no-drag no-click');
      applyGravity();
    }else{
      $("p.rotate").css('visibility','hidden');
      $("#game-pieces div.lockable").removeClass("lockable").addClass("lockable-disabled");
      $("#factory-edit-controls").css('visibility','');
      $("#game-pieces div").removeClass('no-drag no-click');
    }
  });

  $("#game-pieces").on("dblclick",'div:not(.no-click)',function(){
    $(this).addClass('currently-being-configured');
    game_piece_info = $(".add-game-piece[data-game_piece='"+$(this).attr("_piece")+"']").data("game_piece_info")
    if(game_piece_info.configurable){
      $("#game-piece-dialog #save-game-piece").show();
      $("#game-piece-dialog #game-piece-config-options").show();
      $("#game-piece-config-options #color select").empty();
      if($(this).attr("_piece") == 'coin'){
        $("#game-piece-config-options #color label").html("Value");
        for(x in game_piece_info.colors){
          option = $("<option></option>");
          option.html(game_piece_info.color_values[game_piece_info.colors[x]]).val(game_piece_info.colors[x]);
          if(game_piece_info.colors[x] == $(this).attr("_color")){
            option.attr("selected", "selected");
          }
          option.appendTo("#game-piece-config-options #color select");
        }
      }else{
        $("#game-piece-config-options #color label").html("Color");
        for(x in game_piece_info.colors){
          option = $('<option></option>');
          option.html(game_piece_info.colors[x].toUpperCase()).val(game_piece_info.colors[x]);
          if(game_piece_info.colors[x] == $(this).attr("_color")){
            option.attr("selected", "selected");
          }
          option.appendTo("#game-piece-config-options #color select");
        }
      }
      if($(this).hasClass("lockable-disabled")){
        $("#game-piece-config-options #locked").show();
        if($(this).hasClass("locked")){
          $("#game-piece-config-options #locked input").attr("checked","checked");
        }else{
          $("#game-piece-config-options #locked input").removeAttr("checked");
        }
      }else{
        $("#game-piece-config-options #locked").hide();
      }
    }else{
      $("#game-piece-dialog #save-game-piece").hide();
      $("#game-piece-dialog #game-piece-config-options").hide();
    }
    $("#game-piece-dialog").dialog('open');
  });

  $("#game-piece-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    title: "Game Piece Settings",
    close: function(){
      $('.currently-being-configured').removeClass("currently-being-configured");
    }
  });

  $("#saving-dialog").dialog({
    autoOpen: false,
    modal: true,
    draggable: false,
    resizable: false,
    closeOnEscape: false,
    dialogClass: "dialog-no-title dialog-no-close"
  });

  $("#delete-game-piece").click(function(){
    $(".currently-being-configured").remove();
    $("#game-piece-dialog").dialog("close");
  });

  $("#save-game-piece").click(function(){
    piece = $(".currently-being-configured").eq(0);
    game_piece_info = $(".add-game-piece[data-game_piece='"+piece.attr("_piece")+"']").data("game_piece_info")
    old_color = piece.attr("_color");
    new_color = $("#game-piece-dialog #game-piece-config-options #color option:selected").val();
    piece.attr("_color", new_color).removeClass(old_color).addClass(new_color);
    if(piece.attr("_piece") == 'coin'){
      piece.attr("_coin_value", game_piece_info["color_values"][new_color]);
    }
    if(piece.hasClass("lockable-disabled")){
      if($("#game-piece-dialog #game-piece-config-options #locked input").prop("checked")){
        piece.addClass("locked");
      }else{
        piece.removeClass("locked");
      }
    }
    $("#game-piece-dialog").dialog("close");
  });

  $("#save-level").click(function(){
    $("#saving-dialog").dialog("open");
    var game_board_data = {}
    game_board_data.pieces = new Array();
    game_board_data.level_id = $("#board").data("level_id");
    game_board_data.grid_size = $("#grid-size").val();
    $("#game-pieces div").each(function(){
      piece = {}
      piece.cell = $(this).attr("_cell");
      piece.id = $(this).attr("_game_piece_id");
      piece.piece_type = $(this).attr("_piece_type");
      piece.piece = $(this).attr("_piece");
      piece.classes = $(this).attr("class").split(/\s+/);
      piece.attributes = {};
      if($(this).attr("_color")){
        piece.attributes.color = $(this).attr("_color");
      }
      if($(this).attr("_teleport_exit_cell")){
        piece.attributes.teleport_exit_cell = $(this).attr("_teleport_exit_cell");
      }
      if($(this).attr("_coin_value")){
        piece.attributes.coin_value = $(this).attr("_coin_value");
      }
      game_board_data.pieces.push(piece);
    });
    console.log(JSON.stringify(game_board_data));
    $.ajax({
      type: 'POST',
      url: '/level_factory/save',
      data: game_board_data,
      dataType: "json",
      success: function(data){
        console.log(data);
        if(data.action == 'create'){
          window.location = data.level_factory_path;
        }else if(data.action == 'update'){
          $("#saving-dialog").dialog("close");
        }
      }
    });
  });

  $("#revert-level").click(function(){
    confirm_dialog = $("<div></div>");
    confirm_dialog.append("<p>You will lose any unsaved changes.</p>")
    confirm_dialog.dialog({
      title: "Are You Sure?",
      modal: true,
      draggable: false,
      resizable: false,
      closeOnEscape: false,
      dialogClass: "dialog-no-close",
      buttons:{
        Yes: function(){
          window.location.reload();
        },
        No: function(){
          confirm_dialog.dialog("close").remove();
        }
      }
    });
  });

  $("#board").trigger("change");
  initialize_drag();
  initialize_drop();
  $("input[name='mode']").trigger("change");
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
  max_x = parseInt($("#board table tr").length);
  max_y = parseInt($("#board table tr").length);
  $("#board").trigger("resize");
}

function adjust_game_pieces_to_fit_grid(grid_size){
  $("#board #game-pieces div").addClass("adjust-grid-delete");
  //mark the pieces we are going to keep...
  for(var i=1; i <= grid_size; i++){
    for(var j=1; j <= grid_size; j++){
      $("#board #game-pieces div[_cell='"+i+","+j+"']").removeClass("adjust-grid-delete");
    }
  }
  //get rid of the rest...
  $("#board #game-pieces div.adjust-grid-delete").each(function(){
    $(this).remove();
    if($(this).hasClass("teleport")){
      //get rid of linked teleports
      $("div[_teleport_exit_cell='"+$(this).attr('_cell')+"']").remove();
    }
  });
}

function initialize_drag(){
  $("#add-game-pieces p.usable").draggable({
    zIndex: '1000',
    cancel: '.no-drag',
    helper: function(event){
      game_piece_info = $(this).data("game_piece_info")
      new_piece = $("<div></div>");
      new_piece.addClass(game_piece_info.piece_type).addClass($(this).data("game_piece"));
      new_piece.attr("_game_piece_id", "new").attr("_piece_type", game_piece_info.piece_type).attr("_piece", $(this).data("game_piece"));
      if(game_piece_info.lockable){
        new_piece.addClass('lockable-disabled');
      }
      if(game_piece_info.configurable){
        new_piece.addClass('init-config');
      }
      if($.inArray($(this).data("game_piece"),["falling","floating","goal","coin","bomb","paint"]) >= 0){
        //these elements are pre-assigned the first color in the list
        new_piece.addClass(game_piece_info.colors[0]).attr("_color",game_piece_info.colors[0]);
      }
      if($(this).data("game_piece") == 'teleport'){
        //select the next color automatically based on how many teleports there already are.
        num_of_teleports = $("#game-pieces .teleport").size();
        if(num_of_teleports % 2){
          num_of_teleports--;
        }
        teleport_color = num_of_teleports / 2;
        new_piece.addClass(game_piece_info.colors[teleport_color]).attr('_color', game_piece_info.colors[teleport_color]);
      }
      if($(this).data("game_piece") == 'coin'){
        new_piece.attr("_coin_value", game_piece_info.color_values[game_piece_info.colors[0]]);
      }
      console.log($(this).data("game_piece_info"));
      new_piece.appendTo("#game-pieces");
      return new_piece;
    }
  });

  $("#game-pieces div").draggable({
    zIndex: 1000,
    cancel: '.no-drag',
    revert: 'invalid',
    revertDuration: 100
  });
}

function initialize_drop(){
  $("#squares td").droppable({
    hoverClass: 'drag-and-drop-target-hover',
    //accept: $(":not[.bad-element]"),
    accept: function(){
      cell = $(this).attr("_cell");
      return $("#board #game-pieces div[_cell='"+cell+"']").length < 1
    },
    drop: function(event,ui){
      //is this block empty?
      cell = $(this).attr("_cell");
      if($("#board .game-piece[_cell='"+cell+"']").length < 1 && $("#board .station[_cell='"+cell+"']").length < 1){
        if(ui.helper != ui.draggable){
          console.log("new piece");
          new_piece = $(ui.helper).clone(true);
          $(ui.helper).remove();
          new_piece.removeClass("ui-draggable-dragging").css("z-index", '').appendTo("#game-pieces");
          new_piece.draggable({
            zIndex: 1000,
            cancel: '.no-drag',
            revert: 'invalid',
            revertDuration: 100
          });
        }else{
          console.log("Existing Piece");
          new_piece = ui.draggable;
        }
        new_piece.attr("_cell", cell)
        if(new_piece.hasClass("teleport")){
          //check to see if there is one or two teleports of this color
          if($("#game-pieces div.teleport."+new_piece.attr('_color')).length == 1){
            new_piece.removeAttr('_teleport_exit_cell');
          }else{
            new_piece.addClass('teleport_new_piece');
            $("#game-pieces div.teleport."+new_piece.attr('_color')+':not(.teleport_new_piece)').attr('_teleport_exit_cell', new_piece.attr('_cell'));
            new_piece.attr('_teleport_exit_cell',$("#game-pieces div.teleport."+new_piece.attr('_color')+':not(.teleport_new_piece)').attr('_cell'));
            new_piece.removeClass('teleport_new_piece');
          }
        }
        new_piece.css({
          left: $("#board .square[_cell='"+cell+"']").position().left+'px',
          top: $("#board .square[_cell='"+cell+"']").position().top+'px'
        });
        $("#board").trigger("change");
        if(new_piece.hasClass("init-config")){
          new_piece.trigger("dblclick");
          new_piece.removeClass("init-config");
        }
      }
    }
  });
}

function disable_or_enable_teleport_drag(){
  num_of_teleports = $("#game-pieces .teleport").size();
  if(num_of_teleports % 2){
    num_of_teleports--;
  }
  teleport_color = num_of_teleports / 2;
  game_piece_info = $("[data-game_piece=teleport]").data("game_piece_info");
  if(teleport_color >= game_piece_info.colors.length){
    $("[data-game_piece=teleport]").addClass('no-drag');
  }else{
    $("[data-game_piece=teleport]").removeClass('no-drag');
  }
}

function recolor_teleports(){
  var current_color = 0;
  game_piece_info = $("[data-game_piece=teleport]").data("game_piece_info");
  $("#game-pieces div.teleport").each(function(){
    if(!$(this).hasClass('already-changed-color')){
      old_color = $(this).attr('_color');
      $(this).addClass('already-changed-color');
      $(this).removeClass(old_color).addClass(game_piece_info.colors[current_color]).attr('_color',game_piece_info.colors[current_color]);
      $("#game-pieces div.teleport[_cell='"+$(this).attr('_teleport_exit_cell')+"']").addClass('already-changed-color').removeClass(old_color).addClass(game_piece_info.colors[current_color]).attr('_color',game_piece_info.colors[current_color]);
      current_color++;
    }
  });
  $("div.teleport.already-changed-color").removeClass('already-changed-color');
}