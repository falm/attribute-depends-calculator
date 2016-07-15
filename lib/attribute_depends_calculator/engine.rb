
module AttributeDependsCalculator

  class Engine < ::Rails::Engine
    isolate_namespace AttributeDependsCalculator
    initializer 'attribute_depends_calculator.extend_active_record' do
      ActiveRecord::Base.send :extend, AttributeDependsCalculator::Macro
    end
  end
end
