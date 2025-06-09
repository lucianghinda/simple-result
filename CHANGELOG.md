# Changelog

All notable changes to this project will be documented in this file.

## [0.2.0]

### Added

- Added `llms.txt` file with comprehensive usage guide for LLMs

### Changed

- Reorganized tests into focused test files:
  - `simple_result_test.rb`: documentation-style tests for Success/Failure helpers
  - `simple_result_namespaced_test.rb`: tests for SimpleResult::Success, SimpleResult::Failure, SimpleResult::Response
  - `simple_result_cases_test.rb`: edge case tests for inspect and pretty_print methods
