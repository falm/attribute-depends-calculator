module AttributeDependsCalculator
  module Macro

    def attribute_depend(options)
      options.each do |column, option|
        Factory.new(self, column, option).perform
      end
    end

    alias_method :depend, :attribute_depend
  end
end

ActiveRecord::Base.send :extend, AttributeDependsCalculator::Macro
