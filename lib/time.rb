class Time
  def local_timestamp
    getlocal.strftime('%Y/%m/%d %H:%M:%S')
  end
end
