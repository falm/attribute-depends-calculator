# encoding: utf-8
require "rubygems"
require "rails"
require "active_record"
require 'database_cleaner'
require 'attribute-depends-calculator'
require 'coveralls'

Coveralls.wear!

module Rails
  class << self
    def root
      File.expand_path("../spec", __FILE__)
    end
  end
end

ActiveRecord::Base.establish_connection(:adapter  => 'sqlite3',
                                        :database => ':memory:')

# Requires supporting files with schema, models, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each { |f| require f }

RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
