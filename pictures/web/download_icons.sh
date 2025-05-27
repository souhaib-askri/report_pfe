#!/bin/bash

# اسم ملف CSV
CSV_FILE="tech_tools.csv"

# اقرأ الملف سطر سطر مع تجاهل السطر الأول (header)
tail -n +2 "$CSV_FILE" | while IFS=, read -r category name url; do
  # إزالة علامات اقتباس محتملة والمساحات من الحقول
  category=$(echo $category | tr -d '"' | xargs)
  name=$(echo $name | tr -d '"' | xargs)
  url=$(echo $url | tr -d '"' | xargs)

  # أنشئ المجلد إذا لم يكن موجود
  mkdir -p "$category"

  # استخراج امتداد الملف من رابط الأيقونة
  extension="${url##*.}"
  # بعض الروابط تنتهي بـ svg؟ تأكد ان الامتداد معقول
  if [[ "$extension" != "png" && "$extension" != "svg" && "$extension" != "ico" && "$extension" != "jpg" && "$extension" != "jpeg" ]]; then
    # إذا الامتداد غير معروف، استخدم svg كافتراضي
    extension="svg"
  fi

  # اسم الملف داخل المجلد
  filename="${category}/${name// /_}.$extension"

  # تحميل الأيقونة فقط إذا الملف غير موجود لتفادي إعادة التنزيل
  if [ ! -f "$filename" ]; then
    echo "Downloading $name icon to $filename ..."
    curl -sSL "$url" -o "$filename"
  else
    echo "$filename already exists, skipping."
  fi
done
