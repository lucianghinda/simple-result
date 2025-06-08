# SimpleResult

A simple, idiomatic Ruby implementation of a response monad for handling success and failure states inspired by https://github.com/maxveldink/sorbet-result.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_result'
```

## Usage

The recommended usage is to use the `Success` and `Failure` helpers to create responses. You can also use the scoped classes 'SimpleResult::Success' and 'SimpleResult::Failure' if you want.

### Basic Usage

```ruby
require 'simple_result'

success = Success("Hello, World!")
success.success? # => true
success.payload  # => "Hello, World!"

failure = Failure("Something went wrong")
failure.failure? # => true
failure.error    # => "Something went wrong"

# Blank responses
Success() # => Success with nil payload
Failure() # => Failure with nil error
```

### Chaining Operations

```ruby
Success("hello")
  .and_then { |value| value.upcase }
  .and_then { |value| "#{value}!" }
# => "HELLO!"

# Failure short-circuiting
Failure("error")
  .and_then { |value| value.upcase }
  .and_then { |value| "#{value}!" }
# => Failure("error")
```

#### A more common case of chaining operations might look like this

```ruby
def validate(value)
  # validation
  Success(value)
end

def transform(value)
  transformed_value = value.upcase

  Success(transformed_value)
end

def present(value)
  presenter = "#{value}!!"

  Success(presenter)
end

validate("hello")
.and_then { |value| transform(value) }
.and_then { |value| present(value) }
# => "HELLO"

# Or since Ruby 3.4 you can also use the implicit `it` block parameter
validate("hello")
.and_then { transform(it) }
.and_then { present(it) }

# or if you prefer to write without paranthesis in a more DSL like style:
validate("hello")
.and_then { transform it }
.and_then { present it }
```

### Error Handling

```ruby
# Handle errors only when they occur
Success("data").on_error { |error| puts "Error: #{error}" }
# => Success("data") - block not called

Failure("oops").on_error { |error| puts "Error: #{error}" }
# => Prints "Error: oops", returns Failure("oops")
```

### Fallback Values

The fallback will be called only when the result is nil or an error.
Please be carefull when using blank Success and Failure values with `payload_or_fallback` because `Success().payload_or_fallback` will always return the fallback value.

```ruby
# Use payload or fallback
Success("value").payload_or_fallback { "default" }
# => "value"

Success(nil).payload_or_fallback { "default" }
# => "default"

Failure("error").payload_or_fallback { "default" }
# => "default"
```

## Development

Run tests:

```bash
ruby test/test_simple_result.rb
```

Run RuboCop:

```bash
rubocop
```

## License

The gem is available as open source under the [MIT License](https://opensource.org/licenses/MIT).
