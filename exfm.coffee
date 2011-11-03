__get: (route, callback, data={}) ->
    __makeRequest(route, data, callback, 'GET')

__post: (route, callback, data={}) ->
    __makeRequest(route, data, callback, 'POST')

__makeRequest: (route, data, callback, method='GET') ->


class ExfmClient
    @getUser: (username, callback)->
        __get "/user/#{username}", callback

    @getUserLoved: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/loved", callback, {start: start, results: results}

    @getUserFollowers: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/followers", callback, {start: start, results: results}

    @getUserFollowing: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/following", callback, {start: start, results: results}

    @getUserFollowingIds: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/following_ids", callback, {start: start, results: results}

    @getUserFeedLove: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/feed/love", callback, {start: start, results: results}

    @getUserActivity: (username, callback, verb=null, start=0, results=20) ->
        route = "/user/#{username}/activity"
        if verb
            route += "/#{verb}"

        __get route, callback, {start: start, results: results}

    @getUserNotifications: (username, callback, start=0, results=20) ->
        __get "/user/#{username}/notifications", callback, {start: start, results: results}

    @getSong: (songId, callback) ->
        __get "/song/#{songId}", callback

    @getSongSearchResults: (query, callback, start=0, results=20) ->
        __get "/search/song/#{query}", callback, {start: start, results: results}

    @getSongGraph: (songId, callback) ->
        __get "/song/#{songId}/graph", callback

    @loveSong: (username, passwordHash, songId, callback, clientId='exfm_api_client', context=null, source=null) ->

        data =
            username: username
            password: passwordHash
            client_id: clientId
            context: context
            source: source

        __post "/song/#{songId}/love", callback, data

    @unloveSong: (username, passwordHash, songId, callback) ->
        data =
            username: username
            password: passwordHash

        __post "/song/#{songId}/unlove", callback, data

    @getTrending: (callback, date=null, start=0, results=20) ->
        route = "/trending"
        if date
            route += "/#{date}"

        __get route, callback, {start: start, results: results}

    @getSOTD: (callback) ->
        __get "/sotd", callback

    @getMOTM: (callback) ->
        __get "/motm", callback

    @getAOTW: (callback) ->
        __get "/aotw", callback

    @getExplore: (callback, genre=null, start=0, results=20) ->
        route = "/explore"
        if genre
            route += "/#{genre}"

        __ get route, callback, {start: start, results: results}












