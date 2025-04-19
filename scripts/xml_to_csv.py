import csv
import os
from lxml import etree

FIELD_MAP = {
    'Users': [
        'Id', 'Reputation', 'CreationDate', 'DisplayName',
        'LastAccessDate', 'WebsiteUrl', 'Location', 'AboutMe',
        'Views', 'UpVotes', 'DownVotes', 'AccountId'
    ],
    'Posts': [
        'Id', 'PostTypeId', 'AcceptedAnswerId', 'ParentId', 'CreationDate',
        'Score', 'ViewCount', 'Body', 'OwnerUserId',
        'OwnerDisplayName', 'LastEditorUserId', 'LastEditorDisplayName',
        'LastEditDate', 'LastActivityDate', 'Title', 'Tags',
        'AnswerCount', 'CommentCount', 'FavoriteCount',
        'ClosedDate', 'CommunityOwnedDate', 'ContentLicense'
    ],
    'Comments': [
        'Id', 'PostId', 'Score', 'Text', 'CreationDate', 'UserDisplayName', 'UserId'
    ],
    'Badges': [
        'Id', 'UserId', 'Name', 'Date', 'Class', 'TagBased'
    ],
    'PostLinks': [
        'Id', 'CreationDate', 'PostId', 'RelatedPostId', 'LinkTypeId'
    ],
    'PostHistory': [
        'Id', 'PostHistoryTypeId', 'PostId', 'RevisionGUID', 'CreationDate',
        'UserId', 'UserDisplayName', 'Comment', 'Text', 'ContentLicense'
    ],
    'Votes': [
        'Id', 'PostId', 'VoteTypeId', 'UserId', 'CreationDate', 'BountyAmount'
    ],
    'Tags': [
        'Id', 'TagName', 'Count', 'ExcerptPostId', 'WikiPostId', 'IsModeratorOnly', 'IsRequired'
]
}

SEARCH_DIRS = ['meta', 'main']

# Отдельный список — чтобы записать заголовок только один раз
written_headers = set()

# Конвертация одного XML-файла
def convert(input_file, table_name):
    fields = FIELD_MAP.get(table_name)
    if not fields:
        print(f"❌ Пропущено: {table_name} (неизвестные поля)")
        return

    output_file = os.path.join("output", f"{table_name.lower()}.csv")
    os.makedirs("output", exist_ok=True)

    write_header = table_name not in written_headers

    with open(output_file, "w", newline="", encoding="utf-8", errors="ignore") as csvfile:
        writer = csv.DictWriter(
            csvfile,
            fieldnames=fields,
            quoting=csv.QUOTE_MINIMAL,
            lineterminator="\n"
        )
        writer.writeheader()

        for _, elem in etree.iterparse(input_file, events=("end",), tag="row"):
            row = {}
            for key in fields:
                value = elem.attrib.get(key)
                if value is not None:
                    # Удаляем символы перевода строки (только для текста, чтобы избежать \n в CSV)
                    value = value.replace('\r', ' ').replace('\n', ' ')

                row[key] = value
            writer.writerow(row)
            elem.clear()

    print(f"Добавлено из {os.path.basename(input_file)} → {output_file}")

# Поиск и обработка всех XML-файлов
def find_and_convert_all():
    for directory in SEARCH_DIRS:
        for root, _, files in os.walk(directory):
            print(f"{directory}:")
            for file in files:
                table = os.path.splitext(file)[0]
                path = os.path.join(root, file)
                convert(path, table)


if __name__ == "__main__":
    find_and_convert_all()
