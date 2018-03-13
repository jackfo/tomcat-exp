// function csrfSafeMethod(method) {
//     // these HTTP methods do not require CSRF protection
//     return (/^(GET|HEAD|OPTIONS|TRACE)$/.test(method));
// }
// function sameOrigin(url) {
//     // test that a given url is a same-origin URL
//     // url could be relative or scheme relative or absolute
//     var host = document.location.host; // host + port
//     var protocol = document.location.protocol;
//     var sr_origin = '//' + host;
//     var origin = protocol + sr_origin;
//     // Allow absolute or scheme relative URLs to same origin
//     return (url == origin || url.slice(0, origin.length + 1) == origin + '/') ||
//         (url == sr_origin || url.slice(0, sr_origin.length + 1) == sr_origin + '/') ||
//         // or any other URL that isn't scheme relative or absolute i.e relative.
//         !(/^(\/\/|http:|https:).*/.test(url));
// }
// $.ajaxSetup({
//     beforeSend: function(xhr, settings) {
//         if (!csrfSafeMethod(settings.type) && sameOrigin(settings.url)) {
//             // Send the token to same-origin, relative URLs only.
//             // Send the token only if the method warrants CSRF protection
//             // Using the CSRFToken value acquired earlier
//             var csrftoken = $.cookie('csrftoken');
//             xhr.setRequestHeader("X-CSRFToken", csrftoken);
//         }
//     }
// });

function getContextPath() {
	var pathName = document.location.pathname;
	var index = pathName.substr(1).indexOf("/");
	var result = pathName.substr(0, index + 1);
	return result;
}


function GetQueryString(name)
{
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
    var r = window.location.search.substr(1).match(reg);
    if(r!=null)return  unescape(r[2]); return null;
}

jQuery(function($) {

	var error = GetQueryString("error");
	if("-1"==error){
        $("#loginTip").html("登录失败");
	}else if("0"==error){
        $("#loginTip").html("服务器错误");
	}

	$(document).on('click', '.toolbar a[data-target]', function(e) {
		e.preventDefault();
		var target = $(this).data('target');
		$('.widget-box.visible').removeClass('visible');// hide others
		$(target).addClass('visible');// show target
	});

	// 登录页面切换背景图
	$('#btn-login-dark').on('click', function(e) {
		$('body').attr('class', 'login-layout');
		e.preventDefault();
	});
	$('#btn-login-light').on('click', function(e) {
		$('body').attr('class', 'login-layout light-login');
		e.preventDefault();
	});
	$('#btn-login-blur').on('click', function(e) {
		$('body').attr('class', 'login-layout blur-login');
		e.preventDefault();
	});

	// 验证找回密码表单
	$("#retrieveButton").bind("click", function() {
		$('#validationRetrieveForm').submit();
	});
	$('#validationRetrieveForm').validate({
		errorElement : 'div',
		errorClass : 'help-block',
		focusInvalid : false,
		ignore : "",
		rules : {
			email : {
				required : true,
				email : true
			}
		},
		messages : {
			email : {
				required : "请填写邮箱",
				email : "请填写正确的邮箱"
			}
		},
		highlight : function(e) {
			$(e).closest('label').removeClass('has-info').addClass('has-error');
		},
		success : function(e) {
			$(e).closest('label').removeClass('has-error');// .addClass('has-info');
			$(e).remove();
		},
		errorPlacement : function(error, element) {
			error.insertAfter(element.parent());
		},
		submitHandler : function(form) {
			$.ajax({
				dataType : "json",
				url : getContextPath() + "/sys/sysuser/retrievePassword",
				type : "post",
				data : {
					email : $('#retrieveEmail').val()
				},
				complete : function(xmlRequest) {
					var returninfo = eval("(" + xmlRequest.responseText + ")");
					if (returninfo.result == 1) {
						$("#retrieveTip").html("找回密码邮件已经发到你的邮箱");
					} else if (returninfo.result == -1) {
						$("#retrieveTip").html("密保邮箱不存在，请重新输入");
					}
				}
			});
		},
		invalidHandler : function(form) {
		}
	});

	// 按回车键触发登录事件
	$(document).keydown(function(event) {
		var key = window.event ? event.keyCode : event.which;
		if (key == 13) {
			$('#validationLoginForm').submit();
		}
	});

	// 验证登录表单
	$("#loginButton").bind("click", function() {
		$('#validationLoginForm').submit();
	});
    // var token = $("meta[name='_csrf']").attr("content");
    // var header = $("meta[name='_csrf_header']").attr("content");
    // $(document).ajaxSend(function(e, xhr, options) {
    //     xhr.setRequestHeader(header, token);
    // });
	$('#validationLoginForm').validate({
		errorElement : 'div',
		errorClass : 'help-block',
		focusInvalid : false,
		ignore : "",
		rules : {
			userLoginId : {
				required : true
			},
			password : {
				required : true,
				minlength : 5,
				maxlength : 14
			}
		},
		messages : {
			userLoginId : {
				required : "请填写账号"
			},
			password : {
				required : "请输入密码",
				minlength : "密码长度至少为5个字符",
				maxlength : "密码长度至多为14个字符"
			}
		},
		highlight : function(e) {
			$(e).closest('label').removeClass('has-info').addClass('has-error');
		},
		success : function(e) {
			$(e).closest('label').removeClass('has-error');// .addClass('has-info');
			$(e).remove();
		},
		errorPlacement : function(error, element) {
			error.insertAfter(element.parent());
			//error.appendTo('#invalid');
		},
		submitHandler : function(form) {
            $.ajax({
                type: 'POST',
                url: "loginProcess",
                dataType: "json",
                data : {
                    userLoginId : $('#loginUserLogin').val(),
                    password : $('#loginPassword').val(),
                    rememberMe : $("input[name='rememberMe']:checked").val()
                },
                complete: function (xmlRequest) {
                	var status = xmlRequest.status;
                	if(200!=status){
                        $("#loginTip").html("服务器错误");
                        return ;
					}
					var data = xmlRequest.responseJSON;
					if (data.code == 1) {
                    	document.location.href = getContextPath() + "/index";
                    } else if (data.code == -1) {
						$("#loginTip").html(data.data);
                    }  else {
						$("#loginTip").html("服务器错误");
					}
                }
            });
		},
		invalidHandler : function(form) {
		}
	});

	$('[data-rel=tooltip]').tooltip({
		container : 'body'
	});
	
	$('#birthday').datepicker({
	    format: 'yyyy-mm-dd',
	    language: 'zh-CN'
	});

	// 验证注册表单
	$("#registerButton").bind("click", function() {
		$('#validationRegisterForm').submit();
	});
	$('#validationRegisterForm').validate({
		errorElement : 'div',
		errorClass : 'help-block',
		focusInvalid : false,
		ignore : "",
		rules : {
			userName : {
				required : true,
				maxlength : 40
			},
			sex : {
				required : true
			},
			email : {
				required : true,
				email : true,
				maxlength : 30
			},
			phone : {
				required : false,
				maxlength : 20
			},
			birthday : {
				required : false
			},
			password : {
				required : true,
				minlength : 6,
				maxlength : 14
			},
			repeatPassword : {
				required : true,
				minlength : 6,
				maxlength : 14,
				equalTo : "#password"
			},
			agree : {
				required : true,
			}
		},
		messages : {
			userName : {
				required : "请填写姓名",
				maxlength : "姓名长度至多为40个字符"
			},
			sex : "请选择性别",
			email : {
				required : "请填写邮箱",
				email : "请填写正确的邮箱",
				maxlength : "邮箱长度至多为30个字符"
			},
			phone : {
				required : "请填写联系电话",
				maxlength : "联系电话长度至多为20个字符"
			},
			password : {
				required : "请输入密码",
				minlength : "密码长度至少为6个字符",
				maxlength : "密码长度至多为14个字符"
			},
			repeatPassword : {
				required : "请输入确认密码",
				minlength : "确认密码长度至少为6个字符",
				maxlength : "确认密码长度至多为14个字符",
				equalTo : "密码和确认密码不一致"
			},
			agree : "您还未接受用户协议"
		},
		highlight : function(e) {
			$(e).closest('label').removeClass('has-info').addClass('has-error');
		},
		success : function(e) {
			$(e).closest('label').removeClass('has-error');// .addClass('has-info');
			$(e).remove();
		},
		errorPlacement : function(error, element) {
			error.insertAfter(element.parent());
		},
		submitHandler : function(form) {
			$.ajax({
				dataType : "json",
				url : getContextPath() + "/sys/sysuser/register",
				type : "post",
				data : {
					userName : $('#userName').val(),
					sex : $("input[name='sex']:checked").val(),
					email : $('#email').val(),
					phone : $('#phone').val(),
					birthday : $('#birthday').val(),
					password : $('#password').val()
				},
				complete : function(xmlRequest) {
					var returninfo = eval("(" + xmlRequest.responseText + ")");
					if (returninfo.result == 1) {
						document.location.href = getContextPath() + "/sys/sysuser/home";
					} else if (returninfo.result == -1) {
						$("#registerTip").html("此邮箱已被注册");
					} else {
						$("#registerTip").html("服务器错误");
					}
				}
			});
		},
		invalidHandler : function(form) {
		}
	});
});
