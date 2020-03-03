class SemanticRadioButtonsInput < SimpleForm::Inputs::CollectionCheckBoxesInput

  def input(wrapper_options)
    label_method, value_method = detect_collection_methods
    options[:item_wrapper_class] = 'field'
    options[:collection_wrapper_tag] = 'div'
    options[:collection_wrapper_class] = 'grouped fields'

    @builder.send("collection_radio_buttons",
                  attribute_name, collection, value_method, label_method,
                  input_options, input_html_options, &collection_block_for_nested_boolean_style
    )
  end

  protected

  def collection_block_for_nested_boolean_style
    proc { |builder| build_nested_boolean_style_item_tag(builder) }
  end
  
  def build_nested_boolean_style_item_tag(collection_builder)
    tag = String.new
    tag << '<div class="ui radio checkbox">'.html_safe
    tag << collection_builder.radio_button + collection_builder.label
    tag << '</div>'.html_safe
    return tag.html_safe
  end

  
end