var mongoskin = require("mongoskin")
var mongodb = require("mongodb")
var ObjectId = mongodb.BSONPure.ObjectID

var cs = require("coffee-script")

var db = mongoskin.db("localhost/test?auto_reconnect")
var fs = require("fs")
var async = require("async")
var express = require("express")
    require('express-namespace')
var api = require('./api/api')
var s3 = require('./api/s3')
var RedisStore = require('connect-redis')(express)

var auth = require("./auth")
var analytics = require("./api/analytics")

var courses = db.collection("courses")

var settings = {
	session: {
		key: 'token',
		secret: '65542df21089e1a59f6a0bfc7a5d32ccf2eccd27e7a18fee09c8f6f',
		cookie: {
			 path: '/',
			 httpOnly: false,
			 maxAge: 86400000
		},
		store: new RedisStore
	}
}

// initialize express server
var app = express.createServer(
    express.bodyParser(),
    express.cookieParser(),
    auth.token_middleware(),
    express.session(settings.session),
    auth.user_middleware()
)

app.listen(2000)

app.use(function (req, res, next) {
    res.removeHeader("X-Powered-By")
    delete req.query._
    next()
})

app.use("/login", auth.login)
app.use("/logout", auth.logout)
app.use("/hash", auth.hash)
app.use("/check", auth.check)

app.use('/static', express.static(__dirname + '/public'))
app.use('/backbone', express.static(__dirname + '/backbone'))
app.use('/require', express.static(__dirname + '/require'))

// express routing
app.namespace('/api', api.router)
app.namespace('/s3', s3.router)
app.namespace('/analytics', analytics.router)

app.get('/ucsd/cogs160/wi12/*', function(request, response) {
  fs.readFile(__dirname + '/public/cogs160.html', function(err,text) {
      response.end(text)
  })
})

app.get('/ucsd/cogs187a/wi12/*', function(request, response) {
  fs.readFile(__dirname + '/public/cogs187a.html', function(err,text) {
      response.end(text)
  })
})

var base_html = fs.readFileSync(__dirname + '/require/build/test_build.html')

app.get('/course/*', function(request, response) {
  response.end(base_html)
})

app.get('/src/*', function(request, response) {
  fs.readFile(__dirname + '/require/src/test_src.html', function(err,text) {
      response.end(text)
  })
})

app.get('/', function(request, response) {
  response.redirect("/course/")
})

app.get("/course", function(req, res) {
 	res.redirect("/course/")
})

var server = express.createServer(
  //express.logger(), // Log responses to the terminal using Common Log Format.
  //express.responseTime() // Add a special header with timing information.
)

server.use(express.vhost('beta.thiscourse.com', app))

api.initialize()

