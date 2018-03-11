# Visual Tracking by Sampling in Part Space

MATLAB implementation of the tracking method described in the paper [Visual Tracking by Sampling in Part Space](http://iitlab.bit.edu.cn/mcislab/~shenjianbing/pdfs/2017/tip17partspacetrack.pdf).

## Running the tracker

Run tracking on single video "Bird2" (which is already included in this repository):

```
>> demo_single_tracker
```

Run tracking on full benchmark:

1) Change `othPath` in "demo_benchmark.m" to your path to the [benchmark dataset](http://cvlab.hanyang.ac.kr/tracker_benchmark/index.html).
2) Run `demo_benchmark`.

All tracking results will be stored in the "results" folder.

## References

If you find this work useful, please consider citing:

↓ [Journal paper] ↓
```
@article{Huang2017Visual,
  title={Visual Tracking by Sampling in Part Space},
  author={Huang, Lianghua and Ma, Bo and Shen, Jianbing and He, Hui and Shao, Ling},
  journal={IEEE Transactions on Image Processing A Publication of the IEEE Signal Processing Society},
  volume={PP},
  number={99},
  pages={1-1},
  year={2017},
}
```

## License

This code can be freely used for personal, academic, or educational purposes.

Please contact us for commercial use.
