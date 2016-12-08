class Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
    puts "got image #{params[:binary_file].inspect}"
    puts "got tempfile #{params[:binary_file].tempfile.inspect}"
    filename = "file_#{current_user.name}_photo.jpg"
    puts "saving image as: #{filename}"
    FileManager.save_file(params[:binary_file].tempfile.path, filename)
  end

  # POST /resource
  def create
    image = params[:binary_file]
    unless image
      puts 'no image'
      return render(
          json: { success: 'failed', errors: ['image not found'] },
          status: :bad_request
      )
    end
    puts 'using FACE++'
    resp = FACE.detection.detect img: image.tempfile.path
    puts "done with FACE++\n#{resp}\n----"
    if resp['face'].empty? || resp['face'].count > 1
      puts 'no face'
      return render(
          json: { success: 'failed', errors: ['face not found or too many faces'] },
          status: :not_acceptable
      )
    end
    params[:picture] = resp['face'].first['face_id']
    puts "picture: #{params[:picture]}"
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, :binary_file, :face_id])
    params.permit(:email, :password, :password_confirmation, :name, :binary_file, :picture)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
