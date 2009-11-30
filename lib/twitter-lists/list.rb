require 'set'
module Twitter
  class List

    attr_accessor :id, :name, :user, :description, :members
    
    class << self
      def twitter_base
        @twitter_base
      end

      def twitter_base=(base)
        @twitter_base=base
      end

      def setup_basic_auth(username, password)
        self.twitter_base = Twitter::Base.new(Twitter::HTTPAuth.new(username, password))
      end

      def parse(str)
        n= new
        n.user, n.name = str.sub(/^@/,'').split('/')
        n
      end

      def union(*lists)
        lists = lists.collect { |l| l.is_a?(List) ? l : parse(l) }
        sets = lists.collect { |l| Set.new l.members }
        sets.inject { |u,s| s.union u }.to_a
      end

      def intersection(*lists)
        lists = lists.collect { |l| l.is_a?(List) ? l : parse(l) }
        sets = lists.collect { |l| Set.new l.members }
        sets.inject { |i,s| s.intersection i }.to_a
      end
    end

    def twitter_base
      self.class.twitter_base
    end

    def load_members
      self.members = load_members_paged.collect { |x| [x.id, x.screen_name] }
    end
    
    def member_names
      members.collect { |x| username(x) }
    end

    def member_ids
      members.collect { |x| userid(x) }
    end

    def load_members_paged(acc=[],cursor=-1)
      response = twitter_base.list_members(user,name,cursor)
      acc += response.users
      response.next_cursor == 0 ? acc : load_members_paged(acc,response.next_cursor)
    end

    protected
    def username(l)
      l[1]
    end

    def userid(l)
      l[0]
    end

  end
end
