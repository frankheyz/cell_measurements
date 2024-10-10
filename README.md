# cell_measurements
pre-processing code for cell measurements

:syringe:用于甲状腺细胞测量的预处理代码 :syringe:

---------------------
## 代码简介
这里有matlab代码可以对无标记甲状腺穿刺细胞涂片系统的原始数据进行预处理处理。处理后的图像可以用于后续的拼接、配准、虚拟染色、识别、计数等任务。


## 使用方式

- 克隆这个代码仓
- 运行matlab
- 将 `cell_measurements`文件夹添加到matlab的运行路径
  - Home（主页） -> Set Path （设置路径） -> Add with Subfolders（添加文件夹） -> Save（保存）
- 将原始16bits图像转化为8bits，`path/to/raw/data`替换为需要转换的原始数据所在的文件夹
```matlab
    convert_16bits_to_8bits('path/to/raw/data')
```
- 结果保存于`path/to/raw/data_8bits`文件夹中
- 提取每个视场中最清晰的图像
```matlab
    extract_most_clear_image(`path/to/raw/data_8bits`)
```
- 结果保存于`path/to/raw/data_8bits_most_clear`文件夹中

##  其他

- 处理完毕的图像，可以使用ImageJ中的拼接功能进行大图拼接
  - 打开ImageJ
  - Plugins -> Stitching -> Grid/Collection stitching
  - 根据扫描方式及XY格子数量进行拼接