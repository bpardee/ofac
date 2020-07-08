require 'active_record'

class OfacSdnIndividual < ActiveRecord::Base

  def self.init
    @@init ||= begin
      main_hash = Hash.new {|h, k| h[k] = []}
      alt_hash = Hash.new {|h, k| h[k] = []}
      all = OfacSdnIndividual.select('last_name, first_name_1, first_name_2, first_name_3, first_name_4, first_name_5, first_name_6, first_name_7, first_name_8, alternate_last_name, alternate_first_name_1, alternate_first_name_2, alternate_first_name_3, alternate_first_name_4, alternate_first_name_5, alternate_first_name_6, alternate_first_name_7, alternate_first_name_8, address, city').all.to_a
      all.each do |i|
        main_hash[i.last_name] << i
        main_hash[i.first_name_1] << i
        main_hash[i.first_name_2] << i
        main_hash[i.first_name_3] << i
        main_hash[i.first_name_4] << i
        main_hash[i.first_name_5] << i
        main_hash[i.first_name_6] << i
        main_hash[i.first_name_7] << i
        main_hash[i.first_name_8] << i
        alt_hash[i.alternate_last_name] << i
        alt_hash[i.alternate_first_name_1] << i
        alt_hash[i.alternate_first_name_2] << i
        alt_hash[i.alternate_first_name_3] << i
        alt_hash[i.alternate_first_name_4] << i
        alt_hash[i.alternate_first_name_5] << i
        alt_hash[i.alternate_first_name_6] << i
        alt_hash[i.alternate_first_name_7] << i
        alt_hash[i.alternate_first_name_8] << i
      end
      @@main_hash = main_hash
      @@alt_hash = alt_hash
    end
  end

  def self.main_hash
    init
    @@main_hash
  end

  def self.alt_hash
    init
    @@alt_hash
  end

  def self.possible_sdns(name_array, use_ors)
    if use_ors
      matches = []
      name_array.each do |name|
        matches += main_hash[name]
        matches += alt_hash[name]
      end
      matches.uniq
    else
      first, *rest = name_array
      main_matches = main_hash[first]
      alt_matches = alt_hash[first]
      rest.each do |name|
        main_matches &= main_hash[name]
        alt_matches &= main_hash[name]
      end
      (main_matches + alt_matches).uniq
    end
  end

  def name
    "#{last_name}, #{first_name_1} #{first_name_2} #{first_name_3} #{first_name_4} #{first_name_5} #{first_name_6} #{first_name_7} #{first_name_8}".strip
  end

  def alternate_identity_name
    "#{alternate_last_name}, #{alternate_first_name_1} #{alternate_first_name_2} #{alternate_first_name_3} #{alternate_first_name_4} #{alternate_first_name_5} #{alternate_first_name_6} #{alternate_first_name_7} #{alternate_first_name_8}".strip
  end
end