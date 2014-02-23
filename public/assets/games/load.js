/**
 * FlattrButton v0.2
 */
var FlattrButton = {
	
	instance: false,
	queryString: false,
	apiDomain: 'api.flattr.com',

	assembleDataString: function() {

		if (this.getParam('eval', 1) == true) {
			if (this.instance.innerHTML)
			{
				eval(this.instance.innerHTML);
			}
		}

		this.useCompact = ( typeof flattr_btn == 'string' && flattr_btn.toLowerCase() == 'compact' ? true : this.getParam('compact', false) );

		var url = typeof flattr_url == 'string' ? flattr_url : (typeof FLATTR_URL == 'string' ? FLATTR_URL : window.location.href);
		var uid = typeof flattr_uid == 'string' ? flattr_uid : '0';
		var tle = typeof flattr_tle == 'string' ? flattr_tle : '';
		var dsc = typeof flattr_dsc == 'string' ? flattr_dsc : '';
		var tag = typeof flattr_tag == 'string' ? flattr_tag : '';
		var cat = typeof flattr_cat == 'string' ? flattr_cat : '';
		var lng = typeof flattr_lng == 'string' ? flattr_lng : '';

		url = encodeURIComponent(url);
		uid = encodeURIComponent(uid);
		tle = encodeURIComponent(tle.replace(/(\r\n|\n|\r)/gm, ''));
		dsc = encodeURIComponent(dsc.replace(/(\r\n|\n|\r)/gm, ''));
		tag = encodeURIComponent(tag);
		cat = encodeURIComponent(cat);
		lng = encodeURIComponent(lng);

		var hide = (typeof(flattr_hide) != 'undefined' && flattr_hide == true ? 1 : 0);

		var data = 'uid='+uid+'&url='+url+'&language='+lng+'&hidden='+hide+'&title='+tle+'&category='+cat+'&tags='+tag+'&description='+dsc;
		if (this.useCompact == true) {
			data = 'button=compact&' + data;
		}

		return data;
	},

	createIframe: function(data, compact) {

		var compact = compact || false;

		var iframe = document.createElement('iframe');
		iframe.setAttribute('src', 'http://'+ this.apiDomain +'/button/view/?'+ data);
		iframe.setAttribute('width', (compact == true ? 100 : 50) );
		iframe.setAttribute('height', (compact == true ? 17 : 60) );
		iframe.setAttribute('frameBorder', 0);
		iframe.setAttribute('scrolling', 'no');
		iframe.setAttribute('border', 0);
		iframe.setAttribute('marginHeight', 0);
		iframe.setAttribute('marginWidth', 0);
		iframe.setAttribute('marginHeight', 0);
		iframe.setAttribute('allowTransparency', 'true');

		return iframe;
	},

	getParam: function (key, defaultValue)
	{
	    if (!this.queryString) {
	        return defaultValue;
	    }

	    var params = this.queryString.split("&");
	    for (var i = 0; i < params.length; i++)
	    {
	        var pairs = params[i].split("=");
	        if(pairs[0] == key)
	        {
	            return pairs[1];
	        }
	    }

	    return defaultValue;
	},

	init: function() {
		
		var scripts = document.getElementsByTagName("script");
		this.instance = scripts[ scripts.length - 1 ];
		
		var src = this.instance.getAttribute('src');
		var re = new RegExp('^(?:f|ht)tp(?:s)?\://([^/]+)', 'im');
		//this.apiDomain = src.match(re)[1].toString();

		var pos = src.indexOf('?');
		if (pos) {
			var qs = src.substring(++pos);
			this.queryString = qs;
		}
		
		switch(this.getParam('mode', 'direct')) {
			case 'direct':
			default:
				this.render();
		}

	},

	render: function() {

		var data = this.assembleDataString();

		switch(this.getParam('im', 'default')) {
			case 'replace':
					this.replaceWith(this.instance, this.createIframe(data, this.useCompact));
				break;
			default:
				this.instance.parentNode.insertBefore(this.createIframe(data, this.useCompact), this.instance);
		}
	},

	replaceWith: function (old, content)
	{
		if (typeof content == 'string') {

			if ('outerHTML' in document.documentElement)
			{
				old.outerHTML = content;
			}
			else
			{
				var range = document.createRange();
				range.selectNode(old);
				content = range.createContextualFragment(content);

				old.parentNode.replaceChild(content, old);
			}
		}

		old.parentNode.replaceChild(content, old);
	}
};
FlattrButton.init();
