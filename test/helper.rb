require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'matchy'
require 'context'
require 'stump'
require 'fakeweb'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'twitter-lists'

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get,
                     "http://user:pass@twitter.com/ivey/hah/members.json?cursor=-1",
                     :response => File.join(File.dirname(__FILE__), 'fixtures', 'ivey-hah-members.json'))
FakeWeb.register_uri(:get,
                     "http://user:pass@twitter.com/ivey/hah/members.json?cursor=1317534533279684274",
                     :response => File.join(File.dirname(__FILE__), 'fixtures', 'ivey-hah-members-p2.json'))

class Test::Unit::TestCase
end
