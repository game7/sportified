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

  def javascript_pack_tag(*names, **options)
    tag = super(*names, **options)
    if tag && Webpacker.dev_server.running?
      puts '--------------------------------------'
      puts tag
      puts '--------------------------------------'
      #tag = tag.gsub('/packs/', "http://localhost:3035/packs/")
      puts '--------------------------------------'
      puts tag
      puts '--------------------------------------'      
    end
    tag.html_safe
  end

  # override webpacker tag helpers to point directly to
  # webpack dev server.  This overcomes issues between docker
  # and webpacker's proxy
  def stylesheet_pack_tag(*names, **options)
    tag = super(*names, **options)
    if tag && Webpacker.dev_server.running?
      tag = tag.gsub('/packs/', 'http://localhost:3035/packs/')
    end
    tag
  end  

end
