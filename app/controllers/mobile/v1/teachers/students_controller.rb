class Mobile::V1::Teachers::StudentsController < Mobile::V1::Teachers::BaseController
  def index
    @students = current_school.students.includes(:avatars).where(status: "active").order(:first_name, :last_name)
    #@students = Student.joins(:person_school_links).includes(:avatars).merge(person_school_links(:status_active)).send(:status_active)
    #@students.each do | student |
    #  student.checking_history = Plutus::Amount.where(account_id: student.checking_account).order(" id desc ")
    #end
  end

  def show
    # TODO: Fix slowness
    #@student = current_school.students.find(params[:id])
    @student = Student.find(params[:id])
    @checking_history = Plutus::Amount.where(account_id: @student.checking_account).order(" id desc ")
  end

  def create
    #validation
    if !params[:student][:first_name] 
      render json: { status: :unprocessible_entity, message: "Student first name is required" } and return
    end 
    if !params[:student][:last_name] 
      render json: { status: :unprocessible_entity, message: "Student last name is required" } and return
    end 
    if !params[:student][:password] 
      render json: { status: :unprocessible_entity, message: "Student password is required" } and return
    end    
    if !params[:student][:username] 
      render json: { status: :unprocessible_entity, message: "Student username is required" } and return
    end    
    if !params[:student][:grade] 
      render json: { status: :unprocessible_entity, message: "Student grade is required" } and return
    end
    if Spree::User.where(username: params[:student][:username]).first
      render json: { status: :unprocessible_entity, message: "Student username must be unique" } and return
    end
    @student = Student.new   
    @student.first_name = params[:student][:first_name]
    @student.last_name = params[:student][:last_name]
    @student.grade = params[:student][:grade]
    @student.gender = params[:student][:gender] 
    
    
    if @student.save
      @student.user.update_attributes(username: params[:student][:username], password: params[:student][:password], password_confirmation: params[:student][:password_confirmation])
      @student.user.email = params[:student][:email]
      @student.school = current_school
      @student.save
      @student.user.confirmed_at = Time.now
      @student.user.save
      
      #Add classroom
      psl = PersonSchoolLink.where(person_id: @student.id, school_id: current_school.id).first_or_initialize
      pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: params[:student][:classroom_id]).first_or_initialize
      pscl.status = "active"
      if pscl.save   
        render json: { status: :ok, student: @student.id }
      else
        render json: { status: :unprocessible_entity, message: "Could not create student in classroom " } 
      end
    else
      render json: { status: :unprocessible_entity, message: "Could not create student"  }    
    end
  end


  def update
    @student = Student.find(params[:id])
    @student.first_name = params[:student][:first_name]
    @student.last_name = params[:student][:last_name]
    @student.grade = params[:student][:grade]
    @student.gender = params[:student][:gender]   
    @student.user.username = params[:student][:username] 
    @student.user.email = params[:student][:email]  
    @student.user.password = params[:student][:password]         
    if @student.user.save and @student.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessible_entity }
    end
  end

  def add_classrooms
    @student = Student.find(params[:id])
    psl = PersonSchoolLink.where(person_id: @student.id, school_id: current_school.id).first
    params[:classroom_ids].each do |classroom_id|
      pscl = PersonSchoolClassroomLink.where(person_school_link_id: psl.id, classroom_id: classroom_id).first_or_initialize
      pscl.status = "active"
      pscl.save
    end
    render json: { status: :ok }
  end
end
