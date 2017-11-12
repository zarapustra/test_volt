class User::Request::UsersWithCounts < Rectify::Query
  include Rectify::SqlQuery

  def initialize(since, till)
    @since = since
    @till = till
  end

  def model
    User
  end

  def sql
    <<-SQL.strip_heredoc
      SELECT u2.* 
        FROM (
          SELECT u1.*,
                 COUNT(p2) as posts_count,
                 SUM(p2.comments_count)::integer as comments_count
          FROM users u1
          LEFT JOIN (
            SELECT p1.*, 
                   COUNT(c2) as comments_count
            FROM posts p1
            LEFT JOIN (
              SELECT * 
              FROM comments c1 
              WHERE c1.published_at::date >= :since AND c1.published_at::date <= :till  
            ) c2 ON p1.id = c2.post_id
            WHERE p1.published_at::date >= :since AND p1.published_at::date <= :till
            GROUP BY p1.id            
          ) p2 ON p2.user_id = u1.id 
          GROUP BY u1.id   
        ) u2
        ORDER BY (u2.posts_count + u2.comments_count/10) DESC
    SQL
  end

  def params
    {
      since: @since,
      till: @till
    }
  end
end
