# frozen_string_literal: true

module SimpleResult
  module Helpers
    def Success(payload = nil) # rubocop:disable Naming/MethodName -- These are helpers methods defined specifically like this to look similar with the classes
      SimpleResult::Success.new(payload)
    end

    def Failure(error = nil) # rubocop:disable Naming/MethodName -- These are helpers methods defined specifically like this to look similar with the classes
      SimpleResult::Failure.new(error:)
    end
  end
end
