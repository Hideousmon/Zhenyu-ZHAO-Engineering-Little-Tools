import tkinter as tk
from tkinter import *
import psutil
import os

### @ https://github.com/arcticfox1919/tkinter-tabview/blob/master/dragwindow.py
class DragWindow(tk.Tk):
    root_x, root_y, abs_x, abs_y = 0, 0, 0, 0
    width, height = None, None

    def __init__(self, topmost=True, alpha=1, bg="white", width=None, height=None):
        super().__init__()
        self["bg"] = bg
        self.width, self.height = width, height
        self.overrideredirect(True)
        self.wm_attributes("-alpha", alpha)      # 透明度
        self.wm_attributes("-toolwindow", True)  # 置为工具窗口
        self.wm_attributes("-topmost", topmost)  # 永远处于顶层
        self.bind('<B1-Motion>', self._on_move)
        self.bind('<ButtonPress-1>', self._on_tap)

    def set_display_postion(self, offset_x, offset_y):
        self.geometry("+%s+%s" % (offset_x, offset_y))

    def set_window_size(self, w, h):
        self.width, self.height = w, h
        self.geometry("%sx%s" % (w, h))

    def _on_move(self, event):
        offset_x = event.x_root - self.root_x
        offset_y = event.y_root - self.root_y

        if self.width and self.height:
            geo_str = "%sx%s+%s+%s" % (self.width, self.height,
                                       self.abs_x + offset_x, self.abs_y + offset_y)
        else:
            geo_str = "+%s+%s" % (self.abs_x + offset_x, self.abs_y + offset_y)
        self.geometry(geo_str)

    def _on_tap(self, event):
        self.root_x, self.root_y = event.x_root, event.y_root
        self.abs_x, self.abs_y = self.winfo_x(), self.winfo_y()


if __name__ == '__main__':
    root = DragWindow()
    root.set_window_size(101, 77)
    root.set_display_postion(500, 400)
    message_cpu =StringVar()
    message_cpu.set('cpu resources')
    label1 = tk.Label(root,textvariable=message_cpu)
    label1.grid( row=0,sticky=E+W)
    message_mem =StringVar()
    message_mem.set('cpu resources')
    label2 = tk.Label(root,textvariable=message_mem)
    label2.grid( row=1,sticky=E+W)

    tk.Button(root, text="取消执行", command=root.quit).grid( row=2,sticky=E+W)

    restored_cpu = 100
    last_restored_cpu = 100

    def check_resources():
        mem = psutil.virtual_memory().percent
        cpu = psutil.cpu_percent(interval=1)
        global restored_cpu
        global last_restored_cpu
        restored_cpu = last_restored_cpu*0.9 + cpu*0.1
        last_restored_cpu = restored_cpu
        ## debug
        # print("CPU use: {}%".format(cpu))
        # print("MEE use: {}%".format(mem))
        # print("restored_cpu:{}%".format(restored_cpu))
        message_cpu.set("CPU Use: {}%".format(cpu))
        message_mem.set("MEM Use: {}%".format(mem))
        if restored_cpu < 2:
            os.system('start /b shutdown -s -t 0')

        root.after(1000, check_resources)

    root.after(1000,check_resources)

    root.mainloop()
