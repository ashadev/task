class AddCompanyNameToCompany < ActiveRecord::Migration[5.1]
  def change
    add_column :companies, :company_name, :string
    add_column :companies, :address, :string
    add_column :companies, :owner_name, :string
  end
end
