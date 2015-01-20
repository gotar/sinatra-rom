module API
  class BaseSerializer
    def self.single(object)
      {
        key_from_klass_name => basic_struct(object)
      }
    end

    def self.multi(objects)
      {
        key_from_klass_name => objects.map{|o| basic_struct(o)}
      }
    end

    private
    def self.key_from_klass_name
      self.to_s.match(/API::(\w+)Serializer/)[1].downcase.pluralize
    end
  end
end
