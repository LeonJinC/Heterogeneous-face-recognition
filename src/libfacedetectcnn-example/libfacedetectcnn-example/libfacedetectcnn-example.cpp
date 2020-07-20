// libfacedetectcnn-example.cpp : 定义控制台应用程序的入口点。
//

#include "stdafx.h"


#include <stdio.h>
#include <opencv2/opencv.hpp>
#include "facedetectcnn.h"

#pragma comment(lib, "facedetection.lib")//引入链接库

//define the buffer size. Do not change the size!
#define DETECT_BUFFER_SIZE 0x20000
using namespace cv;

int main(int argc, char* argv[])
{
	//if (argc != 2)
	//{
	//	printf("Usage: %s <image_file_name>\n", argv[0]);
	//	return -1;
	//}

	//load an image and convert it to gray (single-channel)
	Mat image = imread("00001.jpg");//00001 10225 00001_a 00005_d 10106_c 10158_e 20348_a	10225_a 10225_b 10225_c 10225_d 10225_e
	resize(image, image, Size(0, 0), 0.8, 0.8);
	/*cvtColor(image, image, CV_BGR2HSV);*/
	//Mat kernel = (Mat_<float>(3, 3) << 0, -1, 0, 0, 5, 0, 0, -1, 0);
	//filter2D(image, image, CV_8UC3, kernel);
	//Mat imageRGB[3];
	//split(image, imageRGB);
	//for (int i = 0; i < 3; i++)
	//{
	//	equalizeHist(imageRGB[i], imageRGB[i]);
	//}
	//merge(imageRGB, 3, image);
	Mat result_cnn = image.clone();
	//if (image.empty())
	//{
	//	fprintf(stderr, "Can not load the image file %s.\n", argv[1]);
	//	return -1;
	//}

	int * pResults = NULL;
	//pBuffer is used in the detection functions.
	//If you call functions in multiple threads, please create one buffer for each thread!
	unsigned char * pBuffer = (unsigned char *)malloc(DETECT_BUFFER_SIZE);
	if (!pBuffer)
	{
		fprintf(stderr, "Can not alloc buffer.\n");
		return -1;
	}


	///////////////////////////////////////////
	// CNN face detection 
	// Best detection rate
	//////////////////////////////////////////
	//!!! The input image must be a BGR one (three-channel) instead of RGB
	//!!! DO NOT RELEASE pResults !!!
	pResults = facedetect_cnn(pBuffer, (unsigned char*)(image.ptr(0)), image.cols, image.rows, (int)image.step);

	printf("%d faces detected.\n", (pResults ? *pResults : 0));
	
	//print the detection results
	float walpha = 0.8;
	float halpha = 0.8;
	for (int i = 0; i < (pResults ? *pResults : 0); i++)
	{
		short * p = ((short*)(pResults + 1)) + 142 * i;
		int x = p[0] + (1 - walpha)*p[2] / 2;
		int y = p[1] + (1 - halpha)*p[3] / 2;
		int w = walpha*p[2];
		int h = halpha*p[3];
		int confidence = p[4];
		int angle = p[5];

		printf("face_rect=[%d, %d, %d, %d], confidence=%d, angle=%d\n", x, y, w, h, confidence, angle);

		rectangle(result_cnn, Rect(x, y, w, h), Scalar(0, 255, 0), 2);
	}
	imshow("result_cnn", result_cnn);

	waitKey();

	//release the buffer
	free(pBuffer);

	return 0;
}

