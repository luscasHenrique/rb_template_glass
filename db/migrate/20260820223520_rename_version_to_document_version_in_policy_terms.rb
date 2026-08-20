class RenameVersionToDocumentVersionInPolicyTerms < ActiveRecord::Migration[8.1]
  def change
    rename_column :policy_terms, :version, :document_version
  end
end
