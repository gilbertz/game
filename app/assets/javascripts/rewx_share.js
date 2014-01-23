 var is_weixin = function () {
                var ua = navigator.userAgent.toLowerCase();
                if(ua.match(/MicroMessenger/i) == "micromessenger") {
                    if(ua.match(/iphone/i) == "iphone") {
                        return 'ios';
                    }
                    return 'android';
                }
                return false;
            }

            var foo = function (o) {
                if (o.value == o.defaultValue) {
                    o.value = '';
                    o.style.color = '#000';
                }
            }

            var bar = function (o) {
                if (o.value == '') {
                    o.value = o.defaultValue;
                    o.style.color = '#9a9a9a';
                } else {
                    o.style.color = '#000';
                }
            }

            var mask = function () {
                if (document.getElementById('mask').style.display == 'inline') {
                    document.getElementById('mask').style.display = 'none';
                    document.getElementById('tip').style.display = 'none';
                } else {
                    document.getElementById('mask').style.display = 'inline';
                    document.getElementById('tip').style.display = 'inline';
                }
            }

            var share = function () {
                mask();
            }

            var share_callback_hy = function () {
                ajax = new XMLHttpRequest();
                ajax.open('GET', '/games/info/wx_share?f=wx', true);
                ajax.send(null);
            }

            var share_callback_pyq = function () {
                ajax = new XMLHttpRequest();
                ajax.open('GET', '/games/info/wx_share?f=wx', true);
                ajax.send(null);
            }

             
            var dataForWeixin = {
              appId: '<%= @wx_appid %>',
              TLImg: "<%= @wx_tlimg  %>",
              url: "<%= @wx_url %>",
              title: "<%= @wx_title %>",
              desc: "<%= @wx_desc %>"
           };

           var name = "<%= params[:name] %> 的测试结果出来了。"

           var onBridgeReady = function(){
                WeixinJSBridge.on('menu:share:appmessage', function(argv){
                    WeixinJSBridge.invoke('sendAppMessage', {
                        "appid": dataForWeixin.appId,
                            "img_url": dataForWeixin.TLImg,
                            "img_width": "120",
                            "img_height": "120",
                            "link": dataForWeixin.url,
                            "title": name + dataForWeixin.title,
                            "desc": dataForWeixin.desc 
                    });
                    share_callback_hy();
                    setTimeout(function () {location.href = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5MzgxNTAxMQ==&amp;appmsgid=10014731&amp;itemidx=4&amp;sign=0f0ce2b22793fd9a882d60438b0a91a5&amp;scene=1#wechat_redirect";}, 1500); 
                });
                WeixinJSBridge.on('menu:share:timeline', function(argv){
                    WeixinJSBridge.invoke('shareTimeline', {
                        "appid": dataForWeixin.appId,
                        "img_url":dataForWeixin.TLImg,
                        "img_width": "120",
                        "img_height": "120",
                        "link": dataForWeixin.url,
                        "title": name + dataForWeixin.title,
                        "desc": name + dataForWeixin.desc
                    });
                    share_callback_pyq();
                    setTimeout(function () {location.href = "http://mp.weixin.qq.com/mp/appmsg/show?__biz=MjM5MzgxNTAxMQ==&amp;appmsgid=10014731&amp;itemidx=4&amp;sign=0f0ce2b22793fd9a882d60438b0a91a5&amp;scene=1#wechat_redirect";}, 1500); 
                });
            };
            if(document.addEventListener){
                document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);
            }else if(document.attachEvent){
                document.attachEvent('WeixinJSBridgeReady', onBridgeReady);
                document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);
            } 
