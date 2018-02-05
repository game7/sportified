module ApplicationHelper


  # def icon(name, label = nil)
  #   content_tag(:i, nil, :class => "fa fa-#{name.to_s.dasherize}") + ' ' + label
  # end

  def iconify(name, label)
    icon(name, label)
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

end
