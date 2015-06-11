@StatisCtrl = ($scope, $location, $http, postData) ->



  $scope.viewPost = (postId) ->
    $location.url('/post/'+postId)

  $scope.send = ->
    $location.url('/activity')

@StatisCtrl.$inject = ['$scope', '$location', '$http', 'postData']

