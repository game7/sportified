class CurrencyInput < SimpleForm::Inputs::Base

  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:value] = template.number_with_precision(value, precision: 2) if value.present? && !@builder.object.errors.include?(attribute_name)
    template.content_tag :div, class: [:ui, :labeled, :input] do
      [
        template.content_tag(:div, '$', class: [:ui, :label]),
        @builder.text_field(attribute_name, merged_input_options)
      ].join.html_safe
    end
  end

  def value
    @builder.object.send(attribute_name)
  end

end