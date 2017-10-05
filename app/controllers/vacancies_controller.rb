class VacanciesController < ApplicationController
  def index
    @filters = VacancyFilters.new(params)
    @sort = VacancySort.new(default_column: 'expires_on', default_order: 'asc')
                       .update(column: sort_column, order: sort_order)
    @query = Vacancy.public_search(filters: @filters, sort: @sort)
    @vacancies = @query.page(params[:page]).records
  end

  def show
    @vacancy = Vacancy.published.friendly.find(params[:id])
  end
  def new
    @vacancy = Vacancy.new
  end

  def create
    @vacancy = CreateVacancy.new(School.first).call(vacancy_params)
    if @vacancy.valid?
      redirect_to publish_vacancy_path(@vacancy)
    else
      render :new
    end
  end

  def publish
    @vacancy = Vacancy.friendly.find(params[:id])
  end

  def edit
    @vacancy = Vacancy.friendly.find(params[:id])
  end

  private

  def vacancy_params
    params.require(:vacancy).permit(:job_title, :headline, :job_description,
                                    :starts_on, :ends_on, :weekly_hours,
                                    :pay_scale_id, :leadership_id, :subject_id,
                                    :benefits, :essential_requirements, :education,
                                    :qualifications, :publish_on, :working_pattern,
                                    :expires_on, :minimum_salary, :maximum_salary)
  end


  def sort_column
    params[:sort_column]
  end

  def sort_order
    params[:sort_order]
  end
end
