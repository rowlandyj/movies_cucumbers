RT_API_KEY = ENV['RT_API_KEY']

RottenTomatoes::Rotten.api_key = RT_API_KEY
# setup your API key

TMDB_API_KEY = ENV['TMDB_API_KEY']
Tmdb.api_key = TMDB_API_KEY

# setup your default language
Tmdb.default_language = "en"

include RottenTomatoes
