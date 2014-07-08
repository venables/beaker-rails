def sign_in_user(user)
  allow(controller).to receive(:current_user) { user }
end

def sign_out_user
  controller.send(:sign_out)
end

def current_user
  controller.send(:current_user)
end
