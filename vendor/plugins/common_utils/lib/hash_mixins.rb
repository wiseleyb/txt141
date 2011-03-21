class Hash

  def keys_to_strings
    res = {}
    self.keys.each do |k|
      if self[k].is_a?(Hash)
        res[k.to_s] = self[k].keys_to_strings
      else
        res[k.to_s] = self[k]
      end
    end
    return res
  end

  def keys_to_symbols
    res = {}
    self.keys.each do |k|
      if self[k].is_a?(Hash)
        res[k.to_sym] = self[k].keys_to_symbols
      else
        res[k.to_sym] = self[k]
      end
    end
    return res
  end

  def requires!(*params)
    params.each do |param|
      raise ArgumentError.new("Missing required parameter: #{param}") unless self.has_key?(param)
    end
  end

end
