class AddColumnsToReferences < ActiveRecord::Migration
  def self.up
    add_column :references, :pages, :string
    add_column :references, :embl_id, :string
    add_column :references, :medline, :string
    add_column :references, :journal, :string
    add_column :references, :volume, :string
    add_column :references, :issue, :string
    add_column :references, :url, :string

  end

  def self.down
    remove_column :references, :url
    remove_column :references, :issue
    remove_column :references, :volume
    remove_column :references, :journal
    remove_column :references, :medline
    remove_column :references, :embl_id
    remove_column :references, :pages
  end
end
