class User < ActiveRecord::Base
   attr_accessible :firstname, :lastname, :email, :password, :project_id, :active, :admin

   has_many :changesets
   belongs_to :project

   validates :firstname, :presence => true, :length => {:maximum => 64}
   validates :lastname,  :presence => true, :length => {:maximum => 64}

   email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
   validates :email, 
      :presence => true, 
      :format => {:with => email_regex}, 
      :uniqueness => {:case_sensitive => false}

   validates :active, :inclusion => { :in => [true, false] }

   before_save :generate_password

   def has_password?(submitted_password)
      password == submitted_password
   end

   def self.authenticate(email, pwd)
      user = find_by_email(email)
      return nil if user.nil?
      return nil if (user.active? == false)
      return user if user.has_password?(pwd)
   end

private 
   def generate_password
      if new_record?
         foo = (('A'..'Z').to_a << ('a'..'z').to_a << ('1'..'9').to_a ).flatten
         foo.delete_if {|x| x == "I" }
         foo.delete_if {|x| x == "l" }
         foo.delete_if {|x| x == "O" }
         bar = String.new
         8.times { bar << foo.shuffle[0] }
         self.password = bar
      end
   end   

end
