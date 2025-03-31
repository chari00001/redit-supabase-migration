# Redit Supabase Veritabanı Migrasyonu

Bu repo, Redit uygulaması için Supabase veritabanı şemasını oluşturan migration scriptlerini içerir.

## Veritabanı Yapısı

Veritabanı aşağıdaki tabloları içerir:

- **Users**: Kullanıcı hesaplarını saklar
- **Posts**: Kullanıcı gönderilerini saklar
- **Comments**: Gönderilere yapılan yorumları saklar
- **Communities**: Topluluklarla ilgili bilgileri saklar
- **User_Communities**: Kullanıcı-topluluk ilişkilerini saklar
- **Likes**: Gönderi beğenilerini saklar
- **Messages**: Kullanıcılar arası mesajları saklar
- **Follows**: Kullanıcı takip ilişkilerini saklar
- **Notifications**: Bildirim verilerini saklar
- **Subtitles**: Alt başlık verilerini saklar
- **User_Subtitles**: Kullanıcı-alt başlık ilişkilerini saklar
- **LiveStreams**: Canlı yayın verilerini saklar
- **Roles**: Kullanıcı rollerini saklar

## Kurulum ve Kullanım

### Gereksinimler

- Node.js (v14+)
- Supabase hesabı ve projeniz
- Supabase Service Role API anahtarı

### Adımlar

1. Repo'yu klonlayın:
   ```
   git clone https://github.com/chari00001/redit-supabase-migration.git
   cd redit-supabase-migration
   ```

2. Bağımlılıkları yükleyin:
   ```
   npm install
   ```

3. `.env` dosyasını oluşturun:
   ```
   cp .env.example .env
   ```

4. `.env` dosyasını Supabase bilgilerinizle güncelleyin:
   ```
   SUPABASE_URL=https://qjezggefroennnhwffpr.supabase.co
   SUPABASE_SERVICE_KEY=your_service_role_key_here
   ```

5. Supabase SQL düzenleyicisinde şu stored procedure'ü oluşturun:
   ```sql
   CREATE OR REPLACE FUNCTION exec_sql(sql text) RETURNS void AS $$
   BEGIN
     EXECUTE sql;
   END;
   $$ LANGUAGE plpgsql SECURITY DEFINER;
   ```

6. Migrasyon scriptini çalıştırın:
   ```
   npm run migrate
   ```

### Notlar

- Migration script'i, veritabanı şemasını oluşturur ve temel güvenlik politikalarını ayarlar.
- Supabase'de Row Level Security (RLS) politikaları otomatik olarak etkinleştirilir.
- `.env` dosyasındaki servis anahtarını güvenli tutun ve hiçbir zaman commit etmeyin.

## Projeye Katkıda Bulunma

1. Bu repo'yu forklayın
2. Kendi özellik dalınızı oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Dalınıza push edin (`git push origin feature/amazing-feature`)
5. Pull Request oluşturun

## Lisans

MIT