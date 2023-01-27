class ThingsController < ApplicationController
  before_action :set_thing, only: %i[ show edit update destroy create_instance ]

  # GET /things or /things.json
  def index
    @things = Thing.all
  end

  # GET /things/1 or /things/1.json
  def show
  end

  # GET /things/new
  def new
    @thing = Thing.new
  end

  # GET /things/1/edit
  def edit
  end

  # POST /things or /things.json
  def create
    @thing = Thing.new(
      name: params[:thing][:name],
    )
    object = []
    Thing.properties.each do |property|
      if params[:thing][property[0].to_sym]
        # raise property[0].to_sym.inspect
        object << {
          property[0].to_sym => params[:thing][property[0].to_sym]
        }
      else
        object << {
          property[0].to_sym => []
        }
      end
    end

    @thing.properties = object
     
    respond_to do |format|
      if @thing.save
        format.html { redirect_to thing_url(@thing), notice: "Thing was successfully created." }
        format.json { render :show, status: :created, location: @thing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_instance
    if !@thing.instances
      identifier = 1.to_s
    else
      identifier = (@thing.instances.last['instance_id'].split("_")[1].to_i + 1).to_s
    end
    
    instance = {
      instance_id: @thing.name + "_" + identifier
    }
    # raise params[:thing].to_a.include?("mustHave").inspect
    if params[:thing]

      if params[:thing][:instance_name] != ""
        instance[:instance_name] = params[:thing][:instance_name]
        params[:thing].delete("instance_name")
      else
        params[:thing].delete("instance_name")
      end
      
      params[:thing].each do |thing|
        new_thing = thing[1]
        thing_id = thing[0].split("_")[1]
        
        @other_thing = Thing.where(name: thing_id).first
        other_thing_instances = @other_thing.instances
        other_thing_instances.each do |other_thing|
          if other_thing["instance_id"] == new_thing
            other_thing[@thing.name] = ()
            @other_thing.save
            break
          end
        end
        # raise
        instance[thing_id.to_sym] = new_thing
      end
    end
    
    # raise 'nope'
    new_instances = @thing.instances.to_a << instance
    @thing.update_column(:instances, new_instances)

    respond_to do |format|
      if @thing.save
        format.html { redirect_to thing_url(@thing), notice: "Instance of thing was successfully created." }
        format.json { render :show, status: :created, location: @thing }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /things/1 or /things/1.json
  def update
    object = []
    Thing.properties.each do |property|
      if params[:thing][property[0].to_sym]
        # raise property[0].to_sym.inspect
        object << {
          property[0].to_sym => params[:thing][property[0].to_sym]
        }
      else
        object << {
          property[0].to_sym => []
        }
      end
    end
    @thing.properties = object
    respond_to do |format|
      if @thing.update(thing_params)
        format.html { redirect_to thing_url(@thing), notice: "Thing was successfully updated." }
        format.json { render :show, status: :ok, location: @thing }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @thing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /things/1 or /things/1.json
  def destroy
    @thing.destroy

    respond_to do |format|
      format.html { redirect_to things_url, notice: "Thing was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_thing
      @thing = Thing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def thing_params
      params.require(:thing).permit(:name, properties: [])
    end
end
