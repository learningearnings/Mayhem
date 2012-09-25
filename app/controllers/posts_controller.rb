class PostsController < LoggedInController
#  before_filter :authenticate_user!

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = current_user.person.posts.new
    @options = [["Tip", "TipPost"], ["Testimonial", "TestimonialPost"], ["News", "NewsPost"]]
  end

  def create
    @post = current_user.person.posts.new(params[:post])
    if @post.save
      flash[:notice] = "Your post was saved successfully."
      redirect_to post_path(@post)
    else
      flash[:alert] = "There was an error saving your Post, please check the form and try again."
      render 'new'
    end
  end

end
