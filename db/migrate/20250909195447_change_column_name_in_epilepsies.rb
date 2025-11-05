class ChangeColumnNameInEpilepsies < ActiveRecord::Migration[5.2]
  def change
    rename_column :epilepsies, :week6_Engel, :week6_engel
    rename_column :epilepsies, :week6_ILAE, :week6_ilae
    rename_column :epilepsies, :month6_Engel, :month6_engel
    rename_column :epilepsies, :month6_ILAE, :month6_ilae
    rename_column :epilepsies, :year1_Engel, :year1_engel
    rename_column :epilepsies, :year1_ILAE, :year1_ilae
    rename_column :epilepsies, :year2_Engel, :year2_engel
    rename_column :epilepsies, :year2_ILAE, :year2_ilae
    rename_column :epilepsies, :year3_Engel, :year3_engel
    rename_column :epilepsies, :year3_ILAE, :year3_ilae
    rename_column :epilepsies, :year4_Engel, :year4_engel
    rename_column :epilepsies, :year4_ILAE, :year4_ilae
    rename_column :epilepsies, :year5_Engel, :year5_engel
    rename_column :epilepsies, :year5_ILAE, :year5_ilae
    rename_column :epilepsies, :year10_Engel, :year10_engel
    rename_column :epilepsies, :year10_ILAE, :year10_ilae
    rename_column :epilepsies, :year11_Engel, :year11_engel
    rename_column :epilepsies, :year11_ILAE, :year11_ilae
    rename_column :epilepsies, :year12_Engel, :year12_engel
    rename_column :epilepsies, :year12_ILAE, :year12_ilae
    rename_column :epilepsies, :year13_Engel, :year13_engel
    rename_column :epilepsies, :year13_ILAE, :year13_ilae
    rename_column :epilepsies, :year14_Engel, :year14_engel
    rename_column :epilepsies, :year14_ILAE, :year14_ilae
    rename_column :epilepsies, :year15_Engel, :year15_engel
    rename_column :epilepsies, :year15_ILAE, :year15_ilae
    rename_column :epilepsies, :addNotes, :add_notes
  end
end
