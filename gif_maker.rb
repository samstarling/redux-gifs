require 'RMagick'

include Magick

image_files = Dir.foreach('output').select do |item|
  item.size > 10
end

filenames = image_files.map do |item|
  "output/#{item}"
end

imagelist = ImageList.new(filenames.first)
filenames.each do |x|
  begin
    a = Image.read(x)
    imagelist << a.first
  rescue => e
    puts "#{x} - #{e}"
  end
end
imagelist.write("news.gif")