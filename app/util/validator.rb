module Validator
  def nil_check_for(args, requirement) 
    requirement.each do |key|
      raise "hash value of ':#{key}' must not be nil" if args[key] == nil
    end
  end
end
