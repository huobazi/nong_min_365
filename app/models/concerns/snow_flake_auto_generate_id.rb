module SnowFlakeAutoGenerateId
  extend ActiveSupport::Concern

  included do |base|
    base.send :before_validation, :generate_id, :on => :create
  end

  private
  def generate_id
    if respond_to?(:attributes_protected_by_default)
      def self.attributes_protected_by_default
        super - ['id']
      end
    end
    self.id = ::WebSiteSnowFlakeGenerator.generate
  end
end

#
# module SnowFlakeAutoGenerateId
#   extend ActiveSupport::Concern
#
#   module RemoveIdFromProtectedAttributes
#     def attributes_protected_by_default
#       super - ['id']
#     end
#   end
#
#   def self.included(base)
#     if Rails.version < '3' # Rails 2 has this as an instance method
#       base.send :include, RemoveIdFromProtectedAttributes
#     else # Rails 3 has this as a class method
#       base.send :extend, RemoveIdFromProtectedAttributes
#     end
#     base.send :before_validation, :generate_id, :on => :create
#   end
#
#   module InstanceMethods
#     private
#     def generate_id
#       self.id = ::WebSiteSnowFlakeGenerator.generate
#     end
#   end
# end
