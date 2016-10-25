module Gmail
  class Label < APIResource
    include Base::List
    include Base::Create
    include Base::Delete
    include Base::Get
    include Base::Update
    
    def all(filters={}, opts={})
      response = Gmail.new_request("list_user_#{class_name.downcase}s",{userId:"me",variables:[]},filters)
    end

    def save
      update(to_hash)
    end

    def save!
      update!(to_hash)
    end

    def self.boxes
      @boxes ||= [:inbox, :sent, :trash, :important, :starred, :draft, :spam, :unread, :category_updates, :category_promotions, :category_social, :category_personal, :category_forums ]
    end

    boxes.each do |method|
      define_singleton_method method do
        Label.get(method.to_s.upcase)
      end
    end

    def messages filters={}
      filters = {label_ids: [id]}.merge(filters)
      filters[:label_ids] = filters[:label_ids] | [id]
      Message.all(filters)
    end

    def unread_messages
      if messagesUnread == 0
        []
      else
        Message.all({label_ids: [id, "UNREAD"]})
      end
    end

    def threads filters={}
      filters = {label_ids: [id]}.merge(filters)
      filters[:label_ids] = filters[:label_ids] | [id]
      Thread.all(filters)
    end

    def unread_threads
      Thread.all({label_ids: [id, "UNREAD"]})
    end

  end
end # Gmail
