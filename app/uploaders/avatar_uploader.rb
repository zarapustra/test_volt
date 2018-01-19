class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/new/#{mounted_as}/#{id_partition}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  process resize_to_fill: [300, 300]

  version :thumb do
    process resize_to_fill: [40, 40]
  end

  private

  def id_partition
    case id = model.id
      when Integer
        ('%09d' % id).scan(/\d{3}/).join('/')
      else
        nil
    end
  end
end

# console
# u.update_attributes(:remote_avatar_url => "https://...")
