require 'rails_helper'

describe Report::Command::GenerateReport, type: :command do
  dates = [*1.month.ago.to_date..Date.today]
  params = {
    start_date: dates[0].to_s,
    end_date: dates[-1].to_s,
    email: 'reports@example.com'
  }

  it 'produces valid report' do
    # seeding
    user1 = create(:user)
    post1 = create(:post, user: user1, published_at: dates.sample)
    40.times { create(:comment, user_id: User.ids.sample, post: post1) }

    user2 = create(:user)
    posts2 = 3.times.map { create(:post, user: user2, published_at: dates.sample) }
    15.times { create(:comment, user_id: User.ids.sample, post: posts2.sample) }

    user3 = create(:user)
    posts3 = 2.times.map { create(:post, user: user3, published_at: dates.sample) }
    21.times { create(:comment, user_id: User.ids.sample, post: posts3.sample) }

    expect { Report::Command::GenerateReport.call(params) }.to broadcast(:ok)
    rows = CSV.read(Dir['tmp/Report-by-author*.csv'].last).drop(1)
    expect(rows.first).to eq([user1.nickname, user1.email, '1', '40'])
    expect(rows.last).to eq([user3.nickname, user3.email, '2', '21'])
  end
end

=begin

user   posts_count  comments    rating
------------------------------------------------
user1      1          40    (1.0 + 40.0/10.0) = 5         1
user2      3          15    (3.0 + 15.0/10.0) = 4,5       3
user3      2          21    (2.0 + 21.0/10.0) = 4,1       2

=end
