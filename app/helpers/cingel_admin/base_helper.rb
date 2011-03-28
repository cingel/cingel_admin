module CingelAdmin::BaseHelper
  
  def admin_page_title
    "#{Rails.application.class.to_s.split("::").first} Administration Area"
  end
  
  def admin_title
    %{<h1>#{link_to(CingelAdmin.title, admin_root_path)}</h1>}.html_safe
  end
  
  def default_admin_main_menu_items
    [
      ["Dobro Došli", admin_root_path, /^(\/admin$|\/dashboard)/]
    ]
  end
  
  def admin_main_menu
    begin
      items = admin_main_menu_items
    rescue NameError
      items = default_admin_main_menu_items
    end
    return "" if items.empty?
    lis = items.map do |item|
      link_class = request.fullpath.match(item[2]) ? "current" : nil
      content_tag(:li, link_to(item[0], item[1], :class => link_class))
    end
    content_tag(:ul, raw(lis.join("")), :id => "admin_main_menu", :class => "main_menu")
  end
  
  def button_link_to(text, url, options = {}, button_options = {})
    options ||= {}
    options[:class] ||= ""
    options[:class] << " awesome_button"
    options[:class] << " awesome_button_#{button_options[:size]}" unless button_options[:size].blank?
    options[:class] << " awesome_button_overlay" if button_options[:overlay] 
    link_to(text, url, options)
  end
  
  def example_label(text, options = {})
    prefix = options.delete(:prefix) || "Primjer: "
    options[:for] ||= nil
    options[:class] = options[:class].to_s.concat(" example_label").strip
    label_tag(options[:for], raw("#{prefix} #{text}"), options)
  end

  def help_label(text, options = {})
    options[:prefix] ||= ""
    example_label(raw(text), options)
  end

  def unit_label(text, options = {})
    options[:for] ||= nil
    options[:class] = options[:class].to_s.concat(" unit_label").strip
    label_tag(options[:for], raw(text), options)
  end

  def inline_label(text, options = {})
    options[:for] ||= nil
    options[:class] = options[:class].to_s.concat(" inline_label").strip
    label_tag(options[:for], raw(text), options)
  end
  
  def link_to_help(text = nil, url = nil)
    text ||= "Pomoć"
    url ||= { :action => "help" }
    content_tag(:p, link_to(text, url), :class => "help_link")
  end
  
  def help_image_tag(src)
    src = "#{src}.png" unless src.match(/\.(png|jpg|jpeg|gif)$/i)
    image_tag("help/#{src}", :class => "help_img")
  end
  
end
