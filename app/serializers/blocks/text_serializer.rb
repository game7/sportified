class Blocks::TextSerializer < BlockSerializer
  def options
    object.options.merge({
      render: RedCloth.new(object.body || '').to_html
    })
  end
end
