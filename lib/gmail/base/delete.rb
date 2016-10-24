module Gmail
  module Base
    module Delete
      def delete(opts={})
        #response = Gmail. request(self.class.base_method.send("delete"),{id: id})
        response = Gmail.new_request("delete_user_#{class_name.downcase}",{userId:"me", variables:[id]})

        if response == ""
          true
        else
          false
        end
      end

      module ClassMethods
        def delete(id, opts={})
         #response = Gmail. request(base_method.send("delete"),{id: id})
         response = Gmail.new_request("update_user_#{class_name.downcase}",{userId:"me", variables:[id]})
         if response == ""
           true
         else
           false
         end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end


    end
  end
end