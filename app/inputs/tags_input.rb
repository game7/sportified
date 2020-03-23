class TagsInput < SimpleForm::Inputs::Base

    def input(wrapper_options)
      source = options[:source] || :event
      tags = source.to_s.classify.constantize.tag_counts
      @builder.select(attribute_name, tags, {}, { class: [:ui, :search, :dropdown], multiple: '' })
    end
  
    protected
  

    
  end