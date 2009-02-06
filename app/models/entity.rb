class Entity < ActiveRecord::Base
    
  require 'RMagick'
  require "ftools"
  include Magick
  
  belongs_to :user
  has_many :comments

  validates_presence_of :title
  validates_uniqueness_of :title
  validates_presence_of :user_id
  validates_numericality_of :user_id
  
  attr_protected :is_submit, :karma, :is_transfer

  FILMS_CATEGORIES = [['Другая', 'other'], ['Комедия', 'comedy'], ['Ужастик', 'horror'], ['Мультфильм', 'mult']]
#  @@films_categories = {:none => 'Нету', :comedy => 'Комедия'}

  def before_destroy
    FileUtils.rm_rf("#{IMAGES_STORAGE_PATH}/entities/#{self[:id]}/")
  end
  
  def get_category
    FILMS_CATEGORIES.each do |v, k|
      if self.category == k
        return v
      end
    end
    return 'Другая'    
  end

end
