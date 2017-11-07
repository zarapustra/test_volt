class CreatePgViewForUserStats < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE VIEW post_stat AS
        SELECT  posts.user_id, 
                COUNT(comments) as comments_count
        FROM    posts
        LEFT OUTER JOIN comments ON comments.post_id = posts.id
        GROUP BY posts.user_id
    SQL
    execute <<-SQL
      CREATE VIEW user_stats AS
        SELECT
          users.id as user_id,
          COUNT(posts) as posts_count,
          ps.comments_count as comments_count
        FROM
          users
          LEFT JOIN posts ON users.id = posts.user_id
          LEFT JOIN post_stat ps ON users.id = ps.user_id
        GROUP BY
          users.id, 
          comments_count
    SQL
  end

  def down
    execute <<-SQL
        DROP VIEW user_stats;
        DROP VIEW post_stat;
    SQL
  end
end
