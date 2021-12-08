<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" +
request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>" />
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function (){
			showDicTypeList();
			$("#qx").click(function (){
				$("input[name=xz]").prop("checked",this.checked)
			})
			$("#dicBody").on("click",$("input[name=xz]"),function (){
				$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
			})
			$("#editBtn").click(function (){
				var $xz = $("input[name=xz]:checked");
				if($xz.length !=1 ){
					alert("请选择一条需要修改的数据")
				}else {
					//onclick="window.location.href='settings/dictionary/type/edit.jsp'"
					window.location.href='settings/dictionary/type/edit.do?code='+$xz.val();
				}
			})
			$("#deleteBtn").click(function (){
				var $xz = $("input[name=xz]:checked");
				if($xz.length == 0){
					alert("请选择!")
				}else {if(confirm("确认删除此条数据么")){
					var param = "";
					for (let i = 0; i < $xz.length; i++) {
						param += "code=" + $xz[i].value;
						if(	i < $xz.length - 1){
							param += "&";
						}
					}
					$.ajax({
						url:"settings/dictionary/type/delete.do",
						data:param,
						type:"post",
						dataType:"json",
						success:function (data){
							if(data){
								showDicTypeList()
							}else {
								alert("删除失败")
							}

						}


					})
				}

				}
			})
		})
		function showDicTypeList(){
			$.ajax({
				url:"settings/user/getDicTypeList.do",
				type:"get",
				dataType:"json",
				success:function (data){
					var html = "";
					$.each(data,function (i,n){
						html += '<tr><td><input type="checkbox" name="xz" value="'+n.code+'"/></td>';
						html += '<td>'+n.code+'</td>';
						html += '<td>'+n.name+'</td>';
						html += '<td>'+n.description+'</td></tr>';
					})
					$("#dicBody").html(html);
				}


			})
		}
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" id="editBtn" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" id="deleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"/></td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="dicBody">


			</tbody>
		</table>
	</div>
	
</body>
</html>