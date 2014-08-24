class Parser

  attr_accessor :file_name

  def initialize(file_name, data, base_only)
    @file_name = file_name
    @data = data
    @base_only = base_only

    @generated_class = self.snake_to_camel(File.basename(file_name, '.json'))

    @properties = self.extract_properties(data['properties'])
    @variable_names = self.extract_variable_names(data['properties'].keys)
    @extends_class = self.extends_class(data)
    @import = self.get_import(data)
    @contains_classes = self.get_contains(data['properties'])
    @array_converters = self.get_array_converters(data['properties'])
  end

  def generate_files
    output = {}

    output["_#{@generated_class}.h"] = Mustache.render(read_template('base_header'),
                                                       :class_name => @generated_class,
                                                       :extends_class => @extends_class,
                                                       :import => @import,
                                                       :description => @data['description'],
                                                       :properties => @properties)

    output["_#{@generated_class}.m"] = Mustache.render(read_template('base_implementation'),
                                                       :class_name => @generated_class,
                                                       :properties => @variable_names,
                                                       :extends => !@import.nil?,
                                                       :contains => @contains_classes,
                                                       :array_converters => @array_converters)

    unless @base_only
      output["#{@generated_class}.h"] = Mustache.render(read_template('header'),
                                                        :class_name => @generated_class)

      output["#{@generated_class}.m"] = Mustache.render(read_template('implementation'),
                                                        :class_name => @generated_class)
    end

    output
  end

  def read_template(template_name)
    File.read("#{File.dirname(__FILE__)}/tpl/#{template_name}.mustache")
  end

  def get_contains(properties)
    contains = []

    properties.each do |name, type_info|
      if self.match_type(type_info['type']) == 'NSArray' && type_info['items']['$ref'] != nil && type_info['items']['$ref'] != '#'
        contains << "#import \"_#{self.snake_to_camel(Pathname.new(type_info['items']['$ref']).basename('.json').to_s)}.h\""
      end
    end

    contains
  end

  def get_array_converters(properties)
    array_converters = []

    properties.each do |name, type_info|
      if self.match_type(type_info['type']) == 'NSArray' && type_info['items']['$ref'] != nil
        extends = type_info['items']['$ref'] != '#' ? self.snake_to_camel(Pathname.new(type_info['items']['$ref']).basename('.json').to_s) : @generated_class
        array_converters << "+ (NSValueTransformer *)#{name}JSONTransformer {\n    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:_#{extends}.class];\n}"
      end
    end

    array_converters
  end

  def get_import(data)
    if data['extends'].to_s == ''
      nil
    else
      import = data['extends'].is_a?(String) ? '_' << self.snake_to_camel(data['extends'].sub('.json', '')) : '_' << self.snake_to_camel(File.basename(data['extends']['$ref'], '.json'))
      "#import \"#{import}.h\""
    end
  end

  def extends_class(data)
    if data['extends'].to_s == ''
      'MTLModel<MTLJSONSerializing>'
    else
      if data['extends'].is_a? String
        '_' << self.snake_to_camel(Pathname.new(data['extends']).basename('.json').to_s)
      else
        '_' << self.snake_to_camel(Pathname.new(data['extends']['$ref']).basename('.json').to_s)
      end
    end
  end

  def extract_variable_names(keys)
    extracted_variables_names = []

    if keys.length > 1
      last = keys.pop
      keys.each { |key| extracted_variables_names << "@\"#{key}\" : @\"#{key}\"," }
      extracted_variables_names << "@\"#{last}\" : @\"#{last}\""
    else
      extracted_variables_names << "@\"#{keys[0]}\" : @\"#{keys[0]}\""
    end

    extracted_variables_names
  end

  def extract_properties(properties)
    extracted_properties = []

    properties.each do |name, type_info|
      type = match_type(type_info['type'])
      extracted_properties << "@property(#{self.copy_type(type) ? 'copy' : 'assign'}, nonatomic, readonly) #{type} #{self.copy_type(type) ? '*' : ''}#{name};"
    end

    extracted_properties
  end

  def copy_type(type)
    type != 'NSInteger' && type != 'BOOL'
  end

  def match_type(in_type)
    case in_type
      when 'string'
        'NSString'
      when 'number', 'long'
        'NSNumber'
      when 'integer'
        'NSInteger'
      when 'boolean'
        'BOOL'
      when 'object', 'any'
        'NSObject'
      when 'array'
        'NSArray'
      when 'null'
        'NSNull'
      else
        'NSObject'
    end
  end

  def snake_to_camel(file_name)
    (file_name.split('_').length > 1) ? file_name.split('_').map { |w| w.capitalize }.join('') : file_name.capitalize
  end

end