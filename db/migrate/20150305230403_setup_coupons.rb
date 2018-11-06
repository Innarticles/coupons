class SetupCoupons < ActiveRecord::Migration[5.0]
  def change
    drop_table(:coupons, if_exists: true)
    drop_table(:coupon_redemptions, if_exists: true)
    create_table :coupons do |t|
      t.string :code, null: false
      t.string :description, null: true
      t.date :valid_from, null: false
      t.date :valid_until, null: true
      t.integer :redemption_limit, default: 1, null: false
      t.integer :coupon_redemptions_count, default: 0, null: false
      t.integer :amount, null: false, default: 0
      t.string :type, null: false
      t.timestamps null: false
      t.integer :owner_id, null: false

      case ActiveRecord::Base.connection.adapter_name
      when 'Mysql2'
        t.text :attachments
      else
        t.text :attachments, default: '{}'
      end
    end

    add_index :coupons, :owner_id
    add_index :coupons, :code, unique: true

    create_table :coupon_redemptions do |t|
      t.belongs_to :coupon, null: false
      t.string :user_id, null: true
      t.string :order_id, null: true
      t.timestamps null: false
    end
  end
end
