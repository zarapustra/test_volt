require 'csv'
require 'zip'

class Report::Command::GenerateReport < Rectify::Command
  attr_reader :file_name, :msg_error

  def initialize(params)
    @msg_error = nil
    @file_name = "Report-by-author-#{Time.now.to_i}"
    @users = User::Request::UsersWithCounts.new(
      params[:start_date], params[:end_date]
    ).query
  end

  def call
    return broadcast(:ok, "#{file_name}.zip") if perform
    broadcast(:error, msg_error)
  end

  def perform
    remove_old_files!
    zip_csv! if generate_csv!
  end

  private

  def remove_old_files! # TODO refactor
    Dir['tmp/Report-by-author*.csv'].map { |f| File.delete(f) }
    Dir['tmp/Report-by-author*.zip'].map { |f| File.delete(f) }
  end

  def generate_csv!
    CSV.open("tmp/#{file_name}.csv", 'wb') do |csv|
      csv << %w(nickname email posts_count comments_count)
      @users.each do |u|
        csv << [u.nickname, u.email, u.posts_count, u.comments_count]
      end
    end
  rescue => e
    @msg_error = "CSV: #{e.message}"
    false
  end

  def zip_csv!
    Zip::File.open("tmp/#{file_name}.zip", Zip::File::CREATE) do |z|
      z.add("#{file_name}.csv", 'tmp')
    end
  rescue => e
    @msg_error = "ZIP: #{e.message}"
    false
  end
end
