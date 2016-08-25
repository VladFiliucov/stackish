require 'rails_helper'

RSpec.describe Commentable do
  with_model :WithCommentable do
    table do |t|
      t.references :user
    end

    model do
      include Commentable
      belongs_to :user
    end
  end
end
