# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/simple_result'

class SimpleResultTest < Minitest::Test
  include SimpleResult::Helpers
  def test_success_helper_method
    success = Success('hello')

    assert_equal 'hello', success.payload
    assert_predicate success, :success?
    refute_predicate success, :failure?
    assert_instance_of SimpleResult::Success, success
  end

  def test_success_helper_method_without_args
    success = Success()

    assert_nil success.payload
    assert_predicate success, :success?
    assert_instance_of SimpleResult::Success, success
  end

  def test_failure_helper_method
    failure = Failure('error')

    assert_equal 'error', failure.error
    refute_predicate failure, :success?
    assert_predicate failure, :failure?
    assert_instance_of SimpleResult::Failure, failure
  end

  def test_failure_helper_method_without_args
    failure = Failure()

    assert_nil failure.error
    refute_predicate failure, :success?
    assert_predicate failure, :failure?
    assert_instance_of SimpleResult::Failure, failure
  end

  def test_success_and_then
    success = Success('hello')
    result = success.and_then(&:upcase)

    assert_equal 'HELLO', result
  end

  def test_failure_and_then
    failure = Failure('error')
    result = failure.and_then(&:upcase)

    assert_equal failure, result
  end

  def test_success_on_error
    success = Success('hello')
    called = false
    result = success.on_error { called = true }

    refute called
    assert_equal success, result
  end

  def test_failure_on_error
    failure = Failure('error')
    called_with = nil
    result = failure.on_error { |error| called_with = error }

    assert_equal 'error', called_with
    assert_equal failure, result
  end

  def test_payload_or_fallback_with_payload
    success = Success('hello')
    result = success.payload_or_fallback { 'fallback' }

    assert_equal 'hello', result
  end

  def test_payload_or_fallback_without_payload
    success = Success(nil)
    result = success.payload_or_fallback { 'fallback' }

    assert_equal 'fallback', result
  end

  def test_failure_payload_or_fallback
    failure = Failure('error')
    result = failure.payload_or_fallback { 'fallback' }

    assert_equal 'fallback', result
  end
end
