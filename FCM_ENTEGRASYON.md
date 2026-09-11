# Bambuk Restaurant — FCM Push Bildirim Entegrasyonu

Bu doküman, admin panelden push bildirim gönderecek backend geliştiricisi içindir.
Mobil uygulamanın (Flutter) bildirimi **nasıl beklediğini**, **hangi alanları okuduğunu** ve
**kullanıcıyı nereye yönlendirdiğini** anlatır.

---

## 1. Özet — En kritik 3 madde

| # | Konu | Durum |
|---|------|-------|
| 1 | **Hedefleme** | Uygulama FCM device token'ını backend'e **göndermiyor**. Şu an tek gönderim yolu `ttf_channel` topic'idir → bildirim **tüm kullanıcılara** gider. Kişiye özel bildirim istenirse §7'ye bakın. |
| 2 | **Mesaj tipi** | Mesaj mutlaka `notification` bloğu **ve** `data` bloğu birlikte içermelidir. Sadece `data` gönderilirse uygulama kapalıyken kullanıcı hiçbir şey görmez. |
| 3 | **URL alanı** | Link `data` içinde gönderilir: `android_link`, `ios_link` veya `url`. `notification` içine konulmaz. |

---

## 2. Gönderim hedefi (topic)

Uygulama her açılışta şu topic'e abone olur:

```
ttf_channel
```

Kaynak: `lib/main.dart` → `FirebaseMessaging.instance.subscribeToTopic('ttf_channel')`

Yani admin panelden gönderilen bildirim `/topics/ttf_channel` hedefine gönderilmelidir.

---

## 3. Mesaj formatı

### 3.1 Uygulamanın okuduğu alanlar

| Alan | Yer | Zorunlu | Açıklama |
|------|-----|---------|----------|
| `title` | `notification` | ✅ Evet | Bildirim başlığı |
| `body` | `notification` | ✅ Evet | Bildirim metni |
| `android_link` | `data` | ➖ Opsiyonel | Android'de açılacak URL |
| `ios_link` | `data` | ➖ Opsiyonel | iOS'ta açılacak URL |
| `url` | `data` | ➖ Opsiyonel | Platform farkı yoksa tek URL (yedek alan) |

> `data` içindeki **tüm değerler string olmalıdır.** FCM `data` bloğu sadece string kabul eder.
> `"id": 12` değil, `"id": "12"` şeklinde gönderin.

### 3.2 URL seçim önceliği

Uygulama linki şu sırayla arar, ilk bulduğunu kullanır:

```
1. Android cihaz  → data.android_link
   iOS cihaz      → data.ios_link
2. data.url
3. notification.body  (eğer "http://" veya "https://" ile başlıyorsa)
```

Kaynak: `lib/values/firebase_messaging_service.dart`, `lib/main.dart` → `_handleMessage()`

> ⚠️ 3. adım yüzünden: `body` alanına düz URL yazarsanız, bildirim metni olarak URL görünür
> **ve** tıklanınca o URL açılır. Bu istenen davranış değilse `body`'ye normal metin yazıp
> linki `data`'ya koyun.

---

## 4. Kullanıcı bildirime tıklayınca ne olur?

Üç durumda da davranış **aynıdır**:

| Uygulama durumu | Link VAR ise | Link YOK ise |
|-----------------|--------------|--------------|
| Açık (foreground) | WebView sayfası açılır, URL yüklenir | **Profil → Bildirimler** sayfası açılır |
| Arka planda | WebView sayfası açılır, URL yüklenir | **Profil → Bildirimler** sayfası açılır |
| Tamamen kapalı | WebView sayfası açılır, URL yüklenir | **Profil → Bildirimler** sayfası açılır |

Kaynak: `lib/values/local_notifications_service.dart` (foreground), `lib/main.dart` → `_handleMessage()` (diğer ikisi)

Ayrıca gelen her bildirim cihazda yerel olarak kaydedilir ve Bildirimler sayfasında görünür (§6).

---

## 5. Örnek gönderimler

### 5.1 FCM HTTP v1 API (önerilen)

`POST https://fcm.googleapis.com/v1/projects/<PROJECT_ID>/messages:send`
Header: `Authorization: Bearer <OAuth2 access token>`

**Linkli bildirim:**

```json
{
  "message": {
    "topic": "ttf_channel",
    "notification": {
      "title": "Täze aksiýa!",
      "body": "Şu hepde ähli pizzalarda 20% arzanladyş"
    },
    "data": {
      "android_link": "https://bambukresto.com.tm/aksiya",
      "ios_link": "https://bambukresto.com.tm/aksiya",
      "url": "https://bambukresto.com.tm/aksiya"
    },
    "android": {
      "priority": "high",
      "notification": {
        "channel_id": "bambuk_channel_id"
      }
    },
    "apns": {
      "headers": { "apns-priority": "10" },
      "payload": { "aps": { "sound": "default", "badge": 1 } }
    }
  }
}
```

**Linksiz bildirim** (tıklanınca Bildirimler sayfası açılır) — `data` bloğunu boş bırakın veya hiç göndermeyin:

```json
{
  "message": {
    "topic": "ttf_channel",
    "notification": {
      "title": "Sargydyňyz kabul edildi",
      "body": "Sargydyňyz taýýarlanýar, 30 minutda eltiler"
    },
    "android": { "priority": "high" },
    "apns": {
      "headers": { "apns-priority": "10" },
      "payload": { "aps": { "sound": "default" } }
    }
  }
}
```

### 5.2 Legacy HTTP API (kullanılıyorsa)

`POST https://fcm.googleapis.com/fcm/send`
Header: `Authorization: key=<SERVER_KEY>`

```json
{
  "to": "/topics/ttf_channel",
  "priority": "high",
  "notification": {
    "title": "Täze aksiýa!",
    "body": "Şu hepde ähli pizzalarda 20% arzanladyş",
    "sound": "default"
  },
  "data": {
    "android_link": "https://bambukresto.com.tm/aksiya",
    "ios_link": "https://bambukresto.com.tm/aksiya",
    "url": "https://bambukresto.com.tm/aksiya"
  }
}
```

> Legacy API Google tarafından kullanımdan kaldırılmıştır. Yeni entegrasyon yapıyorsanız **HTTP v1** kullanın.

### 5.3 Test için curl (legacy)

```bash
curl -X POST https://fcm.googleapis.com/fcm/send -H "Authorization: key=SERVER_KEY" -H "Content-Type: application/json" -d '{"to":"/topics/ttf_channel","priority":"high","notification":{"title":"Test","body":"Test bildirimi"},"data":{"url":"https://bambukresto.com.tm"}}'
```

---

## 6. Bildirimler sayfası — backend endpoint'i

Uygulamadaki **Profil → Bildirimler** sayfası iki kaynağı birleştirip gösterir:

1. **Backend geçmişi** (kalıcı) — aşağıdaki endpoint
2. **Cihazdaki yerel kayıt** — uygulama açıkken/arka plandayken gelen bildirimler cihaza kaydedilir

### 6.1 Uygulamanın çağırdığı endpoint

```
GET https://bambukresto.com.tm:4443/api/v1/push-notifications
Authorization: Bearer <kullanıcı token'ı>
```

Kaynak: `lib/user_reviews_page/notifications_page.dart`

### 6.2 Beklenen cevap formatı

```json
{
  "data": [
    {
      "id": 12,
      "title": "Täze aksiýa!",
      "body": "Şu hepde ähli pizzalarda 20% arzanladyş",
      "created_at": "2026-09-11T14:32:00.000Z"
    },
    {
      "id": 11,
      "title": "Sargydyňyz kabul edildi",
      "body": "Sargydyňyz taýýarlanýar",
      "created_at": "2026-09-10T09:15:00.000Z"
    }
  ]
}
```

| Alan | Tip | Not |
|------|-----|-----|
| `id` | int | Yoksa `0` kabul edilir |
| `title` | string | Yoksa `"No Title"` gösterilir |
| `body` | string | Yoksa `"No Body"` gösterilir |
| `created_at` | string (ISO 8601) | Sıralama bu alana göre yapılır (yeniden eskiye). Parse edilemezse en sona düşer. |

> ⚠️ `200` dışında bir status dönerse sayfa hata ekranı gösterir. Bildirim yoksa
> `{"data": []}` dönün, hata dönmeyin.

> ⚠️ **Tekrar (duplicate) kuralı:** uygulama `title + "-" + body` kombinasyonunu anahtar
> olarak kullanır. Aynı başlık ve metne sahip iki kayıt **tek** satır olarak gösterilir.
> Bu yüzden admin panelden gönderilen her bildirimi bu endpoint'e de kaydedin — kullanıcı
> uygulamayı silse/yeniden kursa bile geçmişi görebilsin.

> ℹ️ Bu endpoint şu an `url` alanı döndürmüyor. Bildirimler sayfasındaki bir kart,
> **sadece `body` alanı `http` ile başlıyorsa** tıklanınca WebView'de açılır.
> Geçmiş listesinden de link açılabilmesi isteniyorsa mobil tarafta küçük bir ekleme
> gerekir (§8).

---

## 7. Admin panel için önerilen form

| Form alanı | Zorunlu | Gittiği yer | Not |
|------------|---------|-------------|-----|
| Başlık | ✅ | `notification.title` | ~40 karakter önerilir, uzunu kesilir |
| Metin | ✅ | `notification.body` | ~120 karakter önerilir |
| Link (URL) | ➖ | `data.android_link` + `data.ios_link` + `data.url` | Boşsa 3 alanı da hiç göndermeyin |
| Android linki farklı mı? | ➖ | `data.android_link` | Ayrı link gerekiyorsa (deep link vb.) |
| iOS linki farklı mı? | ➖ | `data.ios_link` | Ayrı link gerekiyorsa |

**Validasyon önerileri:**
- Link alanı doluysa `http://` veya `https://` ile başladığını doğrulayın. Uygulama bu iki
  önek dışındaki değerleri link saymaz ve kullanıcıyı Bildirimler sayfasına yönlendirir.
- `data` içindeki değerleri her zaman string olarak serialize edin.
- Boş string (`""`) göndermek ile alanı hiç göndermemek uygulamada aynı sonucu verir (link yok sayılır).

**Gönderim sonrası:** aynı kaydı `push_notifications` tablosuna da yazın ki §6'daki endpoint
geçmişi dönebilsin.

---

## 8. Bilinen sınırlar / ileride yapılabilecekler

Bunlar **şu anki durumun** tespitidir, acil hata değildir:

1. **Kişiye özel bildirim yok.** Uygulama FCM device token'ını backend'e göndermiyor.
   Kişiye/siparişe özel bildirim istenirse: mobil tarafta token'ı kaydeden bir endpoint
   çağrısı (`POST /api/v1/device-tokens` gibi) eklenmeli, backend de token bazlı gönderim
   yapmalı. Backend tarafında bu endpoint hazırlanabilir, mobil tarafta ekleme gerekir.
2. **Android bildirim kanalı.** `AndroidManifest.xml` içinde
   `com.google.firebase.messaging.default_notification_channel_id` meta-data'sı tanımlı değil.
   Uygulama kapalıyken gelen bildirimler Android'in varsayılan kanalını kullanır. Mesajda
   `android.notification.channel_id = "bambuk_channel_id"` göndermek en doğrusu;
   kalıcı çözüm için manifest'e meta-data eklenebilir (mobil taraf işi).
3. **Geçmiş listesinden link açma.** §6'da anlatıldığı gibi, geçmiş kayıtlarında ayrı bir
   `url` alanı okunmuyor. Backend bu endpoint'e `url` alanı eklerse, mobil tarafta karşılığını
   okumak küçük bir değişiklik olur.
4. **Sadece-data mesajları.** `notification` bloğu olmadan gönderilen mesaj, uygulama kapalıyken
   kullanıcıya hiçbir şey göstermez (sadece arka planda kaydedilir). Bu yüzden her zaman
   `notification` bloğu gönderin.

---

## 9. İlgili dosyalar (mobil taraf)

| Dosya | Görevi |
|-------|--------|
| `lib/main.dart` | Arka plan/kapalı durumda gelen mesajın işlenmesi ve yönlendirme |
| `lib/values/firebase_messaging_service.dart` | İzin isteme, token, foreground mesaj dinleme, URL çıkarma |
| `lib/values/local_notifications_service.dart` | Yerel bildirim gösterme ve **tıklama yönlendirmesi** |
| `lib/user_reviews_page/notifications_page.dart` | Bildirimler sayfası, backend + yerel kayıt birleştirme |
