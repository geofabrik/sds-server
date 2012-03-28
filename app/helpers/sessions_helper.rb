module SessionsHelper

   def sign_in(user)
      session[:remember_token] = user.id
      self.current_user = user
   end

   def current_user=(user)
      @current_user = user
   end

   def current_user
      @current_user ||= user_from_remember_token
   end

   def current_user?(user)
      user == current_user
   end

   def deny_access
      redirect_to signin_path, :notice => "Please sign in to access this page."
   end

   def signed_in?
      !current_user.nil?
   end

   def sign_out
      reset_session
      self.current_user = nil
   end

   def store_changeset(changeset)
      session[:changeset_id] = changeset.id
   end

   def current_changeset
      changeset_from_session
   end

   def authenticate
      if user = authenticate_with_http_basic { |u, p| User.authenticate(u, p) }
         @current_user = user
      else
         deny_access unless signed_in?
      end
      return nil
   end

private

   def user_from_remember_token
      User.find_by_id(session[:remember_token])
   end

   def changeset_from_session
      Changeset.find_by_id(session[:changeset_id])
   end

end
