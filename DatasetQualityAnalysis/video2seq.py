'''
Author: your name
Date: 2021-10-05 22:17:39
LastEditTime: 2021-10-07 01:47:21
LastEditors: Please set LastEditors
Description: In User Settings Edit
FilePath: \show_trajectory\video2seq.py
'''
import multiprocessing as mp
import time
import cv2
import os


def Video2Image(videoFile, outputFile):
    vc = cv2.VideoCapture(videoFile)
    if vc.isOpened():
        rval, frame = vc.read()
    else:
        print('openerror!')
        rval = False

    frame_id = 1
    while rval:
        rval, frame = vc.read()
        frame_name = outputFile + str(frame_id).zfill(6) + '.jpg'
        if frame is None:
            print(frame_id)
            continue
        cv2.imwrite(frame_name, frame)
        frame_id += 1

    vc.release()


if __name__ == "__main__":
    video_dir = "figures/video"
    output_dir = "figures/trajectory"

    for seq_name in os.listdir(video_dir):
        st = time.time()
        name = os.path.splitext(seq_name)[0]
        videoFile = os.path.join(video_dir, seq_name)
        outputFile = os.path.join(output_dir, name+"/")
        if not os.path.exists(outputFile):
            os.makedirs(outputFile, exist_ok=True)

        Video2Image(videoFile, outputFile)

        print("[%.2f sec] Processed %s." % (time.time()-st, name))
