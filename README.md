# Detour

[![Build Status](https://travis-ci.org/djreimer/detour.png?branch=master)](https://travis-ci.org/djreimer/detour)

Detour is a Ruby gem that scans arbitrary strings of text and allows you to
filter or replace each URL.

Extracted from [Drip](http://www.getdrip.com/).

## Installation

Add this line to your application's Gemfile:

    gem 'detour'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install detour

## Usage

Suppose you have a string that contains any number of URLs and/or hyperlinks
that you would like to replace with shortened versions. You are in luck!
Use the `#replace` method to iterate over each URL and replace with anything
you'd like (the return value of the block):

```ruby
text = "...Some text to process..."
filter = Detour::Filter.new(text)

filter.replace do |url|
  UrlShortener.shorten(url)
end

processed_text = filter.text
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
