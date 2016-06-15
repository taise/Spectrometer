# frozen_string_literal: true
class Time
  def local_timestamp
    getlocal.strftime('%FT%H:%M:%S')
  end
end
