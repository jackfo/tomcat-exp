/**
 * jQuery EasyUI 1.2.2
 * 
 * Licensed under the GPL:
 *   http://www.gnu.org/licenses/gpl.txt
 *
 * Copyright 2010 stworthy [ stworthy@gmail.com ] 
 * 
 */
(function($) {
	function _1(_2) {
		$(_2).addClass("validatebox-text");
	};
	function _3(_4) {
		var _5 = $.data(_4, "validatebox").tip;
		if (_5) {
			_5.remove();
		}
		$(_4).unbind();
		$(_4).remove();
	};
	function _6(_7) {
		var _8 = $(_7);
		var _9 = $.data(_7, "validatebox");
		_9.validating = false;
		_8.unbind(".validatebox").bind("focus.validatebox",
		function() {
//			_9.validating = true; (function() {
//				if (_9.validating) {
//					_11(_7);
//					//setTimeout(arguments.callee, 200);	//200毫秒执行一次验证
//				}
//			})();
			if(opt&&opt.methodType&&$.fn.validatebox.defaults.methods){
				var _obj=$.fn.validatebox.defaults.methods[opt.methodType];
				if(_obj&&_obj.focus&&typeof(_obj.focus)=="function"){
					_obj.focus(_2e8,opt.methodParam);
				}
			}
			_9.validating = false;
			if (_8.hasClass("validatebox-invalid")) {
				_b(_7);
			}
		}).bind("blur.validatebox",
		function() {
			if(opt&&opt.methodType&&$.fn.validatebox.defaults.methods){
				var _obj=$.fn.validatebox.defaults.methods[opt.methodType];
				if(_obj&&_obj.blur&&typeof(_obj.blur)=="function"){
					_obj.blur(_2e8,opt.methodParam);
				}
			}
			_9.validating = true;
			_11(_7);
			_a(_7);
//			_9.validating = false;
//			_a(_7);
		}).bind("mouseenter.validatebox",
		function() {
			if(opt&&opt.methodType&&$.fn.validatebox.defaults.methods){
				var _obj=$.fn.validatebox.defaults.methods[opt.methodType];
				if(_obj&&_obj.mousemove&&typeof(_obj.mousemove)=="function"){
					_obj.mousemove(_2e8,opt.methodParam);
				}
			}
			if (_8.hasClass("validatebox-invalid")) {
				_b(_7);
			}
		}).bind("mouseleave.validatebox",
		function() {
			if(opt&&opt.methodType&&$.fn.validatebox.defaults.methods){
				var _obj=$.fn.validatebox.defaults.methods[opt.methodType];
				if(_obj&&_obj.mouseout&&typeof(_obj.mouseout)=="function"){
					_obj.mouseout(_2e8,opt.methodParam);
				}
			}
			_a(_7);
		});
	};
	/**
	 * 显示提示框
	 */
	function _b(_c) {
		var _d = $(_c);
		var _e = $.data(_c, "validatebox").message;
		var _f = $.data(_c, "validatebox").tip;
		if (!_f) {
			_f = $("<div class=\"validatebox-tip\">" + "<span class=\"validatebox-tip-content\">" + "</span>" + "<span class=\"validatebox-tip-pointer\">" + "</span>" + "</div>").appendTo("body");
			$.data(_c, "validatebox").tip = _f;
		}
		//动态调整提示框的位置
		var content=_f.find(".validatebox-tip-content").html(msg);
		var x=_d.offset().left+_d.outerWidth();
		if($('body').width()<x+_f.width()){
			var t=_d.offset().left-_f.width();
			if(t>0){
				_f.find('.validatebox-tip-pointer').removeClass('validatebox-tip-pointer').addClass('validatebox-tip-pointer-right');
				content.css({left:'auto',right:9});
				_f.css({display:"block",left:t,top:_d.offset().top});
			}else{
				_f.find('.validatebox-tip-pointer').removeClass('validatebox-tip-pointer').addClass('validatebox-tip-pointer-top');
				content.css({top:9});
				_f.css({display:"block",left:_d.offset().left,top:_d.offset().top+_d.outerHeight()});
			}
		}else _f.css({display:"block",left:x,top:_d.offset().top});
	};
	/**
	 * 移除提示框
	 */
	function _a(_10) {
		var tip = $.data(_10, "validatebox").tip;
		if (tip) {
			tip.remove();
			$.data(_10, "validatebox").tip = null;
		}
	};
	/**
	 * 验证输入
	 */
	function _11(el) {
		var options = $.data(el, "validatebox").options;
		var tip = $.data(el, "validatebox").tip;
		var box = $(el);
		var value = box.val();
		function _15(msg) {
			$.data(el, "validatebox").message = msg;
		};
		var disabled = box.attr("disabled");
		if (disabled == true || disabled == "true") {
			return true;
		}
		if (options.required) {
			if (value == "") {
				box.addClass("validatebox-invalid");
				_15(options.missingMessage);
				_b(el);
				return false;
			}
		}
		if (options.validType) {
			var _17 = /([a-zA-Z_]+)(.*)/.exec(options.validType);//将验证方法及参数分组
			var rule = options.rules[_17[1]];	//获取验证方法
			if (value && rule) {
				var _19 = eval(_17[2]);
				if (!rule["validator"](value, _19, el)) {
					box.addClass("validatebox-invalid");
					var _1a = rule["message"];
					if (_19) {
						for (var i = 0; i < _19.length; i++) {
							_1a = _1a.replace(new RegExp("\\{" + i + "\\}", "g"), _19[i]);
						}
					}
					_15(options.invalidMessage || _1a);
					_b(el);
					return false;
				}
			}
		}
		box.removeClass("validatebox-invalid");
		_a(el);
		return true;
	};
	$.fn.validatebox = function(_1b, _1c) {
		if (typeof _1b == "string") {
			return $.fn.validatebox.methods[_1b](this, _1c);
		}
		_1b = _1b || {};
		return this.each(function() {
			var _1d = $.data(this, "validatebox");
			if (_1d) {
				$.extend(_1d.options, _1b);
			} else {
				_1(this);
				var opt = $.data(this, "validatebox", {
					options: $.extend({},
					$.fn.validatebox.defaults, $.fn.validatebox.parseOptions(this), _1b)
				}).options;
				if(opt&&opt.methodType&&$.fn.validatebox.defaults.methods){		//初始化验证扩展方法
					var _a=/([a-zA-Z_]+)(.*)/.exec(opt.methodType);
					opt.methodType=_a[1];
					opt.methodParam=_a[2];
					var _obj=$.fn.validatebox.defaults.methods[opt.methodType];
					if(_obj&&_obj.init&&typeof(_obj.init)=="function"){
						_obj.init(this,opt.methodParam);
					}
				}
			}
			_6(this);
		});
	};
	$.fn.validatebox.methods = {
		destroy: function(jq) {
			return jq.each(function() {
				_3(this);
			});
		},
		validate: function(jq) {
			return jq.each(function() {
				_11(this);
			});
		},
		isValid: function(jq) {
			return _11(jq[0]);
		}
	};
	$.fn.validatebox.parseOptions = function(_1e) {
		var t = $(_1e);
		return {
			required: (t.attr("required") ? (t.attr("required") == "true" || t.attr("required") == true) : undefined),
			validType: (t.attr("validType") || undefined),
			methodType: (t.attr("methodType") || undefined),	//方法事件扩展
			missingMessage: (t.attr("missingMessage") || undefined),
			invalidMessage: (t.attr("invalidMessage") || undefined)
		};
	};
	$.fn.validatebox.defaults = {
		required: false,
		validType: null,
		missingMessage: "This field is required.",
		invalidMessage: null,
		rules: {
			email: {
				validator: function(_1f) {
					return /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i.test(_1f);
				},
				message: "Please enter a valid email address."
			},
			url: {
				validator: function(_20) {
					return /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(_20);
				},
				message: "Please enter a valid URL."
			},
			length: {
				validator: function(_21, _22) {
					var len = $.trim(_21).length;
					return len >= _22[0] && len <= _22[1];
				},
				message: "Please enter a value between {0} and {1}."
			}
		},
		methods:{
			
		}
	};
})(jQuery);