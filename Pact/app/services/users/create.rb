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
      params.except('interests', 'skills')
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
