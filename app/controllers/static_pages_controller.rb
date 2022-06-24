class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy, @feed_items = pagy(Micropost.feed(current_user).recent_posts,
                              items: Settings.paging.posts_per_page)
  end

  def help; end

  def contact; end
end
