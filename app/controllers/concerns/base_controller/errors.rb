module BaseController
  module Errors
    extend ActiveSupport::Concern

    def render_403(opts = {})
      render_4xx_error({ message: t('errors.not_authorized'), status: 403 }.merge(opts))
      return false
    end


    def render_404(opts = {})
      render_4xx_error({ message: t('errors.file_not_found'), status: 404 }.merge(opts))
      return false
    end


    # Renders an error response
    def render_4xx_error(arg)
      arg = { message: arg } unless arg.is_a?(Hash)

      @message    = arg[:message]
      @status     = arg[:status] || 500
      @page_title = "#{t('text.error')} #{@status}"

      respond_to do |format|
        format.html { render template: 'common/error', status: @status }
        format.any { head @status }
      end
    end

  end
end