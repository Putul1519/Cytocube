    def areascan(self):
        self.autoFocus()
        self.snapshot()
        self.ser.write(b'A')
        self.currxpos = self.currxpos + self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'A')
        self.currxpos = self.currxpos + self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'A')
        self.currxpos = self.currxpos + self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'A')
        self.currxpos = self.currxpos + self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.autoFocus()
        self.snapshot()
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.ser.write(b'S')
        self.currypos = self.currypos - self.yFov
        self.label_14.setText(self._translate("MainWindow", str(self.currypos)))
        self.autoFocus()
        self.snapshot()
        self.ser.write(b'D')
        self.currxpos = self.currxpos - self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'D')
        self.currxpos = self.currxpos - self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'D')
        self.currxpos = self.currxpos - self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.ser.write(b'D')
        self.currxpos = self.currxpos - self.xFov
        self.label_13.setText(self._translate("MainWindow", str(self.currxpos)))
        self.autoFocus()
        self.snapshot()


