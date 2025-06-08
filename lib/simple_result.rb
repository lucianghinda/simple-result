# frozen_string_literal: true

require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module SimpleResult
  ResponseError = Class.new(StandardError)
  ErrorNotPresentOnSuccess = Class.new(ResponseError)
  PayloadNotPresentOnFailure = Class.new(ResponseError)
  NotImplemented = Class.new(ResponseError)

  Response = Data.define(:payload, :error) do
    def initialize(payload: nil, error: nil) = super

    def success? = raise NotImplemented, 'success? not implemented'
    def failure? = raise NotImplemented, 'failure? not implemented'
    def payload_or_fallback(&) = payload || yield
    def and_then(&) = raise NotImplementedError, 'and_then not implemented'
  end

  class Success < Response
    def self.blank               = new(payload: nil)
    def initialize(payload: nil) = super(payload: payload, error: nil)

    def success?   = true
    def failure?   = false
    def error      = raise(ResponseError, 'Error not present on success')

    def and_then(&) = yield(payload)
    def on_error(&) = self

    def inspect = "#<data #{self.class.name} payload=#{payload.inspect}>"

    def pretty_print(pp) = pp.text "#<data #{self.class.name} payload=#{payload.inspect}>"
  end

  class Failure < Response
    def self.blank             = new(error: nil)
    def initialize(error: nil) = super(payload: nil, error: error)

    def success?   = false
    def failure?   = true
    def payload    = raise(ResponseError, 'Payload not present on failure')

    def payload_or_fallback(&) = yield
    def and_then(&) = self

    def on_error(&)
      yield(error)
      self
    end

    def inspect = "#<data #{self.class.name} error=#{error.inspect}>"
    def pretty_print(pp) = pp.text "#<data #{self.class.name} error=#{error.inspect}>"
  end
end

def Success(payload = nil) = SimpleResult::Success.new(payload) # rubocop:disable Naming/MethodName -- These are helpers methods defined specifically like this to look similar with the classes
def Failure(error = nil) = SimpleResult::Failure.new(error:) # rubocop:disable Naming/MethodName -- These are helpers methods defined specifically like this to look similar with the classes
