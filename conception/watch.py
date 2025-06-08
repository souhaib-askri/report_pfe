import time
import subprocess
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class PUMLHandler(FileSystemEventHandler):
    def on_modified(self, event):
        self.process(event)

    def on_created(self, event):
        self.process(event)

    def process(self, event):
        if not event.is_directory and event.src_path.endswith(".puml"):
            puml_file = event.src_path
            print(f"📄 تم تعديل أو إضافة الملف: {puml_file}")
            try:
                # تنفيذ أمر plantuml
                subprocess.run(["plantuml", puml_file], check=True)
                print("✅ تم تحويل الملف إلى صورة بنجاح.")
            except subprocess.CalledProcessError as e:
                print(f"❌ حدث خطأ أثناء التحويل: {e}")

if __name__ == "__main__":
    path_to_watch = "./"  # ← غيّره إلى مسار مجلدك

    if not Path(path_to_watch).is_dir():
        print("❗ المسار غير صالح")
        exit(1)

    event_handler = PUMLHandler()
    observer = Observer()
    observer.schedule(event_handler, path=path_to_watch, recursive=True)
    observer.start()

    print(f"👀 مراقبة المجلد (بشكل عميق): {path_to_watch}")

    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()

    observer.join()
