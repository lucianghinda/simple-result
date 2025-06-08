# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require 'prettyprint'
require_relative '../lib/simple_result'

class TestSimpleResult < Minitest::Test
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

  def test_success_and_then
    success = SimpleResult::Success.new('hello')
    result = success.and_then(&:upcase)

    assert_equal 'HELLO', result
  end

  def test_failure_and_then
    failure = SimpleResult::Failure.new(error: 'error')
    result = failure.and_then(&:upcase)

    assert_equal failure, result
  end

  def test_success_on_error
    success = SimpleResult::Success.new('hello')
    called = false
    result = success.on_error { called = true }

    refute called
    assert_equal success, result
  end

  def test_failure_on_error
    failure = SimpleResult::Failure.new(error: 'error')
    called_with = nil
    result = failure.on_error { |error| called_with = error }

    assert_equal 'error', called_with
    assert_equal failure, result
  end

  def test_payload_or_fallback_with_payload
    success = SimpleResult::Success.new('hello')
    result = success.payload_or_fallback { 'fallback' }

    assert_equal 'hello', result
  end

  def test_payload_or_fallback_without_payload
    success = SimpleResult::Success.new(nil)
    result = success.payload_or_fallback { 'fallback' }

    assert_equal 'fallback', result
  end

  def test_failure_payload_or_fallback
    failure = SimpleResult::Failure.new(error: 'error')
    result = failure.payload_or_fallback { 'fallback' }

    assert_equal 'fallback', result
  end

  def test_response_not_implemented
    response = SimpleResult::Response.new

    assert_raises(SimpleResult::NotImplemented) { response.success? }
    assert_raises(SimpleResult::NotImplemented) { response.failure? }
    assert_raises(NotImplementedError) { response.and_then { |x| x } }
  end

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

  # Inspect method tests for Success
  def test_success_inspect_with_nil_payload
    success = Success()
    expected = "#<data SimpleResult::Success payload=nil>"
    
    assert_equal expected, success.inspect
  end

  def test_success_inspect_with_simple_payload
    success = Success("hello")
    expected = "#<data SimpleResult::Success payload=\"hello\">"
    
    assert_equal expected, success.inspect
  end

  def test_success_inspect_with_complex_payload
    payload = { key: "value", number: 42 }
    success = Success(payload)
    expected = "#<data SimpleResult::Success payload=#{payload.inspect}>"
    
    assert_equal expected, success.inspect
  end

  # Inspect method tests for Failure
  def test_failure_inspect_with_nil_error
    failure = Failure()
    expected = "#<data SimpleResult::Failure error=nil>"
    
    assert_equal expected, failure.inspect
  end

  def test_failure_inspect_with_simple_error
    failure = Failure("error message")
    expected = "#<data SimpleResult::Failure error=\"error message\">"
    
    assert_equal expected, failure.inspect
  end

  def test_failure_inspect_with_complex_error
    error = StandardError.new("complex error")
    failure = Failure(error)
    expected = "#<data SimpleResult::Failure error=#{error.inspect}>"
    
    assert_equal expected, failure.inspect
  end

  # Pretty print tests for Success
  def test_success_pretty_print_with_nil_payload
    success = Success()
    pp = StringIO.new
    success.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Success payload=nil>"
    
    assert_equal expected, pp.string
  end

  def test_success_pretty_print_with_simple_payload
    success = Success("hello")
    pp = StringIO.new
    success.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Success payload=\"hello\">"
    
    assert_equal expected, pp.string
  end

  def test_success_pretty_print_with_complex_payload
    payload = [1, 2, { nested: true }]
    success = Success(payload)
    pp = StringIO.new
    success.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Success payload=#{payload.inspect}>"
    
    assert_equal expected, pp.string
  end

  # Pretty print tests for Failure
  def test_failure_pretty_print_with_nil_error
    failure = Failure()
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Failure error=nil>"
    
    assert_equal expected, pp.string
  end

  def test_failure_pretty_print_with_simple_error
    failure = Failure("error message")
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Failure error=\"error message\">"
    
    assert_equal expected, pp.string
  end

  def test_failure_pretty_print_with_complex_error
    error = { type: "validation", details: ["field required"] }
    failure = Failure(error)
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Failure error=#{error.inspect}>"
    
    assert_equal expected, pp.string
  end
end
