# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Gmail
  class LabelTest < Test::Unit::TestCase

    should "Labels should be listable" do
      @mock.expects(:list_user_labels).with("me").once.returns(test_response(test_label_list))
      list = Gmail::Label.all
      assert list.kind_of? Array
      assert list[0].kind_of? Gmail::Label
    end


    context "Retrieve a Label" do
      should "Label should be retrievable by id" do

        @mock.expects(:get_user_label).with("me",test_label[:id]).once.returns(test_response(test_label))
        l = Gmail::Label.get(test_label[:id])
        assert l.kind_of?Gmail::Label
        assert_equal test_label[:id], l.id
      end


      [:inbox, :sent, :trash, :important, :starred, :draft, :spam, :unread, :category_updates, :category_promotions, :category_social, :category_personal, :category_forums ].each do |label_id|
        should "System Label should be retrievable by calling #{label_id.to_s}" do
          @mock.expects(:get_user_label).with("me", label_id.to_s.upcase).once.returns(test_response(test_label_list[:labels].select{|l| l[:id] == label_id.to_s.upcase}.first))
          l = Gmail::Label.send(label_id.to_s)
          assert l.kind_of?Gmail::Label
          assert_equal label_id.to_s.upcase, l.id
        end
      end

    end


    context "Access list of Messages from Label" do
      should "Access list of Messages" do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_messages).with( "me", label_ids: [test_label[:id]]).once.returns(test_response(test_message_list))
        list = label.messages
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Message
      end

      should 'Access list of unread Messages' do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_messages).with("me", labelIds: [test_label[:id], "UNREAD"]).once.returns(test_response(test_message_list))
        list = label.unread_messages
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Message
      end

      should 'Access filtered Messages' do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_messages).with("me", label_ids: ["IMPORTANT", "COOL", test_label[:id]], thread_id: "1").once.returns(test_response(test_message_list))
        list = label.messages(thread_id: "1", label_ids: ["IMPORTANT", "COOL"])
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Message
      end

      should "Access list of Threads" do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_threads).with("me", label_ids: [test_label[:id]]).once.returns(test_response(test_thread_list))
        list = label.threads
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Thread
      end

      should 'Access list of unread Threads' do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_threads).with("me", label_ids: [test_label[:id], "UNREAD"]).once.returns(test_response(test_thread_list))
        list = label.unread_threads
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Thread
      end

      should 'Access filtered Threads' do
        label = Gmail::Label.new test_label
        @mock.expects(:list_user_threads).with("me", label_ids: ["IMPORTANT", "COOL", test_label[:id]], thread_id: "1").once.returns(test_response(test_thread_list))
        list = label.threads(thread_id: "1", label_ids: ["IMPORTANT", "COOL"])
        assert list.kind_of? Array
        assert list[0].kind_of? Gmail::Thread
      end



    end


    should "Label should be deletable" do
      @mock.expects(:delete_user_label).with("me", test_label[:id]).once.returns(test_response(""))
      d = Gmail::Label.new(test_label)
      r = d.delete
      assert r
    end

    should "Label should be updateable" do

      label = Gmail::Label.new test_label(:messageListVisibility=>"show")

      assert_equal "show", label.messageListVisibility


      @mock.expects(:update_user_label).with("me", test_label[:id], test_label(:messageListVisibility=>"hide")).twice.returns(test_response(test_label(:messageListVisibility=>"hide")))

      label.messageListVisibility = "hide"
      new_l = label.save
      assert_equal "hide", new_l.messageListVisibility
      assert_not_equal label.object_id, new_l.object_id
      new_l = label.save!
      assert_equal label.object_id, new_l.object_id
    end

    should "create should return a new Label" do
      label_hash = test_label
      label_hash.delete(:id)
      label = Gmail::Label.new label_hash
      @mock.expects(:create_user_label.with("me", label_hash).once.returns(test_response(test_label))
      created_l = label.save!
      assert_equal Gmail::Label, created_l.class
      assert_equal test_label[:id], label.id
    end




  end
end