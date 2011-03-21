class String
  def methodize
    self.downcase.gsub(" ","_")
  end
end

class Object

  #from: http://stackoverflow.com/questions/752717/how-do-i-use-definemethod-to-create-class-methods
  #allows you to define self.method's... example:
  # class MyClass
  #   self.metaclass.send(:define_method, :my_method) do
  #     ...
  #   end
  # end
  # Creates:  MyClass.my_method
  # See Role model for real world example
  def metaclass
    class << self
      self
    end
  end

  #converts any string into something that can be used in a url
  # "bob Eats lUncH! 'and has bananas'".to_url = "bob-eats-lunch-and-has-bananas"
  def to_url(space = '-')
    self.to_s.gsub(/[^a-z0-9]+/i, space)
  end

  def to_sub_domain
    #thanks to kipp howard for the much more readable regex tips

    #convert spaces to "-"
    a = /\s/
    #remove leading and trailing "-"
    #b = /^-*([a-z0-9][a-z0-9\-]{0,}[a-z0-9]{1})-*$/
    b = /^-*(\w+[a-z0-9\-]*\w)-*$/
    #remove all other characters
    c = /[^a-z0-9\-]/
    #remove all -------
    d = /^-*$/
    self.to_s.strip.downcase.gsub(a,'-').gsub(b,'\1').gsub(c,'').gsub(b,'\1').gsub(d,'')
  end

  #symbolize's any string
  def symbolize(space = '_')
    self.to_url(space).to_sym
  end

  #escapes string to be placed in " "
  def escape_for_double_quotes
    self.gsub('"', '\"')
  end

  def first_chars(num)
    self[0, num]
  end
  def last_chars(num)
    self[self.size - num, num]
  end

  #escapes string to be placed in ' '
  def escape_for_single_quotes
    a = "'"
    b = "\'"
    self.gsub(a,b)
  end

  #pads a string with spaces to the left
  def lpad(i, c = " ")
    s = self.to_s
    i.times do
      s = c + s.to_s
    end
    s
  end

  def truncate_at_words(len = 500, extra = " ...")
    res = ""
    arr = self.to_s.split(" ")
    while res.size < len && arr.size > 0
      res << arr.delete_at(0)
      res << " "
    end
    unless res == self || res.blank? || arr.size < 1
      res << extra
    end
    return res
  end

  def quote_phrase_for_email(len = 80, pad_with = "> ")
    ps = self.split("\n")
    res = []
    ps.delete_if{|p| p.blank?}
    ps.each do |p|
      line = [">"]
      p.split(" ").each do |w|
        if line.join(" ").size + w.size + 1 < len
          line << w
        else
          res << line.join(" ")
          line = [">"]
          line << w unless w.blank?
        end
      end
      res << line.join(" ") unless line.join("").blank?
      res << ">" unless p == ps.last
    end
    res.join("\n")
  end

  def to_hours_minutes_seconds
    time = self.to_i
    [time/3600, time/60 % 60, time % 60].map{|t| t.to_s.rjust(2, '0')}.join(':')
  end

  def to_ymd
    self.strftime("%Y-%m-%d") unless self.nil?
  end

  def to_ymdhm
    self.strftime("%Y-%m-%d %I:%M %p") unless self.nil?
  end
  
  def to_migration_time
    self.strftime("%Y%m%d%I%M%S") unless self.nil?
  end
  
  #useful hack for looking at methods in console without seeing all the usual Object methods
  def class_methods
    (self.methods - Object.methods).sort
  end

  #converts a hash some something readable and storable in a db
  # h = {:one => {:one1 => :two1}, :two => {:two1 => {:two3 => :two3}}, :three => :three}
  # puts h.hash_to_s
  # three: three
  # one
  #  one1: two1
  # two
  #  two1
  #   two3: two3
  def hash_to_s(l = 0)
    res = []
    if self.is_a?(Hash)
      self.each do |k,v|
        if self[k].is_a?(Hash)
          res << k.lpad(l)
          l += 1
          tmp = self[k].hash_to_s(l)
          tmp.each do |t|
            res << t
          end
          l -= 1
        else
          res << "#{k}: #{v}".lpad(l)
        end
      end
    end
    res
  end

  # from http://degenportnoy.blogspot.com/2009/06/supressing-objectid-deprecation.html
  def id_string_for(object_name, method_name, object)
       Kernel::silence_warnings {
          "#{object_name}_#{method_name}_#{object.id}"
        }
  end

  def to_cents
    (self * 100).to_i
  end

end
