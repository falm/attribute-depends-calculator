module AttributeDependsCalculator
  class Factory

    attr_accessor :klass, :column, :association

    attr_accessor :parameter

    extend Forwardable

    def_delegators :parameter, :depend_association_name, :depend_column, :expression

    def initialize(klass, column, params)
      self.klass, self.column = klass, column
      self.parameter = Parameter.new(params)
      self.association = fetch_association
    end

    def perform
      define_calculator
      append_callbacks
    end

    private

    def define_calculator
      self.klass.class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{calculate_method_name}
          total = self.#{depend_association_name}.#{expression}
          update(:#{column} => total)
        end
      METHOD
    end

    def calculate_method_name
      "calculate_and_update_#{column}"
    end

    def klass_assoc_name
      @assoc_name ||= association.reflect_on_all_associations.find {|assoc| assoc.plural_name == klass.table_name}.name
    end

    def fetch_association
      ObjectSpace.const_get klass.reflect_on_association(depend_association_name).class_name
    end

    def append_callbacks
      append_callback_hook
      define_callback_methods
    end

    def append_callback_hook
      self.association.class_eval <<-METHOD, __FILE__, __LINE__ + 1
        after_save :depends_update_#{column}
        around_destroy :depends_update_#{column}_around
      METHOD
    end

    def define_callback_methods
      self.association.class_eval <<-METHOD, __FILE__, __LINE__ + 1
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
