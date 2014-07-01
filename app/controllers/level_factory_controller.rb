class LevelFactoryController < ApplicationController
  before_filter :require_login

  def new
    @title = "Level Factory"
    @level = Level.new(:collection_id => '0', :published => false, :grid_size => 4)
  end

  def save
    response = Hash.new
    if params[:level_publish] === 'true' && publish_level_coin_cost > current_user.coins
      response["type"] = "error"
      response["msg"] = "not enough coins"
      render :json => response.to_json and return
    end
    params[:pieces] = Array.new if params[:pieces].nil?
    params[:pieces].each do |piece_info|
      piece_info = piece_info[1]
      page_not_found unless LevelElement.find_by_name(piece_info["piece"]).usable_by_user?(current_user)
    end
    if params[:level_id] == 'new'
      response["action"] = 'create'
      level = current_user.levels.create(:collection_id => 0, :grid_size => params[:grid_size], :published => false, :number => (Level.where(:collection_id => 0).first.nil? ? 1 : Level.where(:collection_id => 0).order("number DESC").first.number + 1))
    else
      response["action"] = 'update'
      level = Level.find(params[:level_id])
    end
    page_not_found unless current_user.can_edit_level?(level)
    level.grid_size = params[:grid_size]
    level.name = params[:level_name]
    level.description = params[:level_description]
    level.published = params[:level_publish]
    level.save
    if level.published?
      current_user.remove_coins(publish_level_coin_cost)
      current_user.coin_transactions.create!({:amount => 0 - publish_level_coin_cost, :transaction_type => 'Publish', :note => "Published Level: #{level.name}"})
    end
    response["level_id"] = level.id
    response["level_name"] = level.name
    response["level_factory_path"] = edit_level_factory_path(:id => level.id)
    response["published"] = level.published
    response["level_factory_index_path"] = level_factory_path
    response["publish_level_coin_cost"] = publish_level_coin_cost
    active_pieces = Array.new
    params[:pieces].each do |piece_info|
      piece_info = piece_info[1]
      piece = level.game_pieces.where(:id => piece_info["id"]).first || level.game_pieces.build()
      piece.cell = piece_info["cell"]
      piece.piece = piece_info["piece"]
      piece.piece_type = piece_info["piece_type"]
      active_meta_data = Array.new
      #update/add attributes
      unless piece_info["attributes"].nil?
        piece_info["attributes"].each do |attribute, value|
          if game_piece_valid_attributes.include?(attribute)
            md = piece.meta_data.find_by_key("_#{attribute}") || piece.meta_data.build(:key => "_#{attribute}")
            md.value = value
            active_meta_data.push md.id
          end
        end
      end
      #update/add classes
      unless piece_info["classes"].nil?
        piece_info["classes"].each do |md_class|
          md_class = "lockable" if md_class == "lockable-disabled"
          if game_piece_valid_classes.include? md_class
            md = piece.meta_data.find_by_key_and_value("class",md_class) || piece.meta_data.build(:key => "class", :value => md_class)
            active_meta_data.push md.id
          end
        end
      end
      #destroy unused classes/attributes
      piece.meta_data.each do |md|
        md.mark_for_destruction unless active_meta_data.include? md.id
      end
      #save the piece and all metadata
      piece.save
      active_pieces.push piece
    end
    #remove unused game pieces
    level.game_pieces.each do |piece|
      piece.destroy unless active_pieces.include? piece
    end
    render :json => response.to_json
  end

  def edit
    @title = "Level Factory"
    @level = Level.find(params[:id])
    page_not_found unless current_user.can_edit_level?(@level)
  end

  def index
    @title = "Level Factory"
    @levels = current_user.levels.where(:collection_id => 0)
  end
end
