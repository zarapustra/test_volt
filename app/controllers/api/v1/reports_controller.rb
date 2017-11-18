class Api::V1::ReportsController < ApiController
  def by_author
    Report::Command::ByAuthor.call(params.merge(user: current_user)) do
      on(:ok) do |attributes|
        Report::ByAuthorWorker.perform_async(attributes)
        render json: {message: 'Report generation started'}
      end
      on(:invalid) { |errors| render status: 422, json: {errors: errors} }
      on(:unauthorized) { render status: 401 }
    end
  end
end
