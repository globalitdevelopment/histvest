class ReferencesController < ApplicationController
  load_and_authorize_resource :only => [:index, :show, :create, :edit, :new, :update, :destroy]

  # GET /references
  # GET /references.json
  def index
    @references = Reference.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @references }
    end
  end

  # GET /references/1
  # GET /references/1.json
  def show
    @reference = Reference.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reference }
    end
  end

  # GET /references/new
  # GET /references/new.json
  def new
    @reference = Reference.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reference }
    end
  end

  # GET /references/1/edit
  def edit
    @reference = Reference.find(params[:id])
  end

  # POST /references
  # POST /references.json
  def create
    @reference = Reference.new(params[:reference])

    respond_to do |format|
      if @reference.save
        flash[:success] = I18n.t('references.create_flash')
        format.html { redirect_to @reference }
        format.json { render json: @reference, status: :created, location: @reference }
      else
        format.html { render action: "new" }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /references/1
  # PUT /references/1.json
  def update
    @reference = Reference.find(params[:id])

    respond_to do |format|
      if @reference.update_attributes(params[:reference])
        flash[:success] = I18n.t('references.update_flash')
        format.html { redirect_to @reference }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reference.errors, status: :unprocessable_entity }
      end
    end
  end

  def searchSource
    params[:index] ||= 0
    params[:index] = params[:index].to_i

    case params[:source]
    when "NationalLibrary"
      @references = NationalLibraryWrapper.new(params[:query]).search(params[:index])
    when "Europeana"
      @references = EuropeanaWrapper.new(params[:query]).search(params[:index])
    when "Wikipedia"
      @references = WikipediaWrapper.new(params[:query]).search(params[:index])  
    when "DigitalArchive"
      @references = DigitalArchiveWrapper.new(params[:query]).search(params[:index])  
    else
      @references = Array.new()
    end

    respond_to do |format|
      format.html { render :search }
      format.json { render json: @references }
    end
  end

  def numberOfResultsNb
    query = params[:query]
    
    nb_numbers = NationalLibraryWrapper.new(query).number_of_results
    @results = nb_numbers.nil? ? "" : nb_numbers
    render json: @results.to_json
  end

  def numberOfResultsWiki
    query = params[:query]

    wiki_numbers = WikipediaWrapper.new(query).number_of_results
    @results = wiki_numbers.nil? ? "" : wiki_numbers      
    render json: @results.to_json
  end

  def numberOfResultsEuro
    query = params[:query]        

    europeana_numbers = EuropeanaWrapper.new(query).number_of_results
    @results = europeana_numbers.nil? ? "" : europeana_numbers
    render json: @results.to_json
  end

  def numberOfResultsAr
    query = params[:query]

    ar_numbers = DigitalArchiveWrapper.new(query).number_of_results
    @results = ar_numbers.nil? ? "" : ar_numbers
    render json: @results.to_json
  end

  # DELETE /references/1
  # DELETE /references/1.json
  def destroy
    @reference = Reference.find(params[:id])
    @reference.destroy

    respond_to do |format|
      format.html { redirect_to references_url }
      format.json { head :no_content }
    end
  end
end
