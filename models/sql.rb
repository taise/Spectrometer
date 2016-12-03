require 'pathname'

class SQL
  SQL_PATH = Pathname.new(__FILE__).parent / 'sql'
  @@texts = {}

  def self.text(name)
    add(name) unless @@texts.has_key?(name)
    @@texts[name]
  end

  private

  def self.add(name)
    @@texts[name] = open(SQL_PATH / name).read
  end
end
