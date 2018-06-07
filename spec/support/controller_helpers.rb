module ControllerHelpers
  def sign_in(user = double("user"))
    name = "current_#{user.class.name.downcase}".to_sym

    if user.nil?
      allow(request.env["warden"]).to receive(:authenticate!).and_throw(:warden, { scope: :user })
      allow(controller).to receive(name).and_return(nil)
    else
      allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
      allow(controller).to receive(name).and_return(user)
    end
  end

end
