module LazyValue
  class ApplicationController < ActionController::Base
    def show
      payload = Base64.urlsafe_decode64(params[:payload])
      data = JSON.parse(LazyValue.message_encryptor.decrypt_and_verify(payload)).wp

      code = File.read(data["path"]).lines[data["lineno"]-1..-1].join

      regex = /<%= lazy_value_tag (?:do|{.+?}) %>(.+?)<% end %>|<%= lazy_value_tag { (.+?) } %>/m
      str = code.match(regex)

      if str.present? && str[1].present?
        erb = ERB.new(str[1], trim_mode: "-")
        render plain: erb.result(binding)
      elsif str.present? && str[2].present?
        render plain: eval(str[2])
      else
        render plain: "Incorrect usage. Try to use \"lazy_value_tag do ... end\" or \"lazy_value_tag { ... }\""
      end
    end
  end
end
