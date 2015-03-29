var gTextSub        = 0;
var gTextSuper      = 0;
var gTextContent    = 0;
var gPrintText      = '';
var gOrgCardText    = '';

var faces = [':)', ':~', ':B',':|','8-)',':<',':$',':X',':Z',
             ':-|',':@',':P',':D',':O',':(',':+','--b',':Q',':T',
			 ',@P',',@-D',':d',',@o',':g','|-)',':!',':L',':>',':,@',
			 ',@f',':-S','?/',':,@x',',@@',':8',',@!','!!!','xx','bye',
			 'wipe','dig','handclap','&-(','B-)','<@','@>',':-O','>-|','P-(',
			 'X-)',':*','@x','8*','pd','<W>','beer','basketb','oo',
			 'coffee','eat','pig','rose','fade','showlove','heart','break','cake','li',
			 'bome','kn','footb','ladybug','shit','moon','sun','gift','hug','strong',
			 'weak','share','v','@)','jj','@@','bad','lvu','no','ok',
			 'love','<L>','jump','shake','<O>','circle','kotow','turn','skip','oY'];
var urls  = ['http://cache.soso.com/img/img/e100.gif',
    'http://cache.soso.com/img/img/e101.gif','http://cache.soso.com/img/img/e102.gif','http://cache.soso.com/img/img/e103.gif',
	'http://cache.soso.com/img/img/e104.gif','http://cache.soso.com/img/img/e105.gif','http://cache.soso.com/img/img/e106.gif',
	'http://cache.soso.com/img/img/e107.gif','http://cache.soso.com/img/img/e108.gif',
	'http://cache.soso.com/img/img/e110.gif','http://cache.soso.com/img/img/e111.gif','http://cache.soso.com/img/img/e112.gif',
	'http://cache.soso.com/img/img/e113.gif','http://cache.soso.com/img/img/e114.gif','http://cache.soso.com/img/img/e115.gif',
	'http://cache.soso.com/img/img/e116.gif','http://cache.soso.com/img/img/e117.gif','http://cache.soso.com/img/img/e118.gif',
	'http://cache.soso.com/img/img/e119.gif','http://cache.soso.com/img/img/e120.gif','http://cache.soso.com/img/img/e121.gif',
	'http://cache.soso.com/img/img/e122.gif','http://cache.soso.com/img/img/e123.gif','http://cache.soso.com/img/img/e124.gif',
	'http://cache.soso.com/img/img/e125.gif','http://cache.soso.com/img/img/e126.gif','http://cache.soso.com/img/img/e127.gif',
	'http://cache.soso.com/img/img/e128.gif','http://cache.soso.com/img/img/e129.gif','http://cache.soso.com/img/img/e130.gif',
	'http://cache.soso.com/img/img/e131.gif','http://cache.soso.com/img/img/e132.gif','http://cache.soso.com/img/img/e133.gif',
	'http://cache.soso.com/img/img/e134.gif','http://cache.soso.com/img/img/e135.gif','http://cache.soso.com/img/img/e136.gif',
	'http://cache.soso.com/img/img/e137.gif','http://cache.soso.com/img/img/e138.gif','http://cache.soso.com/img/img/e139.gif',
	'http://cache.soso.com/img/img/e140.gif','http://cache.soso.com/img/img/e141.gif','http://cache.soso.com/img/img/e142.gif',
	'http://cache.soso.com/img/img/e143.gif','http://cache.soso.com/img/img/e144.gif','http://cache.soso.com/img/img/e145.gif',
	'http://cache.soso.com/img/img/e146.gif','http://cache.soso.com/img/img/e147.gif','http://cache.soso.com/img/img/e148.gif',
	'http://cache.soso.com/img/img/e149.gif','http://cache.soso.com/img/img/e151.gif',
	'http://cache.soso.com/img/img/e152.gif','http://cache.soso.com/img/img/e153.gif','http://cache.soso.com/img/img/e154.gif',
	'http://cache.soso.com/img/img/e155.gif','http://cache.soso.com/img/img/e156.gif','http://cache.soso.com/img/img/e157.gif',
	'http://cache.soso.com/img/img/e158.gif','http://cache.soso.com/img/img/e159.gif','http://cache.soso.com/img/img/e160.gif',
	'http://cache.soso.com/img/img/e161.gif','http://cache.soso.com/img/img/e162.gif','http://cache.soso.com/img/img/e163.gif',
	'http://cache.soso.com/img/img/e164.gif','http://cache.soso.com/img/img/e165.gif','http://cache.soso.com/img/img/e166.gif',
	'http://cache.soso.com/img/img/e167.gif','http://cache.soso.com/img/img/e168.gif','http://cache.soso.com/img/img/e169.gif',
	'http://cache.soso.com/img/img/e170.gif','http://cache.soso.com/img/img/e171.gif','http://cache.soso.com/img/img/e172.gif',
	'http://cache.soso.com/img/img/e173.gif','http://cache.soso.com/img/img/e174.gif','http://cache.soso.com/img/img/e175.gif',
	'http://cache.soso.com/img/img/e176.gif','http://cache.soso.com/img/img/e177.gif','http://cache.soso.com/img/img/e178.gif',	
	'http://cache.soso.com/img/img/e179.gif','http://cache.soso.com/img/img/e180.gif','http://cache.soso.com/img/img/e181.gif',	
	'http://cache.soso.com/img/img/e182.gif','http://cache.soso.com/img/img/e183.gif','http://cache.soso.com/img/img/e184.gif',	
	'http://cache.soso.com/img/img/e185.gif','http://cache.soso.com/img/img/e186.gif','http://cache.soso.com/img/img/e187.gif',	
	'http://cache.soso.com/img/img/e188.gif','http://cache.soso.com/img/img/e189.gif','http://cache.soso.com/img/img/e190.gif',	
	'http://cache.soso.com/img/img/e191.gif','http://cache.soso.com/img/img/e192.gif','http://cache.soso.com/img/img/e193.gif',
	'http://cache.soso.com/img/img/e194.gif','http://cache.soso.com/img/img/e195.gif','http://cache.soso.com/img/img/e196.gif',
	'http://cache.soso.com/img/img/e197.gif','http://cache.soso.com/img/img/e198.gif','http://cache.soso.com/img/img/e199.gif'
];


if(typeof(gTextAreaLeft) == 'undefined')
{
    var gTextAreaLeft = 0.1;
}

if(typeof(gTextAreaTop) == 'undefined')
{
    var gTextAreaTop = 0.2;
}

if(typeof(gTextAreaWidth) == 'undefined')
{
    var gTextAreaWidth = 0.8;
}

if(typeof(gTextAreaHeight) == 'undefined')
{
    var gTextAreaHeight = 0.2;
}

if(typeof(gCardText) == 'undefined')
{
    var gCardText = '小小卡片一张，带来我的温馨祝福无限';
}

if(typeof(gCardTextNoWrap) == 'undefined')
{
    var gCardTextNoWrap = '小小卡片一张，带来我的温馨祝福无限';
}

if(typeof(gSizeMode) == 'undefined')
{
    var gSizeMode = 'img';  // img or bodywidth
}

if(typeof(gAnimateMode) == 'undefined')
{
    var gAnimateMode = 'left';
}

if(typeof(gSpeed) == 'undefined')
{
    var gSpeed = 350;
}

function ConvFaceOnBegin(message)
{
	var result = '';

	var i = 0;
	
	if(message.substring(i, i + 2) == '/:')
	{
		for(f=0; f<faces.length; f++)
		{
			facestr = faces[f];
			if(message.substring(i + 2, i + 2 + facestr.length) == facestr)
			{
				result = '<img src="' + urls[f] +'" width="48" height="48">';
				i = i + 2 + facestr.length;
				break;
			}
		}
	}
	
	return [result, i];
}

function ConvFace(message)
{
	var msglen = message.length;
	var result = '';

	var i = 0;
	
	while(i < msglen)
	{
		var found = false;
		
		if(message.substring(i, i + 2) == '/:')
		{
			for(f=0; f<faces.length; f++)
			{
				facestr = faces[f];
				if(message.substring(i + 2, i + 2 + facestr.length) == facestr)
				{
					result = result + '<img src="' + urls[f] +'" width="36" height="36">';
					i = i + 2 + facestr.length;
					found = true;
					break;
				}
			}
		}
		
		if(found == false)
		{
			result = result + message.substring(i, i + 1);
			i += 1;
		}
	}
	
	return result;
}

function playsound()
{
    if(typeof(gSound) != 'undefined')
    {
        var audio = document.getElementById('bgsound');
        audio.play();
    }
}

function onLoad()
{
    gTextSub     = document.getElementById("textsub");
    gTextSuper   = document.getElementById("textsuper");
    gTextContent = document.getElementById("textcontent");
    
    if(gSizeMode == 'img')
    {
        var cardimg = document.getElementById("cardimg");
        gTextSuper.style.left   = cardimg.offsetLeft + cardimg.offsetWidth  * gTextAreaLeft;
        gTextSuper.style.top    = cardimg.offsetTop  + cardimg.offsetHeight * gTextAreaTop;
        gTextSuper.style.height = cardimg.offsetHeight * gTextAreaHeight;
        gTextSuper.style.width  = cardimg.offsetWidth  * gTextAreaWidth;
    }
    else if(gSizeMode == 'bodywidth')
    {
        var ruler   = document.getElementById("ruler");
        var baseLen = ruler.offsetWidth;
        gTextSuper.style.left   = baseLen * gTextAreaLeft + 'px';
        gTextSuper.style.top    = baseLen * gTextAreaTop + 'px';
        gTextSuper.style.height = baseLen * gTextAreaHeight + 'px';
        gTextSuper.style.width  = baseLen * gTextAreaWidth + 'px';
    }
    
    if(gAnimateMode == 'print')
    {
        onPrintLoad();
        setTimeout("onPrintAnimate()", 1500);
    }
    else if(gAnimateMode == 'up')
    {
        onUpLoad();
        setTimeout("onUpAnimate()", 10);
    }
    else if(gAnimateMode == 'left')
    {
		gCardText = gCardText.replace(/<br>/g, "");
        onLeftLoad();
        setTimeout("onLeftAnimate()", 10);
    }
	else if(gAnimateMode == 'static')
	{
		gCardText = gCardText.replace(/<br>/g, "");
        onStaticLoad();
	}

    gTextContent.innerHTML = gCardText;
    

    // sound
	//var audio = document.getElementById('bgsound');
	//audio.src = gSound;
	//audio.play();
    
    // font size
    if(typeof(gFontSize) != 'undefined')
    {
        gTextContent.style.fontSize = gFontSize;
    }
	
	// font color
    if(typeof(gColor) != 'undefined')
    {
        gTextContent.style.color = gColor;
    }
}

function onPrintLoad()
{
	gTextSub.style.top = gTextSuper.offsetHeight + 'px';
    gPrintText         = gCardText;
    gOrgCardText       = gCardText;
    gCardText          = '';
}
    
function onUpLoad()
{
	gCardText = ConvFace(gCardText);
    gTextSub.style.top = gTextSuper.offsetHeight + 'px';
}

  
function onLeftLoad()
{
	gCardText = ConvFace(gCardText);
    textwidth = 75 * gCardText.length ;
    if(textwidth < 500) textwidth = 500 ;
    
    gTextSub.style.width = textwidth + 'px';
    gTextSub.style.left  = gTextSuper.offsetWidth +'px';
}

function onStaticLoad()
{
	gCardText = ConvFace(gCardText);
    gTextSub.style.top = gTextSuper.offsetHeight;
}
  
function goguanzhu()
{
    location.href = 'http://mp.weixin.qq.com/s?__biz=MjM5NjIzOTE2OQ==&mid=200366500&idx=1&sn=21c2832b5382e6aafd4e55a0d6c85f5f#rd';
}

function change_txt (msg){
    var reg = /(?:([。\.，\,？\?！\!；\;]))/g ;
    return msg.replace(reg, function(i){
        return i + '<br>' ;
    });
}

function onPrintAnimate()
{
    pushText = '';
    
	var reachEnd = 0;
	
	if(gPrintText.length <= 1)
	{
		reachEnd = 1;
	}
	
	var cutlen = 0;

    if(gPrintText.length >= 4 && gPrintText.substring(0, 4) == '<br>')
    {
        gPrintText = gPrintText.substring(4);
        pushText = '<br>';
		cutlen = 4;
    }
	else if(gPrintText.substring(0, 2) == '/:')
	{
		result = ConvFaceOnBegin(gPrintText);
		cutlen = result[1];
		if(cutlen > 0)
		{
			gPrintText = gPrintText.substring(cutlen)
			pushText = result[0]
		}
	}
	
    if(cutlen == 0 && gPrintText.length >= 1)
    {
        pushText   = gPrintText.substring(0, 1)
        gPrintText = gPrintText.substring(1)
    }

    textcontent.innerHTML = textcontent.innerHTML + pushText

    if(textsub.offsetTop + textsub.offsetHeight > textsuper.offsetHeight)
    {
        textsub.style.top = textsuper.offsetHeight - textsub.offsetHeight +'px';
    }

	if(reachEnd == 1)
	{
		setTimeout("onPrintAnimate()", 10000);
	}
    else if(gPrintText.length == 0)
	{
        gTextSub.style.top     = gTextSuper.offsetHeight + 'px';
        gPrintText             = gOrgCardText;
        gTextContent.innerHTML = gCardText;
        
        setTimeout("onPrintAnimate()", 1500);
    }
    else
	{
		setTimeout("onPrintAnimate()", gSpeed);
    }
}

function onUpAnimate()
{
    textsub.style.top = textsub.offsetTop - 1 + 'px';
    
    if(textsub.offsetTop < - textsub.offsetHeight)
    {
        textsub.style.top = textsuper.offsetHeight + 'px';
    }
    
    setTimeout("onUpAnimate()", 20);
}

function onLeftAnimate()
{
    gTextSub.style.left = gTextSub.offsetLeft - 1 + 'px';
    
    if(gTextSub.offsetLeft < - textwidth)
    {
        gTextSub.style.left = gTextSuper.offsetWidth + 'px';
    }
    
    setTimeout("onLeftAnimate()", 10);
}

function weixinAddContact()
{
    if(typeof(WeixinJSBridge) != "undefined")
    {
        WeixinJSBridge.invoke(
            "addContact",
            {webtype: "1",username: "kagirl"},
            function(e){
                if(e.err_msg == "access_control:not_allow")
                {
                    document.location = "../kagirl/htm/t1.htm"
                }
                }
            )
    }
    else
    {
        document.location = "../kagirl/htm/t1.htm"
    }
}
