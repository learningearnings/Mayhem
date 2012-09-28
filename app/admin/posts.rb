ActiveAdmin.register Post do
  config.filters = false

  form :partial => "form"

  controller do
    before_filter :load_post_types, only: [:new, :create, :edit, :update]
    protected
    def load_post_types
      @post_types = [["Tip", "TipPost"], ["Testimonial", "TestimonialPost"], ["News", "NewsPost"], ["Press Release", "PressRelease"]]
    end
  end
end
