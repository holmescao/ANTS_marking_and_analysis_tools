# ANTS_marking_and_analysis_tools

This repository is provided for marking ant motion trajectories dataset from video. We provide a marking software, three data quality analysis scripts, and a tracking performance evaluation tool.


## Dataset

First you need to download the [Ant_Dataset](https://data.mendeley.com/datasets/9ws98g4npw/3), unzip and extract the `IndoorDataset`, `OutdoorDataset` folders to the current path.

## Marking Software
The marking software (VisualMarkData) is located in the `./VisualMarkData` folder, and the usage can be found in `./VisualMarkData/README.md`.

## Data Analysis Scripts
The data analysis scripts are in the `./DatasetQualityAnalysis` folder and the usage can be found in `./DatasetQualityAnalysis/README.md`.

## Tracking Performance Evaluation
The tracking performance evaluation tool is located in the `./MOTMetricEvaluate` folder, and the usage can be found in `./MOTMetricEvaluate/README.md`.

## Citation
If you find this project useful, please consider to cite our paper. Thank you!

```
@article{wu2022dataset,
  title={A dataset of ant colonies’ motion trajectories in indoor and outdoor scenes to study clustering behavior},
  author={Wu, Meihong and Cao, Xiaoyan and Yang, Ming and Cao, Xiaoyu and Guo, Shihui},
  journal={GigaScience},
  volume={11},
  pages={giac096},
  year={2022},
  publisher={Oxford University Press}
}
```
