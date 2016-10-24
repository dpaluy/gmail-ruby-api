module Gmail
  module Base
    module Get
      module ClassMethods
        def get(id)
          #response = Gmail. request(base_method.send("get"), {id: id})
          response = Gmail.new_request("get_user_#{class_name.downcase}",{userId:"me",variables:[id]})
          Util.convert_to_gmail_object(response, class_name.downcase)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end