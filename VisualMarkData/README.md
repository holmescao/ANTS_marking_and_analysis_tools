# VisualMarkData

We develop an image sequence marking software to mark motion information such as the position and ID number of objects in a video.

## Marking process

### Choose Image Set
```
Before marking, the user should click "Choose ImageSet" to select an image set. 
The filename of the image set is defined in the format of "SeqXObjectYImageZ", where X is the name of the sequence, Y is the number of objects in the first frame and Z is the size of the bounding box which represents the object.
For example, the image set, named "Seq0001Object10Image94", indicates that the sequence "0001" contains 10 objects in the first frame, and each object will be marked with a bounding box with the size of 94x94.
```

### Create Output Directory
```
The user needs to click "Output Directory" to select the storage path of annotations. 
Since VisualMarkData only focuses on one object per marking round (each round goes through the whole image sequence), the output folder is suggested to be named with the identity number of the object, e.g. "0001". As the identity number of object  is user-defined, user can use any number for object and folder as long as it is unique.
```

### Select Start Frame
```
In the last step before starting to marking, you need to enter the start frame, the default value is 0.
This means that you are allowed to exit the software halfway and continue the progress of the current marking task the next time. Then, you can click "Start" button.
```

### Marking
```
The user clicks on the center of object in the current frame, and the software will automatically save the digital location of the center, as well as a bounding box centered on the object.
It should be emphasized that the user needs not to mark all the objects in one image simultaneously, but only marks the same object until the user finishes the entire image set. 
```

### Next Frame
```
The user clicks "Next" button to show the next frame on the window of software.
The marked location on the previous frame will be displayed with a green-dotted, which can help the user quickly locate the target object.
```

### Previous Frame
```
If the marked location of the previous frame is incorrect, the user can click "Previous" button to roll back one frame.
```

### Check and Modify
```
After the user finishes marking the entire image set, checking is needed to guarantee the quality.
In this case, the user can enter the specific frame to modify the annotations by carrying out \textbf{Select Start Frame} step.
```

### Merge Annotations
```
After all objects in a sequence have been marked and reviewed, the user needs to click "Merge" button, thereby all annotations for each object will be sorted by frames and then the ID of object both in ascending order.
```


## Environment and Dependencies

- Language and Environment: `MATLAB R2021b`
- Dependency Toolbox: `Image Processing Toolbox`

