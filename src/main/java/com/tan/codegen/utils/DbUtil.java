package com.tan.codegen.utils;

import com.tan.codegen.entity.TableRequest;
import com.zaxxer.hikari.HikariDataSource;
import lombok.experimental.UtilityClass;
import lombok.extern.slf4j.Slf4j;

/**
 * <p>
 * 数据库工具类
 * </p>
 *
 * @package: com.tan.codegen.utils
 * @description: 数据库工具类
 * @author: yangkai.shen
 * @date: Created in 2019-03-22 10:26
 * @copyright: Copyright (c) 2019
 * @version: V1.0
 * @modified: yangkai.shen
 */
@Slf4j
@UtilityClass
public class DbUtil {
    public HikariDataSource buildFromTableRequest(TableRequest request) {
        HikariDataSource dataSource = new HikariDataSource();
        dataSource.setJdbcUrl(request.getPrepend() + request.getUrl());
        dataSource.setUsername(request.getUsername());
        dataSource.setPassword(request.getPassword());
        return dataSource;
    }

}
