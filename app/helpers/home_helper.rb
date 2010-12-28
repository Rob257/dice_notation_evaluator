module HomeHelper

  def hidden_div_unless(condition, attributes = {}, &block)
    unless condition
      attributes["style"] = "display:none"
    end
    content_tag("div" , attributes, &block)
  end

#  def button_xhr label, action
#    "<% form_remote_tag :url => { :action => #{action} } do %>
#    <%= submit_tag '#{label}' %>
#    <% end %>"
#  end

end

