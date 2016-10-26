# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Gmail
  class ThreadTest < Test::Unit::TestCase

    should "Threads should be listable" do
      @mock.expects(:list_user_threads).with("me").once.returns(test_response(test_thread_list))
      list = Gmail::Thread.all
      assert_equal Array, list.class
      assert_equal Gmail::Thread, list[0].class
    end

    should "Thread should be retrievable by id" do

        @mock.expects(:get_user_thread).with("me", test_thread[:id]).once.returns(test_response(test_thread))
        t = Gmail::Thread.get(test_thread[:id])
        assert_equal Gmail::Thread, t.class
        assert_equal test_thread[:id], t.id
    end


    context "Access list of Messages from thread" do
      should "Access list of Messages" do
        thread = Gmail::Thread.new test_thread
       # @mock.expects(:execute).with(api_method: Gmail.service.users.messages.list, parameters: {userId: "me", threadId: [test_thread[:id]]), headers: {'Content-Type' => 'application/json'}).once.returns(test_response(test_message_list))
        list = thread.messages
        assert_equal Array, list.class
        assert_equal Gmail::Message, list[0].class
      end

      should "Access list of Messages after selecting from list" do
        @mock.expects(:list_user_threads).with("me").once.returns(test_response(test_thread_list))
        thread_list = Gmail::Thread.all
        @mock.expects(:get_user_thread).with("me", test_thread[:id]).once.returns(test_response(test_message_list))
        thread = thread_list.first
        list = thread.messages
        assert_equal Array, list.class
        assert_equal Gmail::Message, list[0].class
      end

      #Not sure what this test was supposed to be testing. 
      #Can't run a thread search with thread_id as a parameter
      # should 'Access list of unread Messages' do
      #   thread = Gmail::Thread.new test_thread
      #   @mock.expects(:list_user_threads).with("me", thread_id: [test_thread[:id]], label_ids: ["UNREAD"]).once.returns(test_response(test_message_list))
      #   list = thread.unread_messages
      #   assert_equal Array, list.class
      #   assert_equal Gmail::Message, list[0].class
      # end

      # should 'Access list of sent Messages' do
      #   thread = Gmail::Thread.new test_thread
      #   @mock.expects(:list_user_threads).with("me", thread_id: [test_thread[:id]], label_ids: ["SENT"]).once.returns(test_response(test_message_list))
      #   list = thread.unread_messages
      #   assert_equal Array, list.class
      #   assert_equal Gmail::Message, list[0].class
      # end
    end


    should "Thread should be deletable" do
      @mock.expects(:delete_user_thread).with("me", test_thread[:id]).once.returns(test_response(nil))
      t = Gmail::Thread.new(test_thread)
      r = t.delete
      assert r
    end

    should "Thread should be thrashable" do
      @mock.expects(:trash_user_thread).with("me", test_thread[:id]).once.returns(test_response(test_thread))
      t = Gmail::Thread.new(test_thread)
      r = t.trash
      assert_equal Gmail::Thread, r.class
    end

    should "Thread should be unthrashable" do
      @mock.expects(:untrash_user_thread).with("me", test_thread[:id]).once.returns(test_response(test_thread))
      t = Gmail::Thread.new(test_thread)
      r = t.untrash
      assert_equal Gmail::Thread, r.class
    end

    context "Modifying Labels" do
      should "Thread should be starrable" do
        @mock.expects(:modify_thread).with("me", test_thread[:id],kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.star
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.star!

        assert_equal t.object_id, r.object_id

      end

      should "Thread should be unstarrable" do
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.unstar
        assert_equal Gmail::Thread, r.class

        assert_not_equal t.object_id, r.object_id

        r = t.unstar!

        assert_equal t.object_id, r.object_id
      end

      should "Thread should be archivable" do
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.archive
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.archive!

        assert_equal t.object_id, r.object_id
      end

      should "Thread should be unarchivable" do
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.unarchive
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.unarchive!

        assert_equal t.object_id, r.object_id
      end

      should "Thread should be markable as read" do
        #@mock.expects(:modify_thread).with("me", test_thread[:id], Google::Apis::GmailV1::ModifyMessageRequest.new(add_label_ids: [], remove_label_ids: ["UNREAD"])).twice.returns(test_response(test_thread))
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.mark_as_read
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.mark_as_read!

        assert_equal t.object_id, r.object_id
      end

      should "Thread should be markable as unread" do
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.mark_as_unread
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.mark_as_unread!

        assert_equal t.object_id, r.object_id
      end


      should "Thread label should be modifiable as wish" do
        @mock.expects(:modify_thread).with("me", test_thread[:id], kind_of(Google::Apis::GmailV1::ModifyMessageRequest) ).twice.returns(test_response(test_thread))
        t = Gmail::Thread.new(test_thread)
        r = t.modify ["UNREAD", "SOME COOL LABEL"], ["INBOX", "SOME NOT COOL LABEL"]
        assert_equal Gmail::Thread, r.class
        assert_not_equal t.object_id, r.object_id

        r = t.modify! ["UNREAD", "SOME COOL LABEL"], ["INBOX", "SOME NOT COOL LABEL"]

        assert_equal t.object_id, r.object_id
      end

    end


    should "Thread should be searcheable" do
      @mock.expects(:list_user_threads).with("me", q: "from:(me) to:(you) subject:(subject) in:inbox before:2014/12/1 after:2014/11/1 test -{real}", label_ids:["UNREAD"]).once.returns(test_response(test_thread_list))
      list = Gmail::Thread.search(from:"me", to: "you", subject: "subject", in: "inbox", before: "2014/12/1", after: "2014/11/1", has_words: "test", has_not_words: "real", label_ids: ["UNREAD"])
      assert_equal Array, list.class
      assert_equal Gmail::Thread, list[0].class
    end




  end
end