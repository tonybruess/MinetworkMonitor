class Check
    include Mongoid::Document

    field :protocol_version
    field :server_version
    field :motd
    field :players_online
    field :players_max
    belongs_to :server

end

