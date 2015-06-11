# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self
#= require_tree ./Controllers/main
#= require_tree ./Services/main

# Creates new Angular module called 'Blog'
y1y = angular.module('y1y', [])

# Sets up routing
y1y.config(['$routeProvider', ($routeProvider) ->
  # Route for '/post/'
  $routeProvider
    .when('/statis', { templateUrl: '../assets/statis.html', controller: 'StatisCtrl' } )
    .when('/activity', { templateUrl: '../assets/mainCreatePost.html', controller: 'CreatePostCtrl' } )
    .when('/post/:postId', { templateUrl: '../assets/mainPost.html', controller: 'PostCtrl' } )
    #.when('/post/:postId/edit', { templateUrl: '../assets/mainEditPost.html', controller: 'EditPostCtrl' } )

  # Default
  $routeProvider.otherwise({ templateUrl: '../assets/mainLogin.html', controller: 'LoginCtrl' } )

])

y1y.config(["$httpProvider", (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
])