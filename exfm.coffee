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

module.exports = ExfmClient

__get: (route, callback, data={}) ->
    __makeRequest(route, data, callback, 'GET')

__post: (route, callback, data={}) ->
    __makeRequest(route, data, callback, 'POST')

__makeRequestJquery: (route, data, callback, method='GET') ->
    url = "http://ex.fm/api/v3#{route}?callback=?"
    if method == 'GET'
        $.get url, data, (data) ->
            callback.apply this, data
    else
        $.post url, data, (data) ->
            callback.apply this, data

__makeRequestNode: (route, data, callback, method='GET') ->
    path = "/api/v3#{route}"

    if method is "GET"
        path += "?" + querystring.stringify data

    responseBuffer = ''

    options =
        host: 'ex.fm',
        port: 80,
        path: path
        method: method

    req = http.request options, (res) ->
        res.on 'data', (chunk) ->
            responseBuffer += chunk.toString()

        res.on 'end', () ->
            data = JSON.parse(responseBuffer)
            if data.status_code != 200
                throw data.status_text

            callback.apply this, data

        res.on 'error', (data) ->
            console.log data

    if method is "GET"
        req.end()
    else
        req.end(data)

if jQuery
    __makeRequest = __makeRequestJquery
else if require?
    http = require('http')
    querystring = require('querystring')
    __makeRequest = __makeRequestNode
else
    throw ('Not node and not jquery.  Need another transport.')
