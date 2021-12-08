<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		// 动态更新出来两个按钮
		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		});
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		// 全选框
		$("#qx").on("click",function () {
			$("input[name=xz]").prop("checked",this.checked);
		});
		// 打开页面的时候刷新市场活动列表
		showActivity();
		showRemarkList();
		$("#getActivities").keydown(function (e){
			if(e.keyCode==13){
				$.ajax({
					url:"workbench/clue/getAcByNameAndNotBund.do",
					data:{
						"name":$.trim($("#getActivities").val()),
						"clueId":"${clue.id}"
					},
					type:"get",
					dataType:"json",
					success:function (data){
						var html = "";
						$.each(data,function (i,n){
							html+='<tr>';
							html+='	<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
							html+='	<td>'+n.name+'</td>';
							html+='	<td>'+n.startDate+'</td>';
							html+='	<td>'+n.endDate+'</td>';
							html+='	<td>'+n.owner+'</td>';
							html+='</tr>';
						})
						$("#searchAcBody").html(html);
					}


				});
				// 阻止关闭该模态窗口
				return false;
			}
		})
		$("#saveBtn").click(function (){
			var $xz = $("input[name=xz]:checked");
			if($xz.length!=0){
				var param = "clueId=${clue.id}&";
				for (var i = 0; i < $xz.length; i++) {
					param += "id=" + $xz[i].value;
					if(i < $xz.length - 1){
						param += "&";
					}
				}
				$.ajax({
					url:"workbench/clue/bundActivityByAcIds.do",
					data:param,
					type:"post",
					dataType:"json",
					success:function (data){
						if(data){
							$("#searchAcBody").html("");
							$("#bundModal").modal("hide");
							$("#getActivities").val("");
							$("#qx").prop("checked",false);
							showActivity();

						}else {
							alert("关联失败")
						}
					}


				})
			}else {
				alert("请选择!")
			}

		})
		$("#edit-btn").click(function (){
			$.ajax({
				url:"workbench/clue/getClueById.do",
				data:{
					"id":"${clue.id}"
				},
				type:"get",
				dataType:"json",
				success:function (data){
					var html = "<option></option>";

					// 下拉框赋值 每一个option中的value赋值为该对应用户的id
					$.each(data.userList , function (index,element) {
						// 当前活动的所有着 为下列列表的开头
						//alert(element.name);
						html += "<option value='"+element.id+"' id='"+element.id+"' >"+element.name+"</option>";
					});
					$("#edit-owner").html(html);
					$("#edit-owner").val(data.clue.owner);
					// 给所有文本栏赋值
					$("#edit-company").val(data.clue.company);
					$("#edit-fullname").val(data.clue.fullname);
					$("#edit-appellation").val(data.clue.appellation);
					$("#edit-email").val(data.clue.email);
					$("#edit-phone").val(data.clue.phone);
					$("#edit-website").val(data.clue.website);
					$("#edit-mphone").val(data.clue.mphone);
					$("#edit-job").val(data.clue.job);
					$("#edit-state").val(data.clue.state);
					$("#edit-source").val(data.clue.source);
					$("#edit-description").val(data.clue.description);
					$("#edit-contactSummary").val(data.clue.contactSummary);
					$("#edit-nextContactTime").val(data.clue.nextContactTime);
					$("#edit-address").val(data.clue.address);

					// 隐藏域中保存id
					$("#edit-id").val(data.clue.id);
					$("#editClueModal").modal("show")
				}


			})
		})
		$("#updateBtn").click(function (){
			$.ajax({
				url:"workbench/clue/update.do",
				data:{
					"id" : $("#edit-id").val(),
					"fullname":$.trim($("#edit-fullname").val()),
					"appellation":$.trim($("#edit-appellation").val()),
					"owner":$.trim($("#edit-owner").val()),
					"company":$.trim($("#edit-company").val()),
					"job":$.trim($("#edit-job").val()),
					"email":$.trim($("#edit-email").val()),
					"phone":$.trim($("#edit-phone").val()),
					"website":$.trim($("#edit-website").val()),
					"mphone":$.trim($("#edit-mphone").val()),
					"state":$.trim($("#edit-state").val()),
					"source":$.trim($("#edit-source").val()),
					"editBy":"${sessionScope.user.name}",
					"description":$.trim($("#edit-description").val()),
					"contactSummary":$.trim($("#edit-contactSummary").val()),
					"nextContactTime":$.trim($("#edit-nextContactTime").val()),
					"address":$.trim($("#edit-address").val())
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data){
						//${requestScope.clue.fullname}${clue.appellation} +'<small>'+$("#edit-company").val()+'</small>'
						$("#top-info").html($("#edit-fullname").val()+$("#edit-appellation").val()+'<small>'+$("#edit-company").val()+'</small>')
						//$("#name").html($("#edit-owner").val());
						$("#owner").html($('#edit-owner').find('option:selected').text());
						$("#fullname").html($("#edit-fullname").val());
						$("#appellation").html($("#edit-appellation").val());
						$("#company").html($("#edit-company").val());
						$("#job").html($("#edit-job").val());
						$("#email").html($("#edit-email").val());
						$("#phone").html($("#edit-phone").val());
						$("#website").html($("#edit-website").val());
						$("#mphone").html($("#edit-mphone").val());
						$("#state").html($("#edit-state").val());
						$("#source").html($("#edit-source").val());
						$("#editBy").html($("#edit-editBy").val());
						$("#description").html($("#edit-description").val());
						$("#contactSummary").html($("#edit-contactSummary").val());
						$("#nextContactTime").html($("#edit-nextContactTime").val());
						$("#address").html($("#edit-address").val());

						$("#editClueModal").modal("hide")


					}else {
						alert("修改失败")
					}
				}


			})
		})
		$("#delete-btn").click(function (){
			if(confirm("确定删除吗")){
				var param = 'id='+"${clue.id}";
				$.ajax({
					url:"workbench/clue/delete.do",
					data:param,
					type:"post",
					dataType:"json",
					success:function (data){
						if(data){
							//pageList( 1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							document.location.href = "workbench/clue/index.jsp"
						}else {
							alert("删除失败")
						}
					}
				})
			}

		})
		$("#addRemarkBtn").click(function (){
			$.ajax({
				url:"workbench/clue/addRemark.do",
				data:{
					"noteContent":$("#remark").val(),
					"clueId":"${clue.id}",
					"createBy":"${user.name}"
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data.success){
						// 拿到回传的备注之后进行标签拼接
						var html = "";
						html +=  '<div id="'+data.ClueRemark.id+'" class="remarkDiv" style="height: 60px;">';
						html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
						html += '<div style="position: relative; top: -40px; left: 40px;" >';
						html += '<h5 id="e'+data.ClueRemark.id+'">'+data.ClueRemark.noteContent+'</h5>';
						html += '<font color="gray">潜在客户-</font> <b>${ClueRemark.name}</b> <small style="color: gray;">'+data.ClueRemark.createTime+' 由'+data.ClueRemark.createBy+'</small>';
						html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
						html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ClueRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '&nbsp;&nbsp;&nbsp;&nbsp;';
						html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ClueRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
						html += '</div>';
						html += '</div>';
						html += '</div>';

						// 将拼接完成的标签插入
						$("#remarkDiv").before(html);

						//清空文本栏
						$("#remark").val("");

					}else{
						alert("添加失败")
					}
				}


			})
		})
		$("#updateRemarkBtn").click(function (){
			var id = $("#remarkId").val();
			$.ajax({
				url:"workbench/clue/updateRemark.do",
				data:{
					"id":id,
					"noteContent":$("#noteContent").val(),
					"editBy":"${sessionScope.user.name}"
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data.success){
						$("#e"+id).html(data.cr.noteContent);
						$("#s"+id).html(data.cr.editTime+" 由"+data.cr.editBy);
						$("#editRemarkModal").modal("hide");
					}else {
						alert("修改失败")
					}
				}


			})
		})

	});
		function showActivity(){
			$.ajax({
				url:"workbench/clue/showActivityByClueId.do",
				data:{
					"id":"${clue.id}"
				},
				type:"get",
				dataType:"json",
				success:function (data){
					var html = "";
					$.each(data,function (i,n){
						html+='<tr id="'+n.id+'">';
						html+='	<td>'+n.name+'</td>';
						html+='	<td>'+n.startDate+'</td>';
						html+='	<td>'+n.endDate+'</td>';
						html+='	<td>'+n.owner+'</td>';
						html+='	<td><a href="javascript:void(0);" onclick="unbund(\''+n.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
						html+='</tr>';
					})
					$("#activityBody").html(html);
				}


			});

		}
		function unbund(id){
			$.ajax({
				url:"workbench/clue/unbund.do",
				data:{
					"id":id
				},
				type:"post",
				dataType:"json",
				success:function (data){
					if(data){
						showActivity();
					}else {
						alert("解除失败")
					}
				}


			})
		}
	function showRemarkList(){
		$.ajax({
			url:"workbench/clue/getRemarkList.do",
			data:{
				"clueId":"${clue.id}"
			},
			type:"get",
			dataType:"json",
			success:function (data){
				var html = '';
				$.each(data,function (i,n){
					html+='<div id='+n.id+' class="remarkDiv" style="height: 60px;">';
					html+='	<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='	<div style="position: relative; top: -40px; left: 40px;" >';
					html+='		<h5 id="e'+n.id+'">'+n.noteContent+' </h5>';
					html+='		<font color="gray">潜在客户</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==1?n.editTime:n.createTime)+' 由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
					html+='		<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='			<a class="myHref" onclick="editRemark(\''+n.id+'\')" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: pink;"></span></a>';
					html+='			&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='			<a class="myHref" onclick="deleteRemark(\''+n.id+'\')" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: pink;"></span></a>';
					html+='		</div>';
					html+='	</div>';
					html+='</div>';
				})
				$("#remarkDiv").before(html);
			}


		})
	}
	function editRemark(id){
		// 保存id值
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).text());
		// 展示模态窗口
		$("#editRemarkModal").modal("show");
	}

	function deleteRemark(id){
		$.ajax({
			url:"workbench/clue/deleteRemark.do",
			data:{
				"id":id
			},
			type:"post",
			dataType:"json",
			success:function (data){
				if(data){
					$("#"+id).remove()
				}else {
					alert("删除失败")
				}
			}


		})
	}
</script>

</head>
<body>
	<!-- 修改市场备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="getActivities" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="searchAcBody">

						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveBtn">关联</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 修改线索的模态窗口 -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id" />

                        <div class="form-group">
                            <label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-company" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-call" class="col-sm-2 control-label">称呼</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-appellation">
									<c:forEach items="${applicationScope.appellation}" var="value" >
										<option value="${value.value}">${value.text}</option>
									</c:forEach>
                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-fullname" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-job" class="col-sm-2 control-label">职位</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-job" >
                            </div>
                            <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-email" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone" >
                            </div>
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-mphone" >
                            </div>
                            <label for="edit-status" class="col-sm-2 control-label">线索状态</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-state">
										<c:forEach items="${applicationScope.clueState}" var="value" >
											<option value="${value.value}">${value.text}</option>
										</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source">
									<c:forEach items="${applicationScope.source}" var="value" >
										<option value="${value.value}">${value.text}</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-description"></textarea>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime" >
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" id="updateBtn">更新</button>
                </div>
            </div>
        </div>
    </div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3 id="top-info">${requestScope.clue.fullname}${clue.appellation} <small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/gotoconvert.do?id=${clue.id}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" class="btn btn-default" id="edit-btn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="delete-btn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="fullname">${requestScope.clue.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="owner">${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="company">${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="job">${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="phone">${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="phone">${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="website">${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="mphone">${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="state">${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="source">${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="createBy">${clue.createBy}&nbsp;&nbsp;</b id="createTime"><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${clue.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="contactSummary">
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="nextContactTime">${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b id="address">
					${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" id="addRemarkBtn" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>