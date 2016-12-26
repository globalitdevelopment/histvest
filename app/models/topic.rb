# == Schema Information
#
# Table name: topics
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  user_id         :integer
#  published       :boolean
#  published_start :datetime
#  published_end   :datetime
#

class Topic < ActiveRecord::Base
  has_paper_trail :if => Proc.new { |t| t.published }
  
  belongs_to :user
  has_and_belongs_to_many :locations
  has_many :references, :dependent => :destroy
  has_one :avatar, :dependent => :destroy
  accepts_nested_attributes_for :locations, :references, :allow_destroy => true
  attr_accessible :title, :content, :user_id, :published, :published_start, :published_end, :references_attributes, :locations_attributes, :avatar_delete, :location_ids

  before_save :destroy_avatar?

  def avatar_delete
    @avatar_delete ||= "0"
  end

  def avatar_delete=(value)
    @avatar_delete = value
  end

  # search configuration

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  settings do 
    mapping do
      indexes :title, analyzer: :norwegian, boost: 10
      indexes :locations do
        indexes :address, analyzer: :norwegian, boost: 5
      end
      indexes :references do
        indexes :title, analyzer: :norwegian, boost: 7
        indexes :creator, analyzer: :norwegian, boost: 3
      end
      indexes :visible?, type: :boolean
      indexes :avatar, index: :not_analyzed
      indexes :url, index: :not_analyzed
    end
  end

  def as_indexed_json opts={}
    opts.merge!(
      only: [:id, :title],
      methods: [:visible?, :avatar_path],
      include: {
        locations: { only: [:address] },
        references: { only: [:title, :creator] }
      }
    )

    if visible?
      ret = published_version.as_json opts
    else
      ret = as_json opts
    end

    ret[:url] = Rails.application.routes.url_helpers.topic_path(self)
    ret[:weight] = search_weight
    ret
  end

  validates :title,
    presence: true,
    uniqueness: true,
    length: { maximum: 100 }

  validates :content,
    presence: true

  scope :published, -> {
    where("(published_start <= ? and published_end >= ?) or (published_end IS NULL and published_start IS NULL)", Time.now, Time.now)
    .where("published = ? OR EXISTS(SELECT 1 FROM versions WHERE item_type='Topic' AND item_id=topics.id AND object->>'published' = 'true')", true)   
  }

  def published?
    # not published if only start or end date is defined
    if (!self.published_start.nil? && self.published_end.nil?) || (self.published_start.nil? && !self.published_end.nil?)
      return false
    end
    
    self.published == true &&
      (
        (self.published_start.nil? && self.published_end.nil?) ||
        (self.published_start <= Time.now && self.published_end >= Time.now)
      )
  end

  def visible?
    ((published_start.nil? && published_end.nil?) || 
    (published_start && published_end && published_start <= Time.now && published_end >= Time.now)) &&
    published || versions.where("object->>'published' = 'true'").exists?
  end 

  def published_version
    if published
      self
    else
      versions.where("object->>'published' = 'true'").last.try(:reify)
    end
  end

  def to_param
    "#{id} #{title}".parameterize
  end

  # Used by search: value, label, img
  def label
    self.title
  end

  def value
    self.title
  end

  def has_avatar?
    !self.avatar.nil? && !self.avatar.avatar_img.nil?
  end

  def avatar_path(size = :thumb)
    if has_avatar?
      self.avatar.avatar_img.url(size)
    else
      ActionController::Base.helpers.image_path("upload-img.gif")
    end
  end

  def search_weight
    @@max ||= SearchTopic.maximum(:view_count) || 1.0
    @@weights ||= Hash[SearchTopic.pluck(:search_string, :view_count)]
    weight = 1
    weight += @@weights[title].to_i * 10/ @@max
  end

  private

  def destroy_avatar?
    if !self.avatar.nil?
      self.avatar.destroy if @avatar_delete == "1"
    end
  end
end
