module LazyValue
  class ApplicationController < ActionController::Base
    REGEXP = /<%= lazy_value_tag(?:.*?)do %>(.*?)<% end %>|<%= lazy_value_tag { (.+?) } %>/m
    ERROR_MESSAGE = "Incorrect usage. Try to use \"lazy_value_tag do ... end\" or \"lazy_value_tag { ... }\""

    def show
      matches = code.match(REGEXP)
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
      # I want to return only first found lazy_value_tag snippet
      snippet = File.read(data["path"]).lines[data["lineno"]-1..-1]
      result = []
      times = 0
      snippet.map do |line|
        times += 1 if line =~ /<%= lazy_value_tag/
        break if times > 1
        result << line
      end
      result.join
    end
  end
end
