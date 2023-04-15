module LazyValue
  class ApplicationController < ActionController::Base
    def show
      payload = Base64.urlsafe_decode64(params[:payload])
      data = JSON.parse(LazyValue.message_encryptor.decrypt_and_verify(payload))

      code = File.read(data["path"]).lines[data["lineno"]-1..-1].join
      # str = code.match(/<%= lazy_value_tag :#{data["value"]} do %>(.+?)<% end %>/m)
      str = code.match(/<%= lazy_value_tag do %>(.+?)<% end %>/m)
      erb = ERB.new(str[1], trim_mode: "-")

      render plain:erb.result(binding)
    end
  end
end
