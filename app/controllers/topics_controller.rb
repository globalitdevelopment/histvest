class TopicsController < ApplicationController
  load_and_authorize_resource :only => [:index, :new, :create, :edit, :update, :destroy, :batch_actions]
  before_filter :authenticate_user!, :except => [:show, :get_topic_with_latlng, :show_topic_in_touch]
  before_filter :save_in_locations, :only => [:create, :update]

  # GET /topics
  # GET /topics.json
  def index        
	if params[:topic_report] && params[:topic_report][:descending] == "false"
	  @flag = true
	else
	  @flag = false
	end  	
	@topic_report = TopicReport.new(params[:topic_report]) do |scope|		
		if current_user.role.contributor?
			scope =	scope.where(user_id: current_user.id) 
		else
			scope =	scope.where(published: true)
		end
		scope
	end
	@under_moderation = Topic.where(:published=>false).count
  end

  def search_stats
	
	@from, @to = nil, nil
	if params[:st] == "1" && params[:period]
	  case params[:period].to_s
	  when 'last_24'
		@from = (Time.now - 1.day).strftime("%Y-%m-%d %H:%M")
		@to = Time.now.strftime("%Y-%m-%d %H:%M")
	  when 'this_week'
		@from = Date.today - (Date.today.cwday - 1)%7
		@to = @from + 6
	  when 'last_week'
		@from = Date.today - 7 - (Date.today.cwday - 1)%7
		@to = @from + 6      
	  when 'this_month'
		@from = Date.civil(Date.today.year, Date.today.month, 1)
		@to = (@from >> 1) - 1
	  when 'last_month'
		@from = Date.civil(Date.today.year, Date.today.month, 1) << 1
		@to = (@from >> 1) - 1            
	  end 
	  @from, @to = @to, @from if @from && @to && @from > @to          
	  @search_stat = SearchTopic.where("updated_at >= ? AND updated_at <= ?", @from,@to).order('view_count DESC').to_a
	elsif params[:st] == "2" && params[:period]      
	  @from = params[:period]+" "+params[:time]      
	  @to = Time.now.strftime("%Y-%m-%d %H:%M")
	  @search_stat = SearchTopic.where("updated_at >= ? AND updated_at <= ?", @from,@to).order('view_count DESC').to_a
	else
	  @search_stat = SearchTopic.order('view_count DESC')    
	end
  end

  def get_address_with_topic
	@locations = Topic.find(params[:topic]).locations.map{|l| [l.latitude, l.longitude, l.address]}
	respond_to do |format|        
	  format.json { render json: @locations }
	end
  end

  def show_topic_in_touch    
	@topic = Topic.find_by_id(params[:id])
	respond_to do |format|
	  format.html { render :layout => 'touch' }
	  format.json { render json: @topic }
	end
  end

  def get_topic_with_latlng
	location = Location.where(:latitude => params["lat"].to_f).last    
	if !location.nil?   
	  @topic = []
	  @title = location.topics.each do |t| 
		x = []
		if !t.title.nil? && !t.title.blank?
		  x << t.title
		else
		  x << "No title"
		end

		if !t.content.nil? && !t.content.blank?
		  x << t.content[0..150].html_safe
		else
		  x << "No content"
		end

		if !t.avatar.nil? && !t.avatar.avatar_img.nil? 
		 x << t.avatar.avatar_img.url(:thumb)
		else
		 x << image_path("no-image.png")
		end
		if !t.id.nil?
		  x << t.id
		end

		@topic << x
	  end
	  respond_to do |format|        
		format.json { render json: @topic }
	  end
	else  
	  @topic = ["","","No topic for this location"]    
	  respond_to do |format|        
		format.json { render json: @topic }
	  end
	end
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  	@topic_locations = []
	  @all_locations = Location.joins(:topics).merge(Topic.published).to_gmaps4rails do |location, marker|
      marker.infowindow render_to_string(:partial => "/welcome/infowindow", :locals => { :topics => location.topics })

      topic_belongs = false
      location.topics.each { |topic| topic_belongs = true if topic.to_param == params[:id] || topic.id.to_s == params[:id] }
      if topic_belongs
        marker.picture(picture: location.topics.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.topics.size}/6991FD/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png")
        marker.json(belongs_to_current_topic: true)
      else
        marker.picture(picture: location.topics.size > 1 ? "http://www.googlemapsmarkers.com/v1/#{location.topics.size}/FD7567/" : "http://www.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png")
        marker.json(belongs_to_current_topic: false)
      end
    end

    begin
      @topic = Topic.includes(:locations, :references).find params[:id]
      @topic = Topic.working_version(@topic) if !@topic.published and (params[:moderation].nil? or current_user.nil?)

      raise Exception.new if @topic.nil?
      raise Exception.new if !@topic.published and (params[:moderation].nil? or current_user.nil?)
    rescue Exception => e
      flash[:danger] = I18n.t('topics.topic_not_published')
      redirect_to Topic
      return
    end

    title @topic.title

    @frequent_searches = SearchTopic.where('created_at > ?',Time.now - 7.days).limit(10)
    @touch = touch?
    if @touch
      layout = false
      action = "show"
    else
      layout = "public"
      action = "show"
    end

    set_cache_buster
    
    respond_to do |format|
      format.html {render :layout => layout, :action => action }
      format.json { render json: @topic.to_json(:include => [:locations, :references]) }
    end
  end

  # GET /topics/new
  # GET /topics/new.json
  def new
	@topic = Topic.new
	@topic.locations.build
	@topic.references.build    
	respond_to do |format|
	  format.html # new.html.erb
	  format.json { render json: @topic }
	end
  end

  # GET /topics/1/edit
  def edit        
	@topic = Topic.find(params[:id])	
  end

  # POST /topics
  # POST /topics.json
  def create  
	@topic = Topic.new(params[:topic])    
	@topic.published = !(current_user.role.contributor?)
	@topic.user_id = current_user.id        
	respond_to do |format|
	  if @topic.save
		if params[:avatar] && params[:avatar][:avatar_img]
		  @avatar = Avatar.create(:avatar_img => params[:avatar][:avatar_img], :topic_id => @topic.id)
		end
		if params[:commit] == "Lagre"
      flash[:success] = I18n.t('topics.create_flash')
		  format.html { redirect_to edit_topic_path(@topic) }
		  format.json { render json: edit_topic_path(@topic), status: :created, location: @topic }
    else
      flash[:success] = I18n.t('topics.create_flash')
		  format.html { redirect_to topics_path }
		  format.json { head :no_content }
		end
	  else           
		@topic.locations.build
		@topic.references.build     
		format.html { render action: "new" }
		format.json { render json: @topic.errors, status: :unprocessable_entity }
	  end
	end
  end

  # PUT /topics/1
  # PUT /topics/1.json
  def update    
	input_locs = params[:topic][:locations_attributes].map{|x| x[:address]} unless params[:topic][:locations_attributes].nil?
	@topic = Topic.find(params[:id])            
	if input_locs
	  @topic.locations.each do |l|
		if !input_locs.include?(l.address)        
		  l.delete
		end
	  end
	end
	respond_to do |format|	  
	  if @topic.update_attributes(params[:topic])
	  	@topic.update_attribute :published, !(current_user.role.contributor?) # to get changes verified by trusted contributor or admin
	  	Rejection.where(:topic_id => @topic.id).update_all(:unchanged => false)
		if params[:avatar] && params[:avatar][:avatar_img]
		  @avatar = Avatar.find_by_topic_id(@topic.id)
		  if @avatar
			@avatar.update_attribute(:avatar_img,params[:avatar][:avatar_img])
		  else
			@avatar = Avatar.create(:avatar_img => params[:avatar][:avatar_img], :topic_id => @topic.id)                
		  end
		end
		if params[:commit] == "Lagre"
      flash[:success] = I18n.t("topics.create_flash")
		  format.html { redirect_to edit_topic_path(@topic) }
		  format.json { head :no_content }
    else
      flash[:success] = I18n.t("topics.create_flash")
		  format.html { redirect_to topics_path }
		  format.json { head :no_content }
		end
	  else
		format.html { render action: "edit" }
		format.json { render json: @topic.errors, status: :unprocessable_entity }
	  end
	end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
	@topic = Topic.find(params[:id])
	@topic.locations.delete_all
	@topic.references.delete_all
	@topic.destroy

	respond_to do |format|
	  format.html { redirect_to topics_url }
	  format.json { head :no_content }
	end
  end
  
  def batch_actions
		topic_ids = params["top_ids"].split(",")
		topics = Topic.find(topic_ids)
		topics.each do |top|
		  if params["batch_action"] == "delet"
				top.locations.delete_all
				top.references.delete_all
				top.destroy
		  else
			top.update_attribute(:published,params["batch_action"] == "publish" ? true : false)
		  end
		end
		flash[:success] = "#{topics.length} topic(s) have been #{params["batch_action"]}ed"
		redirect_to topics_url  
  end

private

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def save_in_locations
    if !params["locations_attributes"].blank?
      new_location_ids = []     
      params["locations_attributes"].each do |values|
        if values[:id].blank?
        	location = get_location values[:latitude], values[:longitude]
          location = Location.create values if location.nil?
        else
          location = Location.find values[:id]
          location.update_attributes values         
        end
        new_location_ids << location.id
      end     
      params["topic"]["location_ids"] ||= Array.new
      params["topic"]["location_ids"] += new_location_ids     
    end   
  end

  def get_location latitude, longitude
  	accuracy = 0.00003
  	locations = Location.where("latitude > '#{'%.5f' % (latitude.to_f - accuracy)}' AND latitude < '#{'%.5f' % (latitude.to_f + accuracy)}' 
  			AND longitude > '#{'%.5f' % (longitude.to_f - accuracy)}' AND longitude < '#{'%.5f' % (longitude.to_f + accuracy)}'")
  	locations.nil? ? nil : locations.first  	
  end
  
end
