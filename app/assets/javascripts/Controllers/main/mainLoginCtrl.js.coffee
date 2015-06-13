@LoginCtrl = ($scope, $location, $http, postData) ->

  $scope.data = postData.data

  postData.loadPosts(null)

  $scope.viewPost = (postId) ->
    $location.url('/post/'+postId)

  $scope.send = ->
    $location.url('/activity')

@LoginCtrl.$inject = ['$scope', '$location', '$http', 'postData']