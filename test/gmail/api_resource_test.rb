# -*- coding: utf-8 -*-
require File.expand_path('../../test_helper', __FILE__)

module Gmail
  class ApiResourceTest < Test::Unit::TestCase

    should "creating a new APIResource should not fetch over the network" do
      @mock.expects(:execute).never
      Gmail::Label.new({
                                          name: "test"
                                      })
    end

    should "setting an attribute should not cause a network request" do
      @mock.expects(:execute).never
      m = Gmail::Message.new({subject: "test"})
      m.body = "this is a test body"
    end

    should "accessing id should not issue a fetch" do
      @mock.expects(:execute).never
      c = Gmail::Message.new({subject: "test"})
      c.id
    end

    should "construct URL properly with base query parameters" do
      response = test_response(test_thread_list)
      @mock.expects(:list_user_threads).with(parameters: {userId: "me"}, headers: {'Content-Type' => 'application/json'}).returns(response)
      Gmail::Thread.all

      @mock.expects(:list_user_threads).with(parameters: {max_results: 150, userId: "test@test.com"}, headers: {'Content-Type' => 'application/json'}).returns(response)
      Gmail::Thread.all(max_results: 150, userId: "test@test.com")
    end


    should "deleting should return true" do
      @mock.expects(:delete_user_draft).with("me", test_draft[:id], headers: {'Content-Type' => 'application/json'}).once.returns(test_response(""))

      d = Gmail::Draft.new test_draft

      assert_equal true, d.delete

    end


  end
end