module API
  module ErrorFormatter
    def self.call message, _backtrace, _options, _env, _original_exception
      {response_type: I18n.t("api.error_formatter.error"), response: message}.to_json
    end
  end
end
