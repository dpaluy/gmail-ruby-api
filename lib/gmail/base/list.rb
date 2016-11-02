module Gmail
  module Base
    module List
      module ClassMethods
        def all(filters={}, opts={})
          opts[:items] ||= []
          if ["message", "thread"].include? class_name.downcase
            max_results = filters[:max_results] || 100
            if max_results == -1
              filters.merge!({max_results: 100})
            end
          end
          #response = Gmail. request(base_method.send("list"), filters)
          response = Gmail.new_request("list_user_#{class_name.downcase}s",{userId:"me",variables:[]},filters)

          items = response["#{class_name.downcase}s".to_sym] || []
          
          opts[:items] = opts[:items] + items
          if ["message", "thread"].include? class_name.downcase
            next_page_token = response[:nextPageToken]
            if items.count < 100 || max_results == items.count
              Util.convert_to_gmail_object(opts[:items], class_name.downcase)
            else
              max_results = (max_results == -1)?-1:max_results-items.count
              all(filters.merge({max_results: max_results, page_token: next_page_token}), opts)
            end
          else
            Util.convert_to_gmail_object(opts[:items], class_name.downcase)
          end
        end

        def search(q={})
          if q.is_a? String
            all({q: q})
          else
            query = ""
            [:from, :to, :subject].each do |prop|
              query += "#{prop.to_s}:(#{q[prop].downcase}) "  unless q[prop].nil?
              q.delete(prop)
            end
            [:in, :before, :after].each do |prop|
              query += "#{prop.to_s}:#{q[prop]} " unless q[prop].nil?
              q.delete(prop)
            end

            query += "#{q[:has_words]} " unless q[:has_words].nil?
            query += "-{#{q[:has_not_words]}}" unless q[:has_not_words].nil?
            q.delete(:has_words)
            q.delete(:has_not_words)

            all(q.merge({q: query}))
          end
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end