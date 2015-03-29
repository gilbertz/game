function change_txt (msg){
    var reg = /(?:([。\.，\,？\?！\!；\;]))/g ;
    return msg.replace(reg, function(i){
        return i + '<br>' ;
    });
}

function goguanzhu()
{
    location.href = 'http://mp.weixin.qq.com/s?__biz=MjM5NjIzOTE2OQ==&mid=200366500&idx=1&sn=21c2832b5382e6aafd4e55a0d6c85f5f#rd';
}

function obj(objid)
{
    return document.getElementById(objid)
}

function onMoveEnd()
{
    win_height = obj("textsuper").offsetHeight;
    
    var item = obj("textsub");
    item.style.webkitTransition = "";
    item.style.top = "" + win_height + "px";
    moveUp();
}

function moveUp()
{
    var win_height = obj("textsuper").offsetHeight;
    var img_h = obj("fontimg").height || obj('text_container').offsetHeight;
    var t_use = (img_h+win_height)/g_speed;
    var item  = obj("textsub");
    item.style.webkitTransition = "top " + t_use + "s linear";
    item.style.top = "-" + img_h + "px";
}

function onTextLoad()
{
    obj("textsuper").style.top = g_text_y + 'px';
    obj("textsuper").style.left = g_text_x + 'px';
    obj("textsuper").style.width = g_text_w + 'px';
    obj("textsuper").style.height = g_text_h + 'px';
    win_height = obj("textsuper").offsetHeight;
    var item = obj("textsub");
    item.style.top = "" + win_height + "px";
    obj("textsub").addEventListener("webkitTransitionEnd", onMoveEnd, false)
    moveUp();
}

function loadFontImg()
{
    if(typeof(g_words) == "undefined" || g_words == "")
    {
        return;
    }
    
	host = "aliyun7.kagirl.cn:8000";
	
	if(typeof(font_svr_ip) != "undefined")
	{
		host = font_svr_ip;
	}
	
    var url = "http://" + host + "/fontimg?words=" + encodeURIComponent(g_words) + "&fontname=" + g_font_name + "&fontsize=" + g_font_size + "&gap=" + g_gap + "&width=" + g_width_c + "&date=" + g_date + "&color=" + g_color;

    obj("fontimg").style.top = 2000;
	obj("fontimg").style.left = 0;
    obj("fontimg").onload = onTextLoad;
    obj("fontimg").src = url;
}

function loadWords( ){
    if(typeof g_words == 'undefined' || g_words == '' )
        return ; 

    var w_array = g_words.split('<br>') , 
        i, len, p, div ; 

    div = document.getElementById('text_container') ;
    for( i = 0 , len = w_array.length; i < len; i++ ){
        p = document.createElement('p') ; 
        p.style.color = '#fff' ;
        p.textContent = w_array[i] ;
        div.appendChild(p) ;
    }
    div.style.top = 2000 ; 
    div.style.left = 0 ; 

    onTextLoad();
}
