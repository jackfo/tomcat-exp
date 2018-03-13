document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\""+CONTEXT_PATH+"/js/bgshade/style.css\">");
/**
 * 描述：jQuery插件，自动在容器中创建背景遮罩及进度条
 * 参数：boolean类型	显示或销毁背景遮罩及进度条		默认“true”——显示
 * 		string类型	进度条中显示的文本，支持HTML		默认“Loading...”
 * 用法：$(document.body).bgshade("导入中...")		在body中显示，进度条中显示“导入中...”
 * 		$(document.body).bgshade(false);		隐藏body中的背景遮罩和进度条
 * 作者：饶飞成
 * 日期：2011-08-29
 * 版本：1.0.0
 */
(function($){
	$.fn.bgshade = function(){
		var _t = "Loading...";
		var _b = true;
		//从隐藏参数中读取参数并按类型进行匹配
		for(var i=0,_l=arguments.length;i<_l&&_l<3;i++){
			var obj = arguments[i];
			if(typeof(obj) == "string"){
				_t = obj;
			}else if(typeof(obj) == "boolean"){
				_b = obj;
			}
		}
		$(this).each(function(){
			//销毁背景遮罩及进度条
			if(!_b){
				var random = $(this).attr('bgShadeRandom');
				var bgId = 'bg_id_'+random;
				var imgId = 'img_id_'+random;
				$(this).find('.'+bgId).remove();
				$(this).find('.'+imgId).remove();
			//显示背景遮罩及进度条
			}else{
				var random = Math.floor(Math.random()*10000+1);
				var bgId = 'bg_id_'+random;
				var imgId = 'img_id_'+random;
				$(this).append('<div class="'+bgId+' bgShade_bgDiv">&nbsp;</div><div class="'+imgId+' bgShade_loadingImg">'+_t+'</div>')
					.attr('bgShadeRandom',random).find('.'+bgId).css({opacity:0.5,width:$(this).innerWidth()});
				//让背景遮罩高度全部占有
				$('.bgShade_bgDiv').height(this.offsetHeight);
			}
		});
	}
})(jQuery);