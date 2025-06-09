# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2025-01-09

### Added

- Added `SimpleResult::Helpers` module containing `Success()` and `Failure()` helper methods

### Changed

- **BREAKING CHANGE**: Moved `Success()` and `Failure()` helper methods from global scope to `SimpleResult::Helpers` mixin
- Updated `llms.txt` with new usage patterns and migration guidance

### Removed

- **BREAKING CHANGE**: Removed global `Success()` and `Failure()` helper methods

### Migration Guide

To continue using the `Success()` and `Failure()` helper methods, add `include SimpleResult::Helpers` to your classes:

```ruby
# Before (v0.2.0)
class MyService
  def call
    Success('result')
  end
end

# After (v0.3.0)
class MyService
  include SimpleResult::Helpers

  def call
    Success('result')
  end
end
```

Alternatively, use the namespaced classes directly (no breaking change):

```ruby
SimpleResult::Success.new('result')
SimpleResult::Failure.new(error: 'error')
```

## [0.2.0] - 2025-01-09

### Added

- Added `llms.txt` file with comprehensive usage guide for LLMs

### Changed

- Reorganized tests into focused test files:
  - `simple_result_test.rb`: documentation-style tests for Success/Failure helpers
  - `simple_result_namespaced_test.rb`: tests for SimpleResult::Success, SimpleResult::Failure, SimpleResult::Response
  - `simple_result_cases_test.rb`: edge case tests for inspect and pretty_print methods
