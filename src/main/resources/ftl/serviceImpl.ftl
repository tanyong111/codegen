package ${packageName}.${service}.${serviceImpl};

import ${packageName}.${entity}.${entityName};
import ${packageName}.${dao}.${entityName}Mapper;
import ${packageName}.${service}.${entityName}Service;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.transaction.annotation.Transactional;

/**   
 * ${comments}服务实现层
 * @version: ${version}
 * @author: ${author}
 * @date: ${createTime}
 */
@Service
public class ${entityName}ServiceImpl  extends ServiceImpl<${entityName}Mapper, ${entityName}> implements ${entityName}Service  {

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void deleteByIds(Long[] ids) {
        for(Long id:ids) {
            ${entityName} ${lowerClassName} = new ${entityName}();
            ${lowerClassName}.setId(id);
            ${lowerClassName}.builderUpdate();
            ${lowerClassName}.setDeleteFlag(true);
            updateById(${lowerClassName});
        }
    }
}