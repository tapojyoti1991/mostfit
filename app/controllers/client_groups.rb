class ClientGroups < Application
  # provides :xml, :yaml, :js
  before :get_context, :only => ['edit', 'update']

  def index
    @client_groups = ClientGroup.all
    display @client_groups
  end

  def show(id)
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
    @cgts = @client_group.cgts
    display @client_group
  end

  def new
    only_provides :html
    @client_group = ClientGroup.new
    display @client_group
  end

  def edit(id)
    only_provides :html
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
    display @client_group
  end

  def create(client_group)
    only_provides :html, :json
    @client_group = ClientGroup.new(client_group)
    if @client_group.save
      request.xhr? ? display(@client_group) : redirect(url(:data_entry), :message => {:notice => "Group was successfully created"})
    else
      message[:error] = "Group failed to be created"
      request.xhr? ? display(@client_group.errors, :status => 406) : render(:new)
    end
  end

  def update(id, client_group)
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
    if @client_group.update(client_group)
      message  = {:notice => "Group was successfully edited"}      
      (@branch and @center) ? redirect(resource(@client_group.center.branch, @client_group.center), :message => message) : redirect(resource(@client_group), :message => message)
    else
      display @client_group, :edit
    end
  end

  def destroy(id)
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
    if @client_group.destroy
      redirect resource(:client_groups)
    else
      raise InternalServerError
    end
  end

  private
  def get_context
    if params[:branch_id] and params[:center_id] 
      @branch = Branch.get(params[:branch_id]) 
      @center = Center.get(params[:center_id]) 
      raise NotFound unless @branch and @center
    end
  end
end # ClientGroups
