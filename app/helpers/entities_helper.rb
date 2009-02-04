module EntitiesHelper
  def show_entities(entities, locals = {})
    locals.reverse_merge! :show_new => false
    render :partial => entities, :locals => locals
  end
end
