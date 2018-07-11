class AddPhoneNumberToCompanies < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :phone_number, :string
    add_column :companies, :phone_number2, :string
    add_column :companies, :phone_number3, :string
  end
end
