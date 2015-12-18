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
      indexes :id, index: :not_analyzed
      indexes :suggest, type: :completion, analyzer: :simple, payloads: true
      indexes :title, analyzer: :norwegian, boost: 5
      indexes :content, analyzer: :norwegian
      indexes :visible?, index: :not_analyzed
      indexes :locations do
        indexes :address, analyzer: :norwegian, boost: 3
      end
      indexes :references do
        indexes :title, analyzer: :norwegian, boost: 2
        indexes :creator, analyzer: :norwegian, boost: 4
      end
    end
  end

  def as_indexed_json opts={}
    opts.merge!(
      only: [:id, :title, :content],
      methods: [:visible?, :to_params],
      include: {
        locations: { only: [:address] },
        references: { only: [:title, :creator] }
      }
    )
    ret = as_json opts
    ret[:suggest] = {
      input: [title] + locations.map(&:address) + references.map(&:title) + references.map(&:creator),
      output: title,
      weight: search_weight,
      payload: { url: Rails.application.routes.url_helpers.topic_path(self), avatar: avatar_path }
    }
    ret
  end

  include PgSearch
    pg_search_scope :assoc_search,
          :against => [:title, :content],
          :associated_against => {
            :locations => [:address],
            :references => [:title, :creator, :snippet]},
          :using => {
            :tsearch => {:prefix => true}
          }

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
    self.class.published.where(id: id).exists?
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
    @@max ||= SearchTopic.maximum(:view_count)
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
