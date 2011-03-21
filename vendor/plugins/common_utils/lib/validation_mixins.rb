#good post on how to do stuff like this  http://www.marklunds.com/articles/one/312

module ValidationMixins

  #takes two or more fields and adds an error is all are blank
  # fields can also be arrays, example
  #     validates_presence_of_at_least_one_field :code, [:begin_code, :end_code]
  #     would validate that either code was present or begin_code and end_code were present
  def validates_presence_of_at_least_one_field(*attributes)
    found = false
    attributes.each do |a|
      if a.is_a?(Array)
        found = true
        a.each do |asub|
          found = false if self.send(asub).blank?
        end
      else
        found = true unless self.send(a).blank?
      end
      break if found
    end
    if found == false
      self.errors.add(attributes.collect {|a| a.is_a?(Array) ? " ( #{a.join(", ")} ) " : a.to_s}.join(", "), 
        "can't all be blank.  At least one field must be filled in.")
    end
  end

  #takes an array of emails and returns an error containing invalid emails
  def validate_emails(arr)
    invalid = []
    arr.each do |a|
      a.gsub!(" ","")
      invalid << a unless a =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
    end
    if invalid.length > 0
      self.errors.add(invalid.join(", "), "appeared to be invalid email addresses")
    end
  end

  def validates_matching(a,b)
    aa = self.send(a)
    bb = self.send(b)
    unless aa == bb
      self.errors.add("#{a}, #{b}", "don't match.")
    end
  end
  
end