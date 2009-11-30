require 'helper'

class TestTwitterList < Test::Unit::TestCase

  should "Have a class-level accessor for the Twitter::Base object" do
    base = "Twitter::Base mock"
    lambda { Twitter::List.twitter_base = base }.should_not raise_error
    Twitter::List.twitter_base.should be(base)
  end

  context "Setting up Basic Auth" do
    setup do
      Twitter::List.setup_basic_auth "user", "pass"
    end

    should "be a Twitter::Base" do
      Twitter::List.twitter_base.class.should be(Twitter::Base)
    end

  end

  context "A Twitter List" do
    setup do
      @list = Twitter::List.new
    end

    should "exist" do
      @list.should_not be_nil
    end

    should "have a id" do
      lambda { @list.id = 12223242 }.should_not raise_error
      @list.id.should be(12223242)
    end

    should "have a name" do
      lambda { @list.name = "Foo" }.should_not raise_error
      @list.name.should be("Foo")
    end

    should "have a user" do
      lambda { @list.user = "ivey" }.should_not raise_error
      @list.user.should be("ivey")
    end

    should "have a description" do
      lambda { @list.description = "Foo Bar Baz" }.should_not raise_error
      @list.description.should be("Foo Bar Baz")
    end

    should "have members" do
      lambda { @list.members = [[1,2],[3,4]] }.should_not raise_error
      @list.members.should be([[1,2],[3,4]])
    end

  end

  context "parsing a user/name string" do
    setup do
      @list = Twitter::List.parse "@ivey/hah"
    end

    should "have user = ivey" do
      @list.user.should be("ivey")
    end

    should "have name = hah" do
      @list.name.should be("hah")
    end

    context "loading from Twitter" do
      setup do
        Twitter::List.setup_basic_auth "user", "pass"
        @list.load_members
      end

      should "have members" do
        @list.members.size.should be(21)
      end

      should "have a userid for each member" do
        @list.members.each { |x| x[0].class.should be(Fixnum)}
        @list.member_ids.should be(@list.members.collect { |x| x[0] })
      end

      should "have a username for each member" do
        @list.members.each { |x| x[1].class.should be(String)}
        @list.member_names.should be(@list.members.collect { |x| x[1] })
      end
    end
  end

  context "Set math on 3 lists" do
    setup do
      @list1 = Twitter::List.new
      @list1.members = [[1,"ivey"],[2,"emilyivey"],[3,"ellieivey"],[8,"billy_goat"]]
      @list2 = Twitter::List.new
      @list2.members = [[1,"ivey"],[4,"tensigma"],[5,"smahend"],[8,"billy_goat"]]
      @list3 = Twitter::List.new
      @list3.members = [[1,"ivey"],[3,"ellieivey"],[6,"jteeter"],[7,"jackowayed"],[8,"billy_goat"]]
    end

    context "find union of the 3 lists" do
      setup do
        @union = Twitter::List.union(@list1,@list2,@list3)
      end

      should "have 8 elements" do
        @union.size.should be(8)
      end
    end

    context "find intersection of the 3 lists" do
      setup do
        @union = Twitter::List.intersection(@list1,@list2,@list3)
      end

      should "have 3 elements" do
        @union.size.should be(2)
      end
    end

  end
end
