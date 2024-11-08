require 'active_interaction'

# User model
class User < ApplicationRecord
  has_many :user_interests
  has_many :interests, through: :user_interests

  has_many :user_skills
  has_many :skills, through: :user_skills

  def full_name
    name + surname + patronymic
  end
end

# Interest model
class Interest < ApplicationRecord
  has_many :user_interests
  has_many :users, through: :user_interests
end

# Skill model
class Skill < ApplicationRecord
  has_many :user_skills
  has_many :users, through: :user_skills
end

# Subtable between users and interests
class UserInterest < ApplicationRecord
  belongs_to :users
  belongs_to :interests
end

# Subtable between users and skills
class UserSkill < ApplicationRecord
  belongs_to :users
  belongs_to :skills
end

module Users
  class Create < ActiveInteraction::Base
    hash :params, strip: false do
      string  :name
      string  :patronymic
      string  :email
      string  :nationality
      string  :country
      string  :gender
      integer :age
    end

    validate :validate_params

    def execute
      @user = User.create(user_params)

      create_interests
      create_skills
    end

    private

    def validate_params
      email_uniqueness
      age_restrictions
      gender_binary_check
    end

    def email_uniqueness
      if User.where(email: params['email']).present?
        errors.add(:email_uniqueness, "email is already taken")
      end
    end

    def age_restrictions
      unless (0...90).include?(params['age'])
        errors.add(:age_restrictions, "your age is out of range")
      end
    end

    def gender_binary_check
      unless ['male','female'].include?(params['gender'])
        errors.add(:gender_binary_check, "check the correct spelling of your gender")
      end
    end

    def user_params
      user_params = params.except('interests', 'skills')
      user_params.merge({full_name: })
    end

    def create_interests
      interests = Interest.where(name: params['interests'])
      user_interests_query = interests.map { |interest| { interest: interest, user: @user }}

      UserInterest.create(
        user_interests_query
      )
    end

    def create_skills
      skills = Skill.where(name: params['skill'].split(','))
      user_skills_query = skills.map { |skill| { skill: skill, user: @user }}

      UserSkill.create(
        user_skills_query
      )
    end
  end
end
