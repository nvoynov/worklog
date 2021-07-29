# Worklog

[![Ruby](https://github.com/nvoynov/worklog/actions/workflows/main.yml/badge.svg)](https://github.com/nvoynov/worklog/actions/workflows/main.yml)

Welcome to the `worklog` gem! The gem provides a simple domain-specific language (DSL) for tracking work time and a command-line interface (CLI) for processing the time spent. It'll answer some basic questions like "how much time I've spent on this project this month?", "how much I've earned the previous week?", "how much total effort for the subject was", etc.

Hopefully, this set of [User Stories](user stories.md) helps you catch the basic idea, and the following sections of the README will clarify the usage details.

## Installation

Just install it yourself as:

    $ gem install worklog

Or you can (now I cannot see meaning doing that, but you certainly can) add this line to your application's Gemfile:

```ruby
gem 'worklog'
```

And then execute:

    $ bundle install

## Usage

### Worklog CLI

The `worklog` gem command-line interface is build on [Thor](https://github.com/rails/thor), so that your first command should be `worklog help` or `thor list`. Then you can get help for each command individually through `worklog help COMMAND`.

### Worklog DSL

The following example shows all the DSL possibilities:

```ruby
title "worklog"
author "nvoynov"
date_format "%Y-%m-%d" # @see Ruby documentations of Date.strptime
hourly_rate 20.00

track "2021-05-22", spent: "6h30m", task: "working on use cases"
track "2021-05-21", spent: "2h", task: "working on user stories", rate: 30 # this is an special hourly rate for overtime
track "2021-05-21", spent: "8h", task: "working on user stories"
track "2021-05-20", spent: "8h", task: "working on vision document"
```

I think to make a more serious example (sandbox) with which you can play around and see the commands in action. __TODO__ provide a complex example with multiple subjects and authors, several months of log, etc.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/worklog.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
