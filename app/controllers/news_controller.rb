class NewsController < ApplicationController
  def index
    posts = NewsPost.most_recent.page(params[:page])
    press_releases = PressRelease.most_recent.limit(4)
    render 'index', locals: { posts: posts, press_releases: press_releases }
  end
end
