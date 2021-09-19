module Serialization
  extend ActiveSupport::Concern

  def record_response(record, *args)
    options = args.extract_options!
    return render_json({ errors: 'record not found' }, :not_found) if record.nil?

    hash = serialize_record(record, options)
    status = if record.errors.none?
               options[:status] || :ok
             else
               hash[:errors] = record.errors.messages
               :bad_request
             end
    render_json(hash, status)
  end

  def collection_response(collection, *args)
    options = args.extract_options!
    items = if options[:skip_pagination].present?
              serialize_collection(collection, options)
            else
              serialize_collection(paginate(collection, options), options)
            end
    render json: {
      items: items,
      count: collection.count
    }, status: options[:status] || :ok
  end

  def render_json(message, status)
    render json: message, status: status
  end

  def serialize_collection(collection, options = {})
    "#{collection.klass.name}Serializer".constantize.render_as_hash(collection, options)
  end

  def serialize_record(record, options = {})
    "#{record.class.name}Serializer".constantize.render_as_hash(record, options)
  end

  def operation_response_json(response_obj)
    message = if response_obj.status.to_sym.eql?(:bad_request)
                { errors: response_obj.data[:errors] }
              elsif response_obj.data[:record].present?
                serialize_record(response_obj.data[:record])
              else
                {}
              end
    render_json(message, response_obj.status.to_sym)
  end
end
