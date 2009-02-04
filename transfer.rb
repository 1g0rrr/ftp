#FileUtils.mkdir '/home/igorrr/rails/file/igor'
#test
FileUtils.touch(RAILS_ROOT + '/lock')
u = Dir.entries(FILMS_UPLOAD_PATH)

# перемещаем подтвержденные файлы
entities = Entity.find(:all, :conditions => "is_submit = 1 AND is_transfer is NULL")

entities.each do |e|
  puts e.file_name.to_s
  if (!e.file_name.to_s.empty? && File.exist?(FILMS_UPLOAD_PATH + "/" + e.file_name.to_s))
    FileUtils.mkpath(FILMS_STORAGE_PATH + "/" + e.category)
    if FileUtils.mv(FILMS_UPLOAD_PATH + "/" + e.file_name.to_s, FILMS_STORAGE_PATH + "/" + e.category)
      e.update_attributes(:is_transfer => 1)
      puts e.file_name.to_s + ' moved'
    end
  end
end

# удаляем отвергнутые модератором файлы
entities = Entity.find(:all, :conditions => "is_transfer = -1")

entities.each do |e|
  if (!e.file_name.to_s.empty? && File.exist?(FILMS_STORAGE_PATH + "/" + e.category + "/" + e.file_name.to_s))
    FileUtils.rm_r(FILMS_STORAGE_PATH + "/" + e.category + "/" + e.file_name.to_s)
  end
  if (!e.file_name.to_s.empty? && File.exist?(FILMS_UPLOAD_PATH + "/" + e.file_name.to_s))
    FileUtils.rm_r(FILMS_UPLOAD_PATH + "/" + e.file_name.to_s)
  end
  puts 'del ' + e.title
  e.destroy
end

FileUtils.rm(RAILS_ROOT + '/lock')

