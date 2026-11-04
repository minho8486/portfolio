import cv2
from cvzone.HandTrackingModule import HandDetector
from cvzone.PoseModule import PoseDetector

import socket
import select

SIZE = 1024

width, height = 1280, 720

# 웹캠
cap = cv2.VideoCapture(0)
cap.set(3, width)
cap.set(4, height)

# 핸드 디텍터
handdetector = HandDetector(maxHands=2, detectionCon=0.8)

# 바디 디텍터
bodydetector = PoseDetector()

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

serverAddressPort = ("127.0.0.1", 5052)  # 자기 자신
data = []

while True:
     # 웹캠 으로 부터 프레임 가져옴?
     success, img = cap.read()

     hands, lmList = handdetector.findHands(img)
     img = bodydetector.findPose(img)

     lmList2, bboxInfo = bodydetector.findPosition(img)
     h, w, _ = img.shape

     data = []
     data1 = []
     totaldata = []

     if bboxInfo and hands:
        hand = hands[0]
        lmList = hand['lmList']

        for lm in lmList2:
            totaldata.extend([lm[0], h - lm[1], lm[2]])
            sock.sendto(str.encode(str(totaldata)), serverAddressPort)

        for lm in lmList:
                totaldata.extend([lm[0], h - lm[1], lm[2]])
                sock.sendto(str.encode(str(totaldata)), serverAddressPort)

     img = cv2.flip(img, 1)
     cv2.imshow("Image", img)
     cv2.waitKey(1)

