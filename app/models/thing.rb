class Thing < ApplicationRecord

  def self.properties
    return [
      ['canHave', "Kan hebben"],
      ['mustHave', "Moet hebben"]
    ]
  end

end
