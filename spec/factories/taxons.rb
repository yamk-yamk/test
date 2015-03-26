# == Schema Information
#
# Table name: taxons
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  position    :integer
#  name        :string(255)
#  permalink   :string(255)
#  description :text(65535)
#  lft         :integer          not null
#  rgt         :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :taxon do
    parent_id 1
positon 1
name "MyString"
permalink "MyString"
taxonomy_id 1
description "MyText"
  end

end
