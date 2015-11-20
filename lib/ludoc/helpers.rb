module Ludoc
  def self.to_pts(str)
    str = str.chomp('"').to_f if str.is_a? String
    str * 72
  end
end
