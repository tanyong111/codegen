package com.tan.codegen.utils;

import com.tan.codegen.entity.TableEntity;
import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringWriter;

public class FreemarkerUtil {
	/**
	 * 更新文件类型：
	 * 1：已存在，不处理，日志显示 `XXX已存在，不进行覆盖`
	 * 2：已存在，强行覆盖，日志显示，`XXX已存在，已进行覆盖`
	 * 3：已存在，生成新文件 原文件名_1，日志显示，`XXX已存在，生成新文件 XXX_1`
	 */
	private static int updateType = 2;

	public static void createFile(TableEntity dataModel, String templateName, String filePath) {
		FileWriter out = null;
		try {
			// 通过FreeMarker的Confuguration读取相应的模板文件
	        Configuration configuration = new Configuration(Configuration.VERSION_2_3_28);
	        // 设置模板路径
	        configuration.setClassForTemplateLoading(FreemarkerUtil.class, "/freemarker/ftl");
	        // 设置默认字体
	        configuration.setDefaultEncoding("utf-8");
	        // 获取模板
			Template template = configuration.getTemplate(templateName);
			File file = new File(filePath);
			if (!file.getParentFile().exists()) {
				file.getParentFile().mkdirs();
			}
			if(!file.exists()) {
                file.createNewFile();
				//设置输出流
				out = new FileWriter(file);
				//模板输出静态文件
				template.process(dataModel, out);
				System.out.println("创建成功"+" ---> ("+filePath+")");
            }else {
				if(updateType == 1){
					System.out.println("已存在，不进行覆盖 ---> ("+filePath+")");
				}else if(updateType == 2){
					//先删除原来文件
					file.delete();
					//创建新文件
					file.createNewFile();
					//设置输出流
					out = new FileWriter(file);
					//模板输出静态文件
					template.process(dataModel, out);
					System.out.println("已存在，已进行覆盖"+" ---> ("+filePath+")");
				}else if(updateType == 3){
					//创建新文件
					String tmpFilePath = filePath+"_1";
					File tmpFile = new File(tmpFilePath);
					tmpFile.createNewFile();
					//设置输出流
					out = new FileWriter(tmpFile);
					//模板输出静态文件
					template.process(dataModel, out);
					System.out.println("已存在，生成新文件_1  ---> ("+filePath+"_1)");
				}else{
					throw new RuntimeException("文件更新方式不合法");
				}
            }
        	return;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            if(null != out) {
                try {
                    out.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
		System.out.println("创建"+filePath+"失败");
	}

	public static StringWriter createStringWriter(TableEntity dataModel, String templateName) {
		StringWriter sw = new StringWriter();
		try {
			// 通过FreeMarker的Confuguration读取相应的模板文件
			Configuration configuration = new Configuration(Configuration.VERSION_2_3_28);
			// 设置模板路径
			configuration.setClassForTemplateLoading(FreemarkerUtil.class, "/ftl");
			// 设置默认字体
			configuration.setDefaultEncoding("utf-8");
			// 获取模板
			Template template = configuration.getTemplate(templateName);
			//模板输出静态文件
			template.process(dataModel, sw);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return sw;
	}

//	public static void create(TableInfo bi) {
//		if(bi.getEntityUrl()!=null) {
//			createFile(bi,"entity.ftl",bi.getEntityUrl());
//		}
//		if(bi.getDaoUrl()!=null) {
//			createFile(bi,"dao.ftl",bi.getDaoUrl());
//		}
//		if(bi.getMapperUrl()!=null) {
//			createFile(bi,"mapper.ftl",bi.getMapperUrl());
//		}
//		if(bi.getServiceUrl()!=null) {
//			createFile(bi,"service.ftl",bi.getServiceUrl());
//		}
//		if(bi.getServiceImplUrl()!=null) {
//			createFile(bi,"serviceImpl.ftl",bi.getServiceImplUrl());
//		}
//		if(bi.getControllerUrl()!=null) {
//			createFile(bi,"controller.ftl",bi.getControllerUrl());
//		}
//	}

}
