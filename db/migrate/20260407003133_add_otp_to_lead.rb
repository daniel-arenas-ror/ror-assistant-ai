class AddOtpToLead < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :otp_code, :string
    add_column :leads, :otp_sent_at, :datetime
  end
end
