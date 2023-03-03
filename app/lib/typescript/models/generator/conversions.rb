module Typescript::Models::Generator::Conversions
  extend ActiveSupport::Concern

  def conversions # rubocop:disable Metrics/MethodLength
    {
      'string' => 'string',
      'inet' => 'string',
      'text' => 'string',
      'json' => 'Record<string, any>',
      'jsonb' => 'Record<string, any>',
      'binary' => 'string',
      'integer' => 'number',
      'bigint' => 'number',
      'float' => 'number',
      'decimal' => 'number',
      'boolean' => 'boolean',
      'date' => 'string',
      'datetime' => 'string',
      'timestamp' => 'string',
      'datetime_with_timezone' => 'string',
      'uuid' => 'string'
    }
  end
end
