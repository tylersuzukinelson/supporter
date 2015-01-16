class Request < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true
  validate :done_default

  private

  def done_default
    self.done ||= false
  end

end
