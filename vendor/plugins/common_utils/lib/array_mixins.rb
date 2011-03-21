class Array

  #reorders an array
  #
  # simple example
  #   arr1 = [0,1,2,3,4]
  #   arr2 = [3,2,4,1, 0]
  #   arr1.reorder(arr2) = [3,2,4,1,0]
  #
  # active record example
  # idarr = [4,2,10,8]
  # users = User.find(idarr)
  # users.reorder(idarr, "id").collect {|u| u.id} = [4,2,10,8]
  #
  # obj_key needs to return a int
  def reorder(array_of_ordered_values, obj_key = "")
    if obj_key.blank? #just collect by position
      return array_of_ordered_values.collect {|a| self[a]}
    else
      h = {}
      self.each do |obj|
        h[obj.send(obj_key)] = obj
      end
      return array_of_ordered_values.collect {|a| h[a]}
    end
  end

  def to_i
    self.collect {|i| i.to_i}
  end

  #creates a hash out of an array of objects with a specified key
  # example
  # users = User.all
  # user_hash = users.to_hash(:login)
  # user_hash["smith"]....
  def to_hash(key_method)
    key_method = key_method.to_sym
    arr = self.collect(&key_method)
    raise "Key Method supplied was not unique" unless arr.size == self.size
    h = {}
    self.each do |a|
      h[a.send(key_method)] = a
    end
    return h
  end

  def normalize(min = 0.1, max = 99.9)
    tmp = self.to_i
    xmax = tmp.max
    tmp.to_i.map {|n| min + (n.to_f - 1.to_f) * (max / xmax.to_f)}.collect{|x| x.to_i}
  end

  # does a join(",") but last item has an and
  def join_with_and
    x = self.pop
    return x if self.size == 0
    "#{self.join(", ")} and #{x}"
  end

  #from http://snippets.dzone.com/posts/show/1167
  def random_pick(number = 0)
    sort_by{ rand }.slice(0...number)
  end

  # sort_by(&:position)

end
