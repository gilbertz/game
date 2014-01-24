 var share_callback_hy = function () {
            ajax = new XMLHttpRequest();
            ajax.open('GET', '/games/info/wx_share?f=wx_hy', true);
            ajax.send(null);
        }

        var share_callback_pyq = function () {
            ajax = new XMLHttpRequest();
            ajax.open('GET', '/games/info/wx_share?f=wx_pyq', true);
            ajax.send(null);
        }


        var dataForWeixin = {
            appId: 'wx78f81724e6590b1d',
            TLImg: "http://mashang.qiniudn.com/ma.jpg",
            url: document.location.href,
            title: "我的瓜瓜结果：2014马上" + randData.title  + ", 你'马上'了吗?",
            desc: "2014年，你'马上'有什么好运，快来刮刮看~"
        };



        var onBridgeReady = function(){
            WeixinJSBridge.on('menu:share:appmessage', function(argv){
                WeixinJSBridge.invoke('sendAppMessage', {
                    "appid": dataForWeixin.appId,
                    "img_url": dataForWeixin.TLImg,
                    "img_width": "120",
                    "img_height": "120",
                    "link": dataForWeixin.url + '?f=wx_hy_1',
                    "title": dataForWeixin.title,
                    "desc": dataForWeixin.desc 
                });
                share_callback_hy();
                setTimeout(function () {location.href = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5MzgxNTAxMQ==&appmsgid=10014731&itemidx=4&sign=0f0ce2b22793fd9a882d60438b0a91a5";}, 1500);  
            });
            WeixinJSBridge.on('menu:share:timeline', function(argv){
                WeixinJSBridge.invoke('shareTimeline', {
                    "appid": dataForWeixin.appId,
                    "img_url":dataForWeixin.TLImg,
                    "img_width": "120",
                    "img_height": "120",
                    "link": dataForWeixin.url + '?f=wx_pyq_1',
                    "title": dataForWeixin.title,
                    "desc": dataForWeixin.desc
                });
                share_callback_pyq();
                setTimeout(function () {location.href = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5MzgxNTAxMQ==&appmsgid=10014731&itemidx=4&sign=0f0ce2b22793fd9a882d60438b0a91a5";}, 1500);    
            });
        };
        if(document.addEventListener){
            document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
        }else if(document.attachEvent){
            document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
            document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
        }
