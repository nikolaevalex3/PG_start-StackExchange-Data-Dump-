import csv
import os


def check_duplicate(current_id: int, existing_ids: set) -> bool:
    """
    Проверяет, есть ли current_id в existing_ids (дубликат в PK),
    и пропускает строку, если она с дубликатом
    """
    if current_id in existing_ids:
        return True
    existing_ids.add(current_id)
    return False


def clean_related_files(post_ids: set, user_ids: set):
    """
    Очищает файлы posthistory, comments, votes
    """
    files_to_clean = [
        ("posthistory.csv", "posthistory_cleaned.csv"),
        ("comments.csv", "comments_cleaned.csv"),
        ("votes.csv", "votes_cleaned.csv")
    ]

    for input_name, output_name in files_to_clean:
        input_file = f"output/{input_name}"
        output_file = f"output/{output_name}"
        ids = set()

        with open(input_file, newline='', encoding='utf-8') as f_in, \
                open(output_file, "w", newline='', encoding='utf-8') as f_out:

            reader = csv.DictReader(f_in)
            writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
            writer.writeheader()

            for row in reader:
                if row["PostId"] in post_ids:
                    if not check_duplicate(row['Id'], ids):
                        user_id = row.get('UserId')
                        if user_id and user_id not in user_ids:
                            row['UserId'] = ''
                        writer.writerow(row)

        # Удаление исходного файла после обработки
        os.remove(input_file)
        print(f"Готово: {output_file}, исходный файл удален")


# Исходные файлы
posts_file = "output/posts.csv"
users_file = "output/users.csv"

# Все существующие ID постов
post_ids = set()
with open(posts_file, newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        post_ids.add(row['Id'])

# Все существующие ID пользователей
user_ids = set()
with open(users_file, newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    for row in reader:
        user_ids.add(row['Id'])

# Вызов функции очистки файлов posthistory.csv, comments.csv, votes.csv
clean_related_files(post_ids, user_ids)

# Обработка файла users.csv
input_file = "output/users.csv"
output_file = "output/users_cleaned.csv"
ids = set()

# Фильтрация записей
with open(input_file, newline='', encoding='utf-8') as f_in, \
        open(output_file, "w", newline='', encoding='utf-8') as f_out:
    reader = csv.DictReader(f_in)
    writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
    writer.writeheader()

    for row in reader:
        # Проверка на дубликаты в PK
        if not check_duplicate(row['Id'], ids):
            writer.writerow(row)

# Удаление исходного файла после обработки
os.remove(input_file)
print(f"Готово: {output_file}, исходный файл удален")

# Обработка файла posts.csv
input_file = "output/posts.csv"
output_file = "output/posts_cleaned.csv"
ids = set()

with open(input_file, newline='', encoding='utf-8') as f_in, \
        open(output_file, "w", newline='', encoding='utf-8') as f_out:
    reader = csv.DictReader(f_in)
    writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
    writer.writeheader()

    for row in reader:
        if not check_duplicate(row['Id'], ids):

            # Обработка AcceptedAnswerId
            aid = row.get('AcceptedAnswerId')
            if aid and aid not in post_ids:
                row['AcceptedAnswerId'] = ''

            # Обработка ParentId
            aid = row.get('ParentId')
            if aid and aid not in post_ids:
                row['ParentId'] = ''

            # Обработка OwnerUserId
            owner_id = row.get('OwnerUserId')
            if owner_id and owner_id not in user_ids:
                row['OwnerUserId'] = ''

            # Обработка LastEditorUserId
            owner_id = row.get('LastEditorUserId')
            if owner_id and owner_id not in user_ids:
                row['LastEditorUserId'] = ''

            writer.writerow(row)

# Удаление исходного файла после обработки
os.remove(input_file)
print(f"Готово: {output_file}, исходный файл удален")

# Обработка файла postlinks.csv
input_file = "output/postlinks.csv"
output_file = "output/postlinks_cleaned.csv"
ids = set()

# Фильтрация записей
with open(input_file, newline='', encoding='utf-8') as f_in, \
        open(output_file, "w", newline='', encoding='utf-8') as f_out:
    reader = csv.DictReader(f_in)
    writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
    writer.writeheader()

    for row in reader:
        # Проверка на дубликаты в PK
        if not check_duplicate(row['Id'], ids):
            if row["PostId"] in post_ids and row["RelatedPostId"] in post_ids:
                writer.writerow(row)

os.remove(input_file)
print(f"Готово: {output_file}, исходный файл удален")

# Обработка файла tags.csv
input_file = "output/tags.csv"
output_file = "output/tags_cleaned.csv"
ids = set()

with open(input_file, newline='', encoding='utf-8') as f_in, \
        open(output_file, "w", newline='', encoding='utf-8') as f_out:
    reader = csv.DictReader(f_in)
    writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
    writer.writeheader()

    for row in reader:
        if not check_duplicate(row['Id'], ids):
            # Обработка AcceptedAnswerId
            aid = row.get('ExcerptPostId')
            if aid and aid not in post_ids:
                row['ExcerptPostId'] = ''

            # Обработка ParentId
            aid = row.get('WikiPostId')
            if aid and aid not in post_ids:
                row['WikiPostId'] = ''

            writer.writerow(row)

os.remove(input_file)
print(f"Готово: {output_file}, исходный файл удален")

# Обработка файла badges.csv
input_file = "output/badges.csv"
output_file = "output/badges_cleaned.csv"
ids = set()

with open(input_file, newline='', encoding='utf-8') as f_in, \
        open(output_file, "w", newline='', encoding='utf-8') as f_out:
    reader = csv.DictReader(f_in)
    writer = csv.DictWriter(f_out, fieldnames=reader.fieldnames)
    writer.writeheader()

    for row in reader:
        if not check_duplicate(row['Id'], ids):
            # Обработка AcceptedAnswerId
            aid = row.get('UserId')
            if aid and aid not in user_ids:
                row['ExcerptPostId'] = ''
            writer.writerow(row)

os.remove(input_file)
print(f"Готово: {output_file}, исходный файл удален")
