import re
from pprint import pprint
import pathlib
import json

all_projects = dict()
current_file_location = str(pathlib.Path(__file__).parent.absolute()) + '\\'


def appender(f, project):
    chip_step = re.sub(r'.*:', '', next(f).strip())
    if all_projects['Project'][project]:
        all_projects['Project'][project]['Chip_step'][chip_step] = {}
    else:
        all_projects['Project'][project] = {'Chip_step': {chip_step: {}}}

    columns = next(f).split(',')
    while True:
        try:
            data = next(f).strip().split(',')
            base = all_projects['Project'][project]['Chip_step'][chip_step]
            for ind, el in enumerate(columns):
                if base.keys():
                    if not data[ind].strip() in base[list(base.keys())[0]]:
                        base[el.strip()][data[ind].strip()] = {}
                else:
                    if ind < len(data) - 1:
                        base[el.strip()] = {data[ind]: {}}
                    else:
                        base[el.strip()] = data[ind]
                        continue
                base = base[el.strip()][data[ind]]
        except StopIteration:
            break


all_projects['Project'] = {}

for path in [current_file_location + 'one.csv', current_file_location + 'two.csv']:
    with open(path) as f:
        project = re.sub(r'.*:', '', next(f).strip())
        if project not in all_projects['Project']:
            all_projects['Project'][project] = {}
        appender(f, project)

pprint(all_projects)
json_data = json.dumps(all_projects)

with open(current_file_location + 'js_result.json', 'w') as f:
    f.write(json_data)
