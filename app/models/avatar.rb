class Avatar < ActiveRecord::Base
  # include Base64fileAttachable
  belongs_to :user
  mount_uploader :file, AvatarUploader

  def self.new_from_path(path)
    new file: Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, path)))
  end

  def self.from_file(relative_path)
    create file: File.open(File.join(Rails.root, ('/public' + relative_path)))
  end

  def self.new_from_url(url)
    new remote_file_url: url
  end

  def self.new_from_base64(base64_image)
    new.tap do |inst|
      inst.attach_base64(base64_image)
    end
  end

  def attach_base64(base64_image, filename_prefix = 'image_')
    self.file = parse_image_data base64_image, filename_prefix
  end
end
