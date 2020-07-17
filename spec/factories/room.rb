FactoryBot.define do
  factory :room do
    code { rand(999999).to_s }
    capacity { rand(6) + 2 }
    notes { 'notes' }
  end
end
