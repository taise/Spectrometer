require 'pathname'

# SQL text accessor
class SQL
  SQL_PATH = Pathname.new(__FILE__).parent / 'sql'
  @@texts = {}

  def self.text(name)
    add(name) unless @@texts.key?(name)
    @@texts[name]
  end

  def self.add(name)
    @@texts[name] = open(SQL_PATH / name).read
  end

  private_class_method :add
end
