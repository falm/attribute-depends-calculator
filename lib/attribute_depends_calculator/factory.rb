require 'forwardable'

module AttributeDependsCalculator
  class Factory

    attr_accessor :klass, :column, :association

    attr_accessor :parameter

    extend ::Forwardable

    def_delegators :parameter, :depend_association_name, :depend_column, :expression, :proc?, :callback

    def initialize(klass, column, params)
      self.klass, self.column = klass, column
      self.parameter = Parameter.new(params)
      self.association = fetch_association
    end

    def perform
      define_calculator
      define_operator_callback
      append_callbacks
    end

    private

    def define_calculator
      self.klass.class_eval <<-METHOD, __FILE__, __LINE__ + 1
        def #{calculate_method_name}
          total = #{calculate}
          update(:#{column} => total)
        end
      METHOD
    end

    def calculate
      if self.proc?
        "self.#{column}_depends_callback(#{depend_association_name})"
      else
        "self.#{depend_association_name}.#{expression}"
      end
    end

    def define_operator_callback
      callback, column = self.callback, self.column
      return if callback.nil?
      self.klass.class_eval do
        define_method "#{column}_depends_callback", &callback
      end
    end

    def calculate_method_name
      "calculate_and_update_#{column}"
    end

    def klass_assoc_name
      @assoc_name ||= begin
        relation = association.reflect_on_all_associations.find {|assoc| assoc.plural_name == klass.table_name}
        relation ? relation.name : nil
      end
    end

    def fetch_association
      klass.reflect_on_association(depend_association_name).class_name.constantize
    end

    def append_callbacks
      append_callback_hook
    end

    def append_callback_hook

      self.association.after_save after_callback_proc
      self.association.after_destroy after_callback_proc

    end

    def after_callback_proc

      attr_name = klass_assoc_name
      return unless attr_name
      method_name = calculate_method_name
      lambda  { |record|
        record.public_send(attr_name).send(method_name)
      }

    end

  end
end
