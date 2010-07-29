require "pagem"

['/public/stylesheets/pagem.css'].each do |file|
    source = File.join(directory,file)
    dest = RAILS_ROOT + file
    FileUtils.cp(source, dest)
end


# move images to public/images/medidata_buttons
['/public/images/pagem'].each do |dir|
  source = File.join(directory,dir)
  dest = RAILS_ROOT + dir
  FileUtils.mkdir_p(dest)
  FileUtils.cp(Dir.glob(source+'/*.*'), dest)
end