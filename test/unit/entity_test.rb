require 'test_helper'

class EntityTest < ActiveSupport::TestCase
  def test_invalid_with_empty_attributes
    ent = Entity.new
    assert !ent.valid?
    assert ent.errors.invalid?(:title)
    assert ent.errors.invalid?(:user_id)
  end
  
  def test_user_id_field
    ent = Entity.new(:title => 'xxx',
                     :user_id => 5 )
    assert ent.valid?
    ent.user_id = 'x'
    assert !ent.valid?, "Igorrr cool"
  end
  
  def test_unique_title
    ent = Entity.new( :title => entities(:one).title,
                      :user_id => 2)
     assert !ent.save
     assert_equal ActiveRecord::Errors.default_error_messages[:taken], ent.errors.on(:title)
     
  end
end
