import os
from lxml import etree
from collections import defaultdict


def extract_field_names(xml_file):
    field_names = set()
    context = etree.iterparse(xml_file, events=("end",), tag="row", huge_tree=True)

    for event, el in context:
        field_names.update(el.attrib.keys())
        el.clear()
        while el.getprevious() is not None:
            del el.getparent()[0]
    return field_names


def collect_fields_by_filename(source_dirs):
    combined_fields = defaultdict(set)

    for label, folder in source_dirs.items():
        for file in os.listdir(folder):
            if file.endswith(".xml"):
                file_path = os.path.join(folder, file)
                try:
                    fields = extract_field_names(file_path)
                    combined_fields[file].update(fields)
                except Exception as e:
                    print(f"Ошибка обработки файла {file}: {str(e)}")
                    continue

    return combined_fields


def print_fields_summary(fields_by_file):
    print("\nОбъединённый список полей по XML-файлам:\n")
    for filename in sorted(fields_by_file):
        fields = fields_by_file[filename]
        print(f" {filename} ({len(fields)} полей):")
        for field in sorted(fields):
            print(f"   - {field}")
        print()


if __name__ == "__main__":
    SOURCES = {
        "meta": "meta",
        "main": "main",
    }

    fields_by_file = collect_fields_by_filename(SOURCES)
    print_fields_summary(fields_by_file)
