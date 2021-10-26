# TODO：用数据集测试

## 1. 安装
```
pip install motmetrics

```

## 2. 设置评估参数
### step1: groundtruths
`--groundtruths`：待评估的数据集主目录（sequence文件夹的父目录）
- Layout for ground truth data
    <GT_ROOT>/<SEQUENCE_1>/gt/gt.txt
    <GT_ROOT>/<SEQUENCE_2>/gt/gt.txt
    ...
故该参数为`--groundtruths <GT_ROOT>`

此外，在ground truth data的sequence目录下（与gt文件夹同级），需要添加1个`seqinfo.ini`文件
内容大致如下：
```
[Sequence]
name=ant0001
imDir=img1
frameRate=30
seqLength=30
imWidth=640
imHeight=480
imExt=.jpg
```

### step2: tests
`--tests`：待评估的数据集的目录
Layout for test data
    <TEST_ROOT>/<SEQUENCE_1>.txt
    <TEST_ROOT>/<SEQUENCE_2>.txt
    ...
故该参数为`--tests <TEST_ROOT>/`

此外，待评估的txt文件的命名应与其sequence号相同，比如：`ant0001.txt`

### step3: seqmap
`--seqmap`：待评估的sequence的说明文件，为txt文件
Seqmap for test data
    [name]
    <SEQUENCE_1>
    <SEQUENCE_2>
    ...
故该参数为`--seqmap ./seqmaps/dataset_name.txt`



## 3. 评估
```
python evaluateTracking.py \
    --groundtruths ../data/motant/ \
    --tests ../results/ \
    --seqmap ./seqmaps/ant.txt
```
输出的最终评估结果大致如下所示：
```
            IDF1    IDP    IDR   Rcll   Prcn GT MT PT ML FP FN IDs  FM   MOTA  MOTP IDt IDa IDm
ANT11-20 100.0% 100.0% 100.0% 100.0% 100.0% 10 10  0  0  0  0   0   0 100.0% 78.0%   0   0   0
OVERALL  100.0% 100.0% 100.0% 100.0% 100.0% 10 10  0  0  0  0   0   0 100.0% 78.0%   0   0   0
```