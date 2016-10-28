module Gmail
  class Draft < APIResource
    include Base::List
    include Base::Create
    include Base::Delete
    include Base::Get
    include Base::Update

    # def create(body, opts={})
    #   #response = Gmail. request(base_method.send("create"), {}, body)
    #   #msg = {raw:Base64.urlsafe_encode64(message.raw)}
    #   # if message.threadId
    #   #   msg[:threadId] = message.threadId
    #   # end
    #   # if message.labelIds
    #   #   msg[:labelIds] = message.labelIds
    #   # end

    #   #body = Google::Apis::GmailV1::Draft.from_json({message:msg}.to_json)
    #   response = Gmail.new_request("create_user_draft",{userId:"me", variables:[]},body)
    #   Util.convert_to_gmail_object(response, class_name.downcase)
    # end
    
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
      msg = {raw:Base64.urlsafe_encode64(message.raw)}
      if message.threadId
        msg[:threadId] = message.threadId
      end
      if message.labelIds
        msg[:labelIds] = message.labelIds
      end
      #body = {message: msg}
      body = Google::Apis::GmailV1::Draft.from_json({message:msg}.to_json)
      update(body)
    end

    def save!(opts={})
      msg = {raw:Base64.urlsafe_encode64(message.raw)}
      if message.threadId
        msg[:threadId] = message.threadId
      end
      if message.labelIds
        msg[:labelIds] = message.labelIds
      end
      #body = {message: msg}
      body = Google::Apis::GmailV1::Draft.from_json({message:msg}.to_json)
      update!(body)
    end

    def deliver
      #response = Gmail. request(self.class.base_method.to_h['gmail.users.drafts.send'],{},{id: id})
      msg = {raw:Base64.urlsafe_encode64(message.raw)}
      if message.threadId
        msg[:threadId] = message.threadId
      end
      if message.labelIds
        msg[:labelIds] = message.labelIds
      end
      # Problematic. this expects a Google::APIs::GmailV1::Draft object. 
      #It might be sensible to build a reverse gmail object creator to cope with the two different types of Gmail Object (which may be incompatible)
      response = Gmail.new_request("send_user_draft", {userId:"me", variables:[]}, Google::Apis::GmailV1::Draft.from_json({message:msg}.to_json))
      Message.get(response[:id])
    end



  end
end