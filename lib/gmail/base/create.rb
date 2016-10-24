module Gmail
  module Base
    module Create
      module ClassMethods
        def create(body, opts={})
          #response = Gmail. request(base_method.send("create"), {}, body)
          response = Gmail.new_request("create_user_#{class_name.downcase}",{userId:"me", variables:[id]},body)
          Util.convert_to_gmail_object(response, class_name.downcase)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end