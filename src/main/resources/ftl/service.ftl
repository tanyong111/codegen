package ${packageName}.${service};

import ${packageName}.${entity}.${entityName};
import com.baomidou.mybatisplus.extension.service.IService;
/**   
 * ${comments}服务层
 * @version: ${version}
 * @author: ${author}
 * @date: ${createTime}
 */
public interface ${entityName}Service extends IService<${entityName}> {

    /**
    * 根据主键id删除
    * @param ids
    */
    void deleteByIds(Long[] ids);
}