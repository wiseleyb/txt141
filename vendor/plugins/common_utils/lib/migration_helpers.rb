module MigrationHelpers


  #column can be a string or an array of column names
  def add_primary_key(table, column)
    c = columns_array_to_string(column)
    drop_primary_key(table)
    begin
      sql = "alter table #{table} add primary key (#{c})"
      execute sql
    rescue
      say "Error adding primary key #{c} to #{table}"
    end
  end

  def drop_primary_key(table)
    begin
      sql = "alter table #{table} drop constraint #{table}_pkey"
      execute sql
    rescue
      say "No contraint #{table}_pkey to drop"
    end
  end

  def foreign_key(from_table, from_column, to_table)
    constraint_name = "fk_#{from_table}_#{from_column}"

    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)}
  end

  #table can be a string or an array of tables
  def drop_table_alt(table)
    table = [table] if !table.is_a?(Array)
    table.each do |t|
      begin
        drop_table t
      rescue
        say "Error dropping table #{t}"
      end
    end
  end

  def add_column_alt(table, column, datatype, options = {})
    begin
      add_column(table,column,datatype, options)
    rescue
      say "Error adding #{column} to #{table}"
    end
  end

  def drop_column_alt(table, column)
    remove_column_alt(table, column)
  end

  def rename_column_alt(table, old_name, new_name)
    begin
      rename_column(table, old_name, new_name)
    rescue
      say "Error renaming #{old_name} to #{new_name} on table #{table}"
    end
  end

  def remove_column_alt(table, column)
    begin
      remove_column(table,column)
    rescue
      say "Error removing #{column} to #{table}"
    end
  end

  def change_column_alt(table, column, new_type, options = {})
    begin
        change_column table, column, new_type, options
    rescue
      say "Error changing #{column} to #{new_type} on #{table}"
    end
  end

  def rename_table_alt(old_table, new_table)
    begin
      rename_table old_table, new_table
    rescue
      say "Error renaming #{old_table} to #{new_table}"
    end
  end

  def execute_alt(sql)
    begin
      execute(sql)
    rescue
      say "Error executing:  "  + sql
    end
  end

  def resequence_table(table_name)
    obj = Object.const_get(table_name.classify)
    row = obj.find(:first,:order => "#{obj.primary_key} desc")
    if !row.nil?
      begin
        ActiveRecord::Base.connection.execute "alter sequence #{table_name}_id_seq restart with " + (row[obj.primary_key] + 1).to_s
      rescue
        puts "Error updated #{table_name}"
      end
    end
  end

  def resequence_all_tables

    tables = %w()
    tables.each do |t|
      puts "resequencing #{t}"
      begin
        resequence_table(t)
      rescue
        puts "Error on #{t}"
      end
    end
  end

  def strip_tags(html)
    return html if html.blank?
    if html.index("<")
      text = ""
      tokenizer = HTML::Tokenizer.new(html)

      while token = tokenizer.next
        node = HTML::Node.parse(nil, 0, 0, token, false)
        # result is only the content of any Text nodes
        text << node.to_s if node.class == HTML::Text
      end
      # strip any comments, and if they have a newline at the end (ie. line with
      # only a comment) strip that too
      text.gsub(/<!--(.*?)-->[\n]?/m, "")
    else
      html # already plain text
    end
  end

  def add_index_alt(table_name, column_name, options = {})
    begin
      add_index(table_name, column_name, options)
    rescue
      say "Error adding index to #{table_name}"
    end
  end

  def remove_index_alt(table_name, column_name)
    begin
      remove_index(table_name, column_name)
    rescue
      say "Error removing index on #{table_name}"
    end
  end

  def execute_sql_array(sql_arr)
    sql_arr.each do |sql|
      execute(sql)
    end
  end

  private
  def columns_array_to_string(column)
    if column.is_a?(Array)
      column = column.join(", ")
    end
    column
  end

end