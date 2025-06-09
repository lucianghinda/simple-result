# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/simple_result'

class SimpleResultNoHelpersTest < Minitest::Test
  def test_success_helper_not_available_without_include
    assert_raises(NameError) { Success('test') }
  end

  def test_failure_helper_not_available_without_include
    assert_raises(NameError) { Failure('test') }
  end

  def test_namespaced_classes_still_available
    success = SimpleResult::Success.new('test')

    assert_instance_of SimpleResult::Success, success
    assert_equal 'test', success.payload

    failure = SimpleResult::Failure.new(error: 'error')

    assert_instance_of SimpleResult::Failure, failure
    assert_equal 'error', failure.error
  end

  def test_blank_methods_still_work
    success = SimpleResult::Success.blank

    assert_instance_of SimpleResult::Success, success
    assert_nil success.payload

    failure = SimpleResult::Failure.blank

    assert_instance_of SimpleResult::Failure, failure
    assert_nil failure.error
  end

  def test_chaining_still_works_with_namespaced_classes
    result = SimpleResult::Success.new('hello').
             and_then(&:upcase)

    assert_equal 'HELLO', result
  end

  def test_error_handling_still_works
    success = SimpleResult::Success.new('data')
    called = false
    success.on_error { called = true }

    refute called
  end
end
