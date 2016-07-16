module AttributeDependsCalculator
  class Factory
    attr_accessor :klass, :column, :params, :association, :associate_column, :association_name
    def initialize(klass, column, params)
      self.klass, self.column = klass, column
      self.association, self.associate_column, self.association_name = fetch_association(params)
    end

    def perform
      define_calculator
      append_callbacks
    end

    private

    def define_calculator
      self.klass.class_eval <<-METHOD, __FILE__, __LINE__
        def #{calculate_method_name}
          total = self.#{association_name}.pluck(:#{associate_column}).compact.reduce(0, :+)
          update(:#{column} => total)
        end
      METHOD
    end

    def calculate_method_name
      "calculate_and_update_#{column}"
    end

    def klass_assoc_name
      klass.table_name.singularize
    end

    def fetch_association(params)
      assoc = params.keys.first
      [klass.reflect_on_association(assoc).class_name.constantize, params.values.first, assoc]
    end

    def append_callbacks
      append_callback_hook
      define_callback_methods
    end

    def append_callback_hook
      self.association.class_eval <<-METHOD, __FILE__, __LINE__
        after_save :depends_update_#{column}
        around_destroy :depends_update_#{column}_around
      METHOD
    end

    def define_callback_methods
      self.association.class_eval <<-METHOD, __FILE__, __LINE__
        private

        def depends_update_#{column}
          self.#{klass_assoc_name}.#{calculate_method_name}
        end

        def depends_update_#{column}_around
          _relation = self.#{klass_assoc_name}
          yield
          _relation.#{calculate_method_name}
        end
      METHOD
    end

  end
end
