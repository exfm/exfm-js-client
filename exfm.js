(function() {
  var ExfmClient, http, querystring, __makeRequest;
  ExfmClient = (function() {
    function ExfmClient() {}
    ExfmClient.getUser = function(username, callback) {
      return __get("/user/" + username, callback);
    };
    ExfmClient.getUserLoved = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/loved", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserFollowers = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/followers", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserFollowing = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/following", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserFollowingIds = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/following_ids", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserFeedLove = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/feed/love", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserActivity = function(username, callback, verb, start, results) {
      var route;
      if (verb == null) {
        verb = null;
      }
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      route = "/user/" + username + "/activity";
      if (verb) {
        route += "/" + verb;
      }
      return __get(route, callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getUserNotifications = function(username, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/user/" + username + "/notifications", callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getSong = function(songId, callback) {
      return __get("/song/" + songId, callback);
    };
    ExfmClient.getSongSearchResults = function(query, callback, start, results) {
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      return __get("/search/song/" + query, callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getSongGraph = function(songId, callback) {
      return __get("/song/" + songId + "/graph", callback);
    };
    ExfmClient.loveSong = function(username, passwordHash, songId, callback, clientId, context, source) {
      var data;
      if (clientId == null) {
        clientId = 'exfm_api_client';
      }
      if (context == null) {
        context = null;
      }
      if (source == null) {
        source = null;
      }
      data = {
        username: username,
        password: passwordHash,
        client_id: clientId,
        context: context,
        source: source
      };
      return __post("/song/" + songId + "/love", callback, data);
    };
    ExfmClient.unloveSong = function(username, passwordHash, songId, callback) {
      var data;
      data = {
        username: username,
        password: passwordHash
      };
      return __post("/song/" + songId + "/unlove", callback, data);
    };
    ExfmClient.getTrending = function(callback, date, start, results) {
      var route;
      if (date == null) {
        date = null;
      }
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      route = "/trending";
      if (date) {
        route += "/" + date;
      }
      return __get(route, callback, {
        start: start,
        results: results
      });
    };
    ExfmClient.getSOTD = function(callback) {
      return __get("/sotd", callback);
    };
    ExfmClient.getMOTM = function(callback) {
      return __get("/motm", callback);
    };
    ExfmClient.getAOTW = function(callback) {
      return __get("/aotw", callback);
    };
    ExfmClient.getExplore = function(callback, genre, start, results) {
      var route;
      if (genre == null) {
        genre = null;
      }
      if (start == null) {
        start = 0;
      }
      if (results == null) {
        results = 20;
      }
      route = "/explore";
      if (genre) {
        route += "/" + genre;
      }
      return __(get(route, callback, {
        start: start,
        results: results
      }));
    };
    return ExfmClient;
  })();
  module.exports = ExfmClient;
  ({
    __get: function(route, callback, data) {
      if (data == null) {
        data = {};
      }
      return __makeRequest(route, data, callback, 'GET');
    },
    __post: function(route, callback, data) {
      if (data == null) {
        data = {};
      }
      return __makeRequest(route, data, callback, 'POST');
    },
    __makeRequestJquery: function(route, data, callback, method) {
      var url;
      if (method == null) {
        method = 'GET';
      }
      url = "http://ex.fm/api/v3" + route + "?callback=?";
      if (method === 'GET') {
        return $.get(url, data, function(data) {
          return callback.apply(this, data);
        });
      } else {
        return $.post(url, data, function(data) {
          return callback.apply(this, data);
        });
      }
    },
    __makeRequestNode: function(route, data, callback, method) {
      var options, path, req, responseBuffer;
      if (method == null) {
        method = 'GET';
      }
      path = "/api/v3" + route;
      if (method === "GET") {
        path += "?" + querystring.stringify(data);
      }
      responseBuffer = '';
      options = {
        host: 'ex.fm',
        port: 80,
        path: path,
        method: method
      };
      req = http.request(options, function(res) {
        res.on('data', function(chunk) {
          return responseBuffer += chunk.toString();
        });
        res.on('end', function() {
          data = JSON.parse(responseBuffer);
          if (data.status_code !== 200) {
            throw data.status_text;
          }
          return callback.apply(this, data);
        });
        return res.on('error', function(data) {
          return console.log(data);
        });
      });
      if (method === "GET") {
        return req.end();
      } else {
        return req.end(data);
      }
    }
  });
  if (jQuery) {
    __makeRequest = __makeRequestJquery;
  } else if (typeof require !== "undefined" && require !== null) {
    http = require('http');
    querystring = require('querystring');
    __makeRequest = __makeRequestNode;
  } else {
    throw 'Not node and not jquery.  Need another transport.';
  }
}).call(this);
