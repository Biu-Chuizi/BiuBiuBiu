#include<opencv2/opencv.hpp>
using namespace cv;

int main()
{
    VideoCapture capture;
    Mat frame;
    frame= capture.open(0);
    capture.set(CV_CAP_PROP_FRAME_WIDTH, 1920);
    capture.set(CV_CAP_PROP_FRAME_HEIGHT, 1080);
    if(!capture.isOpened())
    {
        printf("can not open ...\n");
        return -1;
    }
    namedWindow("output", CV_WINDOW_AUTOSIZE);

    while (capture.read(frame))
    {
        imshow("output", frame);
        waitKey(10);
    }
    capture.release();
    return 0;
}
