require 'active_job/serializers'

class GlobalID
  module Lazy
    class Serializer < ActiveJob::Serializers::ObjectSerializer
      def serialize(obj)
        super('gid' => obj.to_global_id.to_s)
      end

      def deserialize(hash)
        klass.new GlobalID.parse(hash['gid'])
      end

      private
        def klass
          Model
        end
    end
  end
end
