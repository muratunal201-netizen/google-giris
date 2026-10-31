# Google ile Giriş — statik sayfa + Supabase

Şifre alınmaz. Kullanıcı Google ile tek tıkla girer; doğrulanmış e-posta + hesap
adı gelir; her giriş `login_events` tablosuna loglanır. Oturum varsa sayfa link'e
basınca anında açılır.

## Kurulum (yaklaşık 10 dk, hepsi sizin hesaplarınızda)

### 1. Supabase projesi
1. https://supabase.com → yeni proje aç.
2. Settings → API → **Project URL** ve **anon public key** değerlerini kopyala.
3. `index.html` içinde `BURAYA_SUPABASE_URL` ve `BURAYA_ANON_KEY` yerlerine yapıştır.

### 2. Giriş kayıt tablosu
- Supabase → SQL Editor → `schema.sql` içeriğini yapıştır → **Run**.

### 3. Google sağlayıcısını aç
1. Supabase → Authentication → Providers → **Google** → Enable.
2. Google Cloud Console → APIs & Services → Credentials → **OAuth client ID** (Web).
   - Authorized redirect URI olarak Supabase'in verdiği
     `https://<proje>.supabase.co/auth/v1/callback` adresini ekle.
   - Client ID + Client Secret'i Supabase Google ekranına yapıştır.
3. Authentication → URL Configuration → **Site URL** ve **Redirect URLs**
   kısmına sayfanızın yayınlanacağı adresi ekleyin (test için `http://localhost:5173`).

### 4. Haber görseli
- `google-giris` içinde `images/` klasörü aç, görseli `images/haber.jpg` olarak koy.
- `index.html` içindeki haber başlığı/metnini kendi haberinle değiştir (`<article class="news">` bölümü).

### 5. Çalıştır
- Yerel test:  `npx serve .`  (veya herhangi bir statik sunucu — `file://` ile OAuth çalışmaz)

## GitHub Pages ile ücretsiz yayın
1. GitHub'da yeni bir repo aç, bu klasördeki dosyaları yükle (sürükle-bırak da olur).
2. Repo → **Settings → Pages** → Source: `Deploy from a branch` → Branch: `main` / `root` → Save.
3. 1-2 dk sonra adresin hazır olur:  `https://<kullanıcı-adı>.github.io/<repo>/`
4. **Önemli — bu adresi Supabase'e tanıt:**
   Supabase → Authentication → URL Configuration →
   - **Site URL**: `https://<kullanıcı-adı>.github.io/<repo>/`
   - **Redirect URLs** listesine de aynı adresi ekle.
   (Google tarafında değişiklik gerekmez; Google yalnızca Supabase callback'ini tanır.)

> Not: GitHub Pages yalnızca statik dosya sunar — bu proje için yeterli.
> anon key'in sayfada görünmesi normaldir ve güvenlidir; gerçek koruma
> Supabase tarafındaki RLS kurallarıyla sağlanır.

## Giriş kayıtlarını görmek
- Supabase → Table Editor → `login_events`, ya da SQL Editor:
  `select * from login_events order by created_at desc;`
- Kaydedilenler: e-posta, ad, **IP**, cihaz (user agent), tarih.

## IP / KVKK notu
- IP loglama kendi sitenizin güvenliği için yasaldır; IP kişisel veri sayıldığından:
  - Giriş ekranındaki bilgilendirme notu zaten eklendi.
  - Eski kayıtları periyodik silin (örnek, 12 aydan eski olanları):
    `delete from login_events where created_at < now() - interval '12 months';`
  - Kayıtlara yalnızca siz erişin (RLS bunu sağlıyor).
- Bu genel bilgidir, resmi hukuki danışmanlık değildir.
