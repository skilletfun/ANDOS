# This Python file uses the following encoding: utf-8
import sys
import os
import rsa
import random

from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QObject, pyqtSlot

class Crypter(QObject):
    def __init__(self):
        super(Crypter, self).__init__()
        self.keys = rsa.newkeys(16)

    @pyqtSlot(str, result=str)
    def crypt_alice(self, num):
        return str((int(num)**self.keys[0].e)%self.keys[0].n)

    @pyqtSlot(str, result=str)
    def crypt_bob(self, num):
        self.r = random.randrange(100+1)
        return str((int(num)*(self.r**self.keys[0].e))%self.keys[0].n)

    @pyqtSlot(str, result=str)
    def decrypt_alice(self, num):
        return str((int(num)**self.keys[1].d)%self.keys[0].n)

    @pyqtSlot(str, result=str)
    def decrypt_bob(self, num):
        return str(int((int(num)/self.r)%self.keys[0].n))


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon('DOS.png'))
    engine = QQmlApplicationEngine()

    crypter = Crypter()

    ctx = engine.rootContext()
    ctx.setContextProperty('crypter', crypter)

    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
