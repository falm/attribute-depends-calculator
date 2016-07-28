module AttributeDependsCalculator
  class Parameter

    attr_accessor :params, :depend_association_name, :depend_column, :operator

    OPERATORS = %i(+ *)
    METHODS = %i(sum average count minimum maximum)

    def initialize(params)
      self.operator = params.values_at(:operator).first || :sum
      self.params = params
      fetch
    end

    def fetch
      self.depend_association_name = params.keys.first
      self.depend_column = params.values.first
    end

    def expression
      operator_filter
    end

    def operator_filter
      if OPERATORS.include? operator
        "pluck(:#{depend_column}).compact.reduce(0, :#{operator})"
      elsif METHODS.include? operator
        "#{operator}(:#{depend_column})"
      else
        raise 'The operator of depends calculator are incorrect'
      end
    end

  end
end
