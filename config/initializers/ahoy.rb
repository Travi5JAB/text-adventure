class Ahoy::Store < Ahoy::DatabaseStore
end

# set to true for JavaScript tracking
Ahoy.api = false
Ahoy.cookie_options = {same_site: :strict}
Ahoy.geocode = true
