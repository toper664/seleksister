import sys
import typing
from PyQt5.QtCore import QObject
from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import *
from tokofoto import *

# warning: kode spaghetti italiano mamma mia

# todo
# link ui ke cuda
# kamera
# save image
# apply edits

# ini diajarin (baca: dikasih referensi kodenya) bang awe juga
class Camera(QObject):

    ready = pyqtSignal()
    refreshed = pyqtSignal(np.ndarray)
    disabled = pyqtSignal()

    def __init__(self):

        super().__init__()
        self.on = False
    
    def enable(self):
        
        self.on = True
        camera = cv2.VideoCapture(0)
        self.ready.emit()
        while (self.on):
            success, image = camera.read()
            if success:
                image = cv2.flip(image, 1)
                self.refreshed.emit(image)
        self.disabled.emit()
    
    def disable(self):

        self.on = False

class MainWindow(QMainWindow):

    def __init__(self):

        super().__init__()
        
        self.setWindowTitle('Toko Foto "Taisetsu Photograph"')

        self.setFixedSize(1366,768)

        self.contrastval = [0]
        self.saturationval = [100]
        self.blurval = [0]
        self.grayscalemode = [False]
        self.edgemode = [False]
        self.cameramode = [False]

        self.image_path = ""

        image_label = QLabel(self)
        image_label.resize(1280,720)
        image_label.setAlignment(Qt.AlignCenter)
        self.image_label = image_label

        self.setCentralWidget(image_label)
        
        menu = self.menuBar()
        self.menu = menu

        open_button = QAction("Open", self)
        open_button.triggered.connect(self.open_image)
        self.open_button = open_button

        save_button = QAction("Save", self)
        save_button.triggered.connect(self.save_image)
        save_button.setDisabled(True)
        self.save_button = save_button
        

        save_as_button = QAction("Save As", self)
        save_as_button.triggered.connect(self.save_as_image)
        save_as_button.setDisabled(True)
        self.save_as_button = save_as_button

        camera_button = QAction("Camera Mode", self)
        camera_button.setCheckable(True)
        camera_button.toggled.connect(self.onCameraToggle)
        self.camera_button = camera_button

        grayscale_button = QAction("Greyscale", self)
        grayscale_button.setCheckable(True)
        grayscale_button.toggled.connect(lambda: self.onToggleClick(grayscale_button,self.grayscalemode))
        grayscale_button.setDisabled(True)
        self.grayscale_button = grayscale_button
        
        contrast_button = QAction("Contrast", self)
        contrast_button.triggered.connect(lambda: self.onSliderClick("Contrast",-255,255,self.contrastval))
        contrast_button.setDisabled(True)
        self.contrast_button = contrast_button

        saturation_button = QAction("Saturation", self)
        saturation_button.triggered.connect(lambda: self.onSliderClick("Saturation",0,200,self.saturationval))
        saturation_button.setDisabled(True)
        self.saturation_button = saturation_button

        edge_button = QAction("Edge Detection", self)
        edge_button.setCheckable(True)
        edge_button.toggled.connect(lambda: self.onToggleClick(edge_button,self.edgemode))
        edge_button.setDisabled(True)
        self.edge_button = edge_button
        
        blur_button = QAction("Blur", self)
        blur_button.triggered.connect(lambda: self.onSliderClick("Blur",0,10,self.blurval))
        blur_button.setDisabled(True)
        self.blur_button = blur_button

        file_menu = menu.addMenu("File")
        file_menu.addAction(open_button)
        file_menu.addAction(save_button)
        file_menu.addAction(save_as_button)
        file_menu.addSeparator()
        file_menu.addAction(camera_button)

        adjustments_menu = menu.addMenu("Adjustments")
        adjustments_menu.addAction(grayscale_button)
        adjustments_menu.addAction(contrast_button)
        adjustments_menu.addAction(saturation_button)

        effects_menu = menu.addMenu("Effects")
        effects_menu.addAction(edge_button)
        effects_menu.addAction(blur_button)

        toolbar = QToolBar()
        
        self.addToolBar(Qt.BottomToolBarArea,toolbar)

        spacer = QWidget()
        spacer.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        toolbar.addWidget(spacer)

        apply_button = QAction("Apply Edits",self)
        apply_button.triggered.connect(self.apply_image)
        apply_button.setDisabled(True)
        self.apply_button = apply_button

        # jinsei risetto botan
        reset_button = QAction("Reset Edits",self)
        reset_button.triggered.connect(self.reset_vals)
        reset_button.triggered.connect(self.update_preview)
        reset_button.setDisabled(True)
        self.reset_button = reset_button

        toolbar.addAction(reset_button)

        toolbar.addAction(apply_button)
        
        toolbar.setMovable(False)
        toolbar.setFloatable(False)

        self.cameraThread = QThread()
        self.camera = Camera()
        self.camera.ready.connect(self.camera_ready)
        self.camera.refreshed.connect(self.camera_refresh)
        self.camera.disabled.connect(self.camera_disabled)
        self.camera.moveToThread(self.cameraThread)
        self.cameraThread.started.connect(self.camera.enable)
    
    def apply_image(self):

        self.applied_image = self.preview_image

        self.reset_vals()

        self.update_preview()

    def onCameraToggle(self,checked):
        
        if (checked):

            self.open_button.setDisabled(True)
            self.save_button.setDisabled(True)
            self.save_as_button.setDisabled(True)
            self.blur_button.setDisabled(True)
            self.grayscale_button.setDisabled(True)
            self.contrast_button.setDisabled(True)
            self.edge_button.setDisabled(True)
            self.saturation_button.setDisabled(True)
            self.apply_button.setDisabled(True)
            self.save_button.setDisabled(True)
            self.save_as_button.setDisabled(True)
            self.reset_button.setDisabled(True)
            

            self.cameramode[0] = True

            self.cameraThread.start()

        else:

            self.open_button.setDisabled(False)
            self.save_button.setDisabled(True)
            self.save_as_button.setDisabled(True)
            self.blur_button.setDisabled(True)
            self.grayscale_button.setDisabled(True)
            self.contrast_button.setDisabled(True)
            self.edge_button.setDisabled(True)
            self.saturation_button.setDisabled(True)
            self.apply_button.setDisabled(True)
            self.save_button.setDisabled(True)
            self.save_as_button.setDisabled(True)
            self.reset_button.setDisabled(True)

            self.reset_vals()
            self.cameramode = [False]

            self.camera.disable()

    def camera_ready(self):

        self.blur_button.setDisabled(False)
        self.grayscale_button.setDisabled(False)
        self.contrast_button.setDisabled(False)
        self.edge_button.setDisabled(False)
        self.saturation_button.setDisabled(False)
        self.reset_button.setDisabled(False)

        self.image_path = ""
        self.image_label.clear()

    def camera_refresh(self,image):

        self.preview_image = image

        self.update_preview()

    def camera_disabled(self):

        self.cameraThread.quit()
        self.cameraThread.wait()

    def onSliderClick(self,title,min,max,attr):

        self.slider_window = SliderWindow(title,min,max,attr,self)
        self.slider_window.show()

    def onToggleClick(self,button,attr):
        
        attr[0] = button.isChecked()
        self.update_preview()

    def open_image(self):
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getOpenFileName(self, "Pick an image", "", "Images (*.png *.jpg *.bmp);;All Files (*)", options=options)
        if file_name:
            self.load_image(file_name)

    def save_image(self):

        if (self.contrastval[0] != 0 or self.saturationval[0] != 100 or self.blurval[0] != 0 or self.grayscalemode[0] != False or self.edgemode[0] != 0):
            applyDialog = QMessageBox(self)
            applyDialog.setWindowTitle("Apply edits?")
            applyDialog.setText("Would you like to apply your edits first?")
            applyDialog.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
            applyDialog.setIcon(QMessageBox.Question)
            applyDialog.setWindowModality(Qt.ApplicationModal)
            button = applyDialog.exec()

            if button == QMessageBox.Yes:
                self.apply_image()

        cv2.imwrite(self.image_path,self.applied_image)

    def save_as_image(self):

        if (self.contrastval[0] != 0 or self.saturationval[0] != 100 or self.blurval[0] != 0 or self.grayscalemode[0] != False or self.edgemode[0] != 0):
            applyDialog = QMessageBox(self)
            applyDialog.setWindowTitle("Apply edits?")
            applyDialog.setText("Would you like to apply your edits first?")
            applyDialog.setStandardButtons(QMessageBox.Yes | QMessageBox.No)
            applyDialog.setIcon(QMessageBox.Question)
            applyDialog.setWindowModality(Qt.ApplicationModal)
            button = applyDialog.exec()

            if button == QMessageBox.Yes:
                self.apply_image()
        
        options = QFileDialog.Options()
        file_name, _ = QFileDialog.getSaveFileName(self, "Save File", "", "Images (*.png *.jpg *.bmp);;All Files (*)", options=options)
        if file_name:
            self.image_path = file_name
            cv2.imwrite(self.image_path,self.applied_image)

    def reset_vals(self):

        self.contrastval = [0]
        self.saturationval = [100]
        self.blurval = [0]
        self.grayscalemode = [False]
        self.grayscale_button.setChecked(False)
        self.edgemode = [False]
        self.edge_button.setChecked(False)
        

    def load_image(self,file_name):

        self.image_path = file_name
        self.applied_image = cv2.imread(self.image_path)
        self.preview_image = self.applied_image

        self.reset_vals()

        rgb_image = cv2.cvtColor(self.preview_image, cv2.COLOR_BGR2RGB)

        self.height, self.width, self.channel = rgb_image.shape
        self.bytes_per_line = 3 * self.width

        q_image = QImage(rgb_image.data, self.width, self.height, self.bytes_per_line, QImage.Format_RGB888)

        pixmap = QPixmap.fromImage(q_image)

        aspect_ratio = pixmap.width() / pixmap.height()

        if 1280 / 720 > aspect_ratio:
            self.pic_scale = int(720 * aspect_ratio)
            self.image_label.setPixmap(pixmap.scaledToWidth(self.pic_scale))
            self.pic_scale_method = "width"
        else:
            self.pic_scale = int(1280 / aspect_ratio)
            self.image_label.setPixmap(pixmap.scaledToHeight(self.pic_scale))
            self.pic_scale_method = "height"

        self.blur_button.setDisabled(False)
        self.grayscale_button.setDisabled(False)
        self.contrast_button.setDisabled(False)
        self.edge_button.setDisabled(False)
        self.saturation_button.setDisabled(False)
        self.apply_button.setDisabled(False)
        self.save_button.setDisabled(False)
        self.save_as_button.setDisabled(False)
        self.reset_button.setDisabled(False)

    def update_preview(self):

        if not self.cameramode[0]:
            self.preview_image = self.applied_image

        if self.grayscalemode[0]:
            self.preview_image = filter(self.preview_image.astype(np.float32),"grayscale")
        if self.edgemode[0]:
            self.preview_image = filter(self.preview_image.astype(np.float32),"edge_detection")
        
        if self.contrastval[0] != 0:
            self.preview_image = filter(self.preview_image.astype(np.float32),"contrast",self.contrastval[0])
        if self.saturationval[0] != 100:    
            self.preview_image = filter(self.preview_image.astype(np.float32),"saturation",self.saturationval[0])
        if self.blurval[0] != 0:    
            self.preview_image = filter(self.preview_image.astype(np.float32),"blur",self.blurval[0])

        rgb_image = cv2.cvtColor(self.preview_image, cv2.COLOR_BGR2RGB)

        self.height, self.width, self.channel = rgb_image.shape
        self.bytes_per_line = 3 * self.width

        q_image = QImage(rgb_image.data, self.width, self.height, self.bytes_per_line, QImage.Format_RGB888)

        pixmap = QPixmap.fromImage(q_image)

        aspect_ratio = pixmap.width() / pixmap.height()

        if 1280 / 720 > aspect_ratio:
            self.pic_scale = int(720 * aspect_ratio)
            self.image_label.setPixmap(pixmap.scaledToWidth(self.pic_scale))
        else:
            self.pic_scale = int(1280 / aspect_ratio)
            self.image_label.setPixmap(pixmap.scaledToHeight(self.pic_scale))

        loop = QEventLoop()
        QTimer.singleShot(0, loop.quit)
        loop.exec_()

class SliderWindow(QWidget):

    def __init__(self,title,min,max,variable_ref,mainwindow,parent=None):

        super().__init__(parent)

        self.ok = False

        self.setWindowTitle(title)

        self.setWindowModality(Qt.ApplicationModal)

        self.layout = QVBoxLayout()

        self.variable_ref = variable_ref
        self.original_val = self.variable_ref[0]

        self.slider_layout = QHBoxLayout()

        self.slider = QSlider(Qt.Horizontal)
        self.slider.setRange(min,max)
        self.slider.setValue(self.original_val)
        self.slider.valueChanged.connect(self.update_spinbox)
        self.slider_layout.addWidget(self.slider)

        self.spinbox = QSpinBox()
        self.spinbox.setRange(min,max)
        self.spinbox.setValue(self.original_val)
        self.spinbox.valueChanged.connect(self.update_slider)
        self.slider_layout.addWidget(self.spinbox)

        self.layout.addLayout(self.slider_layout)

        # Buttons
        self.buttons_layout = QHBoxLayout()

        self.ok_button = QPushButton("OK")
        self.ok_button.clicked.connect(self.accept_changes)
        self.buttons_layout.addWidget(self.ok_button)

        self.cancel_button = QPushButton("Cancel")
        self.cancel_button.clicked.connect(self.reset_changes)
        self.buttons_layout.addWidget(self.cancel_button)

        self.layout.addLayout(self.buttons_layout)
        self.setLayout(self.layout)

        self.temp_value = self.original_val

        self.mainWindow = mainwindow

    def update_spinbox(self):
        self.temp_value = self.slider.value()
        self.spinbox.setValue(self.temp_value)
        self.update_variable()

    def update_slider(self):
        self.temp_value = self.spinbox.value()
        self.slider.setValue(self.temp_value)
        self.update_variable()
    
    def update_variable(self):
        self.variable_ref[0] = self.temp_value
        self.mainWindow.update_preview()

    def accept_changes(self):
        self.ok = True
        self.close()

    def reset_changes(self):
        self.variable_ref[0] = self.original_val
        self.slider.setValue(self.original_val)
        self.spinbox.setValue(self.original_val)
        self.close()

    def closeEvent(self, event):
        # Reset changes if the window is closed without using OK button
        if (not self.ok):
            self.reset_changes()
        self.mainWindow.update_preview()
    
if __name__ == "__main__":
    app = QApplication(sys.argv)
    w = MainWindow()
    w.show()
    app.exec()