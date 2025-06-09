# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require 'prettyprint'
require_relative '../lib/simple_result'

class SimpleResultCasesTest < Minitest::Test
  include SimpleResult::Helpers
  def test_success_inspect_with_nil_payload
    success = Success()
    expected = '#<data SimpleResult::Success payload=nil>'

    assert_equal expected, success.inspect
  end

  def test_success_inspect_with_simple_payload
    success = Success('hello')
    expected = '#<data SimpleResult::Success payload="hello">'

    assert_equal expected, success.inspect
  end

  def test_success_inspect_with_complex_payload
    payload = { key: 'value', number: 42 }
    success = Success(payload)
    expected = "#<data SimpleResult::Success payload=#{payload.inspect}>"

    assert_equal expected, success.inspect
  end

  def test_failure_inspect_with_nil_error
    failure = Failure()
    expected = '#<data SimpleResult::Failure error=nil>'

    assert_equal expected, failure.inspect
  end

  def test_failure_inspect_with_simple_error
    failure = Failure('error message')
    expected = '#<data SimpleResult::Failure error="error message">'

    assert_equal expected, failure.inspect
  end

  def test_failure_inspect_with_complex_error
    error = StandardError.new('complex error')
    failure = Failure(error)
    expected = "#<data SimpleResult::Failure error=#{error.inspect}>"

    assert_equal expected, failure.inspect
  end

  def test_success_pretty_print_with_nil_payload
    success = Success()
    pp = StringIO.new
    success.pretty_print(PrettyPrint.new(pp))
    expected = '#<data SimpleResult::Success payload=nil>'

    assert_equal expected, pp.string
  end

  def test_success_pretty_print_with_simple_payload
    success = Success('hello')
    pp = StringIO.new
    success.pretty_print(PrettyPrint.new(pp))
    expected = '#<data SimpleResult::Success payload="hello">'

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

  def test_failure_pretty_print_with_nil_error
    failure = Failure()
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = '#<data SimpleResult::Failure error=nil>'

    assert_equal expected, pp.string
  end

  def test_failure_pretty_print_with_simple_error
    failure = Failure('error message')
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = '#<data SimpleResult::Failure error="error message">'

    assert_equal expected, pp.string
  end

  def test_failure_pretty_print_with_complex_error
    error = { type: 'validation', details: ['field required'] }
    failure = Failure(error)
    pp = StringIO.new
    failure.pretty_print(PrettyPrint.new(pp))
    expected = "#<data SimpleResult::Failure error=#{error.inspect}>"

    assert_equal expected, pp.string
  end
end
