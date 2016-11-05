require 'rails_helper'

RSpec.describe SendNotificationsJob, type: :job do
  let!(:user){ create(:user) }
  let(:second_user){ create(:user) }
  let!(:question){ create(:question, user: user) }
  let!(:first_subscription) { create(:subscription, question: question, user: user) }
  let!(:second_subscription) { create(:subscription, question: question, user: second_user) }
  subject { build(:answer, question: question) }

  it 'notifies subscribed users via email' do
    expect(SendNotificationsJob).to receive(:perform_later).with(subject)
    subject.save!
  end

  it 'does not notify subscribed users via email after update' do
    subject.save!
    expect(SendNotificationsJob).to_not receive(:perform_later)
    subject.update(body: "I will never ever set that long length ever again")
  end
end
