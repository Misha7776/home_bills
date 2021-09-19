class Properties::Operations::Destroy < BaseOperation
  def call
    return response(:fail, args) unless delete_record

    assign_args
    success(args)
  end

  private

  def delete_record
    args[:record] = record
    @record = record.destroy
  end

  def assign_args
    args.merge(record: @record)
  end
end
