module CacheMixins

  def cache_delete(name)
    ActionController::Base.cache_store.delete(name) if ActionController::Base.cache_store.exist?(name)
  end

  def cache_delete_file(name)  #warning - this takes wild cards
    p = ActionController::Base.cache_store.cache_path
    p += "/" unless p.last == "/"
    FileUtils.rm_rf Dir.glob("#{p}views/#{name}")
  end

  def cache_exists?(name, expires_in = 15.minutes)
    return false unless ActionController::Base.perform_caching == true
    return false unless ActionController::Base.cache_store.exist?(name) 
    if cached_at(name) < expires_in.ago
      cache_delete(name)
      return false
    else
      return true
    end
  end

  def after_save(record)
    expire_cache_for(record)
  end

  def after_create(record)
    expire_cache_for(record)
  end

  def after_update(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  def cache_filename(name)
    [ActionController::Base.cache_store.cache_path,name,".cache"].join("")
  end
  
  def cached_at(name)
    if ActionController::Base.cache_store.exist?(name)
      f = File.open(cache_filename(name))
      res = f.stat.mtime.to_datetime
      f.close
      return res
    else
      DateTime.now - 10.years
    end
  end
end
