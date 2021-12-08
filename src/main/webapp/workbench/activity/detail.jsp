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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
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
		showRemarkList();
        // 动态更新出来两个按钮
        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        });
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })
        $("#addRemarkBtn").click(function (){
            $.ajax({
                url:"workbench/activity/addRemark.do",
                data:{
                    "noteContent":$("#remark").val(),
                    "activityId":"${activity.id}",
                    "createBy":"${user.name}"
                },
                type:"post",
                dataType:"json",
                success:function (data){
                    if(data.success){
                        // 拿到回传的备注之后进行标签拼接
                        var html = "";
                        html +=  '<div id="'+data.ActivityRemark.id+'" class="remarkDiv" style="height: 60px;">';
                        html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                        html += '<div style="position: relative; top: -40px; left: 40px;" >';
                        html += '<h5 id="e'+data.ActivityRemark.id+'">'+data.ActivityRemark.noteContent+'</h5>';
                        html += '<font color="gray">市场活动-</font> <b>${requestScope.activity.name}</b> <small style="color: gray;">'+data.ActivityRemark.createTime+' 由'+data.ActivityRemark.createBy+'</small>';
                        html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+data.ActivityRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #FF0000;"></span></a>';
                        html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                        html += '<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+data.ActivityRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #FF0000;"></span></a>';
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
                url:"workbench/activity/updateRemark.do",
                data:{
                    "id":id,
                    "noteContent":$("#noteContent").val(),
                    "editBy":"${user.name}"
                },
                type:"post",
                dataType:"json",
                success:function (data){
                    if(data.success){
                        $("#e"+id).html(data.ar.noteContent);
                        $("#s"+id).html(data.ar.editTime+" 由"+data.ar.editBy);
                        $("#editRemarkModal").modal("hide");
                    }else {
                        alert("修改失败")
                    }
                }


            })
        })
        $("#edit-btn").click(function (){
            $.ajax({
                url:"workbench/activity/getAcById.do",
                data:{
                    "id":"${activity.id}"
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
                    $("#edit-owner").val(data.activity.owner);
                    // 给所有文本栏赋值
                    $("#edit-name").val(data.activity.name);
                    $("#edit-startDate").val(data.activity.startDate);
                    $("#edit-endDate").val(data.activity.endDate);
                    $("#edit-cost").val(data.activity.cost);
                    $("#edit-describe").val(data.activity.description);

                    // 隐藏域中保存id
                    $("#edit-id").val(data.activity.id);
                    $("#editActivityModal").modal("show")
                }


            })
        })
        $("#delete-btn").click(function (){
            if(confirm("确定删除吗")){
                var param = 'id='+"${activity.id}";
                $.ajax({
                    url:"workbench/activity/delete.do",
                    data:param,
                    type:"post",
                    dataType:"json",
                    success:function (data){
                        if(data){
                            //pageList( 1 ,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
                            document.location.href = "workbench/activity/index.jsp"
                        }else {
                            alert("删除失败")
                        }
                    }
                })
            }

        })
        $("#updateBtn").click(function (){
            $.ajax({
                url:"workbench/activity/update.do",
                data:{
                    "id" : $("#edit-id").val(),
                    "owner" : $("#edit-owner").val(),
                    "name" : $("#edit-name").val(),
                    "startDate" : $("#edit-startDate").val(),
                    "endDate" : $("#edit-endDate").val(),
                    "cost" : $("#edit-cost").val(),
                    "description" : $("#edit-describe").val(),
                    "editBy":"${user.name}" // 为当前登录用户
                },
                type:"post",
                dataType:"json",
                success:function (data){
                    if(data){
                        //'<small>'+$("#edit-startDate").val()+' ~ +'$("#edit-endDate").val()'+'</small>'
                        //$("#name").html($("#edit-owner").val());
                        $("#name").html($('#edit-owner').find('option:selected').text());
                        $("#editTime").html("${activity.editTime}");
                        $("#editBy").html("${activity.editBy}&nbsp;&nbsp;");
                        $("#title").html('市场活动-'+$("#edit-name").val()+'<small>'+$("#edit-startDate").val()+'～'+$("#edit-endDate").val()+'</small>');
                        $("#name_1").html($("#edit-name").val());
                        $("#startDate").html($("#edit-startDate").val());
                        $("#endDate").html($("#edit-endDate").val());
                        $("#cost").html($("#edit-cost").val());
                        $("#description").html($("#edit-describe").val());
                        $("#editActivityModal").modal("hide");

                    }else {
                        alert("修改失败")
                    }
                }


            })
        })
	});
		function showRemarkList(){
			$.ajax({
				url:"workbench/activity/getRemarkList.do",
				data:{
					"activityId":"${activity.id}"
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
                     html+='		<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;" id="s'+n.id+'"> '+(n.editFlag==1?n.editTime:n.createTime)+' 由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
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
                url:"workbench/activity/deleteRemark.do",
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
	
	<!-- 修改市场活动备注的模态窗口 -->
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

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">

                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-startDate" >
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-endDate" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost" >
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                            </div>
                        </div>
                        <input type="hidden" id="edit-id">

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
			<h3 id="title">市场活动-${requestScope.activity.name} <small>${requestScope.activity.startDate} ~ ${requestScope.activity.endDate}</small> </h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="edit-btn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delete-btn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="name">${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="name_1">${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="startDate">${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="endDate">${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b id="cost">${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${activity.editBy}&nbsp;&nbsp;</b><small id="editTime" style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b id="description">
					${activity.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div id="remarkBody" style="position: relative; top: 30px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<!-- 备注2 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>呵呵！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:20:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>
		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button id="addRemarkBtn" type="button" class="btn btn-primary">保存</button>
				</p>
			</form>
		</div>
	</div>
	<div style="height: 200px;"></div>
</body>
</html>