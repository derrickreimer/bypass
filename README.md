# Bypass

[![Build Status](https://travis-ci.org/djreimer/bypass.png?branch=master)](https://travis-ci.org/djreimer/bypass)
[![Code Climate](https://codeclimate.com/github/djreimer/bypass.png)](https://codeclimate.com/github/djreimer/bypass)

Bypass is a Ruby gem that scans plain text or HTML documents for URLs and
hyperlinks and allows you to mutate or replace them with ease. This library
was originally designed for appending tracking data and shortening link
URLs in HTML and plain text emails.

Extracted from [Drip](http://www.getdrip.com/).

## Installation

Add this line to your application's Gemfile:

    gem 'bypass'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bypass

## Usage

There are URL filters available for both plain text and HTML documents. 

### Plain Text

To replace all URLs in a plain text document:

```ruby
text = "Visit our website: http://www.getdrip.com"
filter = Bypass::TextFilter.new(text)

filter.replace do |url|
  url.append_to_query_values(:id => 123)
end

filter.content
#=> "Visit our website: http://www.getdrip.com?id=123"
```

### HTML

To replace all `href` attributes in `a` tags in an HTML document:

```ruby
text = "Visit our website: <a href='http://www.getdrip.com'>Drip</a>"
filter = Bypass::HTMLFilter.new(text)

filter.replace do |url|
  url.append_to_query_values(:id => 123)
end

filter.content
#=> "Visit our website: <a href='http://www.getdrip.com?id=123'>Drip</a>"
```

To convert all non-hyperlinked URLs to hyperlinks:

```ruby
text = "Lets auto link this: http://www.google.com"
filter = Bypass::HTMLFilter.new(text)
filter.auto_link

filter.content
#=> "Lets auto link this: <a href='http://www.google.com'>http://www.google.com</a>"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
