class AddSocialLinksToParticipantsAndTeamMembers < ActiveRecord::Migration
  def change
    [Participant, TeamMember].each do |m|
      change_table m.table_name do |t|
        t.string :social_twitter
        t.string :social_facebook
        t.string :social_odnoklassniki
        t.string :social_linked_in
        t.string :social_blogger
        t.string :social_vk
        t.string :social_google_plus
      end
    end
  end
end
