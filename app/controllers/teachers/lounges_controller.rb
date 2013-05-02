module Teachers
  class LoungesController < Teachers::BaseController
    def show
      tips = TipPost.most_recent.page(params[:page])
      testimonials = TestimonialPost.most_recent.limit(10)
      render locals: { tips: tips, testimonials: testimonials }
    end
  end
end
