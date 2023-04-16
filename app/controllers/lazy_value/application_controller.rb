module LazyValue
  class ApplicationController < ActionController::Base
    REGEX = /<%= lazy_value_tag (?:do|{.+?}) %>(.+?)<% end %>|<%= lazy_value_tag { (.+?) } %>/m

    def show
      data = JSON.parse(LazyValue.cryptography.decrypt_and_verify(payload))
      code = File.read(data["path"]).lines[data["lineno"]-1..-1].join
      str = code.match(REGEX)

      if str.present? && str[1].present?
        render plain: ActionController::Base.render(inline: str[1])
      elsif str.present? && str[2].present?
        render plain: eval(str[2])
      else
        render plain: "Incorrect usage. Try to use \"lazy_value_tag do ... end\" or \"lazy_value_tag { ... }\""
      end
    end

    private

    def payload
      Base64.urlsafe_decode64(params[:payload])
    end
  end
end
