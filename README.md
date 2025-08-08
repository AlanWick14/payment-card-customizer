# Flutter Card Customization App

Bu loyiha Flutter asosida yozilgan bo‘lib, foydalanuvchiga to‘lov kartasining dizaynini sozlash imkonini beradi.

## 🚀 Funksiyalar

- 📷 **Fon rasmini tanlash:**
  - Qurilmadagi galereyadan yoki kamera orqali suratga olish
  - Oldindan belgilangan rasmlar ro‘yxatidan tanlash
  - Tanlangan rasmni **pinch zoom** va **drag** orqali joylashtirish
- 🎨 **Rang yoki gradient tanlash** (ColorPicker orqali)
- 🌀 **Tuman (blur)** effekt darajasini sozlash
- 🔄 Faqat **bitta** rejim: rasm **yoki** rang/gradient
- 💾 Barcha sozlamalar multipart shaklida, **siqilgan rasm bilan** (max o‘lchamga kamaytirilgan) serverga yuboriladi
- 🎯 Birinchi ishga tushganda tasodifiy oldindan belgilangan rasm tanlanadi

## 🧱 Texnologiyalar

- **Flutter** (null safety)
- **Provider** – holatni boshqarish
- **http** – multipart so‘rov yuborish
- **flutter_colorpicker** – rang tanlash uchun yagona ruxsat etilgan 3rd-party kutubxona
- **Dart `ui` API** – rasmni siqish va qayta o‘lchamlash (3rd-party kutubxonasiz)

## 📂 Loyiha tuzilmasi

```
lib/
├── main.dart                        # Asosiy kirish nuqtasi
│
├── models/
│   └── card_config.dart             # Kartaning konfiguratsiyasi modeli
│
├── pages/
│   └── card_customization_page.dart # Kartani sozlash sahifasi
│
├── provider/
│   └── customization_provider.dart  # Provider orqali holat boshqaruvi
│
├── services/
│   ├── image_service.dart           # Rasmni saqlash va siqish
│   └── upload_service.dart          # Multipart orqali ma’lumot yuborish
│
├── widgets/
│   ├── custom_card.dart             # Dizaynni jonli ko‘rsatadigan kartochka
│   ├── blur_slider.dart             # Blur darajasini tanlash slideri
│   ├── image_picker_modal.dart      # Rasm tanlash oynasi
│   ├── fancy_color_picker_sheet.dart    # Oddiy rang tanlash oynasi
│   ├── fancy_gradient_picker_sheet.dart # Gradient tanlash oynasi
│   ├── components/
│   │   ├── action_row_button.dart
│   │   ├── mini_color_box.dart
│   │   └── mini_gradient_box.dart
│   └── picker_parts.dart            # Color/gradient picker bo‘laklari
│
└── assets/
    └── images/                      # Oldindan belgilangan rasmlar, logo va chip
```
