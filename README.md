代码生成工具
参考开源项目spring-boot-demo中的codegen改造而来
https://github.com/xkcoding/spring-boot-demo
模板引擎使用freemaker
大致原理是通过查询数据库表的信息使用模板替换生成一套基础代码

在实际项目中使用时，还需要根据实际项目结构情况修改相应模板或者添加相应模板

如果输入jdbcurl报错
You must configure either the server or JDBC driver (via the serverTimezone configuration property) to use a more specifc time zone value if you want to utilize time zone support.
需要在输入如下格式url
localhost:3306/test?useUnicode=true&characterEncoding=utf-8&useSSL=false&serverTimezone=GMT%2B8