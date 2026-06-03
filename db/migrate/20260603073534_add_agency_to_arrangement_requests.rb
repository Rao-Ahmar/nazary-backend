class AddAgencyToArrangementRequests < ActiveRecord::Migration[8.0]
  def change
    add_reference :arrangement_requests, :agency, null: true, foreign_key: { to_table: :users }
  end
end
