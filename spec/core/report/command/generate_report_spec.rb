require 'rails_helper'

describe Report::Command::GenerateReport, type: :command do
  subject { Report::Command::GenerateReport.call(params) }
  let(:params) do
    {
      start_date: dates[0].to_s,
      end_date: dates[-1].to_s,
      email: 'reports@example.com'
    }
  end
  let(:dates) { [*1.month.ago.to_date..Date.today] }

  it 'is ok' do
    expect { subject }.to broadcast(:ok)
  end

  it 'creates valid csv file' do
    users = 4.times.map { create(:user) }

    posts1 = 3.times.map { create(:post, user: users[0], published_at: dates.sample) }
    15.times { create(:comment, user_id: User.ids.sample, post: posts1.sample) }

    posts2 = 2.times.map { create(:post, user: users[1], published_at: dates.sample) }
    21.times { create(:comment, user_id: User.ids.sample, post: posts2.sample) }

    posts3 = 3.times.map { create(:post, user: users[2], published_at: dates.sample) }
    5.times { create(:comment, user_id: User.ids.sample, post: posts3.sample) }

    posts4 = 1.times.map { create(:post, user: users[3], published_at: dates.sample) }
    40.times { create(:comment, user_id: User.ids.sample, post: posts4.sample) }

    subject
    rows = CSV.read(Dir['tmp/Report-by-author*.csv'].last).drop(1)
    expected_nicknames = [3, 0, 1, 2].map { |i| users[i].nickname }
    expect(rows.map { |row| row.first }).to eq(expected_nicknames)
  end
end

=begin

user  (posts_count + comments/10.0) ==  rating
------------------------------------------------
user4      1       +     40 / 10.0  ==     5
user1      3       +     15 / 10.0  ==   4,5
user2      2       +     21 / 10.0  ==   4,1
user3      3       +      5 / 10.0  ==   3.5

=end
