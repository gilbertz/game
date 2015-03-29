var _config = {
	color: {
		allTime: 30,
		addTime: 0,
		lvMap: [2, 3, 4, 5, 5, 6, 6, 7, 7, 7, 8, 8, 8, 8, 8, 8, 9]
	},
	pic: {
		isOpen: !1,
		allTime: 5,
		addTime: 0,
		lvMap: [2, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8]
	}
},
	shareData = {
		imgUrl: "http://html5.boyaa.com/mini/find/assets/img/find.logo.png",
		timeLineLink: "http://51self.com/weitest/800757032",
		tTitle: "\u942a\u5b29\u7d98\u93c8\u590a\ue63f\u9479\u8be7\u7d35",
		tContent: "\u93b5\u60e7\u56ad\u93b5\u20ac\u93c8\u590e\u58ca\u9367\u693e\u8151\u68f0\u6ec6\u58ca\u6d93\u5d85\u6093\u9428\u52ea\u7af4\u9367\u693c\u20ac\u509a\u578e\u6d5c\ue0a3\u6e45\u9359\u5b2a\u6e40\u951b\u5c7e\u58d8\u9352\u62cc\u97e9\u6748\u572d\u6b91\u9479\u67e5\u74df"
	};
!
function() {
	var e = $("#box"),
		f = $("#room .lv em"),
		d = $("#room .time"),
		a = $("#dialog .btn-restart"),
		c = $("#dialog .btn-back"),
		b = $("#dialog .btn-share"),
		m = $("#room .btn-pause"),
		n = $("#dialog .btn-resume"),
		h = $("#dialog"),
		p = $("#dialog .content"),
		q = $("#dialog .pause"),
		k = $("#dialog .gameover"),
		l = {
			init: function(a, b, c) {
				this.type = a;
				this.api = API[a];
				this.config = _config[a];
				this.reset();
				this.parent = c;
				this.el = b;
				this.renderUI();
				this.inited || this.initEvent();
				this.inited = !0;
				this.start()
			},
			renderUI: function() {
				var a = 90 == window.orientation || -90 == window.orientation ? window.innerHeight : window.innerWidth,
					a = Math.min(a - 20, 500);
				e.width(a).height(a);
				this.el.show()
			},
			initEvent: function() {
				var g = "ontouchstart" in document.documentElement ? "touchend" : "click",
					d = this;
				$(window).resize(function() {
					l.renderUI()
				});
				e.on(g, "span", function() {
					"a" == $(this).data("type") && d.nextLv.call(d)
				});
				m.on(g, _.bind(this.pause, this));
				n.on(g, _.bind(this.resume, this));
				a.on(g, _.bind(this.start, this));
				c.on(g, _.bind(this.back, this));
				b.on(g, _.bind(this.share, this))
			},
			start: function() {
				5 < this.time && d.removeClass("danger");
				h.hide();
				this._pause = !1;
				this.lv = "undefined" != typeof this.lv ? this.lv + 1 : 0;
				this.lvMap = this.config.lvMap[this.lv] || _.last(this.config.lvMap);
				this.renderMap();
				this.renderInfo();
				this.timer || (this.timer = setInterval(_.bind(this.tick, this), 1E3))
			},
			share: function() {},
			resume: function() {
				h.hide();
				this._pause = !1
			},
			pause: function() {
				this._pause = !0;
				p.hide();
				q.show();
				h.show()
			},
			tick: function() {
				return this._pause ? void 0 : (this.time--, 6 > this.time && d.addClass("danger"), 0 > this.time ? void this.gameOver() : void d.text(parseInt(this.time)))
			},
			renderMap: function() {
				if (!this._pause) {
					var a = "",
						b = "lv" + this.lvMap;
					_(this.lvMap * this.lvMap).times(function() {
						a += "<span></span>"
					});
					e.attr("class", b).html(a);
					this.api.render(this.lvMap, this.lv)
				}
			},
			renderInfo: function() {
				f.text(this.lv + 1)
			},
			gameOver: function() {
				try {
					WeixinJSBridge.call("showOptionMenu")
				} catch (a) {}
				var b = this.api.getGameOverText(this.lv);
				this.lastLv = this.lv;
				this.lastGameTxt = b.txt;
				this.lastGamePercent = b.percent;
				p.hide();
				k.show().find("h3").text(this.lastGameTxt);
				e.find("span").fadeOut(1E3, function() {
					h.fadeIn()
				});
                //var info = "\u93b4\u6226\u68f7\u6769\ufffd" + (Game.lastLv + 1) + "\u934f\u7b79\u7d1d\u9351\u660f\u89e6" + Game.lastGamePercent + "%\u9428\u52ea\u6c49\u951b\u4f79\u579c\u93c4\ue218\u20ac\ufffd" + Game.lastGameTxt + "\u9286\u622f\u7d12\u6d93\u5d86\u6e47\u93c9\u30e6\u57ac\u951b\ufffd";
                                var info = "我闯过了" + (Game.lastLv + 1) + "关，击败" + Game.lastGamePercent + "%的人！我是" + Game.lastGameTxt + "】！不服来战";
                                $('#info').text(info); 
				share_api();
								 
				this._pause = !0;
				this.reset()
			},
			reset: function() {
				this.time = this.config.allTime;
				this.lv = -1
			},
			nextLv: function() {
				this.time += this.config.addTime;
				d.text(parseInt(this.time));
				this._pause || this.start()
			},
			back: function() {
				this._pause = !0;
				this.el.hide();
				h.hide();
				this.parent.render()
			}
		};
	window.Game = l
}();
(function(e) {
	var f = $("#index"),
		d = $("#room"),
		a = $("#loading");
	$("#dialog");
	var c = $(".play-btn"),
		b = {
			init: function() {
				this.initEvent();
				this.loading()
			},
			loading: function() {
				function a() {
					f++;
					f == e && b.render()
				}
				function c() {}
				if (_config.pic.isOpen) for (var d = "assets/img/1.png assets/img/2.png assets/img/3.png assets/img/4.png assets/img/5.png assets/img/6.png assets/img/7.png assets/img/8.png assets/img/9.png assets/img/10.png assets/img/11.png assets/img/12.png assets/img/13.png assets/img/14.png assets/img/15.png assets/img/16.png assets/img/17.png assets/img/18.png".split(" "), e = d.length, f = 0, k = 0; e > k; k++) {
					var l = new Image;
					l.onload = a;
					l.src = d[k]
				} else b.render();
				document.addEventListener("WeixinJSBridgeReady", function() {
					WeixinJSBridge && (WeixinJSBridge.on("menu:share:appmessage", function() {
						WeixinJSBridge.invoke("sendAppMessage", {
							img_url: shareData.imgUrl,
							link: shareData.timeLineLink,
							desc: shareData.tContent,
							title: 0 < Game.lastLv ? "\u93b4\u6226\u68f7\u6769\ufffd" + (Game.lastLv + 1) + "\u934f\u7b79\u7d1d\u9351\u660f\u89e6" + Game.lastGamePercent + "%\u9428\u52ea\u6c49\u951b\u4f79\u579c\u93c4\ue218\u20ac\ufffd" + Game.lastGameTxt + "\u9286\u622f\u7d12\u6d93\u5d86\u6e47\u93c9\u30e6\u57ac\u951b\ufffd" : shareData.tTitle
						}, c)
					}), WeixinJSBridge.on("menu:share:timeline", function() {
						WeixinJSBridge.invoke("shareTimeline", {
							img_url: shareData.imgUrl,
							img_width: "640",
							img_height: "640",
							link: shareData.timeLineLink,
							desc: shareData.tContent,
							title: 0 < Game.lastLv ? "\u93b4\u6226\u68f7\u6769\ufffd" + (Game.lastLv + 1) + "\u934f\u7b79\u7d1d\u9351\u660f\u89e6" + Game.lastGamePercent + "%\u9428\u52ea\u6c49\u951b\u4f79\u579c\u93c4\ue218\u20ac\ufffd" + Game.lastGameTxt + "\u9286\u622f\u7d12\u6d93\u5d86\u6e47\u93c9\u30e6\u57ac\u951b\ufffd" : shareData.tTitle
						}, c)
					}))
				}, !1)
			},
			render: function() {
				a.hide();
				f.show()
			},
			initEvent: function() {
				var a = this;
				c.on("ontouchstart" in document.documentElement ? "touchstart" : "click", function() {
					var b = $(this).data("type") || "color";
					f.hide();
					Game.init(b, d, a)
				})
			}
		};
	b.init();
	e.API = {}
})(window);
(function() {
	var e = $("#box"),
		f = $("#help p"),
		d = $("#help_color");
	API.color = {
                lvT: ["瞎子", "色盲", "色郎", "色狼", "色鬼", "色魔", "超级色魔", "变态色魿", "孤独求色"],
		render: function(a, c) {
			this.lv = c;
			f.hide();
			d.show();
			var b = _config.color.lvMap[c] || _.last(_config.color.lvMap);
			this.d = 15 * Math.max(9 - b, 1);
			this.d = 20 < c ? 10 : this.d;
			this.d = 40 < c ? 8 : this.d;
			this.d = 50 < c ? 5 : this.d;
			var b = Math.floor(Math.random() * a * a),
				m = this.getColor(255 - this.d),
				n = this.getLvColor(m[0]);
			e.find("span").css("background-color", m[1]).data("type", "b");
			e.find("span").eq(b).css("background-color", n[1]).data("type", "a")
		},
		getColor: function(a) {
			a = [Math.round(Math.random() * a), Math.round(Math.random() * a), Math.round(Math.random() * a)];
			var c = "rgb(" + a.join(",") + ")";
			return [a, c]
		},
		getLvColor: function(a) {
			var c = this.d;
			a = _.map(a, function(a) {
				return a + c
			});
			var b = "rgb(" + a.join(",") + ")";
			return [a, b]
		},
		getGameOverText: function(a) {
			var c = 15 > a ? 0 : Math.ceil((a - 15) / 5),
				c = (this.lvT[c] || _.last(this.lvT)) + "lv" + (a + 1),
				b = 2 * a;
			return b = 90 < b ? 90 + .15 * a : b, b = Math.min(b, 100), {
				txt: c,
				percent: b
			}
		}
	}
})();
