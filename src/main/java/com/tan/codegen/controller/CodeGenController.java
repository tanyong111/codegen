package com.tan.codegen.controller;

import cn.hutool.core.io.IoUtil;
import com.tan.codegen.common.R;
import com.tan.codegen.entity.GenConfig;
import com.tan.codegen.entity.TableRequest;
import com.tan.codegen.service.CodeGenService;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.http.HttpHeaders;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;

/**
 * <p>
 * 代码生成器
 * </p>
 *
 * @package: com.tan.codegen.controller
 * @description: 代码生成器
 * @author: yangkai.shen
 * @date: Created in 2019-03-22 10:11
 * @copyright: Copyright (c) 2019
 * @version: V1.0
 * @modified: yangkai.shen
 */
@RestController
@AllArgsConstructor
@RequestMapping("/generator")
public class CodeGenController {
    private final CodeGenService codeGenService;

    /**
     * 列表
     *
     * @param request 参数集
     * @return 数据库表
     */
    @GetMapping("/table")
    public R listTables(TableRequest request) {
        return R.ok(codeGenService.listTables(request));
    }

    /**
     * 生成代码
     */
    @SneakyThrows
    @PostMapping("")
    public void generatorCode(@RequestBody GenConfig genConfig, HttpServletResponse response) {
        byte[] data = codeGenService.generatorCode(genConfig);
        response.reset();
        response.setHeader(HttpHeaders.CONTENT_DISPOSITION, String.format("attachment; filename=%s.zip", genConfig.getTableName()));
        response.addHeader(HttpHeaders.CONTENT_LENGTH, String.valueOf(data.length));
        response.setContentType("application/octet-stream; charset=UTF-8");

        IoUtil.write(response.getOutputStream(), Boolean.TRUE, data);
    }
}
