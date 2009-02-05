# sets the upload root, relative to the RAILS_ROOT
IMAGES_STORAGE_PATH = "#{RAILS_ROOT}/public/uploads"


# папка upload, в которую пользователи загружают фильмы
FILMS_UPLOAD_PATH = "/home/igorrr/upload"

# папка, где будут храниться фиьмы. Скрипт автоматически создаст тут подпапки, по жанрам и будет в них складывать фильмы
FILMS_STORAGE_PATH = "/media/disk/storage"

# Полный путь (включая адрес компьютера), по котором хранятся проверенные модером файлы
FILMS_STORAGE_URL = "ftp://192.168.31.35/kino"

# Полный путь (включая адрес компьютера), по котором хранятся только что загруженные файлы (если к ним есть доступ, если нет - оставьте как есть)
FILMS_UPLOAD_URL = "#"

