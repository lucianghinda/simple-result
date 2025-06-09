# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/simple_result'

class SimpleResultHelpersTest < Minitest::Test
  include SimpleResult::Helpers

  def test_success_helper_creates_success_instance
    success = Success('hello')

    assert_instance_of SimpleResult::Success, success
    assert_equal 'hello', success.payload
  end

  def test_failure_helper_creates_failure_instance
    failure = Failure('error')

    assert_instance_of SimpleResult::Failure, failure
    assert_equal 'error', failure.error
  end

  def test_success_helper_without_args
    success = Success()

    assert_instance_of SimpleResult::Success, success
    assert_nil success.payload
  end

  def test_failure_helper_without_args
    failure = Failure()

    assert_instance_of SimpleResult::Failure, failure
    assert_nil failure.error
  end

  def test_helpers_work_in_chained_operations
    result = Success('hello').
             and_then { |value| Success(value.upcase) }

    assert_equal 'HELLO', result.payload
  end

  def test_helpers_available_after_include
    assert_respond_to self, :Success
    assert_respond_to self, :Failure
  end

  def test_service_style_usage
    service_class = Class.new do
      include SimpleResult::Helpers

      def process(input)
        validate(input).
          and_then { |value| transform(value) }
      end

      private

        def validate(input)
          return Failure('Input required') if input.nil? || input.empty?

          Success(input)
        end

        def transform(input)
          Success(input.upcase)
        end
    end

    service = service_class.new
    result = service.process('test')

    assert_equal 'TEST', result.payload

    error_result = service.process('')

    assert_equal 'Input required', error_result.error
  end
end
