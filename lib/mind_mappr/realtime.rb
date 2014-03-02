module Realtime
  module_function

  def created(context, obj, path)
    publish_rocket(:add, context, obj, path)
  end

  def destroyed(context, obj, path)
    publish_rocket(:remove, context, obj, path)
  end

  def publish_rocket(op, context, obj, path)
    data = {
      op: op,
      path: path,
      value: obj.serializable_hash
    }.to_json

    $redis.with { |r| r.publish(context, data) }
  end
end
