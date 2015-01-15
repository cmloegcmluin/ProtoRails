require_relative '../../db/_example_db_connection'
require_relative 'assoc_options'
require 'active_support/inflector'

class SQLObject
  def self.columns
    DBConnection.execute2(<<-SQL).first.map(&:to_sym)
    SELECT
    *
    FROM
    #{table_name}
    SQL
  end

  def self.finalize!
    columns.each do |column|
      define_method("#{column}") { self.attributes[column] }
      define_method("#{column}=") { |set_to| self.attributes[column] = set_to }
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
    *
    FROM
    #{table_name}
    SQL
    #debugger
    parse_all(results)
  end

  def self.parse_all(results)
    new_objects = []
    results.each do |result|
      new_objects << self.new(result)
    end

    new_objects
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL)
    SELECT
    *
    FROM
    #{table_name}
    WHERE
    id = #{id}
    LIMIT 1
    SQL

    parse_all(results).first
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      unless col_names.include?(attr_name.to_sym)
        raise "unknown attribute '#{attr_name}'"
      end
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    col_names.map { |column| self.send(column) }
  end

  def col_names
    self.class.columns
  end

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
    #{self.class.table_name} (#{col_names.join(", ")})
    VALUES
    (#{(["?"] * col_names.length).join(", ")})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    DBConnection.execute(<<-SQL, *attribute_values, id)
    UPDATE
    #{self.class.table_name}
    SET
    #{col_names.map { |attr_name| "#{attr_name} = ?" }.join(", ")}
    WHERE
    id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end

  def self.where(params)
    where_line = params.map { |key, value| "#{key} = ?" }.join(" AND ")
    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT
    *
    FROM
    #{self.table_name}
    WHERE
    #{where_line}
    SQL

    parse_all(results)
  end

  def self.belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options
    define_method(name) do
      return nil if send(options.foreign_key).nil?
      results = DBConnection.execute(<<-SQL)
      SELECT
      *
      FROM
      #{options.table_name}
      WHERE
      #{options.primary_key} = #{send(options.foreign_key)}
      SQL

      options.model_class.parse_all(results).first
    end
  end

  def self.has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)

    define_method(name) do
      results = DBConnection.execute(<<-SQL)
      SELECT
      *
      FROM
      #{options.table_name}
      WHERE
      #{options.foreign_key} = #{send(options.primary_key)}
      SQL

      options.model_class.parse_all(results)
    end
  end

  def self.assoc_options
    @assoc_options ||= {}
  end

  def self.has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]

      results = DBConnection.execute(<<-SQL)
      SELECT
      #{source_options.table_name}.*
      FROM
      #{source_options.table_name}
      JOIN
      #{through_options.table_name}
      ON
      #{through_options.table_name}.#{source_options.foreign_key} =
      #{source_options.table_name}.#{through_options.primary_key}
      WHERE
      #{through_options.table_name}.#{through_options.primary_key} =
      #{send(through_options.foreign_key)}
      SQL

      source_options.model_class.parse_all(results).first
    end
  end
end
