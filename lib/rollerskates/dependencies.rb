class Object
  def self.const_missing(const)
    require const.to_s.snakize
    const
  end
end
