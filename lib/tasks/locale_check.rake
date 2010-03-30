

def compare_locales(hash1_locale, hash1, hash2_locale, hash2, aggregate_keys = [])
  return unless hash1.kind_of?(Hash) and hash2.kind_of?(Hash)
  if missing_keys = hash1.keys - hash2.keys
    missing_keys.each do |missing_key|
      missing_path = [hash2_locale] + aggregate_keys + [missing_key]
      puts "[#{missing_path.join(', ')}] missing"
    end
  end

  common_keys = hash1.keys & hash2.keys
  common_keys.each do |common_key|
    compare_locales(hash1_locale, hash1[common_key], hash2_locale, hash2[common_key], aggregate_keys + [common_key])
  end
end



namespace :locale do
  desc "Check if all locales have the same keys and are consistent"

  task :check => :environment do
    available_locales = I18n.available_locales
    locale_hashes = I18n.backend.send(:translations)

    locale_hashes.keys.each do |locale_code1|
      locale_hashes.keys.each do |locale_code2|
        compare_locales(locale_code1, locale_hashes[locale_code1], locale_code2, locale_hashes[locale_code2])
      end
    end
  end

end
