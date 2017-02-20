<% module_namespacing do -%>
<% if admin_enabled? -%>
class Admin::<%= controller_class_name %>Controller < ApplicationController
<% else -%>
class <%= controller_class_name %>Controller < ApplicationController
<% end -%>
  load_and_authorize_resource

<% unless singleton? -%>
  def index
    respond_to do |format|
      format.html
<% if options[:json] -%>
      format.json { render json: <%= "@#{plural_table_name}" %> }
<% end -%>
    end
  end

<% end -%>
<% if options[:show] -%>
  def show
    respond_to do |format|
      format.html
<% if options[:json] -%>
      format.json { render json: <%= "@#{singular_table_name}" %> }
<% end -%>
    end
    end
  end

<% end -%>
<% unless singleton? -%>
  def new
    respond_to do |format|
      format.html
<% if options[:json] -%>
      format.json { render json: <%= "@#{singular_table_name}" %> }
<% end -%>
    end
  end

<% end -%>
  def edit
    respond_to do |format|
      format.html
<% if options[:json] -%>
      format.json { render json: <%= "@#{singular_table_name}" %> }
<% end -%>
    end
  end

<% unless singleton? -%>
  def create
    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to return_url(@<%= singular_table_name %>), flash: {success: t("<%= plural_table_name %>.created")} }
<% if options[:json] -%>
        format.json { render json: <%= "@#{singular_table_name}" %>, status: :created, location: <%= "@#{singular_table_name}" %> }
<% end -%>
      else
        format.html { render action: "new" }
<% if options[:json] -%>
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
<% end -%>
      end
    end
  end

<% end -%>
  def update
    respond_to do |format|
      if @<%= orm_instance.update("#{singular_table_name}_params") %>
        format.html { redirect_to return_url(@<%= singular_table_name %>), flash: {success: t("<%= plural_table_name %>.updated")} }
<% if options[:json] -%>
        format.json { head :no_content }
<% end -%>
      else
        format.html { render action: "edit" }
<% if options[:json] -%>
        format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
<% end -%>
      end
    end
  end

<% unless singleton? -%>
  def destroy
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to return_url(@<%= singular_table_name %>), flash: {success: t("<%= plural_table_name %>.removed")} }
<% if options[:json] -%>
      format.json { head :no_content }
<% end -%>
    end
  end

<% end -%>
  protected

  def return_url(<%= singular_table_name %>)
    return params[:return_url] if params[:return_url].present?

<% if singleton? -%>
    edit_<%= "admin_" if admin_enabled? %><%= singular_table_name %>_path(<%= class_name %>.instance)
<% else -%>
    <%= "admin_" if admin_enabled? %><%= plural_table_name %>_path
<% end -%>
  end

  def <%= "#{singular_table_name}_params" %>
    params.require(<%= ":#{singular_table_name}" %>).permit([
<% attributes.each do |attribute| -%>
<% if attribute.localized? -%>
     *locale_attributes(:<%= attribute.name %>),
<% else -%>
     :<%= attribute.name %>,
<% end -%>
<% end -%>
<% if blocks? -%>
     *<%= singular_table_name.classify.constantize %>.block_permitted_attributes,
<% end -%>
    ])
  end
end
<% end -%>
