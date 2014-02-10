$(function(){
    //瀑布流
    var speed      = 1000;
    var $container = $('.container_12');
    //$('#page_nav').css('display', 'none');

    $container.masonry({
        singleMode      : true,
        //columnWidth     : 300,
        itemSelector    : '.grid_4',
        animate         : true,
        animationOptions: {
            duration: speed,
            queue   : false
        }
    });

    //无限滚动
    $('.maxcontainer2').infinitescroll({
        navSelector    : "#page_nav",
        nextSelector   : "#page_nav a",
        itemSelector   : ".maxitem",
        debug          : false,
        loadingImg     : '/assets/static-loader.png',
        loadingText    : "<em>加载更多</em>",
        donetext       : "<em>没有更多的了</em>",
        errorCallback  : function() {
            $('#infscr-loading').animate({opacity: .8},2000).fadeOut('normal');
        }},
        function( newElements ) {
            var $newElems = $( newElements ).css({ opacity: 0 });
            $newElems.animate({ opacity: 1 });
            $container.masonry( 'appended', $newElems, true );
        });

})
