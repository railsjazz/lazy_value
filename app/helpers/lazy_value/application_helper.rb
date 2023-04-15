module LazyValue
  module ApplicationHelper

    def lazy_value_tag(options: {}, &block)
      element_id = "lazy_value_#{SecureRandom.hex(8)}"
      kaller = caller_locations.first

      options[:class] ||= "lazy-value"
      options[:data] ||= {}
      options[:id] = element_id

      data = LazyValue.message_encryptor.encrypt_and_sign(
        {
          path: kaller.path,
          lineno: kaller.lineno
        }.to_json
      )

      content_tag(:span, nil, options) + raw(js_code(data, element_id))
    end

    private
    def js_code(data, element_id)
      <<~html
        <script>
          var remoteServerURL = "/lazy_value/show?payload=#{Base64.urlsafe_encode64(data)}"
          function fetchRemoteContent() {
            var xhr = new XMLHttpRequest();

            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    if (xhr.status >= 200 && xhr.status < 400) {
                        var data = xhr.responseText; // Use JSON.parse(xhr.responseText) if the response is in JSON format
                        var contentContainer = document.getElementById('#{element_id}');
                        contentContainer.innerHTML = data;
                    } else {
                        console.error('Error fetching remote content:', xhr.status);
                    }
                }
            };

            xhr.open('GET', remoteServerURL, true);
            xhr.send();
          }

          fetchRemoteContent();
        </script>
      html
    end

  end
end
