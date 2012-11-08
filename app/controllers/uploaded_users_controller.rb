class UploadedUsersController < LoggedInController
  before_filter :ensure_le_admin!

end
