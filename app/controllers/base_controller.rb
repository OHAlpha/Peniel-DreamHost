class BaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :log
  
  protected
  
    def chklog
      if not @isuser
        respond_to do |format|
          format.html { redirect_to login_user_path, notice: 'You must be logged in to view this page.' }
          format.json { render inline '{error:"You must be logged in to view this page."}' }
        end
      end
    end
    
    def chknlog
      if @isuser
        redirect_to user_path
      end
    end
  
    def log
      @isuser = loggedin?
      if @isuser
        @ismember = @current_person.member?
        @ismaintainer = @current_user.maintainer?
        @isdeveloper = @current_user.developer?
        @isadmin = @current_user.admin?
      else
        @ismember = false
        @ismaintainer = false
        @isdeveloper = false
        @isadmin = false
        visit
      end
    end
    
    def loggedin?
      if not session[:person_id].nil?
        if Person.exists?(session[:person_id])
          @current_person = Person.find(session[:person_id])
          @current_user = @current_person.user
        else
          session[:person_id] = nil
        end
      end
      not @current_person.nil?
    end
    
    def visit
      if not session[:visitor_id].nil?
        if Visitor.exists?(session[:visitor_id])
          @current_visitor = Visitor.find(session[:visitor_id])
        else
          @current_visitor = Visitor.create()
          session[:visitor_id] = @current_visitor.id
        end
      end
    end
  
end
