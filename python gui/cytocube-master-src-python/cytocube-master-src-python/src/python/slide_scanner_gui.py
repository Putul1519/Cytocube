from PyQt5 import QtCore,QtGui,QtWidgets
import sys
import slide_scanner_test
import numpy as np
import cv2
import threading, time
from ximea import xiapi
import toQImage, PIL.Image
import serial


class gui(QtWidgets.QMainWindow,slide_scanner_test.Ui_MainWindow):
    def __init__(self,parent=None):
        super(gui,self).__init__(parent)
        self.setupUi(self)
        self.connectActions()
    def main(self):
        self.logoView.setPixmap(QtGui.QPixmap("0.jpg").scaled(50,50))
        self.cam = xiapi.Camera()
        self.cam.open_device()
        self.cam.set_exposure(2000)
        self.cam.set_imgdataformat('XI_RGB24')
        self.img = xiapi.Image()
        self.cam.start_acquisition()
        self.livePreview = threading.Thread(name='cam_initialization',target=self.openCam,args=())
        self.livePreview.start()
        self.connect2arduino = threading.Thread(name='connect_arduino',target=self.connectArduino,args=())
        self.connect2arduino.start()
        self.currxpos = 0; self.currypos = 0; self.currzpos = 0
        self.xFov = 1255; self.yFov = 1004; self.ymiddle = 40000;#round((12.5*self.yFov)/0.1596);
        self.x0 = 0; self.x1 = 210000;#round((45*self.xFov)/0.1995);
        self.y0 = 0; self.y1 = 80000;#round((12*self.yFov)/0.1596);
        self.Zpulserate = 38400;self.Xpulserate = 38400;self.Ypulserate = 38400
        self._translate = QtCore.QCoreApplication.translate
        self.show()
        
    def connectActions(self):
        self.pushButton.clicked.connect(self.snapshot)
        self.pushButton_2.clicked.connect(self.autoFocus)
        self.pushButton_3.clicked.connect(self.xPlus)
        self.pushButton_4.clicked.connect(self.yMinus)
        self.pushButton_5.clicked.connect(self.yPlus)
        self.pushButton_6.clicked.connect(self.xMinus)
        self.pushButton_7.clicked.connect(self.zUp)
        self.pushButton_8.clicked.connect(self.zDown)
        self.pushButton_9.clicked.connect(lambda: self.gotoX(self.lineEdit.text()))
        self.pushButton_10.clicked.connect(lambda: self.gotoY(self.lineEdit_3.text()))
        self.pushButton_11.clicked.connect(lambda: self.gotoZ(self.lineEdit_2.text()))
        self.pushButton_12.clicked.connect(lambda: self.setExposure(self.lineEdit_4.text()))
        self.pushButton_13.clicked.connect(self.test)
        self.pushButton_17.clicked.connect(self.bloodsmear)
        self.pushButton_18.clicked.connect(self.resetOrigin)
        
    def openCam(self):
        while True:
            self.cam.get_image(self.img)
            self.data = self.img.get_image_data_numpy(invert_rgb_order=True)
            self.pixmap = QtGui.QPixmap.fromImage(toQImage.toQImage(self.data))
            self.slideImageView.setPixmap(self.pixmap.scaled(680,520))
    
    def connectArduino(self):
        self.ser = serial.Serial('COM3',57600)
        #self.ser.open()

    def setExposure(self, value):
        self.cam.set_exposure(int(value))
        
    def resetOrigin(self):
        self.currxpos = 0
        self.currypos = 0
        self.currzpos = 0
        self.ser.write(b'X')
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.label_15.setText(self._translate("MainWindow", str(self.currzpos)))
    def snapshot(self):
        snapshot = PIL.Image.fromarray(self.data,'RGB')
        snapshot.save('snap.jpg')
        
    def autoFocus(self):
        ts_start = time.time()
        # Crude Auto-Focus
        Z_travel_for_crude = 16000;  crude_step_count = 500;
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_max_var=0;    crude_loc_max_var=0;
        crude_start_loc = self.currzpos -(Z_travel_for_crude/2);
        self.gotoZ(crude_start_loc);
        crude_curr_loc = crude_start_loc;
        kernel = np.ones((5,5),np.float32)/9
        for i in range(int(crude_pulse_count)):
            snapshot = self.data
            crude_curr_var = np.var(cv2.filter2D(snapshot,-1,kernel))
            print(crude_curr_var,'||',self.currzpos)
            if crude_curr_var > crude_max_var:
                crude_max_var = crude_curr_var
                crude_loc_max_var = crude_curr_loc
            crude_curr_loc = crude_curr_loc + crude_step_count
            self.gotoZ(crude_curr_loc)
            time.sleep(0.175)
        self.gotoZ(crude_loc_max_var)
        # Fine-crude AF
        Z_travel_for_crude = 1000;  crude_step_count = 50;
        crude_loc_max_var = 0; crude_max_var = 0
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_start_loc = self.currzpos - (Z_travel_for_crude/2);
        self.gotoZ(crude_start_loc);
        crude_curr_loc = crude_start_loc;
        for i in range(int(crude_pulse_count)):
            snapshot = self.data
            crude_curr_var = np.var(cv2.filter2D(snapshot,-1,kernel))
            print(crude_curr_var,'||',self.currzpos)
            if crude_curr_var > crude_max_var:
                crude_max_var = crude_curr_var
                crude_loc_max_var = crude_curr_loc
            crude_curr_loc = crude_curr_loc + crude_step_count
            self.gotoZ(crude_curr_loc)
            time.sleep(0.075)
        self.gotoZ(crude_loc_max_var)
        # Fine AF
        Z_travel_for_crude = 120;  crude_step_count = 5;
        crude_loc_max_var = 0;crude_max_var = 0
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_start_loc = self.currzpos - (Z_travel_for_crude/2);
        self.gotoZ(crude_start_loc);
        crude_curr_loc = crude_start_loc;
        for i in range(int(crude_pulse_count)):
            snapshot = self.data
            crude_curr_var = np.var(snapshot)
            print(crude_curr_var,'||',self.currzpos)
            if crude_curr_var > crude_max_var:
                crude_max_var = crude_curr_var
                crude_loc_max_var = crude_curr_loc
            crude_curr_loc = crude_curr_loc + crude_step_count
            self.gotoZ(crude_curr_loc)
            time.sleep(0.025)
        self.gotoZ(crude_loc_max_var)
        ts_stop = time.time()
        print('time taken for autofocusing:'+str(ts_stop-ts_start)+' secs')
        
    def parameter(self):
        image = self.data
        img = cv2.medianBlur(image,5)
        cimg = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
        circles = cv2.HoughCircles(cimg,cv2.HOUGH_GRADIENT,1,35,param1=50,param2=30,minRadius=10,maxRadius=45)
        area = 0
        try:
            circles = np.uint16(np.around(circles));#print('No.of Circles:',len(circles[0,:]))
            for i in circles[0,:]:
                # Total area
                area = area + (3.1415 * i[2] * i[2])
        except:
            print("No circles detected")
        ret,im_th = cv2.threshold(cimg,np.average(cimg),255,cv2.THRESH_BINARY_INV)
        foreground_area = np.count_nonzero(im_th)
        param = area/foreground_area
        if(param == 0):
            return (foreground_area/(1280*1024))
        return param

    def focus(self,travel,step_count):
        ts_start = time.time()
        # FineCrude
        Z_travel_for_crude = travel;  crude_step_count = step_count;
        crude_loc_max_var = 0; crude_max_var = 0
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_start_loc = self.currzpos - (Z_travel_for_crude/2);
        self.gotoZ(crude_start_loc);
        crude_curr_loc = crude_start_loc;
        kernel = np.ones((5,5),np.float32)/9
        for i in range(int(crude_pulse_count)):
            snapshot = self.data
            crude_curr_var = np.var(cv2.filter2D(snapshot,-1,kernel))
            #print(crude_curr_var,'||',self.currzpos)
            if crude_curr_var > crude_max_var:
                crude_max_var = crude_curr_var
                crude_loc_max_var = crude_curr_loc
            crude_curr_loc = crude_curr_loc + crude_step_count
            self.gotoZ(crude_curr_loc)
            time.sleep(0.075)
        self.gotoZ(crude_loc_max_var)
        # Fine AF
        Z_travel_for_crude = step_count*2;  crude_step_count = 3;
        crude_loc_max_var = 0;crude_max_var = 0
        crude_pulse_count = Z_travel_for_crude / crude_step_count;
        crude_start_loc = self.currzpos - (Z_travel_for_crude/2);
        self.gotoZ(crude_start_loc);
        crude_curr_loc = crude_start_loc;
        for i in range(int(crude_pulse_count)):
            snapshot = self.data
            crude_curr_var = np.var(snapshot)
            #print(crude_curr_var,'||',self.currzpos)
            if crude_curr_var > crude_max_var:
                crude_max_var = crude_curr_var
                crude_loc_max_var = crude_curr_loc
            crude_curr_loc = crude_curr_loc + crude_step_count
            self.gotoZ(crude_curr_loc)
            time.sleep(0.025)
        self.gotoZ(crude_loc_max_var)
        ts_stop = time.time()
        print('time taken for autofocusing:'+str(ts_stop-ts_start)+' secs')
        
    #def focalstack(self,travel):
        
        
        
    def xMinus(self):
        self.ser.write(b'D')
        self.currxpos = self.currxpos - self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
    def xPlus(self):
        self.ser.write(b'A')
        self.currxpos = self.currxpos + self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
    def yMinus(self):
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
    def yPlus(self):
        self.ser.write(b'W')
        self.currypos = self.currypos + self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
    def zDown(self):
        self.ser.write(b'G')
        self.currzpos = self.currzpos - 1
        self.label_15.setText(self._translate("MainWindow", str(self.currzpos)))
    def zUp(self):
        self.ser.write(b'T')
        self.currzpos = self.currzpos + 1
        self.label_15.setText(self._translate("MainWindow", str(self.currzpos)))
    def gotoX(self, xValue):
        xValue = int(xValue)
        if self.currxpos != xValue:
            xValue_str = '#' + str("%($)07d" % {"$":xValue})
            self.ser.write(b'B')
            self.ser.write(xValue_str.encode())
            time.sleep(abs(self.currxpos-xValue)/self.Xpulserate)
            self.currxpos = int(xValue)
            self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
    def gotoY(self, yValue):
        yValue = int(yValue)
        if self.currypos != yValue:
            yValue_str = '#' + str("%($)07d" % {"$":yValue})
            self.ser.write(b'N')
            self.ser.write(yValue_str.encode())
            time.sleep(abs(self.currypos-yValue)/self.Ypulserate)
            self.currypos = int(yValue)
            self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
    def gotoZ(self, zValue):
        zValue = int(zValue)
        if self.currzpos != zValue:
            zValue_str = '#' + str("%($)07d" % {"$":zValue})
            self.ser.write(b'M')
            self.ser.write(zValue_str.encode())
            time.sleep(abs(self.currzpos-zValue)/self.Zpulserate)
            self.currzpos = int(zValue)
            self.label_15.setText(self._translate("MainWindow", str(self.currzpos)))

    def bloodsmear(self):
        self.gotoX('0')
        self.gotoY('0')
        self.gotoZ('0')
        self.gotoY(self.ymiddle);time.sleep(2);
        self.autoFocus()
        Zval = []; param_y0 = []; Xpos = [];
        xstep = round((self.x1-self.x0)/11);
        for xpos in range(self.x0,self.x1,xstep):
            self.gotoX(xpos)
            self.focus(2000,50)
            Zval.append(self.currzpos)
            Xpos.append(self.currxpos)
            snap = self.data
            snapshot = PIL.Image.fromarray(snap,'RGB')
            snapshot.save('snap@'+str(xpos)+'.jpg')
            param_y0.append(self.parameter())
        print(np.asarray(param_y0))
        index = np.argmax((param_y0))
        xbest = Xpos[index]
        self.gotoX(Xpos[index])
        self.gotoZ(Zval[index]);time.sleep(2);
        param_y1 = [];Xpos = []; Zval = [];
        if(xbest<=xstep):
            for xpos in range(xbest,xbest+xstep*2,12581):
                self.gotoX(xpos)
                self.focus(500,50)
                Zval.append(self.currzpos)
                Xpos.append(self.currxpos)
                snap = self.data
                snapshot = PIL.Image.fromarray(snap,'RGB')
                snapshot.save('snap@'+str(xpos)+'.jpg')
                param_y1.append(self.parameter())
        elif(xbest>self.x1):
            for xpos in range(xbest-xstep*2,xbest,12581):
                self.gotoX(xpos)
                self.focus(500,50)
                Zval.append(self.currzpos)
                Xpos.append(self.currxpos)
                snap = self.data
                snapshot = PIL.Image.fromarray(snap,'RGB')
                snapshot.save('snap@'+str(xpos)+'.jpg')
                param_y1.append(self.parameter())
        else:
            for xpos in range(xbest-xstep,xbest+xstep,12581):
                self.gotoX(xpos)
                self.focus(500,50)
                Zval.append(self.currzpos)
                Xpos.append(self.currxpos)
                snap = self.data
                snapshot = PIL.Image.fromarray(snap,'RGB')
                snapshot.save('snap@'+str(xpos)+'.jpg')
                param_y1.append(self.parameter())
        index = np.argmax(np.asarray(param_y1))
        param = np.where(np.asarray(param_y1),1,0)
        self.gotoY(0)
        if(np.sum(param[1:4]) == 3):
            x1 = Xpos[1];
            x2 = Xpos[3];
            self.gotoX(x1);self.focus(500,50);self.ser.write(b'R')
            self.gotoX(x2);self.focus(500,50);self.ser.write(b'E')
            self.gotoY(self.y1);self.focus(500,50);self.ser.write(b'Y')
            xA = x1; xB = x2;
            yC = self.y1; yB = 0;
            numofX = round((xB-xA)/self.xFov);
            numofY = round((yC-yB)/self.yFov);
            self.ser.write(b'Z')
            while(self.ser.read() != 'S'):
                print('.')

            rowcount = 0;
            filecount = 0;
            print('Starting Image Capture...')
            while(rowcount <= numofY):
                while(filecount <= numofX):
                    snap = PIL.Image.fromarray(self.data,'RGB')
                    snapshot.save('Image_'+str(rowcount)+'_'+str(filecount)+'.jpg')
                    filecount = filecount + 1
                filecount = 0
                rowcount = rowcount + 1
        elif(np.sum(param[0:3] > np.sum(param[2:5]))):
            x1 = Xpos[0];
            x2 = Xpos[2];
            self.gotoX(x1);self.focus(500,50);self.ser.write(b'R')
            self.gotoX(x2);self.focus(500,50);self.ser.write(b'E')
            self.gotoY(self.y1);self.focus(500,50);self.ser.write(b'Y')
            xA = x1; xB = x2;
            yC = self.y1; yB = 0;
            numofX = round((xB-xA)/self.xFov);
            numofY = round((yC-yB)/self.yFov);
            self.ser.write(b'Z')
            while(self.ser.read() != 'S'):
                print('.')
            rowcount = 0;
            filecount = 0;
            print('Starting Image Capture...')
            while(rowcount <= numofY):
                while(filecount <= numofX):
                    snap = PIL.Image.fromarray(self.data,'RGB')
                    snapshot.save('Image_'+str(rowcount)+'_'+str(filecount)+'.jpg')
                    filecount = filecount + 1
                filecount = 0
                rowcount = rowcount + 1
        elif(np.sum(param[0:3] < np.sum(param[2:5]))):
            x1 = Xpos[2];
            x2 = Xpos[4];
            self.gotoX(x1);self.focus(500,50);self.ser.write(b'R')
            self.gotoX(x2);self.focus(500,50);self.ser.write(b'E')
            self.gotoY(self.y1);self.focus(500,50);self.ser.write(b'Y')
            xA = x1; xB = x2;
            yC = self.y1; yB = 0;
            numofX = round((xB-xA)/self.xFov);
            numofY = round((yC-yB)/self.yFov);
            self.ser.write(b'Z')
            while(self.ser.read() != 'S'):
                print('.')

            rowcount = 0;
            filecount = 0;
            print('Starting Image Capture...')
            while(rowcount <= numofY):
                while(filecount <= numofX):
                    snap = PIL.Image.fromarray(self.data,'RGB')
                    snapshot.save('Image_'+str(rowcount)+'_'+str(filecount)+'.jpg')
                    filecount = filecount + 1
                filecount = 0
                rowcount = rowcount + 1
        else:
            print('No Best region detected!')
        self.resetOrigin()
        
    def test(self):
        #var = round(np.var(self.data))
        #self.label_8.setText(self._translate("MainWindow", str(var)))
        self.focus(500,50)


if __name__ == '__main__' :
    app = QtWidgets.QApplication(sys.argv)
    x = gui()
    x.main()
    sys.exit(app.exec_())
