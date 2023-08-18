require 'delegate'

class GlobalID
  module Lazy
    class Model < ::Delegator
      def initialize(gid)
        @gid = gid
      end

      def ==(other)
        return @gid == other.to_global_id if other.respond_to?(:to_global_id)

        super
      end

      def __getobj__
        defined?(@model) ? @model : (@model = @gid.find)
      end

      def class
        defined?(@model) ? @model.class : @gid.model_class
      end

      def id
        defined?(@model) ? @model.id : @gid.model_id
      end

      def lazy_model_loaded?
        !!defined?(@model)
      end

      def respond_to?(method, include_all = false)
        # Prevent ActiveJob::Arguments from loading the model while serializing
        # See https://github.com/rails/rails/blob/3b5a4a56fb1dc471fa6dd9450d8ed50d72d4573/2/activejob/lib/active_job/arguments.rb#L93
        return false if method == :permitted? && !include_all && !@model&.respond_to?(:permitted?)

        super
      end

      def to_global_id
        @gid
      end
      alias to_gid to_global_id

      def to_model
        __getobj__
      end
    end
  end
end
