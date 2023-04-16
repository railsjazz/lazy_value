# LazyValue

[![RailsJazz](https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/my_other.svg?raw=true)](https://www.railsjazz.com)
[![Listed on OpenSource-Heroes.com](https://opensource-heroes.com/badge-v1.svg)](https://opensource-heroes.com/r/railsjazz/rails_live_reload)

![RailsLiveReload](docs/lazy_value.gif)

Lazy loader for your Ruby on Rails views. Use it you want to parallelise loading of some info on the page. 

Typical use case: you need to show some stats numbers and usually it take 1-2 seconds to calculate each number. In case you have many of them on a single page it might take a while. This solution can help you with that.

It works similar to lazy Turbo frames, but it has no dependency on turbo. Also you don't need to create a new actions to load data.

## Key advantages

1. No JavaScript dependencies (like Turbo)
2. "Plug & Play" approach
3. Supports Turbo Frames

## Important notes

1. Works with ERB only (at least for now)
2. Every lazy value must be atomic and not depend on any value recevied outside it. It means it cannot access variables initialized in the controller/view.

## Usage

```erb
<div class="column is-one-quarter">
    <div class="box has-text-centered">
        <h2 class="subtitle">Number 2</h2>
        <%= lazy_value_tag do %>
          <p class="title"><%= Project.pending.count %>%</p>
        <% end %>
    </div>
</div>
<div class="column is-one-quarter">
    <div class="box has-text-centered">
        <h2 class="subtitle">Number 3</h2>
        <p class="title">
          <%= lazy_value_tag { User.active.count } %>
        </p>
    </div>
</div>
```

It also works with partials:

```erb
<div class="box">
  <%= lazy_value_tag do %>
    <strong>Random 5 users</strong>
    <%= render "/home/users", users: User.limit(5).order("random()") %>
  <% end %>
</div>
```

And even compatible with Turbo.

```erb
<turbo-frame id="messages" target="_top">
  This content is from lazy loaded turbo frame.

  <%= lazy_value_tag do %>
    <h3 class="title"><%= rand(1000) %></h3>
  <% end %>

  <%= lazy_value_tag do %>
    <%= "I'm lazy loaded from the turbo frame" %>
  <% end %>
</turbo-frame>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem "lazy_value"
```

And then execute:
```bash
$ bundle
```

And that is it. Start using it.

## How it works

1. We call `lazy_value_tag` in the view
2. We save location from where it was called (with `caller_locations.first`), file + line number.
3. We encrypt this info using `ActiveSupport::MessageEncryptor`, creating span with spinner, and JS snippet that will call `/lazy_value/show?payload=`
4. In the controller we decrypt our data and reading ERB file and detecting our snippet
5. Depending on the block syntax we evaluate ERB or Ruby.
6. We return from the controller HTML that will replace snippen on the page.

## Testing

`bin/rails test:system`.

## Contributing

You are welcome to contribute.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[<img src="https://github.com/igorkasyanchuk/rails_time_travel/blob/main/docs/more_gems.png?raw=true"
/>](https://www.railsjazz.com/?utm_source=github&utm_medium=bottom&utm_campaign=rails_live_reload)

