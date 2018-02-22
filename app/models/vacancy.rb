require 'elasticsearch/model'

class Vacancy < ApplicationRecord
  include ApplicationHelper

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks
  # index_name [Rails.env, model_name.collection.tr('\/', '-')].join('_')
  #
  # mappings dynamic: 'false' do
  #   indexes :job_title, analyzer: 'english'
  #   indexes :headline, analyzer: 'english'
  #   indexes :job_description, analyzer: 'english'
  #
  #   indexes :school do
  #     indexes :name, analyzer: 'english'
  #     indexes :phase, type: :keyword
  #     indexes :postcode, type: :string
  #     indexes :town, type: :string
  #     indexes :county, type: :string
  #     indexes :address, type: :string
  #   end
  #
  #   indexes :expires_on, type: :date
  #   indexes :starts_on, type: :date
  #   indexes :updated_at, type: :date
  #   indexes :publish_on, type: :date
  #   indexes :status, type: :keyword
  #   indexes :working_pattern, type: :keyword
  #   indexes :minimum_salary, type: :integer
  #   indexes :maximum_salary, type: :integer
  # end

  extend FriendlyId

  friendly_id :slug_candidates, use: :slugged

  enum status: %i[published draft trashed]
  enum working_pattern: %i[full_time part_time]

  belongs_to :school, required: true
  belongs_to :subject, required: false
  belongs_to :pay_scale, required: false
  belongs_to :leadership, required: false

  delegate :name, to: :school, prefix: true, allow_nil: false
  delegate :geolocation, to: :school, prefix: true, allow_nil: true

  acts_as_gov_uk_date :starts_on, :ends_on, :publish_on, :expires_on

  scope :applicable, (-> { where('expires_on >= ?', Time.zone.today) })

  paginates_per 10

  validates :job_title, :job_description, :headline, \
            :minimum_salary, :working_pattern, \
            :slug,  \
            presence: true

  validates :essential_requirements, presence: true, unless: :new_record?

  validates :publish_on, :expires_on, :contact_email, presence: true, if: :contact_email

  validate :minimum_salary_lower_than_maximum, :working_hours, :validity_of_publish_on

  def location
    @location ||= SchoolPresenter.new(school).location
  end

  def self.public_search(filters:, sort:)
    query = VacancySearchBuilder.new(filters: filters, sort: sort).call
    ElasticSearchFinder.new.call(query[:search_query], query[:search_sort])
  end

  # def as_indexed_json(_ = {})
  #   as_json(include: { school: { only: %i[phase postcode name town county address] } })
  # end

  private

  def slug_candidates
    [
      :job_title,
      %i[job_title school_name],
      %i[job_title location],
    ]
  end

  def minimum_salary_lower_than_maximum
    errors.add(:minimum_salary, 'must be lower than the maximum salary') if minimum_higher_than_maximum_salary
  end

  def minimum_higher_than_maximum_salary
    maximum_salary && minimum_salary > maximum_salary
  end

  def working_hours
    return if weekly_hours.blank?
    !!BigDecimal.new(weekly_hours) rescue errors.add(:weekly_hours, 'must be a valid number') && return
    errors.add(:weekly_hours, 'cannot be negative') if BigDecimal.new(weekly_hours).negative?
  end

  def validity_of_publish_on
    errors.add(:publish_on, /can''t be before today/) if publish_on && publish_on < Time.zone.today
  end
end
