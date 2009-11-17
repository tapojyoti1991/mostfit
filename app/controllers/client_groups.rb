class ClientGroups < Application
  # provides :xml, :yaml, :js

  def index
    @client_groups = ClientGroup.all
    display @client_groups
  end

  def show(id)
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
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
    @client_group = ClientGroup.new(client_group)
    if @client_group.save
      redirect resource(@client_group), :message => {:notice => "ClientGroup was successfully created"}
    else
      message[:error] = "ClientGroup failed to be created"
      render :new
    end
  end

  def update(id, client_group)
    @client_group = ClientGroup.get(id)
    raise NotFound unless @client_group
    if @client_group.update(client_group)
       redirect resource(@client_group)
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

end # ClientGroups
