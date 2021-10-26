import cv2
import multiprocessing as mp
import os
import matplotlib.pyplot as plt
from matplotlib import cm
import numpy as np
import argparse
import re


def getRawData(indoor, filename):
    with open(filename, "r") as f:
        data = f.readlines()
    f.close()
    return data


def calculateVelocity(a, b, pixel_size, indoor,
                      indoor_size=0.0085,
                      outdoor_size=0.009,
                      indoor_fps=25,
                      outdoor_fps=30):

    pixel_distance = ((a[2]-b[2])**2+(a[3]-b[3])**2)**(1/2)

    m_distance = 1
    if indoor:
        m_distance = pixel_distance/pixel_size*indoor_size
        second = (b[0]-a[0]) / indoor_fps
    else:
        m_distance = pixel_distance/pixel_size*outdoor_size
        second = (b[0]-a[0]) / outdoor_fps

    return m_distance/second


def getVelocity(indoor, antnum, pixel_size, filename):
    velocity = []
    processed_datas = []

    # read data
    data = getRawData(indoor, filename)

    # process data
    for line in data:
        L = line.split()[0].split(',')
        center_x = float(L[2]) + float(L[4])/2
        center_y = float(L[3]) + float(L[5])/2
        processed_datas.append([int(L[0]), int(L[1]), center_x, center_y])

    start_index = processed_datas[0][1]

    for i in range(start_index, start_index + antnum):
        trace = []

        for line in processed_datas:
            if line[1] == i:
                trace.append(line)

        for i in range(len(trace)-1):
            temp = trace[i+1]
            temp.append(calculateVelocity(
                trace[i], trace[i+1], pixel_size, indoor))
            velocity.append(temp)

    # [frameId,AntId,AntCenterPosx,AntCenterPosy,speed]
    return velocity


def show_heatmap(v, image_height, cm_unit=100):
    x = []
    y = []
    value = []

    for item in v:
        x.append(item[2])
        y.append(image_height-item[3])
        value.append(item[4]*cm_unit)

    value = np.array(value)
    # print(value.max())

    fs = 22
    plt.figure(1)
    pc = plt.scatter(x, y, s=10, c=value, cmap='jet',
                     alpha=0.7, vmin=0, vmax=0.15*cm_unit)
    ax = plt.gca()
    ax.set_facecolor('#00008f')
    plt.xticks([])
    plt.yticks([])

    cb = plt.colorbar(pc)
    cb.ax.tick_params(labelsize=fs)

    plt.savefig(args.save_fig_dir+'/heatmap_' +
                args.scene+'.jpg', dpi=300, bbox_inches="tight")
    plt.close()


def show_histogram(v, cm_unit=100):
    data = []
    for item in v:
        data.append(item[4]*cm_unit)

    fs = 22
    ax = plt.figure(2)
    plt.hist(
        data, bins=40, facecolor='g', alpha=0.75, edgecolor='black')

    plt.xlabel('Velocity (cm/s)', fontsize=fs+5)
    plt.ylabel('Frequency', fontsize=fs+5)

    plt.xticks(fontsize=fs)
    plt.yticks(fontsize=fs)
    plt.xlim([0, 0.15*cm_unit])

    ax.yaxis.set_ticks_position('right')

    # plt.title('Frequency of Velocity', y=-0.3)

    plt.savefig(args.save_fig_dir+'/histogram_' +
                args.scene+'.jpg', dpi=300, bbox_inches="tight")
    plt.close()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("--scene", default="Seq0005Object10Image94",
                        type=str, help="SeqXObjectYImageZ")
    parser.add_argument("--save_fig_dir", default="figures/speed/",
                        type=str, help="SeqXObjectYImageZ")
    parser.add_argument("--image_height", default="720",
                        type=str, help="heitght of image")
    args = parser.parse_args()

    if not os.path.exists(args.save_fig_dir):
        os.makedirs(args.save_fig_dir, exist_ok=True)

    Dataset_root_path = "../"
    for environment in ["IndoorDataset", "OutdoorDataset"]:
        seq_names = os.listdir(Dataset_root_path+environment)

        for seq in seq_names:
            print(f"Processing {seq}")
            seq_dir = os.path.join(environment, seq)
            seq_img_dir = os.path.join(seq_dir, "img")
            img0_path = os.path.join(seq_img_dir, os.listdir(seq_img_dir)[0])
            img0 = cv2.imread(img0_path)
            args.image_height = img0.shape[0]
            args.scene = seq
            [X, Y, Z] = re.findall(r"\d+\.?\d*", seq)

            indoor = False
            if int(X) < 6:
                indoor = True

            seq_gt_dir = os.path.join(seq_dir, "gt")
            filename = os.path.join(seq_gt_dir, "gt.txt")
            v = getVelocity(indoor, int(Y), int(Z), filename)

            show_heatmap(v, args.image_height)
            show_histogram(v)
