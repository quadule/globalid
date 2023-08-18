require 'helper'
require 'active_job/arguments'
require 'active_job/serializers'

ActiveJob::Serializers.add_serializers GlobalID::Lazy::Serializer

class LazyTest < ActiveSupport::TestCase
  setup do
    @model = PersonModel.new(id: '123')
    @gid = @model.to_global_id
    @lazy = GlobalID::Lazy::Model.new(@gid)
  end

  test 'creates a lazy model from a Global ID with helper method' do
    assert_kind_of GlobalID::Lazy::Model, @gid.lazy
  end

  test 'equal to model with same Global ID' do
    assert_equal @model, @lazy
  end

  test 'lazy model can be used for identification without loading' do
    assert_equal @model.class, @lazy.class
    assert_equal @model.id, @lazy.id
    assert_equal @gid, @lazy.to_global_id
    refute @lazy.lazy_model_loaded?
  end

  test 'lazy model serializes and deserializes without loading' do
    serialized = ActiveJob::Arguments.serialize([@lazy]).first
    deserialized = ActiveJob::Arguments.deserialize([serialized]).first
    assert_equal @lazy, deserialized
    refute @lazy.lazy_model_loaded?
    refute deserialized.lazy_model_loaded?
  end

  test 'loads model when calling model methods' do
    assert_changes -> { @lazy.lazy_model_loaded? }, from: false, to: true do
      @lazy.to_s
    end
  end
end
