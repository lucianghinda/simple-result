# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/simple_result'

class SimpleResultNamespacedTest < Minitest::Test
  def test_success_creation
    success = SimpleResult::Success.new('hello')

    assert_equal 'hello', success.payload
    assert_predicate success, :success?
    refute_predicate success, :failure?
  end

  def test_success_blank
    success = SimpleResult::Success.blank

    assert_nil success.payload
    assert_predicate success, :success?
  end

  def test_success_error_raises
    success = SimpleResult::Success.new('hello')

    assert_raises(SimpleResult::ResponseError) { success.error }
  end

  def test_failure_creation
    failure = SimpleResult::Failure.new(error: 'error message')

    assert_equal 'error message', failure.error
    refute_predicate failure, :success?
    assert_predicate failure, :failure?
  end

  def test_failure_blank
    failure = SimpleResult::Failure.blank

    assert_nil failure.error
    assert_predicate failure, :failure?
  end

  def test_failure_payload_raises
    failure = SimpleResult::Failure.new(error: 'error')

    assert_raises(SimpleResult::ResponseError) { failure.payload }
  end

  def test_response_not_implemented
    response = SimpleResult::Response.new

    assert_raises(SimpleResult::NotImplemented) { response.success? }
    assert_raises(SimpleResult::NotImplemented) { response.failure? }
    assert_raises(NotImplementedError) { response.and_then { |x| x } }
  end
end