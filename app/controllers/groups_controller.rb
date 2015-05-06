class GroupsController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :edit]
  before_action :set_group, only: [:subscribe, :unsubscribe, :show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups
  # GET /groups.json
  def unsubscribe
    respond_to do |format|
      @group.members.delete(current_user.id)

      if @group.save
        format.html { redirect_to groups_url, notice: 'Unsubscribed from group event feed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to groups_url, notice: 'Could not unsubscribe from group event feed.' }
        format.json { head :no_content }
      end
    end
  end

  # GET /groups
  # GET /groups.json
  def subscribe
    respond_to do |format|
      if @group.members.include? current_user.id
        format.html { redirect_to groups_url, notice: 'Already subscribed to group.' }
        format.json { head :no_content }
      else
        @group.members << current_user.id

        if @group.save
          format.html { redirect_to groups_url, notice: 'Subscribed to group event feed.' }
          format.json { head :no_content }
        else
          format.html { redirect_to groups_url, notice: 'Could not subscribe to group event feed.' }
          format.json { head :no_content }
        end
      end
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    if @group.admin != current_user.id
      respond_to do |format|
        format.html { redirect_to group_url, notice: 'You are not the admin of this group.' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    if current_user
      @group.admin = current_user.id
      @group.members << current_user.id
    end
    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :admins)
    end
end
