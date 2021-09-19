class Properties::Operations::Create < BaseOperation
  def call
    build_record
    build_form
    return validation_fail unless form_valid?
    return validation_fail unless save_record

    assign_args
    success(args)
  end

  private

  def build_record
    @record = Property.new(record_params)
  end

  def assign_args
    args.merge!(record: @record)
  end

  def form_class
    Properties::Forms::Create
  end
end
