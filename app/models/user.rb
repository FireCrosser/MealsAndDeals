class User < ApplicationRecord
  has_one :role
  has_secure_password
end
