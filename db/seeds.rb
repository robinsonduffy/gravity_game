# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

LevelElement.find_or_create_by_name_and_description("goal", "The target to reach.")
LevelElement.find_or_create_by_name_and_description("fixed", "A permanently fixed piece.")
LevelElement.find_or_create_by_name_and_description("falling", "A piece that falls to the bottom.")
LevelElement.find_or_create_by_name_and_description("floating", "A piece that floats to the top.")
LevelElement.find_or_create_by_name_and_description("coin", "Optional goals to collect.")
LevelElement.find_or_create_by_name_and_description("bomb", "Destructive blocks triggered by contact with specifically-colored pieces.")
LevelElement.find_or_create_by_name_and_description("paint", "Changes the color of falling or floating pieces.")
LevelElement.find_or_create_by_name_and_description("gravity-swap", "Changes falling to floating pieces and vis a versa.")
LevelElement.find_or_create_by_name_and_description("magnet", "Permanently locks falling or floating pieces.")
LevelElement.find_or_create_by_name_and_description("teleport", "Transports pieces across the board.")
LevelElement.find_or_create_by_name_and_description("gate", "A piece that blocks all but moving pieces of a certain color.")
User.create({:username => "test_user", :email => "user@example.com", :password => "123456", :password_confirmation => "123456"})

# Collection 1
c = Collection.new({:number => 1, :name => 'The Basics 1'})
l = c.levels.build({:number => 7, :grid_size => 6})
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => '_color', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => '_color', :value => 'red'})
gp = l.game_pieces.build({:cell => '1,1', :piece_type => 'game-piece', :piece => 'floating'})
gp.meta_data.build({:key => 'class', :value => 'floating'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '1,6', :piece_type => 'game-piece', :piece => 'floating'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => 'class', :value => 'floating'})
gp = l.game_pieces.build({:cell => '6,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '6,6', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'station', :piece => 'coin'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'coin'})
gp.meta_data.build({:key => '_coin_value', :value => '10'})
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'station', :piece => 'coin'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => '_coin_value', :value => '5'})
gp.meta_data.build({:key => 'class', :value => 'coin'})
l = c.levels.build({:number => 3, :grid_size => 4})
l.meta_data.build({:key => 'popup', :value => '<h1>Color Matters</h1> <p style="clear:both float:left">To finish a level, all the goals must be matched up with a game piece of the same color all at the same time.</p>'})
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp.meta_data.build({:key => '_color', :value => 'green'})
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => '_color', :value => 'red'})
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
l = c.levels.build({:number => 6, :grid_size => 4})
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => '_color', :value => 'red'})
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp.meta_data.build({:key => '_color', :value => 'green'})
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'red'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
l = c.levels.build({:number => 5, :grid_size => 4})
l.meta_data.build({:key => 'popup', :value => '<h1>Defying Gravity</h1> <p style="clear:both float:left"><span style="float:left margin-right:10px background-image:url(../imgs/table-8/sprite.png) background-repeat:no-repeat width:59pxheight: 59px background-position:-59px -295px"></span>Some game pieces defy gravity. The colored circles float instead of fall. They are even strong enough to lift other blocks with them.</p>'})
gp = l.game_pieces.build({:cell => '2,2', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => '_color', :value => 'green'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp = l.game_pieces.build({:cell => '1,2', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'purple'})
gp.meta_data.build({:key => '_color', :value => 'purple'})
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '1,3', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'purple'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '2,3', :piece_type => 'game-piece', :piece => 'floating'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'floating'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
l = c.levels.build({:number => 4, :grid_size => 4})
l.meta_data.build({:key => 'popup', :value => '<h1>Locks</h1> <p style="clear:both float:left"><span style="float:left margin-right:10px background-image:url(../imgs/table-8/sprite.png) background-repeat:no-repeat width:59pxheight: 59px background-position:-177px -236px"></span>Game pieces can be locked in place so that they aren\'t affected by gravity. Click on a game piece to lock or unlock it.</p> <p style="clear:both floatleft">Use locks sparingly as they make your score go up (especially any pieces that are still locked when you finish the level).</p>'})
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => '_color', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'orange'})
gp.meta_data.build({:key => '_color', :value => 'orange'})
gp = l.game_pieces.build({:cell => '1,3', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '2,3', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '2,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'orange'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'locked'})
gp = l.game_pieces.build({:cell => '1,1', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
l = c.levels.build({:number => 2, :grid_size => 4})
l.meta_data.build({:key => 'popup', :value => '<h1>Coins</h1> <p style="clear:both float:left"><span style="float:left margin-right:10px background-image:url(../imgs/table-8/sprite.png) background-repeat:no-repeat width:59pxheight: 59px background-position:-59px -118px"></span>Get a game piece to pass through the coins to pick them up. The different colored coins have different values. Collecting coins improves your score.</p>'})
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => '_color', :value => 'blue'})
gp = l.game_pieces.build({:cell => '1,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '2,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'station', :piece => 'coin'})
gp.meta_data.build({:key => 'class', :value => 'coin'})
gp.meta_data.build({:key => 'class', :value => 'green'})
gp.meta_data.build({:key => '_coin_value', :value => '10'})
l = c.levels.build({:number => 1, :grid_size => 4})
l.meta_data.build({:key => 'popup', :value => '<h1>Gravity...Friend AND Foe</h1> <p><img src="/imgs/table-8/goal-blue.gif" align="left" style="margin-right:10px">Your object is to get the colored game pieces to come to rest in a corresponding goal.</p> <p style="clear:both float:left"><img src="/imgs/shared/counterclockwise.png" align="left"><img src="/imgs/shared/clockwise.png" align="left" style="padding-right:10px">Use these buttons to rotate the game board one-quarter turn either direction. The fewer rotations the lower your score. Try to get the lowest score possible</p> <p style="clear:both float:left"><span style="float:left margin-right:10px background-image:url(../imgs/table-8/sprite.png) background-repeat:no-repeat width:59pxheight: 59px background-position:0px -177px"></span>Gravity makes the square colored pieces fall.</p>'})
gp = l.game_pieces.build({:cell => '2,1', :piece_type => 'goal', :piece => 'goal'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
gp.meta_data.build({:key => '_color', :value => 'blue'})
gp = l.game_pieces.build({:cell => '1,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '1,3', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '1,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'game-piece', :piece => 'fixed'})
gp.meta_data.build({:key => 'class', :value => 'fixed'})
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'game-piece', :piece => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'falling'})
gp.meta_data.build({:key => 'class', :value => 'lockable'})
gp.meta_data.build({:key => 'class', :value => 'blue'})
c.save

# Collection 2
c = Collection.new({:number => 2, :name => 'The Basics 2'});
l = c.levels.build({:number => 1, :grid_size => 5, :bonus_time_limit => 60000});
l.meta_data.build({:key => 'popup', :value => '<h1>Paint Brushes</h1><p>Paint Brush pieces change the color of the first falling or floating piece that passes through them.</p><p>The colored dot in the middle of the paint brush piece determines what color the piece will change to.</p><p>Hint: watch out for teleports that create infinite loops!</p>'});
gp = l.game_pieces.build({:cell => '2,2', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '4,4'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '2,4'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'station', :piece => 'paint'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
l = c.levels.build({:number => 2, :grid_size => 5, :bonus_time_limit => 60000});
gp = l.game_pieces.build({:cell => '1,1', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'red'});
gp = l.game_pieces.build({:cell => '5,1', :piece_type => 'game-piece', :piece => 'floating'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'orange'});
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '5,5', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '4,5', :piece_type => 'station', :piece => 'paint'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '3,5', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '5,4'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '5,4', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '3,5'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
l = c.levels.build({:number => 3, :grid_size => 5, :bonus_time_limit => 60000});
gp = l.game_pieces.build({:cell => '1,1', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '4,5', :piece_type => 'station', :piece => 'paint'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '1,2', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '3,1'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '1,2'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '5,1', :piece_type => 'game-piece', :piece => 'floating'});
gp.meta_data.build({:key => '_color', :value => 'red'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
l = c.levels.build({:number => 5, :grid_size => 5, :bonus_time_limit => 60000});
l.meta_data.build({:key => 'popup', :value => '<h1>Teleports</h1><p>Use telports to immediately move pieces across the board.</p><p>Teleports always come in matching pairs.  The color of the teleports show which teleports are linked together.</p>'});
gp = l.game_pieces.build({:cell => '5,1', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'yellow'});
gp = l.game_pieces.build({:cell => '1,5', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp = l.game_pieces.build({:cell => '5,2', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '1,4', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '2,3'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '2,3', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '4,1'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '2,5', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '4,3'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '2,5'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '5,3', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'yellow'});
gp = l.game_pieces.build({:cell => '1,3', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
l = c.levels.build({:number => 6, :grid_size => 4, :bonus_time_limit => 60000});
l.meta_data.build({:key => 'popup', :value => '<h1>Magnets</h1>If a floating or falling piece moves onto a square with a magnet, it will be locked there permanently.</p>'});
gp = l.game_pieces.build({:cell => '3,1', :piece_type => 'station', :piece => 'magnet'});
gp = l.game_pieces.build({:cell => '2,1', :piece_type => 'station', :piece => 'coin'});
gp.meta_data.build({:key => '_coin_value', :value => '25'});
gp.meta_data.build({:key => '_color', :value => 'red'});
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '4,1', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'station', :piece => 'magnet'});
gp = l.game_pieces.build({:cell => '2,2', :piece_type => 'station', :piece => 'magnet'});
l = c.levels.build({:number => 4, :grid_size => 6, :bonus_time_limit => 60000});
l.meta_data.build({:key => 'popup', :value => '<h1>Tricky Teleports</h1><p>Here\'s a hint for you...if a teleport exit is blocked by a piece, other pieces will pass right through the entrance.</p>'});
gp = l.game_pieces.build({:cell => '3,3', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp = l.game_pieces.build({:cell => '4,4', :piece_type => 'goal', :piece => 'goal'});
gp.meta_data.build({:key => '_color', :value => 'yellow'});
gp = l.game_pieces.build({:cell => '3,4', :piece_type => 'station', :piece => 'coin'});
gp.meta_data.build({:key => '_coin_value', :value => '25'});
gp.meta_data.build({:key => '_color', :value => 'red'});
gp = l.game_pieces.build({:cell => '4,3', :piece_type => 'station', :piece => 'coin'});
gp.meta_data.build({:key => '_coin_value', :value => '25'});
gp.meta_data.build({:key => '_color', :value => 'red'});
gp = l.game_pieces.build({:cell => '2,4', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '4,5', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '5,3', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '3,2', :piece_type => 'game-piece', :piece => 'fixed'});
gp = l.game_pieces.build({:cell => '3,5', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '5,4'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '5,4', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '3,5'});
gp.meta_data.build({:key => '_color', :value => 'blue'});
gp = l.game_pieces.build({:cell => '4,2', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '2,3'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '2,3', :piece_type => 'station', :piece => 'teleport'});
gp.meta_data.build({:key => '_teleport_exit_cell', :value => '4,2'});
gp.meta_data.build({:key => '_color', :value => 'green'});
gp = l.game_pieces.build({:cell => '6,6', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => '_color', :value => 'purple'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
gp = l.game_pieces.build({:cell => '1,1', :piece_type => 'game-piece', :piece => 'falling'});
gp.meta_data.build({:key => '_color', :value => 'yellow'});
gp.meta_data.build({:key => 'class', :value => 'lockable'});
gp.meta_data.build({:key => 'class', :value => 'locked'});
c.save

