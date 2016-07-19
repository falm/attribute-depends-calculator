module AttributeDependsCalculator
  module Macro
    def depend(options)
      options.each do |column, option|
        Factory.new(self, column, option).perform
      end
    end
  end
end

ActiveRecord::Base.send :extend, AttributeDependsCalculator::Macro
