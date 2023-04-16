module LazyValue
  class ApplicationController < ActionController::Base
    REGEX = /<%= lazy_value_tag (?:do|{.+?}) %>(.+?)<% end %>|<%= lazy_value_tag { (.+?) } %>/m
    ERROR_MESSAGE = "Incorrect usage. Try to use \"lazy_value_tag do ... end\" or \"lazy_value_tag { ... }\""

    def show
      matches = code.match(REGEX)
      if matches.present? && matches[1].present?
        render plain: ActionController::Base.render(inline: matches[1])
      elsif matches.present? && matches[2].present?
        render plain: eval(matches[2])
      else
        render plain: ERROR_MESSAGE
      end
    end

    private

    def payload
      Base64.urlsafe_decode64(params[:payload])
    end

    def code
      data = JSON.parse(LazyValue.cryptography.decrypt_and_verify(payload))
      # some security checks
      raise "Incorrect file path" if data["path"] !~ /^#{Rails.root}/ || data["path"].include?("..")

      File.read(data["path"]).lines[data["lineno"]-1..-1].join
    end
  end
end
