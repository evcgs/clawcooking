# Data大厨 使用指南
## 安装方法
### 方法1：一键部署（推荐）
```bash
# 在ccg根目录运行
./scripts/deploy.sh --only data-chef
```

### 方法2：手动安装
```bash
# 安装智能体
openclaw agents install data-chef --config recipes/chefs/data-chef/config.yaml

# 安装数据分析依赖
pip install pandas numpy matplotlib seaborn plotly scipy scikit-learn sqlalchemy openpyxl

# 验证安装
openclaw agents list | grep data-chef
```

## 配置自定义
### 1. 新增数据源连接
编辑 `config.yaml` 中的 `capabilities.data_processing` 字段，添加你常用的数据源：
```yaml
capabilities:
  data_processing:
    supported_sources: ["mysql", "postgresql", "your-custom-database"]
```
并在环境变量中配置数据库连接信息，避免明文存储密码。

### 2. 自定义分析模板
编辑 `config.yaml` 中的 `analysis_templates` 字段，添加你常用的分析模板：
```yaml
analysis_templates:
  your_custom_template: |
    # 你的自定义分析报告模板
    ## 一、自定义部分1
    ## 二、自定义部分2
    ## 三、自定义部分3
```

### 3. 调整可视化配置
编辑 `config.yaml` 中的 `capabilities.visualization` 字段，配置你偏好的可视化库和样式：
```yaml
capabilities:
  visualization:
    libraries: ["plotly", "echarts"]  # 优先使用的可视化库
    chart_export: ["png", "html"]    # 导出格式
```

## 使用技巧
### 技巧1：快速数据分析
```
@Data大厨 分析这份数据：
[上传文件/粘贴数据/数据库连接信息]
- 分析维度：[销售/用户/行为]
- 重点关注：[趋势/结构/异常值]
- 输出：[分析报告+可视化图表/仅统计数据/业务建议]
```
Data大厨会自动完成数据清洗、分析、可视化全流程，输出完整报告。

### 技巧2：A/B测试分析
```
@Data大厨 分析A/B测试结果：
- 对照组数据：[粘贴对照组数据]
- 实验组数据：[粘贴实验组数据]
- 核心指标：[转化率/点击率/留存率]
- 置信度：95%
```
Data大厨会自动做显著性检验，给出明确的结论和建议。

### 技巧3：用户行为分析
```
@Data大厨 分析用户行为数据：
- 数据范围：[近30天/某个活动周期]
- 分析内容：[留存分析/漏斗分析/用户画像]
- 重点：[流失原因/转化卡点/增长机会]
```
Data大厨会自动分析用户行为路径，找出转化卡点和增长机会。

### 技巧4：可视化制作
```
@Data大厨 生成可视化图表：
- 数据：[粘贴数据]
- 图表类型：[柱状图/折线图/仪表盘/数据大屏]
- 展示维度：[按时间/按地区/按品类]
- 输出格式：[图片/HTML/PPT可编辑格式]
```
Data大厨会自动生成专业的可视化图表，支持多种导出格式。

## 常见问题
### Q：Data大厨可以处理多大的数据量？
A：默认支持最大10GB的数据量，更大的数据量可以通过分布式处理或者采样分析，也可以在配置文件中调整`max_data_size`参数。

### Q：可以对接我的业务数据库吗？
A：可以，支持MySQL、PostgreSQL、SQLite等常见数据库，只需要配置数据库连接信息即可，密码通过环境变量存储，不会明文保存。

### Q：生成的分析报告可以直接用吗？
A：Data大厨生成的是基础分析框架，建议你根据实际业务情况调整结论和建议，尤其是涉及到业务决策的部分。

### Q：可以做机器学习和预测分析吗？
A：可以，支持常见的机器学习算法，包括分类、聚类、回归、时间序列预测等，适合做简单的预测分析。

## 最佳实践
1. **数据质量先行**：提供给Data大厨的数据尽量干净、结构化，减少脏数据，分析结果会更准确
2. **明确分析目标**：分析前明确说明分析目标、关注重点、输出要求，避免无目的的泛泛分析
3. **业务知识补充**：如果是特定行业的数据分析，可以先给Data大厨补充行业知识和业务规则，分析结果会更贴合实际
4. **结果验证**：重要的分析结论和决策建议，一定要人工验证数据和逻辑，避免AI幻觉导致的错误
5. **模板复用**：常用的分析场景可以保存为模板，后续直接套用，提高分析效率
