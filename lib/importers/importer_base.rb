require 'csv'

# Class from which all data importers descend.
class ImporterBase

  # @api private
  attr_reader :file_path
  # @api private
  attr_reader :headers

  # Accepts a string that represents the path to the csv file
  #
  # @param [String] file_path
  # @return [ImporterBase]
  def initialize file_path
    @file_path = file_path
    @headers   = csv.shift
  end

  # Returns a CSV IO object of the csv file
  #
  # @return [CSV]
  def csv
    @csv ||= CSV.open(file_path)
  end

  def index_for_header header
    headers.index(header)
  end

  def import!
    csv.each do |row|
      model = model_class.create(attributes_hash(header_mapping, row))
      next unless model.valid?
      handle_associated_many_classes(model, row)
      handle_associated_single_classes(model, row)
    end
  end

  def handle_associated_many_classes model, row
    associated_many_classes.each do |klass|
      collection = klass.to_s.underscore.pluralize.to_sym
      headers_hash = headers_hash_for_class(klass)
      association = model.send(collection).send(:build)
      association_attributes = attributes_hash(send(headers_hash), row)
      association.update_attributes(association_attributes)
    end
  end

  def handle_associated_single_classes model, row
    associated_single_classes.each do |klass|
      headers_hash = headers_hash_for_class(klass)
      association_method = "build_#{klass.to_s.underscore}".to_sym
      association = model.send(association_method)
      association_attributes = attributes_hash(send(headers_hash), row)
      association.update_attributes(association_attributes)
    end
  end

  def headers_hash_for_class klass
    "#{klass.to_s.underscore}_header_mapping".to_sym
  end

  # Overridden in subclassed importers
  def model_class
    nil
  end

  # Overridden in subclassed importers
  def associated_many_classes
    []
  end

  # Overridden in subclassed importers
  def associated_single_classes
    []
  end

  # Accepts a hash that represents the mapping between attributes and the old tables as
  # well as a row from the csv file.  Returns a hash of the attributes
  #
  # @params [Hash, String]
  # @return [Hash]
  def attributes_hash mapping_hash, row
    mapping_hash.each_with_object({}) do |header_map, a_hash|
      new_key       = header_map[0]
      old_key       = header_map[1]
      value         = row[index_for_header(old_key)]
      a_hash[new_key] = value
    end
  end

end

