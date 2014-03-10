require 'minitest/autorun'
require_relative '../lib/teamspeak-ruby'

class TeamspeakTest < MiniTest::Unit::TestCase
  def setup
    @ts = Teamspeak.new
    @ts.login('serveradmin', 'travis_test')
    @ts.command('use', {'sid' => 1})
  end

  def test_get_hostinfo
    assert(@ts.command('hostinfo').first['host_timestamp_utc'])
  end

  def test_get_clients
    @ts.command('clientlist').each do |user|
      assert(user['client_nickname'])
    end
  end

  def teardown
    @ts.disconnect
  end
end
