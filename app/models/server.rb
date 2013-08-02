class Server
    include Mongoid::Document

    field :name
    field :ip
    field :port

    field :stathat_token # api access token
    field :stathat_id # short id found in url
    field :stathat_key # get code -> key
    field :stathat_ukey # get code -> ukey
    field :stathat_data, :type => Array, :default => Array.new

end
