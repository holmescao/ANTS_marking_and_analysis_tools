## 1. Installation
```
pip install motmetrics

```

## 2. set evaluation parameters
## step1: groundtruths
`--groundtruths`: home directory of the dataset to be evaluated (parent directory of the sequence folder)
- Layout for ground truth data
    <GT_ROOT>/<SEQUENCE_1>/gt/gt.txt
    <GT_ROOT>/<SEQUENCE_2>/gt/gt.txt
    ...
So the argument is `--groundtruths <GT_ROOT>`

In addition, in the sequence directory of ground truth data (same level as gt folder), you need to add `seqinfo.ini` file.
The content is roughly as follows.
```
[Sequence]
name=Seq0001Object10Image94
imDir=img
frameRate=25
seqLength=351
imWidth=1920
imHeight=1080
imExt=.jpg
```

### step2: tests
`--tests`: the directory of the dataset to be evaluated
Layout for test data
    <TEST_ROOT>/<SEQUENCE_1>.txt
    <TEST_ROOT>/<SEQUENCE_2>.txt
    ...
Therefore, the parameter is `--tests <TEST_ROOT>/`

In addition, the txt file to be evaluated should be named the same as its SEQUENCE number, for example: `Seq0001Object10Image94.txt`

### step3: seqmap
`--seqmap`: the description file of the sequence to be evaluated, as a txt file
Seqmap for test data
    [name]
    <SEQUENCE_1>
    <SEQUENCE_2>
    ...
So the parameter is `--seqmap . /seqmaps/ant.txt`



## 3. Evaluation
```
python evaluateTracking.py \
    --groundtruths . /IndoorDataset/ \
    --tests ... /results/ \
    --seqmap . /seqmaps/ant.txt
```
The output final evaluation results are roughly as follows.
```
                       IDF1 IDP IDR Rcll Prcn GT MT PT ML FP FN IDs FM MOTA MOTP IDt IDa IDm
Seq0001Object10Image94 100.0% 100.0% 100.0% 100.0% 100.0% 100.0% 10 10 0 0 0 0 0 0 0 100.0% 100.0% 100.0% 0 0 0 0
overall 100.0% 100.0% 100.0% 100.0% 100.0% 100.0% 50 50 0 0 0 0 0 0 0 100.0% 100.0% 0 0 0 0
````