'''
Author: yangming
Date: 2021-10-06 14:26:35
LastEditTime: 2021-10-07 22:59:52
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: \show_trajectory\calculate_speedfeature.py
'''
import os
import numpy as np
import re
from visualize_speed import getVelocity

cm_unit = 100
for environment in ["IndoorDataset", "OutdoorDataset"]:
    seq_names = os.listdir(environment)

    total_v = []
    for seq in seq_names:
        [X, Y, Z] = re.findall(r"\d+\.?\d*", seq)
        filename = os.path.join(environment, seq, "gt", "gt.txt")
        v = getVelocity(int(X), int(Y), int(Z), filename)
        # extra v value
        for item in v:
            total_v.append(item[4]*cm_unit)

    print("mean_" + environment + ":", np.mean(total_v), " cm/s")
    print("std variance_" + environment + ":", np.std(total_v))
