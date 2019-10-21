RSpec::Matchers.define :have_error_on do |field, error_key|
  match do |model|
    if error_key.nil?
      raise ArgumentError, "Usage: expect(object).to have_error_on(:field, :error_key)"
    end

    model.errors.details[field]&.any? { |detail| detail[:error] == error_key }
  end

  failure_message do |model|
    base_message = "expected #{field} to have validation error on :#{error_key}, but no such error was found."
    errors_found = model.errors.details[field].map { |detail| detail[:error] }
    if errors_found.present?
      "#{base_message} \n\nErrors found for #{field}: #{errors_found}"
    else
      base_message
    end
  end
end
