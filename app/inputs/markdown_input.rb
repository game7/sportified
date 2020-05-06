class MarkdownInput < SimpleForm::Inputs::Base

  def input(wrapper_options)
    # item[description]
    # source = options[:source] || :event
    # tags = source.to_s.classify.constantize.tag_counts
    # @builder.select(attribute_name, tags, {}, { class: [:ui, :search, :dropdown], multiple: '' })
    template.react_component 'markdown_editor', props, { camelize_props: true }
  end

  def value
    @builder.object.send(attribute_name)
  end

  def preview
    MarkdownService.html(value)
  end

  def props
    attrs = {
      object: object_name, 
      attr: attribute_name,      
      value: value,
      preview: value.present? ? MarkdownService.html(value) : ''
    }
  end

end