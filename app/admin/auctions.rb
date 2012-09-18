ActiveAdmin.register Auction do
  controller do
    with_role :le_admin
  end
end
