require 'test_helper'

# https://github.com/rails/rails/blob/b6963db965aa10ef9d63002f3a752cfcb20f0203/actionpack/test/controller/api/rate_limiting_test.rb#L5C1-L12C4
class ApiRateLimitedController < ActionController::API
  self.cache_store = ActiveSupport::Cache::MemoryStore.new
  rate_limit to: 2, within: 2.seconds
end

class MessagesLimitedController < ApiRateLimitedController 
  def limited_to_two_messages
    head :ok
  end
end

class UsersLimitedController < ApiRateLimitedController
  def limited_to_two_users
    head :ok
  end
end

class ApiRateLimitingTest < ActionController::TestCase 
  setup do
    ApiRateLimitedController.cache_store.clear
  end

  test 'should not limit messsages and users controller on the same rate limit count' do
    with_routing do |routing|
      routing.draw do
        get :limited_to_two_messages, to: "messages_limited#limited_to_two_messages"
        get :limited_to_two_users, to: "users_limited#limited_to_two_users"
      end

      @controller = MessagesLimitedController.new

      get :limited_to_two_messages
      get :limited_to_two_messages
      assert_response :ok

      get :limited_to_two_messages
      assert_response :too_many_requests

      @controller = UsersLimitedController.new

      get :limited_to_two_users
      get :limited_to_two_users
      assert_response :ok

      get :limited_to_two_users
      assert_response :too_many_requests
    end
  end
end
