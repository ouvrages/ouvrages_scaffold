<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController
  load_and_authorize_resource

  before_filter do
    add_crumb t("navigation.<%= plural_table_name %>"), <%= plural_table_name %>_path
  end

  def index
    respond_to do |format|
      format.html
      # format.json { render json: <%= "@#{plural_table_name}" %> }
    end
  end

  def show
    respond_to do |format|
      format.html
      # format.json { render json: <%= "@#{singular_table_name}" %> }
    end
  end

  def new
    respond_to do |format|
      format.html
      # format.json { render json: <%= "@#{singular_table_name}" %> }
    end
  end

  def edit
  end

  def create
    respond_to do |format|
      if @<%= orm_instance.save %>
        format.html { redirect_to @<%= singular_table_name %>, flash: {success: t("<%= plural_table_name %>.created")} }
        # format.json { render json: <%= "@#{singular_table_name}" %>, status: :created, location: <%= "@#{singular_table_name}" %> }
      else
        format.html { render action: "new" }
        # format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        format.html { redirect_to @<%= singular_table_name %>, flash: {success: t("<%= plural_table_name %>.updated")} }
        # format.json { head :no_content }
      else
        format.html { render action: "edit" }
        # format.json { render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @<%= orm_instance.destroy %>

    respond_to do |format|
      format.html { redirect_to <%= index_helper %>_url, flash: {success: t("<%= plural_table_name %>.removed")} }
      # format.json { head :no_content }
    end
  end
end
<% end -%>
