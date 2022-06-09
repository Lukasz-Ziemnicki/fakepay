# frozen_string_literal: true

namespace :fakepay do
  desc 'Renew payments for a given date, date format : `DD-MM-YYYY` or `DD/MM/YYYY`.'
  task :renew_payments, [:date_string] => :environment do |_t, args|
    date = args[:date_string].to_date

    Fakepay::RenewPaymentService.new(date).call!
  end
end
