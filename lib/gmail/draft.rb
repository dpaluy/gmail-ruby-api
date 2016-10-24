module Gmail
  class Draft < APIResource
    include Base::List
    include Base::Create
    include Base::Delete
    include Base::Get
    include Base::Update

    def message
      if @values.message.is_a?(Message)
        @values.message
      else
        @values.message = Util.convert_to_gmail_object(to_hash[:message], key="message")
        if @values.message.payload.nil?
          self.detailed!
          message
        end
        @values.message
      end
    end

    def save(opts={})
      msg = {raw: message.raw}
      if message.threadId
        msg[:threadId] = message.threadId
      end
      if message.labelIds
        msg[:labelIds] = message.labelIds
      end
      body = {message: msg}
      update(body)
    end

    def save!(opts={})
      msg = {raw: message.raw}
      if message.threadId
        msg[:threadId] = message.threadId
      end
      if message.labelIds
        msg[:labelIds] = message.labelIds
      end
      body = {message: msg}
      update!(body)
    end

    def deliver
      #response = Gmail. request(self.class.base_method.to_h['gmail.users.drafts.send'],{},{id: id})
      
      # Problematic. this expects a Google::APIs::GmailV1::Draft object. 
      #It might be sensible to build a reverse gmail object creator to cope with the two different types of Gmail Object (which may be incompatible)
      response = Gmail.new_request("send_user_draft", {userId:"me", variables:[self]},{id:id})
      Message.get(response[:id])
    end



  end
end