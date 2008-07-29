class String
  def ends_with?(str)
    self =~ /#{Regexp.escape(str)}$/
  end
end