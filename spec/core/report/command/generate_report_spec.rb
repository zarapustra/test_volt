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
    posts1 = 3.times.map { create(:post, user: user1, published_at: dates.sample) }
    15.times { create(:comment, user_id: User.ids.sample, post: posts1.sample) }

    user2 = create(:user)
    posts2 = 2.times.map { create(:post, user: user2, published_at: dates.sample) }
    21.times { create(:comment, user_id: User.ids.sample, post: posts2.sample) }

    expect { Report::Command::GenerateReport.call(params) }.to broadcast(:ok)
    rows = CSV.read(Dir['tmp/Report-by-author*.csv'].last).drop(1)
    expect(rows.size).to eq(2)
    expect(rows.first).to eq([user1.nickname, user1.email, '3', '15'])
    expect(rows.last).to eq([user2.nickname, user2.email, '2', '21'])

    user3 = create(:user)
    posts3 = 3.times.map { create(:post, user: user3, published_at: dates.sample) }
    5.times { create(:comment, user_id: User.ids.sample, post: posts3.sample) }

    expect { Report::Command::GenerateReport.call(params) }.to broadcast(:ok)
    rows = CSV.read(Dir['tmp/Report-by-author*.csv'].last).drop(1)
    expect(rows.first[0]).to eq(user1.nickname)
    expect(rows.last[0]).to eq(user3.nickname)

    user4 = create(:user)
    posts4 = 1.times.map { create(:post, user: user4, published_at: dates.sample) }
    40.times { create(:comment, user_id: User.ids.sample, post: posts4.sample) }

    expect { Report::Command::GenerateReport.call(params) }.to broadcast(:ok)
    rows = CSV.read(Dir['tmp/Report-by-author*.csv'].last).drop(1)
    expect(rows.first[0]).to eq(user4.nickname)
    expect(rows.last[0]).to eq(user3.nickname)
  end
end

=begin

user  (posts_count + comments/10.0) =  rating
------------------------------------------------
user4      1       +     40 / 10.0  =     5
user1      3       +     15 / 10.0  =   4,5
user2      2       +     21 / 10.0  =   4,1
user3      3       +      5 / 10.0  =   3.5

=end
