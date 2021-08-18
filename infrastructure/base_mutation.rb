class BaseMutation < GraphQL::Schema::Mutation
  attr_reader :form, :record, :record_params

  null false

  def current_user
    context[:current_user]
  end

  private

  def build_form
    @form = form_class.new(record_params, record: record)
  end

  def form_valid?
    form.validate
  end

  def assign_attributes
    record.assign_attributes(record_params)
  end

  def record_valid?
    return true if record.errors.none? && record.valid?

    false
  end

  def save_record
    record.save
  end

  def form_class
    raise 'Define form_class in child operation'
  end

  def validation_fail
    form&.sync_errors
    { errors: record.errors.full_messages }
  end
end
