ActiveAdmin.register Poll do
  form :partial => 'form'

  controller do 
    def create
      @poll = Poll.new(params[:poll])
      if @poll.save
        params[:choices].each do |choice|
          # choice.last is so I can get the choice value since I built the form
          # to group the choices together in the params.  Probably a better way
          # to do this.
          @poll.poll_choices.create(:choice => choice.last)
        end
        flash[:notice] = 'The poll was created.'
        redirect_to [:admin, @poll]
      else
        flash[:error] = 'There was a problem creating the poll.'
        render :new
      end
    end

    def update
      @poll = Poll.find params[:id]
      if @poll.update_attributes(params[:poll])
        @poll.poll_choices.delete_all
        params[:choices].each do |choice|
          # choice.last is so I can get the choice value since I built the form
          # to group the choices together in the params.  Probably a better way
          # to do this.
          @poll.poll_choices.find_or_create_by_choice(choice.last) if choice.last.present?
        end
        flash[:notice] = 'The poll was updated.'
        redirect_to [:admin, @poll]
      else
        flash[:error] = 'There was a problem updating the poll.'
        render :edit
      end
    end
  end

  show do |poll|
    attributes_table do
      row :id
      row :title
      row :question
      h6 "Choices"
      div do
        simple_format poll.poll_choices.map{|x| x.choice}.join(', ')
      end
      row :min_grade
      row :max_grade
      row :active
    end
    active_admin_comments
  end
  
end
