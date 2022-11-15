module ApplicationHelper

  # def icon(name, label = nil)
  #   content_tag(:i, nil, :class => "fa fa-#{name.to_s.dasherize}")  ' '  label
  # end

  def icon(name, text = nil, html_options = {}, style = :far)
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end

  def iconify(name, label)
    icon(name, label)
  end

  def brandify(name, label)
    icon(name, label, { class: 'fa-fw' }, 'fab')
  end

  def to_words(num) 
    {
      2 => 'two',
      3 => 'three',
      4 => 'four',
      5 => 'five',
      6 => 'six',
      7 => 'seven',
      8 => 'eight',
      9 => 'nine',
      10 => 'ten'
    }[num]
  end

  def theme
    site = Site.current
    site.present? && site.theme.present? ? site.theme : 'default'
  end

  def tenant
    Tenant.current
  end


  def vertical_form_for(record, options={}, &block)
    options[:html] ||= {}
    options[:html][:class] = "form-vertical #{options[:html][:class]}".rstrip

    form = simple_form_for(record, options, &block)
    form.gsub("form-horizontal ", "").html_safe
  end
 
  def admin_menu_item(url:, icon:, label:)
    if url == admin_root_path
      active = request.path == admin_root_path && :active
    else
      active = request.path.start_with?(url) && :active
    end
    link_to url, class: [:item, active]  do
      semantic_icon(*icon) + label
    end 
  end

end
