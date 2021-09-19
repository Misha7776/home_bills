class AddUserAssociationToWebhookEndpoint < ActiveRecord::Migration[6.1]
  def change
    add_reference :webhook_endpoints, :user, index: true
  end
end
