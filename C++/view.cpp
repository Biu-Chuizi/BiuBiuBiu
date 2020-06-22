#include<opencv2/opencv.hpp>
#include<opencv2/highgui/highgui.hpp>
using namespace cv;
using namespace std;
 
int main()
{
	VideoCapture cap;
	cap = VideoCapture(CV_CAP_DSHOW); //DirectShow
	cap.open(1);	//
	if (!cap.isOpened())
		return -1;
	cap.set(CV_CAP_PROP_FOURCC, CV_FOURCC('M', 'J', 'P', 'G'));//set to MJPG
	cap.set(CV_CAP_PROP_FRAME_HEIGHT, 1920);
	cap.set(CV_CAP_PROP_FRAME_WIDTH, 1080);
	TickMeter tm;
 
	while (1)
	{
 
		tm.reset();
		tm.start();
		Mat frame;
		for (int i = 0; i < 100; i++)//Is not accuracy when I count once.
		{
			cap >> frame;
			imshow("frame", frame);
			if(waitKey(1)==27);//ESC for quit
		}
		tm.stop();
		cout << 100 / tm.getTimeSec() << "fps" << endl;//output the fps
	}
	return 0;
}

