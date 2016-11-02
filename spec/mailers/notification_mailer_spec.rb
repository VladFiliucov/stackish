require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "new_answer_notification" do
    let!(:user) { create(:user) }
    let!(:second_user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscription) { create(:subscription, question: question, user: user) }
    let!(:second_subscription) { create(:subscription, question: question, user: second_user) }
    let(:answer) { create(:answer, question: question) }
    let(:mail) { NotificationMailer.new_answer_notification(answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer notification")
      expect(mail.to).to eq([user.email, second_user.email])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
