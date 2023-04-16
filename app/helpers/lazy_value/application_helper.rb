module LazyValue
  module ApplicationHelper
    SPINNER = <<~SVG
      <svg width="24" height="24" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><style>.spinner_OSmW{transform-origin:center;animation:spinner_T6mA .75s step-end infinite}@keyframes spinner_T6mA{8.3%{transform:rotate(30deg)}16.6%{transform:rotate(60deg)}25%{transform:rotate(90deg)}33.3%{transform:rotate(120deg)}41.6%{transform:rotate(150deg)}50%{transform:rotate(180deg)}58.3%{transform:rotate(210deg)}66.6%{transform:rotate(240deg)}75%{transform:rotate(270deg)}83.3%{transform:rotate(300deg)}91.6%{transform:rotate(330deg)}100%{transform:rotate(360deg)}}</style><g class="spinner_OSmW"><rect x="11" y="1" width="2" height="5" opacity=".14"/><rect x="11" y="1" width="2" height="5" transform="rotate(30 12 12)" opacity=".29"/><rect x="11" y="1" width="2" height="5" transform="rotate(60 12 12)" opacity=".43"/><rect x="11" y="1" width="2" height="5" transform="rotate(90 12 12)" opacity=".57"/><rect x="11" y="1" width="2" height="5" transform="rotate(120 12 12)" opacity=".71"/><rect x="11" y="1" width="2" height="5" transform="rotate(150 12 12)" opacity=".86"/><rect x="11" y="1" width="2" height="5" transform="rotate(180 12 12)"/></g></svg>
    SVG

    def lazy_value_tag(options: {}, &block)
      element_id = "lazy_value_#{SecureRandom.hex(8)}"
      kaller = caller_locations.first

      options[:class] ||= "lazy-value-tag"
      options[:id] = element_id

      data = LazyValue.message_encryptor.encrypt_and_sign(
        {
          path: kaller.path,
          lineno: kaller.lineno
        }.to_json
      )

      content_tag(:span, raw(SPINNER), options) + raw(js_code(data, element_id))
    end

    private
    def js_code(data, element_id)
      <<~html
        <script>
          var remoteServerURL = "/lazy_value/show?payload=#{Base64.urlsafe_encode64(data)}"

          function fetchRemoteContent#{element_id}() {
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

          fetchRemoteContent#{element_id}();
        </script>
      html
    end

  end
end
