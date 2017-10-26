module Procedural
  #:procedural
  require "spec_helper"
  require_relative "../../../../app/models/user"
  require_relative "../../../../app/models/post"
  require_relative "../../../../app/concepts/post/operation/create"

  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(Post.last).to be_nil
    end
  #:procedural end

    it "works with known user" do
      #:dependencies
      result = Post::Create.(post_params, "current_user" => signed_in)
      #:dependencies end

      expect(result).to be_success
      expect(Post.last).to be_persisted
      expect(Post.last.title).to eq("Puns: Ode to Joy")
    end
  end
end

module ProceduralSet
   RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    #:set-spec
    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
    end
    #:set-spec end
  end
end

module FirstSteps
  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
    end

    it "works with known user" do
      result = Post::Create.(post_params, "current_user" => signed_in)

      expect(result).to be_success
      expect(result["model"]).to be_persisted
      expect(result["model"].title).to eq("Puns: Ode to Joy")
    end
  end
end

module Policy
  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    #:guard-result
    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
      expect(result["result.policy.default"]).to be_failure
    end
    #:guard-result end

    it "works with known user" do
      result = Post::Create.(post_params, "current_user" => signed_in)

      expect(result).to be_success
      expect(result["model"]).to be_persisted
      expect(result["model"].title).to eq("Puns: Ode to Joy")
    end
  end
end

module Model
  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    #:guard-result
    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
      expect(result["result.policy.default"]).to be_failure
    end
    #:guard-result end

    it "works with known user" do
      result = Post::Create.(post_params, "current_user" => signed_in)

      expect(result).to be_success
      expect(result["model"]).to be_persisted
      expect(result["model"].title).to eq("Puns: Ode to Joy")
    end
  end
end

 module Contract
  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
      expect(result["result.policy.default"]).to be_failure
    end

    #:validation-fail
    it "works with known user" do
      #:validation-pass
      result = Post::Create.(
        {post: {title: "Puns: Ode to Joy", body: "" } },
        "current_user" => signed_in
      )
      #:validation-pass end
      expect(result).to be_success
      expect(result["model"]).to be_persisted
      expect(result["model"].title).to eq("Puns: Ode to Joy") # fails!
    end
    #:validation-fail end

    #:validation-missing
    it "fails with missing input" do
      result = Post::Create.({}, "current_user" => signed_in)
      expect(result).to be_failure
    end
    #:validation-missing end

    it "fails with missing fields" do
      result = Post::Create.({post: {} }, "current_user" => signed_in)

      expect(result).to be_failure
      expect(result["result.contract.default"].errors.messages).to eq( {:title=>["is missing"], :body=>["is missing", "size cannot be less than 9"]} )
    end


    #:validation-size
    it "fails with body too short" do
      result = Post::Create.(
        {post: {title: "Heatwave!", body: "Too hot!" } },
        "current_user" => signed_in
      )

      expect(result).to be_failure
      expect(result["result.contract.default"].errors.messages).to eq(
        {:body => ["size cannot be less than 9"]} )
    end
    #:validation-size end
  end
end

 module Persist
  RSpec.describe Post::Create do
    let (:anonymous) { User.new(false) }
    let (:signed_in) { User.new(true) }
    let (:post_params) { {post: {title: "Puns: Ode to Joy" } } }

    it "fails with anonymous" do
      result = Post::Create.(post_params, "current_user" => anonymous)

      expect(result).to be_failure
      expect(result["model"]).to be_nil
      expect(result["result.policy.default"]).to be_failure
    end

    #:validation-fail
    it "works with known user" do
      #:validation-pass
      result = Post::Create.(
        {post: {title: "Puns: Ode to Joy", body: "" } },
        "current_user" => signed_in
      )
      #:validation-pass end
      expect(result).to be_success
      expect(result["model"]).to be_persisted
      expect(result["model"].title).to eq("Puns: Ode to Joy") # fails!
    end
    #:validation-fail end

    #:validation-missing
    it "fails with missing input" do
      result = Post::Create.({}, "current_user" => signed_in)
      expect(result).to be_failure
    end
    #:validation-missing end

    it "fails with missing fields" do
      result = Post::Create.({post: {} }, "current_user" => signed_in)

      expect(result).to be_failure
      expect(result["result.contract.default"].errors.messages).to eq( {:title=>["is missing"], :body=>["is missing", "size cannot be less than 9"]} )
    end


    #:validation-size
    it "fails with body too short" do
      result = Post::Create.(
        {post: {title: "Heatwave!", body: "Too hot!" } },
        "current_user" => signed_in
      )

      expect(result).to be_failure
      expect(result["result.contract.default"].errors.messages).to eq(
        {:body => ["size cannot be less than 9"]} )
    end
    #:validation-size end
  end
end
