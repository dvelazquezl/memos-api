class User < ApplicationRecord
    belongs_to :office

    enum role: [:manager, :admin]
end
