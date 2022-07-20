require 'roda'
require 'httparty'

class App < Roda
  plugin :render
  plugin :head

  route do |r|
    r.root do
      view('homepage')
    end

    r.on 'logged_in' do
      r.get do
        uri = 'https://smurnauth.herokuapp.com/oauth/token'
        params = {
          client_id: 'fyOIrPkU9uLz2NV2wA3pcYJVLHg9bMlpt_6khFJkUls',
          client_secret: 'PcrQz5izUqmztOm3lUqWIYanPjZqmkbFZKm31_r4gTk',
          code: r.params['code'],
          grant_type: 'authorization_code',
          redirect_uri: 'http://gh.localtest.me:9292/oauth/callback'
        }
        res = HTTParty.post(uri, body: params)
        @access_token = res.parsed_response['access_token']
        view('logged_in')
      end
    end

    r.is 'oauth/callback' do
      r.get do
        @code = r.params['code']
        view('login')
      end
    end
  end
end

run App.freeze.app
