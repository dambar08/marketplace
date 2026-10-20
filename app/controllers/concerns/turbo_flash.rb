module TurboFlash
  extend ActiveSupport::Concern

  included do
    after_action :append_flash_turbo_stream
  end

  private
    def append_flash_turbo_stream
      return unless turbo_stream_response?
      return if flash.empty?
      return if response.body.include?("action=\"redirect\"")

      response.body = "#{response.body}#{turbo_stream.update("flash", partial: "shared/flash")}"
      flash.discard
    end

    def turbo_stream_response?
      !response.committed? && response.media_type == Mime[:turbo_stream].to_s && response.body.present?
    end
end
