# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'slide_scanner_test01.ui'
#
# Created by: PyQt5 UI code generator 5.15.4
#
# WARNING: Any manual changes made to this file will be lost when pyuic5 is
# run again.  Do not edit this file unless you know what you are doing.


from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QFileDialog


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.setWindowModality(QtCore.Qt.WindowModal)
        MainWindow.resize(1024, 768)
        font = QtGui.QFont()
        font.setPointSize(8)
        MainWindow.setFont(font)
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap("C:/Windows/System32/cmd.exe/logo-smi.gif"), QtGui.QIcon.Normal, QtGui.QIcon.Off)
        MainWindow.setWindowIcon(icon)
        MainWindow.setAutoFillBackground(False)
        MainWindow.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.logoView = QtWidgets.QGraphicsView(self.centralwidget)
        self.logoView.setGeometry(QtCore.QRect(10, 30, 50, 50))
        self.logoView.setAutoFillBackground(False)
        brush = QtGui.QBrush(QtGui.QColor(0, 0, 0))
        brush.setStyle(QtCore.Qt.NoBrush)
        self.logoView.setForegroundBrush(brush)
        self.logoView.setViewportUpdateMode(QtWidgets.QGraphicsView.SmartViewportUpdate)
        self.logoView.setObjectName("logoView")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(70, 20, 591, 71))
        font = QtGui.QFont()
        font.setPointSize(24)
        self.label.setFont(font)
        self.label.setStyleSheet("color: rgb(0, 0, 0);\n"
"")
        self.label.setObjectName("label")
        self.slideImageView = QtWidgets.QLabel(self.centralwidget)
        self.slideImageView.setGeometry(QtCore.QRect(20, 180, 640, 512))
        self.slideImageView.setBaseSize(QtCore.QSize(640, 512))
        self.slideImageView.setStyleSheet("background-color: rgb(85, 255, 127);")
        self.slideImageView.setObjectName("slideImageView")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(210, 130, 291, 31))
        font = QtGui.QFont()
        font.setPointSize(18)
        self.label_2.setFont(font)
        self.label_2.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_2.setObjectName("label_2")
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton.setEnabled(True)
        self.pushButton.setGeometry(QtCore.QRect(670, 610, 171, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton.sizePolicy().hasHeightForWidth())
        self.pushButton.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton.setFont(font)
        self.pushButton.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton.setCheckable(False)
        self.pushButton.setAutoDefault(False)
        self.pushButton.setObjectName("pushButton")
        self.pushButton_2 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_2.setGeometry(QtCore.QRect(850, 610, 161, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_2.sizePolicy().hasHeightForWidth())
        self.pushButton_2.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_2.setFont(font)
        self.pushButton_2.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_2.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_2.setObjectName("pushButton_2")
        self.pushButton_3 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_3.setGeometry(QtCore.QRect(670, 400, 51, 21))
        self.pushButton_3.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_3.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_3.setObjectName("pushButton_3")
        self.pushButton_4 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_4.setGeometry(QtCore.QRect(740, 350, 51, 23))
        self.pushButton_4.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_4.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_4.setCheckable(False)
        self.pushButton_4.setAutoDefault(True)
        self.pushButton_4.setObjectName("pushButton_4")
        self.pushButton_5 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_5.setGeometry(QtCore.QRect(740, 450, 51, 23))
        self.pushButton_5.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_5.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_5.setObjectName("pushButton_5")
        self.pushButton_6 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_6.setGeometry(QtCore.QRect(810, 400, 51, 23))
        self.pushButton_6.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_6.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_6.setObjectName("pushButton_6")
        self.pushButton_7 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_7.setGeometry(QtCore.QRect(920, 350, 75, 23))
        self.pushButton_7.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_7.setAutoFillBackground(False)
        self.pushButton_7.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_7.setObjectName("pushButton_7")
        self.pushButton_8 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_8.setGeometry(QtCore.QRect(920, 450, 75, 23))
        self.pushButton_8.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_8.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_8.setObjectName("pushButton_8")
        self.label_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(730, 260, 221, 71))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.label_3.sizePolicy().hasHeightForWidth())
        self.label_3.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_3.setFont(font)
        self.label_3.setStyleSheet("color: rgb(0,0,0);")
        self.label_3.setObjectName("label_3")
        self.lineEdit = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit.setGeometry(QtCore.QRect(800, 490, 113, 20))
        self.lineEdit.setStyleSheet("QLineEdit {\n"
"    background: rgb(255, 255, 255);\n"
"    border: 2px solid rgb(190, 190, 190);\n"
"    border-radius: 10px;\n"
"}\n"
"\n"
"QLineEdit:focus{\n"
"    border:2px solid rgb(0,0,0);\n"
"}")
        self.lineEdit.setObjectName("lineEdit")
        self.label_4 = QtWidgets.QLabel(self.centralwidget)
        self.label_4.setGeometry(QtCore.QRect(690, 490, 91, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_4.setFont(font)
        self.label_4.setStyleSheet("color: rgb(0,0,0);")
        self.label_4.setObjectName("label_4")
        self.label_5 = QtWidgets.QLabel(self.centralwidget)
        self.label_5.setGeometry(QtCore.QRect(690, 550, 91, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_5.setFont(font)
        self.label_5.setStyleSheet("color: rgb(0,0,0);")
        self.label_5.setObjectName("label_5")
        self.lineEdit_2 = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit_2.setGeometry(QtCore.QRect(800, 550, 113, 21))
        self.lineEdit_2.setStyleSheet("QLineEdit {\n"
"    background: rgb(255, 255, 255);\n"
"    border: 2px solid rgb(190, 190, 190);\n"
"    border-radius: 10px;\n"
"}\n"
"\n"
"QLineEdit:focus{\n"
"    border:2px solid rgb(0,0,0);\n"
"}")
        self.lineEdit_2.setObjectName("lineEdit_2")
        self.label_6 = QtWidgets.QLabel(self.centralwidget)
        self.label_6.setGeometry(QtCore.QRect(690, 520, 91, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_6.setFont(font)
        self.label_6.setStyleSheet("color: rgb(0,0,0);")
        self.label_6.setObjectName("label_6")
        self.lineEdit_3 = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit_3.setGeometry(QtCore.QRect(800, 520, 113, 20))
        self.lineEdit_3.setStyleSheet("QLineEdit {\n"
"    background: rgb(255, 255, 255);\n"
"    border: 2px solid rgb(190, 190, 190);\n"
"    border-radius: 10px;\n"
"}\n"
"\n"
"QLineEdit:focus{\n"
"    border:2px solid rgb(0,0,0);\n"
"}")
        self.lineEdit_3.setObjectName("lineEdit_3")
        self.pushButton_9 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_9.setGeometry(QtCore.QRect(930, 490, 75, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_9.setFont(font)
        self.pushButton_9.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_9.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_9.setObjectName("pushButton_9")
        self.pushButton_10 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_10.setGeometry(QtCore.QRect(930, 520, 75, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_10.setFont(font)
        self.pushButton_10.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_10.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_10.setObjectName("pushButton_10")
        self.pushButton_11 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_11.setGeometry(QtCore.QRect(930, 550, 75, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_11.setFont(font)
        self.pushButton_11.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_11.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_11.setObjectName("pushButton_11")
        self.pushButton_12 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_12.setGeometry(QtCore.QRect(950, 220, 61, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_12.setFont(font)
        self.pushButton_12.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_12.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_12.setObjectName("pushButton_12")
        self.label_7 = QtWidgets.QLabel(self.centralwidget)
        self.label_7.setGeometry(QtCore.QRect(670, 220, 151, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_7.setFont(font)
        self.label_7.setStyleSheet("color: rgb(0,0,0);")
        self.label_7.setAlignment(QtCore.Qt.AlignCenter)
        self.label_7.setObjectName("label_7")
        self.lineEdit_4 = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit_4.setGeometry(QtCore.QRect(830, 220, 113, 20))
        self.lineEdit_4.setAutoFillBackground(False)
        self.lineEdit_4.setStyleSheet("QLineEdit {\n"
"    background: rgb(255, 255, 255);\n"
"    border: 2px solid rgb(190, 190, 190);\n"
"    border-radius: 10px;\n"
"}\n"
"\n"
"QLineEdit:focus{\n"
"    border:2px solid rgb(0,0,0);\n"
"}")
        self.lineEdit_4.setObjectName("lineEdit_4")
        self.pushButton_13 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_13.setEnabled(True)
        self.pushButton_13.setGeometry(QtCore.QRect(670, 690, 121, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_13.sizePolicy().hasHeightForWidth())
        self.pushButton_13.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_13.setFont(font)
        self.pushButton_13.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_13.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_13.setCheckable(False)
        self.pushButton_13.setAutoDefault(False)
        self.pushButton_13.setObjectName("pushButton_13")
        self.label_8 = QtWidgets.QLabel(self.centralwidget)
        self.label_8.setGeometry(QtCore.QRect(670, 180, 131, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_8.setFont(font)
        self.label_8.setStyleSheet("color: rgb(0,0,0);")
        self.label_8.setObjectName("label_8")
        self.lineEdit_5 = QtWidgets.QLineEdit(self.centralwidget)
        self.lineEdit_5.setGeometry(QtCore.QRect(830, 180, 113, 20))
        self.lineEdit_5.setStyleSheet("QLineEdit {\n"
"    background: rgb(255, 255, 255);\n"
"    border: 2px solid rgb(190, 190, 190);\n"
"    border-radius: 10px;\n"
"}\n"
"\n"
"QLineEdit:focus{\n"
"    border:2px solid rgb(0,0,0);\n"
"}")
        self.lineEdit_5.setObjectName("lineEdit_5")
        self.pushButton_14 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_14.setGeometry(QtCore.QRect(950, 180, 61, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_14.setFont(font)
        self.pushButton_14.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_14.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_14.setObjectName("pushButton_14")
        self.label_9 = QtWidgets.QLabel(self.centralwidget)
        self.label_9.setGeometry(QtCore.QRect(740, 0, 161, 31))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_9.setFont(font)
        self.label_9.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_9.setObjectName("label_9")
        self.label_10 = QtWidgets.QLabel(self.centralwidget)
        self.label_10.setGeometry(QtCore.QRect(750, 40, 101, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_10.setFont(font)
        self.label_10.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_10.setObjectName("label_10")
        self.label_11 = QtWidgets.QLabel(self.centralwidget)
        self.label_11.setGeometry(QtCore.QRect(750, 70, 101, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_11.setFont(font)
        self.label_11.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_11.setObjectName("label_11")
        self.label_12 = QtWidgets.QLabel(self.centralwidget)
        self.label_12.setGeometry(QtCore.QRect(750, 100, 91, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_12.setFont(font)
        self.label_12.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_12.setObjectName("label_12")
        self.label_13 = QtWidgets.QLabel(self.centralwidget)
        self.label_13.setGeometry(QtCore.QRect(870, 40, 81, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_13.setFont(font)
        self.label_13.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_13.setObjectName("label_13")
        self.label_14 = QtWidgets.QLabel(self.centralwidget)
        self.label_14.setGeometry(QtCore.QRect(870, 70, 81, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_14.setFont(font)
        self.label_14.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_14.setObjectName("label_14")
        self.label_15 = QtWidgets.QLabel(self.centralwidget)
        self.label_15.setGeometry(QtCore.QRect(870, 100, 81, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_15.setFont(font)
        self.label_15.setStyleSheet("color: rgb(0, 0, 0);")
        self.label_15.setObjectName("label_15")
        self.pushButton_17 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_17.setEnabled(True)
        self.pushButton_17.setGeometry(QtCore.QRect(800, 690, 211, 41))
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_17.sizePolicy().hasHeightForWidth())
        self.pushButton_17.setSizePolicy(sizePolicy)
        font = QtGui.QFont()
        font.setPointSize(12)
        font.setBold(False)
        font.setWeight(50)
        self.pushButton_17.setFont(font)
        self.pushButton_17.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_17.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_17.setCheckable(False)
        self.pushButton_17.setAutoDefault(False)
        self.pushButton_17.setObjectName("pushButton_17")
        self.pushButton_18 = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_18.setGeometry(QtCore.QRect(730, 140, 191, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_18.setFont(font)
        self.pushButton_18.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_18.setStyleSheet("QPushButton{\n"
"      color: rgb(255, 255, 255);\n"
"      background-color: rgb(0, 0, 120);\n"
"      border-radius:10px;\n"
"}\n"
"QPushButton:hover{\n"
"       background-color: rgb(0, 0, 0);\n"
"}")
        self.pushButton_18.setObjectName("pushButton_18")
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

       # self.pushButton.clicked.connect(self.show_popup)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)



    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Slide Scanner - ShanMukha Innovations Pvt Ltd"))
        self.label.setText(_translate("MainWindow", "ShanMukha Innovations Pvt Ltd"))
        self.label_2.setText(_translate("MainWindow", "Live Preview of Silde"))
        self.pushButton.setText(_translate("MainWindow", "Take a Snapshot"))
        self.pushButton_2.setText(_translate("MainWindow", "Auto-Focus"))
        self.pushButton_3.setText(_translate("MainWindow", "X-"))
        self.pushButton_4.setText(_translate("MainWindow", "Y-"))
        self.pushButton_5.setText(_translate("MainWindow", "Y+"))
        self.pushButton_6.setText(_translate("MainWindow", "X+"))
        self.pushButton_7.setText(_translate("MainWindow", "Z - UP"))
        self.pushButton_8.setText(_translate("MainWindow", "Z - DOWN"))
        self.label_3.setText(_translate("MainWindow", "Slide Movement Controls"))
        self.label_4.setText(_translate("MainWindow", "X position"))
        self.label_5.setText(_translate("MainWindow", "Z position"))
        self.label_6.setText(_translate("MainWindow", "Y position"))
        self.pushButton_9.setText(_translate("MainWindow", "Go to X"))
        self.pushButton_10.setText(_translate("MainWindow", "Go to Y"))
        self.pushButton_11.setText(_translate("MainWindow", "Go to Z"))
        self.pushButton_12.setText(_translate("MainWindow", "Set"))
        self.label_7.setText(_translate("MainWindow", "Exposure (in ms)"))
        self.pushButton_13.setText(_translate("MainWindow", "WSI Scan"))
        self.label_8.setText(_translate("MainWindow", "Slide Name"))
        self.pushButton_14.setText(_translate("MainWindow", "Set"))
        self.label_9.setText(_translate("MainWindow", "Current Positions"))
        self.label_10.setText(_translate("MainWindow", "X position:"))
        self.label_11.setText(_translate("MainWindow", "Y position:"))
        self.label_12.setText(_translate("MainWindow", "Z position:"))
        self.label_13.setText(_translate("MainWindow", "0"))
        self.label_14.setText(_translate("MainWindow", "0"))
        self.label_15.setText(_translate("MainWindow", "0"))
        self.pushButton_17.setText(_translate("MainWindow", "Best Region Scanning"))
        self.pushButton_18.setText(_translate("MainWindow", "Set as Origin"))


    def show_popup(self):
        fname, filter = QFileDialog.getSaveFileName(MainWindow, 'Save File', 'C:\\', "Image Files (*.jpg)")



if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
