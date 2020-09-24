<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div class="container" id="userDetailDiv">
</div>


<script type="text/javascript">
	
	$(function(){
		$.ajax({
			url : '${Config.basePath}userinfo/${param.id}',
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var $userDetailDiv = $("#userDetailDiv");
				/**
				<div class="row">
					<label class="col-md-offset-2 col-md-2">用户名：</label>
					<span class="col-md-8">xxx</span>
				</div>
				*/
				$userName = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">用户名：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.userName||'')+'</span>'
						   +'</div>';
						   
				$mobile = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">手机号：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.mobile||'')+'</span>'
						   +'</div>';
					
				var userTypeName;
				if(data.userType == '0')
					userTypeName = '普通用户';
				else if(data.userType == '1')
					userTypeName = '普通会员';
				else if(data.userType == '2')
					userTypeName = '高级会员';
						   
				$userType = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">用户类型：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(userTypeName||'')+'</span>'
						   +'</div>';
						   
				$sex = 		'<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">性别：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.sex||'')+'</span>'
						   +'</div>';
						   
				$age = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">年龄：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.age||'')+'</span>'
						   +'</div>';
						   
				$onlineTime = '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">在线时间：</label>'
						     +'<span class="col-md-8 col-sm-8">'+(data.onlineTime||'')+'</span>'
						     +'</div>';
						     
				$height =     '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">身高：</label>'
						     +'<span class="col-md-8 col-sm-8">'+(data.height||'')+'</span>'
						     +'</div>';
						     
				$introduction =   '<div class="row">'
							   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">介绍：</label>'
							     +'<span class="col-md-8 col-sm-8">'+(data.introduction||'')+'</span>'
							     +'</div>';
							     
				$userDetailDiv.append($userName);
				$userDetailDiv.append($mobile);
				$userDetailDiv.append($userType);
				$userDetailDiv.append($sex);
				$userDetailDiv.append($age);
				$userDetailDiv.append($onlineTime);
				$userDetailDiv.append($height);
				$userDetailDiv.append($introduction);
				
			},
			error : function(xhr) {
				alert("保存失败");
			}
		});
	});
	
</script>
