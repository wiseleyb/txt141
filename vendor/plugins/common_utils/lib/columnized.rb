# from http://snippets.dzone.com/posts/show/2176
# >> puts Post.find(:all).columnized(:max_width => 10)
# updated_at | title      | private | url | thumb      | metadata | movie      | id  | views | content    | user_id | created_at
# ——————————————————————————————————————————
# Wed May 31 | tetwer     | 0       |     |            |          |            | 909 | 0     | video:xyzz | 1       | Wed May 31
# Wed May 31 | bbbb       | 0       |     |            |          |            | 1   | 15    | // descrip | 1       | Tue May 23
# Wed May 31 | cxzcxzx    | 0       |     |            |          |            | 906 | 19    | // descrip | 1       | Tue May 23
# Wed May 31 | jklklkl;   | 0       |     |            |          |            | 907 | 35    | // descrip | 1       | Tue May 23



class Array

  protected

    def columnized_row(fields, sized)
      r = []
      fields.each_with_index do |f, i|
        r << sprintf("%0-#{sized[i]}s", f.to_s.gsub(/\n|\r/, '').slice(0, sized[i]))
      end
      r.join(' | ')
    end

  public

  def columnized(options = {})
    sized = {}
    self.each do |row|
      row.attributes.values.each_with_index do |value, i|
        sized[i] = [sized[i].to_i, row.attributes.keys[i].length, value.to_s.length].max
        sized[i] = [options[:max_width], sized[i].to_i].min if options[:max_width]
      end
    end

    table = []
    table << header = columnized_row(self.first.attributes.keys, sized)
    table << header.gsub(/./, '-')
    self.each { |row| table << columnized_row(row.attributes.values, sized) }
    table.join("\n")
  end
end

class ActiveRecord::Base
  def columnized(options = {})
    [*self].columnized(options)
  end
end
