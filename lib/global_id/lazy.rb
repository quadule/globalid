class GlobalID
  module Lazy
    extend ActiveSupport::Autoload

    autoload :Model
    autoload :Serializer
  end
end
