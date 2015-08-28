require 'carrierwave/processing/rmagick'

class TeamLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "assets/#{model.tenant.id}/#{model.class.name.pluralize.downcase}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  process :resize_to_limit => [400,400]

  version :small do
    process :crop_and_scale
    process :resize_to_fill => [200,200]
  end
  
  version :thumb do
    process :crop_and_scale
    process :resize_to_fill => [100,100]
  end

  version :tiny do
    process :crop_and_scale
    process :resize_to_fill => [50,50]
  end

  version :micro do  
    process :crop_and_scale
    process :resize_to_fill => [25,25]
  end

  def crop_and_scale(resize_to = nil)
    if model.cropping?
      manipulate! do |img|
        img = img.crop(model.crop_x.to_i, model.crop_y.to_i, model.crop_h.to_i, model.crop_w.to_i, true)
        img = img.resize(resize_to, resize_to) if resize_to
        img
      end
    else
      resize_to_limit(resize_to, resize_to)
    end
  end
  
  # Create a 1-row image that has a column for every color in the quantized
  # image. The columns are sorted decreasing frequency of appearance in the
  # quantized image.
  def sort_by_decreasing_frequency(img)
    hist = img.color_histogram
    # sort by decreasing frequency
    sorted = hist.keys.sort_by {|p| -hist[p]}
    new_img = Magick::Image.new(hist.size, 1)
    new_img.store_pixels(0, 0, hist.size, 1, sorted)
  end

  def get_color_map(img)
    palette = Magick::ImageList.new
    pixels = img.get_pixels(0, 0, img.columns, 1)
    map = { :colors => pixels.collect{ |p| p.to_color(Magick::AllCompliance, false, 8, true) } }
    
    primary = pixels[0]
    secondary = ''
    accent = ''
    
    max_diff = 0
    pixels.each do |pixel|
      diff = get_color_diff(primary, pixel)
      if diff > max_diff
        max_diff = diff
        secondary = pixel
      end
    end
    
    max_diff = 0
    pixels.each do |pixel|
      diff = get_color_diff(primary, pixel)
      if diff > max_diff and pixel != secondary
        max_diff = diff
        accent = pixel
      end
    end    
    
    map[:primary] = primary.to_color(Magick::AllCompliance, false, 8, true)
    map[:secondary] = secondary.to_color(Magick::AllCompliance, false, 8, true)
    map[:accent] = accent.to_color(Magick::AllCompliance, false, 8, true)
    map
  end
  
  def get_color_diff(a, b)
    square(a.red-b.red) + square(a.green-b.green) + square(a.blue-b.blue)
  end
  
  def square(n)
    n * n
  end
  

  def color_palette
    cache_stored_file! if !cached?

    img = ::Magick::Image.read(current_path).first
    quantized = img.quantize(8, Magick::RGBColorspace)
    normal = sort_by_decreasing_frequency(quantized)
    map = get_color_map(normal)
  end


end
