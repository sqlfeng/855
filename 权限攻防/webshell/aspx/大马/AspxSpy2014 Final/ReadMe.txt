受bin牛委托修改并发布，版权归bin牛所有。
Bug/建议提交：zcgonvh@rootkit.net.cn
祝各位马年大吉，财运高升。

免责声明：
本程序只用于管理员安全检测，使用前请注意环境与法律法规，因使用不当造成的后果本人不承担任何责任。

已测试的系统：
win2003+iis6+.net 2.0
win2008+iis7+.net 4.0
win8+iis8+.net 4.5
注意：此版本最低需要.net 2.0环境，不再支持.net 1.1。如果目标机器是.net 1.1，请换用AspxSpy2010。
      由于js问题，建议使用ie8+/ff等浏览器访问，win2003自带的ie6在多个功能页面会显示白板。

此版本为开发版本，未进行任何加密，同时不具备免杀功能。如果没有特殊情况，AspxSpy将不再更新（可能更新插件）。如果有需要的话可以自行进行二次开发，但请保留版权。
附件中所有c#源码均可用以下命令编译，添加/t:library 表示生成dll：
set path=%path%;C:\Windows\Microsoft.NET\Framework\v2.0.50727
csc [/t:library] xxxx.cs 

新增功能：
1.显示应用程序域信任等级与当前用户
顶部 Host Trust Level后面的值为Asp.Net信任等级（AspNetHostingPermissionLevel），如果为Full则为完全信任（即非安全模式），否则为非完全信任（安全模式）。
注意：如果管理员修改了web.config或其他配置文件中的权限设置（例如将High-Trust的配置文件中删除了SocketPermission等），则不保证信任等级代表的权限正确。此可能性极低，在大多数情况下可忽略。
IsFull-Trust后面的值表示当前代码是否为Full-Trust，如果为True则为完全信任，此项一定准确。
当信任等级低于Low-Trust（即Minimal-Trust）时，AspxSpy将拒绝运行（在此信任等级下无法访问ServerVarible，不能调用任何与文件相关的方法包括Server.MapPath，权限还不如禁用了所有额外组件的ASP，除非用来分布式跑MD5否则基本是个废物）。

顶部User后面为用户名，此举为防止在非Full-Trust下部分SysInfo功能不可用导致无法获取用户名。此项在Low-Trust下不可用，显示为Unknown -- No permission。

关于asp.net每个信任等级与其默认权限，参考：
trust 元素（ASP.NET 设置架构）：http://msdn.microsoft.com/zh-cn/library/tkscy493%28v=vs.85%29.aspx
Asp.Net各个信任等级默认权限：http://msdn.microsoft.com/zh-cn/library/87x8e4d1%28v=vs.85%29.aspx

2.WMI查询功能
用于查询本机或远程主机WMI信息，利用得当可以获取不少信息。
Computer留空则为本机，Username与Password两项均不使用
Computer非空则为远程主机，如果Username中不含反斜杠(\)，则使用当前主机所在域，如果Username中包含反斜杠，则会将域设置为指定的域。如果需要使用远程域成员主机的本地账户认证，则可将域名指定为IP或计算机名。
Namespace为WMI命名空间，默认为root\CIMV2，QueryString为需要使用的WQL查询语句。

更多关于WMI的知识，参考：
WMICodeCreater，查询命名空间、类、属性与方法，以及生成代码： http://www.microsoft.com/en-us/download/confirmation.aspx?id=8572 （注：百度一下有汉化版）
WMI Administrative Tools，比WMICodeCreater更详细的WMI工具：http://www.microsoft.com/en-us/download/confirmation.aspx?id=24045
WQL，WMI查询语句：http://msdn.microsoft.com/en-us/library/aa394606%28v=vs.85%29.aspx
WMI Reference：http://msdn.microsoft.com/en-us/library/aa394572%28v=vs.85%29.aspx
未添加WMI方法执行功能，原因是方法参数与返回值太过复杂，事件及新建WMI实例同理。如有需要请自行根据WMICodeCreater生成脚本/编写插件。

3.ADS浏览与查询功能
用于查询ADS，对于域环境下有一定帮助（dsquery、dsget工具），也可用于查询本机信息。
Current Path为ADS路径，UserName与PassWord为认证信息，留空则使用默认凭据。
Filter为ADS筛选器，如果指定此项，则执行对Current Path下所有项及子项的搜索，并返回搜索结果的路径。此方法可能会产生大量数据，请构造合理的语句并慎重使用。
Type为System.DirectoryServices.AuthenticationTypes枚举的值，对应C++ ADSOpenObject第四个参数。点击文本框有下拉菜单方便输入，默认为1，此项一般无需更改。
值显示为System.__ComObject的项表示为IADsLargeInteger、IADsDNWithBinary、IADsDNWithString、IADsSecurityDescriptor其中某种类型的实例，由于将其转换为可读方式需要大量Interop代码，所以不做提供。如确有特殊需要，参考附件提供的ADSComObject.cs自行编写脚本/插件。
内置数个常用路径（WinNT、LocalMachine、LocalShare、WorkGroup、CurrentDomain、IIS、W3SVC、LDAP、LDAPRootDSE），方便浏览。
由于基本不可能拥有ADS的修改权限，所有不提供修改功能，如有需要参考msdn自行编写脚本。

更多关于ADS的知识，参考：
ADS COM对象与.net对象映射：http://msdn.microsoft.com/zh-cn/library/ms180868%28v=vs.110%29
DirectoryEntry：http://msdn.microsoft.com/zh-cn/library/System.DirectoryServices.DirectoryEntry
ADS Reference：http://msdn.microsoft.com/en-us/library/windows/desktop/aa772218%28v=vs.85%29.aspx
ADS筛选器语法：http://social.technet.microsoft.com/wiki/contents/articles/5392.active-directory-ldap-syntax-filters.aspx
ADS提供程序：http://msdn.microsoft.com/en-us/library/windows/desktop/aa772235(v=vs.85).aspx
IIS ADS提供程序：http://msdn.microsoft.com/en-us/library/ms524997(v=vs.90).aspx
ADExplorer，LDAP ADS浏览器：http://technet.microsoft.com/en-us/sysinternals/bb963907.aspx
Metabase Explorer，IIS ADS浏览器：http://support.microsoft.com/kb/840671/zh-cn#8

注：在使用Metabase Explorer查看IIS ADS时，最为重要的一项是AdminACL属性，这个属性以windows acl的方式规定了ADS访问权限，可以很直观的看出哪些属性可以被web应用程序所访问。

4.插件加载功能

由于已经包含绝大部分常用功能，如无特殊情况ASPXSpy将不再更新，为了后续拓展性现提供插件加载功能。ASPXSpy的插件需要为一个合法的.net程序集，在上传后进行加载并反射调用插件方法。
TypeName为包含插件方法的完全限定类名，MethodName为方法名，Params为传递的参数，每行一个，空行将被忽略，所有的参数将储存至字符串数组并由反射调用时传递。
如果选中Deflate-Compressed选项，则需将插件进行Deflate压缩后上传，此举为防止由于上传PE文件导致触发IDS。
详细的插件开发信息参考 附录：插件开发指南。

修改：

1.修正大部分功能的异常处理，使之不会出现未处理异常（主要是非Full-Trust下产生的安全性异常）导致的红页。

2.去除了早期使用的VB.Net函数，以取消Microsoft.VisualBasic.dll的依赖以及防止在某些情况下编译出错。

3.File Manager
修正盘符列举方式，使其在High-Trust下可用。
修改文件下载方式，使其在下载大文件时不会因应用程序池回收而崩溃。

4.PortScan
在Medium-Trust及更低信任等级下会显示安全性异常，而不是所有端口均关闭的信息。

5.PortMap
在Medium-Trust及更低信任等级下会显示安全性异常，而不是连接已建立的信息。
增强PortMap的表现形式，现在可以点击List按钮来查看并管理所有开启的连接（由于数据放在Session中，所以服务器必须开启Session，同时不保证在Session Mode为非Inproc模式下能正常工作）。
去掉了无用的Refresh按钮，修改了ClearAll对应的方法使之能正确的清除所有连接。

6.DataBase
MSSQL数据库连接方式修改为SqlConnection，使其在High-Trust/Medium-Trust环境下可用。

7.Serv-U Exp
因过时而删除，将以插件形式供特殊情况下使用。

8.禁用部分控件的ViewState，使得不会由于某些操作在ViewState中保存大量无用信息导致的访问缓慢。

9.重构大部分代码以优化

附录：插件开发指南

ASPXSpy的插件需要为一个合法的.net程序集，在上传后进行加载并反射调用插件方法。此方法必须为接受一个字符串数组作为参数的静态方法，建议返回字符串或StringBuilder等可读对象。为避免某些情况下抛出MethodAccessException，建议将方法所在的类与方法本身设置为public。
注意：服务器必须兼容程序集的运行时版本。

压缩后的插件可以用以下方式创建：
将插件打包为ZIP，压缩模式设置为除“储存”外的任何选项，或者使用windows自带的发送到压缩文件夹。用WINHEX打开打包后的ZIP文件，查找程序集文件名，删除从文件头部至此处的块；定位到文件末尾，向上搜索十六进制值504b0102，删除以第一个搜索结果开始至文件末尾的块。保存文件即可。
也可使用附件中的插件压缩工具(PluginDeflater.exe)，拖拽程序集至工具上即可。

如果选中HTML Result选项，则返回结果将作为HTML显示，可在返回结果中加入以下链接来调用ASPXSPY的功能：
打开文件管理器：javascript:__doPostBack('Bin_Button_File','')
跳转至某目录：javascript:Bin_PostBack('Bin_Listdir','BASE64编码后的文件绝对路径')
打开文本文件：javascript:Bin_PostBack('Bin_Editfile','JS转义后的文件绝对路径') 
下载文件：javascript:Bin_PostBack('Bin_DownFile','BASE64编码后的文件绝对路径')
打开文件属性页面：javascript:Bin_PostBack('Bin_CloneTime','JS转义后的文件绝对路径') 
跳转至文件搜索：javascript:__doPostBack('Bin_Button_Search','')
IIS SPY：javascript:__doPostBack('Bin_Button_IISspy','')
查看进程：javascript:__doPostBack('Bin_Button_Process','')
关闭进程：javascript:Bin_PostBack('zcg_KillProcess','进程ID')
查看服务：javascript:__doPostBack('Bin_Button_Services','')
查看用户信息：javascript:__doPostBack('Bin_Button_Userinfo','')
查看系统信息：javascript:__doPostBack('Bin_Button_Sysinfo','')
跳转至注册表管理器：javascript:__doPostBack('Bin_Button_Reg','')
打开注册表项：javascript:Bin_PostBack('Bin_Regread','BASE64编码后的注册表路径') 
跳转至端口扫描工具：javascript:__doPostBack('Bin_Button_PortScan','')
跳转至WMI工具：javascript:__doPostBack('Bin_Button_WmiTools','')
跳转至ADS工具：javascript:__doPostBack('zcg_lbtnADSViewer','')

附件中TestPlugin.cs为一个测试用插件的源码，SUEXPPlugin.cs为已删除的SU-EXP功能的插件源码，对应的.dll文件为插件，.Deflated文件为压缩后的插件。
两个插件的方法与参数信息如下：
TestPlugin:
TypeName:Zcg.Test.AspxSpyPlugins.TestPlugin
MethodName:Test
HTML Result:false
Params:任意
输出:以|分割的所有参数

TestPlugin:
TypeName:Zcg.Test.AspxSpyPlugins.TestPlugin
MethodName:Test1
HTML Result:true
Params:任意
输出:一个指向百度的链接

SUEXPPlugin：
TypeName:Zcg.Test.AspxSpyPlugins.SUEXPPlugin
MethodName:Run
HTML Result:true
Params:
       cmd命令（可选，若提供则覆盖默认命令cmd /c whoami /all）
       su登录名（可选，若提供则覆盖默认用户名localadministrator）
       su密码（可选，若提供则覆盖默认密码#l@$ak#.lk;0@P）
       su端口（可选，若提供则覆盖默认端口43958）
输出:
     原AspxSpy SU-EXP功能输出或异常信息